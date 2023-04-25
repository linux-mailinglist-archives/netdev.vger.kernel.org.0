Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CE96EE20D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbjDYMoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjDYMoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:44:20 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA693BB8D
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:44:18 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-325f728402cso65965ab.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682426658; x=1685018658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=te/AU6YD3Nrp06W+/L24htOInvAS1q7FQ+X/iKWkuds=;
        b=K1ZWUUchq0Erw5U3Nvwwr6Mo6pQI0pLwySLG1iZlTS2NlkiPcqJL6ZJGTahZwp2eQL
         /fH5bojhLzWVrV5CCJg0gCzeyrpiaOiezhLx5FwHPvf5uARnYifDwuR2i54acxR2k9hg
         nfpIzgS+HrrFFAdD6nCGFJQXjJp9C//n46xY6fUNcuh8TXGFbjHw+O1v9F8NGO1xdXtw
         rrqR50Cf3+cRIVwbCVQtuAKHYwlfdtvhwG7yHD8loc3QydQOS3HSokGELGvZ5RO2ijuq
         lvKUiasZ9Iei9+KGhP9vcZaopFFCpvWhg3RuFBfr12ca4l6sfB7Mq+seYpX2lm48sA+d
         eAmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682426658; x=1685018658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=te/AU6YD3Nrp06W+/L24htOInvAS1q7FQ+X/iKWkuds=;
        b=WRZpBQOzp3/vMnukm3ZUlcLhTiTShfTtO1gObef79YjE8POPD49hel7/YOqhTXXLV3
         t0Sr2WIREUpEhl9GkWIcRm7h01Gg7KlgK6SRdFSSfBbC5Jmhefb9xvk5mtxfLFHxxsQq
         hMRozu0RasxK+00beUy8AXpA6CghcmsG8AU9gsPT1y+7gurXTTJGCaMW6DpqaRJAgX+Y
         FYHXnl7pB/zcYDbxK12XtiDRPJkC2V4EN0qe720De7Iw+qhCh8xT4VPRPHviWVpbnrJm
         T0F+PTJKsInJajYqJUOV9zybvfgZ3uO+6Tv67qASVyMISDz+HAMdrxcR/3yoQqlagt9T
         E40w==
X-Gm-Message-State: AC+VfDyxFCMrRFRXnwGi1D7skj4e2o9PqMOM1DfAX7Lm3HJ+sGBrz9O5
        QTdS54Gi8p0xA4pHf08t5T7XE28km4jdz2H/qRHcTw==
X-Google-Smtp-Source: ACHHUZ74AQK+Hh0UHK0Buv7tEFBp2Kr/Sz+rPOmb/ycOMlzaR8VN8UEyIksEFlfuHPAoisNNupP/MT4jPxfZHdEgMuk=
X-Received: by 2002:a05:6e02:1aaf:b0:313:93c8:e71f with SMTP id
 l15-20020a056e021aaf00b0031393c8e71fmr174663ilv.19.1682426657965; Tue, 25 Apr
 2023 05:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230224-track_gt-v8-0-4b6517e61be6@intel.com> <20230224-track_gt-v8-3-4b6517e61be6@intel.com>
In-Reply-To: <20230224-track_gt-v8-3-4b6517e61be6@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Apr 2023 14:44:06 +0200
Message-ID: <CANn89iLE5fVEom+VgcOtc4DdceYDNj0ftfkd4NjjmTi1LpaDzQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/7] lib/ref_tracker: add printing to memory buffer
To:     Andrzej Hajda <andrzej.hajda@intel.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andi Shyti <andi.shyti@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 12:06=E2=80=AFAM Andrzej Hajda <andrzej.hajda@intel=
.com> wrote:
>
> Similar to stack_(depot|trace)_snprint the patch
> adds helper to printing stats to memory buffer.
> It will be helpful in case of debugfs.
>
> Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
