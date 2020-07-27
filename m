Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417AF22FD9E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgG0X2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgG0XYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8A8620A8B;
        Mon, 27 Jul 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892263;
        bh=LkmYfpO8CCHqVPPYGJEJrOUiJmWXY43q7bamRMNf8qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=131NI9iBTrFuzZ2t85U1G4NdNGkfTMw2FouQOJxaqpDu41xmlO0CPF1fdnhPl4wIZ
         AQQyPJtxrWra/s6R7NE7cgIP62Sezhn7BdwDYLhJk/eoM09/Acst4RVO7Ujc7du+lW
         +xJBsvqVFrhS1IHKCsj6P2orQIbd5mCmTU+6YPwk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Pisati <paolo.pisati@canonical.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/17] selftests: fib_nexthop_multiprefix: fix cleanup() netns deletion
Date:   Mon, 27 Jul 2020 19:24:05 -0400
Message-Id: <20200727232420.717684-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232420.717684-1-sashal@kernel.org>
References: <20200727232420.717684-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

[ Upstream commit 651149f60376758a4759f761767965040f9e4464 ]

During setup():
...
        for ns in h0 r1 h1 h2 h3
        do
                create_ns ${ns}
        done
...

while in cleanup():
...
        for n in h1 r1 h2 h3 h4
        do
                ip netns del ${n} 2>/dev/null
        done
...

and after removing the stderr redirection in cleanup():

$ sudo ./fib_nexthop_multiprefix.sh
...
TEST: IPv4: host 0 to host 3, mtu 1400                              [ OK ]
TEST: IPv6: host 0 to host 3, mtu 1400                              [ OK ]
Cannot remove namespace file "/run/netns/h4": No such file or directory
$ echo $?
1

and a non-zero return code, make kselftests fail (even if the test
itself is fine):

...
not ok 34 selftests: net: fib_nexthop_multiprefix.sh # exit=1
...

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
index 9dc35a16e4159..51df5e305855a 100755
--- a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
+++ b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
@@ -144,7 +144,7 @@ setup()
 
 cleanup()
 {
-	for n in h1 r1 h2 h3 h4
+	for n in h0 r1 h1 h2 h3
 	do
 		ip netns del ${n} 2>/dev/null
 	done
-- 
2.25.1

