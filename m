Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3F038DB7E
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 16:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhEWOxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 10:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhEWOx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 10:53:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43771C061574;
        Sun, 23 May 2021 07:52:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso9074997pjq.3;
        Sun, 23 May 2021 07:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cMgWw8H94zaKjk8GXFY761R3LLW2Itjl1Ts+vcO3J8Y=;
        b=IuJ7jSdTq9izzIC9GytSEI1vhjnoseiJ1X38y/N3ptq0Pchy0Y77p/4F7Mf42Z+cIz
         uLbeJg3V0kSX8rt5ERZ5f3XbjxWac635QGosDiV7ykdscs+9dVXduTvaSf+vPHqc8+Bw
         LHSh2M1wlfFGoTVF5JFFWiOKD/7K58X+3BStiOFs+KkcUobp7/3DhyPVFXERwTKbPg/8
         yMr46uD/GX8q2PdyxiVoFVB4XcTOEnFaGZdoftrlscsyNzNgVWW1PuFnIOI7U5LGi4kb
         cpQ6L9TeEi56YtKXPPqZT5gsz1nzhndS0gIVVtH6fWz4I1C+u9RoxxoawGtyAXXKWyTQ
         OtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMgWw8H94zaKjk8GXFY761R3LLW2Itjl1Ts+vcO3J8Y=;
        b=pJ598gG1lwV3GzX9zEh34rJvxawQePy6f2RtaA2x4lxZKeOrcDEetDk36nZs48LSES
         0OjORgvErACkPpSJYK+CEOQclRqQI85S7B2xv3T4qirCiOym7rZf8KSjNJe3Nokly4hF
         J6AwPfL5XhRznwr9+MDH+cICrDydYAPtit82xU+/fnj/hpzQfy5VeLbzFxMeAxIDkmzx
         qtS57DQnCsi42ZSuJG8RmJS7IoYtGo9VJUXzmiVHO1xcLjkchhexJbP/NFor662rZNUH
         wsiFWDLF6vR+ixh1J8UcXAn7ms0UpjWoS9ABowMWEWyGUK0qXkzJuxumTydY6xKdYOAb
         XEJw==
X-Gm-Message-State: AOAM531jP5esvOZ7IhD4/cKBDFr81J8KrROAyq9vrk4IIRlUW+1t/nIA
        myy/X+AhzHSzNdsudsj1cMk=
X-Google-Smtp-Source: ABdhPJybLP1mV9+33vVAgjPQUIQlLl7AtQ0vGUrCqm+RWoO5g8Zhu7DYAoz+kmbO/MQUiYVtBmCx3g==
X-Received: by 2002:a17:90a:a604:: with SMTP id c4mr20766432pjq.81.1621781522684;
        Sun, 23 May 2021 07:52:02 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id o10sm9237271pgv.28.2021.05.23.07.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 07:52:02 -0700 (PDT)
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
Subject: [PATCH net v2] net: dsa: mt7530: fix VLAN traffic leaks
Date:   Sun, 23 May 2021 22:51:54 +0800
Message-Id: <20210523145154.655325-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523144809.655056-1-dqfext@gmail.com>
References: <20210523144809.655056-1-dqfext@gmail.com>
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
	ip link set br0 type bridge vlan_filtering 0
	ip link set br1 type bridge vlan_filtering 0
	# traffic in br0 and br1 will start leaking to each other

As port_bridge_{add,del} have set up PCR_MATRIX properly, remove the
PCR_MATRIX write from mt7530_port_set_vlan_aware.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2: Fix typo in commit message

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

