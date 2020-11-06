Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2C62A9BED
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgKFSWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:22:06 -0500
Received: from mail.katalix.com ([3.9.82.81]:43092 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgKFSWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 13:22:04 -0500
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 5D23496EE9;
        Fri,  6 Nov 2020 18:17:00 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1604686620; bh=jW5dzwCoREu0Qb7W7G0aRrBFqY8AUd/s6jSQRiPdhnQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[RFC=20PATCH
         =201/2]=20ppp:=20add=20PPPIOCBRIDGECHAN=20ioctl|Date:=20Fri,=20=20
         6=20Nov=202020=2018:16:46=20+0000|Message-Id:=20<20201106181647.16
         358-2-tparkin@katalix.com>|In-Reply-To:=20<20201106181647.16358-1-
         tparkin@katalix.com>|References:=20<20201106181647.16358-1-tparkin
         @katalix.com>;
        b=kYaqu7BrARaen9MkBtUfQ/VNvbjfILMDMFdzjnxGrrh8CmO8tsOrfJErHXFtJzkbq
         yxsGNZ8d9tohEnWff2nwvihOOdE3pcoeWmeaOOyI1lpmLJsoRl4vWz7t0SOtOo5+Ru
         6oFs4NtMnjAfJq2nwU9Nj3z1q0keec6YDoh3MmSIGTezyMewCxS08XrInQG722noB8
         ukQqQyRzOFzet1i8CwmLUt9C3J9yeZraOj7uWxpu488DD2bHq/9Dk19uFvjdsFDXRh
         I/KRw+yC2eII7Kj7ufqNwpymuWDG/NZzvPPpMIVjhEPokHLClPcVcgnOZjXwRNdcdE
         2+xZbs0C0lcdw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH 1/2] ppp: add PPPIOCBRIDGECHAN ioctl
Date:   Fri,  6 Nov 2020 18:16:46 +0000
Message-Id: <20201106181647.16358-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106181647.16358-1-tparkin@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new ioctl allows two ppp channels to be bridged together: frames
arriving in one channel are transmitted in the other channel and vice
versa.

The practical use for this is primarily to support the L2TP Access
Concentrator use-case.  The end-user session is presented as a ppp
channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
over a serial link) and is switched into a PPPoL2TP session for
transmission to the LNS.  At the LNS the PPP session is terminated in
the ISP's network.

When a PPP channel is bridged to another it takes a reference on the
other's struct ppp_file.  This reference is dropped when the channel is
unregistered: if the dereference causes the bridged channel's reference
count to reach zero it is destroyed at that point.
---
 drivers/net/ppp/ppp_generic.c  | 35 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/ppp-ioctl.h |  1 +
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 7d005896a0f9..d893bf4470f4 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -175,6 +175,7 @@ struct channel {
 	struct net	*chan_net;	/* the net channel belongs to */
 	struct list_head clist;		/* link in list of channels per unit */
 	rwlock_t	upl;		/* protects `ppp' */
+	struct channel *bridge;		/* "bridged" ppp channel */
 #ifdef CONFIG_PPP_MULTILINK
 	u8		avail;		/* flag used in multilink stuff */
 	u8		had_frag;	/* >= 1 fragments have been sent */
@@ -641,8 +642,9 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	}
 
 	if (pf->kind == CHANNEL) {
-		struct channel *pch;
+		struct channel *pch, *pchb;
 		struct ppp_channel *chan;
+		struct ppp_net *pn;
 
 		pch = PF_TO_CHANNEL(pf);
 
@@ -657,6 +659,24 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			err = ppp_disconnect_channel(pch);
 			break;
 
+		case PPPIOCBRIDGECHAN:
+			if (get_user(unit, p))
+				break;
+			err = -ENXIO;
+			if (pch->bridge) {
+				err = -EALREADY;
+				break;
+			}
+			pn = ppp_pernet(current->nsproxy->net_ns);
+			spin_lock_bh(&pn->all_channels_lock);
+			pchb = ppp_find_channel(pn, unit);
+			if (pchb) {
+				refcount_inc(&pchb->file.refcnt);
+				pch->bridge = pchb;
+				err = 0;
+			}
+			spin_unlock_bh(&pn->all_channels_lock);
+			break;
 		default:
 			down_read(&pch->chan_sem);
 			chan = pch->chan;
@@ -2100,6 +2120,12 @@ ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
 		return;
 	}
 
+	if (pch->bridge) {
+		skb_queue_tail(&pch->bridge->file.xq, skb);
+		ppp_channel_push(pch->bridge);
+		return;
+	}
+
 	read_lock_bh(&pch->upl);
 	if (!ppp_decompress_proto(skb)) {
 		kfree_skb(skb);
@@ -2791,6 +2817,13 @@ ppp_unregister_channel(struct ppp_channel *chan)
 	up_write(&pch->chan_sem);
 	ppp_disconnect_channel(pch);
 
+	/* Drop our reference on a bridged channel, if any */
+	if (pch->bridge) {
+		if (refcount_dec_and_test(&pch->bridge->file.refcnt))
+			ppp_destroy_channel(pch->bridge);
+		pch->bridge = NULL;
+	}
+
 	pn = ppp_pernet(pch->chan_net);
 	spin_lock_bh(&pn->all_channels_lock);
 	list_del(&pch->list);
diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
index 7bd2a5a75348..4b97ab519c19 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -115,6 +115,7 @@ struct pppol2tp_ioc_stats {
 #define PPPIOCATTCHAN	_IOW('t', 56, int)	/* attach to ppp channel */
 #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
 #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
+#define PPPIOCBRIDGECHAN _IOW('t', 53, int)	/* bridge one channel to another */
 
 #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
 #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */
-- 
2.17.1

