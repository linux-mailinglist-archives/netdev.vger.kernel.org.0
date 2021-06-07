Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B74D39E952
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 00:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFGWLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 18:11:53 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:33283 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbhFGWLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 18:11:52 -0400
Received: by mail-pg1-f173.google.com with SMTP id e20so2981762pgg.0;
        Mon, 07 Jun 2021 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Li3H1i3Z4GjNEEuhPu6PHWkwnaa7+Xs7SitT/yUhlHc=;
        b=vco66jpWgZ90137HGaujCNiG9O/R7REVE32bp45oLlyNxWCpgaUtKQOzL3uwb/AREX
         fG5fyGoP1maZA6crlvrtHGCGmKiWxNLl+vH6zEuxm8r/BWFgi99UYt2T2SLq/ifi10Ov
         oOE6Uew/6CwOxgxpyF1a4Flja/VE+S8HdlHpO8SBvA++xSz7jb22XWFQwWxR1EItSzSY
         VMaccYAOIHKkNPwy8Gvk2xoy16m2W6jSRr3TVBj5VNVCYYgStYm8LuOX1BQAc0jZ+pJU
         0v12UXR9RM34qJlg6PeZHKoL+9916giKy0ztR93E7G75+mUa0ayMIk2KFOULvKhyaHCq
         /PJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Li3H1i3Z4GjNEEuhPu6PHWkwnaa7+Xs7SitT/yUhlHc=;
        b=M0MPeKTddqPw7wzhVtZsOsZuVrdiTYKRNyw12RW5kb2y0Jvx49OSmwZxCUKcQ0NZuA
         3uVUH2JRokrjt0dbSIR1m8mLz6KMzI8kra06LU6GaZYYP7qaMQZGdKCced9D/HmRrkhu
         FfQGcHdwbWj5f1vD++S+UottMjCytOA7aWazHNaiaOhjmvE4QjD9qDO0DC1mSHKb+DVh
         bbm07SoqWRKCiRaQDf5cI0fRrQoTqkkya9HfLfV0zNRUVuQmN/21HwbEkJBhg4M95B8y
         VrYzSsCkYHEyvC/JYut/Lx6EXFzMc+wIPoSiuBawo/4wC2Ihgt/lyVp1QXZui4KneIfi
         6oCQ==
X-Gm-Message-State: AOAM530WFUzJysOkMnvyHEaNGGep8oozu6KzlxCRCAh6F5mrTWj6mbfo
        Yypt9KJlcA3KNDe5fczkoJ74lwJtd8Y=
X-Google-Smtp-Source: ABdhPJzb4oHCb1KFksvQLPY6G4UpvVZD5aOOh2Fr1z+phS/OJyNsoxLPAjSvLJcdtpnCriLSZIbQZA==
X-Received: by 2002:aa7:8b0d:0:b029:2e9:857e:c1d1 with SMTP id f13-20020aa78b0d0000b02902e9857ec1d1mr18819949pfd.33.1623103731950;
        Mon, 07 Jun 2021 15:08:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h8sm9144845pfn.0.2021.06.07.15.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 15:08:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/2] net: dsa: b53: Do not force tagging on CPU port VLANs
Date:   Mon,  7 Jun 2021 15:08:42 -0700
Message-Id: <20210607220843.3799414-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607220843.3799414-1-f.fainelli@gmail.com>
References: <20210607220843.3799414-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
VLANs") forced the CPU port to be always tagged in any VLAN membership.
This was necessary back then because we did not support Broadcom tags
for all configurations so the only way to differentiate tagged and
untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
port into being always tagged.

This is not necessary anymore since 8fab459e69ab ("net: dsa: b53: Enable
Broadcom tags for 531x5/539x families") and we can simply program what
we are being told now, regardless of the port being CPU or user-facing.

Reported-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3ca6b394dd5f..56e3b42ec28c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1477,7 +1477,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 		untagged = true;
 
 	vl->members |= BIT(port);
-	if (untagged && !dsa_is_cpu_port(ds, port))
+	if (untagged)
 		vl->untag |= BIT(port);
 	else
 		vl->untag &= ~BIT(port);
@@ -1514,7 +1514,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 	if (pvid == vlan->vid)
 		pvid = b53_default_pvid(dev);
 
-	if (untagged && !dsa_is_cpu_port(ds, port))
+	if (untagged)
 		vl->untag &= ~(BIT(port));
 
 	b53_set_vlan_entry(dev, vlan->vid, vl);
-- 
2.25.1

