Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B75C5BAFD2
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiIPPEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiIPPEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 11:04:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A086D90196
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:04:03 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j12so21486560pfi.11
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 08:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8AWsuZeHHO0fTr7SMH5yzyE+p153cQFgu5EbTNcp2aQ=;
        b=J5xFUKI+kPTmczQ08Dpkfe91zrTGB6dS68kHAI7EaFrXhLvQZV4DPxt94be3ZNNzO4
         BubkpbjXrRrOitGm0w+q/2dpPXIdzqYX0Q202gxFnI2KbQ6r+PjAWjsm7pjTyH92Z0/2
         H+ghNJ7o+tPb5RnF4ItkNqW+HmuEYLwVssiFQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8AWsuZeHHO0fTr7SMH5yzyE+p153cQFgu5EbTNcp2aQ=;
        b=Vi+NT5jt4l1UEEsr2xu2hsYjg1JtJQfveLNcdiYPD/n8n9L/wqaKgqb4jx8WMU6pig
         saMLTPO4+beJWqg3WgQH2Kcm3awgURfekHWsExcGqiaNvYpZGeb/Uay6QA2yLjZgpN2P
         4HqDz6hoPNbrdhSsq7LJNHJgJ21KC/ZQz/e1ajGVAIdP+3jRVao2yJeXd8t2e42OgXxq
         t6/ckOxUcaDfS5d2+qw5vQ0TLAFq1LqNugIqYe3zlgIx4GX0ijRRN5Bsah6dSHUOJp1k
         wL8cE2/U+rmlFBzcUMJm9IdKCDg13gIAGYFGaH0Rq2rf3Kby/RH4YdZgjlH8X6Jdi7tk
         PGcg==
X-Gm-Message-State: ACrzQf3qqPBrOVKlgsU0L61q6lSCOyIt8LdiGQcnJaPl3nkjXIE9W9/i
        mMmjcfb5mxOkh/jdmz2uaXlf4g==
X-Google-Smtp-Source: AMsMyM5m8WD4MmZWptcMkSLLjG6uON8+pNTeQGVU1aJcIf2cADqJNCE7k5oI7h+pC5Wb13A66R6A0w==
X-Received: by 2002:a05:6a00:1947:b0:536:6730:7d33 with SMTP id s7-20020a056a00194700b0053667307d33mr5669335pfk.10.1663340643093;
        Fri, 16 Sep 2022 08:04:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n5-20020a63e045000000b0041cd2417c66sm13475398pgj.18.2022.09.16.08.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 08:04:02 -0700 (PDT)
Date:   Fri, 16 Sep 2022 08:04:01 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 3/3] wireguard: netlink: avoid variable-sized memcpy
 on sockaddr
Message-ID: <202209160802.60021AF07@keescook>
References: <20220916143740.831881-1-Jason@zx2c4.com>
 <20220916143740.831881-4-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916143740.831881-4-Jason@zx2c4.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 03:37:40PM +0100, Jason A. Donenfeld wrote:
> Doing a variable-sized memcpy is slower, and the compiler isn't smart
> enough to turn this into a constant-size assignment.
> 
> Further, Kees' latest fortified memcpy will actually bark, because the
> destination pointer is type sockaddr, not explicitly sockaddr_in or
> sockaddr_in6, so it thinks there's an overflow:
> 
>     memcpy: detected field-spanning write (size 28) of single field
>     "&endpoint.addr" at drivers/net/wireguard/netlink.c:446 (size 16)
> 
> Fix this by just assigning by using explicit casts for each checked
> case.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Oh, also, please include reporter details:

Reported-by: syzbot+a448cda4dba2dac50de5@syzkaller.appspotmail.com


-- 
Kees Cook
