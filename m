Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A936221FE
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiKICk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:40:25 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBB81A04D;
        Tue,  8 Nov 2022 18:40:24 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N6Thn2MrxzmVg8;
        Wed,  9 Nov 2022 10:40:09 +0800 (CST)
Received: from dggpemm500015.china.huawei.com (7.185.36.181) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 10:40:22 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500015.china.huawei.com
 (7.185.36.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 9 Nov
 2022 10:40:21 +0800
From:   Wang ShaoBo <bobo.shaobowang@huawei.com>
CC:     <luiz.von.dentz@intel.com>, <luiz.dentz@gmail.com>,
        <pabeni@redhat.com>, <liwei391@huawei.com>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Bluetooth: hci_conn: add missing hci_dev_put() in iso_listen_bis()
Date:   Wed, 9 Nov 2022 10:39:06 +0800
Message-ID: <20221109023906.1556201-1-bobo.shaobowang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hci_get_route() takes reference, we should use hci_dev_put() to release
it when not need anymore.

Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
---

v2:
  - always release reference as it is not need anymore when
  - iso_listen_bis() finish.

v1: https://lore.kernel.org/netdev/20221108112308.3910185-1-bobo.shaobowang@huawei.com/T/

 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f825857db6d0..26db929b97c4 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -879,6 +879,7 @@ static int iso_listen_bis(struct sock *sk)
 				 iso_pi(sk)->bc_sid);
 
 	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 
 	return err;
 }
-- 
2.25.1

