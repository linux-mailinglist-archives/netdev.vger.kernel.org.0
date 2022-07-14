Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2145574977
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiGNJqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiGNJps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:45:48 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A624B4BC;
        Thu, 14 Jul 2022 02:45:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VJIcqPy_1657791941;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VJIcqPy_1657791941)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 17:45:43 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/6] net/smc: Extend SMC-R link group netlink attribute
Date:   Thu, 14 Jul 2022 17:44:05 +0800
Message-Id: <1657791845-1060-7-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
References: <1657791845-1060-1-git-send-email-guwen@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend SMC-R link group netlink attribute SMC_GEN_LGR_SMCR.
Introduce SMC_NLA_LGR_R_BUF_TYPE to show the buffer type of
SMC-R link group.

Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
---
 include/uapi/linux/smc.h | 1 +
 net/smc/smc_core.c       | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 693f549..bb4dacc 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -124,6 +124,7 @@ enum {
 	SMC_NLA_LGR_R_V2,		/* nest */
 	SMC_NLA_LGR_R_NET_COOKIE,	/* u64 */
 	SMC_NLA_LGR_R_PAD,		/* flag */
+	SMC_NLA_LGR_R_BUF_TYPE,		/* u8 */
 	__SMC_NLA_LGR_R_MAX,
 	SMC_NLA_LGR_R_MAX = __SMC_NLA_LGR_R_MAX - 1
 };
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index f26770c..ff49a11 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -347,6 +347,8 @@ static int smc_nl_fill_lgr(struct smc_link_group *lgr,
 		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_R_TYPE, lgr->type))
 		goto errattr;
+	if (nla_put_u8(skb, SMC_NLA_LGR_R_BUF_TYPE, lgr->buf_type))
+		goto errattr;
 	if (nla_put_u8(skb, SMC_NLA_LGR_R_VLAN_ID, lgr->vlan_id))
 		goto errattr;
 	if (nla_put_u64_64bit(skb, SMC_NLA_LGR_R_NET_COOKIE,
-- 
1.8.3.1

