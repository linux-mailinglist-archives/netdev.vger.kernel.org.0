Return-Path: <netdev+bounces-699-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE19D6F916C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 13:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B692B1C21A40
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 11:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DFA38476;
	Sat,  6 May 2023 11:14:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CEDA20
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 11:14:23 +0000 (UTC)
X-Greylist: delayed 597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 06 May 2023 04:14:22 PDT
Received: from mailout02.t-online.de (mailout02.t-online.de [194.25.134.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966D06E8F;
	Sat,  6 May 2023 04:14:22 -0700 (PDT)
Received: from fwd86.dcpf.telekom.de (fwd86.aul.t-online.de [10.223.144.112])
	by mailout02.t-online.de (Postfix) with SMTP id C01B9217FF;
	Sat,  6 May 2023 12:57:04 +0200 (CEST)
Received: from linux-vm.fritz.box ([89.182.234.199]) by fwd86.t-online.de
	with (TLSv1.3:TLS_AES_256_GCM_SHA384 encrypted)
	esmtp id 1pvFb6-4KbTvd0; Sat, 6 May 2023 12:57:04 +0200
From: Carsten Schmidt <carsten.schmidt-achim@t-online.de>
To: 
Cc: socketcan@hartkopp.net,
	Carsten Schmidt <carsten.schmidt-achim@t-online.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jimmy Assarsson <extja@kvaser.com>,
	Anssi Hannula <anssi.hannula@bitwise.fi>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	linux-can@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] can: kvaser_usb_leaf: Implement CAN 2.0 raw DLC functionality.
Date: Sat,  6 May 2023 12:55:22 +0200
Message-Id: <20230506105529.4023-1-carsten.schmidt-achim@t-online.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TOI-EXPURGATEID: 150726::1683370624-AF7FDC11-8EA3E313/0/0 CLEAN NORMAL
X-TOI-MSGID: 990f88d3-ea3a-4ba4-90d4-32b76eb17d4e
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
	RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Signed-off-by: Carsten Schmidt <carsten.schmidt-achim@t-online.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 1c2f99ce4c6c..713b633773b1 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -573,7 +573,7 @@ kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			cmd->u.tx_can.data[1] = cf->can_id & 0x3f;
 		}
 
-		cmd->u.tx_can.data[5] = cf->len;
+		cmd->u.tx_can.data[5] = can_get_cc_dlc(cf, priv->can.ctrlmode);
 		memcpy(&cmd->u.tx_can.data[6], cf->data, cf->len);
 
 		if (cf->can_id & CAN_RTR_FLAG)
@@ -1349,7 +1349,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 		else
 			cf->can_id &= CAN_SFF_MASK;
 
-		cf->len = can_cc_dlc2len(cmd->u.leaf.log_message.dlc);
+		can_frame_set_cc_len(cf, cmd->u.leaf.log_message.dlc & 0xF, priv->can.ctrlmode);
 
 		if (cmd->u.leaf.log_message.flags & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
@@ -1367,7 +1367,7 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 			cf->can_id |= CAN_EFF_FLAG;
 		}
 
-		cf->len = can_cc_dlc2len(rx_data[5]);
+		can_frame_set_cc_len(cf, rx_data[5] & 0xF, priv->can.ctrlmode);
 
 		if (cmd->u.rx_can_header.flag & MSG_FLAG_REMOTE_FRAME)
 			cf->can_id |= CAN_RTR_FLAG;
@@ -1702,6 +1702,7 @@ static int kvaser_usb_leaf_init_card(struct kvaser_usb *dev)
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 
 	card_data->ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
+	card_data->ctrlmode_supported |= CAN_CTRLMODE_CC_LEN8_DLC;
 
 	return 0;
 }
-- 
2.34.1


