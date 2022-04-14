Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3720350117B
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 16:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346501AbiDNO0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245045AbiDNN7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 09:59:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F9C1C0;
        Thu, 14 Apr 2022 06:57:01 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KfLZ46JfHzgYdv;
        Thu, 14 Apr 2022 21:55:08 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 14 Apr
 2022 21:56:58 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sdf@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <pabeni@redhat.com>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf-next v3 2/3] net: change skb_ensure_writable()'s write_len param to unsigned int type
Date:   Thu, 14 Apr 2022 21:59:01 +0800
Message-ID: <20220414135902.100914-3-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220414135902.100914-1-liujian56@huawei.com>
References: <20220414135902.100914-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both pskb_may_pull() and skb_clone_writable()'s length parameters are of
type unsigned int already.
Therefore, change this function's write_len param to unsigned int type.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 include/linux/skbuff.h | 2 +-
 net/core/skbuff.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3a30cae8b0a5..fe8990ce52a8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3886,7 +3886,7 @@ struct sk_buff *skb_segment(struct sk_buff *skb, netdev_features_t features);
 struct sk_buff *skb_segment_list(struct sk_buff *skb, netdev_features_t features,
 				 unsigned int offset);
 struct sk_buff *skb_vlan_untag(struct sk_buff *skb);
-int skb_ensure_writable(struct sk_buff *skb, int write_len);
+int skb_ensure_writable(struct sk_buff *skb, unsigned int write_len);
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci);
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 30b523fa4ad2..a84e00e44ad2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5601,7 +5601,7 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(skb_vlan_untag);
 
-int skb_ensure_writable(struct sk_buff *skb, int write_len)
+int skb_ensure_writable(struct sk_buff *skb, unsigned int write_len)
 {
 	if (!pskb_may_pull(skb, write_len))
 		return -ENOMEM;
-- 
2.17.1

