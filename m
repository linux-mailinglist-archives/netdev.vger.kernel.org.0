Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3637E38DB7B
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 16:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbhEWOtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 10:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhEWOto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 10:49:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F73C061574;
        Sun, 23 May 2021 07:48:17 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x18so14423112pfi.9;
        Sun, 23 May 2021 07:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZwfWA295f4RDy0ynim7ZMzb4wqY1p6Zq0kG2VoTpAE=;
        b=c5hXx0ag+I0Eo1OJnDvaIBjDcGZJaN182tT260aS51zpQPAMbhzfQo7qyqEcPrNEnz
         eY/HfKglB2mty/ApboIWW4ll9QPziWY0hWaBTqzsgnOij3lek2DJrXYzZfNt1N2wGXjI
         ktqwZuFT8HDHKBkx6NOe7JlLsvmMPSzXoB9Ib75BkSlCTnCS4zlG0lHmdEtqg4piH0QH
         /bRuXJbyjcov6p6hJhusqFCmC01E+njhjv+DggceHdaH9uhAsI/kXd5JSnR+Qm6O+2tK
         RIfvfVVRXIT+prQctxvHub6Wp3uO99PQWjzyNl7YhAmFiphu9kgS/ItxLR0I41j5MlRj
         4tJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GZwfWA295f4RDy0ynim7ZMzb4wqY1p6Zq0kG2VoTpAE=;
        b=WmQ6SxTkLq4yBaeRvFhBwm+IoJTNdsJxGlfNVPBBAfEiJKYbhn5264xxI0Iw79rtVu
         nLQ0jCc0Dz82YeDFrNq0qs+Ki+cRhTnlf06Gk91A0afqyQavw8sIsK3PakqE7C06T105
         bnBvU0vZilYBMX3GKijdbgZreHQ7H4dE73tOX+as5pC7yvxxzz5pQO35Z/L5WypedN3x
         oqEGuJgNaRUB3y0zYrwX1qlfBUr8z3Lc9GvezF81FF1hieEdcjFji5cNnE9YKDnz9P61
         JcfKx7YnYtFjR7JZ1ykJOzURasICtpkCGlxzw0gxKK/ZJB5hpTiiCKdwl8uatiUH1E2A
         Fq6A==
X-Gm-Message-State: AOAM533J/1htYca791dLuO1DY/JfEpfdnRQm5wMgS1GwsmRVz/0tLIn9
        JHIdTWcEN6yX+5GEqm99agkiDALwYIagyspe
X-Google-Smtp-Source: ABdhPJxF8YEU2dKbvt0JNgX6XHdlIGKAdfT+F6rHY98QI/DUtNusVcifD3jweNS2zhBHr+m7NE98JA==
X-Received: by 2002:a63:db17:: with SMTP id e23mr8933915pgg.274.1621781297422;
        Sun, 23 May 2021 07:48:17 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id c7sm9341162pga.4.2021.05.23.07.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 07:48:16 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net] net: dsa: mt7530: fix VLAN traffic leaks
Date:   Sun, 23 May 2021 22:48:09 +0800
Message-Id: <20210523144809.655056-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PCR_MATRIX field was set to all 1's when VLAN filtering is enabled, but
was not reset when it is disabled, which may cause traffic leaks:

	ip link add br0 type bridge vlan_filtering 1
	ip link add br1 type bridge vlan_filtering 1
	ip link set swp0 master br0
	ip link set swp1 master br1
	ip link add set type bridge vlan_filtering 0
	ip link add set type bridge vlan_filtering 0
	# traffic in br0 and br1 will start leaking to each other

As port_bridge_{add,del} have set up PCR_MATRIX properly, remove the
PCR_MATRIX write from mt7530_port_set_vlan_aware.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index db838343fb05..93136f7e69f5 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1273,14 +1273,6 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	/* The real fabric path would be decided on the membership in the
-	 * entry of VLAN table. PCR_MATRIX set up here with ALL_MEMBERS
-	 * means potential VLAN can be consisting of certain subset of all
-	 * ports.
-	 */
-	mt7530_rmw(priv, MT7530_PCR_P(port),
-		   PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
-
 	/* Trapped into security mode allows packet forwarding through VLAN
 	 * table lookup. CPU port is set to fallback mode to let untagged
 	 * frames pass through.
-- 
2.25.1

