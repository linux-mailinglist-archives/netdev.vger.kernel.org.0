Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2795B39703
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 22:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfFGUqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 16:46:13 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36404 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbfFGUqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 16:46:13 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so2125343qkl.3;
        Fri, 07 Jun 2019 13:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fRehPsNPEN/ECzbU8b7fuUn9KqNcRuRp0hIKZaFy6Ug=;
        b=Y4c5SCaQfbBPk52YPTi7o4M2R3JAWZWzK6p8WRbz6/xgBQSaH7fHxZG29xgOkQJc1t
         2NI3RNcgMTxZpyjWl1ILg0kQXBoPpUjaWA6QJoDMncoRU5mLR4HBbjkOq0udnqD5LUHw
         GbXJvxdKZ04dHBRALWGB5ArybMie+IEqfmO7JSFpd6X1TUMboVcqj4qPHVguXItpTYmN
         m4yeu02OexHattRSuOaA5GvB25TsZQyxTX16adMDm8ouiBWHPm9ZB2F6YRyFzXGem0eX
         NAfYwsvRUFP9+PnbEhisXAB9LRu5qSivB5mIQJUmkRJrCzG1AFH8+1Y/mhgAtfgICnYJ
         oBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fRehPsNPEN/ECzbU8b7fuUn9KqNcRuRp0hIKZaFy6Ug=;
        b=KngsJ4BBBIkK8zoRD114mcUan4W4U1OIX16ipUhfMuo/2ji/6gItM4EQSJdspTsXYe
         hDP7dzKlSYM2zJTuct94yi+PW/H+XlS99HWtxS8j7vjsg0smoRAWXrei5bSz+H7CFseR
         xO/2QTxB53hCHozH/kNH0pH419/SkHIxzqHpSk0UNUTeaVX8Yg/gwPMBmsakQEj6dTke
         xQmmyIEFESC+cD7+OwIfk+WjJO74ZAYJBPoghULLZmSXR/GsnlL6I65uc0uO0Zru5GQV
         Tuu9aCq1KWOqBadG8u6lFkmUomte79F5IoWAMGdpvCSYXdJJjc8pC5E/ewRyH5vU85vC
         BtYA==
X-Gm-Message-State: APjAAAVSyZtNbVjKXwqCt49MPD8fUvwDhU3wu5H6c3bmEgxuHUyBxO7i
        DGkmI1d+s3NvyYhJCWM/8wZja+nW
X-Google-Smtp-Source: APXvYqy6Qlb1MbiwtpuE9bC1TwrNvnsXqBqXwEVCqregplmHtCs75rJJPbqV7FPAiPbCGgAOB16vlg==
X-Received: by 2002:a37:c45:: with SMTP id 66mr27122899qkm.31.1559940372089;
        Fri, 07 Jun 2019 13:46:12 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id d23sm1437823qtq.6.2019.06.07.13.46.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 13:46:11 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org, mkl@pengutronix.de,
        wg@grandegger.com, patrick.ohly@intel.com,
        Willem de Bruijn <willemb@google.com>,
        syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com
Subject: [PATCH net] can: purge socket error queue on sock destruct
Date:   Fri,  7 Jun 2019 16:46:07 -0400
Message-Id: <20190607204607.250375-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

CAN supports software tx timestamps as of the below commit. Purge
any queued timestamp packets on socket destroy.

Fixes: 51f31cabe3ce ("ip: support for TX timestamps on UDP and RAW sockets")
Reported-by: syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/can/af_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index e8fd5dc1780ae..189a6bf8f829c 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -99,6 +99,7 @@ EXPORT_SYMBOL(can_ioctl);
 static void can_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static const struct can_proto *can_get_proto(int protocol)
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

