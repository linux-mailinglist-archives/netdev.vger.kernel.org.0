Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFBA6CD4BA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjC2IfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjC2IfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:35:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227461AC;
        Wed, 29 Mar 2023 01:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=QSGdJmu41rSBexFKsnfWQQ23KoebUnJZThHWBcIYgtw=;
        t=1680078914; x=1681288514; b=oVkVsa8XGCw26wbpNqIUhPKOvzM3diety9fqtr3E1OY6ox+
        k3C6XdMTx4Xs+xN8gPar9j+uT3O9hJ7A1H+gMQZ4x3AosfLbog9RR2c8d5nqM/S+SKIbE8VF1TwSA
        m8FrTu5A9SRPjl2LlpMB4GTZldPP+sP6leaFEP0yYI91xtCtcUuf26Vbcoh0RKQPvBAAfuNK6LRbN
        bcp3CazhhZ+sED5fSkWqDATvnEmASWRwzxANrq4FPBn26+jap0iI0lbBj1lzpoeJBHviiwV3dzdYA
        NeAlAUEiX4FoGPLj5pvfiHrbUeTf++lhWZn3N+mQPUlgTmCodjbS5VWNE9tApRMw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phRGw-0000yB-0W;
        Wed, 29 Mar 2023 10:35:10 +0200
Message-ID: <8304ec7e430815edf3b79141c90272e36683e085.camel@sipsolutions.net>
Subject: Re: traceability of wifi packet drops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Wed, 29 Mar 2023 10:35:08 +0200
In-Reply-To: <20230328155826.38e9e077@kernel.org>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
         <20230327180950.79e064da@kernel.org>
         <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
         <20230328155826.38e9e077@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-28 at 15:58 -0700, Jakub Kicinski wrote:
> On Tue, 28 Mar 2023 09:37:43 +0200 Johannes Berg wrote:
> > > My knee jerk idea would be to either use the top 8 bits of the
> > > skb reason enum to denote the space. And then we'd say 0 is core
> > > 1 is wifi (enum ieee80211_rx_result) etc. Within the WiFi space=20
> > > you can use whatever encoding you like. =20
> >=20
> > Right. That's not _that_ far from what I proposed above, except you pul=
l
> > the core out=20
>=20
> Thinking about it again, maybe yours is actually cleaner.
> Having the subsystem reason on the top bits, I mean.
> That way after masking the specific bits out the lower bits
> can still provide a valid "global" drop reason.

Ah, that's not even what I was thinking, but that would work.

What I was thinking was basically the same as you had, just hadn't
thought about more subsystems yet and was trying to carve out some bits
for wifi specifically :-)

I don't think we'll really end up with a case where we really want to
use the low bits for a global reason and a wifi specific reason in
higher bits together - there are basically no applicable reasons that we
have today ...

I mean, it basically doesn't make sense to have any of the current
reasons (such as _IP_CSUM or _IP_INHDR) with a wifi specific reason
since we wouldn't even go look at the IP header when wifi drops
something.

The only one that _might_ be relevant would be possibly _PKT_TOO_SMALL
where wifi has various "reasons" for it to be too small (depending on
the packet format), but I'm not sure that it would even be helpful to
have drop monitor report "packet too small" from different layers; today
it's used from L3/L4, not L2.


> The UNUSABLE vs MONITOR bits I'd be tempted to put in the "global"
> reason, but maybe that's not a great idea given Eric's concern :)

This bit is actually functionally important for us, but to me it doesn't
matter much where it is.

> Right, drop monitor is good ol' kernel code, we can make it do whatever
> we want. I was worried that tracing / BPF may tie our hands but they
> support sparse enums just fine.

Ah, OK, right.



So after all the discussion, I would revise my proposal to be more like
yours. Let's say like the below. This will not put the reason string
into tracing, but I think we can live with that.

johannes



diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c0a3ea806cd5..f884eb0a1d2d 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -343,6 +343,26 @@ enum skb_drop_reason {
 	 * used as a real 'reason'
 	 */
 	SKB_DROP_REASON_MAX,
+
+	/** @SKB_DROP_REASON_SUBSYS_MASK: subsystem mask in drop reasons,
+	 * see &enum skb_drop_reason_subsys
+	 */
+	SKB_DROP_REASON_SUBSYS_MASK =3D 0xff000000,
+};
+
+/**
+ * enum skb_drop_reason_subsys - subsystem tag for (extended) drop reasons
+ */
+enum skb_drop_reason_subsys {
+	/** @SKB_DROP_REASON_SUBSYS_CORE: core drop reasons defined above */
+	SKB_DROP_REASON_SUBSYS_CORE,
+	/** @SKB_DROP_REASON_SUBSYS_MAC80211: mac80211 drop reasons,
+	 * see net/mac80211/dropreason.h
+	 */
+	SKB_DROP_REASON_SUBSYS_MAC80211,
+
+	/** @SKB_DROP_REASON_SUBSYS_NUM: number of subsystems defined */
+	SKB_DROP_REASON_SUBSYS_NUM
 };
=20
 #define SKB_DR_INIT(name, reason)				\
@@ -358,6 +378,17 @@ enum skb_drop_reason {
 			SKB_DR_SET(name, reason);		\
 	} while (0)
=20
-extern const char * const drop_reasons[];
+struct drop_reason_list {
+	const char * const *reasons;
+	size_t n_reasons;
+};
+
+/* Note: due to dynamic registrations, access must be under RCU */
+extern const struct drop_reason_list __rcu *
+drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM];
+
+void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
+				  const struct drop_reason_list *list);
+void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys);
=20
 #endif
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5a782d1d8fd3..c6c60dc75b2d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/netlink.h>
 #include <linux/net_dropmon.h>
+#include <linux/bitfield.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
@@ -504,8 +505,6 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ign=
ore,
 	if (!nskb)
 		return;
=20
-	if (unlikely(reason >=3D SKB_DROP_REASON_MAX || reason <=3D 0))
-		reason =3D SKB_DROP_REASON_NOT_SPECIFIED;
 	cb =3D NET_DM_SKB_CB(nskb);
 	cb->reason =3D reason;
 	cb->pc =3D location;
@@ -552,9 +551,9 @@ static size_t net_dm_in_port_size(void)
 }
=20
 #define NET_DM_MAX_SYMBOL_LEN 40
+#define NET_DM_MAX_REASON_LEN 50
=20
-static size_t net_dm_packet_report_size(size_t payload_len,
-					enum skb_drop_reason reason)
+static size_t net_dm_packet_report_size(size_t payload_len)
 {
 	size_t size;
=20
@@ -576,7 +575,7 @@ static size_t net_dm_packet_report_size(size_t payload_=
len,
 	       /* NET_DM_ATTR_PROTO */
 	       nla_total_size(sizeof(u16)) +
 	       /* NET_DM_ATTR_REASON */
-	       nla_total_size(strlen(drop_reasons[reason]) + 1) +
+	       nla_total_size(NET_DM_MAX_REASON_LEN + 1) +
 	       /* NET_DM_ATTR_PAYLOAD */
 	       nla_total_size(payload_len);
 }
@@ -610,6 +609,8 @@ static int net_dm_packet_report_fill(struct sk_buff *ms=
g, struct sk_buff *skb,
 				     size_t payload_len)
 {
 	struct net_dm_skb_cb *cb =3D NET_DM_SKB_CB(skb);
+	const struct drop_reason_list *list =3D NULL;
+	unsigned int subsys, subsys_reason;
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
 	void *hdr;
@@ -627,9 +628,24 @@ static int net_dm_packet_report_fill(struct sk_buff *m=
sg, struct sk_buff *skb,
 			      NET_DM_ATTR_PAD))
 		goto nla_put_failure;
=20
+	rcu_read_lock();
+	subsys =3D u32_get_bits(cb->reason, SKB_DROP_REASON_SUBSYS_MASK);
+	if (subsys < SKB_DROP_REASON_SUBSYS_NUM)
+		list =3D rcu_dereference(drop_reasons_by_subsys[subsys]);
+	subsys_reason =3D cb->reason & ~SKB_DROP_REASON_SUBSYS_MASK;
+	if (!list ||
+	    subsys_reason >=3D list->n_reasons ||
+	    !list->reasons[subsys_reason] ||
+	    strlen(list->reasons[subsys_reason]) > NET_DM_MAX_REASON_LEN) {
+		list =3D rcu_dereference(drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_C=
ORE]);
+		subsys_reason =3D SKB_DROP_REASON_NOT_SPECIFIED;
+	}
 	if (nla_put_string(msg, NET_DM_ATTR_REASON,
-			   drop_reasons[cb->reason]))
+			   list->reasons[subsys_reason])) {
+		rcu_read_unlock();
 		goto nla_put_failure;
+	}
+	rcu_read_unlock();
=20
 	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
@@ -687,9 +703,7 @@ static void net_dm_packet_report(struct sk_buff *skb)
 	if (net_dm_trunc_len)
 		payload_len =3D min_t(size_t, net_dm_trunc_len, payload_len);
=20
-	msg =3D nlmsg_new(net_dm_packet_report_size(payload_len,
-						  NET_DM_SKB_CB(skb)->reason),
-			GFP_KERNEL);
+	msg =3D nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
 	if (!msg)
 		goto out;
=20
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..3449f9acbc6c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -122,11 +122,59 @@ EXPORT_SYMBOL(sysctl_max_skb_frags);
=20
 #undef FN
 #define FN(reason) [SKB_DROP_REASON_##reason] =3D #reason,
-const char * const drop_reasons[] =3D {
+static const char * const drop_reasons[] =3D {
 	[SKB_CONSUMED] =3D "CONSUMED",
 	DEFINE_DROP_REASON(FN, FN)
 };
-EXPORT_SYMBOL(drop_reasons);
+
+static const struct drop_reason_list drop_reasons_core =3D {
+	.reasons =3D drop_reasons,
+	.n_reasons =3D ARRAY_SIZE(drop_reasons),
+};
+
+const struct drop_reason_list __rcu *
+drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM] =3D {
+	[SKB_DROP_REASON_SUBSYS_CORE] =3D &drop_reasons_core,
+};
+EXPORT_SYMBOL(drop_reasons_by_subsys);
+
+/**
+ * drop_reasons_register_subsys - register another drop reason subsystem
+ * @subsys: the subsystem to register, must not be the core
+ * @list: the list of drop reasons within the subsystem, must point to
+ *	a statically initialized list
+ */
+void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
+				  const struct drop_reason_list *list)
+{
+	if (WARN(subsys <=3D SKB_DROP_REASON_SUBSYS_CORE ||
+		 subsys >=3D ARRAY_SIZE(drop_reasons_by_subsys),
+		 "invalid subsystem %d\n", subsys))
+		return;
+
+	/* must point to statically allocated memory, so INIT is OK */
+	RCU_INIT_POINTER(drop_reasons_by_subsys[subsys], list);
+}
+EXPORT_SYMBOL_GPL(drop_reasons_register_subsys);
+
+/**
+ * drop_reasons_unregister_subsys - unregister a drop reason subsystem
+ * @subsys: the subsystem to remove, must not be the core
+ *
+ * Note: This will synchronize_rcu() to ensure no users when it returns.
+ */
+void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys)
+{
+	if (WARN(subsys <=3D SKB_DROP_REASON_SUBSYS_CORE ||
+		 subsys >=3D ARRAY_SIZE(drop_reasons_by_subsys),
+		 "invalid subsystem %d\n", subsys))
+		return;
+
+	RCU_INIT_POINTER(drop_reasons_by_subsys[subsys], NULL);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(drop_reasons_unregister_subsys);
=20
 /**
  *	skb_panic - private function for out-of-line support

