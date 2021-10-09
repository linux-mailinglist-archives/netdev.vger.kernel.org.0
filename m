Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128F5427A83
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 15:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbhJINRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 09:17:11 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:50282 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbhJINP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 09:15:27 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id ZC9zmoEn4UGqlZCAKm2if7; Sat, 09 Oct 2021 15:13:30 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 09 Oct 2021 15:13:30 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 2/3] can: dev: reorder struct can_priv members for better packing
Date:   Sat,  9 Oct 2021 22:13:03 +0900
Message-Id: <20211009131304.19729-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
References: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Save eight bytes of holes on x86-64 architectures by reordering the
members of struct can_priv.

Before:

| $ pahole -C can_priv drivers/net/can/dev/dev.o
| struct can_priv {
| 	struct net_device *        dev;                  /*     0     8 */
| 	struct can_device_stats    can_stats;            /*     8    24 */
| 	const struct can_bittiming_const  * bittiming_const; /*    32     8 */
| 	const struct can_bittiming_const  * data_bittiming_const; /*    40     8 */
| 	struct can_bittiming       bittiming;            /*    48    32 */
| 	/* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
| 	struct can_bittiming       data_bittiming;       /*    80    32 */
| 	const struct can_tdc_const  * tdc_const;         /*   112     8 */
| 	struct can_tdc             tdc;                  /*   120    12 */
| 	/* --- cacheline 2 boundary (128 bytes) was 4 bytes ago --- */
| 	unsigned int               bitrate_const_cnt;    /*   132     4 */
| 	const u32  *               bitrate_const;        /*   136     8 */
| 	const u32  *               data_bitrate_const;   /*   144     8 */
| 	unsigned int               data_bitrate_const_cnt; /*   152     4 */
| 	u32                        bitrate_max;          /*   156     4 */
| 	struct can_clock           clock;                /*   160     4 */
| 	unsigned int               termination_const_cnt; /*   164     4 */
| 	const u16  *               termination_const;    /*   168     8 */
| 	u16                        termination;          /*   176     2 */
|
| 	/* XXX 6 bytes hole, try to pack */
|
| 	struct gpio_desc *         termination_gpio;     /*   184     8 */
| 	/* --- cacheline 3 boundary (192 bytes) --- */
| 	u16                        termination_gpio_ohms[2]; /*   192     4 */
| 	enum can_state             state;                /*   196     4 */
| 	u32                        ctrlmode;             /*   200     4 */
| 	u32                        ctrlmode_supported;   /*   204     4 */
| 	int                        restart_ms;           /*   208     4 */
|
| 	/* XXX 4 bytes hole, try to pack */
|
| 	struct delayed_work        restart_work;         /*   216    88 */
|
| 	/* XXX last struct has 4 bytes of padding */
|
| 	/* --- cacheline 4 boundary (256 bytes) was 48 bytes ago --- */
| 	int                        (*do_set_bittiming)(struct net_device *); /*   304     8 */
| 	int                        (*do_set_data_bittiming)(struct net_device *); /*   312     8 */
| 	/* --- cacheline 5 boundary (320 bytes) --- */
| 	int                        (*do_set_mode)(struct net_device *, enum can_mode); /*   320     8 */
| 	int                        (*do_set_termination)(struct net_device *, u16); /*   328     8 */
| 	int                        (*do_get_state)(const struct net_device  *, enum can_state *); /*   336     8 */
| 	int                        (*do_get_berr_counter)(const struct net_device  *, struct can_berr_counter *); /*   344     8 */
| 	unsigned int               echo_skb_max;         /*   352     4 */
|
| 	/* XXX 4 bytes hole, try to pack */
|
| 	struct sk_buff * *         echo_skb;             /*   360     8 */
|
| 	/* size: 368, cachelines: 6, members: 32 */
| 	/* sum members: 354, holes: 3, sum holes: 14 */
| 	/* paddings: 1, sum paddings: 4 */
| 	/* last cacheline: 48 bytes */
| };

After:

| $ pahole -C can_priv drivers/net/can/dev/dev.o
| struct can_priv {
| 	struct net_device *        dev;                  /*     0     8 */
| 	struct can_device_stats    can_stats;            /*     8    24 */
| 	const struct can_bittiming_const  * bittiming_const; /*    32     8 */
| 	const struct can_bittiming_const  * data_bittiming_const; /*    40     8 */
| 	struct can_bittiming       bittiming;            /*    48    32 */
| 	/* --- cacheline 1 boundary (64 bytes) was 16 bytes ago --- */
| 	struct can_bittiming       data_bittiming;       /*    80    32 */
| 	const struct can_tdc_const  * tdc_const;         /*   112     8 */
| 	struct can_tdc             tdc;                  /*   120    12 */
| 	/* --- cacheline 2 boundary (128 bytes) was 4 bytes ago --- */
| 	unsigned int               bitrate_const_cnt;    /*   132     4 */
| 	const u32  *               bitrate_const;        /*   136     8 */
| 	const u32  *               data_bitrate_const;   /*   144     8 */
| 	unsigned int               data_bitrate_const_cnt; /*   152     4 */
| 	u32                        bitrate_max;          /*   156     4 */
| 	struct can_clock           clock;                /*   160     4 */
| 	unsigned int               termination_const_cnt; /*   164     4 */
| 	const u16  *               termination_const;    /*   168     8 */
| 	u16                        termination;          /*   176     2 */
|
| 	/* XXX 6 bytes hole, try to pack */
|
| 	struct gpio_desc *         termination_gpio;     /*   184     8 */
| 	/* --- cacheline 3 boundary (192 bytes) --- */
| 	u16                        termination_gpio_ohms[2]; /*   192     4 */
| 	unsigned int               echo_skb_max;         /*   196     4 */
| 	struct sk_buff * *         echo_skb;             /*   200     8 */
| 	enum can_state             state;                /*   208     4 */
| 	u32                        ctrlmode;             /*   212     4 */
| 	u32                        ctrlmode_supported;   /*   216     4 */
| 	int                        restart_ms;           /*   220     4 */
| 	struct delayed_work        restart_work;         /*   224    88 */
|
| 	/* XXX last struct has 4 bytes of padding */
|
| 	/* --- cacheline 4 boundary (256 bytes) was 56 bytes ago --- */
| 	int                        (*do_set_bittiming)(struct net_device *); /*   312     8 */
| 	/* --- cacheline 5 boundary (320 bytes) --- */
| 	int                        (*do_set_data_bittiming)(struct net_device *); /*   320     8 */
| 	int                        (*do_set_mode)(struct net_device *, enum can_mode); /*   328     8 */
| 	int                        (*do_set_termination)(struct net_device *, u16); /*   336     8 */
| 	int                        (*do_get_state)(const struct net_device  *, enum can_state *); /*   344     8 */
| 	int                        (*do_get_berr_counter)(const struct net_device  *, struct can_berr_counter *); /*   352     8 */
|
| 	/* size: 360, cachelines: 6, members: 32 */
| 	/* sum members: 354, holes: 1, sum holes: 6 */
| 	/* paddings: 1, sum paddings: 4 */
| 	/* last cacheline: 40 bytes */
| };

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/linux/can/dev.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 2381ad9e0814..78e49b1e001c 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -64,6 +64,9 @@ struct can_priv {
 	struct gpio_desc *termination_gpio;
 	u16 termination_gpio_ohms[CAN_TERMINATION_GPIO_MAX];
 
+	unsigned int echo_skb_max;
+	struct sk_buff **echo_skb;
+
 	enum can_state state;
 
 	/* CAN controller features - see include/uapi/linux/can/netlink.h */
@@ -82,9 +85,6 @@ struct can_priv {
 	int (*do_get_berr_counter)(const struct net_device *dev,
 				   struct can_berr_counter *bec);
 
-	unsigned int echo_skb_max;
-	struct sk_buff **echo_skb;
-
 #ifdef CONFIG_CAN_LEDS
 	struct led_trigger *tx_led_trig;
 	char tx_led_trig_name[CAN_LED_NAME_SZ];
-- 
2.32.0

