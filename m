Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7E92282CE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgGUOwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:52:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55431 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbgGUOwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:52:53 -0400
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1jxtdR-0002Sv-Ig; Tue, 21 Jul 2020 14:52:49 +0000
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: txtimestamp: tear down setup() 'tc' and 'ip' env on EXIT
Date:   Tue, 21 Jul 2020 16:52:49 +0200
Message-Id: <20200721145249.72153-1-paolo.pisati@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a cleanup() path upon exit, making it possible to run the test twice in a
row:

$ sudo bash -x ./txtimestamp.sh
+ set -e
++ ip netns identify
+ [[ '' == \r\o\o\t ]]
+ main
+ [[ 0 -eq 0 ]]
+ run_test_all
+ setup
+ tc qdisc add dev lo root netem delay 1ms
Error: Exclusivity flag on, cannot modify.

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 tools/testing/selftests/net/txtimestamp.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/net/txtimestamp.sh b/tools/testing/selftests/net/txtimestamp.sh
index eea6f5193693..77f29cabff87 100755
--- a/tools/testing/selftests/net/txtimestamp.sh
+++ b/tools/testing/selftests/net/txtimestamp.sh
@@ -23,6 +23,14 @@ setup() {
 		action mirred egress redirect dev ifb_netem0
 }
 
+cleanup() {
+	tc filter del dev lo parent ffff:
+	tc qdisc del dev lo handle ffff: ingress
+	tc qdisc del dev ifb_netem0 root
+	ip link del ifb_netem0
+	tc qdisc del dev lo root
+}
+
 run_test_v4v6() {
 	# SND will be delayed 1000us
 	# ACK will be delayed 6000us: 1 + 2 ms round-trip
@@ -75,6 +83,8 @@ main() {
 	fi
 }
 
+trap cleanup EXIT
+
 if [[ "$(ip netns identify)" == "root" ]]; then
 	./in_netns.sh $0 $@
 else
-- 
2.27.0

