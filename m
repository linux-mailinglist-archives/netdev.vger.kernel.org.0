Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640AB603776
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 03:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJSBTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 21:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiJSBTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 21:19:33 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E524A120B0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 18:19:31 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MsXvH3fhjzHv0m;
        Wed, 19 Oct 2022 09:19:23 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 09:19:30 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 09:19:29 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <lanhao@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <huangguangbin2@huawei.com>,
        <chenjunxin1@huawei.com>, <netdev@vger.kernel.org>,
        <dsahern@kernel.org>, <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH iproute2] dcb: unblock mnl_socket_recvfrom if not message received
Date:   Wed, 19 Oct 2022 09:20:08 +0800
Message-ID: <20221019012008.11322-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junxin Chen <chenjunxin1@huawei.com>

Currently, the dcb command sinks to the kernel through the netlink
to obtain information. However, if the kernel fails to obtain infor-
mation or is not processed, the dcb command is suspended.

For example, if we don't implement dcbnl_ops->ieee_getpfc in the
kernel, the command "dcb pfc show dev eth1" will be stuck and subsequent
commands cannot be executed.

This patch adds the NLM_F_ACK flag to the netlink in mnlu_msg_prepare
to ensure that the kernel responds to user requests.

After the problem is solved, the execution result is as follows:
$ dcb pfc show dev eth1
Attribute not found: Success

Fixes: 67033d1c1c ("Add skeleton of a new tool, dcb")
Signed-off-by: Junxin Chen <chenjunxin1@huawei.com>
---
 dcb/dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index 8d75ab0a..a6f457fb 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -156,7 +156,7 @@ static struct nlmsghdr *dcb_prepare(struct dcb *dcb, const char *dev,
 	};
 	struct nlmsghdr *nlh;
 
-	nlh = mnlu_msg_prepare(dcb->buf, nlmsg_type, NLM_F_REQUEST, &dcbm, sizeof(dcbm));
+	nlh = mnlu_msg_prepare(dcb->buf, nlmsg_type, NLM_F_REQUEST | NLM_F_ACK, &dcbm, sizeof(dcbm));
 	mnl_attr_put_strz(nlh, DCB_ATTR_IFNAME, dev);
 	return nlh;
 }
-- 
2.33.0

