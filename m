Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACE63AD22A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235071AbhFRScv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbhFRScp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:32:45 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B794C061767
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:33 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b11so9872921edy.4
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G+4b27f3cSkwtnDT4Xx164bd7wjuZ3sF4a5CqFmM2cs=;
        b=nuA8WJLNcVhq2V3LxAC0TUZfP9TIwXVJKzt1YKB/xktOxsubrnCt5lMnIvU2eTnx58
         ZUdLXb8ACXLvKITzao8GXhNNb/WwTsKhaoDO2sbb6Rd8FjTjeNB2xJsxAX+erMLe0AOu
         0alzta6zuFREqcO3vwYnAv8siVPBVmEx6L8mwRqueqWoCEJnL58Ly8AmZreaP8Por4cK
         LerOU3RrzJEGpZZCsoR65NRsS+y/spcaNw8h0HPU/99KE7VSUntEKH349sgTCFhXjIy1
         om/XxhnEqNIx5/USeeF/sO05sztZweaSImkSdV+UxlnUpiPBu3QOlyc2crdM9sxNqVLU
         +fkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G+4b27f3cSkwtnDT4Xx164bd7wjuZ3sF4a5CqFmM2cs=;
        b=MHI+UaYRx4JanwlmZEEH4mtxCv5UegAmjBr2Sy6SdsTEF6e5jaHQo6Gvr6oOM4XMiZ
         5MuiK0JAb36KZONfeO/gSIQK19la1L8T+6KunLKbhC/ujtmYUKpoOP1cRkQXUUfMK3ec
         tvHruu2UfrtiySL1xrqP02KbhVyFd8oxwtCHjttWlUnVSqVTZhL9pf2tB7JZad3twKUQ
         91jUYjz0Xc5lXJT7y0wni+UImyk51dD5jOGiPX/7Pw4NNTj6qN/xjYZn4wO45KiRDPtD
         +IDqSa/BpXsND2iw1bvZ9ISQtnRMoH6HBhzyP2gEN+ETvTVj284Cu+WXkXthf2XROHmw
         GK2g==
X-Gm-Message-State: AOAM532+Esr9qwB2t4Q+CRBSdoclnu9X0v15l9sTP65sxlljEBFfWQXM
        Ge0agr1K0QFiEG/xYja+5LI=
X-Google-Smtp-Source: ABdhPJxq35+Am/KfDv+G78KklB5bWFaHe2fHlB38Nx2Ik4soV9YidiH76geaElQERh5ooWsU+wrWGw==
X-Received: by 2002:a05:6402:3594:: with SMTP id y20mr7032670edc.299.1624041031954;
        Fri, 18 Jun 2021 11:30:31 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s11sm6071988edd.65.2021.06.18.11.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 11:30:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/6] net: dsa: export the dsa_port_is_{user,cpu,dsa} helpers
Date:   Fri, 18 Jun 2021 21:30:13 +0300
Message-Id: <20210618183017.3340769-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210618183017.3340769-1-olteanv@gmail.com>
References: <20210618183017.3340769-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The difference between dsa_is_user_port and dsa_port_is_user is that the
former needs to look up the list of ports of the DSA switch tree in
order to find the struct dsa_port, while the latter directly receives it
as an argument.

dsa_is_user_port is already in widespread use and has its place, so
there isn't any chance of converting all callers to a single form.
But being able to do:
	dsa_port_is_user(dp)
instead of
	dsa_is_user_port(dp->ds, dp->index)

is much more efficient too, especially when the "dp" comes from an
iterator over the DSA switch tree - this reduces the complexity from
quadratic to linear.

Move these helpers from dsa2.c to include/net/dsa.h so that others can
use them too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 15 +++++++++++++++
 net/dsa/dsa2.c    | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 289d68e82da0..ea47783d5695 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -409,6 +409,21 @@ static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 	return NULL;
 }
 
+static inline bool dsa_port_is_dsa(struct dsa_port *port)
+{
+	return port->type == DSA_PORT_TYPE_DSA;
+}
+
+static inline bool dsa_port_is_cpu(struct dsa_port *port)
+{
+	return port->type == DSA_PORT_TYPE_CPU;
+}
+
+static inline bool dsa_port_is_user(struct dsa_port *dp)
+{
+	return dp->type == DSA_PORT_TYPE_USER;
+}
+
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
 {
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_UNUSED;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ba244fbd9646..9000a8c84baf 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -219,21 +219,6 @@ static void dsa_tree_put(struct dsa_switch_tree *dst)
 		kref_put(&dst->refcount, dsa_tree_release);
 }
 
-static bool dsa_port_is_dsa(struct dsa_port *port)
-{
-	return port->type == DSA_PORT_TYPE_DSA;
-}
-
-static bool dsa_port_is_cpu(struct dsa_port *port)
-{
-	return port->type == DSA_PORT_TYPE_CPU;
-}
-
-static bool dsa_port_is_user(struct dsa_port *dp)
-{
-	return dp->type == DSA_PORT_TYPE_USER;
-}
-
 static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
 						   struct device_node *dn)
 {
-- 
2.25.1

