Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A31362D44F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiKQHny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiKQHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:43:45 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56A72AE8;
        Wed, 16 Nov 2022 23:43:43 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id g12so2225424wrs.10;
        Wed, 16 Nov 2022 23:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=507puUosXRt+1YJ5p1yLTZSFtp0JnpD0Zo8CEq5Yvlw=;
        b=D2bJHtvI+AGQuZc/lPoSV04Om3tjI9NSlspOXXfzeDEjxhTvYdEXSdzzIbrLkzJIrP
         Z42dCGQaXiLy792KqxO6BtZKlqDuvvyo6X5dFdmOrtnLCFxnDdEuCJdeEHkNfPODgA8N
         a88XL1Im1jNBVFdSpg02wgLE562rVKuKHqNHm3NKEFN4Ibl+mZMJo+Rjmcy8Cq08ths5
         k2l4dON0UMWQx55wtiQcBrkNleB8n+IkjVBN++AfT9wYZZjX+plQdzs98PSVvtU9Qc9B
         QcH10MaQKP6E89+9CuocNdjQHuzNvY8AhrZFxZLxkRDeb5MbyywK0vuiLC6y6tExfLUf
         0MOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=507puUosXRt+1YJ5p1yLTZSFtp0JnpD0Zo8CEq5Yvlw=;
        b=uRThQZJXeF3DDTvkqqYIpG+Mrd3KQmYLhWM94ePrkao1mHBxvP0eoVQGn890WjUsz7
         /WKkSXWaqryEH+CDH8u4RL66a1H47ZNZnXCh/sLVDRvKa2/MxErRyogz9Z2KCNj8/Y7K
         GzgIH9UqKHyKQcy5uEjtkP1yU5Els1xjoKEi6EY4G+tvY5zOUvFLb577oMCfYFkG5giS
         VtK+5wWGomBZYY5BbtzozBssy+Eigc0BVcDJUjriuPuJNl2hHe7ckzm7VLUKDcHo/TTT
         VhX2Vdj6u2sUHCGs7msc2sRdkzSk5cxKGgXwMGVpo+4M5RGqoiFXLpymjQHue4qFr+/7
         L51Q==
X-Gm-Message-State: ANoB5pnA5OZLklfoBVjEle7mzZnC6aknOJRBoSgjTB3aOq4H1fZPxZiK
        E0DKeIHUesVIDFC8blSHqbI=
X-Google-Smtp-Source: AA0mqf4vF9Jm+rkWiMKio02HzS+sNCiI6iWCCaTdPdFWk8cKgtVnTPM/H7nZClCvVksk/mRkc7QmMw==
X-Received: by 2002:a5d:6582:0:b0:241:792f:b1fb with SMTP id q2-20020a5d6582000000b00241792fb1fbmr670043wru.436.1668671022131;
        Wed, 16 Nov 2022 23:43:42 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a13-20020a5d53cd000000b002383edcde09sm171842wrw.59.2022.11.16.23.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 23:43:41 -0800 (PST)
From:   Dan Carpenter <error27@gmail.com>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu, 17 Nov 2022 10:43:38 +0300
To:     David Howells <dhowells@redhat.com>
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] rxrpc: fix rxkad_verify_response()
Message-ID: <Y3XmKhBt5fclE6XC@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error handling for if skb_copy_bits() fails was accidentally deleted
so the rxkad_decrypt_ticket() function is not called.

Fixes: 5d7edbc9231e ("rxrpc: Get rid of the Rx ring")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This applies to net-next.  It might go throught some kind of an AFS
tree judging by the S-o-b tags on the earlier patches?  Tracking
everyone's trees is really complicated now that I'm dealing with over
300 trees.

 net/rxrpc/rxkad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 2706e59bf992..110a5550c0a6 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1165,8 +1165,10 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 	eproto = tracepoint_string("rxkad_tkt_short");
 	abort_code = RXKADPACKETSHORT;
-	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header) + sizeof(*response),
-			  ticket, ticket_len) < 0)
+	ret = skb_copy_bits(skb, sizeof(struct rxrpc_wire_header) + sizeof(*response),
+			    ticket, ticket_len);
+	if (ret < 0)
+		goto temporary_error_free_ticket;
 
 	ret = rxkad_decrypt_ticket(conn, server_key, skb, ticket, ticket_len,
 				   &session_key, &expiry, _abort_code);
-- 
2.35.1

