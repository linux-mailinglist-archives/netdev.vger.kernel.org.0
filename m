Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86844F5E89
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiDFNFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbiDFNFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:05:07 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18E5468245
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 02:36:56 -0700 (PDT)
X-QQ-mid: bizesmtp62t1649237795tevo88r8
Received: from localhost.localdomain.localdoma ( [116.228.45.98])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 06 Apr 2022 17:36:34 +0800 (CST)
X-QQ-SSF: 01000000002000903000B00A0000000
X-QQ-FEAT: khFrY5NuiqQ7qMv4VncgwibZeQOLVAjwrTbQ9OqwxmbaSNvi3Dbbxat0zKwxX
        3Wf+pE00cwHqGkWQwUROvqzVVhb6rDTn5hAkTrZsKtHMY+ZzAY7oJAC5ykBfdgMRjgaU2Zf
        JsNuWjwWlBitStUD+DQ6tVrZQVSdOX9A2Ve5dXhzDO+Qc8xz784n/qGNKevs/VpNKWWJelP
        BKP2phOaTCJKPMCDSsXWkmUe9YiwEYXh9+9LuUmSOBsRAH84/bNXsD2fn169XZW0xbLRDYO
        OcbCAed8PaRv31lHiN2wREJoo1zcjKUpb2OmvWUGh7I4VVBEYzRH8YlaMxpMsY/s5WhvnWB
        rZOTGICmqymEiOkcG4=
X-QQ-GoodBg: 0
From:   Michael Qiu <qiudayu@archeros.com>
To:     parav@nvidia.com, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Michael Qiu <qiudayu@archeros.com>
Subject: [PATCH iproute2 v2] vdpa: Add virtqueue pairs set capacity
Date:   Wed,  6 Apr 2022 05:36:31 -0400
Message-Id: <1649237791-31723-1-git-send-email-qiudayu@archeros.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1648113553-10547-1-git-send-email-08005325@163.com>
References: <1648113553-10547-1-git-send-email-08005325@163.com>
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:archeros.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vdpa framework not only support query the max virtqueue pair, but
also for the set action.

This patch enable this capacity, and it is very useful for VMs
 who needs multiqueue support.

After enable this feature, we could simply use below command to
create multi-queue support:

vdpa dev add mgmtdev pci/0000:03:10.3 name foo mac 56:d0:2f:03:c9:6d max_vqp 6

Signed-off-by: Michael Qiu <qiudayu@archeros.com>
---

v2 --> v1:
    rename "max_vq_pairs" to "max_vqp"

    extend the man page for this addition with example
---
 man/man8/vdpa-dev.8 |  9 +++++++++
 vdpa/vdpa.c         | 19 ++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
index aa21ae3..a401115 100644
--- a/man/man8/vdpa-dev.8
+++ b/man/man8/vdpa-dev.8
@@ -74,6 +74,10 @@ This is applicable only for the network type of vdpa device. This is optional.
 - specifies the mtu for the new vdpa device.
 This is applicable only for the network type of vdpa device. This is optional.
 
+.BI max_vqp " MAX_VQP"
+- specifies the max queue pairs for the new vdpa device.
+This is applicable only for the network type of vdpa device. This is optional.
+
 .SS vdpa dev del - Delete the vdpa device.
 
 .PP
@@ -119,6 +123,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55 mtu 9000
 Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55 and mtu of 9000 bytes.
 .RE
 .PP
+vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55 mtu 9000 max_vqp 6
+.RS 4
+Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55, mtu of 9000 bytes and max virtqueue pairs of 6.
+.RE
+.PP
 vdpa dev del foo
 .RS 4
 Delete the vdpa device named foo which was previously created.
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e47..104c503 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -23,6 +23,7 @@
 #define VDPA_OPT_VDEV_HANDLE		BIT(3)
 #define VDPA_OPT_VDEV_MAC		BIT(4)
 #define VDPA_OPT_VDEV_MTU		BIT(5)
+#define VDPA_OPT_VDEV_QUEUE_PAIRS	BIT(6)
 
 struct vdpa_opts {
 	uint64_t present; /* flags of present items */
@@ -32,6 +33,7 @@ struct vdpa_opts {
 	unsigned int device_id;
 	char mac[ETH_ALEN];
 	uint16_t mtu;
+	uint16_t max_vqp;
 };
 
 struct vdpa {
@@ -219,6 +221,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 			     sizeof(opts->mac), opts->mac);
 	if (opts->present & VDPA_OPT_VDEV_MTU)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
+	if (opts->present & VDPA_OPT_VDEV_QUEUE_PAIRS)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -287,6 +291,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_VDEV_MTU;
+		} else if ((strcmp(*argv, "max_vqp") == 0) &&
+			   (o_all & VDPA_OPT_VDEV_QUEUE_PAIRS)) {
+			NEXT_ARG_FWD();
+			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
+			if (err)
+				return err;
+
+			NEXT_ARG_FWD();
+			o_found |= VDPA_OPT_VDEV_QUEUE_PAIRS;
 		} else {
 			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
 			return -EINVAL;
@@ -467,7 +480,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
 static void cmd_dev_help(void)
 {
 	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
-	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [ max_vqp N ]\n");
 	fprintf(stderr, "       vdpa dev del DEV\n");
 	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
 }
@@ -557,7 +570,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
 					  NLM_F_REQUEST | NLM_F_ACK);
 	err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
 				  VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
-				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
+				  VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU | VDPA_OPT_VDEV_QUEUE_PAIRS);
 	if (err)
 		return err;
 
@@ -603,7 +616,7 @@ static void pr_out_dev_net_config(struct nlattr **tb)
 	}
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]) {
 		val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MAX_VQP]);
-		print_uint(PRINT_ANY, "max_vq_pairs", "max_vq_pairs %d ",
+		print_uint(PRINT_ANY, "max_vqp", "max_vqp %d ",
 			     val_u16);
 	}
 	if (tb[VDPA_ATTR_DEV_NET_CFG_MTU]) {
-- 
1.8.3.1


