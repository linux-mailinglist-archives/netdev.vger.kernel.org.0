Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CA1377F86
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 11:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhEJJkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 05:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhEJJk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 05:40:27 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FA8C06175F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:22 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n205so8803354wmf.1
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 02:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vrGRBMEMBYdn7xsdOu9Vp0GY4DXrITa4gzZ8kQN2zME=;
        b=lOP0IvOfVhJVX0SdpTPVUaZmw0YtS+95e8JoBC5851SxngZkPhF9z4HPVov4sHZX3u
         +J9ik7XLJXmoaLDGL6W5wVSxBxI/Fsup3m/0L4XJ9stAQ5KNb3FuBSCreAYU2Jd2YLOZ
         SLx4uSVYt3X7XX9FEbHB1QX3Ys9MW2ltz2PXY02uEvywx6ccPdhfsx30q3KEn592iNEg
         rbD91S9HLV4eNq+ZbGwkx9cn5b8nsfp5p4RnzInb9MQ0Z15ZpCqGS1aRA/s09PQr/EKc
         UFMYIk/vy2HM6uJpVMlKLKYcQdSfw4h+USggPIaoc2hyQJvG6rOw+QWU6nK5oePsm4LM
         uPDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vrGRBMEMBYdn7xsdOu9Vp0GY4DXrITa4gzZ8kQN2zME=;
        b=f0Dzu11fdxNsYKawOhnoTyFsSTR18gI083XbrrHtkj9xUfJ4TfgLSPgxpFa0P36MIS
         pcdhbP7fAKlcCK/44vdJ4KY8CTv8/4AaClMNSLC5XsDXt6175SOR9eX8rU6BGM1+cXXf
         h+l+RqFbHI6WWyeav6XIgoDVfcZu2a4d6paf5mcrJHjsqjM5CTpxkmHNi7j1P+EJpAD1
         ytzhcoxp7bmArm+2eryPQHOA1bzGcJ3BXlxIf6r5/dbVRpLh3XTGY88vgikJiCHQPUrF
         BUmBkFt9bx7OHd8I5deAHvd429FgCXKy1utYU0D5/tRXs5aO6kJTYf3QKJwBwRq/L7DT
         uPrA==
X-Gm-Message-State: AOAM533gxWvE5aQUL0zHIngvrkHoNmF1VYGppFqFVYZJt9eyyrJKKE9y
        fDR2SD152ZeQ1/mxIwAYziw=
X-Google-Smtp-Source: ABdhPJxDq6hQN5O0/HVqWr9ddKcumjxbGtyJQZShCuo/z//KHYAFqRunTQkKv+3Vr8NNXS3Jm4G5MQ==
X-Received: by 2002:a05:600c:154a:: with SMTP id f10mr25597527wmg.31.1620639561387;
        Mon, 10 May 2021 02:39:21 -0700 (PDT)
Received: from localhost.localdomain (h-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id i2sm25892933wro.0.2021.05.10.02.39.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 May 2021 02:39:21 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, brouer@redhat.com
Subject: [PATCH intel-net v2 4/6] igb: add correct exception tracing for XDP
Date:   Mon, 10 May 2021 11:38:52 +0200
Message-Id: <20210510093854.31652-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210510093854.31652-1-magnus.karlsson@gmail.com>
References: <20210510093854.31652-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 038a9fd1af44..004a5b15fadb 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8401,18 +8401,20 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 		break;
 	case XDP_TX:
 		result = igb_xdp_xmit_back(adapter, xdp);
+		if (result == IGB_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (!err)
-			result = IGB_XDP_REDIR;
-		else
-			result = IGB_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IGB_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-- 
2.29.0

