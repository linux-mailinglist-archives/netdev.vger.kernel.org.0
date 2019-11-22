Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D68B41077F2
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKVTUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:20:12 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43276 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfKVTUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 14:20:11 -0500
Received: by mail-io1-f66.google.com with SMTP id p12so1922933iog.10;
        Fri, 22 Nov 2019 11:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LUPoVXtEJRriu3gt1A6+ir0p1Bek4hzh1TUla5kFEi4=;
        b=B++dLgyueJDivQQoLxOkqSMkteMasuevFvh0YY22g0HJXUTPoTQEVXVt4DaEOG1sLi
         wcA6P+fRoUwNqKPpCUkMmyLa+dQEGG1JQWhE70ME0xaVrT+I9XGhv4IJOpn1i0Z2578t
         h8VEwse+AN+IulTu+IahMHZoDd5wwJIXLo8FWEtF1TgxwqACvuY0MWoNnKygoR0cSwxw
         y+C1iBIcTzzX24XaQsh4rfvT12Plq2A4YLWj8gj2PAT1o5ZDRJUA9OkFe366PBEnAC8Z
         6b7E7JzX98pbqykZ/owIr9kC27tRnGT6yk5D2qHMdBEv6LYDo7uSlxCTKiXbiKLtA7iN
         mmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LUPoVXtEJRriu3gt1A6+ir0p1Bek4hzh1TUla5kFEi4=;
        b=Y/3QqUPP0HlaJNXp3o9r8TkbtVYv/bKsg/Xy6bhAkYwqnOHSvkicyUo4QIRha/IW6b
         YB4kmvmcxGBWRBXeSC5NinnQXgPvo7UacUEpPsof3JXpNHh+ZUkLj4XWAeAJM76DX1aK
         dXia2hNBMqAfS96R6H6yISOJkZcon3Ew+8zjjicKXx/TCMkay4zSpvnNyGNlAWhm6OAB
         UJ51DXkzxmRR0FHKm1k17C18HaIeQHelixWfjfOwEne8KjEl1f75RhhsIVO6jPJ33RGf
         C2gz1o9m/CDH//KgOwFJ3vz2VFJ2nLzhQjVGY0nOsJ+XPNfAByAObbnxPD/j4CPWbcaO
         HUFQ==
X-Gm-Message-State: APjAAAVPXYY5iO/jeD/l3B8qvRP/iIiK2v4gy0Dq71KK3Yg7bVsjFNu8
        vctF99xHXyGPt26GKwiYVqU=
X-Google-Smtp-Source: APXvYqyUf8IL7jAXQIGJIUESwEj/Iv27BNarP/uWWDgzny2gzQnUZCVpDtO7kbt1exQCfJOlidXNHg==
X-Received: by 2002:a02:7708:: with SMTP id g8mr5080424jac.9.1574450410698;
        Fri, 22 Nov 2019 11:20:10 -0800 (PST)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id k20sm2647403iol.3.2019.11.22.11.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 11:20:10 -0800 (PST)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu
Subject: [PATCH] brcmfmac: Fix memory leak in brcmf_p2p_create_p2pdev()
Date:   Fri, 22 Nov 2019 13:19:48 -0600
Message-Id: <20191122191954.17908-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of brcmf_p2p_create_p2pdev() the allocated memory
for p2p_vif is leaked when the mac address is the same as primary
interface. To fix this, go to error path to release p2p_vif via
brcmf_free_vif().

Fixes: cb746e47837a ("brcmfmac: check p2pdev mac address uniqueness")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 7ba9f6a68645..1f5deea5a288 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -2092,7 +2092,8 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* firmware requires unique mac address for p2pdev interface */
 	if (addr && ether_addr_equal(addr, pri_ifp->mac_addr)) {
 		bphy_err(drvr, "discovery vif must be different from primary interface\n");
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto fail;
 	}
 
 	brcmf_p2p_generate_bss_mac(p2p, addr);
-- 
2.17.1

