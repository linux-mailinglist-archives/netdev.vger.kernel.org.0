Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAF22E0C2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfE2PNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:13:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53643 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfE2PNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 11:13:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id d17so1943054wmb.3
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 08:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2buZooF/pmx7z95pzXizhl/Lg5Xb9tNt67UtliOTiY=;
        b=LV06o1TFO0Rk9DvfW0Ij9y8Q3aqErIhwJHxIkW4Vq2cYl+khIGgjz4i7kIhyOKcYCY
         nMouG+lJ6fo2Saapcd7nRBt7YK+2s8c6Hr1ZwkwTKfSXNbjPZi8e3dJcvZvfp+6zk0EB
         S1mgG7t02nzHXGwTZcunKLxcXtuPwdoDmD/3AlbVyx+CbmGc7ZQ6zUx7eYZ/M/i/7SGG
         B0UegKGOwPWTnhC/XlraL1jzU86fEAnpGwy7NymRhcECwiEt021m5FwfGXsanCjLWjHU
         ISytB6jw/lRxFdxndsl+GjaAr9VNozRmlShhfboFZPiolXmFYk5neevxwQxRe7TKADBm
         EVkw==
X-Gm-Message-State: APjAAAUy2Tid169KBI/Rcchise2+pURFB+ktKqpb248t+FMnGpjKBiAe
        OiJQccToa/cvtUoCY2BIauKMbawoF34=
X-Google-Smtp-Source: APXvYqw6TGNqjwQ/cGPnADmOEDWtEPldcH4/ylP16XoGpsMS5pki4FsKsIdNSaS7vfzqm2UD4Lr31w==
X-Received: by 2002:a1c:4d07:: with SMTP id o7mr7154944wmh.156.1559142830240;
        Wed, 29 May 2019 08:13:50 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.dsl.teletu.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id c131sm7284963wma.31.2019.05.29.08.13.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 08:13:49 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: avoid indirect calls in L4 checksum calculation
Date:   Wed, 29 May 2019 17:13:48 +0200
Message-Id: <20190529151348.31311-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up
indirect calls of builtin") introduces some macros to avoid doing
indirect calls.

Use these helpers to remove two indirect calls in the L4 checksum
calculation for devices which don't have hardware support for it.

As a test I generate packets with pktgen out to a dummy interface
with HW checksumming disabled, to have the checksum calculated in
every sent packet.
The packet rate measured with an i7-6700K CPU and a single pktgen
thread raised from 6143 to 6608 Kpps, an increase by 7.5%

Suggested-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/core/skbuff.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e89be6282693..0c2e7d4946ef 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -76,6 +76,7 @@
 #include <linux/highmem.h>
 #include <linux/capability.h>
 #include <linux/user_namespace.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include "datagram.h"
 
@@ -2507,7 +2508,8 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 	if (copy > 0) {
 		if (copy > len)
 			copy = len;
-		csum = ops->update(skb->data + offset, copy, csum);
+		csum = INDIRECT_CALL_1(ops->update, csum_partial_ext,
+				       skb->data + offset, copy, csum);
 		if ((len -= copy) == 0)
 			return csum;
 		offset += copy;
@@ -2534,9 +2536,13 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 					      frag->page_offset + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_atomic(p);
-				csum2 = ops->update(vaddr + p_off, p_len, 0);
+				csum2 = INDIRECT_CALL_1(ops->update,
+							csum_partial_ext,
+							vaddr + p_off, p_len, 0);
 				kunmap_atomic(vaddr);
-				csum = ops->combine(csum, csum2, pos, p_len);
+				csum = INDIRECT_CALL_1(ops->combine,
+						       csum_block_add_ext, csum,
+						       csum2, pos, p_len);
 				pos += p_len;
 			}
 
@@ -2559,7 +2565,8 @@ __wsum __skb_checksum(const struct sk_buff *skb, int offset, int len,
 				copy = len;
 			csum2 = __skb_checksum(frag_iter, offset - start,
 					       copy, 0, ops);
-			csum = ops->combine(csum, csum2, pos, copy);
+			csum = INDIRECT_CALL_1(ops->combine, csum_block_add_ext,
+					       csum, csum2, pos, copy);
 			if ((len -= copy) == 0)
 				return csum;
 			offset += copy;
-- 
2.21.0

