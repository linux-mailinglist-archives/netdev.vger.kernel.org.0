Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C64263C1B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 06:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgIJEer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 00:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgIJEen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 00:34:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1163CC061573;
        Wed,  9 Sep 2020 21:34:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l191so3561231pgd.5;
        Wed, 09 Sep 2020 21:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mLWBFcBZV8fmFx5Xk0PVn4QE4aV7gSoFbhf906XUkPs=;
        b=NjJMhcLe4iQ8X5gqAeC+mPeQdB0ZCqaUU7mPw3W/D1GX/8B2q+7jyxu01ySUanM1AP
         XWLRdQ4Ygmq6foo4o51n6qzzhlMY8jt0AuBbbm5ZGfPvBftrhAlI5jR1j9d9rUgO48Zv
         3nt3vC+NKv+yMvAwRrd9oBZghO/4msxbwX1MkPD/pMaLsWI1twbeLVt0jlqh6RQjNPqv
         Q26XqLtkZuJuP/6N1v3qcx9UkIfpsRWUbMIDIHhtC5yect8TFVWqO6rRLCXAUFzUDmdd
         37JxvHGTFtLPc5FV00qdssrm+rSevrHMgr9hB4//8nNwkTrWo33AxIHH3j5/lwv5J4Sz
         UsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mLWBFcBZV8fmFx5Xk0PVn4QE4aV7gSoFbhf906XUkPs=;
        b=oMFTiQp4ZJ4UG4i4oHwt2b/M7CDzl5f7IXHidHqe8nUVnn7vq7uMN2D5P6g0wYElNA
         a4iejcthTRzmbMw2GWDXOrNZWdWHEj/aIxUnDE3TpoJFQ+8rynz9+ua+F49yhvrF3cAB
         v1xw87dRImSUfEAknyaX/qHL0ohSF41ft5kfyzev+xdBqfGc1Y4+4icvKWb+K/49G+ja
         iUNG41LgUPoU7gagBC7qn43ga//Iabnn7dT0T3RziCcnuEo26xLJ/4Jw27BilfozuHKR
         tUWyCSi9R0ScF1Q4PuBkHdG/AyG0cIiI30xOdkXTqfLhbO2qIJNJRL5x5z09eLIk6TJD
         zxvQ==
X-Gm-Message-State: AOAM532WYkwv18xdJPVRoNMKGy3q6dMTEt+L87Xp+91h7cw3q5R8KNmi
        frKPFhg/Nj1lmuELCYuU6O0=
X-Google-Smtp-Source: ABdhPJzFKv4KxelRN1MBEhwmEPGdlzS/d7UG1Dn2QL3AG6VpQwxMK6fYsIxpdOIV7ceTnSwts2E6Vw==
X-Received: by 2002:a63:471b:: with SMTP id u27mr3050649pga.139.1599712481765;
        Wed, 09 Sep 2020 21:34:41 -0700 (PDT)
Received: from localhost.localdomain ([45.118.165.148])
        by smtp.googlemail.com with ESMTPSA id s19sm4384211pfc.69.2020.09.09.21.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 21:34:40 -0700 (PDT)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anmol.karan123@gmail.com,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer dereference in hci_event_packet()
Date:   Thu, 10 Sep 2020 10:04:24 +0530
Message-Id: <20200910043424.19894-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
as NULL. Fix it by adding pointer check for it.

Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
 net/bluetooth/hci_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..871e16804433 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
 		return;
 	}
 
+	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {
+		hci_dev_unlock(hdev);
+		return;
+	}
+
 	if (ev->status) {
 		hci_conn_del(hcon);
 		hci_dev_unlock(hdev);
-- 
2.28.0
