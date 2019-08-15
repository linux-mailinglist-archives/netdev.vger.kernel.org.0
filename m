Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA6A8F636
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbfHOVEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:04:38 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:37085 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729562AbfHOVEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 17:04:37 -0400
Received: by mail-yw1-f68.google.com with SMTP id u141so1151397ywe.4;
        Thu, 15 Aug 2019 14:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+R4DESpyDCTZ4/02fHbOI51O/W8uEbFi4iGwP/pNzHY=;
        b=YGrI1rAgHm76+ahYOMIeT+o2/yHNDSjHdC2DUoghFLq+jgOVFZ2t4+/AhcdTWtU1Wo
         IT7hQS2EVbiwqAgDQihDpYW4mnqjIn5bFjKLFIhJ7kzs/usAZzZZ7wY4VlKDcBtOs0zR
         EaIzRRkEEGDONZSePtQyw22qjeHbPgiU4ovz7HXeXrGUmFgO9HWU1X8urU7T/UL8IMuo
         c1ER7kTlT3aAm3WKm65iODSX/HTWyiTGcMO+nxqtXEXqZ8jAg2FOmxyB5NwIURuf89S0
         cffsJoPT0TMYC8nDlhaRi3OQu1/wzDBKj9Lgjr/h4Ns0oIqp43D3SdB6nS+EBoBWzk4j
         pimQ==
X-Gm-Message-State: APjAAAWK1PU5D3CwDfkun+Leq/vwWZXAzCjnndoIhWqiQNrcgjR39Sfj
        JM24r1d/sS/BiO09z4suypQ=
X-Google-Smtp-Source: APXvYqz7fEvZy6Sm2rvk8VGtZJ+AorpI71niilpfuX4QYL55lDYQF0j9lQCgHV0uOFCk9Ksr1bp4hQ==
X-Received: by 2002:a81:de4e:: with SMTP id o14mr4405193ywl.369.1565903076933;
        Thu, 15 Aug 2019 14:04:36 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id s188sm871287ywd.7.2019.08.15.14.04.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Aug 2019 14:04:35 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH10K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ath10k: add cleanup in ath10k_sta_state()
Date:   Thu, 15 Aug 2019 16:04:31 -0500
Message-Id: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'sta->tdls' is false, no cleanup is executed, leading to memory/resource
leaks, e.g., 'arsta->tx_stats'. To fix this issue, perform cleanup before
go to the 'exit' label.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/wireless/ath/ath10k/mac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0606416..f99e6d2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6548,8 +6548,12 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 
 		spin_unlock_bh(&ar->data_lock);
 
-		if (!sta->tdls)
+		if (!sta->tdls) {
+			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
+			ath10k_mac_dec_num_stations(arvif, sta);
+			kfree(arsta->tx_stats);
 			goto exit;
+		}
 
 		ret = ath10k_wmi_update_fw_tdls_state(ar, arvif->vdev_id,
 						      WMI_TDLS_ENABLE_ACTIVE);
-- 
2.7.4

