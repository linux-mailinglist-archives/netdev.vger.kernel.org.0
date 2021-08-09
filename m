Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B113E4FAB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbhHIXAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 19:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbhHIXAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 19:00:02 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF325C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 15:59:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id n12so3261353edx.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 15:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MzJr0qbqsvMw55RyyIfqZjVAh0S51a48rx6Wiy6q1jc=;
        b=ASZB51Kw764JmFIkT8xeMKlV6w950pnSN5eZfS6ZGWXH6bRk/P/f1eS+4+zc1P8sJo
         P1TnwhIvL6H+xyDXMAIadhrTa3dJ9H02RJ8W9pdqeDnACAvlKemnM5IqeJ71OOrMbBQ+
         cdd7LhkG2hn68iA3hK2MXfkrP/0z91c0o2b7XiQ6kfrm2+f2ZS7o9cCFKl56t6xvgIyz
         NxT6g+V8fghDRlk50qfpnpBbJlUKjzk6PTdsHVEoKRDCbL6lknFaodbyBG4XApUA3ID8
         vQ4mukklJu+0HAcO5Xjr4fP51NiftK4BdYDzYqg7BcAOBKHTkG8Wap74+PLBA+FsZdej
         jpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MzJr0qbqsvMw55RyyIfqZjVAh0S51a48rx6Wiy6q1jc=;
        b=C2Ec9ct7H+eeIXcIrP1bFvyi6m6aCq8pPU5YsxSuAFBGHhUlJZL8+xY1Vcjwo4N7PI
         3yhRoAfYWJh/B5YVEmSmkwLjQCKprtorCSl/DL2AubYxPnU4ylHcyEigPAmFIjpYEmd4
         80AwIokokNqQgjFPB5WiggJyXcrMcilCgzbGsv00AnNbH7AWFtDZbhg90m5Fm+9ZR9L1
         d3AipWEZbm+jgcIPqNXQqIrqxEtOXXhCyw18FT0rNxiNq1DwBe40wyfuEddepHzk9eru
         pdzBBxgbjurw1ccMhtAOrJL1dob6h98RVvlDglKoUYxRuJ4220+BJD2lSXV8YPdKgiae
         dtFg==
X-Gm-Message-State: AOAM532/NY20+mymUocplCPuVL2WJEpKZnFMcGC1IlgOoFXzxn9AbgQ6
        po8xdF6KFNkS3iyqyac6vpHlS07Wn3omfw==
X-Google-Smtp-Source: ABdhPJxc4jSSmf9PrpRZxrxkRoexiFO15pz9nv8mIXM+kfqrgK4bVpuKwewgnm7p5uwRU/t7KWe78A==
X-Received: by 2002:a05:6402:104b:: with SMTP id e11mr926156edu.62.1628549979431;
        Mon, 09 Aug 2021 15:59:39 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id n26sm8620495eds.63.2021.08.09.15.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:59:39 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:59:37 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/7] net: dsa: microchip: ksz8795: Reject unsupported
 VLAN configuration
Message-ID: <20210809225936.GD17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switches supported by ksz8795 only have a per-port flag for Tag
Removal.  This means it is not possible to support both tagged and
untagged VLANs on the same port.  Reject attempts to add a VLAN that
requires the flag to be changed, unless there are no VLANs currently
configured.

VID 0 is excluded from this check since it is untagged regardless of
the state of the flag.

On the CPU port we could support tagged and untagged VLANs at the same
time.  This will be enabled by a later patch.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c    | 27 +++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 95842f7b2f1b..045786f4e29e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1140,13 +1140,38 @@ static int ksz8_port_vlan_add(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p = &dev->ports[port];
 	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
 
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
-	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+	/* If a VLAN is added with untagged flag different from the
+	 * port's Remove Tag flag, we need to change the latter.
+	 * Ignore VID 0, which is always untagged.
+	 */
+	if (untagged != p->remove_tag && vlan->vid != 0) {
+		unsigned int vid;
+
+		/* Reject attempts to add a VLAN that requires the
+		 * Remove Tag flag to be changed, unless there are no
+		 * other VLANs currently configured.
+		 */
+		for (vid = 1; vid < dev->num_vlans; ++vid) {
+			/* Skip the VID we are going to add or reconfigure */
+			if (vid == vlan->vid)
+				continue;
+
+			ksz8_from_vlan(dev, dev->vlan_cache[vid].table[0],
+				       &fid, &member, &valid);
+			if (valid && (member & BIT(port)))
+				return -EINVAL;
+		}
+
+		ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
+		p->remove_tag = untagged;
+	}
 
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
 	ksz8_from_vlan(dev, data, &fid, &member, &valid);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6afbb41ad39e..1597c63988b4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -27,6 +27,7 @@ struct ksz_port_mib {
 struct ksz_port {
 	u16 member;
 	u16 vid_member;
+	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	int stp_state;
 	struct phy_device phydev;
 
-- 
2.20.1

