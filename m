Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3339928C93A
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390105AbgJMH17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:27:59 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E664C0613D0;
        Tue, 13 Oct 2020 00:27:59 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b193so16078434pga.6;
        Tue, 13 Oct 2020 00:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=shmCcPCC3BKRGSsP5ReVaQM3GPq6uAoRhJHnCy/xgF7/tHsG7UmxX1JOWntvb4H8XS
         XxQ6QJyT7tpEotgoo/ChXHpheJw16ceGqIZxZLTh2H1wTeXpqZHPqrtKguh4FOL8ikMH
         L4jLVgmVH/sykm2wvHa+2TVtEwXBr6/ewHhQJT1r84uLhn0igqPLwEjleiCs0/hltI8M
         D2FWehMnhiDh6uvE7MboKdqaFtX4IzcIooexLxLZ2GHWedIwMTnpV3H7C2f64kqxjW8x
         dblBd6q07nIPx+z5CNv1oz5h8rspH31w/F7k8basO1GxlgsWGeuaD/3MIqBJCL1reLs1
         BuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=arykkZ+/Ro4OkthZBI2oum7ZQzq2ei3u7KASBDftOrvZD8/ifh5Dj8++Ixp52rmCnW
         50KdJJjun3UJ6YR8DljCMaWCGfzipj1yu9Bnbp5WqUfJNPAR7s7ZM5opAKAlTZq+zdTB
         JzztDG95BpmwqmCRS8xgjW+v4HXPnXKVxppowIHYRb/74Z1+Im0j+mEz0JYOltue0bVV
         95UzumQupIxTzaK0E3tvP99N/gePsXhi9/jansAckMD2n6dbIHm8f12uMYLg7c9HC7tF
         d/D5ysWSIZO0DaWlf0U+3fsuOV8joHr3W5pxVXWmp2CkFg476itmkDn+FRlEOwVY/hgo
         4Lkg==
X-Gm-Message-State: AOAM532rdOUpnlDJWo1GHkXJbAXjR3lZFNvpevUuW6CXgZs6aNd3NVOD
        g68BdJuL/+gLqpf0UODcBlerXOS0fiE=
X-Google-Smtp-Source: ABdhPJym/DJAfIGKhdOhkBrkbaQKQhK9O9z29llMz1dn9QmEr/dBugdD+RAX16/mSgDwgqT27vQpLw==
X-Received: by 2002:a63:564e:: with SMTP id g14mr9756014pgm.59.1602574078103;
        Tue, 13 Oct 2020 00:27:58 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j138sm22281582pfd.19.2020.10.13.00.27.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:27:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 01/16] udp: check udp sock encap_type in __udp_lib_err
Date:   Tue, 13 Oct 2020 15:27:26 +0800
Message-Id: <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a chance that __udp4/6_lib_lookup() returns a udp encap
sock in __udp_lib_err(), like the udp encap listening sock may
use the same port as remote encap port, in which case it should
go to __udp4/6_lib_err_encap() for more validation before
processing the icmp packet.

This patch is to check encap_type in __udp_lib_err() for the
further validation for a encap sock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23..ca04a8a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -702,7 +702,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691..cde9b88 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -560,7 +560,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
-- 
2.1.0

