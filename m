Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A786CF25C
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 08:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfJHGFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 02:05:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37209 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbfJHGFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 02:05:15 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so10175922pfo.4;
        Mon, 07 Oct 2019 23:05:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v6XPWvTzTNM9h297e855Iegd93fJRV+8wlRBEJwrHzk=;
        b=LzK5smRLhxgfNNVkdeJ2/eBsdZqhSbwI76zXSst0Y4a7oj+3H/lyK9u74sGg7VYCTv
         ulfLGOGUrXWdLi7JjH0PgUisrupW2N4lnatebslFpSpo2TyKOfygaTpSm/Ayofyrgjtn
         Ns5e4ln8g5Wd9ryP8w//KsuPimSXmSLS9LkYZ5p0uuOWw8Kaf6nyYfFGdxs2GdDMHtNT
         cPjoIJYLv7GpmiORg3iQulJvAhdgih23zD3H70LFMfN53wf/Qk4ec7n72lc6eqVt5TpA
         A2a0Qf4AbNrZdxZV78LUOp16owiF4WuR1I9NQhM53B1mOKlaCjWfjxrHhY5sMJhU/RNa
         bWpA==
X-Gm-Message-State: APjAAAVBnpeNNp21YkeqR4/r+e8FaGg0qDHVI16+IfKtdEBw0GGSZDf2
        P303qsGcZ9xxdf7OrMM2oKShZBBoNaM=
X-Google-Smtp-Source: APXvYqwcshMidoQ5fZUhw7ynmteehEgUBfFn5kIT0zoo7uwr+6i431XEQrkyBBzhmWpWYPn95OD6Pg==
X-Received: by 2002:a63:2406:: with SMTP id k6mr34458056pgk.420.1570514714468;
        Mon, 07 Oct 2019 23:05:14 -0700 (PDT)
Received: from localhost (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id z4sm1052231pjt.17.2019.10.07.23.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 23:05:13 -0700 (PDT)
From:   You-Sheng Yang <vicamo.yang@canonical.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Gil Adam <gil.adam@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW version 29
Date:   Tue,  8 Oct 2019 14:05:11 +0800
Message-Id: <20191008060511.18474-1-vicamo.yang@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow-up for commit fddbfeece9c7 ("iwlwifi: fw: don't send
GEO_TX_POWER_LIMIT command to FW version 36"). There is no
GEO_TX_POWER_LIMIT command support for all revisions of FW version
29, either.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204151
Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 32a5e4e5461f..dbba616c19de 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -889,14 +889,14 @@ static bool iwl_mvm_sar_geo_support(struct iwl_mvm *mvm)
 	 * firmware versions.  Unfortunately, we don't have a TLV API
 	 * flag to rely on, so rely on the major version which is in
 	 * the first byte of ucode_ver.  This was implemented
-	 * initially on version 38 and then backported to29 and 17.
+	 * initially on version 38 and then backported to 29 and 17.
 	 * The intention was to have it in 36 as well, but not all
 	 * 8000 family got this feature enabled.  The 8000 family is
 	 * the only one using version 36, so skip this version
-	 * entirely.
+	 * entirely. All revisions of -29 fw still don't have
+	 * GEO_TX_POWER_LIMIT supported yet.
 	 */
 	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
-	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
 	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
 }
 
-- 
2.20.1

