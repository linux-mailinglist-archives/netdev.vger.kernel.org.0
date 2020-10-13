Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267A728C958
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390312AbgJMH3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390145AbgJMH3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:29:41 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B51C0613D0;
        Tue, 13 Oct 2020 00:29:41 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a17so1615405pju.1;
        Tue, 13 Oct 2020 00:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=p4SMhWw/GkelBn53iaflgFeeujBM4zh1mzJ+1B9emc0=;
        b=FFYloyTfJeEXEanWK8kIpdVWRJSnZFph49CEzVuE8TU2GIlbvt3c5E+/jO/FLhlFgF
         J1fK58d1NLwS63BT71inAsekQFgHj3LhJp75yPn5Wsn3VLRZfrlKCgHOJ4KzMvFg1fCz
         tH+xzlgIOa4XkK9YXO1rsyIBd5A3tZI2fl+lAYrg5yWRQi3MdExTrS04fVig3Y7DHjEr
         LZhnK0G3VGjdLFPQwmL+PLNuAcRBZQz5uwmnAi11WD3G0YTeLz0wNM3fvcB//iCF7XD8
         6FLGEYMONN0epyVUtHpZCALDffxpOgKAZZ1cw/+t6lXG6ki+//kCnZkfarisD4gDg89v
         MDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=p4SMhWw/GkelBn53iaflgFeeujBM4zh1mzJ+1B9emc0=;
        b=Qr++fMe0iqvOsKWI389pEw6GgJRRyVwlSQfH+yO78RSwpB2xdXZTu+jnucen9Edqdi
         OZt4+FE3S0n5uuavFNidKFF42hY67vTt/kl+5XXPQpzi4AKyDh+E2EYfaNo+EYbB4w74
         OLJHv3ZFADocvmYYqik8NYLKAVN1qgFVDILG5VK3LeybjGbXsJs5HqTBIXvRk5S6C5eb
         8kvm7y2liVdWHQ+L7NOOKHZsosxowWXVTTQ1vt3cczhS08WCyp/YEVCy4opl/1bUtkwc
         RUPROIoRTaTqUW48n3S86VdGg4qeundV5IxmuXyP19sUNrX9q9K2vmdDJNj0nHp3U0d1
         yNKg==
X-Gm-Message-State: AOAM530ofsTyDXqXaMjfJYWuhhlYiahXWvTxhQmEcvcQyN5ankPJurJs
        k51p30bX5K6t4q3PtkTONVPtHId3+wM=
X-Google-Smtp-Source: ABdhPJzWRfLJhFltIL39Elf8xJcZhSyQDpZvTQe5ad/+mK8Z84pwmwgs2fIvLaZYVU86Tz8IXZnsxw==
X-Received: by 2002:a17:90a:7c44:: with SMTP id e4mr22944797pjl.167.1602574180891;
        Tue, 13 Oct 2020 00:29:40 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22sm21995628pfp.181.2020.10.13.00.29.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:29:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 15/16] sctp: handle the init chunk matching an existing asoc
Date:   Tue, 13 Oct 2020 15:27:40 +0800
Message-Id: <59d083919cccb32dad7aec119d00c5300b0c2800.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <df18ce9f94be0a58bbf1743071993b95696aed2d.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
 <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
 <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
 <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
 <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
 <46f33eb9331b7e1e688a7f125201ad600ae83fbd.1602574012.git.lucien.xin@gmail.com>
 <c79a0be422c96fec9da194a20853811d93809393.1602574012.git.lucien.xin@gmail.com>
 <df18ce9f94be0a58bbf1743071993b95696aed2d.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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
index 8edab15..244a5d8 100644
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
+ * Existing Associations when the udp encap port is incorrect.
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

