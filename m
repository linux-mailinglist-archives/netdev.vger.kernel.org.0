Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C684A2C0E
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 06:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238920AbiA2F6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 00:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbiA2F6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 00:58:22 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3924AC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 21:58:21 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id n198-20020a2540cf000000b00614c2ee23b7so16625274yba.9
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 21:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OH2UJLHBmix7P6Lxls+8L2QjljD4+AgEDIvX54uxAqs=;
        b=mjpJ/cvwOOqb/Lnw8nLIEMxtRUa3ZvPR59eG07Sc6HWZ/hDcE3zPAERZkSoYxO3o0e
         VP4XHXTDR0JTykLB8NQFOZVR0UTktdO3E4TUIeQEUcTDBFN0V8bz30q9HHGwQkOGvC0Q
         jd9QV+masPCfNdxNeXmXb0SLtMDQK0h7lHFvnGW1GrF6APlL7MS4paIlVQ64ru6fWMn0
         UYBLaQvIYJL6iadoUGu5vGuARDBDFxM/JJrA+NpPRDDRcVx9tcrXtUU1kzj67FhMzqE7
         llBj1vTyBwd1u4DCPlbeZf6IqIZCRjXtg78Z29ETB069JyDrr7NNZdbjiT+7rKt1GBz4
         mTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OH2UJLHBmix7P6Lxls+8L2QjljD4+AgEDIvX54uxAqs=;
        b=INlzJhVcE/Aucf5JbGtF4K5okGFRDDRF9dVCQdhqgwW2qUeuMYX47A/WDVdkVk1vlV
         BXTcrO8msVBXWSvcnLBvGH2LUDPbT2Iq8BGhNsxHf5re5I5U4ps0yPneaEE7oKfFy9PH
         un8t5F82bhnGRaYq4RoNR0DVCvLyH/bV8ZV51nkywV/f8N3+7us67Wg+FHePotOAZh5V
         GanMjnrvsv9+qgzC7YrYvdXj7uCr9NepWp4h8upOD0ZBN1EVKxndOeO2dA3kIrKiGgLp
         BVfXk9yhmfeF4hGFfHdMtWJH0uWjJJMGRkeez8gxdUCva1N0g5S9TpPZVDFKq4YIERhx
         rsVw==
X-Gm-Message-State: AOAM532rsY2bdTHIO1TT3Y6go+zCbZBj79ggfJNqOJb8eqCPYWqwEFy0
        1TlEb1rFMWMWYPpO227k4L2isJf4ysXgemHv1B3d6MdnlUqfPCcTY741rOz9bkldDfEGMr9AmAw
        gzNqb7QsAGl2qBzCQQ6oPI8oS8OwGJdUv7FTBTe+mwOWR/aiVWun3iUj6rp8tIOwQ
X-Google-Smtp-Source: ABdhPJxjuGkc9nOjWTIoEzrwhJPQ8EI9TtZEYNrD2UeJeDXCISYdhaxwT7ATZ6NV4BrTtnw8oAlcwIEG8Fph
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:bdf1:aadb:57a:fc76])
 (user=maheshb job=sendgmr) by 2002:a25:1845:: with SMTP id
 66mr4239230yby.196.1643435900317; Fri, 28 Jan 2022 21:58:20 -0800 (PST)
Date:   Fri, 28 Jan 2022 21:58:15 -0800
Message-Id: <20220129055815.694469-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH v2 net-next] bonding: pair enable_port with slave_arr_updates
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 803.2ad mode enables a participating port, it should update
the slave-array. I have observed that the member links are participating
and are part of the active aggregator while the traffic is egressing via
only one member link (in a case where two links are participating). Via
krpobes I discovered that that slave-arr has only one link added while
the other participating link wasn't part of the slave-arr.

I couldn't see what caused that situation but the simple code-walk
through provided me hints that the enable_port wasn't always associated
with the slave-array update.

Change-Id: I6c9ed91b027d53580734f1198579e71deee60bbf
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/bonding/bond_3ad.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6006c2e8fa2b..4d876bfa0c00 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1021,8 +1021,9 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				if (port->aggregator &&
 				    port->aggregator->is_active &&
 				    !__port_is_enabled(port)) {
-
 					__enable_port(port);
+					/* Slave array needs update */
+					*update_slave_arr = true;
 				}
 			}
 			break;
@@ -1779,6 +1780,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			/* Slave array needs update. */
+			*update_slave_arr = true;
 		}
 	}
 
-- 
2.35.0.rc2.247.g8bbb082509-goog

