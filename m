Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C30A5BD4BB
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 20:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiISS2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 14:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiISS2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 14:28:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250D324950
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 11:28:47 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id l65so414229pfl.8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 11:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5q0kKQb7Vw5tSWymQLv5pXsDwNqnc6SGBEsSiAF8K2c=;
        b=lHlDOS+967m0fycI93iI38bylchgK8HkO0ZNHB329th7yBM6l1opRwL3bPxpU3NbXj
         hfKXrLCDMPK+aHueNQGL0pmfV18CWEiuhCX84qNopDwZFFBYi0izDZpuAXDOfFfCqthW
         k7HDGmXgGVZ+WN17Ps2yiTmqQ8rr8WkcfMv7f6rkvtK3AIKIVOkQ7QB6K6C5E3idyhyE
         V5j+MWMs5jniah6mmkaJxdUkQOqj46RQAmiDtIEo3Me6s46CdTUO3BczhkhrnN5PCTuC
         RPoy5r6EZJjnnQCQgOYw/J5GXm8reDGVwnMTrQ+9Q9237QJqYtE9sxHk4dSNb6ommG/r
         THMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5q0kKQb7Vw5tSWymQLv5pXsDwNqnc6SGBEsSiAF8K2c=;
        b=dBBG+LrE9y+kQcrulrNOTFrKX5yhsQBSlYgBfyugfJKpiTlt9NuiPNNnUNk4R2oY3C
         HmFx2QTHkNCtDUE2Kr8WkB/tbDHkERXJ+pJEbu3C3IZ54p1OjW7S8lutG611mvjbRy5+
         i4TfqKbpyuFBNu+UjY2aJ6x0Cs5N1w5cBxtwvfXK/fOBlJvCmVWCpg6kIRiB+ji0lZbF
         f0DLNBdbLDgHoNjLxibMYby45LzxMn9dxqv6xO3L3uInTDEjRHvyWAr9RVUgOLleYclj
         S0QjJ96N0WDFcwuliWViwCn3qlg/ZE//NL5fOztsUEc/3uiv+NyXJ8ZK7Z+57kH/DyER
         FPqw==
X-Gm-Message-State: ACrzQf3KkItPKvkCDXyWfTDgOd/R9UgpPLwhk9TjW6YeOsWjpXEYySqJ
        HWemdjz4WHCNGpM1DAf6ZJc4eCStmEDzPA==
X-Google-Smtp-Source: AMsMyM4bKoLtLkCJHS4NF95Zw7lz/9x+3AdH1hdr9PPslGndy04LXXBLUBPFC+DO8WBBdf/ai3d5gA==
X-Received: by 2002:a63:f20e:0:b0:439:398f:80f8 with SMTP id v14-20020a63f20e000000b00439398f80f8mr16616659pgh.494.1663612126095;
        Mon, 19 Sep 2022 11:28:46 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id u11-20020a17090a450b00b001fd7fe7d369sm6948372pjg.54.2022.09.19.11.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 11:28:45 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jgg@ziepe.ca, william.xuanziyang@huawei.com, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v2] net/8021q/vlan: check the return value of vlan_vid_add()
Date:   Mon, 19 Sep 2022 11:28:16 -0700
Message-Id: <20220919182816.1587604-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Check the return value of vlan_vid_add() which could fail and return
error code.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/8021q/vlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index e40aa3e3641c..cb8048ce05f1 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -382,7 +382,9 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
 		pr_info("adding VLAN 0 to HW filter on device %s\n",
 			dev->name);
-		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
+		err = vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
+		if (err)
+			return notifier_from_errno(err);
 	}
 	if (event == NETDEV_DOWN &&
 	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
-- 
2.25.1

