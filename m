Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C6E642090
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 00:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiLDXi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 18:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiLDXiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 18:38:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAE811A07
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 15:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 491EFB80B4E
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48EDC433C1;
        Sun,  4 Dec 2022 23:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670197131;
        bh=ZR3pumQKwKCYNVmos0EXjZeC1AFFP8rzw3tczoMZyt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dNpQa11SD93eEBF+1EDfD5FF2tXYxtvSHfKWI0tvdAXQTMjDs2kZr3CGyv18mYYxr
         ssaX1epaQAokjssk+arXNRQZicjDCGq+vGY/+y/SCuE9VcVhjr0inaGQXHNhDY5LsH
         aDG/91OuypZadEKihiWR9WmwcxuKI7/ZKHMMJ/8IkmnnmjHCmmivyb+xnwAYWC7wb4
         NX+WPBQMKfEn7cw5e1HHEJND5ECvBoM7SpDbWnI0D4HYhYjc/HhfU3n3K2ePpVgtOY
         /I4OXr6Bj6kA5gpDPWytwmA5XpWBJG+AmszX1bxmpau7MbgerCyqj7Ea3S7IxWlnUT
         nxfHDlqMg5WYw==
Date:   Sun, 4 Dec 2022 15:38:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <20221204153850.42640ac2@kernel.org>
In-Reply-To: <Y4yPwR2vBSepDNE+@unreal>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
        <Y4yPwR2vBSepDNE+@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 4 Dec 2022 14:17:05 +0200 Leon Romanovsky wrote:
> On Thu, Dec 01, 2022 at 04:25:55PM -0800, Sudheer Mogilappagari wrote:
> > Add netlink based support for "ethtool -x <dev> [context x]"
> > command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> > This is equivalent to functionality provided via ETHTOOL_GRSSH
> > in ioctl path. It sends RSS table, hash key and hash function
> > of an interface to user space.
> > 
> > This patch implements existing functionality available
> > in ioctl path and enables addition of new RSS context
> > based parameters in future.  
> 
> But why do you do this conversion now? Was this "future" already
> discussed on the ML?

Conversion to netlink stands on its own.

> > +	u8 *rss_config;
> > +	int ret;  
> 
> <...>
> 
> > +		data->indir_table = (u32 *)rss_config;  
> 
> Please use correct type from the beginning.

There are two tables in this memory, the second one is u8.
So one of them will need the cast, the code is fine AFAICT.
