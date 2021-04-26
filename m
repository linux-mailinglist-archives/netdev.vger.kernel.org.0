Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF036B77D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhDZRFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbhDZRFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:05:34 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2E7C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:52 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d27so32519117lfv.9
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=gIoM+pn92FmZ7l7fGywvcoFz7NhbL6+Ajxhl2csuoH4=;
        b=h/DCxncDj/YrNnh8RNeWnko9Hu+QqSLcJ+7SmZtNXPDB6Nh2VR+UlmwFU1HyMbQJw1
         KJpaxslG4hLz5Q2WlS3v+DiLNCf1XQW/+daYTnRGmiGadi9/SDdfUuq19ZdPkYIpXa/V
         9ISJ8Aw/EUuaS1D6Yi7P+RG4Vey6DytR+g5MzCzLY17JH8HqDikcR/POHLDrHJueGY18
         McuL/u8ZtlTcefFr9/Wh3HFlVu4/pNpwWF9wubfLn/AdRkoQrse8PCxfldEQNDn4L411
         eAN/roayikrAn+4ea3s93LZBdXWBt34HBokMNAVG3WTKHTJZOnuMq9lL9wLdBeziGOD1
         UxVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=gIoM+pn92FmZ7l7fGywvcoFz7NhbL6+Ajxhl2csuoH4=;
        b=oSRoJZNmP8KiW2BD4QQh4bm/Y/JBPdf0FccDK5GzWrclSgFM/yRDGTfWq8RLfu20E0
         +PHMxPZy7FGkxjHzdUfF4+jDXfFLmeHR7nju71VXBYYkjpKDDoqfo/kA9bZmUbvqc2rT
         AKrYOj3aOaCginVH78GTMUJtQ6ghYGi/g+vZNdO8Y+uzQ5TuRFipvU7ylJa1GasCS9sr
         AZuKVjPjym9kNuUtYMzQp2CrEBIPH/bBvUE56Xv/doCtIAQUtBaNGA7qbrn5FYlfq1G9
         07LNY4ShYLeL6EADIXGNgrJN95DBL312AVm/RY2vo4kYxXKWiGPabR9fzhIymozul1cU
         Ag2w==
X-Gm-Message-State: AOAM530G/oXM48XcrAmnvC4CIR2SF5HpZpL8SM88E3wjA4XbIlkDnQKF
        Cg9XD1p4E4L3giepG3xAcgD91g==
X-Google-Smtp-Source: ABdhPJxbcXo+aROPYbeQTvaHsvvv3yjXsCfK4qwS5i4OyRmvKeWwRH5gj22iV2Sb0NOn5SpRl2TV2Q==
X-Received: by 2002:a19:520b:: with SMTP id m11mr13318514lfb.157.1619456691254;
        Mon, 26 Apr 2021 10:04:51 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c18sm59140ljd.66.2021.04.26.10.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 10:04:50 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, idosch@idosch.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 5/9] net: dsa: Track port PVIDs
Date:   Mon, 26 Apr 2021 19:04:07 +0200
Message-Id: <20210426170411.1789186-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426170411.1789186-1-tobias@waldekranz.com>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some scenarios a tagger must know which VLAN to assign to a packet,
even if the packet is set to egress untagged. Since the VLAN
information in the skb will be removed by the bridge in this case,
track each port's PVID such that the VID of an outgoing frame can
always be determined.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/net/dsa.h |  1 +
 net/dsa/port.c    | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 507082959aa4..1f9ba9889034 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -270,6 +270,7 @@ struct dsa_port {
 	unsigned int		ageing_time;
 	bool			vlan_filtering;
 	u8			stp_state;
+	u16			pvid;
 	struct net_device	*bridge_dev;
 	struct devlink_port	devlink_port;
 	bool			devlink_port_setup;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6379d66a6bb3..02d96aebfcc6 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -651,8 +651,14 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.vlan = vlan,
 		.extack = extack,
 	};
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
+	if (!err && (vlan->flags & BRIDGE_VLAN_INFO_PVID))
+		dp->pvid = vlan->vid;
+
+	return err;
 }
 
 int dsa_port_vlan_del(struct dsa_port *dp,
@@ -663,8 +669,14 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 		.port = dp->index,
 		.vlan = vlan,
 	};
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
+	if (!err && vlan->vid == dp->pvid)
+		dp->pvid = 0;
+
+	return err;
 }
 
 int dsa_port_mrp_add(const struct dsa_port *dp,
-- 
2.25.1

