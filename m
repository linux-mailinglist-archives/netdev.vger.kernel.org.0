Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4A429E45E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgJ2HiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgJ2HYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC7C08EA79;
        Thu, 29 Oct 2020 00:07:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o7so1588620pgv.6;
        Thu, 29 Oct 2020 00:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=TLeEEWtJD5FOcaVlaaBDT3ZenGwCI3iSD6tAYB5q5Yw=;
        b=vffkrBncdb0YBVbNOaLDJ6vGuqVsDw6w6OWheK2YT8JChrDvjnM7fC2NpBtmPKv65b
         3tqT9xhxZ1JgUy3aTVqlIn+6VRoS3TT75KdoqrdBAeMdB8ijiKWg3naD+2OWR89nROL7
         uuIWL6ESS5RiWMdQYvIzhy9/GgBKcCwMJhAQiXh7P5Ekd67IbLUozFqbhsfpZivV8idx
         TOG3l5pYx2m8dkQjsLpLDXfk1W8S4syXqUD9h9ZA7v4FZs0WqvmyMdtwGfb7JlJfEtbe
         Hjvu0YacF8hwODtnrGpyWMBtoMaTPpjsF+UeSNRiLs6nE1laqCpZghR9vUFPJyIUpvsK
         Buow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=TLeEEWtJD5FOcaVlaaBDT3ZenGwCI3iSD6tAYB5q5Yw=;
        b=eifx4U12k7sZ3xxtK1q96vyBjwhwY1CHZywfIYy7UJSGw6OmNjY/K+9veSLXN7ePcn
         VZKP3xGuzNPERWBoCunllYbeyfrcjmDpwqkXtLqmtgPS92EYogwpMwEmKdx7iYntNXjn
         DOAX+8lIt2v6sYT1sVRVzagCuERsnrH68DgGDl2/hRM9bpJza3xI29A32X5WW9E4J/eP
         hULQDz5iq3e7pg+grigTE5JhI10J7hIf23wpcOYf6wlkfLRwBayI9VkS5tSqVeLTSR+m
         xvFvxavfAJsvL37GMms82liNEZ8SNvMin5kOPj9vVdgXb9inE5zopD9xYZlTryQmExel
         UcVg==
X-Gm-Message-State: AOAM532dv712YE3e96Oce6FyF4Y7B5kGdqcdJrS85fqAzy3v3imG4FYA
        YlSTBd5NQewyaNHyYzGvRzxVXNPoFoc=
X-Google-Smtp-Source: ABdhPJwXb/TzOgyVfLsyWnWwPRqugxTC5QARUJ3Pgqz8B3JO7IIcMGOreJjxbv0+01tqG5t29zvuMQ==
X-Received: by 2002:a17:90a:ef81:: with SMTP id m1mr2956123pjy.212.1603955237165;
        Thu, 29 Oct 2020 00:07:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y22sm1752772pfr.62.2020.10.29.00.07.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:07:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 15/16] sctp: handle the init chunk matching an existing asoc
Date:   Thu, 29 Oct 2020 15:05:09 +0800
Message-Id: <f07cda44f4039fac54d48ddf82ae3fda953617af.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <566c52da624a35533e0d0403f6218dbe9d39589c.1603955041.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
 <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
 <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
 <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
 <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
 <88a89930e9ab2d1b2300ca81d7023feaaa818727.1603955041.git.lucien.xin@gmail.com>
 <dcea42706709242930ae2d019355f27e7ca745d3.1603955041.git.lucien.xin@gmail.com>
 <566c52da624a35533e0d0403f6218dbe9d39589c.1603955041.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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

