Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59038213C38
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgGCPAw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jul 2020 11:00:52 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46122 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726148AbgGCPAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:00:52 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-tkKdiIvmMFeTrUQ4bjrFdg-1; Fri, 03 Jul 2020 11:00:47 -0400
X-MC-Unique: tkKdiIvmMFeTrUQ4bjrFdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFDBE186A201;
        Fri,  3 Jul 2020 15:00:46 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.195.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F16D52DE77;
        Fri,  3 Jul 2020 15:00:45 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Paul Wouters <pwouters@redhat.com>
Subject: [PATCH net] ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg
Date:   Fri,  3 Jul 2020 17:00:32 +0200
Message-Id: <e14ad6ba2a92a44a8b146e57e8fcdb10fb906226.1593767365.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 ping sockets don't set fl4.fl4_icmp_{type,code}, which leads to
incomplete IPsec ACQUIRE messages being sent to userspace. Currently,
both raw sockets and IPv6 ping sockets set those fields.

Expected output of "ip xfrm monitor":
    acquire proto esp
      sel src 10.0.2.15/32 dst 8.8.8.8/32 proto icmp type 8 code 0 dev ens4
      policy src 10.0.2.15/32 dst 8.8.8.8/32
        <snip>

Currently with ping sockets:
    acquire proto esp
      sel src 10.0.2.15/32 dst 8.8.8.8/32 proto icmp type 0 code 0 dev ens4
      policy src 10.0.2.15/32 dst 8.8.8.8/32
        <snip>

The Libreswan test suite found this problem after Fedora changed the
value for the sysctl net.ipv4.ping_group_range.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Reported-by: Paul Wouters <pwouters@redhat.com>
Tested-by: Paul Wouters <pwouters@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv4/ping.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 535427292194..df6fbefe44d4 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -786,6 +786,9 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			   inet_sk_flowi_flags(sk), faddr, saddr, 0, 0,
 			   sk->sk_uid);
 
+	fl4.fl4_icmp_type = user_icmph.type;
+	fl4.fl4_icmp_code = user_icmph.code;
+
 	security_sk_classify_flow(sk, flowi4_to_flowi(&fl4));
 	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt)) {
-- 
2.27.0

