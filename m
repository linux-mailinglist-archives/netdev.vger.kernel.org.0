Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF632DFEE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEDKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCEDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:10:18 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0AFC061574;
        Thu,  4 Mar 2021 19:10:18 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id l2so383877pgb.1;
        Thu, 04 Mar 2021 19:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s/06w5QgrfcMPtzUsdqEmwK0JlC5zZBUGgXhBq3TD64=;
        b=kGo37IFXZYumoVwQb3oAseOH7lw4OlGNqzdR6jwpJACgIljfSdjXqSM/AYoZFpxSjK
         LRXDj8ny61n0kBGNu3zJ8poETfpKZNaOWLMD9LMcbr6Bll4ESU9UPxMiPYG0fDhp2Obz
         h8ywDyEt1v1htnK8da0Wa/xF4c1EpPvOeNVxlUm1AnoR8BP/9PFa4+KfEDD3ST453chV
         egxGRDiliEzoG5aOkYCAThQ8tuNmQ3ZyKr4Hk8O/qFJfPGoGqGmUvxsyhvJgqczgt1Q6
         mbXY3pYohslqamKxEHttVnrhDwbir0SEOEtFh532Ilb0b9/faNgDBP7XcER9eZZW0qXi
         vXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s/06w5QgrfcMPtzUsdqEmwK0JlC5zZBUGgXhBq3TD64=;
        b=YBl8uAartBGpKwolVDTbwJ7sBfyESk5SDe8Y0mCxi+tBWbOwGRRkX6lxNDgi38ruMz
         4CiCg1GMy/RwIFskiyAnHO8E6qum/IAsR6npYA0A/U/jSadXmyi0fV1k9OEd9D8qi0hH
         Bt+UI1sLBeIQmdZN8hMEVOfSGD+XvkBTJh6yqpsBJwhbSN5qzDE6YYkCaHprXNJp5NmY
         f3ge5NvrranywWwOhTyzyep+zkypDD9FaqisaJ0iJqPCxuosrncMyE7Nu8j3LUdwVqc8
         hq/LXtTcVO38RgfhuUbF4vLNkqWqLvEGPYd14tgzCcg3kSAkbdIZwdIyt1tvgvldpvIB
         m/HQ==
X-Gm-Message-State: AOAM532jqnEsFhwNyZlRMpkci8rf1oiwa4I1YksXumsjxeqQdDRcGqqR
        i+A4zBuq39W6iQmnM1DF1GU=
X-Google-Smtp-Source: ABdhPJxJroc+YD7f8mRyciCHP8r3jc3N5NIQ6PbIRzQqkEN8zgiK9Eqt6sXv1Xj5ZTbry5MVdj4W7A==
X-Received: by 2002:aa7:91cf:0:b029:1cb:1c6f:b77d with SMTP id z15-20020aa791cf0000b02901cb1c6fb77dmr7007696pfa.74.1614913817878;
        Thu, 04 Mar 2021 19:10:17 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id 14sm682122pfo.141.2021.03.04.19.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 19:10:17 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: intel: iavf: fix error return code of iavf_init_get_resources()
Date:   Thu,  4 Mar 2021 19:10:10 -0800
Message-Id: <20210305031010.5396-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When iavf_process_config() fails, no error return code of
iavf_init_get_resources() is assigned.
To fix this bug, err is assigned with the return value of 
iavf_process_config(), and then err is checked.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 0a867d64d467..dc5b3c06d1e0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1776,7 +1776,8 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		goto err_alloc;
 	}
 
-	if (iavf_process_config(adapter))
+	err = iavf_process_config(adapter);
+	if (err)
 		goto err_alloc;
 	adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 
-- 
2.17.1

