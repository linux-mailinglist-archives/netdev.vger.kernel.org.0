Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35300434A5D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhJTLpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJTLpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 07:45:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7ADC061746;
        Wed, 20 Oct 2021 04:42:56 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g79-20020a1c2052000000b00323023159e1so957862wmg.2;
        Wed, 20 Oct 2021 04:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fUqvamQ7yXDdckb8kSICmUsU3zgXD0tC1WwsygvPs7s=;
        b=ji+aM5ulvLCjf1w4de+bfrwZvQsAtAkkmLqtHhrrEMdDJI/56zaBVdh9fahuDaxbe0
         5nIpYaifCHKjb6pcMKdERAfKxenN+50Hsh7icACFGkfJmpnr+JCdYg8isz9mDy7kd/6p
         OkeRiJTFYxRP56CU4gFoJepcF9Nu5i9PHIe2Ir8DDKKqkpi6osQKD++iWG07fSXVTw1z
         0LwblyoasEDWz5B78MrRtcnLuPv2l6/F8qt+/rqp6rKUQ1qU7g/JNeZdlBPxmGAEHLwD
         DW5atF7JsaekiUNdB/krJ969xRIHFmfI/+EdzXdFEuZDmYjw5VYMoIDNW7Oy6ixZz1ci
         XExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fUqvamQ7yXDdckb8kSICmUsU3zgXD0tC1WwsygvPs7s=;
        b=Il84XURDe1tGUAHP/RqI8rHsBNqhdhHImd57YFBSW7IZ3JPgcPLntF2vwPPBEfAvxc
         Uq/iHiuHWVpPnMGWg+0zW+nByCQYCRzf01a5z2RMXFXNieR/6IWzMaA9O/N6ljzQWdBA
         NoziSCNpoqN9WQ0gXzlJ9+gtfRqDw2Zwu4UJ/H6kokG6jyG7K2/5IyCeQcdk62gV9vOB
         1KP6GJby9dLipWY1nBMU+4smDHPwBbK1TQiAHYT6CyWAxHGIChon45HEC9n/AJ2cISMD
         Lh7W0HPtGN98dFSqJ5r5kHwkCsqtiINldSjCZsn3Ao54gO8WTJpsbPgRce6THw5ttnUS
         AYHg==
X-Gm-Message-State: AOAM531NEGVIwcyL2rmZAV8bh2DEAzGLBzYLPYYJCQy8IRYD03CF6CJS
        8iaUnZ4iCzL86dzBYIOLfqS2zh0jgD2+3g==
X-Google-Smtp-Source: ABdhPJw4y3/dC3RnOxzzkqPeZPuSvM+JVW913jByYCanjhLLaadEItLmR+L9bZIKFyvrwoi9s5W4Bg==
X-Received: by 2002:a05:600c:ac1:: with SMTP id c1mr12833085wmr.99.1634730174849;
        Wed, 20 Oct 2021 04:42:54 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 186sm4988989wmc.20.2021.10.20.04.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 04:42:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        michael.tuexen@lurchi.franken.de
Subject: [PATCH net 3/7] sctp: fix the processing for INIT_ACK chunk
Date:   Wed, 20 Oct 2021 07:42:43 -0400
Message-Id: <dfeecf8aaf5319a92bb300c04c08efd4d570fdd1.1634730082.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently INIT_ACK chunk in non-cookie_echoed state is processed in
sctp_sf_discard_chunk() to send an abort with the existent asoc's
vtag if the chunk length is not valid. But the vtag in the chunk's
sctphdr is not verified, which may be exploited by one to cook a
malicious chunk to terminal a SCTP asoc.

sctp_sf_discard_chunk() also is called in many other places to send
an abort, and most of those have this problem. This patch is to fix
it by sending abort with the existent asoc's vtag only if the vtag
from the chunk's sctphdr is verified in sctp_sf_discard_chunk().

Note on sctp_sf_do_9_1_abort() and sctp_sf_shutdown_pending_abort(),
the chunk length has been verified before sctp_sf_discard_chunk(),
so replace it with sctp_sf_discard(). On sctp_sf_do_asconf_ack() and
sctp_sf_do_asconf(), move the sctp_chunk_length_valid check ahead of
sctp_sf_discard_chunk(), then replace it with sctp_sf_discard().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 9bfa8cca9974..672e5308839b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2343,7 +2343,7 @@ enum sctp_disposition sctp_sf_shutdown_pending_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2389,7 +2389,7 @@ enum sctp_disposition sctp_sf_shutdown_sent_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -2659,7 +2659,7 @@ enum sctp_disposition sctp_sf_do_9_1_abort(
 	 */
 	if (SCTP_ADDR_DEL ==
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	if (!sctp_err_chunk_valid(chunk))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
@@ -3865,6 +3865,11 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP: Section 4.1.1
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -3873,13 +3878,7 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	 */
 	if (!asoc->peer.asconf_capable ||
 	    (!net->sctp.addip_noauth && !chunk->auth))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ASCONF ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	hdr = (struct sctp_addiphdr *)chunk->skb->data;
 	serial = ntohl(hdr->serial);
@@ -4008,6 +4007,12 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
+	/* Make sure that the ADDIP chunk has a valid length.  */
+	if (!sctp_chunk_length_valid(asconf_ack,
+				     sizeof(struct sctp_addip_chunk)))
+		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
+						  commands);
+
 	/* ADD-IP, Section 4.1.2:
 	 * This chunk MUST be sent in an authenticated way by using
 	 * the mechanism defined in [I-D.ietf-tsvwg-sctp-auth]. If this chunk
@@ -4016,14 +4021,7 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 	 */
 	if (!asoc->peer.asconf_capable ||
 	    (!net->sctp.addip_noauth && !asconf_ack->auth))
-		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
-					     commands);
-
-	/* Make sure that the ADDIP chunk has a valid length.  */
-	if (!sctp_chunk_length_valid(asconf_ack,
-				     sizeof(struct sctp_addip_chunk)))
-		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
-						  commands);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	addip_hdr = (struct sctp_addiphdr *)asconf_ack->skb->data;
 	rcvd_serial = ntohl(addip_hdr->serial);
@@ -4595,6 +4593,9 @@ enum sctp_disposition sctp_sf_discard_chunk(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Make sure that the chunk has a valid length.
 	 * Since we don't know the chunk type, we use a general
 	 * chunkhdr structure to make a comparison.
-- 
2.27.0

