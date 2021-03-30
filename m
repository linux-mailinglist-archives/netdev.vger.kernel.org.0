Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB4A34E68E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3Lql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbhC3LqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1982C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCp5-0005lp-IL
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:15 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 10531603E11
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6412A603DD1;
        Tue, 30 Mar 2021 11:46:02 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2843f303;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 07/39] can: dev: reorder struct can_priv members for better packing
Date:   Tue, 30 Mar 2021 13:45:27 +0200
Message-Id: <20210330114559.1114855-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Save eight bytes of holes on x86-64 architectures by reordering struct
can_priv members.

Before:

$ pahole -C can_priv drivers/net/can/dev/dev.o
struct can_priv {
	struct net_device *        dev;                  /*     0     8 */
	struct can_device_stats    can_stats;            /*     8    24 */
	struct can_bittiming       bittiming;            /*    32    32 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct can_bittiming       data_bittiming;       /*    64    32 */
	const struct can_bittiming_const  * bittiming_const; /*    96     8 */
	const struct can_bittiming_const  * data_bittiming_const; /*   104     8 */
	struct can_tdc             tdc;                  /*   112    12 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 2 boundary (128 bytes) --- */
	const struct can_tdc_const  * tdc_const;         /*   128     8 */
	const u16  *               termination_const;    /*   136     8 */
	unsigned int               termination_const_cnt; /*   144     4 */
	u16                        termination;          /*   148     2 */

	/* XXX 2 bytes hole, try to pack */

	const u32  *               bitrate_const;        /*   152     8 */
	unsigned int               bitrate_const_cnt;    /*   160     4 */

	/* XXX 4 bytes hole, try to pack */

	const u32  *               data_bitrate_const;   /*   168     8 */
	unsigned int               data_bitrate_const_cnt; /*   176     4 */
	u32                        bitrate_max;          /*   180     4 */
	struct can_clock           clock;                /*   184     4 */
	enum can_state             state;                /*   188     4 */
	/* --- cacheline 3 boundary (192 bytes) --- */
	u32                        ctrlmode;             /*   192     4 */
	u32                        ctrlmode_supported;   /*   196     4 */
	u32                        ctrlmode_static;      /*   200     4 */
	int                        restart_ms;           /*   204     4 */
	struct delayed_work        restart_work;         /*   208   168 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 5 boundary (320 bytes) was 56 bytes ago --- */
	int                        (*do_set_bittiming)(struct net_device *); /*   376     8 */
	/* --- cacheline 6 boundary (384 bytes) --- */
	int                        (*do_set_data_bittiming)(struct net_device *); /*   384     8 */
	int                        (*do_set_mode)(struct net_device *, enum can_mode); /*   392     8 */
	int                        (*do_set_termination)(struct net_device *, u16); /*   400     8 */
	int                        (*do_get_state)(const struct net_device  *, enum can_state *); /*   408     8 */
	int                        (*do_get_berr_counter)(const struct net_device  *, struct can_berr_counter *); /*   416     8 */
	unsigned int               echo_skb_max;         /*   424     4 */

	/* XXX 4 bytes hole, try to pack */

	struct sk_buff * *         echo_skb;             /*   432     8 */

	/* size: 440, cachelines: 7, members: 31 */
	/* sum members: 426, holes: 4, sum holes: 14 */
	/* paddings: 1, sum paddings: 4 */
	/* last cacheline: 56 bytes */
};

After:

$ pahole -C can_priv drivers/net/can/dev/dev.o
struct can_priv {
	struct net_device *        dev;                  /*     0     8 */
	struct can_device_stats    can_stats;            /*     8    24 */
	const struct can_bittiming_const  * bittiming_const; /*    32     8 */
	const struct can_bittiming_const  * data_bittiming_const; /*    40     8 */
	struct can_bittiming       bittiming;            /*    48    32 */
	/* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
	struct can_bittiming       data_bittiming;       /*    80    32 */
	const struct can_tdc_const  * tdc_const;         /*   112     8 */
	struct can_tdc             tdc;                  /*   120    12 */
	/* --- cacheline 2 boundary (128 bytes) was 4 bytes ago --- */
	unsigned int               bitrate_const_cnt;    /*   132     4 */
	const u32  *               bitrate_const;        /*   136     8 */
	const u32  *               data_bitrate_const;   /*   144     8 */
	unsigned int               data_bitrate_const_cnt; /*   152     4 */
	u32                        bitrate_max;          /*   156     4 */
	struct can_clock           clock;                /*   160     4 */
	unsigned int               termination_const_cnt; /*   164     4 */
	const u16  *               termination_const;    /*   168     8 */
	u16                        termination;          /*   176     2 */

	/* XXX 2 bytes hole, try to pack */

	enum can_state             state;                /*   180     4 */
	u32                        ctrlmode;             /*   184     4 */
	u32                        ctrlmode_supported;   /*   188     4 */
	/* --- cacheline 3 boundary (192 bytes) --- */
	u32                        ctrlmode_static;      /*   192     4 */
	int                        restart_ms;           /*   196     4 */
	struct delayed_work        restart_work;         /*   200   168 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 5 boundary (320 bytes) was 48 bytes ago --- */
	int                        (*do_set_bittiming)(struct net_device *); /*   368     8 */
	int                        (*do_set_data_bittiming)(struct net_device *); /*   376     8 */
	/* --- cacheline 6 boundary (384 bytes) --- */
	int                        (*do_set_mode)(struct net_device *, enum can_mode); /*   384     8 */
	int                        (*do_set_termination)(struct net_device *, u16); /*   392     8 */
	int                        (*do_get_state)(const struct net_device  *, enum can_state *); /*   400     8 */
	int                        (*do_get_berr_counter)(const struct net_device  *, struct can_berr_counter *); /*   408     8 */
	unsigned int               echo_skb_max;         /*   416     4 */

	/* XXX 4 bytes hole, try to pack */

	struct sk_buff * *         echo_skb;             /*   424     8 */

	/* size: 432, cachelines: 7, members: 31 */
	/* sum members: 426, holes: 2, sum holes: 6 */
	/* paddings: 1, sum paddings: 4 */
	/* last cacheline: 48 bytes */
};

Link: https://lore.kernel.org/r/20210224002008.4158-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/dev.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 4795da0eb949..27b275e463da 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -39,22 +39,23 @@ struct can_priv {
 	struct net_device *dev;
 	struct can_device_stats can_stats;
 
-	struct can_bittiming bittiming, data_bittiming;
 	const struct can_bittiming_const *bittiming_const,
 		*data_bittiming_const;
-	struct can_tdc tdc;
+	struct can_bittiming bittiming, data_bittiming;
 	const struct can_tdc_const *tdc_const;
+	struct can_tdc tdc;
 
-	const u16 *termination_const;
-	unsigned int termination_const_cnt;
-	u16 termination;
-	const u32 *bitrate_const;
 	unsigned int bitrate_const_cnt;
+	const u32 *bitrate_const;
 	const u32 *data_bitrate_const;
 	unsigned int data_bitrate_const_cnt;
 	u32 bitrate_max;
 	struct can_clock clock;
 
+	unsigned int termination_const_cnt;
+	const u16 *termination_const;
+	u16 termination;
+
 	enum can_state state;
 
 	/* CAN controller features - see include/uapi/linux/can/netlink.h */
-- 
2.30.2


