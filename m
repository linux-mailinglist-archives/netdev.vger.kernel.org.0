Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7768563B5D0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiK1XYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbiK1XY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:24:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E322931F90
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:24:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9000FB80FE9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 23:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0046C433C1;
        Mon, 28 Nov 2022 23:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669677864;
        bh=2DkbCoykw7m5Um2um/6ERgr8KRUUCexwR4uDoykPP/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m6Lw1hWsnTLCkkr5skqhgQK9LKpu3ziskcLYXUq9oI7gSHYjWyf7Rp3Ype2Yq2nRr
         +Ct+bMrJLu5RRHGwIlfdbMVT1L19INBpFvLSqJGQZJaqztlcRKXLkdxQZvSrTPbKVK
         j+Awn87PFsaGxF4Zy8NOiyuPrr14z73dK6vEnWU17dRQOr0PMqQ2MLlkKNpFAouvIm
         SPQ9nuBtZAyrGcUr+joiHJtxASsvjxR61LjP2jfSWjNP8z5ymtoaN4GfwpNyLSVD/b
         CFcV/0F6jDL4W/gIBJ1WZ69vK/4fkcEFRvPWi+ZInCufcLplejvrp5MngzFBtzXWQQ
         nLtPgY3/ymwxQ==
Date:   Mon, 28 Nov 2022 15:24:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v5] ethtool: add netlink based get rss support
Message-ID: <20221128152423.0cc29e10@kernel.org>
In-Reply-To: <IA1PR11MB626656578C50634B3C90E0C4E40E9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221123184846.161964-1-sudheer.mogilappagari@intel.com>
        <20221123193048.7a19d246@kernel.org>
        <IA1PR11MB626656578C50634B3C90E0C4E40E9@IA1PR11MB6266.namprd11.prod.outlook.com>
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

On Fri, 25 Nov 2022 22:19:22 +0000 Mogilappagari, Sudheer wrote:
> > Let's not put the number of rings in RSS.
> > 
> > I keep having to explain to people how to calculate the correct number
> > of active RX rings. If the field is in the channels API hopefully
> > they'll just use it.
> > 
> > The max ring being in RXFH seems like a purely historic / legacy thing.  
> 
> Yes. channels API has this information. If ring count is not recommended in
> RSS_GET, any possibility of excluding rings info from ethtool output too?
> Included rings attribute in RSS_GET because user space code gets simplified
> while maintaining backward compatibility of output. 
> 
> I assume same output needs to be maintained. So, will have user space code
> doing CHANNELS_GET and RSS_GET during ethtool -x. 
>    
> $ ethtool -x eth0
> RX flow hash indirection table for eth0 with 56 RX ring(s): <<< 
>     0:      0     1     2     3     4     5     6     7

I didn't recall the ring count being listed there. I would not be
against dropping it. Otherwise lets read the value via the channels
command. Simple matter of coding, as they say.
