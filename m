Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185C862385D
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 01:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiKJAqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 19:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiKJAqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 19:46:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7671181C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 16:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7550861D2D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 00:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDC3C433C1;
        Thu, 10 Nov 2022 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668041164;
        bh=sk06nkcIyrf8CCu/3TlkkeBEOVj3VPtGK0CJ/tR47LA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BSzKzt69pbylQHaCmiNSyKAm4Dd1dG1ed886uB/SVbVftga5uZtuI0Sye0JKwVoEm
         02EdnUuzo1+zg0ZxubvWFv5tkIX3p4NWQQbH9cwiCk0gZ2C49BCRiGNwNROuOmq57h
         6xLDt2xUTlS1PO40flHXEh5egcUHZHQsjX4I9KdisYAGW0QZdCWhAIzTEk+ylzAWQg
         f8n9BYPYD+cTHoSF3IjjW5gU3UHIDAUL5WOAdIKE1CF60E24dGOP1AgJXj4nw7G5vI
         28BjyuHjkLinliJqocT/fjMSzuWzhM84+tq1JSmKz74aGiWQ6gt6xHfbOpdrnB1wNX
         hbJnOmsYyuSGA==
Date:   Wed, 9 Nov 2022 16:46:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Message-ID: <20221109164603.1fd508ca@kernel.org>
In-Reply-To: <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
        <20221107182549.278e0d7a@kernel.org>
        <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
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

On Thu, 10 Nov 2022 00:26:23 +0000 Mogilappagari, Sudheer wrote:
> > Can we describe in more detail which commands are reimplemented?
> > Otherwise calling the command RXFH makes little sense.
> > We may be better of using RSS in the name in the first place.  
> 
> This is the ethtool command being reimplemented.
> ethtool -x|--show-rxfh-indir DEVNAME   Show Rx flow hash indirection table and/or RSS hash key
>         [ context %d ]
> 
> Picked RXFH based on existing function names and ethtool_rxfh
> structure. If it needs to change, how about RSS_CTX or just RSS ? 

I vote for just RSS.

> > > +  ``ETHTOOL_A_RXFH_HEADER``            nested  reply header
> > > +  ``ETHTOOL_A_RXFH_RSS_CONTEXT``       u32     RSS context number
> > > +  ``ETHTOOL_A_RXFH_INDIR_SIZE``        u32     RSS Indirection table size  
> > > +  ``ETHTOOL_A_RXFH_KEY_SIZE``          u32     RSS hash key size
> > > +  ``ETHTOOL_A_RXFH_HFUNC``             u32     RSS hash func  
> > 
> > This is u8 in the implementation, please make the implementation u32 as
> > documented.  
> 
> This should have been u8 instead. Will make it consistent.

u32 is better, data sizes in netlink are rounded up to 4 bytes anyway,
so u8 is 1 usable byte and 3 bytes of padding. Much better to use u32.

> > > +static int rxfh_prepare_data(const struct ethnl_req_info *req_base,
> > > +			     struct ethnl_reply_data *reply_base,
> > > +			     struct genl_info *info)
> > > +{
> > > +	struct rxfh_reply_data *data = RXFH_REPDATA(reply_base);
> > > +	struct net_device *dev = reply_base->dev;
> > > +	struct ethtool_rxfh *rxfh = &data->rxfh;
> > > +	struct ethnl_req_info req_info = {};
> > > +	struct nlattr **tb = info->attrs;
> > > +	u32 indir_size = 0, hkey_size = 0;
> > > +	const struct ethtool_ops *ops;
> > > +	u32 total_size, indir_bytes;
> > > +	bool mod = false;
> > > +	u8 dev_hfunc = 0;
> > > +	u8 *hkey = NULL;
> > > +	u8 *rss_config;
> > > +	int ret;
> > > +
> > > +	ops = dev->ethtool_ops;
> > > +	if (!ops->get_rxfh)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	ret = ethnl_parse_header_dev_get(&req_info,
> > > +					 tb[ETHTOOL_A_RXFH_HEADER],
> > > +					 genl_info_net(info), info->extack,
> > > +					 true);  
> > 
> > Why are you parsing again?
> > 
> > You hook in ethnl_default_doit() and ethnl_default_dumpit(), which
> > should call the parsing for you already.
> 
> My bad. Had used other netlink get command implementation as reference
> and overlooked request_ops->parse_request. 

Right, as you probably discovered the core ethtool code can do a lot of
work for you if the command doesn't have special requirements and you
can rely on the default doit / dumpit handling.
