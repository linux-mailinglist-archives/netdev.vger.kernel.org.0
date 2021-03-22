Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B96344DE0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhCVR4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhCVR4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:56:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7706EC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:56:18 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b7so22771870ejv.1
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OrKJJ7lUxB0+2wGbFPE+KxXpI85Er2m66PshYy/4kls=;
        b=CE7NmpSehqYNXiRwWePBxpHm+26JpjgIdsVIA/iMVLRI3sHIRGGp1qfkpbsgywb19G
         bzPJAJJGrVtZkZQCinm/B/uetnhoQXgNQBClUEot/B2J1Rg2GWo3FoIpgPzeVaxFypwV
         8RDPjcYxKCA2Nddm83+VyYu1sqX8Z5Top3CY+fcVja0qnwALx4IyZjKtheSCb/EiZSLh
         Cxtj/1be0YbHFyq7d4kmNV1tchrOQt8x2cB9/0P6Y5X0LpMC0dGqwhBRjZulCkPDvnF3
         Php/D1oe0sphOScgV6+zEy4JYV10pbv58sKhZ0TY1ilGu9utfbOrAZgE/9Cu+fKaEQi2
         jspw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OrKJJ7lUxB0+2wGbFPE+KxXpI85Er2m66PshYy/4kls=;
        b=Nrh/RgJTBshuiNqqm7zE/yIXXhES+v/2bd9JwhPzwaIm/g0B5diPppcMh6NasSbjJI
         pnaXZQV4DlMNyVY+NG+gbiMQ/JSmtJft87KXtTFsghoBxTNls4nPfVVp8E9T1tU8EsgS
         NKwGlkQLoe0dXZt0KdTBKDFJ2vs0c2FDcVnawnEOKXH5ygpzrMVew9wtLP+X8CAj3+G5
         gOo64xRO4C8fnoDj4wUWFHZxDa5EvtFlI1CjumkswUE+8kR3fUsFrLXvIE1jImUXwz9D
         oxhNL3RDOpohECnmg4CZ/sPbSU8ka8glReUMEUv4ov1vqFHsSLFbXDFV9/he4F2VxVVF
         E8hQ==
X-Gm-Message-State: AOAM5320UDrX3LaN9vM14tBj9df73YgL4AZbjWHDXmo55F4uy8UPudAG
        d23fbgEsMnEzay65e4eFBW4=
X-Google-Smtp-Source: ABdhPJyWqr9lVOA1Q9EuQhxL71O/vFjTc6w0vZDgIt8Qt5aaYhVHRKYSnu8H3mSCm5k3VBYrz0hg9Q==
X-Received: by 2002:a17:906:4ada:: with SMTP id u26mr981429ejt.129.1616435777253;
        Mon, 22 Mar 2021 10:56:17 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id n16sm9896431ejy.35.2021.03.22.10.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:56:16 -0700 (PDT)
Date:   Mon, 22 Mar 2021 19:56:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 1/3] net: dsa: only unset VLAN filtering when last
 port leaves last VLAN-aware bridge
Message-ID: <20210322175615.47awcvac2sbxqqyc@skbuf>
References: <20210320225928.2481575-1-olteanv@gmail.com>
 <20210320225928.2481575-2-olteanv@gmail.com>
 <87lfafm5xh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfafm5xh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 06:52:58PM +0100, Tobias Waldekranz wrote:
> On Sun, Mar 21, 2021 at 00:59, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > DSA is aware of switches with global VLAN filtering since the blamed
> > commit, but it makes a bad decision when multiple bridges are spanning
> > the same switch:
> >
> > ip link add br0 type bridge vlan_filtering 1
> > ip link add br1 type bridge vlan_filtering 1
> > ip link set swp2 master br0
> > ip link set swp3 master br0
> > ip link set swp4 master br1
> > ip link set swp5 master br1
> > ip link set swp5 nomaster
> > ip link set swp4 nomaster
> > [138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a global setting
> > [138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE
> >
> > When all ports leave br1, DSA blindly attempts to disable VLAN filtering
> > on the switch, ignoring the fact that br0 still exists and is VLAN-aware
> > too. It fails while doing that.
> >
> > This patch checks whether any port exists at all and is under a
> > VLAN-aware bridge.
> >
> > Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > ---
> >  net/dsa/switch.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index 4b5da89dc27a..32963276452f 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -107,7 +107,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
> >  	bool unset_vlan_filtering = br_vlan_enabled(info->br);
> >  	struct dsa_switch_tree *dst = ds->dst;
> >  	struct netlink_ext_ack extack = {0};
> > -	int err, i;
> > +	int err, port;
> >  
> >  	if (dst->index == info->tree_index && ds->index == info->sw_index &&
> >  	    ds->ops->port_bridge_join)
> > @@ -124,13 +124,16 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
> >  	 * it. That is a good thing, because that lets us handle it and also
> >  	 * handle the case where the switch's vlan_filtering setting is global
> >  	 * (not per port). When that happens, the correct moment to trigger the
> > -	 * vlan_filtering callback is only when the last port left this bridge.
> > +	 * vlan_filtering callback is only when the last port leaves the last
> > +	 * VLAN-aware bridge.
> >  	 */
> >  	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
> > -		for (i = 0; i < ds->num_ports; i++) {
> > -			if (i == info->port)
> > -				continue;
> > -			if (dsa_to_port(ds, i)->bridge_dev == info->br) {
> > +		for (port = 0; port < ds->num_ports; port++) {
> > +			struct net_device *bridge_dev;
> > +
> > +			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
> > +
> > +			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
> >  				unset_vlan_filtering = false;
> >  				break;
> >  			}
> > -- 
> > 2.25.1
> 
> Is it the case that all devices in which VLAN filtering is a global
> setting are also single-chip? To my _D_SA eyes, it feels like we should
> have to iterate over all ports in the tree, not just the switch.

Correct, I might revisit this if I ever get my hands on a board with
sja1105 switches in a real multi-switch tree, and not in disjoint trees
as I have had access to so far.
