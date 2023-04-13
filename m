Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C076E0952
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDMIv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDMIv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:51:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2E883C1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:51:55 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n203so2767469ybg.6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681375915; x=1683967915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmQVzBedG9oryNVNnTmY98xDvO4146v3UKMId61ZBT0=;
        b=hpCpQtqziG96sdwykuolRq/fQ/t6xqhP044LynIWYUHBRZUdeIaItVai/bS97jqTdp
         kjUKt5yiSx5AWHwf7wjNDyQ1NfVKPlhQty7iKqdPn3EAMSHz0xDjPrAqJjstBsmfEMa5
         AawG4nEB0Y1mEgrxIIgy5dhn03qggkxySSyJDTHUz3jAeF0yD95usW9Z+q/cscath6A8
         SbFpIJqFhQ4do1RGlV9YKwO6xgiqxggC8kH2goMRoaMrjIRVM11HmGYVGM83VzyD7qyG
         qnxhL7WcPZXNUWuB1hJ3YLgXg2d9C9F/WgrEf8uFzigY2XoakY4XwjC16tIUCFgV/jev
         jZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681375915; x=1683967915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmQVzBedG9oryNVNnTmY98xDvO4146v3UKMId61ZBT0=;
        b=RYa7t3jLiwvo4oMLNN5m/thE4OakmO+PDd7QzCJvwkNw1JpMTRfzHim13emICZQTV/
         Z1UDxYLBuY2OUo0L/Msm9+H1KNmC8MZBIKXBQWrYiooRGoGiyvewxqS3ZXTUZDT9v3Ad
         qk+ZC9xKu4q3mN0lHRxOoh4LmVQoCsHA5vy02MXiP/HR9/s9zIHN01Ivulr9qkAy0UoG
         sfsylBzc6w1sr7hZB2S2WsOTVTtwx+V+6uiUSEdPTAmLMkICeewycVhayMW6/q48urCs
         KnK+2QuNHTJ0r7exuj+nBLNkxnUUVRpBO1ixgRkklb7YYDk7vcpFPqF74Wp/grQdOkIJ
         YrWg==
X-Gm-Message-State: AAQBX9fJN8dPaQL8zvqnr/xA4mO+/RD268YeInoupWL/3U7GyemBW4/n
        ghGZvU2WGwIsIdNExzhWSnPg8EAvhyYTwgNlRvwwtw==
X-Google-Smtp-Source: AKy350bK/E9k9nCepQZcV45AWNvKvZtfUhkZXWYXu5lY4XrY2sHFTLBGrxxpizmVofRTIuiHD9V1ZSqwsfsX8u9jXb4=
X-Received: by 2002:a25:cfce:0:b0:b75:8ac3:d5da with SMTP id
 f197-20020a25cfce000000b00b758ac3d5damr782892ybg.4.1681375914883; Thu, 13 Apr
 2023 01:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230413042605.895677-1-kuba@kernel.org> <20230413042605.895677-2-kuba@kernel.org>
 <4447f0d2-dd78-573a-6d89-aa1e478ea46b@huawei.com>
In-Reply-To: <4447f0d2-dd78-573a-6d89-aa1e478ea46b@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 13 Apr 2023 10:51:43 +0200
Message-ID: <CANn89iJkg=B0D23q_evwqjRVvm0kcNA=xvSRHVxjgeR00HgEjA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: skb: plumb napi state thru skb
 freeing paths
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, alexander.duyck@gmail.com,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 9:49=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
>
> Maybe I missed something obvious about netpoll here.
> Does that mean the "normal NAPI context" and "not normal NAPI context"
> will call napi->poll() concurrently with different budget? Doesn't
> that mean two different contexts may do the tx completion concurrently?

Please take a look at netpoll code:
netpoll_poll_lock, poll_napi() and poll_one_napi()

> Does it break the single-producer single-consumer assumption of tx queue?

We do not think so.
