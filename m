Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45A218EA00
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 17:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCVQEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 12:04:55 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:38110 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCVQEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 12:04:55 -0400
Received: by mail-qv1-f66.google.com with SMTP id p60so5875591qva.5
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 09:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3S/mcHuqke0bXrgqAMvn4in8E/znQrsYqjYUb8zphDc=;
        b=pNpUrjq3eMIls+sR4PIv9Cj5COnVpIta+sBaf7iGLOYNP3D9KpV8BWa6y+eS4Gc6oM
         ZjMXyV9x33B5u7yED8b05OvjIQGnYZX9k4qrBFNPborxnP4hM6aeaYWard9ZUfdPS3uV
         x9EBrdxULGqIS3/fsyeCOgLrRBt6CZUTQRBuY2rkVpY5j54y/OnjnYiE5fEAGNWTkpB6
         TbIjSKLd2Tw2tqlsxaHiu0p64qwCzpk0cOkGViR5DIg+qKSVbIO0t0Ai1gi2zez7E/CP
         qPQwhTguoYCyTeHp+2SEUFexYyNdMd+KJfVnNReb3bbVRWsyFiy6thiWv1da2B/GTBuC
         DrFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3S/mcHuqke0bXrgqAMvn4in8E/znQrsYqjYUb8zphDc=;
        b=p6YbYSEaOfFweGmIFil+yygGp6cbp88Auq1udFhuJkhe2hdYWwnGC0thBTrUDcjUBt
         Q0drFygwwrzIk1xnY0kMdCc9BNEOn7C/KqE60nXw47FyWz+Wu4MoUKYmPl/Q1/9E/dpK
         gLxpUulbyzf45yNzsyegXEgKECIG0+coigT+daZcHvA6uhsf4P6NxH/cmS7hCBYMSs6y
         a5fxXuI75sYvoxx9Az1YWRSLRvY/ejrpzSQqUd6Xj7/yY74KyjzKlvR5EdnTO6+uxpT+
         31Lf5zWp6YZDU6Byz6JTvmXO3aipjl5X7/C7O+423fgH7hb9zBdkber3fyRGEoZ15gM5
         C+EA==
X-Gm-Message-State: ANhLgQ3JhceMhDT/e7hbWWsX5LC2LwaUZrbaWjoGsgLVqAIGhhlNtLBg
        PleIQPy2+tmWr9LW4jh8mbBpko0M
X-Google-Smtp-Source: ADFU+vvl4BxXB+cuLxZb0EGYTvmIt7lKwNyx2FNFza2z0+BlgKK0Fxy9IlrFgtL1QwGODcZYu2+ZDw==
X-Received: by 2002:a05:6214:1449:: with SMTP id b9mr17349605qvy.217.1584893093478;
        Sun, 22 Mar 2020 09:04:53 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id l188sm8928042qkc.106.2020.03.22.09.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 09:04:52 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, sd@queasysnail.net,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] macsec: restrict to ethernet devices
Date:   Sun, 22 Mar 2020 12:04:49 -0400
Message-Id: <20200322160449.79185-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Only attach macsec to ethernet devices.

Syzbot was able able trigger a KMSAN warning in macsec_handle_frame
by attaching to a phonet device.

Macvlan has a similar check in macvlan_port_create.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/macsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 6ec6fc191a6e..92bc2b2df660 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -19,6 +19,7 @@
 #include <net/gro_cells.h>
 #include <net/macsec.h>
 #include <linux/phy.h>
+#include <linux/if_arp.h>
 
 #include <uapi/linux/if_macsec.h>
 
@@ -3665,6 +3666,8 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	real_dev = __dev_get_by_index(net, nla_get_u32(tb[IFLA_LINK]));
 	if (!real_dev)
 		return -ENODEV;
+	if (real_dev->type != ARPHRD_ETHER)
+		return -EINVAL;
 
 	dev->priv_flags |= IFF_MACSEC;
 
-- 
2.25.1.696.g5e7596f4ac-goog

