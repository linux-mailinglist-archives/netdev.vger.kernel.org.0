Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA1985AA10A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiIAUqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbiIAUqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:46:04 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3118D56B80
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 13:46:02 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 72so18585881pfx.9
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 13:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=3FATo+4aSu7y8dsoj+GqrdVX/tRMTr67LwXEb3c92qM=;
        b=JDejjNU/A1CEVLmDw/kbCrNbdJoDEXGLDDaIyV9Igs/XsnOsjR1Dc6yu+mvq7kTeMM
         cvw4U0gVZCifDlqJhtwiRsOvulrMamJ1N3LMefiLT5hGizjH0dPJDT5JLnQPTaFNqL7+
         TUAz8UxE1PUEmXH6jTTj+ycsmdoRAwJ7rPHtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=3FATo+4aSu7y8dsoj+GqrdVX/tRMTr67LwXEb3c92qM=;
        b=m387d/4ZDcZuPQQEkuS+4lgFBM8anbhWCqRzCwPwr11jGyF+C+vi4Xac8TC7g2qRFJ
         wHjkkHaDYpuS9l3tKf7LTEVR1MrQyIuW5HmRvGOM5LU6bNPPpP0/5t3XFPtq9XCVuVFn
         JE5++IuMv8hn+3hkTJdEeYSjATOjqS9FGilVuXNNZaVTbm6dXKHDSivUPt/aG1wQue4y
         1a6OGTOQhdCcyMvAIUGaQwRHpDI8Dzsc6tZd5VEmED6mEJTtQbXoDViMOAcNQ26dJami
         yZ58DbiUXW5YBcceqMybkeB9Vb0oGtZ7YEJBFCNMM+Lz+bmXX0ANDOr8Tk3gFIC0I+ci
         HaiA==
X-Gm-Message-State: ACgBeo0x6ieZfkKK3OiUrpbO/sQYVIFRX5V8NtYBNrfNEQfCKkTlml1C
        2/xaekklnR6wE5o2Sr0uI/WwBQ==
X-Google-Smtp-Source: AA6agR5ZsGlC3fTZ03AIuh04jvZ/ffxqC7vYoNL6qJA03Vhg3EK6HLxeudH2vcuvQD4N+aTvr2burQ==
X-Received: by 2002:a63:7843:0:b0:42b:4e77:a508 with SMTP id t64-20020a637843000000b0042b4e77a508mr27570344pgc.449.1662065161707;
        Thu, 01 Sep 2022 13:46:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q3-20020aa78423000000b0052d87b76d12sm23827pfn.68.2022.09.01.13.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 13:46:00 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Andy Lavr <andy.lavr@gmail.com>, Kalle Valo <kvalo@kernel.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] iwlwifi: calib: Refactor iwl_calib_result usage for clarity
Date:   Thu,  1 Sep 2022 13:45:58 -0700
Message-Id: <20220901204558.2256458-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5095; h=from:subject; bh=dXk9FvP8mQV+OU7HzHs8EJnNRxX0VzSl2ssfNfi+TYY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjERoGa6dATzMBuf7tKR2Kr6iz+T5BgWqO5lKzP2H+ tXAHCbyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxEaBgAKCRCJcvTf3G3AJnCEEA CD5yRk+eEyd95e31q9KVFxtiS/4qWSVLf7kkpCTuMDpudMz7nUxKvg7jTXy2XRiRkpqkwS+UxmsAC0 jrtzN1L/iWsq0KBqjH7uw8Qc0nLos6Ya42Jc+ylzkBMLywoVNW0r2a/JBaMNwCxakQa49fCeKKQpsK ufdhJ/oBicA6OA9NXeGWKu5Wlh/ADv+wvCxadKqd0xwppvmQacyvSjIzuV4choGTHjRuRRkG/BTUBf nVuRVuZ1JVPbwD7nZ+weIPI1WvAW8Ky+Xl8Ly6z72DM66Y2nbldOfg0cz6nnTFeHyZysLmhwT/DS6h YkijlAzekNR90QCKm0Qkn+O54AyhRrRZlGYWnXtObOihyPLgfJpBALGdkCo15y0wQ7HccpBHUItsRS vrAY5y1KYcsPG6pfGCEnNpmU8uqCmqoCTc2rfRc03/LUqsp06vfEi91++48DuBo3iPy0Ny4zeBfpv0 Vib/W0vHtvvuFk5JbC7syM6V25NKeSNzb8u8khHd/MQYJrN42LOWkQb8dQ9KgIHb7MDP5FcPES9K1R pPgRp5CqwkCx7b6QG7Z7apVES3Sv8380ZLHZHw2fdsxwxEEQQhfolh45K6mZS5HBHoUuMboyRDMYwD Dm5x1YW9ST0RxrJmoTfUiDOMy8M9lb0SZMkg9a2zpH8W/cz9BOfYNBov8iFg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing run-time destination buffer
bounds checking for memcpy(), refactor the use of struct iwl_calib_result:

- Have struct iwl_calib_result contain struct iwl_calib_cmd since
  functions expect to operate on the "data" flex array in "cmd", which
  follows the "hdr" member.
- Switch argument passing around to use struct iwl_calib_cmd instead of
  struct iwl_calib_hdr to prepare functions to see the "data" member.
- Change iwl_calib_set()'s "len" argument to a size_t since it is always
  unsigned and is normally receiving the output of sizeof().
- Add an explicit length sanity check in iwl_calib_set().
- Adjust the memcpy() to avoid copying across the now visible composite
  flex array structure.

This avoids the future run-time warning:

  memcpy: detected field-spanning write (size 8) of single field "&res->hdr" (size 4)

Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Reported-by: Andy Lavr <andy.lavr@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h  |  2 +-
 .../net/wireless/intel/iwlwifi/dvm/calib.c    | 22 ++++++++++---------
 .../net/wireless/intel/iwlwifi/dvm/ucode.c    |  8 +++----
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
index 411a6f6638b4..fefaa414272b 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/agn.h
@@ -112,7 +112,7 @@ int iwl_load_ucode_wait_alive(struct iwl_priv *priv,
 			      enum iwl_ucode_type ucode_type);
 int iwl_send_calib_results(struct iwl_priv *priv);
 int iwl_calib_set(struct iwl_priv *priv,
-		  const struct iwl_calib_hdr *cmd, int len);
+		  const struct iwl_calib_cmd *cmd, size_t len);
 void iwl_calib_free_results(struct iwl_priv *priv);
 int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			    char **buf);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
index a11884fa254b..f488620d2844 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/calib.c
@@ -19,8 +19,7 @@
 struct iwl_calib_result {
 	struct list_head list;
 	size_t cmd_len;
-	struct iwl_calib_hdr hdr;
-	/* data follows */
+	struct iwl_calib_cmd cmd;
 };
 
 struct statistics_general_data {
@@ -43,12 +42,12 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 		int ret;
 
 		hcmd.len[0] = res->cmd_len;
-		hcmd.data[0] = &res->hdr;
+		hcmd.data[0] = &res->cmd;
 		hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
 		ret = iwl_dvm_send_cmd(priv, &hcmd);
 		if (ret) {
 			IWL_ERR(priv, "Error %d on calib cmd %d\n",
-				ret, res->hdr.op_code);
+				ret, res->cmd.hdr.op_code);
 			return ret;
 		}
 	}
@@ -57,19 +56,22 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 }
 
 int iwl_calib_set(struct iwl_priv *priv,
-		  const struct iwl_calib_hdr *cmd, int len)
+		  const struct iwl_calib_cmd *cmd, size_t len)
 {
 	struct iwl_calib_result *res, *tmp;
 
-	res = kmalloc(sizeof(*res) + len - sizeof(struct iwl_calib_hdr),
-		      GFP_ATOMIC);
+	if (check_sub_overflow(len, sizeof(*cmd), &len))
+		return -ENOMEM;
+
+	res = kmalloc(struct_size(res, cmd.data, len), GFP_ATOMIC);
 	if (!res)
 		return -ENOMEM;
-	memcpy(&res->hdr, cmd, len);
-	res->cmd_len = len;
+	res->cmd = *cmd;
+	memcpy(res->cmd.data, cmd->data, len);
+	res->cmd_len = struct_size(cmd, data, len);
 
 	list_for_each_entry(tmp, &priv->calib_results, list) {
-		if (tmp->hdr.op_code == res->hdr.op_code) {
+		if (tmp->cmd.hdr.op_code == res->cmd.hdr.op_code) {
 			list_replace(&tmp->list, &res->list);
 			kfree(tmp);
 			return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
index 4b27a53d0bb4..bb13ca5d666c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/ucode.c
@@ -356,18 +356,18 @@ static bool iwlagn_wait_calib(struct iwl_notif_wait_data *notif_wait,
 			      struct iwl_rx_packet *pkt, void *data)
 {
 	struct iwl_priv *priv = data;
-	struct iwl_calib_hdr *hdr;
+	struct iwl_calib_cmd *cmd;
 
 	if (pkt->hdr.cmd != CALIBRATION_RES_NOTIFICATION) {
 		WARN_ON(pkt->hdr.cmd != CALIBRATION_COMPLETE_NOTIFICATION);
 		return true;
 	}
 
-	hdr = (struct iwl_calib_hdr *)pkt->data;
+	cmd = (struct iwl_calib_cmd *)pkt->data;
 
-	if (iwl_calib_set(priv, hdr, iwl_rx_packet_payload_len(pkt)))
+	if (iwl_calib_set(priv, cmd, iwl_rx_packet_payload_len(pkt)))
 		IWL_ERR(priv, "Failed to record calibration data %d\n",
-			hdr->op_code);
+			cmd->hdr.op_code);
 
 	return false;
 }
-- 
2.34.1

