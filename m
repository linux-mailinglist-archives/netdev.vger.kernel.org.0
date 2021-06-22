Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6403B1040
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhFVW44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhFVW4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 18:56:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A4BE61042;
        Tue, 22 Jun 2021 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624402478;
        bh=tdijdXDmNYtsiY2V/IjRRNu5X1ZuOn4QcSnK5odX/LI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrzbYTg4qc9SJtYOu5AWZ8veVXfekZ8KZapS8uZbAkaPcKQzTHx6R1c9mS6xrKPMn
         RwRLtNFg0Yere99q3TT5Q8eqmPdp53VlR7i9EVoOShePC4UAoaWMRG0/70b18RfSuL
         1gvuPmi92mUCkOuTxYW5OClcSnaogwHsy5row1QpZ2Bz62uuoO415iZ2HUhcO19Kd7
         CHi0X9V1C0W5sOecHN67/0OIDA2Nh+KBzuzF8c1u4l17DDgAhIBX1VgIsFrrf7gfx+
         ES2/aPPQ18dm8mrhG1ejY3VGtvY1IHz2wv8ZcKG5sAfTIV63fkf4SRJ3/1M8gl6AUt
         sb3fwEbyEVJrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>, Dave Jones <dsj@fb.com>
Subject: [PATCH net-next v2 2/2] net: ip: avoid OOM kills with large UDP sends over loopback
Date:   Tue, 22 Jun 2021 15:50:57 -0700
Message-Id: <20210622225057.2108592-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622225057.2108592-1-kuba@kernel.org>
References: <20210622225057.2108592-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave observed number of machines hitting OOM on the UDP send
path. The workload seems to be sending large UDP packets over
loopback. Since loopback has MTU of 64k kernel will try to
allocate an skb with up to 64k of head space. This has a good
chance of failing under memory pressure. What's worse if
the message length is <32k the allocation may trigger an
OOM killer.

This is entirely avoidable, we can use an skb with frags.

af_unix solves a similar problem by limiting the head
length to SKB_MAX_ALLOC. This seems like a good and simple
approach. It means that UDP messages > 16kB will now
use fragments if underlying device supports SG, if extra
allocator pressure causes regressions in real workloads
we can switch to trying the large allocation first and
falling back.

Reported-by: Dave Jones <dsj@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/ip_output.c  | 2 +-
 net/ipv6/ip6_output.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 90031f5446bd..1ab140c173d0 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1077,7 +1077,7 @@ static int __ip_append_data(struct sock *sk,
 
 			if ((flags & MSG_MORE) && !has_sg)
 				alloclen = mtu;
-			else if (!paged)
+			else if (!paged && (fraglen < SKB_MAX_ALLOC || !has_sg))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c667b7e2856f..46d805097a79 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1585,7 +1585,7 @@ static int __ip6_append_data(struct sock *sk,
 
 			if ((flags & MSG_MORE) && !has_sg)
 				alloclen = mtu;
-			else if (!paged)
+			else if (!paged && (fraglen < SKB_MAX_ALLOC || !has_sg))
 				alloclen = fraglen;
 			else {
 				alloclen = min_t(int, fraglen, MAX_HEADER);
-- 
2.31.1

