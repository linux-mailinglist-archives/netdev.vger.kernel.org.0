Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5260CA8B1D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733128AbfIDQBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733118AbfIDQBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7A422DBF;
        Wed,  4 Sep 2019 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612912;
        bh=gdfIsCQ3akrb6/fwj/1NzIgPbIVHf0Aisr6RhVLPZNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjAJHEdPIaAkumBUU6ktWqwizMRaNk3HbkBXnPCD7tEtKNAgRLVSdLh0nrxxunlyq
         E5+KVP4XGn+CHgOrqIcZlTtrebBMP+gZwEM4O1jF5q0MdDdTrSmTVP+N1QYa6FRK5C
         z5I83lPuL2GaNYGsO9rYHcZOIpf/0HvQQSzj4Ddk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/36] netfilter: nf_conntrack_ftp: Fix debug output
Date:   Wed,  4 Sep 2019 12:01:05 -0400
Message-Id: <20190904160122.4179-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

[ Upstream commit 3a069024d371125227de3ac8fa74223fcf473520 ]

The find_pattern() debug output was printing the 'skip' character.
This can be a NULL-byte and messes up further pr_debug() output.

Output without the fix:
kernel: nf_conntrack_ftp: Pattern matches!
kernel: nf_conntrack_ftp: Skipped up to `<7>nf_conntrack_ftp: find_pattern `PORT': dlen = 8
kernel: nf_conntrack_ftp: find_pattern `EPRT': dlen = 8

Output with the fix:
kernel: nf_conntrack_ftp: Pattern matches!
kernel: nf_conntrack_ftp: Skipped up to 0x0 delimiter!
kernel: nf_conntrack_ftp: Match succeeded!
kernel: nf_conntrack_ftp: conntrack_ftp: match `172,17,0,100,200,207' (20 bytes at 4150681645)
kernel: nf_conntrack_ftp: find_pattern `PORT': dlen = 8

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_ftp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index f0e9a7511e1ac..c236c7d1655d0 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -323,7 +323,7 @@ static int find_pattern(const char *data, size_t dlen,
 		i++;
 	}
 
-	pr_debug("Skipped up to `%c'!\n", skip);
+	pr_debug("Skipped up to 0x%hhx delimiter!\n", skip);
 
 	*numoff = i;
 	*numlen = getnum(data + i, dlen - i, cmd, term, numoff);
-- 
2.20.1

