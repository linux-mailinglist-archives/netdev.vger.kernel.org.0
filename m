Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A74F18EB21
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCVRvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:51:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46536 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgCVRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:51:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id g7so3731487qtj.13
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 10:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I+iyeDKnRnFIBZjJP6Jvz1N6BJPZaNxiM/5nH4uDfpU=;
        b=lu56dXq29ou7yxT/kfuV22o01l+//J8FiFwXboEjNFu4epwUHbe4M05RUWrzczgcVt
         /5vcVloIcYfE941nyVIztSuI8BAMVEEG4VB7B+T/V1XdU/7/VmYSCnAuTcGqEvg/c2j9
         yIMjtWHmOqfOBvIJSon2bj2WkWbJF15ihl8ddLUjX1+v0/B1vSD93yWtHdliqGkr6j9Z
         gjGkVMDiK0qIzvfPCCcVve2pgyPsye7AnsIKTUCMYypcCXXuugYqS+rSSntsb+FQGX7h
         bOq7cHzs/yhE3QxAXvmWddkrHpkYHRe8WtnetDVfLUp5tCOjioDlhpfISNnj8ANoeMxf
         j8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I+iyeDKnRnFIBZjJP6Jvz1N6BJPZaNxiM/5nH4uDfpU=;
        b=Y5586ESKwuei38di1jlmmQqN012nYViPS+dGfPeqcwDWWXc9BYP7wjZZF8L1Mv1FAE
         gKSv1fY4hSeppwiHvn+GTX3UHLiM4uxjGxSniXYJejIseibrJj6IscVEdB1kHklt3oAE
         AcTkUXTWtVNmHZoeUClnPkt93Vdl6von+CLta1ZveGbzjdrZ0bQB5fdeUHc+ik84L8n2
         6IJsYlLmvFW0g8ggpLDmbL4iGbFD9H+dPUwwogyJoQC16BLXm0VCHSowpoTtXSaCSjlO
         3dIYqfC5t02Po5GgBX41mWmxUi7za3Pro9aTsniqq6fuWPnoNm5CKZpHFqev0/NuG/cT
         vS3w==
X-Gm-Message-State: ANhLgQ3zYM1yNF4AqsvGPrwsQpsLqJU2rLbWo/jSNQLvj+3nyU/r71tn
        /2aSJ9ZXY0k1FTaYhGP793mkD+1R
X-Google-Smtp-Source: ADFU+vvI5L96PIgkbyiUphFkXgIr8L84sFVCfGJu94RufnjJd9gNcXW0GP0mbivPbtGNpREBkIgFlQ==
X-Received: by 2002:ac8:59:: with SMTP id i25mr17933555qtg.110.1584899476279;
        Sun, 22 Mar 2020 10:51:16 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id p191sm9462988qke.6.2020.03.22.10.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 10:51:15 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net v2] macsec: restrict to ethernet devices
Date:   Sun, 22 Mar 2020 13:51:13 -0400
Message-Id: <20200322175113.91143-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Only attach macsec to ethernet devices.

Syzbot was able to trigger a KMSAN warning in macsec_handle_frame
by attaching to a phonet device.

Macvlan has a similar check in macvlan_port_create.

v1->v2
  - fix commit message typo

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

