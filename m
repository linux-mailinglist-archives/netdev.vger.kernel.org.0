Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7549A3A37DD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhFJXaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:30:03 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:43614 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhFJXaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:30:00 -0400
Received: by mail-ej1-f47.google.com with SMTP id ci15so1629535ejc.10
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EpbB6OLrl+ZgCUGKVWY3Eyosu/ePuZHBYeJiFQNBWMg=;
        b=gB5tq6IJxrE+DCi3pOhDOYVe+7S7aHtZdU4liKj2azYoiNGzKDvIthJ8SY+FKpXqtU
         IgkpNaNPoq1gDldbRtAff3UyEVUR1x7ZzhhxTrgPvgtymbdbJeJ269Paj9SSKfc0p0sw
         3tuaLdoIpIyT4uCfItAA/t1tvYNYO2yf3Gfit0NoKZaIBaqMtuj6Gn44L2xxIq7EPH19
         TLMJzDxe0iybXT2RDsvW6v+5ixwDl6KL2rdWofMsTrSrsZzzeMnuTvpWUWE05Kuh5gWA
         qsCUvJe0Abr+XXK1GeFmbZB4hSY0mhbPPuGrGiTYAO68xiwHp30H5hVX40YRl0NKNUxl
         g0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EpbB6OLrl+ZgCUGKVWY3Eyosu/ePuZHBYeJiFQNBWMg=;
        b=Y4et1WuWfKK+byz8ziOkYgtumItX8aohoVbos6X55X2fwGPBpJGgCYFWWNUYsPkCyn
         LC663thfy/JcdWuOCiWGQumjg2wBgZBzqvfipRMKNNWKS94q00usDS/ugc1eZGBM6PSS
         oSOjdkVAxns4KTp3gxuqnoemM4RVif7vqrg46YHfKWOJEqG4DoozPlCuUYRvC0WGa3kR
         gAeMP0T+78CZAD9zZLlEf1v6UqapM6MYuN7iP71O8TbkfuhoDvL1+GxB2SG+3P57N5IP
         HYDiI1ypbbUWlrsn7vTfh2drSj6jpfCBySAa4PavAZGNQccVMuaxIR04jra2TvEjsx8M
         32cQ==
X-Gm-Message-State: AOAM531cGEe+QUzCvxdDHDEwNAquqpnZw/DrqhXujrFzA1HFJnoSX69x
        b2211HZSkxOLILTUeiJ65+E=
X-Google-Smtp-Source: ABdhPJw5f6fX2FFasGwIOqBckWS8Hw4uL8QakWVTIjbPuMx7nZK4jB4KnqNqlmqSNq1QI231KHyKMw==
X-Received: by 2002:a17:906:a850:: with SMTP id dx16mr769719ejb.333.1623367606756;
        Thu, 10 Jun 2021 16:26:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 04/10] net: dsa: tag_sja1105: stop resetting network and transport headers
Date:   Fri, 11 Jun 2021 02:26:23 +0300
Message-Id: <20210610232629.1948053-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
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

