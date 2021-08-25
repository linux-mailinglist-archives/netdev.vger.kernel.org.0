Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8751B3F712D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 10:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbhHYIjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 04:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239367AbhHYIjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 04:39:39 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A4AC0617AE;
        Wed, 25 Aug 2021 01:38:49 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w8so22371361pgf.5;
        Wed, 25 Aug 2021 01:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Dbzh7P/VLZjz7T/PHz/hbVveQrgt7YUkwRS8X1gGPMQ=;
        b=PTryOgjrkt3xSyLLZ3nI0ySlPsg/rl42Z0nmnf4JRFvvk84qFrsvr2LFark0zt6Zak
         KupWKcKNvx4c7Kp/JxLfkkMJ5hHP0qa0vGDfzYUEcKlfzYynxZH7176zVLY7hjT/webd
         RsJkq6SgkfevzO0pn/U5EJneZBoK5QW6SCi+cP1M/1dOLqYHQ+RmwS0iV51F8yTjm0eF
         r3vARMZhBwWhsOWRwpVF/DAgWgEgb11ZmyT/y6KHl/7s300OE8fwyf9ZYkVgqCCIdvfc
         fex16reT0nrhHm1tz13SsnBM9Ini/rBK9wRaSpkGpdYP1BhHkX/gxzrIdxd6tnqRFXdH
         UUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dbzh7P/VLZjz7T/PHz/hbVveQrgt7YUkwRS8X1gGPMQ=;
        b=O2r/U/vM2BuoHwtKOjosuDM8O/WNeZvo29h3Ew5MwnLm3seiPBcWm85IjVwtxZH7ZM
         SH1JicHeCPPlHTIa1e6HbDv4TsIkICfpcsBNI6pkLBjFzvefDXEKAG6H2KJc5lziQkJk
         ol0g9bv2du7gvPKYOv4E2bBnuw+zAUL1MWBUoC98DWggGfcL5R3A8dbELeACmW7+x8YN
         0ZGXgB8FsNBzUuCzgKGyILk2ED6slOck3pLlVv3DS/9cT/LNNeEFh45W+6lrEac/M8xK
         nO5vKdOfTHdsOipfGfFz9esWYz2CsyNbJYjpCftA8gMxblbe5/r4uI0YGd+jdS0C8XyN
         DJNQ==
X-Gm-Message-State: AOAM533L7sSKF/xF4apUh34vuoj8g9o/aAehGiK35v2W5xcs06cw2lko
        h9SvgHRfV4OboE7UZRkWRzE=
X-Google-Smtp-Source: ABdhPJwKwchoRLdo4BZ3JiVc2OLHRyzG0ZZZHm30+1GgS/uyS0K2qPV/3P41I55ugBeCg/tJeNDEHA==
X-Received: by 2002:a63:3dcd:: with SMTP id k196mr1250905pga.387.1629880729365;
        Wed, 25 Aug 2021 01:38:49 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id p18sm24872294pgk.28.2021.08.25.01.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 01:38:48 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC net-next 1/2] net: dsa: allow taggers to customise netdev features
Date:   Wed, 25 Aug 2021 16:38:30 +0800
Message-Id: <20210825083832.2425886-2-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210825083832.2425886-1-dqfext@gmail.com>
References: <20210825083832.2425886-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow taggers to add netdev features, such as VLAN offload, to slave
devices, which will make it possible for taggers to handle VLAN tags
themselves.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 include/net/dsa.h | 2 ++
 net/dsa/slave.c   | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f9a17145255a..f65442858f71 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -96,6 +96,8 @@ struct dsa_device_ops {
 	 * its RX filter.
 	 */
 	bool promisc_on_master;
+	/* Additional features to be applied to the slave. */
+	netdev_features_t features;
 };
 
 /* This structure defines the control interfaces that are overlayed by the
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 662ff531d4e2..6d6f1aebf1ca 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1885,7 +1885,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 
 	p->xmit = cpu_dp->tag_ops->xmit;
 
-	slave->features = master->vlan_features | NETIF_F_HW_TC;
+	slave->features = master->vlan_features | cpu_dp->tag_ops->features |
+			  NETIF_F_HW_TC;
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
-- 
2.25.1

