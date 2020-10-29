Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8D29E466
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgJ2HYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgJ2HYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:36 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86440C08EA74;
        Thu, 29 Oct 2020 00:06:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s22so1571503pga.9;
        Thu, 29 Oct 2020 00:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6TmT0zpWssi6omB7JYKtqocDaBeiltFJDNS384mLiKE=;
        b=px+wcjAcheTBz1Cj4SeFNo3F6/MkW+W9Aq83xTXOixoWjGtA92gDg2bbck9EJszVc4
         Qxkq+zKT+Z7M/XUNQA9vSJbZA5yh6lq3K277ac4v38/KoC9wro/vKQPSo9rMfW7tQaOZ
         89eC55UQXOngRgz4xjxLnjb384GF7enlj1zyrDQ/X1AYbLDlMLEBNAx0gVjBxME8k0Y9
         b7bbQBwmKS0Mw0KxzuaJIaM0Hll4eFLzjQEOB+NWw76kYf11eAER2S/nbubOdhUnSRVH
         unqAFSa5N+bCaBzpU+QW6XbKV+1D88lbxEBhxkltqSCTYMm5R3KWMTLvCH8DEWDKsU7h
         vw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6TmT0zpWssi6omB7JYKtqocDaBeiltFJDNS384mLiKE=;
        b=PbT4TYYKqVvzjmB7iRi30adKTKIJOLtaRbaRakJI+EuJnuWSQzGs6Xv4BAnU0JJEQF
         MVmji7GTutQsKu1vWa/0V91u5PGcxUr+De12vp6RBYpCL7l6XzTVA7tcSZpeYJ0b+hBU
         LKWk0wA7e1rzKp+ZvB0div30uk+ApPDHYCUGReXDxSe1q/xIUd5soZo+doSLqzAywVtB
         tDstF7FWkioYOSspZrXqdg5U4yAyg3P8iZDR3Ug/5NbeMdVvv3ZfOKcE00+gn4qp5zB3
         H8AjZo00SIDB9dTVmHRwza+d3DK/3bqW35PBUBkfZumB0zYm9SNqzJK0h0V5yzz4BFkW
         Qh2g==
X-Gm-Message-State: AOAM5333lEc1dkubg1w5ZQbY8vWQMXNpGaMOShLSC6f7v2l9bAJO9+C0
        kYKM8/P2uD42Qvu3LqwGoOpQVBfR2k4=
X-Google-Smtp-Source: ABdhPJwdX3rX3fATd0/bsFeAYyc1I2nUKSVcQmdyN3LgXeGyKRzr0mECpZQf+SLr9ZuJ3X71gVHDew==
X-Received: by 2002:a17:90a:a394:: with SMTP id x20mr2849391pjp.213.1603955199736;
        Thu, 29 Oct 2020 00:06:39 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nm11sm1747483pjb.24.2020.10.29.00.06.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 10/16] sctp: add udphdr to overhead when udp_port is set
Date:   Thu, 29 Oct 2020 15:05:04 +0800
Message-Id: <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
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
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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

