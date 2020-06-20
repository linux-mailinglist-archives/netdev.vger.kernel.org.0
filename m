Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1D32024E3
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgFTPoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgFTPoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:00 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244E1C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dp18so13498020ejc.8
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lbBKZ+MVHZgFpAjQ9dtZ5xYkmij7ybYh4k6LxP6NLHg=;
        b=XITRqugwOp14OscdReXN/cMX26lJBc3BYgiMwTSODG+Fcoqs10QGHG9ivcZfqGbley
         O+zdL46zsq23ugJJeT6O51n7OJUEAb26H7MaorRim8e4xe6czLf6ovOgaNZlMu866PXr
         pdIjTtZ5S5uwZThqE92VvNmC/gqpKs2JEp6I26V6vKbGBGwrizNAn+RfLWfJlkTK10xk
         tTTH5oPGk3XMM7itHk9VZO+uiPS8vNn0T++G6+87k362z2lpPCjZ1z8rZvnflzP9/Pkk
         5crbRNMb4eQEGb4qrwsOEB2/GGAn0kaMNz0ncoVRQpYFxbQipPPdMX/NnqOM1/cVU9p9
         cWRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lbBKZ+MVHZgFpAjQ9dtZ5xYkmij7ybYh4k6LxP6NLHg=;
        b=Ap6cvoYozFqtfcs7kRcCP/QN4q0egJQImOECPRhAawMkiscqOPoBN3NMgiGGZyQUyS
         Gv59I0UliWT75tompYPmMVCeHpaq0WIgPXF+IckJGW9xvFuXpIlDAOTe+KOzZbKrgF/J
         W5GhYi5JdirdZ0MNgapb2XWv/NvYaikJZhf5kkmW1GTF98shIKg5jkck5UhDQDAxATUe
         dI8XRkCdljpYiyCUhBevBlZl7u5PV0+vmgJyKCloNMt0nfz+Y+sSU2E8/9jSY2MN0Kkt
         ybPvstwX1EMXZ1G90z7tA6BKLZOK8EpKHGCVQ30pbg3iqtze42rm2I36pTYtAFimtlqJ
         H1MA==
X-Gm-Message-State: AOAM533mWCdi0AMdyEuhmdiPcG1MB+b92KEtMTI72r+ghHfQN69svneN
        v8cRCxtyOf9EcSn2bVCupT8=
X-Google-Smtp-Source: ABdhPJxLV8ldi8+CQ99+uMnF2g5KdKgLBv3pzLCYp16c4bK/hzGA8nLNDgTnUthoKXBGxJtdwKbXaQ==
X-Received: by 2002:a17:906:241b:: with SMTP id z27mr8257028eja.267.1592667838072;
        Sat, 20 Jun 2020 08:43:58 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:43:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 03/12] net: mscc: ocelot: access EtherType using __be16
Date:   Sat, 20 Jun 2020 18:43:38 +0300
Message-Id: <20200620154347.3587114-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Get rid of sparse "cast to restricted __be16" warnings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 4 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 17b642e4d291..1dd881340067 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -746,8 +746,8 @@ static bool ocelot_ace_is_problematic_mac_etype(struct ocelot_ace_rule *ace)
 	if (ace->type != OCELOT_ACE_TYPE_ETYPE)
 		return false;
 
-	proto = ntohs(*(u16 *)ace->frame.etype.etype.value);
-	mask = ntohs(*(u16 *)ace->frame.etype.etype.mask);
+	proto = ntohs(*(__be16 *)ace->frame.etype.etype.value);
+	mask = ntohs(*(__be16 *)ace->frame.etype.etype.mask);
 
 	/* ETH_P_ALL match, so all protocols below are included */
 	if (mask == 0)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index c90bafbd651f..99338d27aec0 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -176,8 +176,8 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 		if (proto < ETH_P_802_3_MIN)
 			return -EOPNOTSUPP;
 		ace->type = OCELOT_ACE_TYPE_ETYPE;
-		*(u16 *)ace->frame.etype.etype.value = htons(proto);
-		*(u16 *)ace->frame.etype.etype.mask = 0xffff;
+		*(__be16 *)ace->frame.etype.etype.value = htons(proto);
+		*(__be16 *)ace->frame.etype.etype.mask = htons(0xffff);
 	}
 	/* else, a rule of type OCELOT_ACE_TYPE_ANY is implicitly added */
 
-- 
2.25.1

