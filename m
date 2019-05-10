Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307AC1961D
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 03:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfEJBPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 21:15:13 -0400
Received: from www.osadl.org ([62.245.132.105]:46278 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfEJBPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 21:15:13 -0400
Received: from debian01.hofrr.at (178.115.242.59.static.drei.at [178.115.242.59])
        by www.osadl.org (8.13.8/8.13.8/OSADL-2007092901) with ESMTP id x4A1EcOb003720;
        Fri, 10 May 2019 03:14:38 +0200
From:   Nicholas Mc Guire <hofrat@osadl.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] net: qrtr: use protocol endiannes variable
Date:   Fri, 10 May 2019 03:08:53 +0200
Message-Id: <1557450533-9321-1-git-send-email-hofrat@osadl.org>
X-Mailer: git-send-email 2.1.4
X-Spam-Status: No, score=-1.9 required=6.0 tests=BAYES_00 autolearn=ham
        version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on www.osadl.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sparse was unable to verify endianness correctness due to reassignment
from le32_to_cpu to the same variable - fix this warning up by providing
a proper __le32 type and initializing it. This is not actually fixing
any bug - rather just addressing the sparse warning.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Problem located by an experimental coccinelle script to locate
patters that make sparse unhappy (false positives):

sparse was unhappy about:
net/qrtr/qrtr.c:811:24: warning: cast to restricted __le32

The patch does change the binary - from inspection of the .lst files
it seems that the additional variable as well instruction reordering
constraints change the code even if the code-logic is the same.

Patch was compile-tested with: qcom_defconfig + QRTR=m

Patch is against 5.1 (localversion-next is next-20190509)

 net/qrtr/qrtr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index dd0e97f..c90edaa 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -733,7 +733,8 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct qrtr_node *node;
 	struct sk_buff *skb;
 	size_t plen;
-	u32 type = QRTR_TYPE_DATA;
+	u32 type = 0;
+	__le32 qrtr_type = cpu_to_le32(QRTR_TYPE_DATA);
 	int rc;
 
 	if (msg->msg_flags & ~(MSG_DONTWAIT))
@@ -807,8 +808,8 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		}
 
 		/* control messages already require the type as 'command' */
-		skb_copy_bits(skb, 0, &type, 4);
-		type = le32_to_cpu(type);
+		skb_copy_bits(skb, 0, &qrtr_type, 4);
+		type = le32_to_cpu(qrtr_type);
 	}
 
 	rc = enqueue_fn(node, skb, type, &ipc->us, addr);
-- 
2.1.4

