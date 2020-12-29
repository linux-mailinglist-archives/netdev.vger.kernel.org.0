Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD912E72C5
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgL2Rkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 12:40:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgL2Rkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 12:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609263566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0N2HePoQRmdLA5K1yApdE8rhkgViaY5rXeLPZJah4TQ=;
        b=MmG9nWwLMBau8P4IIoveWubOWmOSNfUSUvwH75MXpKMVkkpvt18+Rz8Y3cuDTsnbBrnchQ
        7fCkRicPDxHCpk4iN2zL24T2EYBGv8gC2AfgzyYMj90EbiusAewGD1bRgC8eWILZh6RMBC
        5XgCi5r6OH+cHIzH00xat0oiapgVUuY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-nPcUYq-wN9-qaxvisBV2kw-1; Tue, 29 Dec 2020 12:39:22 -0500
X-MC-Unique: nPcUYq-wN9-qaxvisBV2kw-1
Received: by mail-oo1-f72.google.com with SMTP id w3so8283854oov.16
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 09:39:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0N2HePoQRmdLA5K1yApdE8rhkgViaY5rXeLPZJah4TQ=;
        b=NGxUYgDCadZ6dUZ03jIl0Nyzwo/NrglbKtIIZBlw/OpAIN40++vBpkAYPdlI1NuIst
         yU4He+yzDepswlOv0enpY4zbe6tO0zOZyvkmK7ep48Slr/k3BoXYdH04lYkOaEuW3ray
         GQDESp9ilPrU5tjmrVWllfzVbKprt/gMqxhrCD+fiTtrivTuSWpi5V69vwMCnjs2e43l
         FsM8FXAoLHg8084M6Qn1SHCtV4K7D9M+WGfiAeJl05WUGcezZS0E8CV06V/UbpIWyfv0
         1+bU8hpaLElwL8Rx+ds+PI8NTT6wGNmKUf7IPObzQOuQ2n/74D3qOrJ7wUAotWg9BDU1
         1F/Q==
X-Gm-Message-State: AOAM531eLLaRfisw9168mSPkqnXEKpOyZCONTvdl7zETHu1XW5c+kTwi
        0FfyODs50/JIM7MAdkla3HVtP2VgwzG34F5DV4Oa9lkK9ADoVnxXaKnB32b0kQ/9XclbiSk5eB/
        Zj+DyIkWHtQKMS+2q
X-Received: by 2002:a4a:c4c7:: with SMTP id g7mr34109291ooq.50.1609263562111;
        Tue, 29 Dec 2020 09:39:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZkhEccaqdwFw1KqH+CndueSbBG4594RPWMr0slNPBBY1NHS22T8wMLn2iZEPQfjiQTKuBeQ==
X-Received: by 2002:a4a:c4c7:: with SMTP id g7mr34109277ooq.50.1609263561902;
        Tue, 29 Dec 2020 09:39:21 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id s26sm9997234otd.8.2020.12.29.09.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Dec 2020 09:39:21 -0800 (PST)
From:   trix@redhat.com
To:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] rxrpc: fix handling of an unsupported token type in rxrpc_read()
Date:   Tue, 29 Dec 2020 09:39:16 -0800
Message-Id: <20201229173916.1459499-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem

net/rxrpc/key.c:657:11: warning: Assigned value is garbage or undefined
                toksize = toksizes[tok++];
                        ^ ~~~~~~~~~~~~~~~

rxrpc_read() contains two loops.  The first loop calculates the token
sizes and stores the results in toksizes[] and the second one uses the
array.  When there is an error in identifying the token in the first
loop, the token is skipped, no change is made to the toksizes[] array.
When the same error happens in the second loop, the token is not
skipped.  This will cause the toksizes[] array to be out of step and
will overrun past the calculated sizes.

Change the error handling in the second loop to be consistent with
the first.  Simplify the error handling to an if check.

Fixes: 9a059cd5ca7d ("rxrpc: Downgrade the BUG() for unsupported token type in rxrpc_read()")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/rxrpc/key.c | 48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 9631aa8543b5..eea877ee6ab3 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -587,20 +587,19 @@ static long rxrpc_read(const struct key *key,
 	for (token = key->payload.data[0]; token; token = token->next) {
 		toksize = 4;	/* sec index */
 
-		switch (token->security_index) {
-		case RXRPC_SECURITY_RXKAD:
-			toksize += 8 * 4;	/* viceid, kvno, key*2, begin,
-						 * end, primary, tktlen */
-			if (!token->no_leak_key)
-				toksize += RND(token->kad->ticket_len);
-			break;
-
-		default: /* we have a ticket we can't encode */
+		if (token->security_index != RXRPC_SECURITY_RXKAD) {
+			/* we have a ticket we can't encode */
 			pr_err("Unsupported key token type (%u)\n",
 			       token->security_index);
 			continue;
 		}
 
+		/* viceid, kvno, key*2, begin, end, primary, tktlen */
+		toksize += 8 * 4;
+
+		if (!token->no_leak_key)
+			toksize += RND(token->kad->ticket_len);
+
 		_debug("token[%u]: toksize=%u", ntoks, toksize);
 		ASSERTCMP(toksize, <=, AFSTOKEN_LENGTH_MAX);
 
@@ -654,28 +653,25 @@ static long rxrpc_read(const struct key *key,
 
 	tok = 0;
 	for (token = key->payload.data[0]; token; token = token->next) {
+		/* error reported above */
+		if (token->security_index != RXRPC_SECURITY_RXKAD)
+			continue;
+
 		toksize = toksizes[tok++];
 		ENCODE(toksize);
 		oldxdr = xdr;
 		ENCODE(token->security_index);
 
-		switch (token->security_index) {
-		case RXRPC_SECURITY_RXKAD:
-			ENCODE(token->kad->vice_id);
-			ENCODE(token->kad->kvno);
-			ENCODE_BYTES(8, token->kad->session_key);
-			ENCODE(token->kad->start);
-			ENCODE(token->kad->expiry);
-			ENCODE(token->kad->primary_flag);
-			if (token->no_leak_key)
-				ENCODE(0);
-			else
-				ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
-			break;
-
-		default:
-			break;
-		}
+		ENCODE(token->kad->vice_id);
+		ENCODE(token->kad->kvno);
+		ENCODE_BYTES(8, token->kad->session_key);
+		ENCODE(token->kad->start);
+		ENCODE(token->kad->expiry);
+		ENCODE(token->kad->primary_flag);
+		if (token->no_leak_key)
+			ENCODE(0);
+		else
+			ENCODE_DATA(token->kad->ticket_len, token->kad->ticket);
 
 		ASSERTCMP((unsigned long)xdr - (unsigned long)oldxdr, ==,
 			  toksize);
-- 
2.27.0

