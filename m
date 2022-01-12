Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C4348C439
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 13:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353282AbiALMxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 07:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiALMxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 07:53:05 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC9EC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:53:05 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso3443506pjd.1
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 04:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PMeiRfGJc0VLb0BUrd7j9PE/Kg2nFVodwzl9nDcM1jA=;
        b=VRhmuOqyx732m3kr85Y2TlMYnJmiKmIjtZgJi+2BFrULWm9wUbIOmR9RhiOV9NexgT
         nyS0znfVp7Dfw+BsG/8VD1tsb6TDdowcbMcQ/76RkxIaPIkOcHzySOVHr19G5ecw0bSC
         GNBOGiWI7UVDFe/mNnyazF0lR9GT3aYFHeJ+epsK8L2H9G26ZQtIOOknZSnK4ZDHivJo
         OzvQ7HWVmItsUWtU5dcnrdRbzKKP2WdVkLEyS9LAYBOmPgl/FR02A0XDM5OtwBhO1GUW
         TYjvV2UGKWXDamVowPVKQWAzgBatA+RTDvgReMtm0ymKK4XRtMPCcXIwqpz8ZlhaeYxF
         88Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PMeiRfGJc0VLb0BUrd7j9PE/Kg2nFVodwzl9nDcM1jA=;
        b=3+ehOcmMM/Hb1gJganN/Zt+1KBl1fn/bAAVfwMXv2MfglVUHlh+5jWl/UjVBMII3Xu
         CQ1ZlUmOiuG9xtDOh08QN2EhIj9I8iGlbOlUQI+ZbvpeOf961m1+ZumYIylsQwHokhj5
         IJ+zK6ftD6gQO6FudlPqm8jQ6at4eIRBeKzoB6mPfEpz4ABA5/q6lKzG/Q1vqD2oPELP
         +STFPys/0pnTp6NMaDnngILh7jGhshD1bIl+mk2/m4dSDC4CnrsXrmTAIX+6zYFpu8Bp
         1D7snouJScmx1ZThRbvC2jD9u/EPSyuYTWaj/Yz3Q0HKx/xNO2ogTSxhKlVGQq72W/Yq
         bIaw==
X-Gm-Message-State: AOAM532Sv9ZgK2gn15d+PgRJgxfo0uL4709AfH6J20vRHl2SKOkLwKD7
        KOhzTz4JqlOnc+PYu+CFc6bPqbSjeK0QBA==
X-Google-Smtp-Source: ABdhPJwA/5mzn6a4lwVopneQkL6LOFJBeVbqtFfr/UjWR9SMl8V2RJMVLRmf7i1R2dtyyPouBRiqPQ==
X-Received: by 2002:a63:8a41:: with SMTP id y62mr4189160pgd.428.1641991984794;
        Wed, 12 Jan 2022 04:53:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e0d4:f730:8e14:abc3])
        by smtp.gmail.com with ESMTPSA id h2sm7867235pfv.35.2022.01.12.04.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 04:53:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: bridge: fix net device refcount tracking issue in error path
Date:   Wed, 12 Jan 2022 04:53:00 -0800
Message-Id: <20220112125300.506685-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I left one dev_put() in br_add_if() error path and sure enough
syzbot found its way.

As the tracker is allocated in new_nbp(), we must make sure
to properly free it.

We have to call dev_put_track(dev, &p->dev_tracker) before
@p object is freed, of course. This is not an issue because
br_add_if() owns a reference on @dev.

Fixes: b2dcdc7f731d ("net: bridge: add net device refcount tracker")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/bridge/br_if.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a52ad81596b72dde8e9a0affccd38c91ab59315d..55f47cadb114038920c01bf43e43500e07a3539c 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -615,6 +615,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	err = dev_set_allmulti(dev, 1);
 	if (err) {
 		br_multicast_del_port(p);
+		dev_put_track(dev, &p->dev_tracker);
 		kfree(p);	/* kobject not yet init'd, manually free */
 		goto err1;
 	}
@@ -724,10 +725,10 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
 	br_multicast_del_port(p);
+	dev_put_track(dev, &p->dev_tracker);
 	kobject_put(&p->kobj);
 	dev_set_allmulti(dev, -1);
 err1:
-	dev_put(dev);
 	return err;
 }
 
-- 
2.34.1.575.g55b058a8bb-goog

