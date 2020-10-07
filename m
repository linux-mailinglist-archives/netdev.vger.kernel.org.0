Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A9D28553F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 02:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgJGALJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 20:11:09 -0400
Received: from correo.us.es ([193.147.175.20]:47006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgJGAKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 20:10:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3CEA91F0CF4
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:10:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3082CDA704
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:10:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 262C0DA73D; Wed,  7 Oct 2020 02:10:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A538DA704;
        Wed,  7 Oct 2020 02:10:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 07 Oct 2020 02:10:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D48A942EF42A;
        Wed,  7 Oct 2020 02:10:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/4] selftests: netfilter: remove unused cnt and simplify command testing
Date:   Wed,  7 Oct 2020 02:10:26 +0200
Message-Id: <20201007001027.2530-4-pablo@netfilter.org>
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

cnt was not used in nft_meta.sh
This patch also fixes 2 shellcheck SC2181 warnings:
"check exit code directly with e.g. 'if mycmd;', not indirectly with
$?."

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 1f5b46542c14..18a1abca3262 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -7,8 +7,7 @@ ksft_skip=4
 sfx=$(mktemp -u "XXXXXXXX")
 ns0="ns0-$sfx"
 
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! nft --version > /dev/null 2>&1; then
 	echo "SKIP: Could not run test without nft tool"
 	exit $ksft_skip
 fi
@@ -86,8 +85,7 @@ check_one_counter()
 	local want="packets $2"
 	local verbose="$3"
 
-	cnt=$(ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want")
-	if [ $? -ne 0 ];then
+	if ! ip netns exec "$ns0" nft list counter inet filter $cname | grep -q "$want"; then
 		echo "FAIL: $cname, want \"$want\", got"
 		ret=1
 		ip netns exec "$ns0" nft list counter inet filter $cname
-- 
2.20.1

