Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965D21C47D4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgEDUSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgEDUSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:18:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423CFC061A0E;
        Mon,  4 May 2020 13:18:10 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a5so472970pjh.2;
        Mon, 04 May 2020 13:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mBLKfvK+TlfAtTHQanQgHlv1D1yJyX+Gon6/azPPNo=;
        b=HtluyzkauYfZ2YAflxShgODGBqt+/PvbOalG2B7lekeQhLAxFsSwXM9UZ6ceDkviR8
         5vYHZXTGMCox6TW/VyMGwLbllyjqdMSL2zSSsFeUIZqpQiJPU19eVKLuxoBYapg7vRRa
         w/piVVucZ7sFyQpNygR9p+I2Wn57eE/xgftCNrjnP+7XqZjMkkVVxRL+1hNcPdIq/73l
         gQi6qwEcuJsy5AGyKCA7HexJ4OHf7l/nITLtvpQpy2j1JHwgHTwS/3PVathcJ9rne7HH
         9kBlXcRYB72CodN6cMDrlM0Whg/D4TzFuQlrRYNGty+NtC6T5rhoZjSqlsArrWpLAlzN
         5FMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mBLKfvK+TlfAtTHQanQgHlv1D1yJyX+Gon6/azPPNo=;
        b=VSVLkzYcj1x9gjWREyiyPF7DccM07PcG1dNxUqk8rvxr4BRd5WMekUc4mOirWaSdjq
         oK7iiMjkEuXLldvIr1GnZxn8+Q79XF79tITWJ42Gh3e06xrWW4vXqF8AvAkqrPrWcTYq
         OLjBTF3DeCpiW1MMyc0hHUZOYL8fDKOuPf5nqjySSjcH+U2vkktfoCyYeeNuANBRX+zo
         Rz74/ZR7XALnJV3xqXQM8Ht3nW1M5v1zqIhy8914B8c5Mq6aecfAm4Q3BWLqZmEY14UL
         joW7YG1n0miaw7pXY/V3Qfa3uI40GcsaVMXy4wi0hKyMHDsPx0Uh/z029wmCj9MEoOfw
         4Uhw==
X-Gm-Message-State: AGi0PubdyRCuE4JvZIla6ZUqUQdV0R8Jr5rWInGPyaCJrdsBdECgll2j
        RTDwX8yovNA0Gma61hqrpBOUJAPU
X-Google-Smtp-Source: APiQypIK4xGAVkclsDi/LY8AGEJIUEpUUrLYBhKkTmUsgLESOTCpLUUVX3zkmZG0TiHPSZ0k0RDFpA==
X-Received: by 2002:a17:902:d883:: with SMTP id b3mr928358plz.133.1588623489319;
        Mon, 04 May 2020 13:18:09 -0700 (PDT)
Received: from bender.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e11sm2814627pgs.41.2020.05.04.13.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 13:18:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     allen.pais@oracle.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: Do not leave DSA master with NULL netdev_ops
Date:   Mon,  4 May 2020 13:18:06 -0700
Message-Id: <20200504201806.27192-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ndo_get_phys_port_name() for the CPU port was added we introduced
an early check for when the DSA master network device in
dsa_master_ndo_setup() already implements ndo_get_phys_port_name(). When
we perform the teardown operation in dsa_master_ndo_teardown() we would
not be checking that cpu_dp->orig_ndo_ops was successfully allocated and
non-NULL initialized.

With network device drivers such as virtio_net, this leads to a NPD as
soon as the DSA switch hanging off of it gets torn down because we are
now assigning the virtio_net device's netdev_ops a NULL pointer.

Fixes: da7b9e9b00d4 ("net: dsa: Add ndo_get_phys_port_name() for CPU port")
Reported-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index b5c535af63a3..a621367c6e8c 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -289,7 +289,8 @@ static void dsa_master_ndo_teardown(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 
-	dev->netdev_ops = cpu_dp->orig_ndo_ops;
+	if (cpu_dp->orig_ndo_ops)
+		dev->netdev_ops = cpu_dp->orig_ndo_ops;
 	cpu_dp->orig_ndo_ops = NULL;
 }
 
-- 
2.20.1

