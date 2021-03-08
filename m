Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C003311A2
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 16:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhCHPFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 10:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhCHPFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 10:05:17 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECC2C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 07:05:16 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id u4so16491438ljh.6
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 07:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ngAdWgaFg04b00gupLmQJu+pOGUba6DEdcm73GzTXVo=;
        b=elRRa/SxF0nXc1JwXsyAhFdJtQZmrhCJjoJcHAVJ8jHVsOIeu25VqZ24ceMzIlLOG6
         VHeYvrwGwLEFygelX9uPty21sDe+D6UsAcPEq9495Zhw4hu//jBLM9C+jG9iQ+xtUexO
         UphPknqSAd7g0tcLyfKM35OoUgTUAHLmJzBH379mB3pzmum1kNX3NtQc1cs2TIozdvt8
         vn96thy4i/V9ghakKx50LRRRMhodPPf7GDeEBAOkPxD7zyHboc7L2Q2YnkdBqzZ/IAv+
         MIqF8P/jcNJsRpECBQP3fnlonlA6PVKWJ+ih2kVG2NW2JFOYFMcLy07eXpGEbHjaH7Gg
         /SRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ngAdWgaFg04b00gupLmQJu+pOGUba6DEdcm73GzTXVo=;
        b=QwTwCAPVjAjGGfrTb7V+UW6eAYFF0NeDqhj/ja2i2C14l/RAss6fgsxZtfq3291RnH
         BB/RPEhFwgZPlempYqLdJIlUmy4k9XDyESP2Jwbsd89NKhM87anC/1ZWV398gBR2knQM
         7mqUYc2yeiIx65MB924HqiQTBbf0QEVqVuwbUNtdvELyQya3WxObK0Yw/kPrP9kZCWWX
         jg682l1vdkTsRuxM4n1RLZoMIswVAH3Y88b1UjYWummdNOmjmtNYejbqHWMQFmHRcNAL
         7pTOB06kOWor6aV+ZJ/FdW5zcnnH9pZwJ47YyufxcADEiHrMUf1pZ6RRzo8S1pLb4o1H
         jLDQ==
X-Gm-Message-State: AOAM532+ddfsgjP2EDdEHYG6chk9Y2KRwPZvY/tDqJm5e9hARTvtnDgy
        Rt55Rn1bHW8NFW1QZPoZGPbg7g==
X-Google-Smtp-Source: ABdhPJwdRzuzbErc9ombuHQ5OOgDOnr4tVdVJUxEWyBblvH4E7+NRGpp8C0SXBjJQ5ELpQwc0yx5XQ==
X-Received: by 2002:a2e:b0f2:: with SMTP id h18mr13661747ljl.396.1615215914576;
        Mon, 08 Mar 2021 07:05:14 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id i184sm1385696lfd.205.2021.03.08.07.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:05:13 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked interfaces
Date:   Mon,  8 Mar 2021 16:04:04 +0100
Message-Id: <20210308150405.3694678-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210308150405.3694678-1-tobias@waldekranz.com>
References: <20210308150405.3694678-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa_slave_vlan_rx_{add,kill}_vid ndos are required for hardware
that can not control VLAN filtering per port, rather it is a device
global setting, in order to support VLAN uppers on non-bridged ports.

For hardware that can control VLAN filtering per port, it is perfectly
fine to fallback to software VLANs in this scenario. So, make sure
that this "error" does not leave the DSA layer as vlan_add_vid does
not know the meaning of it.

The blamed commit removed this exemption by not advertising the
feature if the driver did not implement VLAN offloading. But as we
know see, the assumption that if a driver supports VLAN offloading, it
will always use it, does not hold in certain edge cases.

Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..64d330f138f5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1346,6 +1346,12 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 	/* User port... */
 	ret = dsa_port_vlan_add(dp, &vlan, &extack);
 	if (ret) {
+		if (ret == -EOPNOTSUPP)
+			/* Driver allows the configuration, but is not
+			 * offloading it, which is fine by us.
+			 */
+			goto add_to_master;
+
 		if (extack._msg)
 			netdev_err(dev, "%s\n", extack._msg);
 		return ret;
@@ -1360,6 +1366,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		return ret;
 	}
 
+add_to_master:
 	return vlan_vid_add(master, proto, vid);
 }
 
@@ -1379,7 +1386,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	 * ports which can be members of this VLAN as well.
 	 */
 	err = dsa_port_vlan_del(dp, &vlan);
-	if (err)
+	if (err && err != -EOPNOTSUPP)
 		return err;
 
 	vlan_vid_del(master, proto, vid);
-- 
2.25.1

