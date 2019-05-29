Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5219B2D8C3
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfE2JPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:15:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36650 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfE2JPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:15:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id d21so809145plr.3;
        Wed, 29 May 2019 02:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7qRIoAoMwFa3C+MKmnp6p+PijydujIip3aFQ2je5+pM=;
        b=LbPa/DcNDQZyrTlTZcHIXNLoDhP2oB1brO6jWEBdbT5/2ywWe/M8uqqFCyGf6fXKmD
         3XpPD6bMskfXKkH0b27SrbW1e1WwJf2hgipU2Vv31Xthu0DJv02c2OgWcXv5B+TOFzk6
         EpChEb5rq087KFHnTMZTGY9qOX0JbhAC/AwsIgdZDYp1HEh4YQwRX05/RKFUbh6htNYd
         87R9irwxnymKcAdqJHdY8NkdqSGOlU32RomQbjMd5IJFbxBt4cJbNIuGCiCJllO6Ry2N
         9IETQRWs25YYkj1oxKge4cTi7Lm0h7wr+o4sQzBHzhQNWSnS/CF5QDFGkPl0QPhKQXVd
         CPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7qRIoAoMwFa3C+MKmnp6p+PijydujIip3aFQ2je5+pM=;
        b=L8KZWfzCe0ofZ4AlfTITAE/ROs+0lkpR6rUluBkkk9MkHF/LexpcwgXIZMW7litgzQ
         +NqwjD31PRrtIWMaS4yHCHif3QDESYe8V/nBE+I3dhs9koPX/hyUCnADaEEa3XRGZ36c
         TuYLI2HhG7ARoD0jNKcs+bpa+lWdV8f8ChFQOrT8jb1A8cQvCbpwucFClA0mVU9aqRWd
         1CZkmEZ4RD0W3DOQYp9XgR1qeCfy1FIT5eMuNKFT6g2QlJQtrcPoWdNnxYe+3EaAR103
         wNtOAQAaM4vKPY4qbtTcHiyv0Xw/YFIIKGevO1cdkFlqU8nNkSh8TN4oKlrDKrz4TPJb
         dr6Q==
X-Gm-Message-State: APjAAAWLjr72Qj+eg8XZPcahMSM92GWfe81mo1voa4U9JxG5KNZtnF8u
        JA/Ao970DIuLm8h6HF1RLlE=
X-Google-Smtp-Source: APXvYqymDJsmB7mrZHnSffvjL/AgMhhrCQY1tAUJ04EAhpx0MaWk+njjoQ/E63h9EnWyqTnyhnXwlw==
X-Received: by 2002:a17:902:bd94:: with SMTP id q20mr117409634pls.146.1559121315292;
        Wed, 29 May 2019 02:15:15 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id y12sm11587635pgp.63.2019.05.29.02.15.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 29 May 2019 02:15:14 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     isdn@linux-pingi.de, keescook@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] isdn: hisax: hfc_2bds0: Fix a possible concurrency use-after-free bug in HFCD_l1hw()
Date:   Wed, 29 May 2019 17:16:23 +0800
Message-Id: <1559121383-28691-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In drivers/isdn/hisax/hfc_2bds0.c, the function hfc2bds0_interrupt() and
HFCD_l1hw() may be concurrently executed.

HFCD_l1hw()
    line 969: if (!cs->tx_skb)

hfc2bds0_interrupt()
    line 875: dev_kfree_skb_irq(cs->tx_skb);

Thus, a possible concurrency use-after-free bug may occur in HFCD_l1hw().

To fix these bugs, the calls to spin_lock_irqsave() and
spin_unlock_irqrestore() are added in HFCD_l1hw(), to protect the
access to cs->tx_skb.

See commit 7418e6520f22 ("isdn: hisax: hfc_pci: Fix a possible concurrency
use-after-free bug in HFCPCI_l1hw()") for details.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 drivers/isdn/hisax/hfc_2bds0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/isdn/hisax/hfc_2bds0.c b/drivers/isdn/hisax/hfc_2bds0.c
index 3715fa0..ade12c0 100644
--- a/drivers/isdn/hisax/hfc_2bds0.c
+++ b/drivers/isdn/hisax/hfc_2bds0.c
@@ -966,11 +966,13 @@ HFCD_l1hw(struct PStack *st, int pr, void *arg)
 		if (cs->debug & L1_DEB_LAPD)
 			debugl1(cs, "-> PH_REQUEST_PULL");
 #endif
+		spin_lock_irqsave(&cs->lock, flags);
 		if (!cs->tx_skb) {
 			test_and_clear_bit(FLG_L1_PULL_REQ, &st->l1.Flags);
 			st->l1.l1l2(st, PH_PULL | CONFIRM, NULL);
 		} else
 			test_and_set_bit(FLG_L1_PULL_REQ, &st->l1.Flags);
+		spin_unlock_irqrestore(&cs->lock, flags);
 		break;
 	case (HW_RESET | REQUEST):
 		spin_lock_irqsave(&cs->lock, flags);
-- 
2.7.4

