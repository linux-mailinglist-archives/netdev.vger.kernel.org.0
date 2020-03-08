Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 187C717D2EB
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 10:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgCHJpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 05:45:34 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38601 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCHJpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 05:45:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id g21so3450512pfb.5;
        Sun, 08 Mar 2020 01:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Aa3m98s9W+HyU21/D2jhm/INGzeeIBZDLFGCZvKBfcU=;
        b=pyG+FlBv7lYcHJarifLHdqmmA3EAcTTZ8kEiWPuX4e5UjydOV62NqD8p7Auzjn++IQ
         Zmw4HwiKpZXFLGN72DnNdD7+Z0aSZJjxtMpxrJf11JYVDMHawypylnLm7MqAxiS8XMyv
         w3SXuc8AlFyta+5nT6cGIBw+qn82l6JMdhlA6rJba5o0ZVSJ5EXPG/uc3m1HOnJ6qrCw
         +TF0InMXdexqNnyJo6OrFinG1QilocWba3vzEKLNdj/RVgDyulWne5RhFtm0Em2tVRMO
         06bdF21YoJuc+tI41/sgCcHR0nRss7cTZSY988HxC+68YDe/w0eIkK+89aR3zgk/rHxs
         odSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Aa3m98s9W+HyU21/D2jhm/INGzeeIBZDLFGCZvKBfcU=;
        b=CentyL2VlbyrOaoYdbW+HjYqz+3mvYIw0n0Pas+le+nFXrIbvBoCGg0r5VeyYYyOFj
         qinK6kK3Z04zOpKdF9Da8OBrT88dgH00Cv5/BXmPOOvIdouieThHorfgrfBAopXF5hWa
         3kAZSrJNr9l4K4oW2zRpWzgCXcX4eASRj7yUQULoSEpuKoKzbnftLWMlnzF0BA21dxMM
         UNM+jETJi/piNUD7NRuVYrUqiQhdnlMKGElH0huOW8nf1hXbxAjVtUEo8uyzrmYMAKcE
         nopStmrMydzkEVjrZgfw7Bosypx95+I8mHQKjSJghU9AAn5y2TyQsnvFyxJBh7tYUxeA
         rA7g==
X-Gm-Message-State: ANhLgQ0sj5I7ILEYLrm25kV2HmoW6HjpoV99yFzlTosBaoEYOsUL7rzi
        tK0/5gyFrntwU53FkNuRQMrJ7eVD
X-Google-Smtp-Source: ADFU+vuvewk+1/JlAdwXumnrwoaepCNypYxB34T4DKSXS6+fKtAtZqd6m42WcSY85xX+QiZk7AHESw==
X-Received: by 2002:a63:f74a:: with SMTP id f10mr11164849pgk.360.1583660733303;
        Sun, 08 Mar 2020 01:45:33 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id n22sm1343627pjq.36.2020.03.08.01.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 01:45:32 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hdanton@sina.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v2] bluetooth/rfcomm: fix ODEBUG bug in rfcomm_dev_ioctl
Date:   Sun,  8 Mar 2020 17:45:27 +0800
Message-Id: <1583660727-9227-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Needn't call 'rfcomm_dlc_put' here, because 'rfcomm_dlc_exists' didn't
increase dlc->refcnt.

Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Suggested-by: Hillf Danton <hdanton@sina.com>
---
 net/bluetooth/rfcomm/tty.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 0c7d31c..a585849 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -413,10 +413,8 @@ static int __rfcomm_create_dev(struct sock *sk, void __user *arg)
 		dlc = rfcomm_dlc_exists(&req.src, &req.dst, req.channel);
 		if (IS_ERR(dlc))
 			return PTR_ERR(dlc);
-		else if (dlc) {
-			rfcomm_dlc_put(dlc);
+		if (dlc)
 			return -EBUSY;
-		}
 		dlc = rfcomm_dlc_alloc(GFP_KERNEL);
 		if (!dlc)
 			return -ENOMEM;
-- 
1.8.3.1

