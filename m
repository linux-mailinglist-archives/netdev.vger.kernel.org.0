Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA6127357D
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgIUWMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgIUWMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 18:12:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06B4C0613D0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 15:12:18 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id r7so19932571ejs.11
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 15:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kbz14uJeVU1pvnVijwPrCQLnHmGj1B9M2UqMUV5G2oQ=;
        b=K04v5BH9XcB1ZRnVOqydd2eMTapb0P2nuCGpMXj/AHF15glR8hepjo6GTK0Ipgfq50
         Ly/t0a/kUj6euEVSY/tj1nvE7FFLAGM0IpF4Nht5PmyH51ydYaBpRfpcJpxAOX0qOrvk
         TZY7DbXFnWELa8i8pCl7Brtnol4sa4/diCtS6LuqlL2YNh2qG4a0G9q6c8WGNmeVoYHq
         01XavNnLBNXMeXhBVGz8mxzi0ftRjBOJWwSuGDsGNCaViACZGjBfI1GekW3z08BRyNhy
         pVKenWnLi0cjZyXPlkTmwVH1a/PA7bqXan7MnSmfQNgUbuMuTEwUfd5I57moVFp4d+lL
         o7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kbz14uJeVU1pvnVijwPrCQLnHmGj1B9M2UqMUV5G2oQ=;
        b=syekukR3FwZMQZza5v115xnyOPbBUAeHDVYRNYPa5Qo21xP9PSQO/4b7t7BPd2O6dd
         61nmjedy9+WUgeqG/uCKnSfyHtBItCv2IOliaYt0Xot4rL3RCBW1A/sJDcZBIpSuEc0y
         EAOyWeWwOAqlDydR7kk+BS68+f1RduyQdBHB+JBvLY42qWdwxCe4xGK71++EinWmX9gv
         Ngeejtr63AD46xNSobsLIcIJNGgLG6o+qYH+hH+FzJ2ySunxdQVG/K4gUbUXZ1ub0fS4
         I+IqwccEu9+VaWMQ4ScL0RJ//MsMZfZZiwr3pb+6EOyXu2bdjqqNXbCPn3uiywZb5D1v
         Ms1g==
X-Gm-Message-State: AOAM533SLHuhqFy3ogbp7V8CiZ5tq9v+34QZ3tqwxTudg0AC5XGH8XdK
        bOUk06V8f3EiwnQZeobsnvA=
X-Google-Smtp-Source: ABdhPJyc8EEn23MPoSNH94Q1FAUdaAaSeCKFVfwpVgGz0zLFKDIiKjLwQr3Aeduoed/sTzsBfefgJA==
X-Received: by 2002:a17:906:8690:: with SMTP id g16mr1621939ejx.187.1600726337564;
        Mon, 21 Sep 2020 15:12:17 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id gh21sm9766886ejb.32.2020.09.21.15.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 15:12:16 -0700 (PDT)
Date:   Tue, 22 Sep 2020 01:12:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: bridge: pop vlan from skb if filtering is
 disabled but it's a pvid
Message-ID: <20200921221214.skhtyevm6pdbaee7@skbuf>
References: <20200911231619.2876486-1-olteanv@gmail.com>
 <ddfecf408d3d1b7e4af97cb3b1c1c63506e4218e.camel@nvidia.com>
 <cd25db58-8dff-cf5f-041a-268bf9a17789@gmail.com>
 <315a6f2a1cec945eb35e69c6fdeaf3c2ab3cb25d.camel@nvidia.com>
 <cc20face-ec67-d444-1cf8-f4257dbe1e1c@gmail.com>
 <a322976c-6d47-aae8-32eb-3593f8e3cc10@gmail.com>
 <20200921195607.hb47f6lpk4wzpys4@skbuf>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cchpaeadit24fxhj"
Content-Disposition: inline
In-Reply-To: <20200921195607.hb47f6lpk4wzpys4@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cchpaeadit24fxhj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 21, 2020 at 10:56:07PM +0300, Vladimir Oltean wrote:
> On Mon, Sep 21, 2020 at 12:44:43PM -0700, Florian Fainelli wrote:
> > Vladimir, let me know if you have a patch for DSA and I can give it a
> > try quickly. Thanks!
> 
> Let me clean it up a little and send it, I need to export a wrapper over
> br_get_pvid() for external use, called under rcu_read_lock().

Here it is as an attached patch, sorry that it can't be simpler than
that. Please call the function from where you need it, and then submit
it yourself to net-next.

Also, you'll notice a lockdep warning when you test it. That's what the
br_vlan_get_pvid_rcu() fix I've just sent is for. Make sure you also
take that.

Thanks,
-Vladimir

--cchpaeadit24fxhj
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-net-dsa-untag-the-bridge-pvid-from-rx-skbs.patch"

From 664bad74cb8e598280e20940092a190026459c5a Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 21 Sep 2020 23:06:44 +0300
Subject: [PATCH] net: dsa: untag the bridge pvid from rx skbs

Currently the bridge untags VLANs present in its VLAN groups in
__allowed_ingress() only when VLAN filtering is enabled.

But when a skb is seen on the RX path as tagged with the bridge's pvid,
and that bridge has vlan_filtering=0, and there isn't any 8021q upper
with that VLAN either, then we have a problem. The bridge will not untag
it (since it is supposed to remain VLAN-unaware), and pvid-tagged
communication will be broken.

There are 2 situations where we can end up like that:

1. When installing a pvid in egress-tagged mode, like this:

ip link add dev br0 type bridge vlan_filtering 0
ip link set swp0 master br0
bridge vlan del dev swp0 vid 1
bridge vlan add dev swp0 vid 1 pvid

This happens because DSA configures the VLAN membership of the CPU port
using the same flags as swp0 (in this case "pvid and not untagged"), in
an attempt to copy the frame as-is from ingress to the CPU.

However, in this case, the packet may arrive untagged on ingress, it
will be pvid-tagged by the ingress port, and will be sent as
egress-tagged towards the CPU. Otherwise stated, the CPU will see a VLAN
tag where there was none to speak of on ingress.

When vlan_filtering is 1, this is not a problem, as stated in the first
paragraph, because __allowed_ingress() will pop it. But currently, when
vlan_filtering is 0 and we have such a VLAN configuration, we need an
8021q upper (br0.1) to be able to ping over that VLAN, which is not
symmetrical with the vlan_filtering=1 case, and therefore, confusing for
users.

Basically what DSA attempts to do is simply an approximation: try to
copy the skb with (or without) the same VLAN all the way up to the CPU.
But DSA drivers treat CPU port VLAN membership in various ways (which is
a good segue into situation 2). And some of those drivers simply tell
the CPU port to copy the frame unmodified, which is the golden standard
when it comes to VLAN processing (therefore, any driver which can
configure the hardware to do that, should do that, and discard the VLAN
flags requested by DSA on the CPU port).

2. Some DSA drivers always configure the CPU port as egress-tagged, in
an attempt to recover the classified VLAN from the skb. These drivers
cannot work at all with untagged traffic when bridged in
vlan_filtering=0 mode. And they can't go for the easy "just keep the
pvid as egress-untagged towards the CPU" route, because each front port
can have its own pvid, and that might require conflicting VLAN
membership settings on the CPU port (swp1 is pvid for VID 1 and
egress-tagged for VID 2; swp2 is egress-taggeed for VID 1 and pvid for
VID 2; with this simplistic approach, the CPU port, which is really a
separate hardware entity and has its own VLAN membership settings, would
end up being egress-untagged in both VID 1 and VID 2, therefore losing
the VLAN tags of ingress traffic).

So the only thing we can do is to create a helper function for resolving
the problematic case (that is, a function which untags the bridge pvid
when that is in vlan_filtering=0 mode), which taggers in need should
call. It isn't called from the generic DSA receive path because there
are drivers that fall neither in the first nor second category.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 66 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2da656d984ef..0348dbab4131 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -7,6 +7,7 @@
 #ifndef __DSA_PRIV_H
 #define __DSA_PRIV_H
 
+#include <linux/if_bridge.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/netpoll.h>
@@ -194,6 +195,71 @@ dsa_slave_to_master(const struct net_device *dev)
 	return dp->cpu_dp->master;
 }
 
+/* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
+ * frames as untagged, since the bridge will not untag them.
+ */
+static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+	struct vlan_ethhdr *hdr = vlan_eth_hdr(skb);
+	struct net_device *br = dp->bridge_dev;
+	struct net_device *dev = skb->dev;
+	struct net_device *upper_dev;
+	struct list_head *iter;
+	u16 vid, pvid, proto;
+	int err;
+
+	if (!br || br_vlan_enabled(br))
+		return skb;
+
+	err = br_vlan_get_proto(br, &proto);
+	if (err)
+		return skb;
+
+	/* Move VLAN tag from data to hwaccel */
+	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto == htons(proto)) {
+		skb = skb_vlan_untag(skb);
+		if (!skb)
+			return NULL;
+	}
+
+	if (!skb_vlan_tag_present(skb))
+		return skb;
+
+	vid = skb_vlan_tag_get_id(skb);
+
+	/* We already run under an RCU read-side critical section since
+	 * we are called from netif_receive_skb_list_internal().
+	 */
+	err = br_vlan_get_pvid_rcu(dev, &pvid);
+	if (err)
+		return skb;
+
+	if (vid != pvid)
+		return skb;
+
+	/* The sad part about attempting to untag from DSA is that we
+	 * don't know, unless we check, if the skb will end up in
+	 * the bridge's data path - br_allowed_ingress() - or not.
+	 * For example, there might be an 8021q upper for the
+	 * default_pvid of the bridge, which will steal VLAN-tagged traffic
+	 * from the bridge's data path. This is a configuration that DSA
+	 * supports because vlan_filtering is 0. In that case, we should
+	 * definitely keep the tag, to make sure it keeps working.
+	 */
+	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
+		if (!is_vlan_dev(upper_dev))
+			continue;
+
+		if (vid == vlan_dev_vlan_id(upper_dev))
+			return skb;
+	}
+
+	__vlan_hwaccel_clear_tag(skb);
+
+	return skb;
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
-- 
2.25.1


--cchpaeadit24fxhj--
