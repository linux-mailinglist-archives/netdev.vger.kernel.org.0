Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF204C49EA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbiBYQA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237541AbiBYQA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:00:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5435186475
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:59:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91533B82CDA
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 15:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAC7C340E7;
        Fri, 25 Feb 2022 15:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645804792;
        bh=uBoOVuTr+AsRYg44mE0Y9jiKDdeAUVkq9FhbfNyI4wY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F0xjBkngI46KBvtP7GBFLss+lDCMl0FYSQenr5ignitANgfz7NMZIHeiDgIkiiJJp
         fijivjFiwxGMWoWtn2fKFvmiayjzI+4G3sSdCULzAgyF5PwnAsF1B8lLYYwTMGwGC4
         un63Zu6hp4clsrfftbZ2mc6pB/1Tkh1GmOh0k4jZ1VPN2DGzZNMA81HuZuJzzscpch
         ZaCMGQDrekKhVZNkARUzww7KSNGY6I8UKKVz+bDct7HNVPGtxAWvXYZPh0B4l2arwb
         DaOyRiy9p5qjSECSiqHj9LoGCCLew+VNFiChx6kPzxfiladABNsuPjMhLqP5BI3c7v
         1W5rphz59vZcg==
Date:   Fri, 25 Feb 2022 07:59:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        Siva Reddy <siva.kallam@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Byungho An <bh74.an@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: sxgbe: fix return value of __setup handler
Message-ID: <20220225075950.7ba5cc62@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <d397d64f-8ae6-2713-d71c-465ae71baebe@infradead.org>
References: <20220224033528.24640-1-rdunlap@infradead.org>
        <20220224214302.4262c26f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d397d64f-8ae6-2713-d71c-465ae71baebe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022 23:30:42 -0800 Randy Dunlap wrote:
> On 2/24/22 21:43, Jakub Kicinski wrote:
> > On Wed, 23 Feb 2022 19:35:28 -0800 Randy Dunlap wrote:  
> >> __setup() handlers should return 1 on success, i.e., the parameter
> >> has been handled. A return of 0 causes the "option=value" string to be
> >> added to init's environment strings, polluting it.  
> > 
> > Meaning early_param_on_off() also returns the wrong thing?
> > Or that's different?  
> 
> early_param() and its varieties are different -- 0 for success, else error.

Making it an even stronger contender for the worst API ever award ;)

> >> Fixes: acc18c147b22 ("net: sxgbe: add EEE(Energy Efficient Ethernet) for Samsung sxgbe")
> >> Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
> >> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> >>
> >> --- linux-next-20220223.orig/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
> >> +++ linux-next-20220223/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
> >> @@ -2285,18 +2285,18 @@ static int __init sxgbe_cmdline_opt(char
> >>  	char *opt;
> >>  
> >>  	if (!str || !*str)
> >> -		return -EINVAL;
> >> +		return 1;
> >>  	while ((opt = strsep(&str, ",")) != NULL) {
> >>  		if (!strncmp(opt, "eee_timer:", 10)) {
> >>  			if (kstrtoint(opt + 10, 0, &eee_timer))
> >>  				goto err;
> >>  		}
> >>  	}
> >> -	return 0;
> >> +	return 1;
> >>  
> >>  err:
> >>  	pr_err("%s: ERROR broken module parameter conversion\n", __func__);
> >> -	return -EINVAL;
> >> +	return 1;
> >>  }
> >>  
> >>  __setup("sxgbeeth=", sxgbe_cmdline_opt);  
> > 
> > Was the option of making __setup() return void considered?
> > Sounds like we always want to return 1 so what's the point?  
> 
> Well, AFAIK __setup() has been around forever (at least 22 years), so No,
> I don't think anyone has considered making it void.
> 
> Returning 1 or 0 gives kernel parameter writers the option of how error
> input is handled, although 0 is usually wrong. :)

Yeah, well, we've been making bus ->remove() functions void IIUC
so why not this. That's separate from fixing the current incorrect
uses tho, so let me apply both of the netdev fixes, thank you!
