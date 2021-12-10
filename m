Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8795A4707AC
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbhLJRy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:54:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhLJRy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639158680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ukYg9yVF7Hnqlm26oYbdTUk4RmNwQN7/khFBiUIKu2I=;
        b=haZ5+HMsi7ZiTrXrzDpKXSWWa/LLNhzSuktg7gaFrfWtWD5vnpJNWshGXXvtP3uyGVNFTz
        sF+GWSAB4dXmx72eNaWW5nKi0xFXb3z2PdC8JmsNz/EXO7fPygIqDLPWAV7YTw2LESXRqa
        OMj98CR6M+LVtPxOUOXBEPSibZEwreU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-566-Lq2EVaPaNU-VR1NJmzM47Q-1; Fri, 10 Dec 2021 12:51:17 -0500
X-MC-Unique: Lq2EVaPaNU-VR1NJmzM47Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 197471006AA2;
        Fri, 10 Dec 2021 17:51:16 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.193.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E09D110013D0;
        Fri, 10 Dec 2021 17:51:13 +0000 (UTC)
From:   Filip Pokryvka <fpokryvk@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Antonio Cardace <acardace@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Filip Pokryvka <fpokryvk@redhat.com>
Subject: [PATCH net] netdevsim: don't overwrite read only ethtool parms
Date:   Fri, 10 Dec 2021 18:50:32 +0100
Message-Id: <20211210175032.411872-1-fpokryvk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ethtool ring feature has _max_pending attributes read-only.
Set only read-write attributes in nsim_set_ringparam.

This patch is useful, if netdevsim device is set-up using NetworkManager,
because NetworkManager sends 0 as MAX values, as it is pointless to
retrieve them in extra call, because they should be read-only. Then,
the device is left in incosistent state (value > MAX).

Fixes: a7fc6db099b5 ("netdevsim: support ethtool ring and coalesce settings")
Signed-off-by: Filip Pokryvka <fpokryvk@redhat.com>
---
 drivers/net/netdevsim/ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index b03a0513e..2e7c1cc16 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -77,7 +77,10 @@ static int nsim_set_ringparam(struct net_device *dev,
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
+	ns->ethtool.ring.rx_pending = ring->rx_pending;
+	ns->ethtool.ring.rx_jumbo_pending = ring->rx_jumbo_pending;
+	ns->ethtool.ring.rx_mini_pending = ring->rx_mini_pending;
+	ns->ethtool.ring.tx_pending = ring->tx_pending;
 	return 0;
 }
 
-- 
2.27.0

