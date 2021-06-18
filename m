Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0CC3AD229
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhFRScu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhFRSco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F6AC06175F
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:32 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t3so9853832edc.7
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mdGI9KdhxE1M65wlF6EhJcVpZobBKGasuvbTwE7j2TM=;
        b=Z2KLDrEOrNyPy4fVcDgr6FK1ZZoHu5MwWeesaGQrlWAM8cQSErjucWWlEWrxUnsLkO
         0owQ9htX1Ds46X+XEo+QPIg5lLA/Kq51cDxmXr0oylRteNgrjF2oYpKwresCZDcxVQxW
         LDHnWhbhYx2kT4w09Z8+1F+WHwd8qkuyje2RYzek58Y/+kSzPa9EvURH3ssDWwcbJKoD
         enmuOhkcOrwQozvGgId7Mz9I7Bb8XrMKNb0QrM/r2JSndjm3HYmKbzCJ9YVFImXf+YZU
         ibuqdZEYHjQuhP5znOxRCeU/UgyyvXrAEFitwt2FpO5cTCAvUwfjOf6vftgrf5cbclLm
         AqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mdGI9KdhxE1M65wlF6EhJcVpZobBKGasuvbTwE7j2TM=;
        b=ite05xi0plGRMHowsAaQmNt8tvU/u5aRGBV96kGSG9BU0vxRVWi7Ui/LVR3kO9JQLw
         V23AMf9v+vax+tswGeDTR0y4QIlI/sxU2+SNqsnb4+4fdnzSHJ+MszR4GpBRQ1PPpQYa
         t6M0Qq5/+X+rOTUP+FPFCG+7DNhQ/jbOCwm5LG9gy9lYtz2drUFccQAST3vT/9A8RNJs
         fFwkecYQgvXwl4nCsyvhOCG5TnVQlGgz2vm02F63xe/TcnXkNnqHL17rYdLskS6GEWrQ
         oJmAtRS67fx/FzGOhC4N0pYTc0ApseO+6WNCsbsFhsMoYEVQ2R+D6+s4+Hd2aSMdFMG1
         74TA==
X-Gm-Message-State: AOAM531Ui8SjkMmLPGDmYXdhCXLe1SjkANtBf4LudvdsrqEcqLH+06KJ
        9iVpHs8gEmX3IYPv5vyAh9Y=
X-Google-Smtp-Source: ABdhPJxm6aEJ3GXnGHpJyHmSWQCk+EVqzPsb6T04MhlByWNXdV6XQIqLPQRNyoSQNdMLhrYOErK/9g==
X-Received: by 2002:a05:6402:51d0:: with SMTP id r16mr7201541edd.138.1624041030945;
        Fri, 18 Jun 2021 11:30:30 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/6] net: dsa: assert uniqueness of dsa,member properties
Date:   Fri, 18 Jun 2021 21:30:12 +0300
Message-Id: <20210618183017.3340769-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618183017.3340769-1-olteanv@gmail.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The cross-chip notifiers work by comparing each ds->index against the
info->sw_index value from the notifier. The ds->index is retrieved from
the device tree dsa,member property.

If a single tree cross-chip topology does not declare unique switch IDs,
this will result in hard-to-debug issues/voodoo effects such as the
cross-chip notifier for one switch port also matching the port with the
same number from another switch.

Check in dsa_switch_parse_member_of() whether the DSA switch tree
contains a DSA switch with the index we're preparing to add, before
actually adding it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b71e87909f0e..ba244fbd9646 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1259,6 +1259,13 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 	if (!ds->dst)
 		return -ENOMEM;
 
+	if (dsa_switch_find(ds->dst->index, ds->index)) {
+		dev_err(ds->dev,
+			"A DSA switch with index %d already exists in tree %d\n",
+			ds->index, ds->dst->index);
+		return -EEXIST;
+	}
+
 	return 0;
 }
 
-- 
2.25.1

