Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660D23A689A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbhFNOB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:01:28 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:43706 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbhFNOB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:01:26 -0400
Received: by mail-ej1-f42.google.com with SMTP id ci15so16883266ejc.10
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 06:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r6izeuJhZiJoW9MH2dfKNcgUUzIRhDaZYWOf9tdTY44=;
        b=ImDJxw0gkxmdXxKMEJE6qeaNGrpjdAFdcgai6CEu5x433LExYzsNCd2kFp+y/sjwAT
         cogIOelWpL4ycZTh14d9xbfEnH+p0vSGkgPjDJy1W16TMAd//tiKtF6iwX8p18sX45yP
         7DLsNtNmuDM+Y+hnuk5vU1y+NE/Dub/MzceUqfRTb5mhScwyW85aVq4GIV948mr4oBzd
         ySlJ7tsDOJUdbVulzhOv+mJSugk9j4pESP3kYuAYBd0hJjE8IAG6NNX0uPtHhihtKlQH
         V9iT9NqQTOKwxaaBpS9/OUhK8Qs59v/qvgOYiivWvy1s03FIhVtFqrH+APkFwvkjds6Z
         8gpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r6izeuJhZiJoW9MH2dfKNcgUUzIRhDaZYWOf9tdTY44=;
        b=phviAOa/GgH0N2jp6ecTjxEjs82vYYRT1kCbaCIb8ezvEqGaXP29tZ4YtiZn+Zy6mm
         8y448MGf+6NsN88TzfYrI8eP++A3SDEVReFxmHk0Cj3awBbxDYOakXANaNPFse8fH5ky
         ms0PuW4F2X4x9H2ys6PV+rUpx3nhYayxTJxtCn3xNeW9MRBNsFQpfg04RGu8Aludcyj1
         8wrWuOt0I+8WSi+HyDE7PZL9UdEIQncRcodw/9tAJbQjkZfy7PdMeyu5UoeURQAzAQ3b
         MisF9est9OEyqiY/nFVeL+6L/9krSIA4pqJy/NHu7HlMjcEJR4Vb14WwGLUj0YNstTsq
         pM4A==
X-Gm-Message-State: AOAM530C4m3utYFfCXtN/cnvoIkkausOcVAMDD8dofod1IOGFs7VBf8q
        Ae82QMoeEZh4hHCVeQ4m0aY=
X-Google-Smtp-Source: ABdhPJw8y/F+M0AO/YRRHGGAWoAb42P9OIFIcIluO8r45HittfCSg0UC2NGrmkieZCOCcm320wEGHQ==
X-Received: by 2002:a17:907:2648:: with SMTP id ar8mr15271442ejc.521.1623679103350;
        Mon, 14 Jun 2021 06:58:23 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id n5sm8897316edd.40.2021.06.14.06.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 06:58:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: flow_dissector: fix RPS on DSA masters
Date:   Mon, 14 Jun 2021 16:58:19 +0300
Message-Id: <20210614135819.504455-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After the blamed patch, __skb_flow_dissect() on the DSA master stopped
adjusting for the length of the DSA headers. This is because it was told
to adjust only if the needed_headroom is zero, aka if there is no DSA
header. Of course, the adjustment should be done only if there _is_ a
DSA header.

Modify the comment too so it is clearer.

Fixes: 4e50025129ef ("net: dsa: generalize overhead for taggers that use both headers and trailers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/flow_dissector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index c04455981c1e..2aadbfc5193b 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -943,8 +943,8 @@ bool __skb_flow_dissect(const struct net *net,
 			int offset = 0;
 
 			ops = skb->dev->dsa_ptr->tag_ops;
-			/* Tail taggers don't break flow dissection */
-			if (!ops->needed_headroom) {
+			/* Only DSA header taggers break flow dissection */
+			if (ops->needed_headroom) {
 				if (ops->flow_dissect)
 					ops->flow_dissect(skb, &proto, &offset);
 				else
-- 
2.25.1

