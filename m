Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22B25335AE
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 05:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbiEYDUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 23:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240132AbiEYDUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 23:20:12 -0400
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E785C36B6B;
        Tue, 24 May 2022 20:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=sihod
        Ty0qX96ePaPV7EUOKS+sepQwhPU1v9YxGFh4Co=; b=naN70jQKzyrJn4TGnSaD+
        FlKhAp5aByo2YIh4ewWe7hLfJ8en0x83B2Pm6yFDmQmDtcI0Ealieb1U2tSymtfV
        KX4kwruFuBkn4RMmD012V2TjvdOjYoTw5aB32fKPwCgPb573F2GKdODjvnOIYRMy
        n5QXG/+d7CEg50PaGRAMf8=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp2 (Coremail) with SMTP id GtxpCgDn0ApboI1ipV7GEQ--.25971S2;
        Wed, 25 May 2022 11:19:56 +0800 (CST)
From:   Yun Lu <luyun_611@163.com>
To:     willemb@google.com, davem@davemloft.net, edumazet@google.com
Cc:     willemdebruijn.kernel@gmail.com, liuyun01@kylinos.cn,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v2] selftests/net: enable lo.accept_local in psock_snd test
Date:   Wed, 25 May 2022 11:18:19 +0800
Message-Id: <20220525031819.866684-1-luyun_611@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgDn0ApboI1ipV7GEQ--.25971S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CFy5uw47GF1kZw1kXw1fZwb_yoW8Xw47pr
        yxW34Yk348tFy2vw1xCF4kJry8Wan7Ar4Fkw4vq347Xa1kCryxWr13Kryq9FnrKrWSqa1f
        Aas29r1YgwnFyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UB89_UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiQxwMzlc7ZoyBPAAAsm
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

The psock_snd test sends and recieves packets over loopback, and
the test results depend on parameter settings:
Set rp_filter=0,
or set rp_filter=1 and accept_local=1
so that the test will pass. Otherwise, this test will fail with
Resource temporarily unavailable:
sudo ./psock_snd.sh
dgram
tx: 128
rx: 142
./psock_snd: recv: Resource temporarily unavailable

For most distro kernel releases(like Ubuntu or Centos), the parameter
rp_filter is enabled by default, so it's necessary to enable the
parameter lo.accept_local in psock_snd test. And this test runs
inside a netns, changing a sysctl is fine.

v2: add detailed description.

Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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

