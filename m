Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D432429E506
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbgJ2HYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgJ2HYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:35 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE321C08EA75;
        Thu, 29 Oct 2020 00:06:48 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 13so1580325pfy.4;
        Thu, 29 Oct 2020 00:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=vMjbRXCHxjly4KBHeowv4WArdSpuEQVziNdCx0WvZiXH91WLUMi2VPNoxisdyXj6Se
         YxKaaoCuyK8j7qPh3Bbu9nzLOtpHZH6QsJTRcdhiNSgfFLjTXTpykqv943ZKobVnmGLl
         TIg4g1AEErNrpGrTUZdJ6VuaDMq1fHOKlxzrjETvgL5txFY74pL0I+Ptyft8DfyARpzj
         tudlNc1PgwgThMQ1yjJVE0eq/CeS3vqzxThM7XAyj/qH+Q9zhUsC9zZdEe/yE2iCOQKy
         A5lHU52ngIuZgNXQgvTJQJ3X+me3MGcwezKDUfBV15gHssoGskHvtkdXuVZWH2z/HQIP
         q9+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=N4ettp2P6JRI1eqyP1zAfULMYonIst52TpOPiFfJwbJ+bQ5ps0Vn/RdyDrtpSkR93r
         oPdarqEjVh3kA6njA0+Oza8zPcsliJQgKoRrt87eetaMR51yiNKQ1Sdc+iAjkOaFMKih
         kft9/ncoWBYywStfhVG83YEri938OKsPVcXrtdBWEi00rFfLay+3yUanwRavQvi/Eud+
         D+E6xxfl4Z9ivcvZSLpb+jbYSaJxbn49XWNKzqgPD/1L6iMyRNRPXefZzOgcZfCkWhIt
         CoZEnQwWOrC6knaN8qDXM1B9XxRJLTKZ8Htqzl6T7/rxMgh+X0TploIdJvrjYtlhryns
         7fEQ==
X-Gm-Message-State: AOAM5307AzlnY/nbpEbjYs0bWnft+rwNwhn4wkn3rlQzD7e/5Ur83ewy
        +CmvoGGUJAxYCruWZh6S0wPvDQFirRM=
X-Google-Smtp-Source: ABdhPJzWJNk9pqOOpHM5Tpeq/a3wxMwoJ5GeAg7fRTEFsTVNZMlzMGlF6YUN19A34felxGZueBtb+g==
X-Received: by 2002:a17:90b:460e:: with SMTP id ia14mr2802328pjb.7.1603955208288;
        Thu, 29 Oct 2020 00:06:48 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z30sm1788018pfq.87.2020.10.29.00.06.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:47 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 11/16] sctp: call sk_setup_caps in sctp_packet_transmit instead
Date:   Thu, 29 Oct 2020 15:05:05 +0800
Message-Id: <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
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
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
Add GSO support"), as:

  "We have to refresh this in case we are xmiting to more than one
   transport at a time"

This actually happens in the loop of sctp_outq_flush_transports(),
and it shouldn't be tied to gso, so move it out of gso part and
before sctp_packet_pack().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 1441eaf..fb16500 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -508,12 +508,6 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 					sizeof(struct inet6_skb_parm)));
 		skb_shinfo(head)->gso_segs = pkt_count;
 		skb_shinfo(head)->gso_size = GSO_BY_FRAGS;
-		rcu_read_lock();
-		if (skb_dst(head) != tp->dst) {
-			dst_hold(tp->dst);
-			sk_setup_caps(sk, tp->dst);
-		}
-		rcu_read_unlock();
 		goto chksum;
 	}
 
@@ -593,6 +587,13 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	}
 	skb_dst_set(head, dst);
 
+	rcu_read_lock();
+	if (__sk_dst_get(sk) != tp->dst) {
+		dst_hold(tp->dst);
+		sk_setup_caps(sk, tp->dst);
+	}
+	rcu_read_unlock();
+
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
-- 
2.1.0

