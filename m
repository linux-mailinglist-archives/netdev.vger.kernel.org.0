Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6CE29274F
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgJSM1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgJSM1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:27:34 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CC2C0613CE;
        Mon, 19 Oct 2020 05:27:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a17so5244074pju.1;
        Mon, 19 Oct 2020 05:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=TLeEEWtJD5FOcaVlaaBDT3ZenGwCI3iSD6tAYB5q5Yw=;
        b=u8vTYeNQBzp6MEjI7LCrdEIfVm8/nLVH7xPSFobsHDcdIIblJzz/YlntYyHIv79UYg
         4fa2MdZgVfNT4jN6af4cFZDgdpMNRkl0pTIwwRmouORUMKPuSry9scGMUU3WU4QUxPeG
         IxOBk+dGxC46wG6/9vOrK9C/L7lGNJp2A+YGZxCVnAh6j2cTJR90I68VaHtNLrWZ3bTD
         3ftfLZKxyURxxP5clrmUbtvEdtImeyAavHnkdz3ZLHwWW4j0XWEN0LodnqrjNRbujYXQ
         0KjAb/g5hTCYjWMkqzg5JqxWcp3Ws0YCwazWV5GW1FXpmjKD9FNyxy0Toq8SWjOPk+c+
         4Skg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=TLeEEWtJD5FOcaVlaaBDT3ZenGwCI3iSD6tAYB5q5Yw=;
        b=e5vMuc7HmhdVQVq8EQBuKWI5Hnvy9OL+ltm/tXaaXouqGwxhmCgD2BAu1aqNdyB/66
         6OaLo7lsIrQ15weOdBoeyy5TdZmDlcr14mV7K+EudQGa1N68Kvo+QJFvx0ZU4ECmyx/n
         FLTMDtZ+jQ+3pZWUPgQhh9OAP9RU+CJhCZOWxAojh/hp28zGi+5N0agaE+kF7mUvcd6H
         Hj9+ZOiV2ejemoQ8tqkChsiaa1g1y8xExn6IAOn1u4DH13Gwn+RUCwiRBC7lSPLeRJNO
         zbm0PWXQMDTmXRgswuQDOVUthkepNDBLhkNVqhNruZtzuJxki6gDzCsXYcR3G+soJMB0
         3vKw==
X-Gm-Message-State: AOAM5326t9gBZYhiJFA+p5vpf9CeafkzTDciswhERqSknSJkUtLsfdzw
        jMsKiirSzn91xusn/hIDD3L8umj4i98=
X-Google-Smtp-Source: ABdhPJy00OzhMj5POAloB2gUMBjk4dePdPjzC2x+emXVo9vu2aR6ZUlTrJsP2EqRv4ZI/Pza46I8YQ==
X-Received: by 2002:a17:90a:cb91:: with SMTP id a17mr16514606pju.220.1603110453180;
        Mon, 19 Oct 2020 05:27:33 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u65sm12013776pfc.11.2020.10.19.05.27.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:27:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 15/16] sctp: handle the init chunk matching an existing asoc
Date:   Mon, 19 Oct 2020 20:25:32 +0800
Message-Id: <81779bb5f9dbe452d91904f617d8083f1ba91a34.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
 <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
 <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
 <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is from Section 4 of draft-tuexen-tsvwg-sctp-udp-encaps-cons-03,
and it requires responding with an abort chunk with an error cause
when the udp source port of the received init chunk doesn't match the
encap port of the transport.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8edab15..af2b704 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -87,6 +87,13 @@ static enum sctp_disposition sctp_sf_tabort_8_4_8(
 					const union sctp_subtype type,
 					void *arg,
 					struct sctp_cmd_seq *commands);
+static enum sctp_disposition sctp_sf_new_encap_port(
+					struct net *net,
+					const struct sctp_endpoint *ep,
+					const struct sctp_association *asoc,
+					const union sctp_subtype type,
+					void *arg,
+					struct sctp_cmd_seq *commands);
 static struct sctp_sackhdr *sctp_sm_pull_sack(struct sctp_chunk *chunk);
 
 static enum sctp_disposition sctp_stop_t1_and_abort(
@@ -1493,6 +1500,10 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	if (!sctp_chunk_length_valid(chunk, sizeof(struct sctp_init_chunk)))
 		return sctp_sf_violation_chunklen(net, ep, asoc, type, arg,
 						  commands);
+
+	if (SCTP_INPUT_CB(chunk->skb)->encap_port != chunk->transport->encap_port)
+		return sctp_sf_new_encap_port(net, ep, asoc, type, arg, commands);
+
 	/* Grab the INIT header.  */
 	chunk->subh.init_hdr = (struct sctp_inithdr *)chunk->skb->data;
 
@@ -3392,6 +3403,45 @@ static enum sctp_disposition sctp_sf_tabort_8_4_8(
 
 	sctp_packet_append_chunk(packet, abort);
 
+	sctp_add_cmd_sf(commands, SCTP_CMD_SEND_PKT, SCTP_PACKET(packet));
+
+	SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
+
+	sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	return SCTP_DISPOSITION_CONSUME;
+}
+
+/* Handling of SCTP Packets Containing an INIT Chunk Matching an
+ * Existing Associations when the UDP encap port is incorrect.
+ *
+ * From Section 4 at draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.
+ */
+static enum sctp_disposition sctp_sf_new_encap_port(
+					struct net *net,
+					const struct sctp_endpoint *ep,
+					const struct sctp_association *asoc,
+					const union sctp_subtype type,
+					void *arg,
+					struct sctp_cmd_seq *commands)
+{
+	struct sctp_packet *packet = NULL;
+	struct sctp_chunk *chunk = arg;
+	struct sctp_chunk *abort;
+
+	packet = sctp_ootb_pkt_new(net, asoc, chunk);
+	if (!packet)
+		return SCTP_DISPOSITION_NOMEM;
+
+	abort = sctp_make_new_encap_port(asoc, chunk);
+	if (!abort) {
+		sctp_ootb_pkt_free(packet);
+		return SCTP_DISPOSITION_NOMEM;
+	}
+
+	abort->skb->sk = ep->base.sk;
+
+	sctp_packet_append_chunk(packet, abort);
+
 	sctp_add_cmd_sf(commands, SCTP_CMD_SEND_PKT,
 			SCTP_PACKET(packet));
 
-- 
2.1.0

