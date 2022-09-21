Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5785BFAEA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiIUJ1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIUJ1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:27:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC38E0E4;
        Wed, 21 Sep 2022 02:27:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w20so5022792ply.12;
        Wed, 21 Sep 2022 02:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=78NlHYouWaUJs1I4MESYcMIc37BB9/YJyi8yjuu9aFY=;
        b=DN154rKwTyiD9kRuijlX2tRS5fJ7xu0mi1SoRL3BCWjc92+vt4cF4itRPOVkkOXEsa
         RpTKRaT/9eYFOl/sCQh0D0EX8Ml/+yeP11BKTg/MHU2nQPAHKaqEkqdnMn9K2edgK6uy
         nh6P6T0ithfOMb76IsPNj4vSnHpAqEZWekATrU8pBc8audCNAdiUa4QapYbeXxELrvbH
         f3jx1uZmUwtiP2CnP0UQ/p9sYoWj12RkUTmGBSRV01fqO0v0FsMtHvuUfZJqZLBb0CEO
         AAEtXLgnXl8DLsS29eWkiGjeP00Gs6Xq4+Cj1BpXH16nfqDpWcMi2c3f/BSomFTtVEnd
         2KQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=78NlHYouWaUJs1I4MESYcMIc37BB9/YJyi8yjuu9aFY=;
        b=gNrJ/E1N3tecru+YoPE5dDi+6e/i7sPDoifU6U7N6OD/GCb5QBV9TbT4NMmotQXAqf
         TdoFZVB2UZJFANJC7aS6NsgSRYc8aI43LCSTsJ2DhboSSOkvbQAPlELhHSJu/6L+rXbA
         QCFVI9iqeOTmfEYUGvvoJW/EqxEQTvDaEQu4Rh87GYS8bhSF9HoUlfOG3Br8g+UZacMA
         2PMdqeDFpRKIpbl5WgswHxQU5GtcOyOt5CQwsw7x/608ZkujUjEMdm+V4OMWc3HqDHkz
         gj0LzkopEBXGNxxg8JjuA01fDOiDqABWB0Ztc3r15vBJzUfHSzcL7mUTL0F7af0RRrCa
         NuVg==
X-Gm-Message-State: ACrzQf1iAwiqGAXIbHrCDtthLsJUCtSsGtR9sZ7bXvJ741ghNplR8BVe
        NJNEEcrWO7MKjDhg2E1DZfw=
X-Google-Smtp-Source: AMsMyM6L7lqci37TTwA6HlNxDfiHmtXI93kI8zC9PnTHPhRGzGOCrBldFqA+zbsKyANlMPh23hVg/g==
X-Received: by 2002:a17:902:6a8a:b0:173:14f5:1d89 with SMTP id n10-20020a1709026a8a00b0017314f51d89mr3817721plk.89.1663752467219;
        Wed, 21 Sep 2022 02:27:47 -0700 (PDT)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a450b00b001fb53587166sm1410068pjg.28.2022.09.21.02.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 02:27:46 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH v2] net: sched: fix possible refcount leak in tc_new_tfilter()
Date:   Wed, 21 Sep 2022 17:27:34 +0800
Message-Id: <20220921092734.31700-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tfilter_put need to be called to put the refount got by tp->ops->get to
avoid possible refcount leak when chain->tmplt_ops != NULL and
chain->tmplt_ops != tp->ops.

Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
---

v2: fix a description error

 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 790d6809be81..51d175f3fbcb 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2137,6 +2137,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	}
 
 	if (chain->tmplt_ops && chain->tmplt_ops != tp->ops) {
+		tfilter_put(tp, fh);
 		NL_SET_ERR_MSG(extack, "Chain template is set to a different filter kind");
 		err = -EINVAL;
 		goto errout;
-- 
2.34.1

