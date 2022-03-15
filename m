Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6884DA5E0
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352455AbiCOXCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237721AbiCOXCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:02:05 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2885D655;
        Tue, 15 Mar 2022 16:00:52 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m12so642957edc.12;
        Tue, 15 Mar 2022 16:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1tIkuOSCc+qFWcv2z4RMZ2bxB/GyvFYB7yDb+c65+EA=;
        b=Y9FnwbvplYaVf2XpGWfLEJlBBRR8QNaaR/MkZrtTtE4+qRxzWVs47vpw/S1yzoAgic
         CXcVS6JjKiZJJI5xmfJxriOy21lDK45mSoIDpJHzZvpiu+zl16JuxdnMzBQzxPuQOW0m
         kxSIUuZszUqhgBTnZDzFTkeKZNOZaoUxRETGAsyLhF787KlJ026n/o8cEkRorGd/oIQw
         uOWqZIRVOPhHy17kRxlu13TdF4UHQGeXqOKMVQmvn4Rj+US6zx35H5AG1e3uBc7PmfR0
         fDEqZTnOrwpuCoLRCCbHsN1f6N+HPv8fX+tLDUbxVEU35hWJleRvhoTc7f23XMmVcriq
         7LzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tIkuOSCc+qFWcv2z4RMZ2bxB/GyvFYB7yDb+c65+EA=;
        b=2T29FrLuIZVAdW3sSsPd9VJ1ZYNgo6IaWF8/OoR4R9/I28dJk0r48SJgNBzrQ4WIJK
         HkuBsZIES1XFmirh/eg/bEQ+MaSLfZzhNOd9hUDL2qMW7vFRi4D/aJto14AtEdpT2vNQ
         CrFmlsu5o6S7/HrmkgNjX1AZz/ZSt1j1zdy2LCJzsSwosuddMV+EER8LRWOj8w2xoUM5
         URB+ZFkJdzel+O7c24vaIxj/5BXuLiJWczkc1DiUyzne1lggxi+UXam1l0MBHDYS7lh5
         SKk4EJtXhvC4ZWonF3zSkU/96PG/HgZqIbzQMLvU3DnCNlYwqzuBeMevExfv+hYm9eP2
         hMVQ==
X-Gm-Message-State: AOAM530/EI7vmYRTjj6kbCmgELK/PPZ5sMWu/O0y8CF7Xs22LZI2R06o
        Vbl6503Bqj1tihVVjN/+jXY=
X-Google-Smtp-Source: ABdhPJxB0FqblRgEMEZaZinlMoFZSZj/DFpjD0krEKm/hRyktHCjXszrM7xXyy+0ighQkqr7eYWbQA==
X-Received: by 2002:a05:6402:2750:b0:416:29dd:1d17 with SMTP id z16-20020a056402275000b0041629dd1d17mr27355656edd.387.1647385251210;
        Tue, 15 Mar 2022 16:00:51 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id fq6-20020a1709069d8600b006db088ca6d0sm140390ejc.126.2022.03.15.16.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 16:00:50 -0700 (PDT)
Date:   Wed, 16 Mar 2022 01:00:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Never offload FDB entries on
 standalone ports
Message-ID: <20220315230049.pw5r5e5pnd6o5hus@skbuf>
References: <20220315225018.1399269-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315225018.1399269-1-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 11:50:18PM +0100, Tobias Waldekranz wrote:
> If a port joins a bridge that it can't offload, it will fallback to
> standalone mode and software bridging. In this case, we never want to
> offload any FDB entries to hardware either.
> 
> Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")

Do you mind if you resend and you explain in the commit message what is
the impact and why you chose this Fixes: tag?

> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/slave.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index f9cecda791d5..d24b6bf845c1 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2847,6 +2847,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>  	if (ctx && ctx != dp)
>  		return 0;
>  
> +	if (!dp->bridge)
> +		return 0;
> +
>  	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
>  		if (dsa_port_offloads_bridge_port(dp, orig_dev))
>  			return 0;
> -- 
> 2.25.1
> 
