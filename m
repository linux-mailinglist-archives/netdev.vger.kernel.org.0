Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056F0AD148
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731550AbfIHXy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:54:56 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35698 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbfIHXyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:54:55 -0400
Received: by mail-qk1-f194.google.com with SMTP id d26so11422918qkk.2
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T1rRRwWXT3QaVagLyAOhHwvQqwm/h8f33DBBH5bc+/o=;
        b=M4Mh/wsYZ9d3pgzOt5cvFyhA4WAyHGXj2UrRe5RtNKvzLSrJVIGrZn7XkA4bkw8Wfm
         s0tDUmAVUxsFWrNHHIv5H3pN31EWPNdLNHfjnTDHmdmUsjqsjYBbwkHEiuLZlRQ7aD1A
         iNKyZs8XSfSJLOl2236dnfQmEWf98YxzKoiH4/Y1NR4dvV6Xl6WKHwAaS+MhEtLAyTLV
         vbmhj5TbtizzErd2WSvNbiODIU08xSmtvEXFRh2ysbH7FS8I57xeB9LsEvG9U+QvlM2b
         5SEutxNBpBIauKyEXrNR5OiYfSsXq+ZVQ85w9w+Q0Q0D4j7tPf0aIf3vH+nOWLfmAf3E
         /O0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T1rRRwWXT3QaVagLyAOhHwvQqwm/h8f33DBBH5bc+/o=;
        b=eBIWDXlhMwa5LHtMjhzsl/LJk3SJRR2owRpOROfMxQ6n+cRjT2aNqzjDOWDEr9Z2Kv
         qmVtcYcSEdIK7J3Ap/DJrCScApXCSAREKoNpU/nD/Www3Wv+QYNhiusio1+g6dAHI3YU
         1ZSFsba50IiYPMyfAp29o7YqF1oZs1w2FsqNxx2xn+MR4V/QS7fIqMp6ToHtvsJN+S8r
         po5y332WYSVeMf7Jwv9nip8cj8nDvFLuMpI7ZzdN7iU14veSU7VKJYglaBKnj9kWxA09
         WMaD1qtMbE/VFmSxnN/359vEmlC0BBCk15/0zQHxkWjiR+8SPdrCxU8q7WIJzO21Ek7q
         6xuA==
X-Gm-Message-State: APjAAAXCpbQRIpvTRRo04uvwKDab+RAlzfBSYAa+bvvElMGZN9NMT/WG
        vV+Q5XV5dw86cgUjzxI5FQKv2Q==
X-Google-Smtp-Source: APXvYqznJ95XH6PMeFYf308Dau12mOCbT1pDedWGBtSWydJmkiyXL+cKyUKpUJw4LN3ZTaBpF9z/8Q==
X-Received: by 2002:a37:48cd:: with SMTP id v196mr19830867qka.419.1567986895032;
        Sun, 08 Sep 2019 16:54:55 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:54:54 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 03/11] nfp: nsp: add support for fw_loaded command
Date:   Mon,  9 Sep 2019 00:54:19 +0100
Message-Id: <20190908235427.9757-4-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the simple command that indicates whether application
firmware is loaded.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
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

