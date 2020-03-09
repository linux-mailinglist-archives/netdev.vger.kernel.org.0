Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7681D17EC5C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgCIW5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:57:12 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:33814 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCIW5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:57:11 -0400
Received: by mail-pf1-f201.google.com with SMTP id s13so7810310pfe.1
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8FFym9DKDada0xXWYMI34JI5YA8SZzCPHrqtYuMIDqg=;
        b=EncZORYJGb/R6pjWY+vvmKaEJNqpi3Oym8Fz75H0gbyCU/HJLSUEQhM59ktii/rZ9E
         j5/Ml6LkfUpxBkGXTXVMqxZG7DkXacrWCcANxsJqSYria8x5XgVyuK7DihPW42PJ83ry
         kUvckRhAPl+k2EfPnuiu9YIM0kSHJ2/3JO21A0gmGPJrp0dOqWMQ566vbJ4B/xSEHdoF
         RUiN2pr0sVb+djGkHghXrAYGR/yvXF0o/ofk8EL4+Y8NvisW2Upkr3iiDXBzelaJhLEK
         Ck7MVFWn39x8/IqRJxwzPCW5LOTqabVI01iV9N5drZhFCKo7UCJPapfyfNUC8a3V9TIE
         14Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8FFym9DKDada0xXWYMI34JI5YA8SZzCPHrqtYuMIDqg=;
        b=VvRxd5Bw2kiFYhFNuZ0AEy0CBSmid3Rnn3fdB4Niy6SjwAfU8OqLXj197+rviIkKBO
         oeZqb2YHiS+mJpjeeIbHu2PUWg9UtO00tB9/TSWiyA5PcL2ziBCIYIsoPAf04rOVL29O
         Nu6QANsnwf4Jyzzsm6+T3Fyf96Dalv3ocNq3cpQEzhqL3Sde0kUsrOTaPuML3v8hMxgH
         2po/bD5JdpjZI6W+4klMRSm3RIgA96MP99emxoFuY6cde+9/Jv2kxesS6Zw1hvS/LHHt
         tT8jrDxN7DRJebFkmMTSWjAzYOY8WOl0omXHJFaQoyiQG1ZlV9vxP0G8VBL5i+YyacTd
         Gndw==
X-Gm-Message-State: ANhLgQ1AaiWESjip/Q/p8NLHmaD4st0lxuaycmz7Kmrs7cBu90ekV0MW
        XzJ4LPUlr+UtkqyInhLjAKGv6N9rw7Fx
X-Google-Smtp-Source: ADFU+vt6gGmBxqf+SzlhbaOwns/oLRNF5DgDCRuwGfT2Tz9HqcX814Qm7OrZKMkT8jbYMSUdYOOD1x5eePxo
X-Received: by 2002:a17:90a:a890:: with SMTP id h16mr1410920pjq.55.1583794630711;
 Mon, 09 Mar 2020 15:57:10 -0700 (PDT)
Date:   Mon,  9 Mar 2020 15:57:07 -0700
Message-Id: <20200309225707.65351-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] macvlan: add cond_resched() during multicast processing
From:   Mahesh Bandewar <maheshb@google.com>
To:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Rx bound multicast packets are deferred to a workqueue and
macvlan can also suffer from the same attack that was discovered
by Syzbot for IPvlan. This solution is not as effective as in
IPvlan. IPvlan defers all (Tx and Rx) multicast packet processing
to a workqueue while macvlan does this way only for the Rx. This
fix should address the Rx codition to certain extent.

Tx is still suseptible. Tx multicast processing happens when
.ndo_start_xmit is called, hence we cannot add cond_resched().
However, it's not that severe since the user which is generating
 / flooding will be affected the most.

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>

---
 drivers/net/macvlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 81aa7adf4801..e7289d67268f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -334,6 +334,8 @@ static void macvlan_process_broadcast(struct work_struct *w)
 		if (src)
 			dev_put(src->dev);
 		consume_skb(skb);
+
+		cond_resched();
 	}
 }
 
-- 
2.25.1.481.gfbce0eb801-goog

