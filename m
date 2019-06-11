Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608CD4171B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407734AbfFKVsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:48:17 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32853 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407700AbfFKVsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:48:14 -0400
Received: by mail-qt1-f195.google.com with SMTP id x2so15565726qtr.0;
        Tue, 11 Jun 2019 14:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O80Exxt17pxJ1Hq+S34lSpMcQJfv5U5vVpWz3fRmYaQ=;
        b=rxPMSDSyoZgC7hpxd7a75dDZGPWhxVKaq7ok542jU92A5zGJUC8o8k7ww/RTHVn/p7
         54nI+L7wEsqcyc0Z5NhLNUo2OYpsqw3wrdNXYwieuS08Ul6J9qT2c0XCetv+iJCjGrih
         B0ZDEGeftrTwzz6Pti81s883BssRa+4qJEIQIFdy8U/EiG6zwPNMXitDo1YCidnG0Jdb
         /E6TbENxb+XifhyAITmDaub/YRb03Esadx97TmTv+JmKpphV2Nd4l6Zq8lFLF+75JJ+J
         pTeshzllleSnhx2s9URP7eNXpR8ghdwz57Qzu8GXGpEDn5NGQMPnqmCcexwT9Gft7GD2
         cUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O80Exxt17pxJ1Hq+S34lSpMcQJfv5U5vVpWz3fRmYaQ=;
        b=XZlMGvSbtMGdtLAvZ/xl/XpdS0SDrxEf202A7kLAkQpeDCs1cLCKKbSFMqqIKcUdlc
         mZhQ4YSMckjLAAwiyHEikgA2Ca9EIXUxginmf3QIOzPVlgBrVYjcnxm7dxdDQsovaih1
         RSYSVBEh5OH4kMq9Q1fbNlbCIDAsyyJSV9zSpULD5pWzNzpfWsymZDErQ3RDQmmG3nvE
         eo14pVawdNwUgxxqwBcfSAN3WiVJ4w2/HFu7QVfsNHWtAJblXqyiKJsScvJy1gI8Rptw
         JdWv0VjTSHGGha66TQklZl/L3hSB6wrnY9tuaziky2bzjGSxRNHAxvX4qknKBYaa5nN/
         OBrg==
X-Gm-Message-State: APjAAAU+zsrsDRMC6+QgF3J+O/3QY+L44+TJQd+ipdtfM6oJL9doLsN1
        hDS/h8uzC9/EXtQ4xbAn+KgsD5Wa3Jg=
X-Google-Smtp-Source: APXvYqz6zj94n7kmdVSyja6gnqFw02F2MoQ+zmv0l9Bjgw3+JmgU8bv8hk7HAFSpVFO6WcjzsqgUxA==
X-Received: by 2002:ac8:eca:: with SMTP id w10mr59939532qti.81.1560289693364;
        Tue, 11 Jun 2019 14:48:13 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p23sm1126109qkm.55.2019.06.11.14.48.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:48:12 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next 1/4] net: dsa: do not check orig_dev in vlan del
Date:   Tue, 11 Jun 2019 17:47:44 -0400
Message-Id: <20190611214747.22285-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611214747.22285-1-vivien.didelot@gmail.com>
References: <20190611214747.22285-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current DSA code handling switchdev objects does not recurse into
the lower devices thus is never called with an orig_dev member being
a bridge device, hence remove this useless check.

At the same time, remove the comments about the callers, which is
unlikely to be updated if the code changes and thus confusing.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/port.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 70744fec9717..f83756eaf8a5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -336,9 +336,6 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	/* Can be called from dsa_slave_port_obj_add() or
-	 * dsa_slave_vlan_rx_add_vid()
-	 */
 	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
 		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 
@@ -354,12 +351,6 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		.vlan = vlan,
 	};
 
-	if (vlan->obj.orig_dev && netif_is_bridge_master(vlan->obj.orig_dev))
-		return -EOPNOTSUPP;
-
-	/* Can be called from dsa_slave_port_obj_del() or
-	 * dsa_slave_vlan_rx_kill_vid()
-	 */
 	if (!dp->bridge_dev || br_vlan_enabled(dp->bridge_dev))
 		return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 
-- 
2.21.0

