Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB524DD4A9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 07:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiCRGSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 02:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiCRGSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 02:18:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3522B3D4A;
        Thu, 17 Mar 2022 23:17:25 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KKYhK2HN1zcbCv;
        Fri, 18 Mar 2022 14:17:21 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 14:17:22 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <paul@paul-moore.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] netlabel: fix out-of-bounds memory accesses
Date:   Fri, 18 Mar 2022 14:35:08 +0800
Message-ID: <20220318063508.1348148-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In calipso_map_cat_ntoh(), in the for loop, if the return value of
netlbl_bitmap_walk() is equal to (net_clen_bits - 1), when 
netlbl_bitmap_walk() is called next time, out-of-bounds memory accesses
of bitmap[byte_offset] occurs.

The bug was found during fuzzing. The following is the fuzzing report
 BUG: KASAN: slab-out-of-bounds in netlbl_bitmap_walk+0x3c/0xd0
 Read of size 1 at addr ffffff8107bf6f70 by task err_OH/252
 
 CPU: 7 PID: 252 Comm: err_OH Not tainted 5.17.0-rc7+ #17
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  dump_backtrace+0x21c/0x230
  show_stack+0x1c/0x60
  dump_stack_lvl+0x64/0x7c
  print_address_description.constprop.0+0x70/0x2d0
  __kasan_report+0x158/0x16c
  kasan_report+0x74/0x120
  __asan_load1+0x80/0xa0
  netlbl_bitmap_walk+0x3c/0xd0
  calipso_opt_getattr+0x1a8/0x230
  calipso_sock_getattr+0x218/0x340
  calipso_sock_getattr+0x44/0x60
  netlbl_sock_getattr+0x44/0x80
  selinux_netlbl_socket_setsockopt+0x138/0x170
  selinux_socket_setsockopt+0x4c/0x60
  security_socket_setsockopt+0x4c/0x90
  __sys_setsockopt+0xbc/0x2b0
  __arm64_sys_setsockopt+0x6c/0x84
  invoke_syscall+0x64/0x190
  el0_svc_common.constprop.0+0x88/0x200
  do_el0_svc+0x88/0xa0
  el0_svc+0x128/0x1b0
  el0t_64_sync_handler+0x9c/0x120
  el0t_64_sync+0x16c/0x170

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 net/netlabel/netlabel_kapi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index beb0e573266d..54c083003947 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -885,6 +885,8 @@ int netlbl_bitmap_walk(const unsigned char *bitmap, u32 bitmap_len,
 	unsigned char bitmask;
 	unsigned char byte;
 
+	if (offset >= bitmap_len)
+		return -1;
 	byte_offset = offset / 8;
 	byte = bitmap[byte_offset];
 	bit_spot = offset;
-- 
2.25.1

