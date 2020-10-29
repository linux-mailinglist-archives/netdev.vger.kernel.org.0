Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D615329E3C2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgJ2HVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgJ2HU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:20:58 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1A5C08E8AE;
        Thu, 29 Oct 2020 00:05:28 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x13so1575379pgp.7;
        Thu, 29 Oct 2020 00:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=n5QS4lq1xeSlJTfnw0v0Fi9KLZjHLLMrDZg7zuJ+PUi5X/GdVVp2LOtmYU/si9J0S8
         NceJif7Gjt6hZ+sU4ec2ZvZhF6GBqBMQQPcb7RrvouM6AhzxmeUuW7Am3SRx3Xlos20j
         Y8tERTnQdznQ0fUVyHK/Xf4XirsbOMtjRN6HQyCB8WEV/LcfLlMIkRHlimDL1ULtY+jF
         IyuztcKFbm7ReN3ocHum70WX+Gsat09zOHIP0Asnf5COJEQZ94V/exbWNdYQSjgi33xq
         nad9pv0ccupiRj/N97+1OB31sBsU9x5h0FCaARPfVX7vZzRdym6XwUIzYLLSxgbO/GUi
         8wPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=Uc9i9wJh5p8xPA1HqGQNjnW1mBmsyzuqSAsu7F9LwLuY2bFq8PoQm42xCp0BFNbfK5
         aUucb1bL7Q/sJu2Ldv1RrYZXifGUBhRgPYLOq+EWrOpAAtf4xz2MdCvcdu/iEfpr59hB
         WlvqdyAGNKqdvDWPXcF5wL5WrPvcGPYDWlp5gYYQx6kR6rnNm1bdORq1eW0C21A6DrJQ
         sIb4QqiFzYh88bVu7/Xz0ijtOal3lg4x938vj7vJvlQEu0jLKoDV5VVM9aWLrArOG5xO
         R6At+eCXZc/Z76Dae0chNjqN4wTpimA0jvNqnyYjw0a/ZkVlcipGDZJrCb6KNvEU95ez
         oRBw==
X-Gm-Message-State: AOAM532yaE/qQolNhkZb2HyJTdZgW8A2Y5iUVIIGe7q+S5C8w6hbFUm4
        y1pT0k7I+NlDiSUrrpuV2rmJLqp57yQ=
X-Google-Smtp-Source: ABdhPJz01vaxX/Qq4Nfx2wuMuFt5+ir6H2uSn4qpq51DJfIIeENHpHJbc2xgNxUPMK39nLoIQClb+Q==
X-Received: by 2002:a63:9909:: with SMTP id d9mr158690pge.360.1603955127779;
        Thu, 29 Oct 2020 00:05:27 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e3sm1441726pgm.93.2020.10.29.00.05.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:05:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 01/16] udp: check udp sock encap_type in __udp_lib_err
Date:   Thu, 29 Oct 2020 15:04:55 +0800
Message-Id: <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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

