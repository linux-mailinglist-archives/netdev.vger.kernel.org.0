Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B0D44294D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhKBI1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 04:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhKBI1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 04:27:13 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F72AC061764
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 01:24:38 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:5050:fce2:2424:248f])
        by laurent.telenet-ops.be with bizsmtp
        id DLQb2600B0xGf5L01LQbSu; Tue, 02 Nov 2021 09:24:36 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mhp5v-009fdO-5X; Tue, 02 Nov 2021 09:24:35 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mhp5u-00G21O-N2; Tue, 02 Nov 2021 09:24:34 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [-next] net: marvell: prestera: Add explicit padding
Date:   Tue,  2 Nov 2021 09:24:33 +0100
Message-Id: <20211102082433.3820514-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On m68k:

    In function ‘prestera_hw_build_tests’,
	inlined from ‘prestera_hw_switch_init’ at drivers/net/ethernet/marvell/prestera/prestera_hw.c:788:2:
    ././include/linux/compiler_types.h:335:38: error: call to ‘__compiletime_assert_345’ declared with attribute error: BUILD_BUG_ON failed: sizeof(struct prestera_msg_switch_attr_req) != 16
    ...

The driver assumes structure members are naturally aligned, but does not
add explicit padding, thus breaking architectures where integral values
are not always naturally aligned (e.g. on m68k, __alignof(int) is 2, not
4).

Fixes: bb5dbf2cc64d5cfa ("net: marvell: prestera: add firmware v4.0 support")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Compile-tested only.

BTW, I sincerely doubt the use of __packed on structs like:

    union prestera_msg_switch_param {
	    u8 mac[ETH_ALEN];
	    __le32 ageing_timeout_ms;
    } __packed;

This struct is only used as a member in another struct, where it is
be naturally aligned anyway.

Some of the other __packed attributes look fishy to me, too.
---
 drivers/net/ethernet/marvell/prestera/prestera_hw.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 41ba17cb29657392..4f5f52dcdd9d2814 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -189,6 +189,7 @@ struct prestera_msg_switch_attr_req {
 	struct prestera_msg_cmd cmd;
 	__le32 attr;
 	union prestera_msg_switch_param param;
+	u8 pad[2];
 };
 
 struct prestera_msg_switch_init_resp {
@@ -313,6 +314,7 @@ struct prestera_msg_port_info_resp {
 	__le32 hw_id;
 	__le32 dev_id;
 	__le16 fp_id;
+	u8 pad[2];
 };
 
 struct prestera_msg_vlan_req {
@@ -345,11 +347,13 @@ struct prestera_msg_bridge_req {
 	__le32 port;
 	__le32 dev;
 	__le16 bridge;
+	u8 pad[2];
 };
 
 struct prestera_msg_bridge_resp {
 	struct prestera_msg_ret ret;
 	__le16 bridge;
+	u8 pad[2];
 };
 
 struct prestera_msg_acl_action {
@@ -408,16 +412,19 @@ struct prestera_msg_acl_ruleset_bind_req {
 	__le32 port;
 	__le32 dev;
 	__le16 ruleset_id;
+	u8 pad[2];
 };
 
 struct prestera_msg_acl_ruleset_req {
 	struct prestera_msg_cmd cmd;
 	__le16 id;
+	u8 pad[2];
 };
 
 struct prestera_msg_acl_ruleset_resp {
 	struct prestera_msg_ret ret;
 	__le16 id;
+	u8 pad[2];
 };
 
 struct prestera_msg_span_req {
@@ -425,11 +432,13 @@ struct prestera_msg_span_req {
 	__le32 port;
 	__le32 dev;
 	u8 id;
+	u8 pad[3];
 };
 
 struct prestera_msg_span_resp {
 	struct prestera_msg_ret ret;
 	u8 id;
+	u8 pad[3];
 };
 
 struct prestera_msg_stp_req {
@@ -443,6 +452,7 @@ struct prestera_msg_stp_req {
 struct prestera_msg_rxtx_req {
 	struct prestera_msg_cmd cmd;
 	u8 use_sdma;
+	u8 pad[3];
 };
 
 struct prestera_msg_rxtx_resp {
@@ -455,12 +465,14 @@ struct prestera_msg_lag_req {
 	__le32 port;
 	__le32 dev;
 	__le16 lag_id;
+	u8 pad[2];
 };
 
 struct prestera_msg_cpu_code_counter_req {
 	struct prestera_msg_cmd cmd;
 	u8 counter_type;
 	u8 code;
+	u8 pad[2];
 };
 
 struct mvsw_msg_cpu_code_counter_ret {
-- 
2.25.1

