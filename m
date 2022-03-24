Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9EF4E60FD
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348801AbiCXJV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 05:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237756AbiCXJV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 05:21:27 -0400
Received: from m12-16.163.com (m12-16.163.com [220.181.12.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F7D25A592
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=/+Yyru6eznxWnIS5vS
        g8ztqHwIA+k1oSMs1Rz4ZXzVE=; b=El6yNZ4oySvOwvtcbkHeW7wyxatXf78yV4
        OkU+6zy/omXerPCRRBR3x9I3R9edK15vOuaIwub8VN6a8bdyvRadNgBvLN5qAeO/
        pfayrJFhbQoC7JPEqxjYf1NcGuhAUQrpIUrdha4KZO4sJC89Y84qq2Kq5/7yvLi0
        VTUE9lMko=
Received: from localhost.localdomain.localdomain (unknown [116.228.45.98])
        by smtp12 (Coremail) with SMTP id EMCowAA38huTNzxisgjzAg--.8498S2;
        Thu, 24 Mar 2022 17:19:15 +0800 (CST)
From:   08005325@163.com
To:     netdev@vger.kernel.org
Cc:     parav@nvidia.com, stephen@networkplumber.org,
        Michael Qiu <qiudayu@archeros.com>
Subject: [PATCH iproute2] vdpa: Add virtqueue pairs set capacity
Date:   Thu, 24 Mar 2022 05:19:13 -0400
Message-Id: <1648113553-10547-1-git-send-email-08005325@163.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: EMCowAA38huTNzxisgjzAg--.8498S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGF1fXFy3Gr4fKFy7ZF4kXrb_yoW5XrWUpa
        98A3W5W3yFqrZrAa47JF4kWwn3CwnIg34q9Fnavw1jyF43GrykJ3s29F4xur1vkFyrXa4f
        uw4YyF15tF4DXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5txhUUUUU=
X-Originating-IP: [116.228.45.98]
X-CM-SenderInfo: qqyqikqtsvqiywtou0bp/xtbBrRfNrF75eTve6wAAsL
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Qiu <qiudayu@archeros.com>

vdpa framework not only support query the max virtqueue pair, but
also for the set action.

This patch enable this capacity, and it is very useful for VMs
 who needs multiqueue support.

Signed-off-by: Michael Qiu <qiudayu@archeros.com>
---
 vdpa/vdpa.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e47..434d68e 100644
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
+	uint16_t max_vq_pairs;
 };
 
 struct vdpa {
@@ -219,6 +221,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
 			     sizeof(opts->mac), opts->mac);
 	if (opts->present & VDPA_OPT_VDEV_MTU)
 		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
+	if (opts->present & VDPA_OPT_VDEV_QUEUE_PAIRS)
+		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vq_pairs);
 }
 
 static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
@@ -287,6 +291,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
 
 			NEXT_ARG_FWD();
 			o_found |= VDPA_OPT_VDEV_MTU;
+		} else if ((strcmp(*argv, "max_vq_pairs") == 0) &&
+			   (o_all & VDPA_OPT_VDEV_QUEUE_PAIRS)) {
+			NEXT_ARG_FWD();
+			err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vq_pairs);
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
+	fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [ max_vq_pairs N ]\n");
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
 
-- 
1.8.3.1

