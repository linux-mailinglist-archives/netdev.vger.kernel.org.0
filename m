Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006972B9CEE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgKSVX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKSVX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:23:56 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955CC0613CF;
        Thu, 19 Nov 2020 13:23:54 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id k4so6908988qko.13;
        Thu, 19 Nov 2020 13:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=rsJB7zlj1ubuXabMIzGnYmJ1xAmzWzPfgMBEPVTYqiw=;
        b=M+xlC4LZ0W0RBfeQ8bJKTXQ6k4Wk7hm7LybWzFmAL9hXJ5GkrSrBLrDlbzbNsXDqwt
         jdOcFj5Q4SQq5ohkBCFDDF/aIo2rAiHlKFpck3ljklGkj3dkZkEwYg/Hj8HzrNTDGclZ
         L9rkMmfnz3ahKXjxCzg8/CHmjd482AkPM0ZNKakx9q2015rMOkiaPZDo8MYKtGAgWh9a
         DJNFKRcZylV30pLZEe/OwX/8D0LiC4XgFxdwV0DzodgWbt34uW/OLbn0HESX47yEjjk4
         qxhyWtTrwuEXGi+yNVvS25kDeDd2vZSve0r5W1SbAC5RtPM6LRABJG4lVJBeapE7obXd
         UVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rsJB7zlj1ubuXabMIzGnYmJ1xAmzWzPfgMBEPVTYqiw=;
        b=DSi387vXajWvy8V+AjWbwMhv+7si64tDOYAqLZzV+uhtKkN0H9lKMRO/pEu0CHONCA
         PpdwtPyOFOcTd7I3A26kDRpG+8xMRrfp7kGfvV5ekehZQGkK9kbI3lM4spEyoeWXP6Hg
         FimX8++8q7sAoQY2Zh5gxi4D0xlvamqrA3y5fA0AVk9EVpVc5ZPew09ZvlAotzB/+tH8
         eg5huGh13q/lHfPcTLpmQ19EPaarb43q8OzdB5QSooJ0OXrVKaAgm2ktGjDo2neI+Hii
         Iv9cZ1t1SBfg5yOpit9GDT8X8an7sqtiHJvEXyxPUV+xe5Jb9AN9VqQ0CcgQrXIlZ8if
         uKlw==
X-Gm-Message-State: AOAM533z1fCwkf/aFFFRfywHor4wK5CvMP5ql9aRFG90H09HHSbUqQLi
        xluTkGYsn8irp4O+Buc+kNdRXKU3vvnEug==
X-Google-Smtp-Source: ABdhPJxZLSkvv9TBTCU9BtisX+3eGnv9olK8d5wylR+7gk3o9am0gce+0Ms+ziup2x2RwSOr0cixQQ==
X-Received: by 2002:a37:a855:: with SMTP id r82mr12429026qke.132.1605821033465;
        Thu, 19 Nov 2020 13:23:53 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 21sm796088qkv.78.2020.11.19.13.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 13:23:52 -0800 (PST)
Subject: [net PATCH 1/2] tcp: Allow full IP tos/IPv6 tclass to be reflected in
 L3 header
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        kernel-team@fb.com, edumazet@google.com, brakmo@fb.com,
        alexanderduyck@fb.com, weiwan@google.com
Date:   Thu, 19 Nov 2020 13:23:51 -0800
Message-ID: <160582103106.66684.9841738004971200231.stgit@localhost.localdomain>
In-Reply-To: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
References: <160582070138.66684.11785214534154816097.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

An issue was recently found where DCTCP SYN/ACK packets did not have the
ECT bit set in the L3 header. A bit of code review found that the recent
change referenced below had gone though and added a mask that prevented the
ECN bits from being populated in the L3 header.

This patch addresses that by rolling back the mask so that it is only
applied to the flags coming from the incoming TCP request instead of
applying it to the socket tos/tclass field. Doing this the ECT bits were
restored in the SYN/ACK packets in my testing.

One thing that is not addressed by this patch set is the fact that
tcp_reflect_tos appears to be incompatible with ECN based congestion
avoidance algorithms. At a minimum the feature should likely be documented
which it currently isn't.

Fixes: ac8f1710c12b ("tcp: reflect tos value received in SYN to the socket")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv4/tcp_ipv4.c |    5 +++--
 net/ipv6/tcp_ipv6.c |    6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c2d5132c523c..c5f8b686aa82 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -981,7 +981,8 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 	skb = tcp_make_synack(sk, dst, req, foc, synack_type, syn_skb);
 
 	tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
-			tcp_rsk(req)->syn_tos : inet_sk(sk)->tos;
+			tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
+			inet_sk(sk)->tos;
 
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
@@ -990,7 +991,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 		err = ip_build_and_send_pkt(skb, sk, ireq->ir_loc_addr,
 					    ireq->ir_rmt_addr,
 					    rcu_dereference(ireq->ireq_opt),
-					    tos & ~INET_ECN_MASK);
+					    tos);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8db59f4e5f13..3d49e8d0afee 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -530,12 +530,12 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 		rcu_read_lock();
 		opt = ireq->ipv6_opt;
 		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
-				tcp_rsk(req)->syn_tos : np->tclass;
+				tcp_rsk(req)->syn_tos & ~INET_ECN_MASK :
+				np->tclass;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
 		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,
-			       tclass & ~INET_ECN_MASK,
-			       sk->sk_priority);
+			       tclass, sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}


