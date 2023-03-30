Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247926D0C93
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjC3RTz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Mar 2023 13:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjC3RTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:19:46 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98BAE048
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:19:43 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-PtyqyyTfOKqoXX5TWfu2lw-1; Thu, 30 Mar 2023 13:19:24 -0400
X-MC-Unique: PtyqyyTfOKqoXX5TWfu2lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D109780C8C1;
        Thu, 30 Mar 2023 17:19:23 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8C332166B33;
        Thu, 30 Mar 2023 17:19:22 +0000 (UTC)
Date:   Thu, 30 Mar 2023 19:19:21 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Emeel Hakim <ehakim@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <ZCXEmUQgswOBoRqR@hog>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com>
 <ZCROr7DhsoRyU1qP@hog>
 <20230329184201.GB831478@unreal>
MIME-Version: 1.0
In-Reply-To: <20230329184201.GB831478@unreal>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=0.6 required=5.0 tests=RCVD_IN_DNSWL_LOW,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-29, 21:42:01 +0300, Leon Romanovsky wrote:
> On Wed, Mar 29, 2023 at 04:43:59PM +0200, Sabrina Dubroca wrote:
> > 2023-03-29, 15:21:04 +0300, Emeel Hakim wrote:
> > > Add support for MACsec offload operations for VLAN driver
> > > to allow offloading MACsec when VLAN's real device supports
> > > Macsec offload by forwarding the offload request to it.
> > > 
> > > Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> > > ---
> > > V1 -> V2: - Consult vlan_features when adding NETIF_F_HW_MACSEC.
> > 
> > Uh? You're not actually doing that? You also dropped the
> > changes to vlan_dev_fix_features without explaining why.
> 
> vlan_dev_fix_features() relies on real_dev->vlan_features which was set
> in mlx5 part of this patch.
> 
>   643 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
>   644         netdev_features_t features)
>   645 {
>   ...
>   649
>   650         lower_features = netdev_intersect_features((real_dev->vlan_features |
>   651                                                     NETIF_F_RXCSUM),
>   652                                                    real_dev->features);
> 
> This part ensure that once real_dev->vlan_features and real_dev->features have NETIF_F_HW_MACSEC,
> the returned features will include NETIF_F_HW_MACSEC too.

Ok, thanks.

But back to the issue of vlan_features, in vlan_dev_init: I'm not
convinced NETIF_F_HW_MACSEC should be added to hw_features based on
->features. That would result in a new vlan device that can't offload
macsec at all if it was created at the wrong time (while the lower
device's macsec offload was temporarily disabled). AFAIU,
vlandev->hw_features should be based on realdev->vlan_features. I
don't see a reason to advertise a feature in the vlan device if we
won't ever be able to turn it on because it's not in ->vlan_features
("grmbl why can't I enable it, ethtool says it's here?!").


Emeel, I'm not a maintainer, but I don't think you should be reposting
until the existing discussion has settled down.

> > 
> > [...]
> > > @@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
> > >  			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
> > >  			   NETIF_F_ALL_FCOE;
> > >  
> > > +	if (real_dev->features & NETIF_F_HW_MACSEC)
> > > +		dev->hw_features |= NETIF_F_HW_MACSEC;
> > > +
> > >  	dev->features |= dev->hw_features | NETIF_F_LLTX;
> > >  	netif_inherit_tso_max(dev, real_dev);
> > >  	if (dev->features & NETIF_F_VLAN_FEATURES)

-- 
Sabrina

