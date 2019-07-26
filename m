Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F96763A8
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfGZKjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 06:39:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfGZKjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 06:39:07 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FEB3308A968;
        Fri, 26 Jul 2019 10:39:07 +0000 (UTC)
Received: from ovpn-204-199.brq.redhat.com (ovpn-204-199.brq.redhat.com [10.40.204.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EF4519729;
        Fri, 26 Jul 2019 10:39:05 +0000 (UTC)
Message-ID: <7ec40c37b843ebd3fd2ff5998bb382e13e45d816.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
From:   Davide Caratti <dcaratti@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
In-Reply-To: <f9ca12ff3880f94d4576ab4e4239f072ed611293.camel@mellanox.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
         <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
         <e007bac4c951486294d4e69d20f7c9ed7040172d.camel@mellanox.com>
         <73cd7a2a29db5a32d669273d367566cdf6652f4e.camel@redhat.com>
         <f9ca12ff3880f94d4576ab4e4239f072ed611293.camel@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 26 Jul 2019 12:39:04 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 26 Jul 2019 10:39:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-07-25 at 21:27 +0000, Saeed Mahameed wrote:
> On Thu, 2019-07-25 at 14:25 +0200, Davide Caratti wrote:
> > On Wed, 2019-07-24 at 20:47 +0000, Saeed Mahameed wrote:
> > > On Wed, 2019-07-24 at 16:02 +0200, Davide Caratti wrote:
> > > > ensure to call netdev_features_change() when the driver flips its
> > > > hw_enc_features bits.
> > > > 
> > > > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> > > 
> > > The patch is correct, 
> > 
> > hello Saeed, and thanks for looking at this!
> > 
> > > but can you explain how did you come to this ? 
> > > did you encounter any issue with the current code ?
> > > 
> > > I am asking just because i think the whole dynamic changing of dev-
> > > > hw_enc_features is redundant since mlx4 has the featutres_check
> > > callback.
> > 
> > we need it to ensure that vlan_transfer_features() updates
> > the (new) value of hw_enc_features in the overlying vlan: otherwise,
> > segmentation will happen anyway when skb passes from vxlan to vlan,
> > if the
> > vxlan is added after the vlan device has been created (see:
> > 7dad9937e064
> > ("net: vlan: add support for tunnel offload") ).
> > 
> 
> but in previous patch you made sure that the vlan always sees the
> correct hw_enc_features on driver load, we don't need to have this
> dynamic update mechanism,

ok, but the mlx4 driver flips the value of hw_enc_features when VXLAN
tunnels are added or removed. So, assume eth0 is a Cx3-pro, and I do:
 
 # ip link add name vlan5 link eth0 type vlan id 5
 # ip link add dev vxlan6 type vxlan id 6  [...]  dev vlan5
 
the value of dev->hw_enc_features is 0 for vlan5, and as a consequence
VXLAN over VLAN traffic becomes segmented by the VLAN, even if eth0, at
the end of this sequence, has the "right" features bits.

> features_check ndo should take care of
> protocols we don't support.

I just had a look at mlx4_en_features_check(), I see it checks if the
packet is tunneled in VXLAN and the destination port matches the
configured value of priv->vxlan_port (when that value is not zero). Now:

On Wed, 2019-07-24 at 20:47 +0000, Saeed Mahameed wrote:
> I am asking just because i think the whole dynamic changing of 
> dev-> hw_enc_features is redundant since mlx4 has the featutres_check
> callback.

I read your initial proposal again. Would it be correct if I just use
patch 1/2, where I add an assignment of

dev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | \
                       NETIF_F_RXCSUM | \
                       NETIF_F_TSO | NETIF_F_TSO6 | \
                       NETIF_F_GSO_UDP_TUNNEL | \
                       NETIF_F_GSO_UDP_TUNNEL_CSUM | \
                       NETIF_F_GSO_PARTIAL;

in mlx4_en_init_netdev(), and then remove the code that flips
dev->hw_enc_features in mlx4_en_add_vxlan_offloads() and
mlx4_en_del_vxlan_offloads() ?

thanks,
--
davide


