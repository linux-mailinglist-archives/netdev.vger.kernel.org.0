Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1368A3A1637
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236935AbhFIN5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhFIN5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:57:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6E2C061760;
        Wed,  9 Jun 2021 06:55:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c5so25560533wrq.9;
        Wed, 09 Jun 2021 06:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tbTIFZQTIEpa1eyBbGiQT0roNrVenTXWuaspqjQrcdk=;
        b=gOmJuGsx9Phzg2NGfm5LJ7fSnle+7mBBXGBplGinnuk27o/HMwQ+PRxnNOYBKHK/Hw
         RWUxWQ0XlA/qfQEpB4IEIcvXezeVcjyZfLxuhadkXFrxImzZAYT28Alc7CWvqy+gXAa9
         P9+kMN0uB79PkGjrmqeLel6ooCXAaYKRHw180gmkCEo7rKDp3bEqcNYigXAoSMRTeHsC
         zMpYSfxBa25ykISQWFB4RW003KeH0msoUfJxwgvMVVLZWVpXutYJ1yTGVGsPVPXKgLTE
         isTx6FFcQl6SJZFn9CMIIfhqq94dyXfDZffLSJ/5JriCjHcmUvtlXuwqQUVIk5tXrwZG
         Gw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tbTIFZQTIEpa1eyBbGiQT0roNrVenTXWuaspqjQrcdk=;
        b=dpQSRvmPt7T/rlJl9rv4q3a4iHE0AZuyJE2scUvuNbF4jE+b9brY4sWpClmp1j9x6v
         DUkjO587XuSscLeCVUzfxdXc/N3TLs7PR7V9VPmV6DkJJKNh+Lg3G67ysiCtQ4T3WxA2
         qY7D7GSMyBjSs0bBIwcMoU1hqeO/5Tiz/PtPi/IUFlL/j8xjLd2MaArdCdwMmcvLkwTm
         pdERXmhT2EtCZeHaDCqG3r5q2Tt9Vro3qE6cFx5lSi+sS7AMKyA7GsdLDBG8DtxLgQU2
         w5+TbhGCLsf4tzqM2pPyzzKlZtheD2bLAj3aHbCjd3XWSYxG+lFHEqe27T/FZHTI1vrp
         7f9g==
X-Gm-Message-State: AOAM531VIN/6PtvNGRc+NJZ7DvRvYQgE8kbJqFL4pe4EH6wZ3tjepQtf
        ldcvFeAvMYyVX0DYjQOGtP+MsH2DfQinRJs=
X-Google-Smtp-Source: ABdhPJyrlvXOBPRcaMWVxhlQvES6nAcf+k+Wb7q0pkR8P2yF2NfpjZzvXT0cUDOoCVn0uCb6fWw+tw==
X-Received: by 2002:a5d:47c3:: with SMTP id o3mr20219233wrc.122.1623246954905;
        Wed, 09 Jun 2021 06:55:54 -0700 (PDT)
Received: from balnab.. ([37.17.237.224])
        by smtp.gmail.com with ESMTPSA id q20sm4575wrf.45.2021.06.09.06.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:55:54 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next 2/3] net: bonding: Use per-cpu rr_tx_counter
Date:   Wed,  9 Jun 2021 13:55:36 +0000
Message-Id: <20210609135537.1460244-3-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The round-robin rr_tx_counter was shared across CPUs leading
to significant cache trashing at high packet rates. This patch
switches the round-robin mechanism to use a per-cpu counter to
decide the destination device.

On a 100Gbit 64 byte packet test this reduces the CPU load from
50% to 10% on the test system.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 drivers/net/bonding/bond_main.c | 18 +++++++++++++++---
 include/net/bonding.h           |  2 +-
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 38eea7e096f3..917dd2cdcbf4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4314,16 +4314,16 @@ static u32 bond_rr_gen_slave_id(struct bonding *bond)
 		slave_id = prandom_u32();
 		break;
 	case 1:
-		slave_id = bond->rr_tx_counter;
+		slave_id = this_cpu_inc_return(*bond->rr_tx_counter);
 		break;
 	default:
 		reciprocal_packets_per_slave =
 			bond->params.reciprocal_packets_per_slave;
-		slave_id = reciprocal_divide(bond->rr_tx_counter,
+		slave_id = this_cpu_inc_return(*bond->rr_tx_counter);
+		slave_id = reciprocal_divide(slave_id,
 					     reciprocal_packets_per_slave);
 		break;
 	}
-	bond->rr_tx_counter++;
 
 	return slave_id;
 }
@@ -5278,6 +5278,9 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	list_del(&bond->bond_list);
 
+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN)
+		free_percpu(bond->rr_tx_counter);
+
 	bond_debug_unregister(bond);
 }
 
@@ -5681,6 +5684,15 @@ static int bond_init(struct net_device *bond_dev)
 	if (!bond->wq)
 		return -ENOMEM;
 
+	if (BOND_MODE(bond) == BOND_MODE_ROUNDROBIN) {
+		bond->rr_tx_counter = alloc_percpu(u32);
+		if (!bond->rr_tx_counter) {
+			destroy_workqueue(bond->wq);
+			bond->wq = NULL;
+			return -ENOMEM;
+		}
+	}
+
 	spin_lock_init(&bond->stats_lock);
 	netdev_lockdep_set_classes(bond_dev);
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 34acb81b4234..8de8180f1be8 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -232,7 +232,7 @@ struct bonding {
 	char     proc_file_name[IFNAMSIZ];
 #endif /* CONFIG_PROC_FS */
 	struct   list_head bond_list;
-	u32      rr_tx_counter;
+	u32 __percpu *rr_tx_counter;
 	struct   ad_bond_info ad_info;
 	struct   alb_bond_info alb_info;
 	struct   bond_params params;
-- 
2.30.2

