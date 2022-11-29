Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C1C63BE23
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbiK2Kl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiK2KlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:41:25 -0500
Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A8F8FC6E;
        Tue, 29 Nov 2022 02:41:18 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltAAH+Ay44YVjAYkAAA--.821S2;
        Tue, 29 Nov 2022 18:40:57 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf v3 0/4] bpf, sockmap: Fix some issues with using apply_bytes
Date:   Tue, 29 Nov 2022 18:40:37 +0800
Message-Id: <1669718441-2654-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: SyJltAAH+Ay44YVjAYkAAA--.821S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1xJw43uFWxuFWxuF47XFb_yoWDXrcEv3
        yUtFZ8JFW8XF1rCaya9FZ8CF97Cw4DZrykJF98trW3Gr1xZr1UGrs5Xry0yr18Gay3Kr97
        XrykCrWvqr1FgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUUUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1~3 fixes three issues with using apply_bytes when redirecting.
Patch 4 adds ingress tests for txmsg with apply_bytes in selftests.

Thanks to John Fastabend and Jakub Sitnicki for correct solution.

---
Changes in v3:
*Patch 2: Rename 'flags', modify based on Jakub Sitnicki's patch

Changes in v2:
*Patch 2: Clear psock->flags explicitly before releasing the sock lock

Pengcheng Yang (4):
  bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
  bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
  bpf, sockmap: Fix data loss caused by using apply_bytes on ingress
    redirect
  selftests/bpf: Add ingress tests for txmsg with apply_bytes

 include/linux/skmsg.h                      |  1 +
 include/net/tcp.h                          |  4 ++--
 net/core/skmsg.c                           |  9 ++++++---
 net/ipv4/tcp_bpf.c                         | 19 ++++++++++++-------
 net/tls/tls_sw.c                           |  6 ++++--
 tools/testing/selftests/bpf/test_sockmap.c | 18 ++++++++++++++++++
 6 files changed, 43 insertions(+), 14 deletions(-)

-- 
1.8.3.1

