Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3073DB204
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 05:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhG3DmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 23:42:23 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:39613 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230158AbhG3DmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 23:42:23 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UhP1c4p_1627616537;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UhP1c4p_1627616537)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 30 Jul 2021 11:42:17 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>
Subject: [PATCH] selftests/net: remove min gso test in packet_snd
Date:   Fri, 30 Jul 2021 11:41:55 +0800
Message-Id: <20210730034155.24560-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removed the 'raw gso min size - 1' test which
always fails now:
./in_netns.sh ./psock_snd -v -c -g -l "${mss}"
  raw gso min size - 1 (expected to fail)
  tx: 1524
  rx: 1472
  OK

After commit 7c6d2ecbda83 ("net: be more gentle about silly
gso requests coming from user"), we relaxed the min gso_size
check in virtio_net_hdr_to_skb().
So when a packet which is smaller then the gso_size,
GSO for this packet will not be set, the packet will be
send/recv successfully.

Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 tools/testing/selftests/net/psock_snd.sh | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/net/psock_snd.sh b/tools/testing/selftests/net/psock_snd.sh
index 170be65e0816..1cbfeb5052ec 100755
--- a/tools/testing/selftests/net/psock_snd.sh
+++ b/tools/testing/selftests/net/psock_snd.sh
@@ -86,9 +86,6 @@ echo "raw truncate hlen - 1 (expected to fail: EINVAL)"
 echo "raw gso min size"
 ./in_netns.sh ./psock_snd -v -c -g -l "${mss_exceeds}"
 
-echo "raw gso min size - 1 (expected to fail)"
-(! ./in_netns.sh ./psock_snd -v -c -g -l "${mss}")
-
 echo "raw gso max size"
 ./in_netns.sh ./psock_snd -v -c -g -l "${max_mss}"
 
-- 
2.19.1.3.ge56e4f7

