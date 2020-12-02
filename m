Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECEF2CC058
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 16:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgLBPIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 10:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgLBPIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 10:08:23 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ACFC0617A6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 07:07:42 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h7so691461pjk.1
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 07:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D686hSiICwbI3KAxIZ+IHOTQOCH5FGtz5n2ONqK1CCI=;
        b=icskpsMgacpPpGanJiD9g39ACv0k53x49q4iDbl+CC1kVFvPKV4hsAa2Okas6HnW2s
         Ijy2IPvgRjZfWQJZ81YhvXS5Y23gL/CWuDTfNtiW0Apt0/lZy4Ibsyci/pjIZe0tdFO1
         VHR1D0KFd07ruaZxwh4Xl525ChrSckjmV1JkfMilc1eik5udgPKlCdfa06vKiJcCFAlg
         xnllZCh7f8ZM4nbeT6aRERzIj8FJ7W/xrxzUVwGJ3YRn30TGYS3wI30XgCUNfvpaDP/R
         l8IRhCbVqzJXtDO2IE1P1mWOHKLkc/A2wNPeCmDAOQlKeLvwSrFzisGQ8hhzlvXIhjKy
         +4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D686hSiICwbI3KAxIZ+IHOTQOCH5FGtz5n2ONqK1CCI=;
        b=l0/GIlSfZbx5ZXSweq1LynAsw4tzEiuk7jPQ1tspQtDi3WUnX6VxeaTJyLUp/8IJ7z
         jPQ+/SVBf/krAT2LOfbbEqTHsZw0HjfHdpE60c18XNMTyuIqjt84uHwSZWDZadjX6Y/P
         ehrVll5+nvzlqLWYNmPo9tTKP8ATQMxIdblWSTueAkNeNR3Rp+fuDd0uil/PTUs4G7KY
         gqxefq5cX36ALdoyt8dIJL8gwE+O66PdkJDcb56nE6aeCWcoJrWPU34srXABQBp8uN+6
         uo+k3fSmwLNs8RfduK0nzHL+IY7lEPkrWE+8lHDpOHO+YsviL0in/R3Vv9ZGGqH5x6l1
         7LOw==
X-Gm-Message-State: AOAM5337HOAnxbN1QtYAl3t/xVBL6vGtMXeExDvp2uK6P1aOnK+Ld5vU
        FxRtzy+1aQFYry8AQBGbRlI=
X-Google-Smtp-Source: ABdhPJxHIVLfr1VpNqQzLD/yEFI0hz/fSIAdQgOpKPK4ZJjBGPbz7kr3m+/sKrUSZLc4JdSLEBmJeg==
X-Received: by 2002:a17:902:7606:b029:da:246c:5bd8 with SMTP id k6-20020a1709027606b02900da246c5bd8mr3075082pll.27.1606921662592;
        Wed, 02 Dec 2020 07:07:42 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id p21sm148537pfn.87.2020.12.02.07.07.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 07:07:42 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH net-next 2/3] ixgbe: optimize for XDP_REDIRECT in xsk path
Date:   Wed,  2 Dec 2020 16:07:23 +0100
Message-Id: <20201202150724.31439-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201202150724.31439-1-magnus.karlsson@gmail.com>
References: <20201202150724.31439-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Optimize ixgbe_run_xdp_zc() for the XDP program verdict being
XDP_REDIRECT in the zsk zero-copy path. This path is only used when
having AF_XDP zero-copy on and in that case most packets will be
directed to user space. This provides a little under 100k extra
packets in throughput on my server when running l2fwd in xdpsock.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 3771857cf887..91ad5b902673 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -104,6 +104,13 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	if (likely(act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
+		rcu_read_unlock();
+		return result;
+	}
+
 	switch (act) {
 	case XDP_PASS:
 		break;
@@ -115,10 +122,6 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 		}
 		result = ixgbe_xmit_xdp_ring(adapter, xdpf);
 		break;
-	case XDP_REDIRECT:
-		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		result = !err ? IXGBE_XDP_REDIR : IXGBE_XDP_CONSUMED;
-		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
-- 
2.29.0

