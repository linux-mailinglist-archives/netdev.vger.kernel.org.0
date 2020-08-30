Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984CB256E0C
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgH3NPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 09:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgH3NPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 09:15:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07528C061573;
        Sun, 30 Aug 2020 06:15:19 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i13so1709662pjv.0;
        Sun, 30 Aug 2020 06:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+j3TxzpjcwHJjeRI7zoLPA9SPkk21BdzC8mVJDrt+pE=;
        b=RO7NNB0jn1YTdQo4sFvc4RgowTC/uoxkT+efufWSBfiitS4HKZtox30Vjs2fgtDTgm
         096r8JFxjZWOpbovb0/iYJ1T7/K/60oUf+JFYXhjswFFqeBMMaTRoXE/ndqoDnxvQjEO
         LiHbx3GIBk4G9b/Ma79T1vY9tA9JfG/WtOLUhkr0qeJfFVlB9ULoeg/BBMwk6BajL5tp
         qoqHyLIyoipO1Q86lt0Z2M04AkwdPa+vSWKQESN86gy+l0yPe6iOBM9E2VMJQqhowtHu
         +NoifOfvf4gSdgjCdFaXVz+bojKqTEsU7hbaM0fMKc+eufCTK1XZC8XuESzsvsOjyIld
         AjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+j3TxzpjcwHJjeRI7zoLPA9SPkk21BdzC8mVJDrt+pE=;
        b=DD0j9YOsu95+tWN541HIxVrwlBhEJcgHDoI0n20HLZzUFECfEL9rVeMVgjqXs4zcUO
         o4EsNQF+T0mjrot/GKjPIg4KC20014LLfa38nKgAPv0yF+xFXeTW06cx2K6EgSIOeG9R
         RYqSnKB/ncC+LZtUbywjYMXOopPapHJqS87kUwAFzkgEHlZJgljqn5C2xZlneHKzvLlc
         tOwhZDLjTtnnSII/1x+kRjlszooIOFCtT/RCESmbJhUQYRqhcTaIn4TNBUzWqc7eEmqV
         utzXbBICRyo/gjxk8WyZFnQFtZWINcPPYa5M3iT2ldxB+PGPbAL5r4NQvqPVbnzkBOHP
         T3Sg==
X-Gm-Message-State: AOAM530RVRU5UzKOBRxoQYmYIiOzE9mq1tPujxv3IzPTnnQXZLVZ3MFM
        iOCwPlLnRg6HkO5tjesWLrQ=
X-Google-Smtp-Source: ABdhPJy/k0e7urcYXy6mU16T992sYPbCw5F+C1+Om20UbX7j1iO43ooRy9e4dKJxAqGd/5MIDghxEQ==
X-Received: by 2002:a17:902:e901:: with SMTP id k1mr5364502pld.189.1598793318383;
        Sun, 30 Aug 2020 06:15:18 -0700 (PDT)
Received: from localhost.localdomain (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id i1sm4505185pgq.41.2020.08.30.06.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 06:15:17 -0700 (PDT)
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH] veth: fix memory leak in veth_newlink()
Date:   Sun, 30 Aug 2020 06:13:36 -0700
Message-Id: <20200830131336.275844-1-rkovhaev@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when register_netdevice(dev) fails we should check whether struct
veth_rq has been allocated via ndo_init callback and free it, because,
depending on the code path, register_netdevice() might not call
priv_destructor() callback

Reported-and-tested-by: syzbot+59ef240dd8f0ed7598a8@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=59ef240dd8f0ed7598a8
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
---
 drivers/net/veth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a475f48d43c4..e40ca62a046a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1394,7 +1394,9 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	return 0;
 
 err_register_dev:
-	/* nothing to do */
+	priv = netdev_priv(dev);
+	if (priv->rq)
+		veth_dev_free(dev);
 err_configure_peer:
 	unregister_netdevice(peer);
 	return err;
-- 
2.28.0

