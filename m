Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465A61B716
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbfEMNdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:33:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35674 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbfEMNdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:33:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id h1so6805779pgs.2;
        Mon, 13 May 2019 06:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dHB+2UT2SbFOUCgxQjFqk9pofSt4ba6bP6xlRWy9uz8=;
        b=KuXvSRMYMKGzAylOkSf6HZsrUBzZMXGa86X+6uv3efqmd+6ImnKgro2FqOsBr2V44w
         ELvJmk5nJEWhJjUmtdgHpYgUtNfZ1Fk9TKFzXNxMzQess1GQ3XObF0QfDHbhIEVtUUFB
         dN2jQ3JgzsRrAGO49aEiYDrL956oBcs/o8kEoz46lQ2CSCQ6Eyrduhiiacr9lLcvUdvF
         1NDIALBson6SKLJeebv1XRoNFMdl1sMLIoh1OPwXVBeOsbVacm8W/E7Ms9BxuWbWwOPk
         Ab7BfgP9UmGxW2nVDG/z4uuffyE+gF6CsnxG7iF//EdmqheaG8SZwcVypUAUcZYNl2zo
         CbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dHB+2UT2SbFOUCgxQjFqk9pofSt4ba6bP6xlRWy9uz8=;
        b=XiQ1SA6Kn8pHx4KuaPC633+HRy6da5+R+IDK6Qe+Lt/xjvBEeqrTk6LrGlL2hV3spu
         6vA+kQEcoUf+ZBtDjoUzqDeyazZSS9yzUPkmVhKA1aYc8sHnhOFIJIHwBpQ+5Ky4NtFi
         goAQyPmEBtyLhhlou1n5VJp3bwLp8C61GQ5njPTZ/yBZ/9buoICSsEp+XeeNlVtqQf4z
         84GcDozcaIFvrZ5Xn/PoPyGTgYom4hZ/Yjmr8D5a7nkDlSh93hR76sgU19E1CAmyL6U9
         bLbewU6Juw5Ioyv+Ynv7pUS57HJrIaUfy8GnBH81z6Qrm41E1kncgvVR4iqXDI6mlWxD
         lvxA==
X-Gm-Message-State: APjAAAXU5sZBB7Z8E+fh0HZD9A1hiC4Uhy8mC8mKQcYnZuM+58FVqd3f
        VIZwT+fk5Yw1QhNivGPVTnI=
X-Google-Smtp-Source: APXvYqzCHEBbsQ9j/TAQ9YLva9rBRXDXM3fwxild9xMkA+ykPkX3PCo9l3kUOGRoDUw95ZR47IUmEw==
X-Received: by 2002:a62:1c06:: with SMTP id c6mr22162703pfc.168.1557754417788;
        Mon, 13 May 2019 06:33:37 -0700 (PDT)
Received: from localhost (36-225-62-102.dynamic-ip.hinet.net. [36.225.62.102])
        by smtp.gmail.com with ESMTPSA id h6sm28582717pfk.188.2019.05.13.06.33.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 May 2019 06:33:37 -0700 (PDT)
From:   Cyrus Lien <cyruslien@gmail.com>
X-Google-Original-From: Cyrus Lien <cyrus.lien@canonical.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Lior Cohen <lior2.cohen@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Cyrus Lien <cyrus.lien@canonical.com>
Subject: [PATCH] iwlwifi: trans: fix killer series loadded incorrect firmware
Date:   Mon, 13 May 2019 21:33:35 +0800
Message-Id: <20190513133335.14536-1-cyrus.lien@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Killer series loadded IWL_22000_HR_B_FW_PRE prefixed firmware instead
IWL_CC_A_FW_PRE prefixed firmware.

Add killer series to the check logic as iwl_ax200_cfg_cc.

Signed-off-by: Cyrus Lien <cyrus.lien@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 79c1dc05f948..576c2186b6bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3565,7 +3565,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   (trans->cfg != &iwl_ax200_cfg_cc ||
+		   ((trans->cfg != &iwl_ax200_cfg_cc &&
+		     trans->cfg != &killer1650x_2ax_cfg &&
+		     trans->cfg != &killer1650w_2ax_cfg) ||
 		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
-- 
2.17.1

