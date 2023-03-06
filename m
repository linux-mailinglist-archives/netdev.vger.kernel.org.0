Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BF66ACF9F
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCFU5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCFU5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:57:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E472E4A1D4;
        Mon,  6 Mar 2023 12:57:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E4EEB81128;
        Mon,  6 Mar 2023 20:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E371C433EF;
        Mon,  6 Mar 2023 20:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678136252;
        bh=EEGNEdub0w4hIAmIaVGxgI/ZXHmKcyB1pnsQBSCuhEE=;
        h=Date:From:To:Cc:Subject:From;
        b=FyLAVFVmO0Pg0RRNFm+BnJxeoIq60hAKFr5DaE6cLm/WbCRPLeQFKals8/UBAMcGL
         wJLr4h/+tsg3JOBIjRQbfrLPTHlYYYCxavZx/kuKHmISQv1KMv+NxRxX4pikoLM97w
         2eUJFiV5xNKNtIo+J1jSBcB7dDuUztOs8NdatI7WxSeRSvO3VLE8u3Lkx5gdJhp12O
         OQqGJ0G4j+hsXqv34WjsgDZxz6f6JQ2GQEjI/Juz2+vlt0ekQQC6U/EupAWvZI0ZJP
         +NIzIX3ZJjz8QuxUcrXTauEPxiF0EZoDqazM/UQrgHTSkcdrfjLLWYlsETT3nPleS3
         FdIwQ/mAvk8mg==
Date:   Mon, 6 Mar 2023 14:57:59 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] rxrpc: Replace fake flex-array with flexible-array
 member
Message-ID: <ZAZT11n4q5bBttW0@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Transform zero-length array into flexible-array member in struct
rxrpc_ackpacket.

Address the following warnings found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
net/rxrpc/call_event.c:149:38: warning: array subscript i is outside array bounds of ‘uint8_t[0]’ {aka ‘unsigned char[]’} [-Warray-bounds=]

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/263
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/rxrpc/protocol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/protocol.h b/net/rxrpc/protocol.h
index 6760cb99c6d6..e8ee4af43ca8 100644
--- a/net/rxrpc/protocol.h
+++ b/net/rxrpc/protocol.h
@@ -126,7 +126,7 @@ struct rxrpc_ackpacket {
 	uint8_t		nAcks;		/* number of ACKs */
 #define RXRPC_MAXACKS	255
 
-	uint8_t		acks[0];	/* list of ACK/NAKs */
+	uint8_t		acks[];		/* list of ACK/NAKs */
 #define RXRPC_ACK_TYPE_NACK		0
 #define RXRPC_ACK_TYPE_ACK		1
 
-- 
2.34.1

