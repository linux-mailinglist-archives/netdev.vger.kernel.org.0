Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01AC617998
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbiKCJPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiKCJOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:14:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA918E019;
        Thu,  3 Nov 2022 02:14:17 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N2ycX64r7zRp1N;
        Thu,  3 Nov 2022 17:09:16 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 17:14:15 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 17:14:15 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <keescook@chromium.org>,
        <gustavoars@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <acme@kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH net v2] uapi: Add missing linux/stddef.h header file to in.h
Date:   Thu, 3 Nov 2022 17:11:00 +0800
Message-ID: <20221103091100.246115-1-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper") does
not include "linux/stddef.h" header file, and tools headers update
linux/in.h copy, BPF prog fails to be compiled:

    CLNG-BPF [test_maps] bpf_flow.bpf.o
    CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.bpf.o
  In file included from progs/cgroup_skb_sk_lookup_kern.c:9:
  /root/linux/tools/include/uapi/linux/in.h:199:3: error: type name requires a specifier or qualifier
                  __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
                  ^
  /root/linux/tools/include/uapi/linux/in.h:199:32: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
                  __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
                                               ^
  2 errors generated.

To maintain consistency, add missing header file to kernel.

Fixes: 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---

Changes since v1:
 - 'Fixes' tag separates by the commit message by a blank line
 - Remove the empty line between 'Fixes' and SoB.
 - Specify the target tree to "net" in title
 - Wrap the commit message text to 75 chars per line (except build output)

 include/uapi/linux/in.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index f243ce665f74..79015665daf1 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/libc-compat.h>
 #include <linux/socket.h>
+#include <linux/stddef.h>
 
 #if __UAPI_DEF_IN_IPPROTO
 /* Standard well-defined IP protocols.  */
-- 
2.30.GIT

