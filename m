Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8095EFB40B
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfKMPqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:46:51 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40544 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfKMPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:46:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id r4so1918835pfl.7;
        Wed, 13 Nov 2019 07:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TBVtymOI9WwZsWEvU07x8pNEkzVPUQwttMv3w1HkiJ8=;
        b=mvo2vdSi3TpgqVnEPaWhYlSWv2KwG7IyopXGZJg3fMsbp3v6j1pIvTAVW8UfVQkH9K
         XdEFqj8ztEc9jrMWhZI0oyM3fLG+vzPaurnl13NBHlkvwMQQDhKJ6tjoxWfmuVy3EnkF
         WoqlsNflDPGF0RgSgSo+t5DT/6kTQvRdi+rzdAh/wqLE6FZw2HyT08WjnZD03GNGakdY
         rCCVMbfDRWP3TaNAPYx8WgMgXBxyrbVUACB9X7fOfbiVcpTu4DTMkV9WBeSyi6DAx7dY
         YzujGpVbXJ+ZM7bDbrBcRP2H5GvkH/9WTqLtPyQuonXAb2cs/0VgfHG1ZROKJeg9Ea2Y
         imUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TBVtymOI9WwZsWEvU07x8pNEkzVPUQwttMv3w1HkiJ8=;
        b=cJWfVSNCMkEefci9wmM/TGe3+gPIhXQ7hgUQwP5CfJ9w4nZEW5LCjxbkjEotZRlU0J
         8nlzuvQ6wr2YdopsTQ853Fo1i91DISKroVjLfk5SucRP5jsiyr/iLZPwvFHRWpRFmWT+
         418LV1N6Ri9F4tWTPFbeDCSu5ntmM+5fd3N02DavPKKPFNDYdEm14O9UPIQ0dtpCmI1n
         g9X3sxbBrcrZQgk7yb32gfDPqZbC35IytqCOMCPTAkVnDBFn40GaSdn1JJXZ5nEjkWcp
         AzPaG2h1fdlB9ZIBV2MkUpHsJn1rJEevIlWwU7tEu723lsF2Lpf5ZVPKWB/NkK52g/5p
         I7rg==
X-Gm-Message-State: APjAAAVUZFfScK6acZq7D1LT2q1beUn2i3ITnbSLdOVSdzU9h91WofcY
        dnbDo70EeRWpfsYqBRhP3lQ=
X-Google-Smtp-Source: APXvYqw+4YtAO4BurwCMDsiaBzTWfhVwSTwA+/T/CjKbuQnohvT7t9DtGQo9ioj0WANfV+2kt5VWFA==
X-Received: by 2002:a63:e84d:: with SMTP id a13mr4422751pgk.226.1573660010409;
        Wed, 13 Nov 2019 07:46:50 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 16sm3953091pfc.21.2019.11.13.07.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 07:46:49 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH v2] ath10k: Handle "invalid" BDFs for msm8998 devices
Date:   Wed, 13 Nov 2019 07:46:46 -0800
Message-Id: <20191113154646.43048-1-jeffrey.l.hugo@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the BDF download QMI message has the end field set to 1, it signals
the end of the transfer, and triggers the firmware to do a CRC check.  The
BDFs for msm8998 devices fail this check, yet the firmware is happy to
still use the BDF.  It appears that this error is not caught by the
downstream drive by concidence, therefore there are production devices
in the field where this issue needs to be handled otherwise we cannot
support wifi on them.  So, attempt to detect this scenario as best we can
and treat it as non-fatal.

Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

v2:
-tweak conditional nesting
-add comment in code to clarify

 drivers/net/wireless/ath/ath10k/qmi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 637f83ef65f8..6df2d3ac5474 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -279,7 +279,15 @@ static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
 		if (ret < 0)
 			goto out;
 
-		if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
+		/* end = 1 triggers a CRC check on the BDF.  If this fails, we
+		 * get a QMI_ERR_MALFORMED_MSG_V01 error, but the FW is still
+		 * willing to use the BDF.  For some platforms, all the valid
+		 * released BDFs fail this CRC check, so attempt to detect this
+		 * scenario and treat it as non-fatal.
+		 */
+		if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
+		    !(req->end == 1 &&
+		      resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {
 			ath10k_err(ar, "failed to download board data file: %d\n",
 				   resp.resp.error);
 			ret = -EINVAL;
-- 
2.17.1

