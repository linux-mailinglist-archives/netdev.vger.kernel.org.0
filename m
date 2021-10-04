Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A08042098D
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 12:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhJDK5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 06:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhJDK5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 06:57:20 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAB7C061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 03:55:31 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id n8so14367295lfk.6
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 03:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1KfiBEqB5/VGCa+x2QWlU7C4MdQz1YKYJs87y0zYPTE=;
        b=gGJ3nA8cRNlrBgtAjf+0kVx+TYgMd/iWk5OLo2cQh/xdtNVyqYtQkiQHrJvXK/pXPL
         BCgmiR7EtAerkZpvRSyQ6CmL3lkI/xXoZqlHC3jaXU80374HbzvlCLHqjQu2zZeJwFBX
         Awd41LPfJuL6Hxk5eQRK1bGiBY7b7w8BOLl+MfACPq9vy+PWX1ZzZCgctt4B1vWLdp/7
         GUAoQxO10qX4fNXaW+B2mTKqRySc6C1mWSiFdlgDu9gKdjGPuAyG0CtSGfkwBNlpobmZ
         Jp+sOh2NfelRQGgkR1iOHSoKvwVE0gUPQQ09pXIGy4OeWaMMwSytg8U6hUwwv/rXh6HV
         Fthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1KfiBEqB5/VGCa+x2QWlU7C4MdQz1YKYJs87y0zYPTE=;
        b=Yo0pDo83zRkPlKvduoh9uX2ZGh22ZXF/p/24c3vKotkmWm6txdrozXr+opRggmyzEF
         tQWcFFOmKwQdWdyMbGPT67ZmXE2Hohx8VUNdRfmiaDipbQMhga0xamVfgym0HvyPdnaU
         D1kbyGhVvPdRf7rxDm+BNWb/Niy0+kYFxDOB6o36FN3EcxuW2KdcAMmYYvcWkW49vNdg
         4Tzq9Dt2Wgl5IFs9X+5MQcNFlibIJMZBKfY6Un/cDS5Kxl01bdmGltrFvd+iSRG43nIJ
         bY0jciXicxbFNLkrXLAqTfQJMtGoEh0u2XJ2A7XYOv7tdGT9NZZx5UwCWjQGvCg9AvyI
         zpXg==
X-Gm-Message-State: AOAM5316I4Ndu/jLRFh7fxoFxOhkhDsGUD7dctISjaD2+VzIRUYNkMLc
        JILkD7c8l690975o8zmhP5tE1g==
X-Google-Smtp-Source: ABdhPJz8HtpSD5G+NIczedlM142R841nIV3xOUgEuePOj4BLIf2Bv7I8iMezRLadWMS84refFnIsTw==
X-Received: by 2002:ac2:4acb:: with SMTP id m11mr13610237lfp.146.1633344928604;
        Mon, 04 Oct 2021 03:55:28 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id h23sm1605647lja.131.2021.10.04.03.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 03:55:28 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd
 offload from VLAN-unaware bridges using VID 0
In-Reply-To: <20211003222312.284175-2-vladimir.oltean@nxp.com>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
 <20211003222312.284175-2-vladimir.oltean@nxp.com>
Date:   Mon, 04 Oct 2021 12:55:27 +0200
Message-ID: <871r51m540.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 01:23, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> The present code is structured this way due to an incomplete thought
> process. In Documentation/networking/switchdev.rst we document that if a
> bridge is VLAN-unaware, then the presence or lack of a pvid on a bridge
> port (or on the bridge itself, for that matter) should not affect the
> ability to receive and transmit tagged or untagged packets.
>
> If the bridge on behalf of which we are sending this packet is
> VLAN-aware, then the TX forwarding offload API ensures that the skb will
> be VLAN-tagged (if the packet was sent by user space as untagged, it
> will get transmitted town to the driver as tagged with the bridge
> device's pvid). But if the bridge is VLAN-unaware, it may or may not be
> VLAN-tagged. In fact the logic to insert the bridge's PVID came from the
> idea that we should emulate what is being done in the VLAN-aware case.
> But we shouldn't.

IMO, the problem here stems from a discrepancy between LinkStreet
devices and the bridge, in how PVID is interpreted. For the bridge, when
VLAN filtering is disabled, ingressing traffic will be assigned to VID
0. This is true even if the port's PVID is set. A mv88e6xxx port who's
QMode bits are set to 00 (802.1Q disabled) OTOH, will assign ingressing
traffic to its PVID.

So, in order to match the bridge's behavior, I think we need to rethink
how mv88e6xxx deals with non-filtering bridges. At first, one might be
tempted to simply leave the hardware PVID at 0. The PVT can then be used
to create isolation barriers between different bridges. ATU isolation is
really what kills this approach. Since there is no VLAN information in
the tag, there is no way to separate flows from different bridges into
different FIDs. This is the issue I discovered with the forward
offloading series.

> It appears that injecting packets using a VLAN ID of 0 serves the
> purpose of forwarding the packets to the egress port with no VLAN tag
> added or stripped by the hardware, and no filtering being performed.
> So we can simply remove the superfluous logic.

The problem with this patch is that return traffic from the CPU is sent
asymmetrically over a different VLAN, which in turn means that it will
perform the DA lookup in a different FID (0). The result is that traffic
does flow, but for the wrong reason. CPU -> port traffic is now flooded
as unknown unicast. An example:

(:aa / 10.1)
    br0
   /   \
sw0p1 sw0p2
\         /
 \       /
  \     /
    CPU
     |
  .--0--.
  | sw0 |
  '-1-2-'
    | '-- sniffer
    '---- host (:bb / 10.2)

br0 is created using the default settings. sw0 will have (among others)
static entries for the CPU:

    fid:0 addr:aa type:static port:0
    fid:1 addr:aa type:static port:0

1. host sends an ARP for 10.1.

2. sw0 will add this entry (since vlan_default_pvid is 1):

    fid:1 addr:bb type:age-7 port:1

3. CPU replies with a FORWARD (VID 0).

4. sw0 will perform a DA lookup in FID 0, missing the entry learned in
   step 2.

5. sw0 floods the frame as unknown unicast to both host and sniffer.

Conversely, if flooding of unknown unicast is disabled on sw0p1:

    $ bridge link set dev sw0p1 flood off

host can no longer communicate with the CPU.

As I alluded to in the forward offloading thread, I think we need to
move a scheme where:

1. mv88e6xxx clears ds->configure_vlan_while_not_filtering.
2. Assigns a free VID (and by extension a FID) in the VTU to each
   non-filtering bridge.

With this in place, the tagger could use the VID associated with the
egressing port's bridge in the tag.

> There are in fact two independent reasons why having this logic is broken:
>
> (1) When CONFIG_BRIDGE_VLAN_FILTERING=n, we call br_vlan_get_pvid_rcu()
>     but that returns an error and we do error out, dropping all packets
>     on xmit. Not really smart. This is also an issue when the user
>     deletes the bridge pvid:
>
>     $ bridge vlan del dev br0 vid 1 self
>
>     As mentioned, in both cases, packets should still flow freely, and
>     they do just that on any net device where the bridge is not offloaded,
>     but on mv88e6xxx they don't.
>
> (2) that code actually triggers a lockdep warning due to the fact that
>     it dereferences bridge private data that assumes rcu_preempt protection
>     (rcu_read_lock), but rcu_read_lock is not actually held during
>     .ndo_start_xmit, but rather rcu_read_lock_bh (rcu_bh), which has its
>     own lockdep keys.
>
> The solution to both problems is the same: delete the broken code.
>
> Fixes: d82f8ab0d874 ("net: dsa: tag_dsa: offload the bridge forwarding process")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20211003155141.2241314-1-andrew@lunn.ch/
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20210928233708.1246774-1-vladimir.oltean@nxp.com/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/tag_dsa.c | 20 ++------------------
>  1 file changed, 2 insertions(+), 18 deletions(-)
>
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index 77d0ce89ab77..7e35bcda91c9 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -129,12 +129,9 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  	u8 tag_dev, tag_port;
>  	enum dsa_cmd cmd;
>  	u8 *dsa_header;
> -	u16 pvid = 0;
> -	int err;
>  
>  	if (skb->offload_fwd_mark) {
>  		struct dsa_switch_tree *dst = dp->ds->dst;
> -		struct net_device *br = dp->bridge_dev;
>  
>  		cmd = DSA_CMD_FORWARD;
>  
> @@ -144,19 +141,6 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  		 */
>  		tag_dev = dst->last_switch + 1 + dp->bridge_num;
>  		tag_port = 0;
> -
> -		/* If we are offloading forwarding for a VLAN-unaware bridge,
> -		 * inject packets to hardware using the bridge's pvid, since
> -		 * that's where the packets ingressed from.
> -		 */
> -		if (!br_vlan_enabled(br)) {
> -			/* Safe because __dev_queue_xmit() runs under
> -			 * rcu_read_lock_bh()
> -			 */
> -			err = br_vlan_get_pvid_rcu(br, &pvid);
> -			if (err)
> -				return NULL;
> -		}
>  	} else {
>  		cmd = DSA_CMD_FROM_CPU;
>  		tag_dev = dp->ds->index;
> @@ -188,8 +172,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>  
>  		dsa_header[0] = (cmd << 6) | tag_dev;
>  		dsa_header[1] = tag_port << 3;
> -		dsa_header[2] = pvid >> 8;
> -		dsa_header[3] = pvid & 0xff;
> +		dsa_header[2] = 0;
> +		dsa_header[3] = 0;
>  	}
>  
>  	return skb;
> -- 
> 2.25.1
