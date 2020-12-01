Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B6F2CA1D8
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388875AbgLALxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgLALxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:53:38 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADA6DC0613D6
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 03:52:57 -0800 (PST)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id BDE3983169;
        Tue,  1 Dec 2020 11:52:56 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606823576; bh=ddEeRa2fVoJ6Zm1JvDo9Da7Ib+HO1FCNseixp0IeGL4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20v2=
         20net-next=201/2]=20ppp:=20add=20PPPIOCBRIDGECHAN=20and=20PPPIOCUN
         BRIDGECHAN=20ioctls|Date:=20Tue,=20=201=20Dec=202020=2011:52:49=20
         +0000|Message-Id:=20<20201201115250.6381-2-tparkin@katalix.com>|In
         -Reply-To:=20<20201201115250.6381-1-tparkin@katalix.com>|Reference
         s:=20<20201201115250.6381-1-tparkin@katalix.com>;
        b=Vmq7ke4M7XgdlRdbwqnsWLab7kWv3u+/5Nznok+jivEhyNwg+agH8PU9qmDQmsY/3
         IAyhhGh2zHb47l3zyMHEsA/RaqQRVp8lGy84o6/NV8BeuSn/Vk5mykuPDbXFvSu2CO
         rzRtMnC32miD/Ob6aZ3yU6/RHe6zWypeYUAGYAmy5uTxdNRguVkNi2GjM5xgqtDDvc
         SuVY7MA6Bz6uxyES/rLtXZQIejC7B8gYE6Sfs7e1ncUO+xK1ZhBQv1FGBAVgyn7Za9
         imcxFLf332uUd1KjiJTzYDxRp5+JxIwH19yAhkE7YRa7Zg21TXKymde2CcqxdvPVZG
         6ngzsc9DgEkFw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v2 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls
Date:   Tue,  1 Dec 2020 11:52:49 +0000
Message-Id: <20201201115250.6381-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201115250.6381-1-tparkin@katalix.com>
References: <20201201115250.6381-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new ioctl pair allows two ppp channels to be bridged together:
frames arriving in one channel are transmitted in the other channel
and vice versa.

The practical use for this is primarily to support the L2TP Access
Concentrator use-case.  The end-user session is presented as a ppp
channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
over a serial link) and is switched into a PPPoL2TP session for
transmission to the LNS.  At the LNS the PPP session is terminated in
the ISP's network.

When a PPP channel is bridged to another it takes a reference on the
other's struct ppp_file.  This reference is dropped when the channels
are unbridged, which can occur either explicitly on userspace calling
the PPPIOCUNBRIDGECHAN ioctl, or implicitly when either channel in the
bridge is unregistered.

In order to implement the channel bridge, struct channel is extended
with a new field, 'bridge', which points to the other struct channel
making up the bridge.

This pointer is RCU protected to avoid adding another lock to the data
path.

To guard against concurrent writes to the pointer, the existing struct
channel lock 'upl' coverage is extended rather than adding a new lock.

The 'upl' lock is used to protect the existing unit pointer.  Since the
bridge effectively replaces the unit (they're mutually exclusive for a
channel) it makes coding easier to use the same lock to cover them
both.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 drivers/net/ppp/ppp_generic.c  | 139 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/ppp-ioctl.h |   2 +
 2 files changed, 138 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 7d005896a0f9..5babf0aff840 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -174,7 +174,8 @@ struct channel {
 	struct ppp	*ppp;		/* ppp unit we're connected to */
 	struct net	*chan_net;	/* the net channel belongs to */
 	struct list_head clist;		/* link in list of channels per unit */
-	rwlock_t	upl;		/* protects `ppp' */
+	rwlock_t	upl;		/* protects `ppp' and 'bridge' */
+	struct channel __rcu *bridge;	/* "bridged" ppp channel */
 #ifdef CONFIG_PPP_MULTILINK
 	u8		avail;		/* flag used in multilink stuff */
 	u8		had_frag;	/* >= 1 fragments have been sent */
@@ -606,6 +607,73 @@ static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
 #endif
 #endif
 
+/* Bridge one PPP channel to another.
+ * When two channels are bridged, ppp_input on one channel is redirected to
+ * the other's ops->start_xmit handler.
+ * In order to safely bridge channels we must reject channels which are already
+ * part of a bridge instance, or which form part of an existing unit.
+ * Once successfully bridged, each channel holds a reference on the other
+ * to prevent it being freed while the bridge is extant.
+ */
+static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
+{
+	write_lock_bh(&pch->upl);
+	if (pch->ppp || pch->bridge) {
+		write_unlock_bh(&pch->upl);
+		return -EALREADY;
+	}
+	rcu_assign_pointer(pch->bridge, pchb);
+	write_unlock_bh(&pch->upl);
+
+	write_lock_bh(&pchb->upl);
+	if (pchb->ppp || pchb->bridge) {
+		write_unlock_bh(&pchb->upl);
+		goto err_unset;
+	}
+	rcu_assign_pointer(pchb->bridge, pch);
+	write_unlock_bh(&pchb->upl);
+
+	refcount_inc(&pch->file.refcnt);
+	refcount_inc(&pchb->file.refcnt);
+
+	return 0;
+
+err_unset:
+	write_lock_bh(&pch->upl);
+	RCU_INIT_POINTER(pch->bridge, NULL);
+	write_unlock_bh(&pch->upl);
+	synchronize_rcu();
+	return -EALREADY;
+}
+
+static int ppp_unbridge_channels(struct channel *pch)
+{
+	struct channel *pchb;
+
+	write_lock_bh(&pch->upl);
+	pchb = rcu_dereference(pch->bridge);
+	if (!pchb) {
+		write_unlock_bh(&pch->upl);
+		return -EINVAL;
+	}
+	RCU_INIT_POINTER(pch->bridge, NULL);
+	write_unlock_bh(&pch->upl);
+
+	write_lock_bh(&pchb->upl);
+	RCU_INIT_POINTER(pchb->bridge, NULL);
+	write_unlock_bh(&pchb->upl);
+
+	synchronize_rcu();
+
+	if (refcount_dec_and_test(&pch->file.refcnt))
+		ppp_destroy_channel(pch);
+
+	if (refcount_dec_and_test(&pchb->file.refcnt))
+		ppp_destroy_channel(pchb);
+
+	return 0;
+}
+
 static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ppp_file *pf;
@@ -641,8 +709,9 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 	if (pf->kind == CHANNEL) {
-		struct channel *pch;
+		struct channel *pch, *pchb;
 		struct ppp_channel *chan;
+		struct ppp_net *pn;
 
 		pch = PF_TO_CHANNEL(pf);
 
@@ -657,6 +726,29 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			err = ppp_disconnect_channel(pch);
 			break;
 
+		case PPPIOCBRIDGECHAN:
+			if (get_user(unit, p))
+				break;
+			err = -ENXIO;
+			pn = ppp_pernet(current->nsproxy->net_ns);
+			spin_lock_bh(&pn->all_channels_lock);
+			pchb = ppp_find_channel(pn, unit);
+			/* Hold a reference to prevent pchb being freed while
+			 * we establish the bridge.
+			 */
+			if (pchb)
+				refcount_inc(&pchb->file.refcnt);
+			spin_unlock_bh(&pn->all_channels_lock);
+			err = ppp_bridge_channels(pch, pchb);
+			/* Drop earlier refcount now bridge establishment is complete */
+			if (refcount_dec_and_test(&pchb->file.refcnt))
+				ppp_destroy_channel(pchb);
+			break;
+
+		case PPPIOCUNBRIDGECHAN:
+			err = ppp_unbridge_channels(pch);
+			break;
+
 		default:
 			down_read(&pch->chan_sem);
 			chan = pch->chan;
@@ -2089,6 +2181,40 @@ static bool ppp_decompress_proto(struct sk_buff *skb)
 	return pskb_may_pull(skb, 2);
 }
 
+/* Attempt to handle a frame via. a bridged channel, if one exists.
+ * If the channel is bridged, the frame is consumed by the bridge.
+ * If not, the caller must handle the frame by normal recv mechanisms.
+ * Returns true if the frame is consumed, false otherwise.
+ */
+static bool ppp_channel_bridge_input(struct channel *pch, struct sk_buff *skb)
+{
+	struct channel *pchb;
+
+	rcu_read_lock();
+	pchb = rcu_dereference(pch->bridge);
+	if (!pchb)
+		goto out_rcu;
+
+	spin_lock(&pchb->downl);
+	if (!pchb->chan) {
+		/* channel got unregistered */
+		kfree_skb(skb);
+		goto outl;
+	}
+
+	skb_scrub_packet(skb, !net_eq(pch->chan_net, pchb->chan_net));
+	if (!pchb->chan->ops->start_xmit(pchb->chan, skb))
+		kfree_skb(skb);
+
+outl:
+	spin_unlock(&pchb->downl);
+out_rcu:
+	rcu_read_unlock();
+
+	/* If pchb is set then we've consumed the packet */
+	return !!pchb;
+}
+
 void
 ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
 {
@@ -2100,6 +2226,10 @@ ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
 		return;
 	}
 
+	/* If the channel is bridged, transmit via. bridge */
+	if (ppp_channel_bridge_input(pch, skb))
+		return;
+
 	read_lock_bh(&pch->upl);
 	if (!ppp_decompress_proto(skb)) {
 		kfree_skb(skb);
@@ -2796,8 +2926,11 @@ ppp_unregister_channel(struct ppp_channel *chan)
 	list_del(&pch->list);
 	spin_unlock_bh(&pn->all_channels_lock);
 
+	ppp_unbridge_channels(pch);
+
 	pch->file.dead = 1;
 	wake_up_interruptible(&pch->file.rwait);
+
 	if (refcount_dec_and_test(&pch->file.refcnt))
 		ppp_destroy_channel(pch);
 }
@@ -3270,7 +3403,7 @@ ppp_connect_channel(struct channel *pch, int unit)
 		goto out;
 	write_lock_bh(&pch->upl);
 	ret = -EINVAL;
-	if (pch->ppp)
+	if (pch->ppp || pch->bridge)
 		goto outl;
 
 	ppp_lock(ppp);
diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
index 7bd2a5a75348..8dbecb3ad036 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -115,6 +115,8 @@ struct pppol2tp_ioc_stats {
 #define PPPIOCATTCHAN	_IOW('t', 56, int)	/* attach to ppp channel */
 #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
 #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
+#define PPPIOCBRIDGECHAN _IOW('t', 53, int)	/* bridge one channel to another */
+#define PPPIOCUNBRIDGECHAN _IO('t', 54)	/* unbridge channel */
 
 #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
 #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */
-- 
2.17.1

