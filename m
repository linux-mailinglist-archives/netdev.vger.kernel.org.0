Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EFA525EFE
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379143AbiEMJwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 05:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351638AbiEMJws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 05:52:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C97ED6A42A
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 02:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652435566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QhMj9dRMHoO9LZCNH8LqQ27GRVAk0pG5E3kR76KvUgk=;
        b=bQnz04g6zw51KOhi73U7N0UNtdzRcn3GT+5rggICZqKXvi5Otr9QHHfzvjSN7HEmHKtEzG
        QXW98sKqus079iiTFCMGbkK0yX6U1j8XPDBZSVg7/N0eFV1qybF7zgmPMhZgvEIWqSrzc8
        zPXsiEBbDMlJIhYM5PvVz0Atmki7Qk8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-IsPUjOmLNdKMWUCVtdJZHQ-1; Fri, 13 May 2022 05:52:45 -0400
X-MC-Unique: IsPUjOmLNdKMWUCVtdJZHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FCA83C0D19B;
        Fri, 13 May 2022 09:52:45 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41AE140D2820;
        Fri, 13 May 2022 09:52:44 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, lucien.xin@gmail.com
Subject: [PATCH iproute2] tipc: fix keylen check
Date:   Fri, 13 May 2022 11:52:30 +0200
Message-Id: <9e21220e872dc70dbcd8d4dcba38c3a607052d6e.1652435398.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Key length check in str2key() is wrong for hex. Fix this using the
proper hex key length.

Fixes: 28ee49e5153b ("tipc: bail out if key is abnormally long")
Suggested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tipc/misc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tipc/misc.c b/tipc/misc.c
index 909975d8..6175bf07 100644
--- a/tipc/misc.c
+++ b/tipc/misc.c
@@ -113,16 +113,15 @@ int str2key(char *str, struct tipc_aead_key *key)
 	    }
 	}
 
-	if (len > TIPC_AEAD_KEYLEN_MAX)
+	key->keylen = ishex ? (len + 1) / 2 : len;
+	if (key->keylen > TIPC_AEAD_KEYLEN_MAX)
 		return -1;
 
 	/* Obtain key: */
 	if (!ishex) {
-		key->keylen = len;
 		memcpy(key->key, str, len);
 	} else {
 		/* Convert hex string to key */
-		key->keylen = (len + 1) / 2;
 		for (i = 0; i < key->keylen; i++) {
 			if (i == 0 && len % 2 != 0) {
 				if (sscanf(str, "%1hhx", &key->key[0]) != 1)
-- 
2.35.3

