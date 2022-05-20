Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A817552E571
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346089AbiETGzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346102AbiETGzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:55:35 -0400
X-Greylist: delayed 910 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 23:55:33 PDT
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C53A114FC9F;
        Thu, 19 May 2022 23:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Mff2d
        v08+/B+/bGWeUwW9MgjlQSqdbbmS0SIwTwzpAA=; b=oiRmqPUIAMx9gAlb4+4UB
        ItCLlwFGKqM+AbF6FLh7WkR9YGYjtow+dT4ZYZZJ8adHQR1ZppNYnAGT/2EPaxLi
        ZxcT5+89Di0VoUoA0qVVltLuDWd8kL3L6Oi3CGYWtC4CmbM8Ubx+aGOpcKpnnnX3
        K/BDfJLu/fF7bA2edpKYrE=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp1 (Coremail) with SMTP id GdxpCgDn24XFN4diP0VpDQ--.42783S2;
        Fri, 20 May 2022 14:40:08 +0800 (CST)
From:   Yun Lu <luyun_611@163.com>
To:     willemb@google.com, davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH] selftests/net: enable lo.accept_local in psock_snd test
Date:   Fri, 20 May 2022 14:38:35 +0800
Message-Id: <20220520063835.866445-1-luyun_611@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDn24XFN4diP0VpDQ--.42783S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw17GF4rKr18ZFyUXF1fJFb_yoWktrcEqa
        1Yqrn7Zr4UZFnxtF4xuw4UZr4Fka13WrWDGrsxJF17tw4xWa1rJFWkZws3AF1kWFWYkFW2
        va1fJryYq3Z29jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUZmR7UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbi6wIHzlXl1m+fkAAAsm
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luyun <luyun@kylinos.cn>

The psock_snd test sends and recievs packets over loopback, but the
parameter lo.accept_local is disabled by default, this test will
fail with Resource temporarily unavailable:
sudo ./psock_snd.sh
dgram
tx: 128
rx: 142
./psock_snd: recv: Resource temporarily unavailable

So enable the parameter lo.accept_local in psock_snd test.

Signed-off-by: luyun <luyun@kylinos.cn>
Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>
---
 tools/testing/selftests/net/psock_snd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/psock_snd.c b/tools/testing/selftests/net/psock_snd.c
index 7d15e10a9fb6..edf1e6f80d41 100644
--- a/tools/testing/selftests/net/psock_snd.c
+++ b/tools/testing/selftests/net/psock_snd.c
@@ -389,6 +389,8 @@ int main(int argc, char **argv)
 		error(1, errno, "ip link set mtu");
 	if (system("ip addr add dev lo 172.17.0.1/24"))
 		error(1, errno, "ip addr add");
+	if (system("sysctl -w net.ipv4.conf.lo.accept_local=1"))
+		error(1, errno, "sysctl lo.accept_local");
 
 	run_test();
 
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus

