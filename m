Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC3C2871F5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgJHJuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgJHJub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:50:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ED6C061755;
        Thu,  8 Oct 2020 02:50:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id o8so2507461pll.4;
        Thu, 08 Oct 2020 02:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=p4SMhWw/GkelBn53iaflgFeeujBM4zh1mzJ+1B9emc0=;
        b=DiLr5/kJE3FI0vWri/jVH/5jzhPnKJp4tno25ep6IBm25uDkb4eqAxuLpLqyngTo88
         cgagiX9LrdBiGVnxLIlhDJ1MG2Y9pTcABQ1EpQhdg7RV9yfEbWXGqkO6hDPHRmchAbmS
         UILHakP/bughjA7dqFw3o7sKO64q+L4NK5Y4k7A5u4AI08oFNqI4/kvsKfrHREuQ45Fb
         dkVhZbDtAFZE8ik/N+GCaXhPbld1sawpaZAB/sb0bD/162Q8T1bAaGK2rqQlQ7JKIddt
         i7QCpe08WxcJno9bFubr3eWt3+PpO4IGotqo35XH5j40bR+Xoz8D5jE2K23Me63ginbL
         XdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=p4SMhWw/GkelBn53iaflgFeeujBM4zh1mzJ+1B9emc0=;
        b=mVD7q5U9XCijVpV+fIsWPqC3G21VRUAMH3rWXRY5ELAD9vxD8qu3O6x80s/rW6LP7n
         oW0khm5mpfktZVn0ZRwLfD/CD6CsynT2lX59m2DluLJ26hkYKIIwKMR3kRhMqYIqVBqM
         vIx06JeOGp+mtsJENy489e7JleM8K+ulMp3RN+IOB6dMYDQNfcfj0Cy8y5tuO1ITIbO6
         vlvVFOhwS2ZlqaQq2C2xaXsdAdUI4UPOEgsfDFRAgcstyXAPPMRk5mvcrTyKh0L0gGJ7
         zeOlkZ0j2P9T6vbmoDyMOlcKWJjdUHaIZLWjmPP9HR7Nx0yPKNvGadrD1REeEt7tcsjw
         w3Xg==
X-Gm-Message-State: AOAM532NczUMzb05VC/3yNqPZ20Q8ZpJe5yD3V2hqSmNashtDmLMiVuy
        qmLrF3xHpq4IDT/Tmknm+BE81tg6/jA=
X-Google-Smtp-Source: ABdhPJz0oqvTVCLYh8Ux0T+YbUD4J/nFJb2LagH4j5GnUiaYx89kXNWOZ15zfgiCTsnpJMs1aGmJFA==
X-Received: by 2002:a17:902:8646:b029:d3:b593:2842 with SMTP id y6-20020a1709028646b02900d3b5932842mr7034479plt.46.1602150629488;
        Thu, 08 Oct 2020 02:50:29 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t13sm6055173pjo.15.2020.10.08.02.50.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:50:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 16/17] sctp: handle the init chunk matching an existing asoc
Date:   Thu,  8 Oct 2020 17:48:12 +0800
Message-Id: <a0d328bcd0cc1c274305513054256a05b86c6be0.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <8815067eea44ffd7274b0038e48c2618c2e77916.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
 <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
 <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
 <ad362276ba90a8af3178f19aba15a7e67107652f.1602150362.git.lucien.xin@gmail.com>
 <1d1b2e92f958add640d5be1e6eaec1ac5e4581ce.1602150362.git.lucien.xin@gmail.com>
 <5c0e9cf835f54c11f7e3014cab926bf10a47298d.1602150362.git.lucien.xin@gmail.com>
 <8815067eea44ffd7274b0038e48c2618c2e77916.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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

