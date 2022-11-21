Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7353B632CEC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiKUTX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiKUTX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:23:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8747C8C4A8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 226776143F
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 19:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D990C433D6;
        Mon, 21 Nov 2022 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669058603;
        bh=QICRYlsGNSkXTxy4UF6u/YKSg3BCoXmEDGeTUfT9Y5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e0Ih1yoO99qED5I/9qjdY605zY2WlhdbT8nefmrgcADtI69axgPBkPvyXymf4HLOm
         23dhB+XI2DbVsiDZHnH2ttE0F6UKtyqYoW1N7Qn33PXvWBbSTUxEhxhX9Ols2HxNS5
         KpNS0fHgtxMZ5+Axxu+uvaG0N6AmjHx2cQqFNC72kt8rKufOE2IcCJURdYAgqAJnfk
         o1hUsyWGiZctvA5fgYOL289WMc0TzjAZPOV7Q74oR9KFsbbFnGF0gtiww4lWYGg1zn
         6fGRWBTz34qdsG8E9cVBWjrahXVVPJP4bHhNOsy4RJwIvXlh+iETBOxOH+FlxoAcqw
         gb6BcsLCSkMAQ==
Date:   Mon, 21 Nov 2022 11:23:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 3/8] devlink: report extended error message in
 region_read_dumpit
Message-ID: <20221121112322.21bffb4b@kernel.org>
In-Reply-To: <243100a2-abb4-6df4-235e-42a773716309@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-4-jacob.e.keller@intel.com>
        <20221118174012.5f4f5e21@kernel.org>
        <243100a2-abb4-6df4-235e-42a773716309@intel.com>
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

On Mon, 21 Nov 2022 11:10:37 -0800 Jacob Keller wrote:
> >> @@ -6453,8 +6453,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
> >>   
> >>   	devl_lock(devlink);
> >>   
> >> -	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
> >> -	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> >> +	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
> >> +		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
> >> +		err = -EINVAL;
> >> +		goto out_unlock;
> >> +	}
> >> +
> >> +	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {  
> > 
> > Please use GENL_REQ_ATTR_CHECK() instead of adding strings.
> >   
> 
> Ahhh. Figured out why GENL_REQ_ATTR_CHECK wasn't used here already. It 
> happens because the dumpit functions don't get a genl_info * struct, 
> they get a netlink_cb and a genl_dumpit_info.
> 
> I can look at improving this.

Ah damn, you're right, I thought I just missed it because it wasn't 
at the top of the function.
