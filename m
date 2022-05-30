Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599B5537EBF
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiE3N5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbiE3N4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:56:37 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44E295A0E;
        Mon, 30 May 2022 06:38:23 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id 129-20020a1c0287000000b003974edd7c56so5032821wmc.2;
        Mon, 30 May 2022 06:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KsAtagss1zN3OoHQ7StI415A2RqFxEh/FfqiDwV3lwg=;
        b=7lyU2De1X9ZXN/Hr9PSFbeqMSGGk5VUpXoWpUWNqicJOhkowYwVTgrFCAH69cxDxze
         X6Y+0xysgCcAF5PSY72jLW0SVLYtcK9vJExKiyU04x3hciYgUX8y5SWAvqAHG43g3g8L
         EeCsQ4N5qM0XDiG9C8y89pyoiuZ4EXx9rNac8wR5VB15Z2Ur6y1G50hIAWzcmHgOe+eH
         X8uiwOdyelie4EmmKRYtuTJGmUEVtea+8/4dT8bhP3mxP9bhuhv+JlHYqz4AmT9ndlXe
         +HY08mhXjnpRdKcKmjg/i2Gmw2OD14fn5VFallHzNFM1PNsrVOExcCxFdOPbKpIGSeOx
         Pc9A==
X-Gm-Message-State: AOAM530ftFmF2fgyGTR83L0/XkdCwFVmo6pxXxqWcivdRUeXKJ/vlHqR
        dVKk33ahROERZeGppNGMOMOmR/XNUiQ=
X-Google-Smtp-Source: ABdhPJyLAdckxSBuBL1xhlfS9GVoNCXS4Kx15kZbX2/pn3pGdm0f8N7kwpIgiWG6jbtRdSs4v7MPfw==
X-Received: by 2002:a7b:c1d8:0:b0:397:337a:b593 with SMTP id a24-20020a7bc1d8000000b00397337ab593mr18979837wmj.96.1653917902170;
        Mon, 30 May 2022 06:38:22 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id u2-20020adfdb82000000b002102e6b757csm5331680wri.90.2022.05.30.06.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 06:38:21 -0700 (PDT)
Date:   Mon, 30 May 2022 13:38:20 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH] xen/netback: fix incorrect usage of
 RING_HAS_UNCONSUMED_REQUESTS()
Message-ID: <20220530133820.5mbjaavusxdhv25c@liuwe-devbox-debian-v2>
References: <20220530113459.20124-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530113459.20124-1-jgross@suse.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 01:34:59PM +0200, Juergen Gross wrote:
> Commit 6fac592cca60 ("xen: update ring.h") missed to fix one use case
> of RING_HAS_UNCONSUMED_REQUESTS().
> 
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Fixes: 6fac592cca60 ("xen: update ring.h")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
