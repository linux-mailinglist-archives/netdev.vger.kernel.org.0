Return-Path: <netdev+bounces-2095-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 650A27003BA
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:29:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEC4E2816A8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA91BE48;
	Fri, 12 May 2023 09:28:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30F138A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54D2C433EF;
	Fri, 12 May 2023 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683883737;
	bh=YThvIcJe2hl5akcLwoIgNs9f7+0dvzucFtD1r4L+NQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jybHKPOnDzlGjX/7rzEJoprFi6tef7HpbYpKWB5gU1JOPworj7ycBb7t3Zt7vSixB
	 /ubf74BhuZN7/QhDukmsoINFXNtXe0/wm66MRWLZNPveCQg2mubUyOjouqN7OCYwwk
	 VpOADTT3adzDJG1A5TpKXDQxHD7t3JUeQaumhVwFqqD+P4oQao+FI8WG60AgV3jbl4
	 z/csNCIA6OPhNomaiUGAYcFrBF4L599uzqQuiGKODwg6IjLKfhRCHedsivoyGhGLy9
	 di10byFFvvhIJefidgBqeN7EcIQR1jZYNEEh4up5LDcvpx5L3jjIa4VBQgoWZUL0DY
	 AhvTwpsU0S+EQ==
Date: Fri, 12 May 2023 11:28:53 +0200
From: Simon Horman <horms@kernel.org>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: Always assign be16 value to
 vlan_proto
Message-ID: <ZF4G1f2tr7SmjIs1@kernel.org>
References: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
 <8715.1683848637@famine>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8715.1683848637@famine>

On Thu, May 11, 2023 at 04:43:57PM -0700, Jay Vosburgh wrote:
> Simon Horman <horms@kernel.org> wrote:
> 
> >The type of the vlan_proto field is __be16.
> >And most users of the field use it as such.
> >
> >In the case of setting or testing the field for the special VLAN_N_VID
> >value, host byte order is used. Which seems incorrect.
> >
> >It also seems somewhat odd to store a VLAN ID value in a field that is
> >otherwise used to store Ether types.
> >
> >Address this issue by defining BOND_VLAN_PROTO_NONE, a big endian value.
> >0xffff was chosen somewhat arbitrarily. What is important is that it
> >doesn't overlap with any valid VLAN Ether types.
> 
> As I think you mentioned, 0xffff is marked as a reserved ethertype.

Yes, it seems that I did. It is reserved in RFC-1701.

I can work it into the patch description if you like - there is no
particular reason I didn't for v2.

[1] https://lore.kernel.org/all/ZEI0zpDyJtfogO7s@kernel.org/
[2] https://www.rfc-editor.org/rfc/rfc1701.html
[3] https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml

> >I don't believe the problems described above are a bug because
> >VLAN_N_VID in both little-endian and big-endian byte order does not
> >conflict with any supported VLAN Ether types in big-endian byte order.
> >
> >Reported by sparse as:
> >
> > .../bond_main.c:2857:26: warning: restricted __be16 degrades to integer
> > .../bond_main.c:2863:20: warning: restricted __be16 degrades to integer
> > .../bond_main.c:2939:40: warning: incorrect type in assignment (different base types)
> > .../bond_main.c:2939:40:    expected restricted __be16 [usertype] vlan_proto
> > .../bond_main.c:2939:40:    got int
> >
> >No functional changes intended.
> >Compile tested only.
> >
> >Signed-off-by: Simon Horman <horms@kernel.org>
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> 	-J
> 
> >---
> >Changes in v2:
> >- Decribe Ether Type aspect of problem in patch description
> >- Use an Ether Type rather than VID valie as sential
> >- Link to v1: https://lore.kernel.org/r/20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org
> >---
> > drivers/net/bonding/bond_main.c | 8 +++++---
> > 1 file changed, 5 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 3fed888629f7..ebf61c19dcef 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -2871,6 +2871,8 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
> > 	return ret;
> > }
> > 
> >+#define BOND_VLAN_PROTO_NONE cpu_to_be16(0xffff)
> >+
> > static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
> > 			     struct sk_buff *skb)
> > {
> >@@ -2878,13 +2880,13 @@ static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
> > 	struct net_device *slave_dev = slave->dev;
> > 	struct bond_vlan_tag *outer_tag = tags;
> > 
> >-	if (!tags || tags->vlan_proto == VLAN_N_VID)
> >+	if (!tags || tags->vlan_proto == BOND_VLAN_PROTO_NONE)
> > 		return true;
> > 
> > 	tags++;
> > 
> > 	/* Go through all the tags backwards and add them to the packet */
> >-	while (tags->vlan_proto != VLAN_N_VID) {
> >+	while (tags->vlan_proto != BOND_VLAN_PROTO_NONE) {
> > 		if (!tags->vlan_id) {
> > 			tags++;
> > 			continue;
> >@@ -2960,7 +2962,7 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
> > 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
> > 		if (!tags)
> > 			return ERR_PTR(-ENOMEM);
> >-		tags[level].vlan_proto = VLAN_N_VID;
> >+		tags[level].vlan_proto = BOND_VLAN_PROTO_NONE;
> > 		return tags;
> > 	}
> > 
> >
> >
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com
> 

