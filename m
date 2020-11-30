Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF22C888E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgK3Pow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:44:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgK3Pow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 10:44:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606751005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pc3sTfbXJOVt6vCEe9FHldGHV1UK5SFz3XNDNv2grKc=;
        b=iMqNJRfp8EQRXerxZCOZvWuuTwzSr8J5keA/OfbvRTB+wQbr1rxyQaSepDFrN0uYT+lNsM
        IXkyVrfdgszjcoXoLf86M3OFJZ2gsFeIS482aFaGo8jx4/2wGxOF/a2IJ08jLWWCWsmCvR
        rNXBuW/tzaL3IRWMwk1KodNB8X0Qoqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-FYIPvKtJOLi8Kdje2lC_UA-1; Mon, 30 Nov 2020 10:43:19 -0500
X-MC-Unique: FYIPvKtJOLi8Kdje2lC_UA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A4A5185E481;
        Mon, 30 Nov 2020 15:43:17 +0000 (UTC)
Received: from ceranb (unknown [10.40.196.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 922286086F;
        Mon, 30 Nov 2020 15:43:14 +0000 (UTC)
Date:   Mon, 30 Nov 2020 16:43:13 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 7/9] bridge: switchdev: Notify about VLAN
 protocol changes
Message-ID: <20201130164313.535b6efa@ceranb>
In-Reply-To: <20201129125407.1391557-8-idosch@idosch.org>
References: <20201129125407.1391557-1-idosch@idosch.org>
        <20201129125407.1391557-8-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 29 Nov 2020 14:54:05 +0200
Ido Schimmel <idosch@idosch.org> wrote:

> From: Danielle Ratson <danieller@nvidia.com>
> 
> Drivers that support bridge offload need to be notified about changes to
> the bridge's VLAN protocol so that they could react accordingly and
> potentially veto the change.
> 
> Add a new switchdev attribute to communicate the change to drivers.
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/switchdev.h |  2 ++
>  net/bridge/br_vlan.c    | 16 ++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index 53e8b4994296..99cd538d6519 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -38,6 +38,7 @@ enum switchdev_attr_id {
>  	SWITCHDEV_ATTR_ID_PORT_MROUTER,
>  	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
>  	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
> +	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
>  	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
>  	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
>  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> @@ -58,6 +59,7 @@ struct switchdev_attr {
>  		bool mrouter;				/* PORT_MROUTER */
>  		clock_t ageing_time;			/* BRIDGE_AGEING_TIME */
>  		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
> +		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
>  		bool mc_disabled;			/* MC_DISABLED */
>  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
>  		u8 mrp_port_state;			/* MRP_PORT_STATE */
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 11f54a7c0d1d..d07008678d32 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -854,15 +854,25 @@ EXPORT_SYMBOL_GPL(br_vlan_get_proto);
>  
>  int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
>  {
> +	struct switchdev_attr attr = {
> +		.orig_dev = br->dev,
> +		.id = SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
> +		.flags = SWITCHDEV_F_SKIP_EOPNOTSUPP,
> +		.u.vlan_protocol = ntohs(proto),
> +	};
>  	int err = 0;
>  	struct net_bridge_port *p;
>  	struct net_bridge_vlan *vlan;
>  	struct net_bridge_vlan_group *vg;
> -	__be16 oldproto;
> +	__be16 oldproto = br->vlan_proto;
>  
>  	if (br->vlan_proto == proto)
>  		return 0;
>  
> +	err = switchdev_port_attr_set(br->dev, &attr);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	/* Add VLANs for the new proto to the device filter. */
>  	list_for_each_entry(p, &br->port_list, list) {
>  		vg = nbp_vlan_group(p);
> @@ -873,7 +883,6 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
>  		}
>  	}
>  
> -	oldproto = br->vlan_proto;
>  	br->vlan_proto = proto;
>  
>  	recalculate_group_addr(br);
> @@ -889,6 +898,9 @@ int __br_vlan_set_proto(struct net_bridge *br, __be16 proto)
>  	return 0;
>  
>  err_filt:
> +	attr.u.vlan_protocol = ntohs(oldproto);
> +	switchdev_port_attr_set(br->dev, &attr);
> +
>  	list_for_each_entry_continue_reverse(vlan, &vg->vlan_list, vlist)
>  		vlan_vid_del(p->dev, proto, vlan->vid);
>  

Reviewed-by: Ivan Vecera <ivecera@redhat.com>

