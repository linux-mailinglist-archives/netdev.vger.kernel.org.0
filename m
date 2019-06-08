Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5561D3A257
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfFHWW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2414421848;
        Sat,  8 Jun 2019 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030828;
        bh=s9gyIvxMbtGWiF7pT/vy1y+gLPYEPsebOhBcWwCLfzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cSpXxY37D4VMjO8Qa3INHLq8lQJ9WenHaWZgyt27Q7791zu1p9eYqD4eWrUFxEFcW
         ozq4dK2+uEp/dFDGbLwi4+QUOSE8+1l6BSzBzoKnOQeIpNhY3/HkUlUsJxRtuJayN8
         2ayR2xfVv9kP4s5u7HgSYLOD7m1hebr9Tmxp7+wQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 16/20] selftests: pmtu: Move route installs to a new function
Date:   Sat,  8 Jun 2019 14:53:37 -0700
Message-Id: <20190608215341.26592-17-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the route add commands to a new function called setup_routing_old.
The '_old' refers to the classic way of installing routes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
---
 tools/testing/selftests/net/pmtu.sh | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 3d6b21c4b1db..14ffcf490032 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -448,6 +448,20 @@ setup_xfrm6() {
 	setup_xfrm 6 ${veth6_a_addr} ${veth6_b_addr}
 }
 
+setup_routing_old() {
+	for i in ${routes}; do
+		[ "${ns}" = "" ]	&& ns="${i}"		&& continue
+		[ "${addr}" = "" ]	&& addr="${i}"		&& continue
+		[ "${gw}" = "" ]	&& gw="${i}"
+
+		ns_name="$(nsname ${ns})"
+
+		ip -n ${ns_name} route add ${addr} via ${gw}
+
+		ns=""; addr=""; gw=""
+	done
+}
+
 setup_routing() {
 	for i in ${NS_R1} ${NS_R2}; do
 		ip netns exec ${i} sysctl -q net/ipv4/ip_forward=1
@@ -478,17 +492,7 @@ setup_routing() {
 		ns=""; peer=""; segment=""
 	done
 
-	for i in ${routes}; do
-		[ "${ns}" = "" ]	&& ns="${i}"		&& continue
-		[ "${addr}" = "" ]	&& addr="${i}"		&& continue
-		[ "${gw}" = "" ]	&& gw="${i}"
-
-		ns_name="$(nsname ${ns})"
-
-		ip -n ${ns_name} route add ${addr} via ${gw}
-
-		ns=""; addr=""; gw=""
-	done
+	setup_routing_old
 }
 
 setup() {
-- 
2.11.0

