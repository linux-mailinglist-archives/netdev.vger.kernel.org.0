Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8B3530903
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 07:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbiEWFwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 01:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiEWFwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 01:52:03 -0400
Received: from corp-front08-corp.i.nease.net (corp-front08-corp.i.nease.net [59.111.134.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45666477;
        Sun, 22 May 2022 22:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:MIME-Version:Content-Transfer-Encoding; bh=2SdOn
        bcxJLMl7W/R+ogaGZHqr1mDU28XhhJYQ8UJrNk=; b=gEKAwbDHAIacTe7WgA09w
        UYcT1iGSlbi/M4fs1l9Dv5uOY2xVYksHxDRjOE+RoEI1YAxlQTQtdZE2co3bG988
        Qg1vfelL00LAOiYzzmBLP3fWooREYFrHhCCdSjOFQrRW2R257iYhXax+WcoZWxeP
        ffBw24mYN/mrK7wIZs+7nY=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front08-corp.i.nease.net (Coremail) with SMTP id nhDICgB3twPMIItizVBhAA--.44228S2;
        Mon, 23 May 2022 13:51:09 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ubraun@linux.ibm.com,
        liuyacan <liuyacan@corp.netease.com>
Subject: [PATCH net] net/smc: fix listen processing for SMC-Rv2
Date:   Mon, 23 May 2022 13:50:56 +0800
Message-Id: <20220523055056.2078994-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nhDICgB3twPMIItizVBhAA--.44228S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF17KFWUJr4xtF4xWF1kuFg_yoWrJF1fpa
        1Ykry3CFs5GFs3Grs3tF15Zr4rZw18try8G3srGr1FkwnrtryrtryxXF4j9FZxJFW3t3WI
        vFW8Ar1fWw15taDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUULYb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84
        ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9vy-n0Xa0_Xr1Utr1k
        JwI_Jr4ln4vE4IxY62xKV4CY8xCE548m6r4UJryUGwAS0I0E0xvYzxvE52x082IY62kv04
        87Mc804VCqF7xvr2I5Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
        AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwAKzVCY
        07xG64k0F24l7I0Y64k_MxkI7II2jI8vz4vEwIxGrwCF04k20xvY0x0EwIxGrwCF72vEw2
        IIxxk0rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7vE0wC20s026c02F40E14v26r1j6r18
        MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr4
        1lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1l
        IxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4
        A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRp6wAUUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760cBigAAsE
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: liuyacan <liuyacan@corp.netease.com>

In the process of checking whether RDMAv2 is available, the current
implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
smc buf desc, but the latter may fail. Unfortunately, the caller
will only check the former. In this case, a NULL pointer reference
will occur in smc_clc_send_confirm_accept() when accessing
conn->rmb_desc.

This patch does two things:
1. Use the return code to determine whether V2 is available.
2. If the return code is NODEV, continue to check whether V1 is
available.

Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
Signed-off-by: liuyacan <liuyacan@corp.netease.com>
---
 net/smc/af_smc.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 45a24d242..d3de54b70 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2093,13 +2093,13 @@ static int smc_listen_rdma_reg(struct smc_sock *new_smc, bool local_first)
 	return 0;
 }
 
-static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
-					 struct smc_clc_msg_proposal *pclc,
-					 struct smc_init_info *ini)
+static int smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
+					struct smc_clc_msg_proposal *pclc,
+					struct smc_init_info *ini)
 {
 	struct smc_clc_v2_extension *smc_v2_ext;
 	u8 smcr_version;
-	int rc;
+	int rc = 0;
 
 	if (!(ini->smcr_version & SMC_V2) || !smcr_indicated(ini->smc_type_v2))
 		goto not_found;
@@ -2117,26 +2117,31 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 	ini->smcrv2.saddr = new_smc->clcsock->sk->sk_rcv_saddr;
 	ini->smcrv2.daddr = smc_ib_gid_to_ipv4(smc_v2_ext->roce);
 	rc = smc_find_rdma_device(new_smc, ini);
-	if (rc) {
-		smc_find_ism_store_rc(rc, ini);
+	if (rc)
 		goto not_found;
-	}
+
 	if (!ini->smcrv2.uses_gateway)
 		memcpy(ini->smcrv2.nexthop_mac, pclc->lcl.mac, ETH_ALEN);
 
 	smcr_version = ini->smcr_version;
 	ini->smcr_version = SMC_V2;
 	rc = smc_listen_rdma_init(new_smc, ini);
-	if (!rc)
-		rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
-	if (!rc)
-		return;
-	ini->smcr_version = smcr_version;
-	smc_find_ism_store_rc(rc, ini);
+	if (rc) {
+		ini->smcr_version = smcr_version;
+		goto not_found;
+	}
+	rc = smc_listen_rdma_reg(new_smc, ini->first_contact_local);
+	if (rc) {
+		ini->smcr_version = smcr_version;
+		goto not_found;
+	}
+	return 0;
 
 not_found:
+	rc = rc ?: SMC_CLC_DECL_NOSMCDEV;
 	ini->smcr_version &= ~SMC_V2;
 	ini->check_smcrv2 = false;
+	return rc;
 }
 
 static int smc_find_rdma_v1_device_serv(struct smc_sock *new_smc,
@@ -2169,6 +2174,7 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 				  struct smc_init_info *ini)
 {
 	int prfx_rc;
+	int rc;
 
 	/* check for ISM device matching V2 proposed device */
 	smc_find_ism_v2_device_serv(new_smc, pclc, ini);
@@ -2196,14 +2202,18 @@ static int smc_listen_find_device(struct smc_sock *new_smc,
 		return ini->rc ?: SMC_CLC_DECL_NOSMCDDEV;
 
 	/* check if RDMA V2 is available */
-	smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
-	if (ini->smcrv2.ib_dev_v2)
+	rc = smc_find_rdma_v2_device_serv(new_smc, pclc, ini);
+	if (!rc)
 		return 0;
 
+	/* skip V1 check if V2 is unavailable for non-Device reason */
+	if (rc != SMC_CLC_DECL_NOSMCDEV &&
+	    rc != SMC_CLC_DECL_NOSMCRDEV &&
+	    rc != SMC_CLC_DECL_NOSMCDDEV)
+		return rc;
+
 	/* check if RDMA V1 is available */
 	if (!prfx_rc) {
-		int rc;
-
 		rc = smc_find_rdma_v1_device_serv(new_smc, pclc, ini);
 		smc_find_ism_store_rc(rc, ini);
 		return (!rc) ? 0 : ini->rc;
-- 
2.20.1

