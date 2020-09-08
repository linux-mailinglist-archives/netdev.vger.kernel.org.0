Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DCB26176F
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731890AbgIHReR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731468AbgIHQPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:15:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137D6C0617BF
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 05:18:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f18so10790526pfa.10
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I6s+zS63VgYflu2ysM9jwbSThCH0cW5s0L4jq3r9DZY=;
        b=Txqe4FtqMIs8NZBjP01sirvZGuIa1rODpnwJ4t+6Jvxs8S+QJiOYxFcFDD2chZ9RGX
         z2KVXcdeiq7bHPzvvR/0bhlfIXFOT4F7DgjtFmjCYOwIewId04lQtA770Naj9UdbrFdO
         1hcxMQxKIxz4M/HGN0dBfBezknP7m7wfI/NO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I6s+zS63VgYflu2ysM9jwbSThCH0cW5s0L4jq3r9DZY=;
        b=Zu56xdZgxV6jZ2AQ1+DOpu6qH+mV5qZlJSFtjWdlEQYEv4TiM4hbZEYvWXZ376kIqP
         aToAMa0C1uJG9Ut+qvHyu+0J3JiIAoQJg1GKLiU5JnQ2i7Gul1/EwLhQimg6/wPTV0ZW
         tXzbOui4sCbZp1P5YAjUrFUqVG12QBbN3bzf7HMtUaCMVgfxQMHP++GBAFLKfA7K+Ttf
         m8y9otLXm/A0cKPny2NnQKDuwcDuEJ9jnN8hS2UnD5gcfIYo3CaOVbS4OFfi8f1FNUPz
         01E/D/sK/xpAAfDuOLFO5X+Tcp5dbZ2f8dGQIlpX3DZf5ssUzp/gXcKlbjPZvHQvUbAn
         2byA==
X-Gm-Message-State: AOAM531V7ARLmfczBGi6hui4tIvFm2gW3QNObEzV/4sS8SXz5v6r+tm3
        VFXiJxsXV5ua7tPCpXlJZVs4Hg==
X-Google-Smtp-Source: ABdhPJwqcY4s0ngn/4xvoWW8TRtIFUj78DiGmg9n3J0eITWmhZYcAu1ac5FpbNUjo94SZis9zTr01g==
X-Received: by 2002:a17:902:d714:b029:d0:cbe1:e7a2 with SMTP id w20-20020a170902d714b02900d0cbe1e7a2mr941003ply.19.1599567483478;
        Tue, 08 Sep 2020 05:18:03 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id a138sm19084597pfd.19.2020.09.08.05.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 05:18:02 -0700 (PDT)
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
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] brcmsmac: fix memory leak in wlc_phy_attach_lcnphy
Date:   Tue,  8 Sep 2020 12:17:41 +0000
Message-Id: <20200908121743.23108-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <2a11074f-e155-0af1-aa37-108c8cd120e7@broadcom.com>
References: <2a11074f-e155-0af1-aa37-108c8cd120e7@broadcom.com>
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
changelog(v2): change call from wlc_phy_detach_lcnphy() to kfree()

 .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index 7ef36234a25d..66797dc5e90d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -5065,8 +5065,10 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	pi->pi_fptr.radioloftget = wlc_lcnphy_get_radio_loft;
 	pi->pi_fptr.detach = wlc_phy_detach_lcnphy;
 
-	if (!wlc_phy_txpwr_srom_read_lcnphy(pi))
+	if (!wlc_phy_txpwr_srom_read_lcnphy(pi)) {
+		kfree(pi->u.pi_lcnphy);
 		return false;
+	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
 		if (pi_lcn->lcnphy_tempsense_option == 3) {
-- 
2.17.1

