Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B06D3FB577
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbhH3MDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236859AbhH3MBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F224961155;
        Mon, 30 Aug 2021 12:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324829;
        bh=BrGMmr91FkLRClV3hf95jzIDUzwfBJimPIlI3gCuCNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=es28ycaobyTbWWNM1wVonz8Nox6RVL1RsHXuDiou2PSKh36X4cB65LItT2NHbPaCv
         dBkVG3ToUawONNMXPRvwbGFvDdTZDKDW4eBNuBDDs1yht6NbmQGACyub/tmCvinNiD
         TjYCbxeeLjPtcrlL/bUURgdXsf/jbhbZskxhpicPyfB3JNr8FRLfb2j4iykkt8Ovjo
         2pXjajaE94EyDbGDxCpsR93LE2laIMxp2/HF01Si/J6P17VVvF3rrYSpjJBueBvG5j
         p5I+COGrrh8bFOsUZzgxBSz5y4dHyndj6lbfhjDsvr+J9aIwx3XIP6OiTFdUmUmFSb
         mz9s+MkJvaAXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/10] net: fix NULL pointer reference in cipso_v4_doi_free
Date:   Mon, 30 Aug 2021 08:00:16 -0400
Message-Id: <20210830120018.1017841-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120018.1017841-1-sashal@kernel.org>
References: <20210830120018.1017841-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]

In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
failed, we sometime observe panic:

  BUG: kernel NULL pointer dereference, address:
  ...
  RIP: 0010:cipso_v4_doi_free+0x3a/0x80
  ...
  Call Trace:
   netlbl_cipsov4_add_std+0xf4/0x8c0
   netlbl_cipsov4_add+0x13f/0x1b0
   genl_family_rcv_msg_doit.isra.15+0x132/0x170
   genl_rcv_msg+0x125/0x240

This is because in cipso_v4_doi_free() there is no check
on 'doi_def->map.std' when 'doi_def->type' equal 1, which
is possibe, since netlbl_cipsov4_add_std() haven't initialize
it before alloc 'doi_def->map.std'.

This patch just add the check to prevent panic happen for similar
cases.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index c1ac802d6894..18b80ee76b02 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -466,14 +466,16 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
 	if (!doi_def)
 		return;
 
-	switch (doi_def->type) {
-	case CIPSO_V4_MAP_TRANS:
-		kfree(doi_def->map.std->lvl.cipso);
-		kfree(doi_def->map.std->lvl.local);
-		kfree(doi_def->map.std->cat.cipso);
-		kfree(doi_def->map.std->cat.local);
-		kfree(doi_def->map.std);
-		break;
+	if (doi_def->map.std) {
+		switch (doi_def->type) {
+		case CIPSO_V4_MAP_TRANS:
+			kfree(doi_def->map.std->lvl.cipso);
+			kfree(doi_def->map.std->lvl.local);
+			kfree(doi_def->map.std->cat.cipso);
+			kfree(doi_def->map.std->cat.local);
+			kfree(doi_def->map.std);
+			break;
+		}
 	}
 	kfree(doi_def);
 }
-- 
2.30.2

