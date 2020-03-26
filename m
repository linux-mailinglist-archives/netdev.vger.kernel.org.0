Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62BC0194D79
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCZXsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:48:04 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46042 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCZXsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:48:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id t17so7150261qtn.12;
        Thu, 26 Mar 2020 16:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dkNOMi2FtYTC8+a1lToB3ldA1tOEr8r2kseCPrwn7bQ=;
        b=CWz0mmxZ9XGJfdspK7yzkSjQ6IrhII30rMMnQxDe1nnuVFYxrwGIrlmOv8vykAm8U5
         g3DMpXxQqEHKLpPw7oaVueFGiT8j1vS6zmIjtNL9851AMa6Ozd27PL//JKAkZtS4ZPhD
         6CUQ3ucCL4zDDofXSJ81rKpAJQDF538rLQUboq6yvUO5B9gIylh+J0bh8eLsLrITsZsB
         c3UEpGqh0HCqsnoD4v81E7XehEkin5S6W4VRoRVQpJRSmOYP22TC3k9BSC8vX27kJ4Gh
         ajBp9YIWuxoQ4mktBLJS6A7wPOuGpYPBTOtWJooPPPv2E/8d60fKVP5/Xkjfl5ePv/1e
         nTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dkNOMi2FtYTC8+a1lToB3ldA1tOEr8r2kseCPrwn7bQ=;
        b=lMAJ9g7qxBK4hh6nwqT4Dx2JxxAz6tpgu/svLAxJqd+U6ZiCWntuLE429+JjTkPGDH
         5kK3PiPEOBEOJNHFmq7lDPEE1G+jBSeRSUa7YAwqd19k8n1Crj5R0PZD4RUsksKH/yPb
         VCjnFLmIX1DWArmqO4qt6eUJk4vzg27swKsDFVcEyNSqByTKtObYLauvYaRAG1L+a/ZS
         Ty0pVAqZjKrd0TwbWH31RL22X+EO2BKwS9kAQJi6K8fvLduZfHsM/wrEamaVrMyJ22av
         YO5DNKYMH+oG14AdVskynIjVh8AfbRcTKmOnMSKcntcnZDGAVRtjBW78gYHad2x32tvB
         oT/Q==
X-Gm-Message-State: ANhLgQ1w/p18WWXm35bf8bXCqVc7zAgI49ZsxnPk3OueJL9ktOBzwrWL
        y0DXFwC1dOmb5rFHB7hUSfjExxUKs1s=
X-Google-Smtp-Source: ADFU+vtSDB+DTBVXA5XhdAS6lDdROuNob/pA7C8oWabhnS+/19qhzSmzE8QyXtV8dnUW+3hjokTRhQ==
X-Received: by 2002:aed:2625:: with SMTP id z34mr11705906qtc.276.1585266482951;
        Thu, 26 Mar 2020 16:48:02 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.248])
        by smtp.gmail.com with ESMTPSA id 193sm2524605qkj.1.2020.03.26.16.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 16:48:02 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 89770C5CE4; Thu, 26 Mar 2020 20:47:59 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jin Meng <meng.a.jin@nokia-sbell.com>
Subject: [PATCH net] sctp: fix possibly using a bad saddr with a given dst
Date:   Thu, 26 Mar 2020 20:47:46 -0300
Message-Id: <d6baf212bdd7c54df847e0b5117406419c993a4f.1585182887.git.mleitner@redhat.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under certain circumstances, depending on the order of addresses on the
interfaces, it could be that sctp_v[46]_get_dst() would return a dst
with a mismatched struct flowi.

For example, if when walking through the bind addresses and the first
one is not a match, it saves the dst as a fallback (added in
410f03831c07), but not the flowi. Then if the next one is also not a
match, the previous dst will be returned but with the flowi information
for the 2nd address, which is wrong.

The fix is to use a locally stored flowi that can be used for such
attempts, and copy it to the parameter only in case it is a possible
match, together with the corresponding dst entry.

The patch updates IPv6 code mostly just to be in sync. Even though the issue
is also present there, it fallback is not expected to work with IPv6.

Fixes: 410f03831c07 ("sctp: add routing output fallback")
Reported-by: Jin Meng <meng.a.jin@nokia-sbell.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/ipv6.c     | 20 ++++++++++++++------
 net/sctp/protocol.c | 28 +++++++++++++++++++---------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index bc734cfaa29eb6acf2b09d641fc6b740595bfcec..c87af430107ae444d9eb293d96f9423730a72033 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -228,7 +228,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 {
 	struct sctp_association *asoc = t->asoc;
 	struct dst_entry *dst = NULL;
-	struct flowi6 *fl6 = &fl->u.ip6;
+	struct flowi _fl;
+	struct flowi6 *fl6 = &_fl.u.ip6;
 	struct sctp_bind_addr *bp;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct sctp_sockaddr_entry *laddr;
@@ -238,7 +239,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	enum sctp_scope scope;
 	__u8 matchlen = 0;
 
-	memset(fl6, 0, sizeof(struct flowi6));
+	memset(&_fl, 0, sizeof(_fl));
 	fl6->daddr = daddr->v6.sin6_addr;
 	fl6->fl6_dport = daddr->v6.sin6_port;
 	fl6->flowi6_proto = IPPROTO_SCTP;
@@ -276,8 +277,11 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	rcu_read_unlock();
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
-	if (!asoc || saddr)
+	if (!asoc || saddr) {
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
 		goto out;
+	}
 
 	bp = &asoc->base.bind_addr;
 	scope = sctp_scope(daddr);
@@ -300,6 +304,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 			if ((laddr->a.sa.sa_family == AF_INET6) &&
 			    (sctp_v6_cmp_addr(&dst_saddr, &laddr->a))) {
 				rcu_read_unlock();
+				t->dst = dst;
+				memcpy(fl, &_fl, sizeof(_fl));
 				goto out;
 			}
 		}
@@ -338,6 +344,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 			if (!IS_ERR_OR_NULL(dst))
 				dst_release(dst);
 			dst = bdst;
+			t->dst = dst;
+			memcpy(fl, &_fl, sizeof(_fl));
 			break;
 		}
 
@@ -351,6 +359,8 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 			dst_release(dst);
 		dst = bdst;
 		matchlen = bmatchlen;
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
 	}
 	rcu_read_unlock();
 
@@ -359,14 +369,12 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		struct rt6_info *rt;
 
 		rt = (struct rt6_info *)dst;
-		t->dst = dst;
 		t->dst_cookie = rt6_get_cookie(rt);
 		pr_debug("rt6_dst:%pI6/%d rt6_src:%pI6\n",
 			 &rt->rt6i_dst.addr, rt->rt6i_dst.plen,
-			 &fl6->saddr);
+			 &fl->u.ip6.saddr);
 	} else {
 		t->dst = NULL;
-
 		pr_debug("no route\n");
 	}
 }
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 78af2fcf90cc50cdfca6e7c91bd63dd841eb5ec2..092d1afdee0d23cd974210839310fbf406dd443f 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -409,7 +409,8 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 {
 	struct sctp_association *asoc = t->asoc;
 	struct rtable *rt;
-	struct flowi4 *fl4 = &fl->u.ip4;
+	struct flowi _fl;
+	struct flowi4 *fl4 = &_fl.u.ip4;
 	struct sctp_bind_addr *bp;
 	struct sctp_sockaddr_entry *laddr;
 	struct dst_entry *dst = NULL;
@@ -419,7 +420,7 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 
 	if (t->dscp & SCTP_DSCP_SET_MASK)
 		tos = t->dscp & SCTP_DSCP_VAL_MASK;
-	memset(fl4, 0x0, sizeof(struct flowi4));
+	memset(&_fl, 0x0, sizeof(_fl));
 	fl4->daddr  = daddr->v4.sin_addr.s_addr;
 	fl4->fl4_dport = daddr->v4.sin_port;
 	fl4->flowi4_proto = IPPROTO_SCTP;
@@ -438,8 +439,11 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		 &fl4->saddr);
 
 	rt = ip_route_output_key(sock_net(sk), fl4);
-	if (!IS_ERR(rt))
+	if (!IS_ERR(rt)) {
 		dst = &rt->dst;
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
+	}
 
 	/* If there is no association or if a source address is passed, no
 	 * more validation is required.
@@ -502,27 +506,33 @@ static void sctp_v4_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		odev = __ip_dev_find(sock_net(sk), laddr->a.v4.sin_addr.s_addr,
 				     false);
 		if (!odev || odev->ifindex != fl4->flowi4_oif) {
-			if (!dst)
+			if (!dst) {
 				dst = &rt->dst;
-			else
+				t->dst = dst;
+				memcpy(fl, &_fl, sizeof(_fl));
+			} else {
 				dst_release(&rt->dst);
+			}
 			continue;
 		}
 
 		dst_release(dst);
 		dst = &rt->dst;
+		t->dst = dst;
+		memcpy(fl, &_fl, sizeof(_fl));
 		break;
 	}
 
 out_unlock:
 	rcu_read_unlock();
 out:
-	t->dst = dst;
-	if (dst)
+	if (dst) {
 		pr_debug("rt_dst:%pI4, rt_src:%pI4\n",
-			 &fl4->daddr, &fl4->saddr);
-	else
+			 &fl->u.ip4.daddr, &fl->u.ip4.saddr);
+	} else {
+		t->dst = NULL;
 		pr_debug("no route\n");
+	}
 }
 
 /* For v4, the source address is cached in the route entry(dst). So no need
-- 
2.25.1

