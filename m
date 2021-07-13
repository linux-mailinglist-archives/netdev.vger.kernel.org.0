Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382983C703F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhGMMXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbhGMMXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:23:33 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21210C0613DD;
        Tue, 13 Jul 2021 05:20:43 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id p36so9699181pfw.11;
        Tue, 13 Jul 2021 05:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N12Qt0FbX8/A1qRMnGp6XJs1s3QP6zmQUn6Y4fY3u94=;
        b=hfylIuaTT2n81A+A5vS0z3hJLKe3dvZTZw1MoT9Kpifs+cFkL+LOJ9zq0o130wRkqe
         nnp+KeDfqvAkInKZO3PvoCSx5716riVxvltU0TobGnesfnbMUAFW1AExyChi37nacWKK
         OywwrydZum1BJGoqpIU5hjWDX6+XFc9b2T2t+5qkuPJtlaXoeXcjAKFgKie8bZgh9nrI
         I8Q4gIIn5jIS6T4NcUR3+MOqgVaH3zA2j18/gTyjVqaagGUymW4TV7U4uV7ZCXYxHbe1
         BrvS8Sce5SrcltkHn4cuuqSxCL9nncOx7u9/iD9b783lq50K4aDs0ZE6sPge+FHGuLxn
         SkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N12Qt0FbX8/A1qRMnGp6XJs1s3QP6zmQUn6Y4fY3u94=;
        b=l4Pw72NF55FxfhElqKtW9h6c1ukdUfe5kdJ1IS+PI6Hwzl9fosSwhntA4r2YGzcPio
         xy2UOPODQv5cQxhRnEn7a2BZJNmGHWCk81dsNZiiIwjHEfRIS4O5+h4//kFlvnBQrhwk
         RAH1vDN9zSogGpVogPG43QqSo4rRVsvrHKnhLdLrWcoPVdQ2bhmYTMTX+PiqwUDI9QiP
         1Wk6Rnws7ylkAd2je4y2Kgstc5d7hLd7XMCZZVX2S/qkbNo7mk7vwl9xRfmvVEP1mNyP
         6oOIidaMbobP77zzEoHZpM5jPqoBa+oOjrG+7rZSDX6IPf6Sft5KLyiGmAGGjdfSq8MQ
         a98A==
X-Gm-Message-State: AOAM532n0e7ohkcLcQfdV8o2gqPpAGEycJyifQm5I89UYMlcHAk+Ueai
        QPeDpool9Zin/iss2BUip7k=
X-Google-Smtp-Source: ABdhPJxPMiF0vYDmisrDv8/T6niOAkHikVbq4qnURKb/AumrClNXbcI7A+KC4w3ocfGZkTX2IrtuXA==
X-Received: by 2002:aa7:90c8:0:b029:32c:935f:de5f with SMTP id k8-20020aa790c80000b029032c935fde5fmr4380311pfk.79.1626178842534;
        Tue, 13 Jul 2021 05:20:42 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id d14sm20248253pfv.171.2021.07.13.05.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 05:20:41 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Shannon Nelson <shannon.nelson@intel.com>,
        Catherine Sullivan <catherine.sullivan@intel.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i40e: Fix error handling code of label err_set_queues
Date:   Tue, 13 Jul 2021 20:20:27 +0800
Message-Id: <20210713122028.463450-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If i40e_up_complete fails in i40e_vsi_open, it goes to err_up_complete.
The label err_set_queues has an issue: if the else branch is executed,
there is no need to execute i40e_vsi_request_irq.

Fix this by adding a condition of i40e_vsi_free_irq.

Reported-by: Dongliang Mu (mudongliangabcd@gmail.com)
Fixes: 9c04cfcd4aad ("i40e: Fix error handling in i40e_vsi_open")
Fixes: c22e3c6c7912 ("i40e: prep vsi_open logic for non-netdev cases")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 861e59a350bd..ae54468c7001 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8720,7 +8720,8 @@ int i40e_vsi_open(struct i40e_vsi *vsi)
 err_up_complete:
 	i40e_down(vsi);
 err_set_queues:
-	i40e_vsi_free_irq(vsi);
+	if ((vsi->netdev) || (vsi->type == I40E_VSI_FDIR))
+		i40e_vsi_free_irq(vsi);
 err_setup_rx:
 	i40e_vsi_free_rx_resources(vsi);
 err_setup_tx:
-- 
2.25.1

