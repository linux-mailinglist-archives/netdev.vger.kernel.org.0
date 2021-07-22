Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C8B3D2333
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhGVLfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 07:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhGVLe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 07:34:56 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201B8C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 05:15:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id qb4so8016088ejc.11
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 05:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0PAvrBmP9kB4RveLqnGMDVCPc6Nnkn87XVLSuQdF9BA=;
        b=l+T6zu37Og9eYFD4GQUJeBLxxdrOHFg46E4/+YWvAhuDRgkhQLlc+HyWeXep4kfaEL
         nqHXbzP3UAX5JkaFlsNjcJ2qInqXxaeib4qXUXECZMsFGsuCKDStIS8T4uhe0tcjEpvR
         kmdHye1fPEc/VPqC+CB1bUlQLUsDBKTIWcKQUgNDrUhdL+QTuIMjZ5QcuHtHl3kyW4lG
         U28Pw5OxM+qvR63pJMf+OpaZ9xgGF7G0+s5j2QyJPDMMqtkWU0GdMmjuh3ohYerZRuAL
         Rjv1kT/OeVqv7XESRY7RlIukQI44DPsz9iy1k25hyrxyp0Wmmweqbe93D4lv8vkBz7VX
         5O9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0PAvrBmP9kB4RveLqnGMDVCPc6Nnkn87XVLSuQdF9BA=;
        b=QpulYbSrtj5O1bvRirbjSuG5tBtTAPhTTtGyhVyj2hYZ3O7ow6V1FiJatrpAP9TIAp
         gue2xcE+Cb5QSd1ThHrh06RJZv3B50zU/VLksnEhByLcnxY1gdD4faj8i0f9r6zaOIOr
         E5EmU4SyiL3/50hJxAa5hj4W8DWwUGFJ9zDVbiqV/tPjzdd9rX/c5SnwpCQUDak5gFHv
         oTirUF6iVXVhwRnggGAIiNgaECLVR2SZphI8Y4jAgR+vLeAfGsHF6DJR7gk9js+Cf0Fl
         y1RgiGpIOTkNjt2tI6Ff69Gudke52accMsGtNoGYWVNjPiQ+eb1xhCevSzg/iJS+RRdC
         pnlA==
X-Gm-Message-State: AOAM5338WLnqiesItG140lxtQfeiucFdRWRol1aqrAZUCg16bgKWNHA/
        YEN40htuDU+VdQStM3V/mdI=
X-Google-Smtp-Source: ABdhPJwwy98SEYGa9ZAlWHxFhn4pwgoqSmHgP6riVRgh5DIdnfuiF6F027Jxepb764WIDalGs3dkNQ==
X-Received: by 2002:a17:906:8292:: with SMTP id h18mr44161658ejx.451.1626956128678;
        Thu, 22 Jul 2021 05:15:28 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id y6sm12269604edv.88.2021.07.22.05.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 05:15:27 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] dpaa2-switch: seed the buffer pool after allocating the swp
Date:   Thu, 22 Jul 2021 15:15:51 +0300
Message-Id: <20210722121551.668034-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Any interraction with the buffer pool (seeding a buffer, acquire one) is
made through a software portal (SWP, a DPIO object).
There are circumstances where the dpaa2-switch driver probes on a DPSW
before any DPIO devices have been probed. In this case, seeding of the
buffer pool will lead to a panic since no SWPs are initialized.

To fix this, seed the buffer pool after making sure that the software
portals have been probed and are ready to be used.

Fixes: 0b1b71370458 ("staging: dpaa2-switch: handle Rx path on control interface")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2138239facfd..3d021edb78e6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2809,32 +2809,32 @@ static int dpaa2_switch_ctrl_if_setup(struct ethsw_core *ethsw)
 	if (err)
 		return err;
 
-	err = dpaa2_switch_seed_bp(ethsw);
-	if (err)
-		goto err_free_dpbp;
-
 	err = dpaa2_switch_alloc_rings(ethsw);
 	if (err)
-		goto err_drain_dpbp;
+		goto err_free_dpbp;
 
 	err = dpaa2_switch_setup_dpio(ethsw);
 	if (err)
 		goto err_destroy_rings;
 
+	err = dpaa2_switch_seed_bp(ethsw);
+	if (err)
+		goto err_deregister_dpio;
+
 	err = dpsw_ctrl_if_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err) {
 		dev_err(ethsw->dev, "dpsw_ctrl_if_enable err %d\n", err);
-		goto err_deregister_dpio;
+		goto err_drain_dpbp;
 	}
 
 	return 0;
 
+err_drain_dpbp:
+	dpaa2_switch_drain_bp(ethsw);
 err_deregister_dpio:
 	dpaa2_switch_free_dpio(ethsw);
 err_destroy_rings:
 	dpaa2_switch_destroy_rings(ethsw);
-err_drain_dpbp:
-	dpaa2_switch_drain_bp(ethsw);
 err_free_dpbp:
 	dpaa2_switch_free_dpbp(ethsw);
 
-- 
2.31.1

