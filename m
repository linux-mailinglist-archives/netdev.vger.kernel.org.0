Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911D1600669
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 07:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiJQFrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 01:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJQFrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 01:47:36 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192E94E199;
        Sun, 16 Oct 2022 22:47:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VSIKI1E_1665985636;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VSIKI1E_1665985636)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 13:47:30 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] Bluetooth: Use kzalloc instead of kmalloc/memset
Date:   Mon, 17 Oct 2022 13:47:13 +0800
Message-Id: <20221017054713.7507-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kzalloc rather than duplicating its implementation, which makes code
simple and easy to understand.

./net/bluetooth/hci_conn.c:2038:6-13: WARNING: kzalloc should be used for cp, instead of kmalloc/memset.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2406
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/bluetooth/hci_conn.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 5d6ee5075642..495de21d52cd 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2035,13 +2035,12 @@ int hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst, __u8 dst_type,
 	if (hci_dev_test_and_set_flag(hdev, HCI_PA_SYNC))
 		return -EBUSY;
 
-	cp = kmalloc(sizeof(*cp), GFP_KERNEL);
+	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
 	if (!cp) {
 		hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 		return -ENOMEM;
 	}
 
-	memset(cp, 0, sizeof(*cp));
 	cp->sid = sid;
 	cp->addr_type = dst_type;
 	bacpy(&cp->addr, dst);
-- 
2.20.1.7.g153144c

