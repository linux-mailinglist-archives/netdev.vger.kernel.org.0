Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E71365FCD
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhDTSyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233689AbhDTSx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:53:56 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43F2C06138B
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:24 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so8474463wmi.5
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=shL6zOQzv52YEKOsxH5/pj2HoCJcjW02k0sCp3S/LFo=;
        b=pKejEQtT3ejZSvbuGJ20rJnvpnjqLCCRIYJaHm6GgaQH8P4uSFQ3u0+LuXXiXa4jNw
         kQbXKqYiMuo3dhrcmz37NXt+hdixST97A4/SA4PgqE6ZML7WDvSPToCLMEy1VSjffuGf
         jcSldwcCXEAVpQ4kHKGxfpSLF4R2QPcL4kkFzUlQ0kJ2ACh2dYhGV5qkIW0x5zevOs9r
         OFoev1ofQ6N5T9wPEkaaM8GWEeL86AautK4aK+RoRK1nJhG3wiYMc7VHmU6b+nsHov6A
         QrW9slS28N6TQ1f0Q/KMqWdnMoc7TjkRcmWi6CAtRkAuN0sfOh5rGSOnG06dUqso1UdI
         rl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=shL6zOQzv52YEKOsxH5/pj2HoCJcjW02k0sCp3S/LFo=;
        b=ZTOdl5KmzNAd+1r4bnbH4XrD4teb3Rna/jC+dAim/jNiBnW26tuEhuWqlcqn5zj8ub
         ychoH6QoGQOcrr9XxsKvLfgyHTkZvyGbTX4+oAGFaOEWxz3w4C/itb00YCgrmSRYQFTy
         lTTc8n5V3ctEm0T4/ufnfStu0+ShRXFwxHsYWCeAxoTkVrwssqfq56e0M+M+ZP/E0MPT
         3iof9PHPXoCUDRJNARj+qfxIP6TlxJ5N1tptxOeersjedGN9RwDrk0hOz6Dux9dZSRAB
         p5vMq6MIqC7/CbXKavF/cU5kXHKgdQgRhOrBL3I+gEf2zhIlbmkKocZ5yfl8cpcJPSuo
         4+/Q==
X-Gm-Message-State: AOAM530RtBW6MfhtKxqOkt9TpVWqz7FYPp8v2HYrcL1itsX31hm4TLjb
        VD9fGnW8H14h7406wObWcPG1sA==
X-Google-Smtp-Source: ABdhPJwhX0piPJJ0TmJEpEglEWchVkOSf9tp+S8bnnyq0dmmnU67vMmOsZzOpwsoMq+Pe2ChfO8HTg==
X-Received: by 2002:a1c:f60a:: with SMTP id w10mr5859973wmc.5.1618944803704;
        Tue, 20 Apr 2021 11:53:23 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f7sm25897402wrp.48.2021.04.20.11.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:53:23 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 3/5] net: dsa: Only notify CPU ports of changes to the tag protocol
Date:   Tue, 20 Apr 2021 20:53:09 +0200
Message-Id: <20210420185311.899183-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420185311.899183-1-tobias@waldekranz.com>
References: <20210420185311.899183-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously DSA ports were also included, on the assumption that the
protocol used by the CPU port had to the matched throughout the entire
tree.

As there is not yet any consumer in need of this, drop the call.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/switch.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 32963276452f..9bf8e20ecdf3 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -323,15 +323,6 @@ static int dsa_switch_vlan_del(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool dsa_switch_tag_proto_match(struct dsa_switch *ds, int port,
-				       struct dsa_notifier_tag_proto_info *info)
-{
-	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
-		return true;
-
-	return false;
-}
-
 static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 				       struct dsa_notifier_tag_proto_info *info)
 {
@@ -344,16 +335,14 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	ASSERT_RTNL();
 
 	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_tag_proto_match(ds, port, info)) {
-			err = ds->ops->change_tag_protocol(ds, port,
-							   tag_ops->proto);
-			if (err)
-				return err;
+		if (!dsa_is_cpu_port(ds, port))
+			continue;
 
-			if (dsa_is_cpu_port(ds, port))
-				dsa_port_set_tag_protocol(dsa_to_port(ds, port),
-							  tag_ops);
-		}
+		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+		if (err)
+			return err;
+
+		dsa_port_set_tag_protocol(dsa_to_port(ds, port), tag_ops);
 	}
 
 	/* Now that changing the tag protocol can no longer fail, let's update
-- 
2.25.1

