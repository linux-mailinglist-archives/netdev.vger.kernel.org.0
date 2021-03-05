Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C5F32F5C9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCEWSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:18:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:38642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhCEWRc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 17:17:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F285F65077;
        Fri,  5 Mar 2021 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614982652;
        bh=QQA/VkUhA7KImA1MH4uivzt46BJXoB0NT1sTlls75rw=;
        h=From:To:Cc:Subject:Date:From;
        b=EwK1J9xTQRr1K4pG6T6jzVKZ99Q6jLIy3+teLRVcDKjVQQW5AmSWtXgnZQumfy0FZ
         uvTIX5114rLXmGEAhBYi0P2hF5Vxt3+XNPe+UVkFANCEPSXlwH2J96C2UY2uUR+fv7
         In5kBbCmU1ABC5oyvmdmfxjm5SOklh7HFSsOUOTjMF0AQErqcOwMce1CGqCFwlgz9v
         6/yC8+OyWQLvjUq6gQ/Sz9K9CBIo3877jF1GmU81jYRnQ/nV7C9QtYlJt2a9j4TsQP
         5JZt5PaY3vX5nNM0a1jK+6BESzztGRnlJa6JHnu1Nr32k5CnISi/sLMAu4Y7redytX
         lpKYiEkk+dYQA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, zbynek.michl@gmail.com,
        chris.snook@gmail.com, bruceshenzk@gmail.com,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org
Subject: [PATCH net] ethernet: alx: fix order of calls on resume
Date:   Fri,  5 Mar 2021 14:17:29 -0800
Message-Id: <20210305221729.206096-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_device_attach() will unpause the queues so we can't call
it before __alx_open(). This went undetected until
commit b0999223f224 ("alx: add ability to allocate and free
alx_napi structures") but now if stack tries to xmit immediately
on resume before __alx_open() we'll crash on the NAPI being null:

 BUG: kernel NULL pointer dereference, address: 0000000000000198
 CPU: 0 PID: 12 Comm: ksoftirqd/0 Tainted: G           OE 5.10.0-3-amd64 #1 Debian 5.10.13-1
 Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./H77-D3H, BIOS F15 11/14/2013
 RIP: 0010:alx_start_xmit+0x34/0x650 [alx]
 Code: 41 56 41 55 41 54 55 53 48 83 ec 20 0f b7 57 7c 8b 8e b0
0b 00 00 39 ca 72 06 89 d0 31 d2 f7 f1 89 d2 48 8b 84 df
 RSP: 0018:ffffb09240083d28 EFLAGS: 00010297
 RAX: 0000000000000000 RBX: ffffa04d80ae7800 RCX: 0000000000000004
 RDX: 0000000000000000 RSI: ffffa04d80afa000 RDI: ffffa04e92e92a00
 RBP: 0000000000000042 R08: 0000000000000100 R09: ffffa04ea3146700
 R10: 0000000000000014 R11: 0000000000000000 R12: ffffa04e92e92100
 R13: 0000000000000001 R14: ffffa04e92e92a00 R15: ffffa04e92e92a00
 FS:  0000000000000000(0000) GS:ffffa0508f600000(0000) knlGS:0000000000000000
 i915 0000:00:02.0: vblank wait timed out on crtc 0
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000198 CR3: 000000004460a001 CR4: 00000000001706f0
 Call Trace:
  dev_hard_start_xmit+0xc7/0x1e0
  sch_direct_xmit+0x10f/0x310

Cc: <stable@vger.kernel.org> # 4.9+
Fixes: bc2bebe8de8e ("alx: remove WoL support")
Reported-by: Zbynek Michl <zbynek.michl@gmail.com>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983595
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/atheros/alx/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9b7f1af5f574..9e02f8864593 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1894,13 +1894,16 @@ static int alx_resume(struct device *dev)
 
 	if (!netif_running(alx->dev))
 		return 0;
-	netif_device_attach(alx->dev);
 
 	rtnl_lock();
 	err = __alx_open(alx, true);
 	rtnl_unlock();
+	if (err)
+		return err;
 
-	return err;
+	netif_device_attach(alx->dev);
+
+	return 0;
 }
 
 static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
-- 
2.26.2

