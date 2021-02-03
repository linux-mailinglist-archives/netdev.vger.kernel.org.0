Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EC230E36A
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhBCTkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhBCTkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 14:40:08 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE05C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 11:39:27 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id w1so912676ejf.11
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 11:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d2hM7tfBFJxLwZrun5kz32bu7mL9u5x+3fila9t7zbc=;
        b=m4FFXK6BCRTSgnYworNIDnZ8Y+UnavgI1jqJIfZkYTVrucHgY2I8eCqjQpcUM2j4xx
         YvH5uoGRLgzJDz1VfyOJvWXG3FDmqv3gSLgv6zja7/iIzhelzgk9NU19gckhrpSr3M6y
         OGlXZjCcOt/EdabJzWL3kFCP+BDdLWOV4y/bQ0Xp0uBCjnSb5AnCgKikfvta2ywlL2uz
         rvyJ99RGFNDHgNrfKN5NU9hgGaEkBTc/e5NTlrL0V4pX/m/ZGM9RAUkfIpeC1weptrbd
         mOJ2yYxKmZ0LfJzGQTKcEnrgTtB29xUb09VMGp7G7hB/U5UNQZ8LFZT+pEIqBUTb6BtX
         Yevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d2hM7tfBFJxLwZrun5kz32bu7mL9u5x+3fila9t7zbc=;
        b=Y1tbwtOe3ABweR6lxXGT9gcqDXypuGzcCNNYVv/kqnfNPiaJL0650ABKKe1lpXF/RV
         uZklCjDXRKk32v+KN5KxSAAj+etvddhdeRajKqJURlnfb7aQqBgDRRT/iXzwiZkENikk
         EmUtudSOE4z+BZbg/Asa216qarMPNRX3tcE2a55CMwc2pKOC81Cf6t2gE/Sw5ySNiz6V
         mQXfUri0OaBJPVdr1rvQ7KefCyYq7DK84s1wEcJVNXuGb0z6ardfVOUEIMP9ZywE1KUk
         +wB4jD0hJjolzDPXbk/jqlwoXUrBmKMGXf+QQ4CIQ8F4RVBctF9XMiVAt9QubLErcNbR
         4MoQ==
X-Gm-Message-State: AOAM531C7tCI5d4g58afNrhKxKZeWg4Sq0nVQ5neCxcLTlbHRTl/qEMh
        tkuD5Kl8peEBx8rDsJH1ues=
X-Google-Smtp-Source: ABdhPJzQXE1uzzcJGL/oRPtPVw9IQE1R+esmhS+oCd44e8CuM/2shZT2aFMG05YzuWT6oE3ArXk8Eg==
X-Received: by 2002:a17:906:4707:: with SMTP id y7mr4714756ejq.445.1612381166068;
        Wed, 03 Feb 2021 11:39:26 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t9sm1386478ejc.51.2021.02.03.11.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 11:39:25 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH RESEND net-next] net: dsa: bcm_sf2: Check egress tagging of CFP rule with proper accessor
Date:   Wed,  3 Feb 2021 21:39:18 +0200
Message-Id: <20210203193918.2236994-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow steering struct ethtool_flow_ext::data field is __be32, so when
the CFP code needs to check the VLAN egress tagging attribute in bit 0,
it does this in CPU native endianness. So logically, the endianness
conversion is set up the other way around, although in practice the same
result is produced.

Gets rid of build warning:

warning: cast from restricted __be32
warning: incorrect type in argument 1 (different base types)
   expected unsigned int [usertype] val
   got restricted __be32
warning: cast from restricted __be32
warning: cast from restricted __be32
warning: cast from restricted __be32
warning: cast from restricted __be32
warning: restricted __be32 degrades to integer

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index ed45d16250e1..178218cf73a3 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -886,7 +886,7 @@ static int bcm_sf2_cfp_rule_insert(struct dsa_switch *ds, int port,
 
 		vid = be16_to_cpu(fs->h_ext.vlan_tci) & VLAN_VID_MASK;
 		vlan.vid = vid;
-		if (cpu_to_be32(fs->h_ext.data[1]) & 1)
+		if (be32_to_cpu(fs->h_ext.data[1]) & 1)
 			vlan.flags = BRIDGE_VLAN_INFO_UNTAGGED;
 		else
 			vlan.flags = 0;
-- 
2.25.1

