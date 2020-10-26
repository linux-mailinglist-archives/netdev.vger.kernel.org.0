Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8915C299B71
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 00:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409420AbgJZXv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 19:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409404AbgJZXv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24C8520872;
        Mon, 26 Oct 2020 23:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756286;
        bh=s0rkcfRo2H2UVNq7sVdFjdowKR+FjljpilL/7POFG58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQKNFd1dRA7GUl2T0x4sWLtNfpSoO54RNuAq2IsOAr+xAOo2qkrvxRAMaJEisYJ1y
         JZgijyE6fm5FvNXOAzDOm+eDl8lWPkYZgT4Cfwry0a5s0n+qN1k6EvhQ9LqPhJcI7Z
         Vx/B8YC6zrQAq81NXBrQAh7j9uNlAveqetwmjnCU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 115/147] net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid
Date:   Mon, 26 Oct 2020 19:48:33 -0400
Message-Id: <20201026234905.1022767-115-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 7ca1db21ef8e0e6725b4d25deed1ca196f7efb28 ]

In p9_fd_create_unix, checking is performed to see if the addr (passed
as an argument) is NULL or not.
However, no check is performed to see if addr is a valid address, i.e.,
it doesn't entirely consist of only 0's.
The initialization of sun_server.sun_path to be equal to this faulty
addr value leads to an uninitialized variable, as detected by KMSAN.
Checking for this (faulty addr) and returning a negative error number
appropriately, resolves this issue.

Link: http://lkml.kernel.org/r/20201012042404.2508-1-anant.thazhemadam@gmail.com
Reported-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Tested-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index c0762a302162c..8f528e783a6c5 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1023,7 +1023,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
 
 	csocket = NULL;
 
-	if (addr == NULL)
+	if (!addr || !strlen(addr))
 		return -EINVAL;
 
 	if (strlen(addr) >= UNIX_PATH_MAX) {
-- 
2.25.1

