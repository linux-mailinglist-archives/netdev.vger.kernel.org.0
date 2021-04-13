Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A456F35D575
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 04:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343494AbhDMCvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 22:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbhDMCvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 22:51:18 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E5BC061574;
        Mon, 12 Apr 2021 19:51:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t22so7090545ply.1;
        Mon, 12 Apr 2021 19:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WaHFfcPJ+3sbinVxpYP4an1fZeysBF2p9bqkO0Z0pX0=;
        b=DUQ2t+iTufRRuZYkeivDWWd32fAMqbNXdhJDaQbsV0X9TXy0FEoY1IldrssVcRzxMc
         JSx8+fo91BqVPXqj6Tm5ijI8O+P3pSVE0uYfwRBUUGavmlspuQVqfQgAsSYMXancRMG0
         xbegYnk9XN58NVz6I3JRZbOtQA3YehpMzi6FPzblBG1APSR5Uoft7prwTCFfDWAkEq8o
         /t+IVHmjZlkD8IoU65Lc75rLh3cp4GxGDxQuaG+g9B52UbFgw4rgevwYit3/pSCvhRUu
         KaLEbJiBCVtZzbs/APC0TvuiRjAY070c7uNlCLt0/qp9uE7n6LnaP7JqULKPTAyOJsa2
         FsFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WaHFfcPJ+3sbinVxpYP4an1fZeysBF2p9bqkO0Z0pX0=;
        b=YnZCwnakulAfR8mYMDccz9T5YxpJgLlPiXlZ5FsyIypcHjBz2ypJe31msjWNSFe0d7
         WPOoQ6jQabblMq9fq/YPhwRSeVLPGZOd72BaZwOfc5WeSMqsZlVV+Arfig5sRlteR6vz
         5Natj5J9V0cUW9sP/gMnH2x8q0vX6P/+6hwMdLApMFnAGFw0K6GuGkGLvF50C3SKsf1x
         veTBZeRN/InmS1NC1nois7hNVgUDmSIq7yyqNRWheRV+MBh/R3mMUht4fzDizQ2tlGLt
         XJOfMEU/9KLktzm+BkubUrWDWXFP1NrrIECZMXOpyKz7cHDXicbsavhAi4x6rI0gdnsK
         NTBA==
X-Gm-Message-State: AOAM533QpKZuzpx7wg33lZAc15tWVEZHaZ7eD3kK+oryExU11ud3sihm
        SQ8VQ+fYjmuBXcMJsbpbqUc=
X-Google-Smtp-Source: ABdhPJxt60DfDVuddlrs0naNoU9IsplaxpKwBU5kVTKr83wquWneKpDo+5UfVHg+pU1Jhk7bbBM7bg==
X-Received: by 2002:a17:90a:7f8b:: with SMTP id m11mr2317105pjl.221.1618282259705;
        Mon, 12 Apr 2021 19:50:59 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.203])
        by smtp.gmail.com with ESMTPSA id f21sm633093pjj.52.2021.04.12.19.50.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Apr 2021 19:50:59 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: [PATCH net v2] i40e: fix the panic when running bpf in xdpdrv mode
Date:   Tue, 13 Apr 2021 10:50:11 +0800
Message-Id: <20210413025011.1251-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20210412065759.2907-1-kerneljasonxing@gmail.com>
References: <20210412065759.2907-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Fix this panic by adding more rules to calculate the value of @rss_size_max
which could be used in allocating the queues when bpf is loaded, which,
however, could cause the failure and then trigger the NULL pointer of
vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
cpus are online and then allocates 256 queues on the machine with 32 cpus
online actually.

Once the load of bpf begins, the log will go like this "failed to get
tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
failed".

Thus, I attach the key information of the crash-log here.

BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
Call Trace:
[2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
[2160294.717666]  dev_xdp_install+0x4f/0x70
[2160294.718036]  dev_change_xdp_fd+0x11f/0x230
[2160294.718380]  ? dev_disable_lro+0xe0/0xe0
[2160294.718705]  do_setlink+0xac7/0xe70
[2160294.719035]  ? __nla_parse+0xed/0x120
[2160294.719365]  rtnl_newlink+0x73b/0x860

Fixes: 41c445ff0f48 ("i40e: main driver core")

Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 521ea9d..4e9a247 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -11867,6 +11867,7 @@ static int i40e_sw_init(struct i40e_pf *pf)
 {
 	int err = 0;
 	int size;
+	u16 pow;
 
 	/* Set default capability flags */
 	pf->flags = I40E_FLAG_RX_CSUM_ENABLED |
@@ -11885,6 +11886,11 @@ static int i40e_sw_init(struct i40e_pf *pf)
 	pf->rss_table_size = pf->hw.func_caps.rss_table_size;
 	pf->rss_size_max = min_t(int, pf->rss_size_max,
 				 pf->hw.func_caps.num_tx_qp);
+
+	/* find the next higher power-of-2 of num cpus */
+	pow = roundup_pow_of_two(num_online_cpus());
+	pf->rss_size_max = min_t(int, pf->rss_size_max, pow);
+
 	if (pf->hw.func_caps.rss) {
 		pf->flags |= I40E_FLAG_RSS_ENABLED;
 		pf->alloc_rss_size = min_t(int, pf->rss_size_max,
-- 
1.8.3.1

