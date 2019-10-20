Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED10DDC02
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfJTDUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:24 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43051 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfJTDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id t20so15223061qtr.10;
        Sat, 19 Oct 2019 20:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DiYXjj+rdzvH3hyjdoa4vh5vwNi7WALd3XOKliIHKPs=;
        b=tRxlI4u+B+ce24ynEdYm96Tq+1+uBH33HQVCvNlQI6nLlG76ooEBY3YdsbHx3F9QyT
         VFzm/T1H88s7uZafS4vsxM+sZ+4kgVGq7v5yDX4BbfefePA/ZDfyEe0LwrFW9B0zsuGw
         RwofGehWEiDTHrEwnyJeaIrHeiJl/TPmpq4kbTQKsZaWRwCbDqtfExJV00ACHjoYO/kL
         aq6G1k56Sz0GBdBXj+f90W5QLZTRN2nwHkQHiholkIjFTxv11kax2i9RmlsaAZ2IUmvF
         A29Dl+e2/HwtnNpMoMhXy1w28YJ1mi85CmKsX1D0i/J7X9XhnSQL4DcMOH8o9YNh9tS+
         +mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DiYXjj+rdzvH3hyjdoa4vh5vwNi7WALd3XOKliIHKPs=;
        b=tZnVWGjtcTRaHC7tG4Wbyiut8f+/ook5KuuU9kf07fX4CkMznJHSJYJcj+Gxa86lGS
         Pq0xlt7r1Mdeu+XqhLjyLHdKbOf7irak9uqDLdSHghv+uNmPYT5s6RN7H/vT6W1OMjtb
         Yz0l5LlSk4O96XlAqQEeu6zqk/sOPiYErZM5mhS3NANzoCCzsNI8XbZeVN9kTUkOxc5F
         TQ/kN+IFqwHpBf8zVe6b1p8Ksf5pXE7DFAEd5gRiU3+Yu7foBkz4FJynoYjbj/aphJNo
         GRZDSat2yEEPA/Tvo00bDHOF9urBrmf8lYqPJChx12dlt/uXSGwHB3rcdtPsClYZrfKi
         iX9g==
X-Gm-Message-State: APjAAAXJrSBKKBLxEHLi+UMUIEQ11X0q+uEgbCQ1i8zOi9cBtFG0aqfi
        llj0yfTKGsgNvom71F7NAac=
X-Google-Smtp-Source: APXvYqyCm762Y8lBHpw1GT6GZ1jqyZvWqMgsKljgaLsOnX0a+6gk5F22Dm1MEV+tzylPhMvIwsIOzg==
X-Received: by 2002:a0c:8964:: with SMTP id 33mr17992633qvq.241.1571541615655;
        Sat, 19 Oct 2019 20:20:15 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q25sm4903902qtr.25.2019.10.19.20.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:15 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 06/16] net: dsa: use ports list for routing table setup
Date:   Sat, 19 Oct 2019 23:19:31 -0400
Message-Id: <20191020031941.3805884-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of accessing the dsa_switch array
of ports when iterating over DSA ports of a switch to set up the
routing table.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index fd2b7f157f97..84afeaeef141 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -157,6 +157,7 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 
 static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 {
+	struct dsa_switch_tree *dst = ds->dst;
 	bool complete = true;
 	struct dsa_port *dp;
 	int i;
@@ -164,10 +165,8 @@ static bool dsa_switch_setup_routing_table(struct dsa_switch *ds)
 	for (i = 0; i < DSA_MAX_SWITCHES; i++)
 		ds->rtable[i] = DSA_RTABLE_NONE;
 
-	for (i = 0; i < ds->num_ports; i++) {
-		dp = &ds->ports[i];
-
-		if (dsa_port_is_dsa(dp)) {
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->ds == ds && dsa_port_is_dsa(dp)) {
 			complete = dsa_port_setup_routing_table(dp);
 			if (!complete)
 				break;
-- 
2.23.0

