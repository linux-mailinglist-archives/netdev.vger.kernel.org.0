Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6E45AE343
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbiIFImf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239335AbiIFImJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:42:09 -0400
Received: from 7of9.schinagl.nl (7of9.connected.by.freedominter.net [185.238.129.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5527A759;
        Tue,  6 Sep 2022 01:38:23 -0700 (PDT)
Received: from localhost (7of9.are-b.org [127.0.0.1])
        by 7of9.schinagl.nl (Postfix) with ESMTP id 3E344186D925;
        Tue,  6 Sep 2022 10:37:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662453478; bh=aXwLTb+hD9KUw7lePfE8Qw+Eb84hrWFhNIrpepLA8Ss=;
        h=From:To:Cc:Subject:Date;
        b=bPxs1addoZHE9rR2YE8noQg9liWZHnastXqDhtINubz9HZCVc9UDsy80ECV56Rxs1
         SRWrZDLnpgiRoc79OdyL8n6R3hLuQ17NRogayujA3UeDaJVq2J9yOmIF+vFbaRod8c
         Loa/NMj365DUHfiXjwhR59D1PW8O7fVJU+HrDLvQ=
X-Virus-Scanned: amavisd-new at schinagl.nl
Received: from 7of9.schinagl.nl ([127.0.0.1])
        by localhost (7of9.schinagl.nl [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id L5NP1EfV7y3q; Tue,  6 Sep 2022 10:37:57 +0200 (CEST)
Received: from valexia.are-b.org (unknown [10.2.11.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 7of9.schinagl.nl (Postfix) with ESMTPSA id 272A0186D91D;
        Tue,  6 Sep 2022 10:37:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schinagl.nl; s=7of9;
        t=1662453477; bh=aXwLTb+hD9KUw7lePfE8Qw+Eb84hrWFhNIrpepLA8Ss=;
        h=From:To:Cc:Subject:Date;
        b=ho80HkmdEi/4Wj6SMvP0++4Prn8JR3DrCx1B9e/CwMHR1DJCV4hEAt4H3shLjUTsm
         NnJ5WAcVcZ+JX8gms6M61RDR6ztQ5WCExpTeYbsrfUC7ST+rnzr4sHHuh+AcXHZJj0
         paI1tzSyGm1ZLk1ocVUGiisaTImRqQKBlGBlhlCg=
From:   Olliver Schinagl <oliver@schinagl.nl>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Alexandru Tachici <alexandru.tachici@analog.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Olliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH] linkstate: Add macros for link state up/down
Date:   Tue,  6 Sep 2022 10:37:54 +0200
Message-Id: <20220906083754.2183092-1-oliver@schinagl.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phylink_link_state.state property can be up or down, via 1 and 0.

The other link state's (speed, duplex) are defined in ethtool.h so lets
add defines for the link-state there as well so we can use macro's to
define our up/down states.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 include/uapi/linux/ethtool.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2d5741fd44bb..3a00e2f64d87 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1857,6 +1857,10 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define XCVR_DUMMY2		0x03
 #define XCVR_DUMMY3		0x04
 
+/* Linkstate, Up or Down */
+#define LINKSTATE_DOWN		0x0
+#define LINKSTATE_UP		0x1
+
 /* Enable or disable autonegotiation. */
 #define AUTONEG_DISABLE		0x00
 #define AUTONEG_ENABLE		0x01
-- 
2.37.2

