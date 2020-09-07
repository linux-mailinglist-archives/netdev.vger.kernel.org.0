Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF025FEC9
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbgIGQXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730433AbgIGQXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:23:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5604C061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:23:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id n3so7606026pjq.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SDxUUQ+8c+YEIDDJur8rYrh3CcLj60cM5IrQcltAbJU=;
        b=Wy+lY5pi2y0MXKbzHqJ4nxyLK8FkoENJ+OWduamenQCm/MHiU+zeaS9LOSSiSk7TmX
         OQwBenpNoA2RRwW+bDYWYnuPBVvGkPeIZJXm0ZMBz4gBd2pC5Kw5z5E0N3ZbM34nAw+k
         OdteM1Ed8drJUGv6ZCa9m6kJPpuG9BZzrYu+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SDxUUQ+8c+YEIDDJur8rYrh3CcLj60cM5IrQcltAbJU=;
        b=PGRC/035u/WtD0GwCESHcYRSwILJZdQ4+cMTE5mY0nccTEHZ7JQhP9WgN9ZmBabiZ9
         nt8YZKSayR/8RKaf+SzS7oCflkszuX+MyHcGg+KJWdIJ3qkFrV5CU14ODpvjBB0qNn7A
         QxzvrgMpe1n1X+SSUZ7bzTujRZk3MbAs43ak8NjFW1SBN6B3T+/hQnC/j3AMU3U6+0Ke
         oP/XV40YERo+RSoK9p0nmr/9R3iZR8/ZRjh/aLnjisY62slCwO+Qz418L1774VlmdeUz
         ww7M4tSn3Om3N96uqUrquzxtmV/MHZFj0q1gOMccFKN7j9AKjDkLuUgBVQVt4rvzyE4J
         Aa9A==
X-Gm-Message-State: AOAM531UUEdGDuU1HhSYw58TTmCIBPG8An+Ekqm/NGJEQ1XbPGSvIkVP
        RvrBvXh0e8WHaye+Yoezmnk5nA==
X-Google-Smtp-Source: ABdhPJyt1f1puArMGZEw7H7IWnsOdW3BtYIeDECpZMGG2uhioAhtb/hu+XxvwnoXRKkOXMIXD2nqUQ==
X-Received: by 2002:a17:902:d353:: with SMTP id l19mr9227410plk.220.1599495818901;
        Mon, 07 Sep 2020 09:23:38 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id v1sm3229622pjn.1.2020.09.07.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:23:38 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi@sslab.ics.keio.ac.jp,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list.pdl@broadcom.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        brcm80211-dev-list@cypress.com (open list:BROADCOM BRCM80211
        IEEE802.11n WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] brcmsmac: fix potential memory leak in wlc_phy_attach_lcnphy
Date:   Mon,  7 Sep 2020 16:22:43 +0000
Message-Id: <20200907162245.17997-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When wlc_phy_txpwr_srom_read_lcnphy fails in wlc_phy_attach_lcnphy,
the allocated pi->u.pi_lcnphy is leaked, since struct brcms_phy will be
freed in the caller function.

Fix this by calling wlc_phy_detach_lcnphy in the error handler of
wlc_phy_txpwr_srom_read_lcnphy before returning.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index 7ef36234a25d..6d70f51b2ddf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -5065,8 +5065,10 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	pi->pi_fptr.radioloftget = wlc_lcnphy_get_radio_loft;
 	pi->pi_fptr.detach = wlc_phy_detach_lcnphy;
 
-	if (!wlc_phy_txpwr_srom_read_lcnphy(pi))
+	if (!wlc_phy_txpwr_srom_read_lcnphy(pi)) {
+		wlc_phy_detach_lcnphy(pi);
 		return false;
+	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
 		if (pi_lcn->lcnphy_tempsense_option == 3) {
-- 
2.17.1

