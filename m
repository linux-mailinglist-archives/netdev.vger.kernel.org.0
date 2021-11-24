Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FC245CD67
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 20:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243314AbhKXTmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 14:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbhKXTms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 14:42:48 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77106C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 11:39:38 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o29so3504011wms.2
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 11:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3QGPgxprh2tb4Gl3h4Uv0GQ0Zm/aQZNDdCKiWQFxV4=;
        b=Vs6GqXTRoEgfIrL4ioHj2vTbxNFzHHhRKV/cH+MwljLJjuMYhd4Xg6apa5T1kLs1KR
         G74Y7f3UgHj+a0ZYPksnCWcMIP4vCu6IE7HjdLPJ0WSvXSxNDp3I3+kq3pql1I3a7zKv
         0AP8yCngVgBc3ZR/JOMgLRSmnD250nsTeYmVn6gqVoKRX+wXHOFWmLXMKYZSdHvcoEOX
         rdt+Ouw76gm2cz/AWYpPiQ+dhBgAK1kCpQjm3Pn9JaNPf6iLlgw+bS+TymajlQNdPhmt
         /aOuZabhtvYAHgU5X6nQdM4/IeSSFNCb3+UYS0WGh+tVLP4Q+I9NreR/Wj3RrY7pD6xD
         vS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3QGPgxprh2tb4Gl3h4Uv0GQ0Zm/aQZNDdCKiWQFxV4=;
        b=PmAt7GOfSUdAlTMLm4F8UCYydWFTVtR4ZiAPJ6nD3IT4cQS4ee16Duiavn2pET6RgX
         krMRlfOP7jqp8TpiR4VJBdONqUutO5qmUQB9vOz1SAiAwvkmjD1+KwVmDR+v7H3fjLSh
         NTrzQyJNn72qilKyJ2/S8Vhlu0RjPak6TKBtM1Q+tl6blkOdj2m6AR24esShv2TRX5/z
         aY9kjUKRxvjOdSOtrl6ynBE1yQjIwb1I/6/MBmGyJdb9jl/JwnKO4AqIy5zLzS8tcyA8
         ge4Y626ZwI2r/Up9bKv234VYK4rxPeSgHq8+ijEh2SnV3HWdPE3jv1an1uJsbVdwpL6G
         TLnA==
X-Gm-Message-State: AOAM532WWJE0Rr4Zer+U2cHivU8t4Y3Hi5JMd9iDixcBOz/fL3KLq8MP
        eKmWmFJsqo7AoF9P1+1MIJa17EnMFh7sGg==
X-Google-Smtp-Source: ABdhPJy0si6hptmjDHmROfJQ4xQvWKTZK8N2ZN8vFvfIHHDQuVYZnn1NUmIQw9iOlg1ijds6JxFEuA==
X-Received: by 2002:a05:600c:35d4:: with SMTP id r20mr18928112wmq.76.1637782776819;
        Wed, 24 Nov 2021 11:39:36 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z8sm710011wrh.54.2021.11.24.11.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 11:39:36 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        christophe.jaillet@wanadoo.fr
Subject: [PATCH net-next] bridge: use __set_bit in __br_vlan_set_default_pvid
Date:   Wed, 24 Nov 2021 14:39:33 -0500
Message-Id: <4e35f415226765e79c2a11d2c96fbf3061c486e2.1637782773.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same optimization as the one in commit cc0be1ad686f ("net:
bridge: Slightly optimize 'find_portno()'") is needed for the
'changed' bitmap in __br_vlan_set_default_pvid().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 49e105e0a447..84ba456a78cc 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1063,7 +1063,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (br_vlan_delete(br, old_pvid))
 			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
-		set_bit(0, changed);
+		__set_bit(0, changed);
 	}
 
 	list_for_each_entry(p, &br->port_list, list) {
@@ -1085,7 +1085,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (nbp_vlan_delete(p, old_pvid))
 			br_vlan_notify(br, p, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(p->br, p, pvid, 0, RTM_NEWVLAN);
-		set_bit(p->port_no, changed);
+		__set_bit(p->port_no, changed);
 	}
 
 	br->default_pvid = pvid;
-- 
2.27.0

