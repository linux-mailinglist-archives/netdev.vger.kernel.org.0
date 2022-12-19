Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F526510F4
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiLSRIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbiLSRIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:08:19 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83D1DEEE;
        Mon, 19 Dec 2022 09:08:17 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VXiEJp1_1671469693;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VXiEJp1_1671469693)
          by smtp.aliyun-inc.com;
          Tue, 20 Dec 2022 01:08:15 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 2/5] net/smc: choose loopback device in SMC-D communication
Date:   Tue, 20 Dec 2022 01:07:45 +0800
Message-Id: <1671469668-82691-3-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671469668-82691-1-git-send-email-guwen@linux.alibaba.com>
References: <1671469668-82691-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows SMC-D to use loopback device.

But noted that the implementation here is quiet simple and informal.
Loopback device will always be firstly chosen, and fallback happens
if loopback communication is impossible.

It needs to be discussed how client indicates to peer that multiple
SMC-D devices are available and how server picks a suitable one.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 net/smc/af_smc.c  | 55 +++++++++++++++++++++++++++++++++++++++++++++++++------
 net/smc/smc_clc.c |  4 +++-
 net/smc/smc_ism.c |  3 ++-
 3 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 9546c02..b9884c8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -979,6 +979,28 @@ static int smc_find_ism_device(struct smc_sock *smc, struct smc_init_info *ini)
 	return 0;
 }
 
+/* check if there is a lo device available for this connection. */
+static int smc_find_lo_device(struct smc_sock *smc, struct smc_init_info *ini)
+{
+	struct smcd_dev *sdev;
+
+	mutex_lock(&smcd_dev_list.mutex);
+	list_for_each_entry(sdev, &smcd_dev_list.list, list) {
+		if (sdev->is_loopback && !sdev->going_away &&
+		    (!ini->ism_peer_gid[0] ||
+		     !smc_ism_cantalk(ini->ism_peer_gid[0], ini->vlan_id,
+				      sdev))) {
+			ini->ism_dev[0] = sdev;
+			break;
+		}
+	}
+	mutex_unlock(&smcd_dev_list.mutex);
+	if (!ini->ism_dev[0])
+		return SMC_CLC_DECL_NOSMCDDEV;
+	ini->ism_chid[0] = smc_ism_get_chid(ini->ism_dev[0]);
+	return 0;
+}
+
 /* is chid unique for the ism devices that are already determined? */
 static bool smc_find_ism_v2_is_unique_chid(u16 chid, struct smc_init_info *ini,
 					   int cnt)
@@ -1044,10 +1066,20 @@ static int smc_find_proposal_devices(struct smc_sock *smc,
 {
 	int rc = 0;
 
-	/* check if there is an ism device available */
+	/* TODO:
+	 * How to indicate to peer if ism device and loopback
+	 * device are both available ?
+	 *
+	 * The RFC patch hasn't resolved this, just simply always
+	 * chooses loopback device first, and fallback if loopback
+	 * communication is impossible.
+	 *
+	 */
+	/* check if there is an ism or loopback device available */
 	if (!(ini->smcd_version & SMC_V1) ||
-	    smc_find_ism_device(smc, ini) ||
-	    smc_connect_ism_vlan_setup(smc, ini))
+	    (smc_find_lo_device(smc, ini) &&
+	    (smc_find_ism_device(smc, ini) ||
+	    smc_connect_ism_vlan_setup(smc, ini))))
 		ini->smcd_version &= ~SMC_V1;
 	/* else ISM V1 is supported for this connection */
 
@@ -2135,9 +2167,20 @@ static void smc_find_ism_v1_device_serv(struct smc_sock *new_smc,
 		goto not_found;
 	ini->is_smcd = true; /* prepare ISM check */
 	ini->ism_peer_gid[0] = ntohll(pclc_smcd->ism.gid);
-	rc = smc_find_ism_device(new_smc, ini);
-	if (rc)
-		goto not_found;
+
+	/* TODO:
+	 * How to know that peer has both loopback and ism device ?
+	 *
+	 * The RFC patch hasn't resolved this, simply tries loopback
+	 * device first, then ism device.
+	 */
+	/* find available loopback or ism device */
+	if (smc_find_lo_device(new_smc, ini)) {
+		rc = smc_find_ism_device(new_smc, ini);
+		if (rc)
+			goto not_found;
+	}
+
 	ini->ism_selected = 0;
 	rc = smc_listen_ism_init(new_smc, ini);
 	if (!rc)
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index dfb9797..3887692 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -486,7 +486,9 @@ static int smc_clc_prfx_set4_rcu(struct dst_entry *dst, __be32 ipv4,
 		return -ENODEV;
 
 	in_dev_for_each_ifa_rcu(ifa, in_dev) {
-		if (!inet_ifa_match(ipv4, ifa))
+		/* add loopback support */
+		if (inet_addr_type(dev_net(dst->dev), ipv4) != RTN_LOCAL &&
+		    !inet_ifa_match(ipv4, ifa))
 			continue;
 		prop->prefix_len = inet_mask_len(ifa->ifa_mask);
 		prop->outgoing_subnet = ifa->ifa_address & ifa->ifa_mask;
diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 911fe08..1d10435 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -227,7 +227,8 @@ static int smc_nl_handle_smcd_dev(struct smcd_dev *smcd,
 	if (nla_put_u8(skb, SMC_NLA_DEV_IS_CRIT, use_cnt > 0))
 		goto errattr;
 	memset(&smc_pci_dev, 0, sizeof(smc_pci_dev));
-	smc_set_pci_values(to_pci_dev(smcd->dev.parent), &smc_pci_dev);
+	if (!smcd->is_loopback)
+		smc_set_pci_values(to_pci_dev(smcd->dev.parent), &smc_pci_dev);
 	if (nla_put_u32(skb, SMC_NLA_DEV_PCI_FID, smc_pci_dev.pci_fid))
 		goto errattr;
 	if (nla_put_u16(skb, SMC_NLA_DEV_PCI_CHID, smc_pci_dev.pci_pchid))
-- 
1.8.3.1

