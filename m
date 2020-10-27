Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D246299DE2
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411544AbgJ0AKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439245AbgJ0AK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E28821741;
        Tue, 27 Oct 2020 00:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757428;
        bh=EyO/SshQRHbmPmx0YqXRwILlS+U77AA2cW9uBk571XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wpn96LWb4EmaTJrVPdq0lU/RwXd29aKgUUoge533uIW9whF2PWQC2i2N/5GtNnsfQ
         J8AOGGRmvQnUzQuawYqWe+RjnGIGvO98AbbZJ5LoxNaYujoLROiUeZj9gU19Yi5go0
         CDQ0LmZ38ybSMQKx6MC/ghkqihHGH7bDDd5RUcLY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 35/46] net: 9p: initialize sun_server.sun_path to have addr's value only when addr is valid
Date:   Mon, 26 Oct 2020 20:09:34 -0400
Message-Id: <20201027000946.1026923-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
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
index 9f020559c1928..1b56b22c5c5d7 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1029,7 +1029,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
 
 	csocket = NULL;
 
-	if (addr == NULL)
+	if (!addr || !strlen(addr))
 		return -EINVAL;
 
 	if (strlen(addr) >= UNIX_PATH_MAX) {
-- 
2.25.1

