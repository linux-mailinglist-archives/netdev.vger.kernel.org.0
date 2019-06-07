Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0F638E7F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbfFGPJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbfFGPJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:09:47 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0A9B216C4;
        Fri,  7 Jun 2019 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559920187;
        bh=5NSGpExZNt0wzn7Pwx4r39olG24/HqatDMclYX1Xud8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKDhDGx2CPkwapR5oNM2p/z2nErXt9SjrGK1dX9pOl9jezLOQtO7UjKld/dTPirxS
         vuiHCTsYVM6dEXUtnoQZRKv70gsFQ7PUylSFceaWLzbx7/CG+J6//K3j6E+NbR9+Yu
         hMDvL6z4rskOWt4V2Wxg6o0c/zRlUv8oHy5cROwE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 16/20] selftests: pmtu: Move route installs to a new function
Date:   Fri,  7 Jun 2019 08:09:37 -0700
Message-Id: <20190607150941.11371-17-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607150941.11371-1-dsahern@kernel.org>
References: <20190607150941.11371-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move the route add commands to a new function called setup_routing_old.
The '_old' refers to the classic way of installing routes.

Signed-off-by: David Ahern <dsahern@gmail.com>
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

