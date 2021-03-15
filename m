Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8778F33C852
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhCOVPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhCOVPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:09 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EB6C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:09 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id v9so59144870lfa.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=/fEDJ/+UtGgOsosVbiVuQs5SVczo3uICiP9N+8NI0Gk=;
        b=zVYKtfyvKhQdO0/DvbCRgRbHjdpR8Vcktyx0qjh6gzmaobdAnz3IPF9KuUo7jvkap7
         f6FgiuMpct/T2P6bgUQdRXpz9q90v/PR9v0EcGrY7pAZBAhIur0fYvIY6tocARHVm+C+
         rGeYvjaFcgrd7XbpUwZooNISrie9BjtyiJ8nAA/Y8S7RojZTQR8xA9UEp2+bl7IXT6c6
         6x+zo9NFYnKo5haou3UMV9Sj9Fzj/ECnAEogThfg011C9+KKaDkxQ0MFaGdsFHGG1cdk
         LQoRVAWIEqqMOxZ7kB/6aAty90apDUl1yoKRrw+V4E0xnsLiKROocSr6zSsEAiVk0YcT
         6eTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=/fEDJ/+UtGgOsosVbiVuQs5SVczo3uICiP9N+8NI0Gk=;
        b=Td2POlM08p3ZvLZSXNj/A5tn1k/D/79dv5WxUNkH2O3nyWvZMi70lSrPbr7YJgBNl9
         RjGet9D1BVBzs5JcT2ME5V5J8PyWHFF8l2IwdItFNWr7DehBmbGiY9ZNnrD9ENcF37Dj
         DPa8yvqrPGJFcTO9sc6USjd5KxQrPkFIVhaL40rjffZXV+KKSqCEFfWZNQV5QBx7bzBp
         dmd4mZ3170j7hL1RHe/NjwLk+U4wtrbbslRC8Sz818XbdjSCiOEF8iaw2PfeaaocEqMr
         R61Hy5rKjO9nDsy/aS3Yp4Q4xhv255S2OzwuH2N2oYUNycZDERGqes7SQB9yIjS69y48
         dsqg==
X-Gm-Message-State: AOAM531ccFU9HOHUtMulMVJ1ObUeLRJ2rWUyiE6pgnju35/cFJg8m555
        d2ZqE6d/S6GMYfdGDOPlcfnLT7h0NHuLU5ox
X-Google-Smtp-Source: ABdhPJzy28qmHZMc6p2lj5ENY4YdNuz20am3qJvaq5cSa5guD1EAuhqnTwhF9O1xwq1ZC0NEcV3pVw==
X-Received: by 2002:a05:6512:200a:: with SMTP id a10mr8636103lfb.564.1615842907893;
        Mon, 15 Mar 2021 14:15:07 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v11sm2975003ljp.63.2021.03.15.14.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:07 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
Date:   Mon, 15 Mar 2021 22:13:58 +0100
Message-Id: <20210315211400.2805330-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315211400.2805330-1-tobias@waldekranz.com>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In accordance with the comment in dsa_port_bridge_leave, standalone
ports shall be configured to flood all types of traffic. This change
aligns the mv88e6xxx driver with that policy.

Previously a standalone port would initially not egress any unknown
traffic, but after joining and then leaving a bridge, it would.

This does not matter that much since we only ever send FROM_CPUs on
standalone ports, but it seems prudent to make sure that the initial
values match those that are applied after a bridging/unbridging cycle.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 86027e98d83d..01e4ac32d1e5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2457,19 +2457,15 @@ static int mv88e6xxx_setup_message_port(struct mv88e6xxx_chip *chip, int port)
 
 static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 {
-	struct dsa_switch *ds = chip->ds;
-	bool flood;
 	int err;
 
-	/* Upstream ports flood frames with unknown unicast or multicast DA */
-	flood = dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port);
 	if (chip->info->ops->port_set_ucast_flood) {
-		err = chip->info->ops->port_set_ucast_flood(chip, port, flood);
+		err = chip->info->ops->port_set_ucast_flood(chip, port, true);
 		if (err)
 			return err;
 	}
 	if (chip->info->ops->port_set_mcast_flood) {
-		err = chip->info->ops->port_set_mcast_flood(chip, port, flood);
+		err = chip->info->ops->port_set_mcast_flood(chip, port, true);
 		if (err)
 			return err;
 	}
-- 
2.25.1

