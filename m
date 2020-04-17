Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DF01AD794
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgDQHkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgDQHku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 03:40:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28792C061A0C;
        Fri, 17 Apr 2020 00:40:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h2so1880775wmb.4;
        Fri, 17 Apr 2020 00:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M6zd6QhvfNJlEwVbZDRhDx/68LHI8zgQWBMk5eF3jR0=;
        b=FcBenMqFS5c2OoxTLCn55ksThTSSUloPM/Zc55FM/evT6+1CaYC8UMmy7FzGcra0Fl
         VkyTyRf7ifqtgwFrnGQV574d5i51AkTBteqmekTgabH6Oz7Ka18/laSW1bXXfsUTvYLN
         qslPQ/MTbviAHsjwiyIo0lb5UdkPgSBaKNOjFsa4N/kMzWFciQNMVrFaCPtyaTHlVg01
         UubuxJJBZNC8UBchdmCAGde40f75hU4/lWOVq0agF5vbtKnDD4WEyQAe5PQsfVmhTPIG
         7mhwgNeb5sECqGq3aegAmSw1JECTp5oSpiq1JziZHWrecuxS2bSfO92Vq9eKfWWYulS3
         ZpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M6zd6QhvfNJlEwVbZDRhDx/68LHI8zgQWBMk5eF3jR0=;
        b=HUH3qoUxEhrR6RwlHXcfy0tv2fYp7zECUo4QHPni48yYK823GxytVHr7Fbew873WeL
         FbLEirXyZSXiAmWoYdi6Jz0lpAhsgN/qq1xA+SDrjk35AJE/d/So2JrqQ6IIM3F42I9/
         6LtiPq03Tf7F1UkE06CvU3RFqrUT1YGjnHwJ4b2m6Cb4yZsOz84HhwkM7zuNjD4AhRPd
         7imyshMKvzwdwzVPsBrfGUIE5lxn8e6WEQKweDPNc1AjHVTRHW74G9FlKkOLwMJBHoPx
         ah3C1vC+4Bgc9vATUJo1PtCHJrOISRjuqYritQoRqbcEfFddg8ODKaYTU2hl7qYl+Jcd
         acpQ==
X-Gm-Message-State: AGi0PuZKDrlNS2VMf3l4fKFjVToQv3ppTXhtVpUYy5OB1vj/y3PjKcoO
        oWyyZ4tU76FdW6s8GRUZGU4=
X-Google-Smtp-Source: APiQypKN0pm4j1A38T2NDteLwArt/IZPZZVBmjJtO+MGEg1XFX2vXkZjdyxrYCpIAipEGsrTY5p4RA==
X-Received: by 2002:a05:600c:da:: with SMTP id u26mr2051692wmm.48.1587109248784;
        Fri, 17 Apr 2020 00:40:48 -0700 (PDT)
Received: from localhost.localdomain (x59cc99b1.dyn.telefonica.de. [89.204.153.177])
        by smtp.gmail.com with ESMTPSA id a10sm30628942wrm.87.2020.04.17.00.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 00:40:48 -0700 (PDT)
From:   Sedat Dilek <sedat.dilek@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Chris Rorvick <chris@rorvick.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH wireless-drivers v2] iwlwifi: actually check allocated conf_tlv pointer
Date:   Fri, 17 Apr 2020 09:40:35 +0200
Message-Id: <20200417074035.12214-1-sedat.dilek@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Rorvick <chris@rorvick.com>

Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
("iwlwifi: dbg: move debug data to a struct") but does not implement the
check correctly.

Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
Tweeted-by: @grsecurity
Message-Id: <20200402050219.4842-1-chris@rorvick.com>
Signed-off-by: Chris Rorvick <chris@rorvick.com>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ff52e69c1c80..eeb750bdbda1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1467,7 +1467,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				kmemdup(pieces->dbg_conf_tlv[i],
 					pieces->dbg_conf_tlv_len[i],
 					GFP_KERNEL);
-			if (!pieces->dbg_conf_tlv[i])
+			if (!drv->fw.dbg.conf_tlv[i])
 				goto out_free_fw;
 		}
 	}
-- 
2.26.1

