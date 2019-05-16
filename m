Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD720E20
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfEPRlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:41:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbfEPRlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 13:41:35 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CA092082E;
        Thu, 16 May 2019 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558028493;
        bh=GwZK3tmCsmRrIaoFEPRYLDes6Nxzo0uiFS3qzuXxiQA=;
        h=From:To:Cc:Subject:Date:From;
        b=yGAYT8ixQrUAYMdMw9YsBrozX4nKF1qo95LNOI9UHHKiYFM5CUe06Qao7jSy1cCoK
         C5OPEusd+j5ggwJudmkd6jXhUPCF730rVRJOhtN0CKB3MUUQK7wEnkysWq/FD2LfQT
         LbtDqfggTVxDR16bE54uZPrEt3ng/AVHna9oblF4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, sbrivio@redhat.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] selftests: pmtu.sh: Remove quotes around commands in setup_xfrm
Date:   Thu, 16 May 2019 10:41:31 -0700
Message-Id: <20190516174131.19473-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The first command in setup_xfrm is failing resulting in the test getting
skipped:

+ ip netns exec ns-B ip -6 xfrm state add src fd00:1::a dst fd00:1::b spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
+ out=RTNETLINK answers: Function not implemented
...
  xfrm6 not supported
TEST: vti6: PMTU exceptions                                         [SKIP]
  xfrm4 not supported
TEST: vti4: PMTU exceptions                                         [SKIP]
...

The setup command started failing when the run_cmd option was added.
Removing the quotes fixes the problem:
...
TEST: vti6: PMTU exceptions                                         [ OK ]
TEST: vti4: PMTU exceptions                                         [ OK ]
...

Fixes: 56490b623aa0 ("selftests: Add debugging options to pmtu.sh")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/pmtu.sh | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 524b15dabb3c..b9171a7b3aaa 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -430,15 +430,15 @@ setup_xfrm() {
 	veth_a_addr="${2}"
 	veth_b_addr="${3}"
 
-	run_cmd "${ns_a} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel" || return 1
-	run_cmd "${ns_a} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel"
-	run_cmd "${ns_a} ip -${proto} xfrm policy add dir out mark 10 tmpl src ${veth_a_addr} dst ${veth_b_addr} proto esp mode tunnel"
-	run_cmd "${ns_a} ip -${proto} xfrm policy add dir in mark 10 tmpl src ${veth_b_addr} dst ${veth_a_addr} proto esp mode tunnel"
-
-	run_cmd "${ns_b} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel"
-	run_cmd "${ns_b} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel"
-	run_cmd "${ns_b} ip -${proto} xfrm policy add dir out mark 10 tmpl src ${veth_b_addr} dst ${veth_a_addr} proto esp mode tunnel"
-	run_cmd "${ns_b} ip -${proto} xfrm policy add dir in mark 10 tmpl src ${veth_a_addr} dst ${veth_b_addr} proto esp mode tunnel"
+	run_cmd ${ns_a} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel || return 1
+	run_cmd ${ns_a} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
+	run_cmd ${ns_a} ip -${proto} xfrm policy add dir out mark 10 tmpl src ${veth_a_addr} dst ${veth_b_addr} proto esp mode tunnel
+	run_cmd ${ns_a} ip -${proto} xfrm policy add dir in mark 10 tmpl src ${veth_b_addr} dst ${veth_a_addr} proto esp mode tunnel
+
+	run_cmd ${ns_b} ip -${proto} xfrm state add src ${veth_a_addr} dst ${veth_b_addr} spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
+	run_cmd ${ns_b} ip -${proto} xfrm state add src ${veth_b_addr} dst ${veth_a_addr} spi 0x1001 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
+	run_cmd ${ns_b} ip -${proto} xfrm policy add dir out mark 10 tmpl src ${veth_b_addr} dst ${veth_a_addr} proto esp mode tunnel
+	run_cmd ${ns_b} ip -${proto} xfrm policy add dir in mark 10 tmpl src ${veth_a_addr} dst ${veth_b_addr} proto esp mode tunnel
 }
 
 setup_xfrm4() {
-- 
2.11.0

