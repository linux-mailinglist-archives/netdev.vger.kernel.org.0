Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAFDBE8B4
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 01:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbfIYXEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 19:04:25 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44554 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfIYXEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 19:04:25 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so1256661iog.11;
        Wed, 25 Sep 2019 16:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HPeGGcQkwDZoIbx5ihbpL7zXBF5pHk94wt6ftwYDWM0=;
        b=rGI5rPEVpuUosM8L21N6Vw1ruIQDuRWtlpYz8o8Di4LEwQhHLwaBeMRY13l84KqOw7
         8of4c7Xs8Kpndx7zZZvU1SU1aXkzjYI0IS3sK5X7hpAVr+bv2VUNwDQW7+qYFotggjGO
         UjMMk55FloQxab5Ua8sOB6/t30Pnxgksbp90hLPlNX1D03ZAwQ0pDdQLNjBNNj7ujGvx
         /T/J/70lLY2nQG/cbrkfGbwuzFzGcMMkZV+BUTVT+xCdX//RYQTsv26WlV2+mvuIXvEr
         EV08UFYht8DIymg8cq/n3eZjBrAee+46H/6Yo663b/2iPye/gWRPvC3zaDa8l4NjcvUc
         GdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HPeGGcQkwDZoIbx5ihbpL7zXBF5pHk94wt6ftwYDWM0=;
        b=Nrfj7Q5TWqN+JXRRet2NQknYTVvV8dLvORXuyVBZyidLOpjDxP3sz8ta7MmRza5S7t
         nvlK8j6OuYGT0DustAYwS62+FOW9RL12ONILGpAlKkIHhJeIc0OQtTL4yzk5GCNUWOVb
         Q2rmObfvQatGImSN+QXA7Cq9YuwJ07MNaRqHEWTdgHJX+YbnsW3jJJLGHBa2ZT4+/TgG
         39fNsPJiskF7LG6xEqXBmc4mqS311jybkGNj0qmXKVbHf15d2CBVHt0GDO529MsKNFuo
         leMbhm9dbwZFhc6WD7LzsfgT8maaK+CSakgcjRyAeFkE3IwDuFqYjUB4ytWw5Q+MOb0v
         PQmg==
X-Gm-Message-State: APjAAAWybpbupDTSHzirUJJbBLTKYHHZLqvhOVl6GKZlCTQUXaIAehQi
        18NCH0M5WFzLj4nzxKanXB8=
X-Google-Smtp-Source: APXvYqyFN2qSCFDaAmyrOpJE2dX1zjYW9wVObb8wgz2k/1xxJSPjf9JL1Edo0wCVYEJk+/wfMwWB7A==
X-Received: by 2002:a05:6638:294:: with SMTP id c20mr811214jaq.77.1569452664394;
        Wed, 25 Sep 2019 16:04:24 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id t9sm63420iop.86.2019.09.25.16.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 16:04:23 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qrtr: fix memory leak in qrtr_tun_read_iter
Date:   Wed, 25 Sep 2019 18:04:13 -0500
Message-Id: <20190925230416.20126-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In qrtr_tun_read_iter we need an error handling path to appropriately
release skb in cases of error.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/qrtr/tun.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index e35869e81766..0f6e6d1d2901 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -54,19 +54,24 @@ static ssize_t qrtr_tun_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	int count;
 
 	while (!(skb = skb_dequeue(&tun->queue))) {
-		if (filp->f_flags & O_NONBLOCK)
-			return -EAGAIN;
+		if (filp->f_flags & O_NONBLOCK) {
+			count = -EAGAIN;
+			goto out;
+		}
 
 		/* Wait until we get data or the endpoint goes away */
 		if (wait_event_interruptible(tun->readq,
-					     !skb_queue_empty(&tun->queue)))
-			return -ERESTARTSYS;
+					     !skb_queue_empty(&tun->queue))) {
+			count = -ERESTARTSYS;
+			goto out;
+		}
 	}
 
 	count = min_t(size_t, iov_iter_count(to), skb->len);
 	if (copy_to_iter(skb->data, count, to) != count)
 		count = -EFAULT;
 
+out:
 	kfree_skb(skb);
 
 	return count;
-- 
2.17.1

