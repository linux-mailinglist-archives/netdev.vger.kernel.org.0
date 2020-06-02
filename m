Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20E11EC1F7
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgFBSiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:38:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48453 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgFBSiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:38:52 -0400
Received: from 201-95-154-249.dsl.telesp.net.br ([201.95.154.249] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1jgBoG-0003MM-Lj; Tue, 02 Jun 2020 18:38:49 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH] selftests: net: ip_defrag: ignore EPERM
Date:   Tue,  2 Jun 2020 15:38:37 -0300
Message-Id: <20200602183837.1540345-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When running with conntrack rules, the dropped overlap fragments may cause
EPERM to be returned to sendto. Instead of completely failing, just ignore
those errors and continue. If this causes packets with overlap fragments to
be dropped as expected, that is okay. And if it causes packets that are
expected to be received to be dropped, which should not happen, it will be
detected as failure.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 tools/testing/selftests/net/ip_defrag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/ip_defrag.c b/tools/testing/selftests/net/ip_defrag.c
index b53fb67f8e5e..62ee927bacae 100644
--- a/tools/testing/selftests/net/ip_defrag.c
+++ b/tools/testing/selftests/net/ip_defrag.c
@@ -192,9 +192,9 @@ static void send_fragment(int fd_raw, struct sockaddr *addr, socklen_t alen,
 	}
 
 	res = sendto(fd_raw, ip_frame, frag_len, 0, addr, alen);
-	if (res < 0)
+	if (res < 0 && errno != EPERM)
 		error(1, errno, "send_fragment");
-	if (res != frag_len)
+	if (res >= 0 && res != frag_len)
 		error(1, 0, "send_fragment: %d vs %d", res, frag_len);
 
 	frag_counter++;
@@ -313,9 +313,9 @@ static void send_udp_frags(int fd_raw, struct sockaddr *addr,
 			iphdr->ip_len = htons(frag_len);
 		}
 		res = sendto(fd_raw, ip_frame, frag_len, 0, addr, alen);
-		if (res < 0)
+		if (res < 0 && errno != EPERM)
 			error(1, errno, "sendto overlap: %d", frag_len);
-		if (res != frag_len)
+		if (res >= 0 && res != frag_len)
 			error(1, 0, "sendto overlap: %d vs %d", (int)res, frag_len);
 		frag_counter++;
 	}
-- 
2.25.1

