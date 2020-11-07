Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40332AA77C
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 19:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgKGS5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 13:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGS5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 13:57:14 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC2AC0613CF;
        Sat,  7 Nov 2020 10:57:14 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id z24so3628868pgk.3;
        Sat, 07 Nov 2020 10:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=afHTW824kBEGWvvhUfZ3PFiZzmUwUob7a4RTUq6L29M=;
        b=o7ScU2Xor+ZuZiG+hPCasydHyXeqbZkNHK3eIs5iVsazHLeSlwETo1FzIG4JhtDPfu
         8duzNH3Gvwd+jeqOSOUv8CjLncS0AQ0XShWCAEpqlNonfo9kDYvLrYqqYT+qSiDM7wX9
         YZiM3TBqJ7ssVrcBtc7ccbhDYYOvXythStyjRYjxqdWbvg6vpIp4ijSGwUhxUNdAQpU/
         1ssIxh08PjgKPlPKBa7GJT6mtRWkrWNjdXNtauOgBZaW1RukvGhCa9yVPyj51/PRG8Hl
         Azc0iBK+GRcFrXAN54ENbhsqUUVjp8fQosN0i4gUcaP8JKulxEd3AXwJ07QlarWJKXt8
         MBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afHTW824kBEGWvvhUfZ3PFiZzmUwUob7a4RTUq6L29M=;
        b=MBvh0kqxoTzpV+0MoLJDuIkZ2+gnUOpFhhL8tQfFuTh6T1FA02jZHt2dv2tgPdeFJk
         CrEeRhCq0NLw6QU+uPphh7gpuZIIKeakoS/QVTMZEENKVEfzMRU922lLG2TpBNLkdM9g
         6iRFE1CtBU6GkQGtGjcG4vgR0JYNbP0cOCFj3JBIylp9Wvj3y003SKanUmWOKFBUaPjy
         UVuUXuTwX6qMbr7BpdHtOSvVUlSlZNA8Hm0Yz8xEMK4x45TLl3q/GNGtSK6Dmdnkj0VT
         QjRpLugKoH+86GYb1iHLR+ppxuR24wA3hKUSVFapO83Ol7GgCxRn7ANuV8Yje4EDaUXv
         JuSg==
X-Gm-Message-State: AOAM530G86BZxgSIvqw7UbhcU54kc+A2c+iFIrz6zqSSxfcsVYfHSEjb
        EyjEIzMzpJIpj+sBL/FBBX4=
X-Google-Smtp-Source: ABdhPJw2amXadmyF/5X65byZ9X2cW/hVkSb20cYEJFED8+QmCEouNiXV3miVxY+8b3LExk2iYfmWMQ==
X-Received: by 2002:a65:6201:: with SMTP id d1mr6502774pgv.156.1604775432941;
        Sat, 07 Nov 2020 10:57:12 -0800 (PST)
Received: from localhost.localdomain ([45.118.167.194])
        by smtp.googlemail.com with ESMTPSA id q12sm6738025pfc.84.2020.11.07.10.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 10:57:12 -0800 (PST)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     saeed@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH v2] net: rose: Fix Null pointer dereference in rose_send_frame()
Date:   Sun,  8 Nov 2020 00:26:54 +0530
Message-Id: <20201107185654.4339-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201105155600.9711-1-anmol.karan123@gmail.com>
References: <20201105155600.9711-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rose_send_frame() dereferences `neigh->dev` when called from
rose_transmit_clear_request(), and the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
and it is initialized in rose_add_loopback_neigh() as NULL.
i.e when `rose_loopback_neigh` used in rose_loopback_timer()
its `->dev` was still NULL and rose_loopback_timer() was calling
rose_rx_call_request() without checking for NULL.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Fix it by adding NULL checking for `rose_loopback_neigh->dev`
in rose_loopback_timer().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
Changes in v3:
        - Corrected checkpatch warnings and errors (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
	- Added "Fixes:" tag (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
Changes in v2:
	- Added NULL check in rose_loopback_timer() (Suggested-by: Greg KH <gregkh@linuxfoundation.org>)

 net/rose/rose_loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 7b094275ea8b..2c51756ed7bf 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}

 		if (frametype == ROSE_CALL_REQUEST) {
-			if ((dev = rose_dev_get(dest)) != NULL) {
+			dev = rose_dev_get(dest);
+			if (rose_loopback_neigh->dev && dev) {
 				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
 					kfree_skb(skb);
 			} else {
-
2.29.2

