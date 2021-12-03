Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA38466F97
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378012AbhLCCNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:13:51 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:36818
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377988AbhLCCNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:13:50 -0500
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id DF23C41B8A;
        Fri,  3 Dec 2021 02:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638497426;
        bh=MTq2dYtg3YeoM4VKuKUBUvX2WOXVAXc3ZzvEPiuJkuM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ue794apfTGL1FQ8SvpLX8YhtNWHKiOn9/r1q4bBFDs+p/iK9z5SqrKpaV8vmgnco8
         yHkCXmtcLeYhp0G/6QedSlnjF7UXWOmhL5GSSGUotGU+EBX++rhvVTkXoKmkk9mQeU
         FQ6y3oFbieUbvTWQKa2ce9GrotFsUWBb0hVPP7F6nbgvDItwn8nkvpONldAp9Ew7u9
         xS32QQ/yPJYwyzxjlltpfOd2Zqtm5lyibE6Bad2gdAExFgNlVM7JnHIEO9wGjX1RSi
         LeE1VLicE4s+SeKFNWNw0O68FouT1/mEwMccDXKMaftjIw+Rl2jRSSOWOKHib0OH3k
         SCjvjgC8iqiCA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     luciano.coelho@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dror Moshe <drorx.moshe@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Abhishek Naik <abhishek.naik@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Ayala Barazani <ayala.barazani@intel.com>,
        Harish Mitty <harish.mitty@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Increase microcodes loading timeout
Date:   Fri,  3 Dec 2021 10:09:28 +0800
Message-Id: <20211203020931.1419572-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel AX201/AX211 device may not work at boot:
[    8.875307] iwlwifi 0000:00:14.3: SecBoot CPU1 Status: 0x7267, CPU2 Status: 0xb03
[    8.875418] iwlwifi 0000:00:14.3: UMAC PC: 0x80481126
[    8.875426] iwlwifi 0000:00:14.3: LMAC PC: 0x1541c
[    8.875430] iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 13 fired (delay=0ms).
[    8.877906] iwlwifi 0000:00:14.3: Loaded firmware version: 64.97bbee0a.0 so-a0-gf-a0-64.ucode
...
[    8.878997] iwlwifi 0000:00:14.3: Failed to start RT ucode: -110
[    8.878999] iwlwifi 0000:00:14.3: Failed to start RT ucode: -110

Increase MVM_UCODE_ALIVE_TIMEOUT to 2 seconds can solve the issue.

The PNVM loading can also fail:
[    5.159949] iwlwifi 0000:00:14.3: loaded PNVM version 4b50f925
[    5.414211] iwlwifi 0000:00:14.3: Timeout waiting for PNVM load!
[    5.414219] iwlwifi 0000:00:14.3: Failed to start RT ucode: -110
[    5.414224] iwlwifi 0000:00:14.3: WRT: Collecting data: ini trigger 13 fired (delay=0ms).
[    5.416618] iwlwifi 0000:00:14.3: Start IWL Error Log Dump:
[    5.416619] iwlwifi 0000:00:14.3: Transport status: 0x00000042, valid: 6
[    5.416620] iwlwifi 0000:00:14.3: Loaded firmware version: 64.97bbee0a.0 so-a0-gf-a0-64.ucode
...
[    5.914276] iwlwifi 0000:00:14.3: Failed to run INIT ucode: -110

Trial and error shows that the MVM_UCODE_PNVM_TIMEOUT also needs to be
bumped to 2 seconds to fully eliminate the issue.

The timeout values are verified by rebooting over 10k times.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
index 203c367dd4dee..b730330d8feac 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
@@ -10,7 +10,7 @@
 
 #include "fw/notif-wait.h"
 
-#define MVM_UCODE_PNVM_TIMEOUT	(HZ / 4)
+#define MVM_UCODE_PNVM_TIMEOUT	(2 * HZ)
 
 #define MAX_PNVM_NAME  64
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 6ce78c03e51f7..0c5375f7baecf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -24,7 +24,7 @@
 #include "iwl-modparams.h"
 #include "iwl-nvm-parse.h"
 
-#define MVM_UCODE_ALIVE_TIMEOUT	(HZ)
+#define MVM_UCODE_ALIVE_TIMEOUT	(2 * HZ)
 #define MVM_UCODE_CALIB_TIMEOUT	(2 * HZ)
 
 #define UCODE_VALID_OK	cpu_to_le32(0x1)
-- 
2.32.0

