Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA53489047
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiAJGkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiAJGkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:40:41 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AC3C06173F;
        Sun,  9 Jan 2022 22:40:40 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id p44so1808350pfw.5;
        Sun, 09 Jan 2022 22:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=VP9KpK795M7r1x0QaisDVkxn7asruzZsE8CWmNWFRcg=;
        b=IaNj5IL5kz2GwCsxUzKDX+okU0WGXhKh7xvHL47hg1EmgsvUy6Fo6aCrYQjRRhrN0O
         HdDlTotrCcMaUovTCeKwGo+ykcG/uKBMpRBBB5byCk849TExmkcvdVEaMCR+h1yLZX2I
         hbdYNr5b7X1oZDRbImK9jCOljNQSkAU3pNP1pZJH6LSJKaIdxBQj2R3xjiahDwWoWq8p
         y0/ptSAZI0ONQjsFARpVgyDiMss7kvVH9J0yrzRKJaHrP/ABBRvAQl6sTjYwDSCdXeU3
         TlVpu+O9sPJB8grY/+jd7yX5RhDoHKpM3jbNEcQqW6nmu8RUvWRtkCiFfS9wRKtlrILM
         xJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VP9KpK795M7r1x0QaisDVkxn7asruzZsE8CWmNWFRcg=;
        b=CD9cBjPTx0rJKnXcSn7bnJrgszLb2Cv869M+MRns+m7RrY+dL0PwR/RFElsSeP+5BA
         zuet0fI0JnJqRH8TT/cyF9XGYaU3Uzu1hXRGFhqF7dfV+q3L8yuT94sa3c3gnYzkVve2
         RQSzmgXjgfLCuE8RrzeUDlpm6+RRTcu2u04DXfYRKmHphg+fLMBEAqGUNttmMwG0OsWw
         sKr8UvmM5EGNblAmeilOtAwAz0IgbFiflf2dJIKg1St3BRIzVDVyGuGj+64v4qB7rjCH
         j2iXW36D7yNqWriTkLGwlescZ3L2WUcPZjNaqU9mRFFhbm+kLDAmca2ea7CzE+2J8G9Q
         NxFw==
X-Gm-Message-State: AOAM5329ry8NLDUeq+FZJQY2iFJhp84vcNS6YayyVjsgLaIfp1AtT3Tl
        Jl5jvvZp4DaokYb4DSrBq3E=
X-Google-Smtp-Source: ABdhPJxlA9+6ZZY0InLtFnxsJY+XAvQHmW4uUsfO/ps9T4TJ74rqyy6UmxPDCQ71pd5e22nlheFAPw==
X-Received: by 2002:a05:6a00:2391:b0:4a2:cb64:2e43 with SMTP id f17-20020a056a00239100b004a2cb642e43mr73563134pfc.49.1641796840250;
        Sun, 09 Jan 2022 22:40:40 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id s5sm5217633pfe.117.2022.01.09.22.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:40:39 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns: Fix missing put_device() call in hns_mac_register_phy
Date:   Mon, 10 Jan 2022 06:40:29 +0000
Message-Id: <20220110064031.3431-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to drop the reference taken by hns_dsaf_find_platform_device
Missing put_device() may cause refcount leak.

Fixes: 804ffe5c6197 ("net: hns: support deferred probe when no mdio")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
index 7edf8569514c..7364e05487c7 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c
@@ -764,6 +764,7 @@ static int hns_mac_register_phy(struct hns_mac_cb *mac_cb)
 		dev_err(mac_cb->dev,
 			"mac%d mdio is NULL, dsaf will probe again later\n",
 			mac_cb->mac_id);
+		put_device(&pdev->dev);
 		return -EPROBE_DEFER;
 	}
 
-- 
2.17.1

