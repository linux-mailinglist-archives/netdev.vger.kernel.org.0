Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5614862CDC7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiKPWh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiKPWhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:37:24 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF086B3A4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:37:23 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso224539wmo.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DdCi7i53M7SdmWJENVuu2u1iCBwoHAK4ArwaATMNUTk=;
        b=IXpqH5PJjyVvfTaPA2+sTXPEZNNLJ5rfd1SD13n0pu91n5YCewPqfqhTjdLizA4SWH
         mCgW/ut2XejvFczESAw6Z99Tqq5keSSXypILyUOazGBliBZdkNQYXro90nXVung2q6bb
         4HIPuDX6ZDJmFesxzpFL89/pZpWT+Z8c1Nc+H3S3KF3wwJeyzWgeJvEWtKeqrea/9R1M
         ccz9vSWZS1904qymqkRvoXup5dzGpXgAJaKBkSDxl6T/AU+LCrsVADf6y9NmDdCr51QH
         oxpQqPZ9Hgm6fNrjtaytErXsqPtlVUET3+kxv6Z8GmM8U8+zaHdVFuh5W55LehLTHJt+
         qcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DdCi7i53M7SdmWJENVuu2u1iCBwoHAK4ArwaATMNUTk=;
        b=OGakyYlON/ehNrgTplsqpdAnk3gW4Um46MFMoHQYl1NeoEA1dMo1d5n8zZ1UyW+8nV
         kCt0AUeaKoQQnjBp1wrdipko6we3ufj4oST7WKAamb8q02h5MEF237N4sioqiRyx9S9y
         UDeqSCr5TODsvqf7BQamQVWDZ7y26sAH/EqduDKatpJ7WN2VlkBKMmuZz2/qptEOZC0k
         vwxuZxARBrg1eTx6RapZFutsdg85GqSArAm+espb70iqJgh0qPCGRtwwWatjWxT3Y28G
         b00KTz8iaOqFhLDVU60s7pNz7H02bdYVw7/caXd5jkMekGU3yR4YcZLSBhiZmVUNxm0I
         BK+g==
X-Gm-Message-State: ANoB5ploeuVl7xQsCcPYUQlWEtI52gplqYdQLxsSO2djyOf2xkiK/Z8x
        KxkkiftQsiwWKwt3OvaE9Rvngw==
X-Google-Smtp-Source: AA0mqf7nQtnAf+wahmKfpwsx+1U4sa/29Y2YebNZUFFmC+4pwsUWTz2lMlpIxzeSD5v15yhQTsRC+w==
X-Received: by 2002:a05:600c:4f04:b0:3cf:9881:e9d9 with SMTP id l4-20020a05600c4f0400b003cf9881e9d9mr3570378wmq.6.1668638241510;
        Wed, 16 Nov 2022 14:37:21 -0800 (PST)
Received: from zoltan.localdomain ([167.98.215.174])
        by smtp.gmail.com with ESMTPSA id f4-20020adff984000000b0024194bba380sm7598297wrr.22.2022.11.16.14.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 14:37:20 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     error27@gmail.com, caleb.connolly@linaro.com, elder@kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: avoid a null pointer dereference
Date:   Wed, 16 Nov 2022 16:37:18 -0600
Message-Id: <20221116223718.137175-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter reported that Smatch found an instance where a pointer
which had previously been assumed could be null (as indicated by a
null check) was later dereferenced without a similar check.

In practice this doesn't lead to a problem because currently the
pointers used are all non-null.  Nevertheless this patch addresses
the reported problem.

In addition, I spotted another bug that arose in the same commit.
When the command to initialize a routing table memory region was
added, the number of entries computed for the non-hashed table
was wrong (it ended up being a Boolean rather than the count
intended).  This bug is fixed here as well.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/kernel-janitors/Y3OOP9dXK6oEydkf@kili
Tested-by: Caleb Connolly <caleb.connolly@linaro.com>
Fixes: 5cb76899fb47 ("net: ipa: reduce arguments to ipa_table_init_add()")
Signed-off-by: Alex Elder <elder@linaro.org>
---
Note:  This does *not* need to be back-ported (it applies to net-next).

 drivers/net/ipa/ipa_table.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index cc9349a1d4df9..b81e27b613549 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -382,6 +382,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 	const struct ipa_mem *mem;
 	dma_addr_t hash_addr;
 	dma_addr_t addr;
+	u32 hash_offset;
 	u32 zero_offset;
 	u16 hash_count;
 	u32 zero_size;
@@ -394,8 +395,10 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 			: ipv6 ? IPA_CMD_IP_V6_ROUTING_INIT
 			       : IPA_CMD_IP_V4_ROUTING_INIT;
 
+	/* The non-hashed region will exist (see ipa_table_mem_valid()) */
 	mem = ipa_table_mem(ipa, filter, false, ipv6);
 	hash_mem = ipa_table_mem(ipa, filter, true, ipv6);
+	hash_offset = hash_mem ? hash_mem->offset : 0;
 
 	/* Compute the number of table entries to initialize */
 	if (filter) {
@@ -411,7 +414,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 		 * of entries it has.
 		 */
 		count = mem->size / sizeof(__le64);
-		hash_count = hash_mem && hash_mem->size / sizeof(__le64);
+		hash_count = hash_mem ? hash_mem->size / sizeof(__le64) : 0;
 	}
 	size = count * sizeof(__le64);
 	hash_size = hash_count * sizeof(__le64);
@@ -420,7 +423,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 	hash_addr = ipa_table_addr(ipa, filter, hash_count);
 
 	ipa_cmd_table_init_add(trans, opcode, size, mem->offset, addr,
-			       hash_size, hash_mem->offset, hash_addr);
+			       hash_size, hash_offset, hash_addr);
 	if (!filter)
 		return;
 
@@ -433,7 +436,7 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter, bool ipv6)
 		return;
 
 	/* Zero the unused space in the hashed filter table */
-	zero_offset = hash_mem->offset + hash_size;
+	zero_offset = hash_offset + hash_size;
 	zero_size = hash_mem->size - hash_size;
 	ipa_cmd_dma_shared_mem_add(trans, zero_offset, zero_size,
 				   ipa->zero_addr, true);
-- 
2.34.1

