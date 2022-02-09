Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9984AF250
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiBINGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiBINGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:06:10 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE2BC05CB97;
        Wed,  9 Feb 2022 05:06:13 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o2so4102148lfd.1;
        Wed, 09 Feb 2022 05:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=xsR/hKbVC0DUFloHcPTPuu9npcAFNkMVex8QVbhOYjs=;
        b=aj5Htxtjt1QnCulCfzu1eLyveHrhHah6dMQEHuzB3QTTYShvpcRAjZ5pfxCGk762qQ
         6BFw3eAADUmyqfZmB9V4jt23udaEyQK7EIVxNG9+FpfuXQDvXqpG8/O5kS13UiE2pXOj
         437f9KJulPeEz0tpSD51qy++kHowekZNWZrx7tiLHrpi4+NYHgOTG//YhDgd6U66f2Pz
         c5hoPpXA/21eoyFtrKLJMXJaYVaU2BLR2E4MoYM2g8/ffSc2HO00JOB4wlpY0lwbCpz6
         TNWPzGdJ99ZavA4XvY/6aMxWBiD5qnAzBPAs9UM/psV1+fqPOAuo2N22BrJNCl1Z2BSW
         7mww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=xsR/hKbVC0DUFloHcPTPuu9npcAFNkMVex8QVbhOYjs=;
        b=mVfXr8k8MJxXXyI56fnsyiqH8+AnQoyN0DjW8hlPVmGzSTr1sSguYAPjbHea74sZeY
         4yuW0M8bl2+bhiF6LOVH+mtnElgrWhareOKmJvmzbalDfSB621tmbmaVqomSaPGkvauR
         AZslPj2rYpjbgLYg0eS/6cr3DdF5ducfM8n1RXi76EaS803odbtmYteZoRk1okRN4rlk
         eMaxVncSCR+GugGpbeOy3uIWR3Y9yhlk9JIsZ2Wgu/UTs7Plj+9Nlg6wEsoZoDrFOrpF
         6E+cDLSspvQfcQvgvegcMDhMp/bD74DFNW+ShSdL7D6hK2m4sMqQsYF1HeDi+Nczczo9
         R/cw==
X-Gm-Message-State: AOAM5303pmA7s7x9TqdKIkZ68QVMwO+xDc2TCFSsuKEMRGzn00KoR+6a
        3b+HKqkAaXpw7KekuzlJqfM=
X-Google-Smtp-Source: ABdhPJwc0CV74l66f2wraJk089tfQr+62hoxcpiYKudUS/YHO6pQn91PajQKct90SKtB1DhVFlnXKA==
X-Received: by 2002:a19:9219:: with SMTP id u25mr1547578lfd.685.1644411971858;
        Wed, 09 Feb 2022 05:06:11 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k3sm2352608lfo.127.2022.02.09.05.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 05:06:11 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net: dsa: Add support for offloaded locked port flag
Date:   Wed,  9 Feb 2022 14:05:35 +0100
Message-Id: <20220209130538.533699-4-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Among the switchcores that support this feature is the Marvell
mv88e6xxx family.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 net/dsa/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..01ed22ed74a1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -176,7 +176,7 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 					 struct netlink_ext_ack *extack)
 {
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
 	int flag, err;
 
@@ -200,7 +200,7 @@ static void dsa_port_clear_brport_flags(struct dsa_port *dp)
 {
 	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
 	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
-				   BR_BCAST_FLOOD;
+				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
 	int flag, err;
 
 	for_each_set_bit(flag, &mask, 32) {
-- 
2.30.2

