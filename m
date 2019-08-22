Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CD69A0E6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392854AbfHVUNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:13:53 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43950 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390373AbfHVUNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:52 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so6280945qkd.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OQBQV+56l3dMpNr75FvhBT66cS1jMo+PnG0C5SOikqc=;
        b=nKuYRP2iiDAXLHHZhctL25SPEkD5vpQsCEh8B2pndWiahtIZXNYLXFtSeHKf1p4MN9
         2nfyCDlEkxySysfcpMLVjZSA495bmIJCLdoxUPr/81vkuz4ujHAZLFSLMlrTVUdRavPc
         1ajZyPXz3A5db6K6fYuHcekrQnGV3nyagyrdu6Q7TZ8dkBoWq1HwC1J3lk3Tlwctetb7
         PIlTZqjw5uRVasUl5kI+SI8U5dg8fQJo0WRS6u38B84B6cCbqJ+zOzDQmV/rsmM/Megu
         1ElLIf5tEFpsSF+9QA5x5YZpw191G1Ck8dTUJUnVyZ63jKv8DsOEjJjr8SZ482ZTGL/i
         vrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OQBQV+56l3dMpNr75FvhBT66cS1jMo+PnG0C5SOikqc=;
        b=th2bAyueDxJVThAq6PDAb+mZLy16QMd8g5pagwrYVDNquxqsr//kjEDb4GtIevXJQn
         sVlF8Q11AuYcQ5Lyo4+1HIpgfow+D8zbyxHq2xKEeIfVDtqqFS5oQ8GT7rIFFGV+A5C4
         6pEBprW+XrgeMHApk6n9z4azyrRuOAoG2kLZ3bzqYJrRyVmdRwiKcN0+MnA/nJI8D/cO
         YqB8DwV43Lo2fDgr0lSUi4frFpayMCmE9NGwP8sZukf6rNIAPalnV1D1AFzYlAG8IX8r
         hjeHy8EfmP6KO1/6h9VlYyLwndz9Zvy9nJ/YayRWd2lUje1jCJXsih64IDpL7F3U1MAX
         e4pw==
X-Gm-Message-State: APjAAAVlrNaXgNcbrt7dVhtFwq0NDJFMA9gXQNn0EeKxWEVHDzMi4y+L
        DC52vp4qSB+rqcGWu0lPIofH+L9L
X-Google-Smtp-Source: APXvYqzJ9PaozPPG+SLUzHbr3Xcdf2qaIZWIJt1xxK6dI2vI6WfZKYNRkbRldZ9mi5nYiyB2gmnKHA==
X-Received: by 2002:ae9:e707:: with SMTP id m7mr892913qka.50.1566504831012;
        Thu, 22 Aug 2019 13:13:51 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c23sm253556qtp.3.2019.08.22.13.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:50 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/6] net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
Date:   Thu, 22 Aug 2019 16:13:19 -0400
Message-Id: <20190822201323.1292-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822201323.1292-1-vivien.didelot@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dsa_port_vid_add returns 0 if the switch returns -EOPNOTSUPP.

This function is used in the tag_8021q.c code to offload the PVID of
ports, which would simply not work if .port_vlan_add is not supported
by the underlying switch.

Do not skip -EOPNOTSUPP in dsa_port_vid_add but only when necessary,
that is to say in dsa_slave_vlan_rx_add_vid.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/port.c  | 4 ++--
 net/dsa/slave.c | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index f75301456430..ef28df7ecbde 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -382,8 +382,8 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
 
 	trans.ph_prepare = true;
 	err = dsa_port_vlan_add(dp, &vlan, &trans);
-	if (err == -EOPNOTSUPP)
-		return 0;
+	if (err)
+		return err;
 
 	trans.ph_prepare = false;
 	return dsa_port_vlan_add(dp, &vlan, &trans);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33f41178afcc..9d61d9dbf001 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1082,8 +1082,11 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	/* This API only allows programming tagged, non-PVID VIDs */
-	return dsa_port_vid_add(dp, vid, 0);
+	ret = dsa_port_vid_add(dp, vid, 0);
+	if (ret && ret != -EOPNOTSUPP)
+		return ret;
+
+	return 0;
 }
 
 static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
-- 
2.23.0

