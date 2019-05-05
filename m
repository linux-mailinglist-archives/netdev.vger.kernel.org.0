Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6758F1430A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 01:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfEEXdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 19:33:32 -0400
Received: from mail.us.es ([193.147.175.20]:34086 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728084AbfEEXdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 19:33:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D9E9211ED83
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8780DA705
        for <netdev@vger.kernel.org>; Mon,  6 May 2019 01:33:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BE1E0DA703; Mon,  6 May 2019 01:33:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2204DA701;
        Mon,  6 May 2019 01:33:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 01:33:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9F7754265A31;
        Mon,  6 May 2019 01:33:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/12] netfilter: slightly optimize nf_inet_addr_mask
Date:   Mon,  6 May 2019 01:33:05 +0200
Message-Id: <20190505233305.13650-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505233305.13650-1-pablo@netfilter.org>
References: <20190505233305.13650-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

using 64bit computation to slightly optimize nf_inet_addr_mask

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index a7252f3baeb0..996bc247ef6e 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -41,10 +41,19 @@ static inline void nf_inet_addr_mask(const union nf_inet_addr *a1,
 				     union nf_inet_addr *result,
 				     const union nf_inet_addr *mask)
 {
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
+	const unsigned long *ua = (const unsigned long *)a1;
+	unsigned long *ur = (unsigned long *)result;
+	const unsigned long *um = (const unsigned long *)mask;
+
+	ur[0] = ua[0] & um[0];
+	ur[1] = ua[1] & um[1];
+#else
 	result->all[0] = a1->all[0] & mask->all[0];
 	result->all[1] = a1->all[1] & mask->all[1];
 	result->all[2] = a1->all[2] & mask->all[2];
 	result->all[3] = a1->all[3] & mask->all[3];
+#endif
 }
 
 int netfilter_init(void);
-- 
2.11.0

