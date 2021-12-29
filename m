Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947584811CD
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 11:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239800AbhL2K63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 05:58:29 -0500
Received: from m12-16.163.com ([220.181.12.16]:54369 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239798AbhL2K62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 05:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=mqgrx
        JiH65XQQm1qcbiC2nXc24ljlfOxEspWfg5t59Y=; b=RaZ0mdvGaw0ObVJ+nZq1C
        OwR0uDFm4lSOXFTmDNg6zzHyQj/L0c3gBceFaHbaP/l0mcDe/ZXou1raQ8iNwHvX
        wGPWIE6isbCDnhQlgQ/evWCYlGgD2/kWdErt9WUJ7FDqbIkOONpMqMBjmYoLS4og
        badLTLUcqhQHmal3lRW4Po=
Received: from [192.168.16.193] (unknown [110.80.1.44])
        by smtp12 (Coremail) with SMTP id EMCowAD3_4dCP8xhNN99Dw--.114S2;
        Wed, 29 Dec 2021 18:58:16 +0800 (CST)
Message-ID: <ff620d9f-5b52-06ab-5286-44b945453002@163.com>
Date:   Wed, 29 Dec 2021 18:58:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To:     willemb@google.com, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] selftests/net: udpgso_bench_tx: fix dst ip argument
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EMCowAD3_4dCP8xhNN99Dw--.114S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ury8Zry3KFWDZry8urWkCrg_yoW8Wry7pa
        4kKayjyrWkXFy3t3W0yr4kWw1rZrZrJrW2ka97Z34Uuw4rWrn2qrW7KFWIyF9rXrZYyFZ8
        Zwsa9a43Zan5Jw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzv3bUUUUU=
X-Originating-IP: [110.80.1.44]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiRAh4kFSIjod4QQAAsI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wujianguo <wujianguo@chinatelecom.cn>

udpgso_bench_tx call setup_sockaddr() for dest address before
parsing all arguments, if we specify "-p ${dst_port}" after "-D ${dst_ip}",
then ${dst_port} will be ignored, and using default cfg_port 8000.

This will cause test case "multiple GRO socks" failed in udpgro.sh.

Setup sockaddr after after parsing all arguments.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 17512a4..f1fdaa2 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -419,6 +419,7 @@ static void usage(const char *filepath)

 static void parse_opts(int argc, char **argv)
 {
+	const char *bind_addr = NULL;
 	int max_len, hdrlen;
 	int c;

@@ -446,7 +447,7 @@ static void parse_opts(int argc, char **argv)
 			cfg_cpu = strtol(optarg, NULL, 0);
 			break;
 		case 'D':
-			setup_sockaddr(cfg_family, optarg, &cfg_dst_addr);
+			bind_addr = optarg;
 			break;
 		case 'l':
 			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
@@ -492,6 +493,11 @@ static void parse_opts(int argc, char **argv)
 		}
 	}

+	if (!bind_addr)
+		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
+
+	setup_sockaddr(cfg_family, bind_addr, &cfg_dst_addr);
+
 	if (optind != argc)
 		usage(argv[0]);

-- 
1.8.3.1

