Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7928236B77B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhDZRFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbhDZRFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:05:33 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36510C06175F
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:50 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d27so32518893lfv.9
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=OOyB/1EE0eWY12Fb0O+Ry3sAB71ImU80hOCuCFisolk=;
        b=0HxjTxUqm16Mjfaxqs+3gIH6mIXzFURaMQXnQTxOWVr/b1qcz/uuVMvXrH4PIkKHkt
         E0of8vDgA0EnZ/7ghKu9m3qVi8i2U8tX46qT6tUf58bHMHPKoyWIx2Myyi3XdpWHnPai
         361UPhyG0ytSzko2v1PqsnWDTKm/+5i22SzYBDzwmE5ZBnl7MMMwRPIhsKpRZyyUJz8N
         HkZH702ly+zqHvMI5mi00tLT5FFcBFdiqT4r6nwkqMQOCo0TgQYBE+sTvsy0XHaYvIIa
         TqkiHTN6zFfAt9sDvyURfitCnKpGZ0j6l3uDComxii0BQaHOgBWygUe5GY/Joy+U36Iy
         0cUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=OOyB/1EE0eWY12Fb0O+Ry3sAB71ImU80hOCuCFisolk=;
        b=sekRKatpMPOPxPz7GeoirB8ecJyNpRTEG9LB5KguBs8jrOnE0PfKIAvGlh1Z9LkH62
         JgwkIGDquvmuXjp0qm8Xz0IRdVQYtGvQBqpeVdXh7tB9ByNjwDJ0PdUA7WsYc39fhm4M
         eLCkogX4dKs+M8FmFMiUcQLRYuqD/gHflp5cdAZ36WUu7zJh4+bJUOESoR1XNDeEMBPV
         fRW0O/VV4J169R1wq5iweVB/SipjiBeDaZ9PHMIK6FjcaeIDJAZ2YC+dYV0oMNy8N/8G
         8w+cR0vLP7tQPeb7EfE9BkWcvxYcN82lWmW1OegViLpLmSTEJT8QdZGFJLQRjYQMDrTO
         USWQ==
X-Gm-Message-State: AOAM532ozrphDBReeurIk0FbU12ujoHrPxJvRlUBZ+zKbsM1Q0cRg3L5
        HOn+meZmVDyoEePTmEbCjU+shw==
X-Google-Smtp-Source: ABdhPJyBuqqrojOvqZwoXps/D2lJd/hUbwvs/OaDJtNxxT3mmaXpza+LFxDwuMR7dWk7xGkVt1hhQQ==
X-Received: by 2002:ac2:5cb3:: with SMTP id e19mr13168782lfq.89.1619456687593;
        Mon, 26 Apr 2021 10:04:47 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c18sm59140ljd.66.2021.04.26.10.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 10:04:47 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 1/9] net: dfwd: Constrain existing users to macvlan subordinates
Date:   Mon, 26 Apr 2021 19:04:03 +0200
Message-Id: <20210426170411.1789186-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426170411.1789186-1-tobias@waldekranz.com>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dfwd_add/del_station NDOs are currently only used by the macvlan
subsystem to request L2 forwarding offload from lower devices. In
order add support for other types of devices (like bridges), we
constrain the current users to make sure that the subordinate
requesting the offload is in fact a macvlan.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 3 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c     | 3 +++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2fb52bd6fc0e..4dba6e6a282d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1352,6 +1352,9 @@ static void *fm10k_dfwd_add_station(struct net_device *dev,
 	int size, i;
 	u16 vid, glort;
 
+	if (!netif_is_macvlan(sdev))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/* The hardware supported by fm10k only filters on the destination MAC
 	 * address. In order to avoid issues we only support offloading modes
 	 * where the hardware can actually provide the functionality.
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c2d145a56b5e..b90b79f7ee46 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7663,6 +7663,9 @@ static void *i40e_fwd_add(struct net_device *netdev, struct net_device *vdev)
 	struct i40e_fwd_adapter *fwd;
 	int avail_macvlan, ret;
 
+	if (!netif_is_macvlan(vdev))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if ((pf->flags & I40E_FLAG_DCB_ENABLED)) {
 		netdev_info(netdev, "Macvlans are not supported when DCB is enabled\n");
 		return ERR_PTR(-EINVAL);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c5ec17d19c59..ff5334faf6c5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9940,6 +9940,9 @@ static void *ixgbe_fwd_add(struct net_device *pdev, struct net_device *vdev)
 	int tcs = adapter->hw_tcs ? : 1;
 	int pool, err;
 
+	if (!netif_is_macvlan(vdev))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (adapter->xdp_prog) {
 		e_warn(probe, "L2FW offload is not supported with XDP\n");
 		return ERR_PTR(-EINVAL);
-- 
2.25.1

