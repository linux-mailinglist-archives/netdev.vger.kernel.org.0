Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A5B7102B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfGWDln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:41:43 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45041 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbfGWDln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:41:43 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so20002267plr.11
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 20:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f83zJaD9M577kuvJ3vToD6RGlHvSJBHpbv6acwBXPA8=;
        b=N57Dz0can4yBJbn1OIvYcBphg4truGZJKrCXztggQoJg7qi/bGf6xqhlUaIeaXRAZL
         r9WmhKL2YeYbTUv6SZ0HcEGW4hnfWJsaNwRvNRIkgYpb8cAwmJDdInuHVRMJjK4HaVwj
         zY5S3tJtfbKM7eSBKoitOKHwsHCE8q3/d9eWU/uP7GVWZUs6TqbQXTlSCrEuIwlyHXsx
         cLgExwG8tfqeqC7cSEYxKtK5finJGe76xT3OBnG7aa3ztAUksLx9U+AoDXEWjQDrpzl1
         UD0iMif1HWHA8wVkRyzu3Ckf0nfRFvbI5njL8cMjMAkPVdyTHeiptv5pxS8bxu4YsUlO
         tgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f83zJaD9M577kuvJ3vToD6RGlHvSJBHpbv6acwBXPA8=;
        b=UtDJ0aQQ1A5Uy3DaSGRx7zc3T5FzJ14GQcQETWrfbGmnGB3dRJa7+9osQbdEqYvSeP
         T5rZ6u2v9b4mSaHR8V+zn6WMsDkaN8oJqepJs9OvQQ3LCDfrYKjWV5KQQT2capS4ai9M
         r+9M2U3J2rmJX8XiPIrNklsUrFDgNhqVc6Hgc5DKeceBC9RHzevfGLIM+8AIwVfUtR6v
         2ZB/c9kFpZqyk7RfwfoSXRWVNkEzfW9A17dBQwjsBwy0YdTBfZSdy5x+wxXpE22P6dtd
         p9sPj7R26b/3/pdL/EypDVCYhn2NGrzb3mmgXG447UckLS8wMbmwTS/TvK7xDu9Cu8XS
         2QvA==
X-Gm-Message-State: APjAAAXUyx1U0jWjeHPv9iSWzunatA+EpBOGGhAua2uD9E9uLQGnMEBM
        wvo8ynKYxO7i/uOmwmwdeBE1K6WVfXA=
X-Google-Smtp-Source: APXvYqwNtG6swYsOJXCPAIhf4dqtCXVGGjg9tCw73ohUfkbRnz1v34qE6SF3tnZnsaFvfQpmbVAnKg==
X-Received: by 2002:a17:902:a417:: with SMTP id p23mr77312038plq.136.1563853302563;
        Mon, 22 Jul 2019 20:41:42 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id n98sm41857273pjc.26.2019.07.22.20.41.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 20:41:41 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com,
        syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com,
        syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com,
        syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [Patch net] netrom: hold sock when setting skb->destructor
Date:   Mon, 22 Jul 2019 20:41:22 -0700
Message-Id: <20190723034122.23166-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_efree() releases the sock refcnt, if we don't hold this refcnt
when setting skb->destructor to it, the refcnt would not be balanced.
This leads to several bug reports from syzbot.

I have checked other users of sock_efree(), all of them hold the
sock refcnt.

Fixes: c8c8218ec5af ("netrom: fix a memory leak in nr_rx_frame()")
Reported-and-tested-by: <syzbot+622bdabb128acc33427d@syzkaller.appspotmail.com>
Reported-and-tested-by: <syzbot+6eaef7158b19e3fec3a0@syzkaller.appspotmail.com>
Reported-and-tested-by: <syzbot+9399c158fcc09b21d0d2@syzkaller.appspotmail.com>
Reported-and-tested-by: <syzbot+a34e5f3d0300163f0c87@syzkaller.appspotmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netrom/af_netrom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 96740d389377..c4f54ad2b98a 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -967,6 +967,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 
 	window = skb->data[20];
 
+	sock_hold(make);
 	skb->sk             = make;
 	skb->destructor     = sock_efree;
 	make->sk_state	    = TCP_ESTABLISHED;
-- 
2.21.0

