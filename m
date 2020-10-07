Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958D9285530
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 02:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgJGAKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 20:10:43 -0400
Received: from correo.us.es ([193.147.175.20]:46972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgJGAKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 20:10:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30F061F0CED
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24887DA722
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A5F5DA78D; Wed,  7 Oct 2020 02:10:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED294DA73D;
        Wed,  7 Oct 2020 02:10:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Oct 2020 02:10:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C1C5242EF42B;
        Wed,  7 Oct 2020 02:10:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/4] selftests: netfilter: fix nft_meta.sh error reporting
Date:   Wed,  7 Oct 2020 02:10:25 +0200
Message-Id: <20201007001027.2530-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201007001027.2530-1-pablo@netfilter.org>
References: <20201007001027.2530-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

When some test directly done with check_one_counter() fails,
counter variable is undefined. This patch calls ip with cname
which avoids errors like:
FAIL: oskuidcounter, want "packets 2", got
Error: syntax error, unexpected newline, expecting string
list counter inet filter
                        ^
Error is now correctly rendered:
FAIL: oskuidcounter, want "packets 2", got
table inet filter {
	counter oskuidcounter {
		packets 1 bytes 84
	}
}

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 17b2d6eaa204..1f5b46542c14 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -90,7 +90,7 @@ check_one_counter()
 	if [ $? -ne 0 ];then
 		echo "FAIL: $cname, want \"$want\", got"
 		ret=1
-		ip netns exec "$ns0" nft list counter inet filter $counter
+		ip netns exec "$ns0" nft list counter inet filter $cname
 	fi
 }
 
-- 
2.20.1

