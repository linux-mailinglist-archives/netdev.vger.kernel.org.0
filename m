Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936363A3238
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFJRiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:38:14 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:33389 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbhFJRiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:38:09 -0400
Received: by mail-ed1-f53.google.com with SMTP id f5so28995074eds.0
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bq2sTXppE3vWWf+YO0inT3m8fFWkaJHkeJaZb/ltFJc=;
        b=EqVeHkawKUlQeK3u4vmA8e1+lJE7dOGJmYaDuthmtkXF94DkRt2XkAFHVRnYunzm2j
         mFdAG3z5LLZj5d4Ai1OgTojuLDNHWwruVg59pszGyFIfZuA6ApOBwvgZOatgv4370qmt
         OHDq575GlDZH2AwDzeZw/N09I4WftffygPWNt9+HaI/fKHJHpwFNrKp2CtbvqrvTZq7O
         w1JmWvJ/y8kmzqMkeg46qoqbB8wifUrnlom1ANoOZLMlIjo/n1X3ALN1KJQ3NEOJ4REz
         7vXaIXEX4Xe89Hqg/armPaQ99fNXdlhqzSKstMZGpTf0IpJe79Kfcorpb5eDAf5bRvHh
         20rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bq2sTXppE3vWWf+YO0inT3m8fFWkaJHkeJaZb/ltFJc=;
        b=ctWWq4L1ttnfSFmf7o//qjLn4FZFcmcicEtW/Tf8/wmLvPyA6FGMW3gmcRyf2zysVL
         SHyRsYNr/FB8hZI4VHP4mkfgolJQbk6MjD3t+AezXU5Tr3H/SqrobDlJ2ymo6cNeY6wf
         M/qG/UEzYhcKsAl5fr5yQkvdRNEeafnBzjsKaVilKpC/XV9KXXGbqz1tpWsdSN6iXyyh
         vlqOXbgNkl9nnisG00CzBB6kf5ysf/2jrDE26oJHBuNx/Z7go4+ApUiE58V20WKHpd+Z
         5xVbZgCNxQV42DA81jirVOwVZ0tgcQs0ChjuaAhBOec7wE77mef/FneXEbymoeK4sb6y
         W+nA==
X-Gm-Message-State: AOAM532U0kavrneFnBPv/9C/gWBBEmYbpnb1ADN5CaDxguEfHmRcskWJ
        T7J6eRmtPCn1XjPVjdzXz2k=
X-Google-Smtp-Source: ABdhPJzqcru3GYNLjrBEGKeuvOvSahTcaipxK9+1uaj1tUHCvYm1a+wLwl5GJTF+k1OkgU14FY2Vgw==
X-Received: by 2002:a50:a446:: with SMTP id v6mr634018edb.254.1623346502349;
        Thu, 10 Jun 2021 10:35:02 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:35:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 04/10] net: dsa: tag_sja1105: stop resetting network and transport headers
Date:   Thu, 10 Jun 2021 20:34:19 +0300
Message-Id: <20210610173425.1791379-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
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

