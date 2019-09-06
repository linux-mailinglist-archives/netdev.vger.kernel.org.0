Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B6FABD32
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395038AbfIFQBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39681 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIFQBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so7141865wra.6
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jQMyV+x+vaAQ7ys5KCHBBGyiMgYaDxRKLpQMTJgq/FQ=;
        b=UX5yP8RSqHon8OhExykl4xi7t3k6wgETHP5brKXwySgHnAK5P9RiCF9UQ6+yJYW2NG
         br6H51YKqGpRI2KYu0nnNNs5TeqJ3DYKdcNtxJfd44SdPqguap/bTiPQ1Ziij858WPEo
         jeZCmQCCvXwjJSUeHZwCzF/Xzdgkg7K99TgQNsv/onr1rsb8DNyoxHK9DrqG59mfAlET
         apsdZfQjysr0Xdk8LI4btPFXTvz7046uAl+q1Nmnt/I2NLN9LPf6PadXu3g+LexfVh0j
         Kjy/pxGjNgQokmINZswBa5MwK0vOCf/gbZVJKFPNoIxWt57GnGTvI2T4TvJzp7PRf6Ux
         jpFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jQMyV+x+vaAQ7ys5KCHBBGyiMgYaDxRKLpQMTJgq/FQ=;
        b=ju/gYGYNcXkya7XSLGz0hDvqv96QaOCJn+E1N+G9Cnpc2NyXFzli5iadT+ffOOPB7p
         hvYRiGmt3bWFwqHM13O0nfgArRHos7roxM1gz3NNy8XaGIH6lCII4mRp8o8enLo/KYWt
         PhI2A+fG8YbW3ERjFOE5eP9sWcJCXrn+Kd15gD8CEBO+vtkpMltblTcCg/07LSm0C91T
         RRlUp+KOtKj4RwAjMb/a6RSHv4sUzLBdgFcqNJD3LB03Sy4eMsrrFIGjXiEY/7tkwvcd
         ApAyu/YflvuObo+Uy8/fiVwzkg2sB5u7a9yt901CGRP321P5DUyf80JV3Xjq5rqkoE/b
         yoAw==
X-Gm-Message-State: APjAAAU6MeLfjVqXJ6w97aM3m6nxDEj73CacHK/p/9GdCKeCXxjCZgjj
        BJML7BZSkhfk9Xprnwz0AdY5Dw==
X-Google-Smtp-Source: APXvYqyUsPXw6Pn4Z3sDrgAD29Cgx7hIp7BoxnFj3Z0TN/bew3Zd9Eq/Bk4DEZt3x5VOsibiqQMLMg==
X-Received: by 2002:a05:6000:1632:: with SMTP id v18mr8494723wrb.61.1567785677021;
        Fri, 06 Sep 2019 09:01:17 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:16 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 05/11] nfp: nsp: add support for hwinfo set operation
Date:   Fri,  6 Sep 2019 18:00:55 +0200
Message-Id: <20190906160101.14866-6-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the NSP HWinfo set command. This closely follows the
HWinfo lookup command.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
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

