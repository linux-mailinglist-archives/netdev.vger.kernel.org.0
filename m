Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B94733CF9
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 04:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfFDCEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 22:04:45 -0400
Received: from cat-porwal-prod-mail1.catalyst.net.nz ([202.78.240.226]:36518
        "EHLO cat-porwal-prod-mail1.catalyst.net.nz" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725876AbfFDCEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 22:04:45 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2019 22:04:44 EDT
Received: from timbeale-pc.wgtn.cat-it.co.nz (unknown [IPv6:2404:130:0:1000:ed06:1c1d:e56c:b595])
        (Authenticated sender: timbeale@catalyst.net.nz)
        by cat-porwal-prod-mail1.catalyst.net.nz (Postfix) with ESMTPSA id BE17E81232;
        Tue,  4 Jun 2019 13:56:57 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=catalyst.net.nz;
        s=default; t=1559613419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zlxPk8Grmjvfc1gNhrJYrpT6xOBrQjE/mrwvf8Qc9M0=;
        b=tlbS4rAuReuDG+cTAMYG5To879bmPuCxZzvMOln/7pVB2R3HsKhzmBTldZFohzT6xCNm/d
        HdgMW9OpT7FGT5/Z3PiOBzZRaeGiufM9uL2BvqCi+1cai8DZqGncUKB0mIJufmC+aG+/nA
        QReWZsavQLEg7WcZv347TDDREz0SCI3m/yEeD11eRjU9xQTbAXiHJozznEEnyJTia+x3H4
        r4AZOVnWHF/S3o3rDSvuaIzJjLzMMjkg2scfneY9TM+vhCy34edgiAGKj8gSqaZdzY9UkJ
        h6tXVyF/pwjmTU3jhiUWenRZaCeIUiLnjfq8DWTR09bzNX3TU38/HBKTsVcX6g==
From:   Tim Beale <timbeale@catalyst.net.nz>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Tim Beale <timbeale@catalyst.net.nz>
Subject: [PATCH net] udp: only choose unbound UDP socket for multicast when not in a VRF
Date:   Tue,  4 Jun 2019 13:56:23 +1200
Message-Id: <1559613383-6086-1-git-send-email-timbeale@catalyst.net.nz>
X-Mailer: git-send-email 2.7.4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=catalyst.net.nz;
        s=default; t=1559613420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zlxPk8Grmjvfc1gNhrJYrpT6xOBrQjE/mrwvf8Qc9M0=;
        b=OGqnBs0jg5cS5u+Jz50M86Lk0ACDAQw0ZpNDJE4yIMpFegYZMfv3xHKhwRVD9P+gBP/VVG
        QiHdEevHjEa7yQrlpvg6w/fswFyaG/6o7bRuCJ1T/JjlC19vvWRkiXcyeBP6D5UN7VHvvz
        gyerxTm7ZvuPzgIl03LzOEuypV3ropePGmjFZ8P4RPs1/cbIqCFTKiv8vvlm6q4uVgTsVR
        j6ydAGePuZmeuUCXHh+PyJmspsX1XpxICpw7U80GsoJcEwBzZE4YuFMpPmYTPf3Ec71WZv
        7MbNQ3s9K4GzRiHAU+KgEas7NbyrCs0SIeNnfn3DTHZM8qUTczhf4iEQrT89zA==
ARC-Seal: i=1; s=default; d=catalyst.net.nz; t=1559613420; a=rsa-sha256;
        cv=none;
        b=s4rSGkei7s9QcgucrgDSCuqP+XhasqXQQnNWlvFR1a1iiNaZbC/a2xOF8wTbt0mfhSKl4s
        EHaDLOX8yNBen55fKt1mmJUQBBY3kSsx+QoPUforaBjgDekGb+AMbsR4h4gW+MptehfO7u
        ed4xDCiqv/FNrAva1jYS1nN77vuUtpeOteGiqOrWYZxyc68yXgp9PTNUEkmEPpkSRK6RPQ
        4To2lQZ4sAIpPtK+EyFhw61HO9n4LeVUrDpyA9IE+8pJRXHi5Dk8ZqZGzM91y0ynT64sPc
        RWJDPyExPnzRWpmUObfV5MRQEqgcR8JXfFJNbaeKrK3YRr89D/FI+dLaWUDGEw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=timbeale@catalyst.net.nz smtp.mailfrom=timbeale@catalyst.net.nz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, packets received in another VRF should not be passed to an
unbound socket in the default VRF. This patch updates the IPv4 UDP
multicast logic to match the unicast VRF logic (in compute_score()),
as well as the IPv6 mcast logic (in __udp_v6_is_mcast_sock()).

The particular case I noticed was DHCP discover packets going
to the 255.255.255.255 address, which are handled by
__udp4_lib_mcast_deliver(). The previous code meant that running
multiple different DHCP server or relay agent instances across VRFs
did not work correctly - any server/relay agent in the default VRF
received DHCP discover packets for all other VRFs.

Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
---
 net/ipv4/udp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8fb250e..efe9283 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -538,8 +538,7 @@ static inline bool __udp_is_mcast_sock(struct net *net, struct sock *sk,
 	    (inet->inet_dport != rmt_port && inet->inet_dport) ||
 	    (inet->inet_rcv_saddr && inet->inet_rcv_saddr != loc_addr) ||
 	    ipv6_only_sock(sk) ||
-	    (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-	     sk->sk_bound_dev_if != sdif))
+	    !udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 		return false;
 	if (!ip_mc_sf_allow(sk, loc_addr, rmt_addr, dif, sdif))
 		return false;
-- 
2.7.4

