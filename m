Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DF3F2453
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732955AbfKGBeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:34:14 -0500
Received: from mail-m972.mail.163.com ([123.126.97.2]:48498 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbfKGBeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:34:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=igu7ryEbU708awC1Bd
        3bWmgFCHnT2YPwmA8o7T7/XHc=; b=TWDxZ2vsOevUE01PkN9V313//G6+++5dcw
        vLsKDQNMZGpYsxwdZRVNq5GFy1flyyude4eMquHtB0cgsSbAs6rGyQoW6C90umbR
        U4zrGAXj303972qoav6QHdQTY66jemwoMCg52LtKQdTflGfhicVQiBP5OmTWVtnk
        Tl3vxTkg8=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp2 (Coremail) with SMTP id GtxpCgC3hBJldMNdYlzDBA--.183S3;
        Thu, 07 Nov 2019 09:33:52 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] NFC: st21nfca: fix double free
Date:   Thu,  7 Nov 2019 09:33:20 +0800
Message-Id: <1573090400-23570-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: GtxpCgC3hBJldMNdYlzDBA--.183S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1DZw1fuF15Jw4DtFy5Jwb_yoWfXFc_K3
        W8Xw1xXrs0g34UKa13uFsxZ3yIgFy5Z3WFgrs2qa4SyryxZwnxZFs0vrs7Wr17WrsFvF9r
        uan5Zr1Fvr4qqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUU9jjJUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZwBmcletw91YHQAAsS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable nfcid_skb is not changed in the callee nfc_hci_get_param()
if error occurs. Consequently, the freed variable nfcid_skb will be
freed again, resulting in a double free bug. Set nfcid_skb to NULL after
releasing it to fix the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/nfc/st21nfca/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index f9ac176cf257..2ce17932a073 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -708,6 +708,7 @@ static int st21nfca_hci_complete_target_discovered(struct nfc_hci_dev *hdev,
 							NFC_PROTO_FELICA_MASK;
 		} else {
 			kfree_skb(nfcid_skb);
+			nfcid_skb = NULL;
 			/* P2P in type A */
 			r = nfc_hci_get_param(hdev, ST21NFCA_RF_READER_F_GATE,
 					ST21NFCA_RF_READER_F_NFCID1,
-- 
2.7.4

