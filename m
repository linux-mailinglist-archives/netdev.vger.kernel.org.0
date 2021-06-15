Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6113A881E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhFORx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbhFORx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 13:53:26 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEE4C061574;
        Tue, 15 Jun 2021 10:51:20 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so9684810oti.2;
        Tue, 15 Jun 2021 10:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JjUN7QIyrElerNYioXdpATYpC1N6H4aJXPGt5T0SivQ=;
        b=Y1HMknLPxmw9DR3dfsXtHzmA2RtNGaTlMwo5oIsCDvq7bY9t6STA1uQbEqY5eEWgQu
         q3G12XRrpc11fGcRjk5FXFUgosbyXRuXE3LXBxr52nE54ODErvYUGPmFh9j0DhkrGJAb
         1E+Bxy8ribIUNhOui/bbT27DQViEnf6Sj+44TxSa/qAhVjoJJudYMgfB6skSDqW8g/nJ
         TdNAtDFyqb5i+elzKoxfqgLxcu1y4jg5wj2weba8qulbk6fdKKinxHQH4jq+Trn+URM3
         q22n5foFLS2ukVxmnQkWA/E5SXyI7m2OZzQKDAhfL/a0cEXz79l6DvRDg+BzwWWaqN0e
         qcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JjUN7QIyrElerNYioXdpATYpC1N6H4aJXPGt5T0SivQ=;
        b=AZKcbmRG9BqqBoxDMEjKgpUfz21xboasnosd8eb9MPdwvdbuhrFJcT5pbR/L6tHF4s
         Lad7Bdeh4mAqZ1zG1sq689+ZCRNFf1BgxxaDRTNPuGdNvBjbG1b4KTVh1PyEVenbZCZZ
         8C32mxvLqH9MdRetZ2fr5xGUauUwAY8qmc7cwOhh31VJf0SxTQb6OUOw0xNsPsxSEZpQ
         unlTBCzfd65LCwbI4iIUBkW3RrBL8vGv74KB/2+YBliA3JZtWFUQx0T/cvyJTEMAw5et
         YI/V0AikC6h9aSwmTxOC4rcQzC9Gw9IvV2kuQ0k7i+VDUDEiTy+2i4Hv3NMqgxNHbTJo
         ydrg==
X-Gm-Message-State: AOAM531uDgwR5m6QsF4ySQjVPTgGv2a8tdtqUBRpzjPfjtiOrwPrG6+M
        4ZmexacnWdTTc3euakqCyZwUESbYWXok
X-Google-Smtp-Source: ABdhPJw+6BkTi0AEvbpcnMoUidUtaAjPsdONpoBqG3DgqXyeaWn+QSX5d1UUj/Ij939Nj1UswEcCyQ==
X-Received: by 2002:a9d:7682:: with SMTP id j2mr332666otl.299.1623779479713;
        Tue, 15 Jun 2021 10:51:19 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id m6sm4120656ots.74.2021.06.15.10.51.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jun 2021 10:51:18 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Marco Wenzel <marco.wenzel@a-eberle.de>,
        linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next] net: hsr: don't check sequence number if tag removal is offloaded
Date:   Tue, 15 Jun 2021 12:50:37 -0500
Message-Id: <20210615175037.19730-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't check the sequence number when deciding when to update time_in in
the node table if tag removal is offloaded since the sequence number is
part of the tag. This fixes a problem where the times in the node table
wouldn't update when 0 appeared to be before or equal to seq_out when
tag removal was offloaded.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 net/hsr/hsr_framereg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index bb1351c38397..e31949479305 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -397,7 +397,8 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 	 * ensures entries of restarted nodes gets pruned so that they can
 	 * re-register and resume communications.
 	 */
-	if (seq_nr_before(sequence_nr, node->seq_out[port->type]))
+	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	    seq_nr_before(sequence_nr, node->seq_out[port->type]))
 		return;
 
 	node->time_in[port->type] = jiffies;
-- 
2.11.0

