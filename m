Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 630B7ABD33
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395034AbfIFQBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:19 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:36149 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389620AbfIFQBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:16 -0400
Received: by mail-wm1-f54.google.com with SMTP id p13so7710203wmh.1
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ztIrhpPXGgpR6CRxJyU3cxdcXT/xvKpS3PfOJtbETmA=;
        b=y+aUEDLclY2jDSA8UOnLJ8/MWADfpWC/qV45mQRq3m4CCE7Wdl1r88X5crjyEBWLyw
         gIqjKWfo/nZJGRpZHA/IJ2wSLNjQBV8TQtpdYjABuF8fDWrUOsCtTdRirptYT1INAQb6
         Z5cc+RFUJ0dDT64gciLstmFv7UizLLKALbQgymwxkCZY95yFfGwjRTdvnE7jpc6cjBan
         nGA+Rack2S3ZJ1bOq1MqWrY8/1MXHCiVO3UOKnI955esuywhK93/Ig6lumEMzzlzRd0l
         sk5sDaZ0Uou/NpdEyIsUX6MBfkhfeOEpLE7nI+Q76tzMz/reeYGUqk7x15vojpYNyMFE
         sDTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ztIrhpPXGgpR6CRxJyU3cxdcXT/xvKpS3PfOJtbETmA=;
        b=C7+3ukQp32++ykkr5GAgImE2bQ0dEnXxiUg/Kr2pIwqI+s6xqUz14mp6rbYLy/tQyL
         LBRgtKsZSDi3sCWXwb7q0C4/4h2bcENT8MwuRCacY3pVMW963JKCZd77Ypw2fCUmCTNm
         PJ6hoh27xCUsnEW12okeUTlKt9SajVMa0i7EVAI7texxMS1pGF7/OGGRzfeg8uQjTXcO
         0tODv+A4teK0wgc+pYBVWQThOUTEgJbl+oJTOrphI3ZRrBnSM6AcSDcknYhvuyVgMPTq
         O3xzjserukbPZSphqSiP6mu4EUiXOysV6RyJEsYnFU21fhMrW41izdoAUH3X3W01anzc
         YQSA==
X-Gm-Message-State: APjAAAWU43bVS2Zi4NkrEFEjzl6eG801JjUCha/0tkg4Jiwq3A8OBU0D
        DGk65cMN37yxxFtDNWGEJwJnesCCo+w=
X-Google-Smtp-Source: APXvYqzRfOuURmpriep7aXoYbQRJkcfBAFfDGiEBWNgbFSrco0LZuOyBeXpHIsJPzXVRjPMjTnnJ2A==
X-Received: by 2002:a7b:cd12:: with SMTP id f18mr8180279wmj.111.1567785674712;
        Fri, 06 Sep 2019 09:01:14 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:14 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 03/11] nfp: nsp: add support for fw_loaded command
Date:   Fri,  6 Sep 2019 18:00:53 +0200
Message-Id: <20190906160101.14866-4-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the simple command that indicates whether application
firmware is loaded.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 10 ++++++++++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 9a08623c325d..b4c5dc5f7404 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -96,6 +96,7 @@ enum nfp_nsp_cmd {
 	SPCODE_NSP_IDENTIFY	= 13, /* Read NSP version */
 	SPCODE_FW_STORED	= 16, /* If no FW loaded, load flash app FW */
 	SPCODE_HWINFO_LOOKUP	= 17, /* Lookup HWinfo with overwrites etc. */
+	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
 	SPCODE_VERSIONS		= 21, /* Report FW versions */
 	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
 };
@@ -925,6 +926,15 @@ int nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size)
 	return 0;
 }
 
+int nfp_nsp_fw_loaded(struct nfp_nsp *state)
+{
+	const struct nfp_nsp_command_arg arg = {
+		.code		= SPCODE_FW_LOADED,
+	};
+
+	return __nfp_nsp_command(state, &arg);
+}
+
 int nfp_nsp_versions(struct nfp_nsp *state, void *buf, unsigned int size)
 {
 	struct nfp_nsp_command_buf_arg versions = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 22ee6985ee1c..4ceecff347c6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -22,6 +22,7 @@ int nfp_nsp_write_flash(struct nfp_nsp *state, const struct firmware *fw);
 int nfp_nsp_mac_reinit(struct nfp_nsp *state);
 int nfp_nsp_load_stored_fw(struct nfp_nsp *state);
 int nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size);
+int nfp_nsp_fw_loaded(struct nfp_nsp *state);
 int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 			       unsigned int offset, void *data,
 			       unsigned int len, unsigned int *read_len);
@@ -41,6 +42,11 @@ static inline bool nfp_nsp_has_hwinfo_lookup(struct nfp_nsp *state)
 	return nfp_nsp_get_abi_ver_minor(state) > 24;
 }
 
+static inline bool nfp_nsp_has_fw_loaded(struct nfp_nsp *state)
+{
+	return nfp_nsp_get_abi_ver_minor(state) > 25;
+}
+
 static inline bool nfp_nsp_has_versions(struct nfp_nsp *state)
 {
 	return nfp_nsp_get_abi_ver_minor(state) > 27;
-- 
2.11.0

