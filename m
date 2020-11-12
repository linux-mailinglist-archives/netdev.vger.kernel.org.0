Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A202B0395
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgKLLML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLLMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:12:09 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908C0C0613D1;
        Thu, 12 Nov 2020 03:12:09 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 33so5558941wrl.7;
        Thu, 12 Nov 2020 03:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t1pdCeyp/Dvzku3Y54x16meEdju3+1zInH0bmOMDDL0=;
        b=XtJAfKg8cmV/weC4CRM0DfyVs6/MmiX/gtIGuFegWgMaPHAg/Sm2ZMgBs6NAlDSxG3
         Dk2Wx50IcCLt+PF2mn3CfEaoKMHX+WrMB4oTfihQeXZejwZW9qAsbv/SBJe2dpDPT6vu
         rnUJcp9+MwooScc7SjIR7+pEWrY63qgM4dRjZcynqwGqHU1FfuEvC9WcsSD6hM2Snxa1
         T8Z0HcpLo/mFl0rcT/Qu3j6W/v7Mmujy5ep7ckxehw+2AUHRo7PrA2k+e2h/U/flduSO
         f5EO9GD+f/EyvK3pfYJZer8yfpzliQKOp77D8ei241UcvngqiCcYdC20Qyp/wzlHobUz
         YCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t1pdCeyp/Dvzku3Y54x16meEdju3+1zInH0bmOMDDL0=;
        b=t9nBzLoPh1SdwWv6jFQ1IINbjCckmdpL9mK6QKAgpdS1ijVOPjakHUqINiJ5K3Gn+P
         IQrqXipBXwvpiABssTNpn6lpW36abUQM9/tEBUiAacrTtdrABkpnxO1CUiX77u43IepQ
         bejO7q5JkAo9LgaWVv1nMU3Q+yTPZQqWR3std6FZjwHnR/o7np/pB7zte0Wx2pKBvmdK
         nKOe7TR6zGVoo4zIPmKnzdPBTVYOyLKs1HNr5sd/8uuxlMrjd2AW5I3vEv/pFpdMIWQ2
         tSPQL+QrTXkYK78fXL5YWPQAZkCM8Ru9n/ZXjbPuMjMgiWZ0kM2MOIf0uXRA4g3d7pZA
         E0zg==
X-Gm-Message-State: AOAM532p/0wQFe6+xWMUO7p1OVDv2R+43bwg9qoo7WlwSMZenJNJwM8j
        k5QQ34aAshdPJRWFHFWDDIk=
X-Google-Smtp-Source: ABdhPJzJDOVpqsF4ZiSXu2YN5wygEyo1lKeDDy737wWNYVM3m1V1uU+4CpHeLusXvUQ0WYX5LKy7Ng==
X-Received: by 2002:adf:ea03:: with SMTP id q3mr5462838wrm.141.1605179528311;
        Thu, 12 Nov 2020 03:12:08 -0800 (PST)
Received: from ubux1.panoulu.local ([2a00:1d50:3:0:1cd1:d2e:7b13:dc30])
        by smtp.gmail.com with ESMTPSA id g11sm6456484wrq.7.2020.11.12.03.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:12:07 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH 2/3] net: openvswitch: use core API for updating TX stats
Date:   Thu, 12 Nov 2020 13:11:50 +0200
Message-Id: <20201112111150.34361-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
stats.

Use this function instead of own code. While on it, replace
"len" variable with "skb->len".

Signed-off-by: Lev Stipakov <lev@openvpn.net>
---
 net/openvswitch/vport-internal_dev.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 1e30d8df3ba5..116738d36e02 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -33,23 +33,17 @@ static struct internal_dev *internal_dev_priv(struct net_device *netdev)
 static netdev_tx_t
 internal_dev_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-	int len, err;
+	int err;
 
-	len = skb->len;
 	rcu_read_lock();
 	err = ovs_vport_receive(internal_dev_priv(netdev)->vport, skb, NULL);
 	rcu_read_unlock();
 
-	if (likely(!err)) {
-		struct pcpu_sw_netstats *tstats = this_cpu_ptr(netdev->tstats);
-
-		u64_stats_update_begin(&tstats->syncp);
-		tstats->tx_bytes += len;
-		tstats->tx_packets++;
-		u64_stats_update_end(&tstats->syncp);
-	} else {
+	if (likely(!err))
+		dev_sw_netstats_tx_add(netdev, 1, skb->len);
+	else
 		netdev->stats.tx_errors++;
-	}
+
 	return NETDEV_TX_OK;
 }
 
-- 
2.25.1

