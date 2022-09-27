Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB0C5EBAED
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 08:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiI0GrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 02:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiI0GrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 02:47:03 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15786A02E1;
        Mon, 26 Sep 2022 23:46:59 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id v4so8564150pgi.10;
        Mon, 26 Sep 2022 23:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=giKqVLcDi0A/kp1flXGKrWB3LVVMTb0gV31mRaBRfxY=;
        b=ijB/Pg5LK2RlayWqv39DerX3wXnxYd4z33ufOOQwRYT8k5t0tS06ItEM7JDUZArcCn
         geUJ8LX1j+ifV/Oh0WFFtPFXjFOs2y/2NsatSlfMFBS2f8PobQ1GnNX3s++lHTSQNK1k
         xJvN34dvb0P3fcRpANqQRT4xzgP1qiK85F+UGDgJhqEV55asLUhhYCFG9Op1S8+Pls5J
         FBJ6ER56nfzdwM10un4MV4Sia0jjAHbjtRm6DlIpgbbCWXM+RnO268iwLpLUjxtzMRui
         CgZcE1+DUf6V3X9ie765PyZQhrvN44waypUfjvygsT5VqMyrfCIdsGnOcXDqxbcRw6ok
         x5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=giKqVLcDi0A/kp1flXGKrWB3LVVMTb0gV31mRaBRfxY=;
        b=eAISBuodKgyUqPY7Q/xn6hpe19J0cng5hzGxX1x3k/nfu7pYke8Er2oupAZXDEdjWV
         fNU+JyY7HQSfT2k23q545dvPNSO/WMASVJF09EZTpMtHUGFTy6ZnWfjV44VkXsvyTHy/
         PsfT2Hh0+WBMX8cABDZhDWb+A35QtGUSWM6vD+0/l8QmoUCsBjXU21vcn7s+LFodbbaN
         4fX2T2WYF/a+q3+uFn/nm/g5Wn05IIvVtZY2115LHe/eXau1Zo0Eyl7nWu03k1/Nn/4c
         7NIHu2IBNDBmBg58n4kDn7Zz0FyksKOz96gUCn54S4oYm1x6AIrVi/RSHJUarBH62kLB
         L3AA==
X-Gm-Message-State: ACrzQf3hZ/m7fIsPAn8kcT57Vv0QLthv3y6sJCpvJpR+WNFj+1BgKWKU
        XqdGiuIUZY7FQBHc5Z0aYgY=
X-Google-Smtp-Source: AMsMyM5dO21mlyWLoDTvVhLKCsNSC9R7zyPKgDypKm3vQbjsGIUgWuKyBNtFyEdtJK8zAWXY57evUQ==
X-Received: by 2002:a63:2cc2:0:b0:41c:681d:60d2 with SMTP id s185-20020a632cc2000000b0041c681d60d2mr22229629pgs.502.1664261218633;
        Mon, 26 Sep 2022 23:46:58 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t17-20020a63eb11000000b00439d071c110sm667233pgh.43.2022.09.26.23.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 23:46:58 -0700 (PDT)
From:   zhangsongyi.cgel@gmail.com
X-Google-Original-From: zhang.songyi@zte.com.cn
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        zhang.songyi@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] net: atm: Convert to use sysfs_emit()/sysfs_emit_at() APIs
Date:   Tue, 27 Sep 2022 06:46:49 +0000
Message-Id: <20220927064649.257988-1-zhang.songyi@zte.com.cn>
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

From: zhang songyi <zhang.songyi@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the value
to be returned to user space.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 net/atm/atm_sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/atm/atm_sysfs.c b/net/atm/atm_sysfs.c
index 0fdbdfd19474..2258d94288a6 100644
--- a/net/atm/atm_sysfs.c
+++ b/net/atm/atm_sysfs.c
@@ -16,7 +16,7 @@ static ssize_t type_show(struct device *cdev,
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
 
-	return scnprintf(buf, PAGE_SIZE, "%s\n", adev->type);
+	return sysfs_emit(buf, "%s\n", adev->type);
 }
 
 static ssize_t address_show(struct device *cdev,
@@ -24,7 +24,7 @@ static ssize_t address_show(struct device *cdev,
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
 
-	return scnprintf(buf, PAGE_SIZE, "%pM\n", adev->esi);
+	return sysfs_emit(buf, "%pM\n", adev->esi);
 }
 
 static ssize_t atmaddress_show(struct device *cdev,
@@ -37,7 +37,7 @@ static ssize_t atmaddress_show(struct device *cdev,
 
 	spin_lock_irqsave(&adev->lock, flags);
 	list_for_each_entry(aaddr, &adev->local, entry) {
-		count += scnprintf(buf + count, PAGE_SIZE - count,
+		count += sysfs_emit_at(buf, count,
 				   "%1phN.%2phN.%10phN.%6phN.%1phN\n",
 				   &aaddr->addr.sas_addr.prv[0],
 				   &aaddr->addr.sas_addr.prv[1],
@@ -55,7 +55,7 @@ static ssize_t atmindex_show(struct device *cdev,
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", adev->number);
+	return sysfs_emit(buf, "%d\n", adev->number);
 }
 
 static ssize_t carrier_show(struct device *cdev,
@@ -63,7 +63,7 @@ static ssize_t carrier_show(struct device *cdev,
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 			 adev->signal == ATM_PHY_SIG_LOST ? 0 : 1);
 }
 
@@ -87,7 +87,7 @@ static ssize_t link_rate_show(struct device *cdev,
 	default:
 		link_rate = adev->link_rate * 8 * 53;
 	}
-	return scnprintf(buf, PAGE_SIZE, "%d\n", link_rate);
+	return sysfs_emit(buf, "%d\n", link_rate);
 }
 
 static DEVICE_ATTR_RO(address);
-- 
2.25.1


