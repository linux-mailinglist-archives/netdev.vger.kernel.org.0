Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016BF3194D
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfFADg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfFADgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:25 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20767270D6;
        Sat,  1 Jun 2019 03:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360185;
        bh=5NSGpExZNt0wzn7Pwx4r39olG24/HqatDMclYX1Xud8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NX418fcV78AW0WLJHOZnQkCX2/rdTEEvj7svMrh3yIDI4z96v6/HMTxxlfH8X9eeD
         TVFXrtbkQXoN6TdF4JT9B1DTCvLGvD8qza2h8s7G1trGfpoNArqq9opSamXyNClSZP
         iztCMBVeosTuU4Y5sGUnMDM0iqBXpiqH//z8b7zE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 24/27] selftests: pmtu: Move route installs to a new function
Date:   Fri, 31 May 2019 20:36:15 -0700
Message-Id: <20190601033618.27702-25-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
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

