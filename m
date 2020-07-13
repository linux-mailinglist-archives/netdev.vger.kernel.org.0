Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD1521D0FA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgGMHzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgGMHzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:55:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B52C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:55:54 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so14748993wrv.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U0xHrDyuP3Svmbc/4508Y7n/6ojkkw4nrDsriuZwAbQ=;
        b=LH2TBK8wXecjFcDyFwOlRw00XlQnrI6jwFhAzA2TffvWyb92qLAQXgAPk/s1HEqYX7
         U2UdeySCFC2wldaWxEwcLEEBOFghNXGTymyhnZI/Tio3IWphyWgsBssTXvEyf76L4LuA
         Ev+iQaf+BJa9GGk9l8roVBF6KKE2L66PhbLcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U0xHrDyuP3Svmbc/4508Y7n/6ojkkw4nrDsriuZwAbQ=;
        b=Bnz28y+fkRzcKDctYIul2FNnz1UoTcLcXNPi7RMmiypdGh/y8HIVG96nBWOrn5Oko4
         hVItupvcZ7/atEGsxGo9gwnQwrKCqVTZIFg2jf3YUVTFaV8T02BoJt5ts7b64yFCGrv4
         y/878uXVjOguIZH69KjWvWJU7Dt4lj1n5qLHGUFkVfxEwFj0cOmn/AIqHZzKSuHNzL+6
         LNRiGe2n/yfA+fBMQVYo08z01kJJseR6VjxL8fD1hPQ+oQvvPL9MLjq66zJ9Cqyhd0Tv
         /nRaXM4YHjbIoJjYsLnZNR6CwMYo3vnQG7xUjqSvvJssoHHZa9aOQNOEmEASJ8XnT9zT
         kvUQ==
X-Gm-Message-State: AOAM530rcHuAAqZTjXDGPRF+wU0/u0DZzgg0i4yljoGCX9gMYkmOYIY6
        /xJosdSsbLbWQHYtSZQpbrH3QlZ8pTBfnw==
X-Google-Smtp-Source: ABdhPJzWD111ftJYX09eaNAoYqNhx6iclvtp2LS0w7D1vVNx5HHAMRclOLZ3X+zeJpNooHwrniOi6A==
X-Received: by 2002:a5d:40c9:: with SMTP id b9mr75693909wrq.425.1594626952656;
        Mon, 13 Jul 2020 00:55:52 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r8sm22268160wrp.40.2020.07.13.00.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:55:51 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net: bridge: fix undefined br_vlan_can_enter_range in tunnel code
Date:   Mon, 13 Jul 2020 10:55:46 +0300
Message-Id: <20200713075546.1147199-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bridge vlan filtering is not defined we won't have
br_vlan_can_enter_range and thus will get a compile error as was
reported by Stephen and the build bot. So let's define a stub for when
vlan filtering is not used.

Fixes: 94339443686b ("net: bridge: notify on vlan tunnel changes done via the old api")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
I mixed br_netlink_tunnel with br_vlan_tunnel where the former is always
compiled and the latter only with vlan filtering enabled.

 net/bridge/br_private.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 65d2c163a24a..a0034400b762 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1200,6 +1200,12 @@ static inline void br_vlan_notify(const struct net_bridge *br,
 				  int cmd)
 {
 }
+
+static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
+					   const struct net_bridge_vlan *range_end)
+{
+	return true;
+}
 #endif
 
 /* br_vlan_options.c */
-- 
2.25.4

