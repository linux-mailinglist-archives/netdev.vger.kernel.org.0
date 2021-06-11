Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896173A4924
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhFKTFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:05:06 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:33789 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhFKTFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:05:03 -0400
Received: by mail-ed1-f51.google.com with SMTP id f5so33263007eds.0
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f70SAejO+Q4VbHsqvG9aO26yfEE3LyWRNlJZYPpxB/Q=;
        b=F9XBBtLbdY35GvicfU+Gwt85ee7SRZm6TkhSe9oMPqOBFG04Wt9SUKOJYXjyrwO5NT
         lzfqc2gxzNNJmL5GD1W2hdFVw0waZok8X+i+he0oxCUVyS4dTsrMRJoGkXZiuD6qWUG6
         Yh1tfCE/3iNZ74IJ+aqkT7xVUA1hRbsmlgrHJOTze00/o/KmLMXDdfpkLE7vQZMRD52t
         he48Nt/uYK75tu2edAMeCcXrnyF57d3zGPcsIQ8Scx1DoKcEUzk+q0wsG+XFi+HiIkpB
         tqCrxccvaPEkPFExVogla4o+IaPn0VzAzD87iMwTGkEKKbhX3i7jIkcnCt+V5Xrf/tHx
         bULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f70SAejO+Q4VbHsqvG9aO26yfEE3LyWRNlJZYPpxB/Q=;
        b=IzSPvm+24ILQEmaBSHKnDMfXZpKmZpTJXpW9RCnqv0VIQT/rpvMHY4KtKpTM2dFjuZ
         MKhYIqF7Kp7kNvNbMQ1U15wwe2PhgMdf1mVBhzOhWu2KXH6DDSB6Un8F2ta6ZX8787Ji
         5+dEGK6B3NAF3mhYuoJgOORBMQ6efwy/BDjf7h4O2+pyFoSYGrBkJQCK+nrmk/gCKkns
         2iUEZzbHi0FT/O76lzUmfw1qwRQt3/r9I2J2eSXxa1s7rE/QCNgrEhoFNIb1xfjBG+hI
         QoVdi8Q120JckP+yy1FTh63MqVdAookFiw3YrcjiXDZtWvOsBtugSJJD4zM1KJ3W9zC1
         sTZg==
X-Gm-Message-State: AOAM533aqDCkOjxXcV8MUcIwoYiq/I9XK0qCxVvFUsG2TmKnaQYj6t3G
        DcoBOB0NwP0o/Ot08CP/Yuc=
X-Google-Smtp-Source: ABdhPJwcUtQHbog8gOPOSopbpFUpzlH72u4dg3j20z3l3EHQpzqb6YejXBB/71IfK7cYB8Oki5vZhg==
X-Received: by 2002:a05:6402:144d:: with SMTP id d13mr5050037edx.288.1623438107783;
        Fri, 11 Jun 2021 12:01:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 04/10] net: dsa: tag_sja1105: stop resetting network and transport headers
Date:   Fri, 11 Jun 2021 22:01:25 +0300
Message-Id: <20210611190131.2362911-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This makes no sense and is not needed, it is probably a debugging
leftover.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 net/dsa/tag_sja1105.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index ff4a81eae16f..92e147293acf 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -307,8 +307,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 			__skb_vlan_pop(skb, &tci);
 		}
 		skb_pull_rcsum(skb, ETH_HLEN);
-		skb_reset_network_header(skb);
-		skb_reset_transport_header(skb);
 
 		vid = tci & VLAN_VID_MASK;
 		source_port = dsa_8021q_rx_source_port(vid);
-- 
2.25.1

