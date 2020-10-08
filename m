Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ECB2871E9
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgJHJtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:49:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506FEC061755;
        Thu,  8 Oct 2020 02:49:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o8so2506609pll.4;
        Thu, 08 Oct 2020 02:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=r065IKyXdFJ5GMOudMqVr03VgbZjGBH5pw37dEIt8yw=;
        b=FlDv+QExgF/i45sOO63T3sCZjZ8SD5VvUI/DB97k295irQH+pN0HARRIzlr10+2pD4
         HXq6ESJc8IgrMRAPadgk6nt7f0VJd8OvkSiHd4jQf9e8/hVT1cq1wd+B+K0ZtbJFxEzu
         FlpafJpAMUzwRE7rWHBm9SQbbp+5dXaeAWWGTz/9CwgGSbkEP1bkOLue45Z06lM02WW3
         kI09OchFishQdRQNQrY7HFHIw5rsZvAnH2vN19enYi/MRW+az9LbFSBLJy3wnxL93W3s
         Mwg4Z3Kvdh/J0yNdC5Yrrwwa8tz1yt1sI1kVVltT9EOYFvo2Swy3AFuFsk7K9tdIldXK
         jqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=r065IKyXdFJ5GMOudMqVr03VgbZjGBH5pw37dEIt8yw=;
        b=HfL+bWlHmIZKAk1pAWc3V4IaQCsgylSyuvPwS1snjNBSuy0ramZd9NIYEBq94h6HFQ
         ebb4HZq9KwtUi/MIohagpDYeKa2ZzpL0b8plIZXCvoHm7tPEufkmgpBH4XDDR2ueHodi
         FJ0n8GpzASQKWcTDY87ztPYhbJbOQEVrcjDp0fJnI7w+Z8i10BA8i+fhinzq9bzi+4CO
         /RAXmi9z6sAg2GYHzsSyRi6VO5xJzHhjkASJZzu4LXV2pzK+LRvnuG+gfQ2yqXhWbmjj
         Co+n5z+8o3aXwgG8EVN+UvazroqZo9bura4bFiQtzklgcYgFlg71hFoQizDrCpZq5cpe
         fN3w==
X-Gm-Message-State: AOAM533voGW9mPoZMQjRE/eJUE9m6JiRYNRVLblt1xhDJrGM5gO7/OL2
        gvlGlZA6uvklOYYJ4tMRhvvhnQ9jekA=
X-Google-Smtp-Source: ABdhPJwnklnf2845eRn/TNO/4TW0SgYIc9M5xfZYMuQ4s4yGMDSRu64/thCQEe4BG76zktXa+7ezHw==
X-Received: by 2002:a17:902:aa90:b029:d3:b2d3:44ef with SMTP id d16-20020a170902aa90b02900d3b2d344efmr6790987plr.60.1602150589570;
        Thu, 08 Oct 2020 02:49:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o17sm6110166pji.30.2020.10.08.02.49.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:49:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 11/17] sctp: add udphdr to overhead when udp_port is set
Date:   Thu,  8 Oct 2020 17:48:07 +0800
Message-Id: <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
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
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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
index c9e86f5..192ab9a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4926,6 +4926,7 @@ static int sctp_init_sock(struct sock *sk)
 	 * be modified via SCTP_PEER_ADDR_PARAMS
 	 */
 	sp->hbinterval  = net->sctp.hb_interval;
+	sp->udp_port    = htons(net->sctp.udp_port);
 	sp->encap_port  = htons(net->sctp.encap_port);
 	sp->pathmaxrxt  = net->sctp.max_retrans_path;
 	sp->pf_retrans  = net->sctp.pf_retrans;
-- 
2.1.0

