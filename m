Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DE73A906C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 06:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhFPE0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 00:26:31 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10085 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhFPE02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 00:26:28 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4X7T3dcfzZdxV;
        Wed, 16 Jun 2021 12:21:25 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 16
 Jun 2021 12:24:18 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf] samples/bpf: Fix Segmentation fault for xdp_redirect command
Date:   Wed, 16 Jun 2021 12:23:24 +0800
Message-ID: <20210616042324.314832-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A Segmentation fault error is caused when the following command
is executed.

$ sudo ./samples/bpf/xdp_redirect lo
Segmentation fault

This command is missing a device <IFNAME|IFINDEX> as an argument, resulting
in out-of-bounds access from argv.

If the number of devices for the xdp_redirect parameter is not 2,
we should report an error and exit.

Fixes: 24251c264798 ("samples/bpf: add option for native and skb mode for redirect apps")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 samples/bpf/xdp_redirect_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index c903f1ccc15e..93854e135134 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -130,7 +130,7 @@ int main(int argc, char **argv)
 	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
 
-	if (optind == argc) {
+	if (optind + 2 != argc) {
 		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
 		return 1;
 	}
-- 
2.17.1

