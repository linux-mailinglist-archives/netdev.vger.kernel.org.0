Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4DAD14A
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbfIHXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:55:00 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35704 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbfIHXy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:54:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id d26so11423013qkk.2
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gEiaUTDA5a50+LWsAeRcviNLIrH5IR/RNH30K0Fxnsc=;
        b=a89Iq83oamhl7ecFBzuyR9rXZx6Jmkxxk+eCcaepu9NPQTBihWfz1XchCf1lRQoUf8
         clRrFL6cJOx2nM/QhrZa8XMI50hGu0MBNooJaxbUZPIs2RnJaiQy52WZBq4bomubrZ2G
         icm1bx4DQKoqDmKauo6ygvzn6WBsGJ08fZtxuAi+R2UqKuSF62i10qVuOa/CJT3KE0Xl
         OvxDc1RumM+cF0XYR+3FM3o/IRGAANRzj4EtiS48YnKKdkYBu4bIOyYqY9RGENaSnDdB
         64aNbOsWdrjlr7nYW9EEBHmZIip+Mr5k1HS/OGz+zsotjnOnHElF9ncq4A3F81vVsP+f
         p56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gEiaUTDA5a50+LWsAeRcviNLIrH5IR/RNH30K0Fxnsc=;
        b=n91u8lTdxh/LsS5hJc8kBrBT1k+3Ete/VRzYHyx8/yz2o6JcMvzmeuE1C2+w0cB02F
         j+V7SGUlNHJLbNCx6+gp/fDBRaZuUbdnx8b8cLTOxx4MCLTmQwsX2QiwzcgHOmTvhIKg
         RaeZUV03ux0/WZ+NSNbTdLuYyl/KO5NuSHnV6GMAJ5MIa42+sfRv7eLle9TKs6ZxrYNO
         FGeV1C2eGx0Nuumb9ywWgVs/TS2oeT35+oHg/53msXo1yuTSbfx2vXgEH/ZLR+u5yy82
         nA2DQJ0/qTrEvZ36HpM/ujmyoCGbAJMqLsMpAvptFKSagpJb7BR5ZsZkFz+mgFnYuOhA
         R/pQ==
X-Gm-Message-State: APjAAAVa/E1i8NNo/49TiQjoM8e84IA5f5VVs+TEeV6t43yPhlixT292
        icG23FYSGqTutvU4EqNiBy1wJA==
X-Google-Smtp-Source: APXvYqx/koDZEfdkAcdpj4ySzr3WHXq50u28L9bnYKKCNaNEnIR7qMPdpRmSEW2VLxMeM+KNnQ0CdQ==
X-Received: by 2002:a37:a604:: with SMTP id p4mr19197745qke.58.1567986898926;
        Sun, 08 Sep 2019 16:54:58 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:54:58 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 05/11] nfp: nsp: add support for hwinfo set operation
Date:   Mon,  9 Sep 2019 00:54:21 +0100
Message-Id: <20190908235427.9757-6-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the NSP HWinfo set command. This closely follows the
HWinfo lookup command.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 15 +++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index deee91cbf1b2..f18e787fa9ad 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -96,6 +96,7 @@ enum nfp_nsp_cmd {
 	SPCODE_NSP_IDENTIFY	= 13, /* Read NSP version */
 	SPCODE_FW_STORED	= 16, /* If no FW loaded, load flash app FW */
 	SPCODE_HWINFO_LOOKUP	= 17, /* Lookup HWinfo with overwrites etc. */
+	SPCODE_HWINFO_SET	= 18, /* Set HWinfo entry */
 	SPCODE_FW_LOADED	= 19, /* Is application firmware loaded */
 	SPCODE_VERSIONS		= 21, /* Report FW versions */
 	SPCODE_READ_SFF_EEPROM	= 22, /* Read module EEPROM */
@@ -970,6 +971,20 @@ int nfp_nsp_hwinfo_lookup_optional(struct nfp_nsp *state, void *buf,
 	return 0;
 }
 
+int nfp_nsp_hwinfo_set(struct nfp_nsp *state, void *buf, unsigned int size)
+{
+	struct nfp_nsp_command_buf_arg hwinfo_set = {
+		{
+			.code		= SPCODE_HWINFO_SET,
+			.option		= size,
+		},
+		.in_buf		= buf,
+		.in_size	= size,
+	};
+
+	return nfp_nsp_command_buf(state, &hwinfo_set);
+}
+
 int nfp_nsp_fw_loaded(struct nfp_nsp *state)
 {
 	const struct nfp_nsp_command_arg arg = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index a8985c2eb1f1..055fda05880d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -24,6 +24,7 @@ int nfp_nsp_load_stored_fw(struct nfp_nsp *state);
 int nfp_nsp_hwinfo_lookup(struct nfp_nsp *state, void *buf, unsigned int size);
 int nfp_nsp_hwinfo_lookup_optional(struct nfp_nsp *state, void *buf,
 				   unsigned int size, const char *default_val);
+int nfp_nsp_hwinfo_set(struct nfp_nsp *state, void *buf, unsigned int size);
 int nfp_nsp_fw_loaded(struct nfp_nsp *state);
 int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
 			       unsigned int offset, void *data,
@@ -44,6 +45,11 @@ static inline bool nfp_nsp_has_hwinfo_lookup(struct nfp_nsp *state)
 	return nfp_nsp_get_abi_ver_minor(state) > 24;
 }
 
+static inline bool nfp_nsp_has_hwinfo_set(struct nfp_nsp *state)
+{
+	return nfp_nsp_get_abi_ver_minor(state) > 25;
+}
+
 static inline bool nfp_nsp_has_fw_loaded(struct nfp_nsp *state)
 {
 	return nfp_nsp_get_abi_ver_minor(state) > 25;
-- 
2.11.0

