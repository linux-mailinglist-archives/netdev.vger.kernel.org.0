Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFB35BA75
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 08:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbhDLG6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 02:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhDLG6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 02:58:32 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7772C061574;
        Sun, 11 Apr 2021 23:58:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d124so8559092pfa.13;
        Sun, 11 Apr 2021 23:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R61KIRW9eJhAauoZ++ww3cJarlsZLJBuOebMWuzeCs8=;
        b=PhRRBRVM13us4+Vnnf8O8QY/seKGZHYKcHE/fmGn3iNXzY7+dyQkfelUrbJdeLHJ3y
         gAYiqylMaDfzvVd2UJhKJ6CnGZrMLW3RA54wCwwZO5caSQodJkxOFN4C/ebVnSRtkdw9
         8FR2Dv7EGlbLsf01Be0tnY9rTlQszP2qDn4tsnR4tXkL0DqQcEw3WMVElKNhhcaV9awS
         1R+I3RvtuvY/4IChSM93U17e6yqlgI2FSQ5qHZjI/dTGoafISCnCn2nRjMsPh53dv8XA
         5gnuZfgxqwYRMndVboB9ir/7ypLJFCPYO5opFKzLvIxNgIyBmNn8i40+PinSy556sL7i
         HuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R61KIRW9eJhAauoZ++ww3cJarlsZLJBuOebMWuzeCs8=;
        b=pevcait5MnWBuCNMRwPl9op3a4LsskgB2A8L1OtNCpwf9gHsiR/lGJXY9il/k3/6/e
         T4dvEBwlxMPUClj1HZxoq/GtkFSMVClQ1H2o2iQIQGLptt4uqVhRhtzfHhfu0On5n2CY
         bs4MiG2uBcapQhhufyqv6g7dxPlp5NQBe2wDaMhWzdZcqiCCd7K1Ash9sEiWph51G1VR
         6t4StrW+ztMDF5u6Wa7mNq13Go3z0FyF01PAyZ6ULWd/qMFUgo5LwkAPaTCreBCyD/20
         dDBPIyafcYUi5pXYTzg1uZUxd1jHlrzgTNe2oK8pKkjnfUQugMA/T+2uJYS0Uk31exUT
         kzDg==
X-Gm-Message-State: AOAM532Xq5jc/gfG1CHV0eMQh4aEAcrR84k5YtBzPlNlUqrP9PwhsMDo
        lGZp4R4oeLCUq+hOH+/DOVQ6RO3vkyJ6y0tb
X-Google-Smtp-Source: ABdhPJyK4C7wwWmayAbPvEzyPx4pgsKzynqeaIvEX0hhz9GCmhkg6IQlCYZxQsqm7Or77mnPisyOAw==
X-Received: by 2002:a63:5f0c:: with SMTP id t12mr25183838pgb.381.1618210694278;
        Sun, 11 Apr 2021 23:58:14 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.203])
        by smtp.gmail.com with ESMTPSA id v135sm10538992pgb.82.2021.04.11.23.58.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Apr 2021 23:58:14 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: [PATCH] i40e: fix the panic when running bpf in xdpdrv mode
Date:   Mon, 12 Apr 2021 14:57:59 +0800
Message-Id: <20210412065759.2907-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Fix this by add more rules to calculate the value of @rss_size_max which
could be used in allocating the queues when bpf is loaded, which, however,
could cause the failure and then triger the NULL pointer of vsi->rx_rings.
Prio to this fix, the machine doesn't care about how many cpus are online
and then allocates 256 queues on the machine with 32 cpus online
actually.

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

