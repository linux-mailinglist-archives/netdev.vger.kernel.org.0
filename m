Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D70A58EF7C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiHJPiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiHJPiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:38:04 -0400
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.237.72.81])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 1388C28E02;
        Wed, 10 Aug 2022 08:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=dwLcVSKssd
        J7Q7x71NIOI0DB3SuG4iOBFHZ/ZegSBCM=; b=Sh0mUqCpfjv4X2jqzgwnx+9cjK
        HJc+bMuzYf3WfJxDn/pF+FYJWgQIo8ijm5L0Ke4kz6RQ8zU/25OW4CJGw+zIXUuQ
        9stvW10V7lCcpJ+R27zxxIIo6Xa7SYi8PGEbCeEcGsYZusCY0iwXCeaL7ujTxHuo
        JIsfnCVDr5M9BL/WY=
Received: from localhost.localdomain (unknown [202.120.224.54])
        by app1 (Coremail) with SMTP id XAUFCgDX3oKa0PNigiMfAw--.39779S4;
        Wed, 10 Aug 2022 23:37:29 +0800 (CST)
From:   Xin Xiong <xiongx18@fudan.edu.cn>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?q?=E2=80=9CDavid=20S=20=2E=20Miller=20?= 
        <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()
Date:   Wed, 10 Aug 2022 23:29:13 +0800
Message-Id: <20220810152909.25149-1-xiongx18@fudan.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: XAUFCgDX3oKa0PNigiMfAw--.39779S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Gw1DWFy3XFy3AFW8JrykuFg_yoW8JrW8pF
        W3G347uFykKrW7Xa17Ca10ga45ZFZ8GF15JrZ5C3W3Awn8Xa45Gr109ay29F1xCrWFk34S
        qF4vgF4rZFWDCa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Cr0_Gr
        1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6ryrMxAIw28IcxkI7VAKI4
        8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
        wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
        v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
        Y4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5ku4UUUUU
X-CM-SenderInfo: arytiiqsuqiimz6i3vldqovvfxof0/1tbiAg4OEFKp2quTOAAAsz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue happens on some error handling paths. When the function
fails to grab the object `xprt`, it simply returns 0, forgetting to
decrease the reference count of another object `xps`, which is
increased by rpc_sysfs_xprt_kobj_get_xprt_switch(), causing refcount
leaks. Also, the function forgets to check whether `xps` is valid
before using it, which may result in NULL-dereferencing issues.

Fix it by adding proper error handling code when either `xprt` or
`xps` is NULL.

Fixes: 5b7eb78486cd ("SUNRPC: take a xprt offline using sysfs")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/sunrpc/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index a3a2f8aeb80e..d1a15c6d3fd9 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -291,8 +291,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 	int offline = 0, online = 0, remove = 0;
 	struct rpc_xprt_switch *xps = rpc_sysfs_xprt_kobj_get_xprt_switch(kobj);
 
-	if (!xprt)
-		return 0;
+	if (!xprt || !xps) {
+		count = 0;
+		goto out_put;
+	}
 
 	if (!strncmp(buf, "offline", 7))
 		offline = 1;
-- 
2.25.1

