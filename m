Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308956E49D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfGSLAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40163 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfGSLAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so28628362wmj.5
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4lgqQje4EBzZCisTQ5kwgkJTWm0D9L/zyJz0Qy9kZQ=;
        b=BJDNLniEqtD/81RLP8XjtX2UumpyxctBJSDH74R7c4BrbeoBZCz5B17W4vUOzTN2yp
         0yXu3JbsWuGqrT+iK8KhxywgI0ba6jEq5AIVqsfadSfb/CZFfyT6OqDWwPMiJTHmBSzS
         Ora/Cg/oDD0dSfkTmfk4q1tQhX6OU81Ge/Mq3/MHvsid60/HqJNhyGC6X74w+Q4eZQX7
         tSHJbOtLtJ4ukXM9KqT4w242bxMjHxMHHS3aEr145BsmdVdsuslvhvghHwfRrYfnbXGY
         2YyqWMroFdWtDJvhLcYaMCOFFfO/U2P5B6/yFVb3eqN/qzLWS8lXghOeSP6f0gpNZFhk
         InrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4lgqQje4EBzZCisTQ5kwgkJTWm0D9L/zyJz0Qy9kZQ=;
        b=bSLFxw52OyYHzqHGIucwYZn4/v3hg21C6v0Il98EwpAgbqG/vihZzFLCbjq21tDw/d
         cWkoG/7GBa/w4vLRwQbYxEXTX/4A33gyrXCqCpt0Zh67S9HnhleNvs/XD+07S4+5TUNS
         joQ6oZgqRpPGvgQAMmV32Ix5PTcF9L2ZkV26a6YrcfqFGcOzR8I3vDBiWTMePjWpkU+Q
         NKoV6U1VDrm4zQZxdhOo2i/Y8ccVRstIvYtzRHk4W8bVuGXZ0sET5jnveslOvL3NUk9p
         N3Zg1c9ohAMQxqG8ZsAisaWtfdlXCtStftICV27dHiyh6dHDBMrsxGPAm3XGum6OLRiL
         kxpw==
X-Gm-Message-State: APjAAAWj6oyTnRpaxP6SX7HhYaTwt3HZNYEwuZiWR9n6MZXKAHC/qF4m
        DRyvRt+OZvNjwfdNoya9Yr3E6SLw
X-Google-Smtp-Source: APXvYqyym6A2ehJ1P5xSXalghJBKqyBZzabxDJq8HLM+4Ym1/4FaaM/1J+ou3HK+/L+6PCeNtYJopA==
X-Received: by 2002:a1c:4b0b:: with SMTP id y11mr19670753wma.25.1563534031726;
        Fri, 19 Jul 2019 04:00:31 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id d16sm23790914wrv.55.2019.07.19.04.00.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 1/7] net: procfs: use index hashlist instead of name hashlist
Date:   Fri, 19 Jul 2019 13:00:23 +0200
Message-Id: <20190719110029.29466-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Name hashlist is going to be used for more than just dev->name, so use
rather index hashlist for iteration over net_device instances.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/net-procfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 36347933ec3a..6bbd06f7dc7d 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -20,8 +20,8 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	struct hlist_head *h;
 	unsigned int count = 0, offset = get_offset(*pos);
 
-	h = &net->dev_name_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, name_hlist) {
+	h = &net->dev_index_head[get_bucket(*pos)];
+	hlist_for_each_entry_rcu(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
-- 
2.21.0

