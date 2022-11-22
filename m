Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0926340A9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiKVP6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiKVP6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:58:15 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEA65A6E3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669132694; x=1700668694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lx4pnKsO3cVJFE1M7M5Wllsqubn+S6Ss+79s0TGmVrs=;
  b=bi6O0W7u2NhXnuGA+oXX8e2/6MA8gfwOoUa+R0A75XloeemKGf9SJtkU
   9WTJG8N0vfZ6Av96Hz2mohe7NmfCisJUu2itAQBnc26RVLo8SP685RC32
   lAS3crGVODwvAFSp/JZeeMwBti0dShhCY13cA9HVil+YX5n71xofHzMha
   ixjPW51r3Ian3X6ntoNNjDN/wtkd/SnaPi5ex+k/kRz2HkDY9j7fQpLkg
   oXAVHpAWSCcv6WchlQndN2yRhJaCxmZsJV9s7EgTL6lWzskiaRw33RyFg
   pWQsbVeeSvOp/cPZ/bXBCyQOHec7wgWIMWrJRRmKqXTAlG3CofdUqzPlq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312550441"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="312550441"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 07:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="705013101"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="705013101"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2022 07:58:02 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AMFw0cx020296;
        Tue, 22 Nov 2022 15:58:00 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        tirtha@gmail.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com
Subject: Re: [PATCH intel-next v4] i40e: allow toggling loopback mode via ndo_set_features callback
Date:   Tue, 22 Nov 2022 16:57:59 +0100
Message-Id: <20221122155759.426568-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y3ytcGM2c52lzukO@unreal>
References: <20221118090306.48022-1-tirthendu.sarkar@intel.com> <Y3ytcGM2c52lzukO@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 22 Nov 2022 13:07:28 +0200

> On Fri, Nov 18, 2022 at 02:33:06PM +0530, Tirthendu Sarkar wrote:
> > Add support for NETIF_F_LOOPBACK. This feature can be set via:
> > $ ethtool -K eth0 loopback <on|off>
> > 
> > This sets the MAC Tx->Rx loopback.
> > 
> > This feature is used for the xsk selftests, and might have other uses
> > too.

[...]

> > @@ -12960,6 +12983,9 @@ static int i40e_set_features(struct net_device *netdev,
> >  	if (need_reset)
> >  		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
> >  
> > +	if ((features ^ netdev->features) & NETIF_F_LOOPBACK)
> > +		return i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
> 
> Don't you need to disable loopback if NETIF_F_LOOPBACK was cleared?

0 ^ 1 == 1 -> call i40e_set_loopback()
!!(0) == 0 -> disable

> 
> > +
> >  	return 0;
> >  }
> >  
> > @@ -13722,7 +13748,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
> >  	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
> >  		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
> >  
> > -	netdev->hw_features |= hw_features;
> > +	netdev->hw_features |= hw_features | NETIF_F_LOOPBACK;
> >  

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Thanks,
Olek
