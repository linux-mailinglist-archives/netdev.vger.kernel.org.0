Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215A7304AD6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbhAZE40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:56:26 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:29596 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbhAYKok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 05:44:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611571262;
        s=strato-dkim-0002; d=hartkopp.net;
        h=Message-Id:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=EaTZMYup884BzWi92+HHYjKXVVZIKnErZ2yMyFuBn8s=;
        b=d7UQH4jGo8YeIdl4ET96TJyCWRwgv/8v2udb0zvCu/90zghHfVRjpbAZlDX15GsKsN
        fbnvcYHN6IoLbF16Bupy+v8Np4SvrHeZKz8nDqoG+Bie6zwxX7HVzsFTuKltbfMfDY9I
        uXb0dkXlCxgQU8khPdRDNknwDpltV/Q1LMbEvud2yF/KSRKzzeCdhVXP7lwL/MLXJgKv
        Ciae3Dl5NBx3aCC8Gn267BKiu/+ewjbNAWFla6fsu9qRSNNpQqLNE0OMpxnQfkKPJy9g
        buioYoI0Q1aWc5J9SOhqPZbchVeuXl6E7+pLU++7YiUfQ8/JDzz5L3qaVdhenL+f+7uP
        j0uQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0k+8CejudJy4jsSstZQ=="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id k075acx0PAf1xWB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 25 Jan 2021 11:41:01 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame LEN8_DLC support
Date:   Mon, 25 Jan 2021 11:40:55 +0100
Message-Id: <20210125104055.79882-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The len8_dlc element is filled by the CAN interface driver and used for CAN
frame creation by the CAN driver when the CAN_CTRLMODE_CC_LEN8_DLC flag is
supported by the driver and enabled via netlink configuration interface.

Add the command line support for cc-len8-dlc for Linux 5.11+

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 ip/iplink_can.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 735ab941..6a26f3ff 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -35,10 +35,11 @@ static void print_usage(FILE *f)
 		"\t[ one-shot { on | off } ]\n"
 		"\t[ berr-reporting { on | off } ]\n"
 		"\t[ fd { on | off } ]\n"
 		"\t[ fd-non-iso { on | off } ]\n"
 		"\t[ presume-ack { on | off } ]\n"
+		"\t[ cc-len8-dlc { on | off } ]\n"
 		"\n"
 		"\t[ restart-ms TIME-MS ]\n"
 		"\t[ restart ]\n"
 		"\n"
 		"\t[ termination { 0..65535 } ]\n"
@@ -101,10 +102,11 @@ static void print_ctrlmode(FILE *f, __u32 cm)
 	_PF(CAN_CTRLMODE_ONE_SHOT, "ONE-SHOT");
 	_PF(CAN_CTRLMODE_BERR_REPORTING, "BERR-REPORTING");
 	_PF(CAN_CTRLMODE_FD, "FD");
 	_PF(CAN_CTRLMODE_FD_NON_ISO, "FD-NON-ISO");
 	_PF(CAN_CTRLMODE_PRESUME_ACK, "PRESUME-ACK");
+	_PF(CAN_CTRLMODE_CC_LEN8_DLC, "CC-LEN8-DLC");
 #undef _PF
 	if (cm)
 		print_hex(PRINT_ANY, NULL, "%x", cm);
 	close_json_array(PRINT_ANY, "> ");
 }
@@ -209,10 +211,14 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 				     CAN_CTRLMODE_FD_NON_ISO);
 		} else if (matches(*argv, "presume-ack") == 0) {
 			NEXT_ARG();
 			set_ctrlmode("presume-ack", *argv, &cm,
 				     CAN_CTRLMODE_PRESUME_ACK);
+		} else if (matches(*argv, "cc-len8-dlc") == 0) {
+			NEXT_ARG();
+			set_ctrlmode("cc-len8-dlc", *argv, &cm,
+				     CAN_CTRLMODE_CC_LEN8_DLC);
 		} else if (matches(*argv, "restart") == 0) {
 			__u32 val = 1;
 
 			addattr32(n, 1024, IFLA_CAN_RESTART, val);
 		} else if (matches(*argv, "restart-ms") == 0) {
-- 
2.29.2

