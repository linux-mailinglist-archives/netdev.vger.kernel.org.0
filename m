Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574633AF13F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhFURFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhFURFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:05:12 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382EDC051C75
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nb6so29769927ejc.10
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ar8srF6RoxucIg9He9/E36VcEjkgKbzFguO1R6WKeOo=;
        b=peayvWjX4KWkJJxfAVXYdYknyjVdiB+aAJVSzovUVgNKUD7Lb7uGH/30RDLT4vnK55
         9lBdHx74MXPQSgIWwmPDRZQgnDVHcJNwn96UMRDrc6fDQJHhvAu2o7kGnXg+S786SxSX
         0UqhT22eOzLtZOslLS198z/p+UA0MhCPj2/VlX1naA0DVKdEq85uKDdzG2Y3X66nMkuE
         23jSoTqJOzw1fQZRhaxmpcKER4KdofPTa0S/E+ocNJrVUYPClQVfTtX7b4YRAstFUij+
         PS5XcBueDuuTPJ62KW2Vjuq6bu2h7CwKUJ4q3ZQ7d78BVGnJN3cWTND2YamwIX6eMUAE
         S7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ar8srF6RoxucIg9He9/E36VcEjkgKbzFguO1R6WKeOo=;
        b=GZFqTF+LJdILM3T6/DhkRQxvr0+9PtVEwjBTSJ1jNwIae+ck+5DF00GJ4fy+7+oCsH
         ZP9AWBrRyavAWejr6LL0i6r23Ci4e3PeDUyXIkJWqidYxd9CqGF54jL9OBY+VZ0+hJBA
         U+SbkDvMDsF3/wvrbdYDjeLtavV2xNEB77aB8hERzmb7gqtWijIpayPuyZHOXYOF1wKF
         rKV+jRV8q2QD6RpBrDopJHX53GW38FGEYfnDBORTuveqznlOY5op4Ib0fUzAZEB8g09M
         K6XJFuuEsg+XZpuPgemH3p+gEYo24MOJgZsQB1zzRUC85wa6fmBaDXUtlx3Kec2kIxn5
         4bDw==
X-Gm-Message-State: AOAM53169kmMWWS5z1/zGCMadtto6ZgNEQMeHgbnwS/o7o4m2ZzM5Wno
        QWEN3kw2yz5940T/e83BmhA=
X-Google-Smtp-Source: ABdhPJw989ZN4qylLpu1dIrX77rgqCvroIEJvXRwXE2qfw0wkC5LJKn99+XpViL34YCTy2LoC9A1+g==
X-Received: by 2002:a17:906:2b01:: with SMTP id a1mr12574813ejg.133.1624293754843;
        Mon, 21 Jun 2021 09:42:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c23sm10931093eds.57.2021.06.21.09.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:42:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 1/6] net: dsa: assert uniqueness of dsa,member properties
Date:   Mon, 21 Jun 2021 19:42:14 +0300
Message-Id: <20210621164219.3780244-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621164219.3780244-1-olteanv@gmail.com>
References: <20210621164219.3780244-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v1->v2: none

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

