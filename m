Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994B728C94E
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390237AbgJMH3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390054AbgJMH3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:29:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5815C0613D0;
        Tue, 13 Oct 2020 00:29:04 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g16so167605pjv.3;
        Tue, 13 Oct 2020 00:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=c/V+vNDJrOspJRGxife48bCWIoOHzBRQJZlEDRIn4AA=;
        b=QyQZXHpBIf34iisy7I4EFjzoZ/q4d1K8oBQfHgknidG73CG52qSRjFQC0TCnOXebft
         R7KqD21Zm5M6fuq7RGNo64ZMdpxsCSR+VJ8FK9hCKPrjEoNeVMDsUcBdJfg+FWWkRrV+
         GDpz9o3UOPAYYA3tBpr5lUoP+jojf9CDKHwzej+UnZuhn1gjRdKHhW9hW9e+Ms8DaWEG
         c7J6j1pw10cKXJdCljWjRK/OmfU8Y0k3FxkunnBcAUDXmB03Jb+s+QTMwKQnZywDsHvk
         iMhF10cmlO7rEWTHohIp/q444zYDK1K8EsFAXJxz2S95Kw7XfvLwxDF8gSTrRMEo8ex6
         EAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=c/V+vNDJrOspJRGxife48bCWIoOHzBRQJZlEDRIn4AA=;
        b=raykKK+VeQExWfLhAyWz5llGRX/i/lKQM77gPn/6tYagQ5pfV19jWB+/6boQDGrzE2
         62GSdv1JtYg7cPlP1Zlz/sD69VHs8JaZK0jhgs6rj0rZWXzVKTGKWFbUggd4hwVHDhnE
         spsBhcz7kqQdVFuJ9mHKCuh9oqvTr6tpwWXoQ9mye41Icc7aGtl5T+I/o5KC+xYVMIy0
         rSqQI/eUZJpNPYQWfSPsH+7CvZKU0GMfDk9qzUGBX2/WrJvSBxsbVO6hgH3MR4Mi7kLs
         3AiKLjPACdgOX5J2ac03nIpSrRTRUxMsV0HhD89SVIBspHKzAt3Dlvfkkk2U113vEojv
         w0Qw==
X-Gm-Message-State: AOAM532NHkMgYBwj6R5oN566lxBVaKSJHjUriIU4qTWoiB0bAR8sQpA0
        teNrxt94Y2ll9tujCmDJtdHF5hKYCKU=
X-Google-Smtp-Source: ABdhPJzrwGq4VqGarxSvT4MlVDTkL6QunpUwQ7sxlEvExcaGNty32JBFUgmWZylLkLPv3ImdbHK4XA==
X-Received: by 2002:a17:902:ec02:b029:d1:fc2b:fe95 with SMTP id l2-20020a170902ec02b02900d1fc2bfe95mr28008816pld.79.1602574143942;
        Tue, 13 Oct 2020 00:29:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t17sm8769335pjs.39.2020.10.13.00.29.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:29:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 10/16] sctp: add udphdr to overhead when udp_port is set
Date:   Tue, 13 Oct 2020 15:27:35 +0800
Message-Id: <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
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
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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
index 26e464b..8e1dcfb 100644
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

