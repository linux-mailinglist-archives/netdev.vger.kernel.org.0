Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F4949D6AA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbiA0A0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiA0A0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:26:11 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799BBC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:26:11 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id g7-20020a25bdc7000000b00611c616bc76so2719410ybk.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RPPVNhQtLRSFAOqZpI7MCesPlTv2uvcy8KE2u/QIKE4=;
        b=Y0g01LKGZ4phwalUn33bJL/UeLBP4MpppalAS0Ztn+q4i0qpvF/2XHY15DwSGCSat+
         yney7WzbsKNzM+sbPC8AyrivBnMHv/F6XOzQoxAkBlQiXtwxnOnYH2UeGJYYInpMcnjL
         utDGDu2ZqFmcKixlvDU1nj+U1y45g9hxL1vxEDdz/MficXO8aRM1enZDh+v7MZudRkOu
         fATcsmrSHQcs1vsEMU6Y2FBwIMlit+80b/DE6hAXLf0w0DLG7O4pvMvLeCQCJ+BoewhW
         tyC/qemJC85f5+pJZDj3AzOcesxSQASTXGW9Oo0JWpP8tt65GoyDnmw0HJgR07H0FgcB
         P1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RPPVNhQtLRSFAOqZpI7MCesPlTv2uvcy8KE2u/QIKE4=;
        b=eZJcCx33HqPmptzTlMbwCuu1d5N9rhc1Jj7KwdBKTveP9hSpZ/mcEYYfnyv3+BljWo
         xRqdhzuj6AmVPZKbywvF8WjAXEbEpFcEUDmoYBKpejNae7MMNL5WHgUZ37z7cTDJCPa1
         BJq23LZ4kkIwkzGG2OaELF/ylkLKlJzAgKfT/Zn59RSVs+4x78CCtFdS2Gk3o7hxC7dB
         gp/BJCbesC6zmvdmE8Mt+R6LBmG8HFVr7j42Hi8fDkAeNAHIGXqwUAdiNFKDZdUqTCqG
         fpdtmjzWcRHOkmKm8wbFAutAGJVGK8g3oDFYmpbqfGNtOe+nk+Kx466TJIsPkn6WuIdE
         0gjg==
X-Gm-Message-State: AOAM530pTTrlqieDzPHvsAG9Z/aFyMox3K5VmHKD5lG4WwjWYpDz5nbu
        VWpKhg22+SWYPDTJ5nTE9+wwz/jpTkR/wm8OddjXUM4nVcs2+VMwmPO0CTXLwb0VVYyiqRnYPUk
        vT4K10DJMM5H62pECP3ID63DCv+CVQcQdIjngNQeAPMdBNXlZjJG88OiotpX7mbZD
X-Google-Smtp-Source: ABdhPJzulG7VHtZw9EAlNOSd/WQjKy/AB+JEMMMajpjosPdHZjOZa7JP6/exULwjjXTn2zgpNdBHDmOVnGWk
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:1f33:2e3:631:77d6])
 (user=maheshb job=sendgmr) by 2002:a25:d4c9:: with SMTP id
 m192mr2062130ybf.526.1643243170546; Wed, 26 Jan 2022 16:26:10 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:26:05 -0800
Message-Id: <20220127002605.4049593-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH next] bonding: pair enable_port with slave_arr_updates
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

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/bonding/bond_3ad.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6006c2e8fa2b..f20bbc18a03f 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1024,6 +1024,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 
 					__enable_port(port);
 				}
+				/* Slave array needs update */
+				*update_slave_arr = true;
 			}
 			break;
 		default:
@@ -1779,6 +1781,8 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			/* Slave array needs update. */
+			*update_slave_arr = true;
 		}
 	}
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

