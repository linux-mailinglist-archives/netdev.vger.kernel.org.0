Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE4513872
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 11:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfEDJdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 05:33:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40831 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfEDJdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 05:33:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id d31so3932552pgl.7;
        Sat, 04 May 2019 02:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=o4j1T5yZ8t1V9WsJtSUZ/pyrVijvIYHALD8xyZnCv2E=;
        b=SDHqbOWQEYpiZtXu9miV/f1WNH8j3fcQaHDOtq5uS8LwdVNSkLhLyyx36zJAg7RCmr
         Inxs90oOWKzevhvzRfjiCRvTeYB34gF8BrjRgP7/TViod7RwfEnJQKWlKT8ep+mmdPwU
         CPNPN0j1XADrukqawuWKSDKXo+ZFysVq8G3HNEoGkFSlrwJ7f0/aFG9IhZIVcl22JeCh
         JYVj32eXCfvrIH8YtEoUGNLFjUaT21ibQ5OTawXZaYy5/uuwqJ9pVp92ZsoAPygPBCXB
         s0EDWtYiWny6ZgrmEEDVneEG5uC0rUzlVsfhH3BLAPcm47fkQ6T8KyveADPztz9Bggu7
         TYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o4j1T5yZ8t1V9WsJtSUZ/pyrVijvIYHALD8xyZnCv2E=;
        b=KsG50sgGCbINc04GRIFsehsmWMc1E6tK1BsJg9k1oVs+P5KmC6hmEydEEbPGzxtgdA
         AO1zCG4JiTomG9+BP1ZzdHHMXMK6tyF7ZZ2d0Prp9b3Hp1wkqnz5MwLFVpr4KolHnvok
         0MpKV58pXhF5shJfeTponh8rg0go25OwQ9mCDQMmBd3ddEVq/ZSJZ+pecR9Nw98wnxj2
         kTTX2okVCayubyDilZ/kvk0Xeke+wkR3giW/PZQ8sRJqxxCdy32K9tLyox27sh9Oqj24
         GN/IMBl4Jy+rvp8NvBVb3DxkuZb6MH7rztp13al3V9JRvfyLmKA+hjycXFHnzp7a0Pb3
         YECg==
X-Gm-Message-State: APjAAAUN/IjUEEUx1+x6MGMZQHK72bt6RoLs283yl7f3rVHHATmM5/tX
        k84E/xHwQFrgSQvV7GIgoSQ=
X-Google-Smtp-Source: APXvYqzV4He6PXMEm+3iAAIH0Opk3nip8WWLlYkb+jO2QDLwqHbCyPYdLwu7oQ3tzh6qUUhnW3i9Sw==
X-Received: by 2002:a63:5057:: with SMTP id q23mr17508361pgl.30.1556962394911;
        Sat, 04 May 2019 02:33:14 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id j22sm6066243pfi.139.2019.05.04.02.33.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 02:33:14 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: iwlwifi: Fix double-free problems in iwl_req_fw_callback()
Date:   Sat,  4 May 2019 17:33:05 +0800
Message-Id: <20190504093305.19360-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the error handling code of iwl_req_fw_callback(), iwl_dealloc_ucode()
is called to free data. In iwl_drv_stop(), iwl_dealloc_ucode() is called
again, which can cause double-free problems.

To fix this bug, the call to iwl_dealloc_ucode() in
iwl_req_fw_callback() is deleted.

This bug is found by a runtime fuzzing tool named FIZZER written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 689a65b11cc3..4fd1737d768b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1579,7 +1579,6 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	goto free;
 
  out_free_fw:
-	iwl_dealloc_ucode(drv);
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
-- 
2.17.0

