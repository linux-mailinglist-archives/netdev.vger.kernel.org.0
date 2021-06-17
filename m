Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B4F3ABA49
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhFQRMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFQRMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 13:12:05 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D97C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 10:09:57 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id n12so5439330pgs.13
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 10:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W/S32u3ekjPeReAIcSVPK84B3McfcY02qau4OC949Fo=;
        b=IgBimoOgYkL5HrKYTQgnDtuqkUgHEAELBT8PhXEEbGPQV3ZILOOxH6uqp64AzPyQ2X
         L/4CEMA5zwqvjlsbdhNLPR2cL0rk08cu5TFNds7PVrz5UMVqPyiCHnot3r+39vCeOX89
         8hVNW/j3mhGRLTHhXTiog5Qz5L1ykBrnaSqj0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W/S32u3ekjPeReAIcSVPK84B3McfcY02qau4OC949Fo=;
        b=JLR86mmtHUZMrxkxcRnl37TJmH0njcmTusD4vFxxgiACcaP36jLNJUSZ4YrGCcRkub
         VEjIPvkgYdm7RBj8DCQfIChZSVdFGpnHvRUUILyoaocXSiyXXHaZNyZ77s4DKX2mOGHf
         xoAG9+wBIdf+WeMyNwKdkQiq7wvUoOiy/Zdf2lUIGJJnJLY5qfdeVRSFEkTHEQ8IVq5P
         UkN5UwaVLb3WmWp2AdPtVejHUT2Wtw3B8WGwYqzsGs6TfcFoeyhMtgu1za6+wNNEckLD
         Jca9NWNmaWJE36oMwW3a7/cjyuaRZD8rehpOIFDTHRoE2lJIRFHqmdb12WtLHe64yD02
         oX3g==
X-Gm-Message-State: AOAM531ciAe9bWknecNT/m78jzZitniiKS+1sUBrcI0GY4YKF7qQgHie
        vxu+ygod4lXNZ0/1Exq/kqwO4A==
X-Google-Smtp-Source: ABdhPJzfVVxxl4/obG5AKUZMNwwQGXdHf6ZfEgj/rA3dG8YJz6YKHXafcOT6QkyYzgFsV8lcWYA1Og==
X-Received: by 2002:a62:1b91:0:b029:2fd:2904:938a with SMTP id b139-20020a621b910000b02902fd2904938amr733177pfb.18.1623949797155;
        Thu, 17 Jun 2021 10:09:57 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n5sm2589727pgf.35.2021.06.17.10.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:09:56 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Kees Cook <keescook@chromium.org>,
        Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net: qed: Fix memcpy() overflow of qed_dcbx_params()
Date:   Thu, 17 Jun 2021 10:09:53 -0700
Message-Id: <20210617170953.3410334-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=7ee16d0c85b43265f1b056049a01025c7810232c; i=7UynV2bzrbyVcxIExxwAR2qPDHrjOVlt1/0kMWRdngo=; m=2tWE1O18O7/RX9jY2E+cZNsP6H6Af9JdA55eVc/s3NQ=; p=h9rajczpeiIMkXn0tERvoj5tzIpf9alLTkjRcrTfInk=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDLgeAACgkQiXL039xtwCaa7w/+MUC Jj9Che+mSHBlh+Ij5I0hZF4uNeub1HtZ/Nj23qSxIJ1tgPUpZItnEW+cgd8fW7QW+oAV9TCACXYlo 19vn/7m1UAR8oa3pEc2Wdl/zxCJHbrIHH2FF+4Rv1G0Z50pWCZAMsH+o+V+h9t2pOn8/yOp7Am6Ng 4TYQT6wLcffX4W+Hy3a6xtJ3+55r/5Ogd0AfdBKgAUIbHS/DQQv26HMshKHYgfmRMX1MCgUR9he84 kt6Eu1cY8ecJBnlzcF3vjdIIqc8Gs5pLLCVfo1fJ0taHEdQEc3JFmq1UUOMD7bGzcw+rcbWQFNH1r OWRzajC+s1YGUUuhv6Cf47xDFrgvxsODGf+qm6FHsQ+pIYv2iGyrh7unpaVjdZNGJqm3hHZ4AIw1g h7z83PMBsdRlk/kaJZ/D/bA4nC5u+FgGcVljfhbAKddUzsnLF1kzS1F5HXY6HM/uQOKOYYk09Zhvf OKAOdWu62fIPaKDvXjlENb557CaH3/qV0DwV82EMVGhkOY9VxoWhEWaKaVZcenVIOP6bDH/WQTbyq 5BMbcJXhP0RpaNqrbJoXQxtIM3m49YRr0zc4dANKxzpWSlBZCtWlbAwaWvr2x3L48xg5iCgmOXkHV F/olOjqrMYtTy7dS0d76YDEJUtJXVKgRW43aLOhN79hMfPyU4DaGbDV+9ygASAas=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The source (&dcbx_info->operational.params) and dest
(&p_hwfn->p_dcbx_info->set.config.params) are both struct qed_dcbx_params
(560 bytes), not struct qed_dcbx_admin_params (564 bytes), which is used
as the memcpy() size.

However it seems that struct qed_dcbx_operational_params
(dcbx_info->operational)'s layout matches struct qed_dcbx_admin_params
(p_hwfn->p_dcbx_info->set.config)'s 4 byte difference (3 padding, 1 byte
for "valid").

On the assumption that the size is wrong (rather than the source structure
type), adjust the memcpy() size argument to be 4 bytes smaller and add
a BUILD_BUG_ON() to validate any changes to the structure sizes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index 17d5b649eb36..e81dd34a3cac 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1266,9 +1266,11 @@ int qed_dcbx_get_config_params(struct qed_hwfn *p_hwfn,
 		p_hwfn->p_dcbx_info->set.ver_num |= DCBX_CONFIG_VERSION_STATIC;
 
 	p_hwfn->p_dcbx_info->set.enabled = dcbx_info->operational.enabled;
+	BUILD_BUG_ON(sizeof(dcbx_info->operational.params) !=
+		     sizeof(p_hwfn->p_dcbx_info->set.config.params));
 	memcpy(&p_hwfn->p_dcbx_info->set.config.params,
 	       &dcbx_info->operational.params,
-	       sizeof(struct qed_dcbx_admin_params));
+	       sizeof(p_hwfn->p_dcbx_info->set.config.params));
 	p_hwfn->p_dcbx_info->set.config.valid = true;
 
 	memcpy(params, &p_hwfn->p_dcbx_info->set, sizeof(struct qed_dcbx_set));
-- 
2.25.1

