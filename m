Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B08C63D100
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbiK3Ipp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiK3IpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:45:21 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F95630F58;
        Wed, 30 Nov 2022 00:45:15 -0800 (PST)
Received: from ykarpov.intra.ispras.ru (unknown [10.10.2.71])
        by mail.ispras.ru (Postfix) with ESMTPSA id 7867A40D403D;
        Wed, 30 Nov 2022 08:45:11 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7867A40D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1669797911;
        bh=r3Rg2YhNmfjZGaScA5OcxaOz3tJEP+T11CxUAPtKqrI=;
        h=From:To:Cc:Subject:Date:From;
        b=hpkfxYnEjSReIcIiVajn4hcK9ueNnjTwjcBMwyyLcH2d2JVxpcir1hX6UbqGcZ+FU
         xnIAYlSTYc2dj6/fddzRKpFupf/qZpbwweZHBbWkJasQdHk7pRoKwOuHZWRmAeA+Xa
         rvuXQOSRN537ymkTDz1fh8AFggEIQBkUGtSe4aRU=
From:   Yuri Karpov <YKarpov@ispras.ru>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Yuri Karpov <YKarpov@ispras.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] net: dsa: fix NULL pointer dereference in seq_match()
Date:   Wed, 30 Nov 2022 11:44:31 +0300
Message-Id: <20221130084431.3299054-1-YKarpov@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp_parse_header() result is not checked in seq_match() that can lead
to NULL pointer dereferense.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c6fe0ad2c349 ("net: dsa: mv88e6xxx: add rx/tx timestamping support")
Signed-off-by: Yuri Karpov <YKarpov@ispras.ru>
---
 drivers/net/dsa/mv88e6xxx/hwtstamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index 331b4ca089ff..97f30795a2bb 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -246,7 +246,7 @@ static int seq_match(struct sk_buff *skb, u16 ts_seqid)
 
 	hdr = ptp_parse_header(skb, type);
 
-	return ts_seqid == ntohs(hdr->sequence_id);
+	return hdr ? ts_seqid == ntohs(hdr->sequence_id) : 0;
 }
 
 static void mv88e6xxx_get_rxts(struct mv88e6xxx_chip *chip,
-- 
2.34.1

