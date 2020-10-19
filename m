Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5ED292745
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgJSM06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbgJSM05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:26:57 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8491C0613CE;
        Mon, 19 Oct 2020 05:26:56 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h2so4882938pll.11;
        Mon, 19 Oct 2020 05:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6TmT0zpWssi6omB7JYKtqocDaBeiltFJDNS384mLiKE=;
        b=UPLEcZpYHug+vKz040o8b3sGylzOz6BIqJRqC//idSvYfut3DYRLu7wnHyTOcJTCjp
         wAL/kpiZj8g8WcCAeDcuJIqB3jSmNC/GCkdgZnEsmYZkX+WRQ+eyo6cNw4x28a/f7MNr
         s3XEC9bx588oYjxvHSTl24QrBmUHiD9YwqQ+qnzs4At1PKweQ+rMNeTUo7O3yN6n7H1E
         owpvLSTt8RUrkxQQURbvHCUGANwaq9Vp++kKwMRwMLiNjHA2v18SRutwywTUKfQqHPni
         eBt7LM95zeaWm8PZSvZu8ZoNy40Ca6U/UiCFTN0P4nRH2NJiLvr5cG1XpwZskz7x3xA/
         OHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6TmT0zpWssi6omB7JYKtqocDaBeiltFJDNS384mLiKE=;
        b=phXVANgCg1Evpv168ovcAJXdhCrRM2Iklfc1bK4LMXKlFMMQCQ/fZHW1uwOERdYL7+
         1mf2aqvdFSQzOkFGssofvPvmDE+4v/mlkkSmv7QGg0UoWIXg4OKeUjVWd0oBPFZJtrwO
         G0lF8UFgh8pKxw5xDBgKViNLM9pPUi2LM6aPolpwsvGCSS/JtLKVIXqODNkasAu4HX62
         nGzQOhCffcSpnzV6dWfjGZi3sAozFgnLJ+AzqOaxyRkn9w0zMDYds+eGp5QuIByjCMlU
         S+XixVtRHvLDq7yjPOk4NF5yNAdtwkC18YiUIzdhWUj8UCV4rs6Ra/JPDncqnw7TWsv/
         +yZg==
X-Gm-Message-State: AOAM532tp5KKtlTTZW1IRvWllYuQVkN84Ho8PiRAOz3IRfFy/AMAK8wM
        1c8gVZuCvwhrKPNp2BdD2axL7KquBUk=
X-Google-Smtp-Source: ABdhPJzhO8rMhINNt7L+oMr2gmm2X0TlvD0mGKlct8qL1+v5fizRlNSSIqWJ0gXE9nlOk6N0+HnG1w==
X-Received: by 2002:a17:90b:312:: with SMTP id ay18mr16987873pjb.17.1603110415974;
        Mon, 19 Oct 2020 05:26:55 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k14sm10968111pfu.163.2020.10.19.05.26.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:26:55 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 10/16] sctp: add udphdr to overhead when udp_port is set
Date:   Mon, 19 Oct 2020 20:25:27 +0800
Message-Id: <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
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
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_mtu_payload() is for calculating the frag size before making
chunks from a msg. So we should only add udphdr size to overhead
when udp socks are listening, as only then sctp can handle the
incoming sctp over udp packets and outgoing sctp over udp packets
will be possible.

Note that we can't do this according to transport->encap_port, as
different transports may be set to different values, while the
chunks were made before choosing the transport, we could not be
able to meet all rfc6951#section-5.6 recommends.

v1->v2:
  - Add udp_port for sctp_sock to avoid a potential race issue, it
    will be used in xmit path in the next patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h    | 7 +++++--
 include/net/sctp/structs.h | 1 +
 net/sctp/socket.c          | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index bfd87a0..86f74f2 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -578,10 +578,13 @@ static inline __u32 sctp_mtu_payload(const struct sctp_sock *sp,
 {
 	__u32 overhead = sizeof(struct sctphdr) + extra;
 
-	if (sp)
+	if (sp) {
 		overhead += sp->pf->af->net_header_len;
-	else
+		if (sp->udp_port)
+			overhead += sizeof(struct udphdr);
+	} else {
 		overhead += sizeof(struct ipv6hdr);
+	}
 
 	if (WARN_ON_ONCE(mtu && mtu <= overhead))
 		mtu = overhead;
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 81464ae..80f7149 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -178,6 +178,7 @@ struct sctp_sock {
 	 */
 	__u32 hbinterval;
 
+	__be16 udp_port;
 	__be16 encap_port;
 
 	/* This is the max_retrans value for new associations. */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2a9ee9b..a710917 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4928,6 +4928,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->udp_port    = htons(net->sctp.udp_port);
 	sp->encap_port  = htons(net->sctp.encap_port);
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
-- 
2.1.0

