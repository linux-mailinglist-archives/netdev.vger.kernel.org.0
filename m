Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25B76350D8
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbiKWHBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236297AbiKWHBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:01:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F341BF8845
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 23:00:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9099761AA9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CEDC433B5;
        Wed, 23 Nov 2022 07:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669186844;
        bh=h4qg7Xue/Hu8HNz4giAOKeVz2yr0I+aE6Vrebw/pOvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B2ctS6KCMORIH3Ehzc4jigb2NC/+Ygtah3IngOYRRmT118D9ZERyizEHRE32Bnhl+
         cZ6jGjxFhCUNojbUN81A9FBVivVu59gl727USX1Wh3n/QiTeyA1HrH2vqYDR4fNhyP
         cK++0rbmL3uLtZYCiwpdloIlsc/x8PPbf/Hla60THHOfk3afjBBQdJ8B3RHJW5VWYh
         Im/O1xzs/6dyuKlIrqD+WZ8pGJFrFaim1zeFOoR5wWdXqkcOFrp2qksZ170D6HcBi9
         BtqPCYwp0TBCqaac2mb/1o21etPbT+iAQczjN1jPAwtGniOfF0diHjBbjKL0zrfwA/
         uoNOV6BDMjWYQ==
Date:   Wed, 23 Nov 2022 09:00:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>, tirtha@gmail.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH intel-next v4] i40e: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <Y33FFtXqcAiDXxLA@unreal>
References: <20221118090306.48022-1-tirthendu.sarkar@intel.com>
 <Y3ytcGM2c52lzukO@unreal>
 <20221122155759.426568-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122155759.426568-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 04:57:59PM +0100, Alexander Lobakin wrote:
> From: Leon Romanovsky <leon@kernel.org>
> Date: Tue, 22 Nov 2022 13:07:28 +0200
> 
> > On Fri, Nov 18, 2022 at 02:33:06PM +0530, Tirthendu Sarkar wrote:
> > > Add support for NETIF_F_LOOPBACK. This feature can be set via:
> > > $ ethtool -K eth0 loopback <on|off>
> > > 
> > > This sets the MAC Tx->Rx loopback.
> > > 
> > > This feature is used for the xsk selftests, and might have other uses
> > > too.
> 
> [...]
> 
> > > @@ -12960,6 +12983,9 @@ static int i40e_set_features(struct net_device *netdev,
> > >  	if (need_reset)
> > >  		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
> > >  
> > > +	if ((features ^ netdev->features) & NETIF_F_LOOPBACK)
> > > +		return i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
> > 
> > Don't you need to disable loopback if NETIF_F_LOOPBACK was cleared?
> 
> 0 ^ 1 == 1 -> call i40e_set_loopback()
> !!(0) == 0 -> disable
> 

Nice, thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
