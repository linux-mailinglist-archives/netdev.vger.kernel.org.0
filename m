Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEA97874A
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfG2IXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:23:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46253 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfG2IXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:23:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so27185012plz.13;
        Mon, 29 Jul 2019 01:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=px4UPlf0dAssmmR/aVHt6FhvemexiyDz/1qhQq2NUko=;
        b=ONbOeXSmBYXhAmPzT9WtjuC9mlCj/p1+djw0YyAE2aYD4rh1JfRiBZ4PC1G86lbcTU
         lGY9O270uWbF+5G11ST2jnjdxYFNR1ndEhglFejjFTxEipn6CaYEhmyLGwwfgkP5HPup
         oazngm8PlyM3KuwTXYhf2hWfHezsIhgRqM7HgqVRm+t2aKsOCNgqnCNrw8KHPJPXOzhF
         LCx885R0hZmk55jpRmzQE69ENjT4o9p1HL3jkA59VB4PMKVl80Em59LpCuxdpMVZqb8K
         +CezBpo4j3cdStmCqHbf4aqiz4HqKygnXNntizZCqgamf6o0XUCsJ/WQH9hJ0KV4novq
         mRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=px4UPlf0dAssmmR/aVHt6FhvemexiyDz/1qhQq2NUko=;
        b=SrqzU7Ojx+ID+Qmwk5hDo/QkNpGkHN7F5oH22HV4JudKGGYi3EUMyjJs20xrdNNNUc
         QVbt6v/cDhis2Cg5ESkhiX3v0mzzh26CUSdgLx1/WlI43ojg0WkULpn3JmiiGLS0d4DL
         bmeq+6pBbVw0wl/Eza0l/OhnZbRc6T/HSwmmWjjsGMiG3or90jZ5kQ/XcOx++sOzIXuy
         Z8XHgYE+gMXfUMi9OfEOO6WfvyCRcaWD25wi7TE1ps+eRwaXh3/pVju5bMeGHqC89KMr
         vBxKyXog1mcLjrr2Wd/krDJlKMtVNNlNXLXpLngZ5Ys0qoafu+UYtZQTSX31/qoYSZsx
         ioKg==
X-Gm-Message-State: APjAAAW0sRNznw525r7TkdW4mZMicRFzvWSZf4kKxqdldAlrVCJo/zRe
        VAPk80LsSTpH4WvG+2+5sR8=
X-Google-Smtp-Source: APXvYqwKLTOEqmF07kbxWKw/jeRR659gFxXIBuV+9xCSArtaGiaB8k3HB0lu4Cq2asUQVU6/c6Ibvw==
X-Received: by 2002:a17:902:4501:: with SMTP id m1mr109309896pld.111.1564388618785;
        Mon, 29 Jul 2019 01:23:38 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id c70sm5905731pfb.36.2019.07.29.01.23.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 01:23:38 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] mac80211_hwsim: Fix possible null-pointer dereferences in hwsim_dump_radio_nl()
Date:   Mon, 29 Jul 2019 16:23:32 +0800
Message-Id: <20190729082332.28895-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hwsim_dump_radio_nl(), when genlmsg_put() on line 3617 fails, hdr is 
assigned to NULL. Then hdr is used on lines 3622 and 3623:
    genl_dump_check_consistent(cb, hdr);
    genlmsg_end(skb, hdr);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, hdr is used here when it is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 519b4ee88c5c..61a8b6429e09 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3617,10 +3617,11 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq, &hwsim_genl_family,
 				  NLM_F_MULTI, HWSIM_CMD_GET_RADIO);
-		if (!hdr)
+		if (hdr) {
+			genl_dump_check_consistent(cb, hdr);
+			genlmsg_end(skb, hdr);
+		} else
 			res = -EMSGSIZE;
-		genl_dump_check_consistent(cb, hdr);
-		genlmsg_end(skb, hdr);
 	}
 
 done:
-- 
2.17.0

