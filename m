Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971D55035A4
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiDPJXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiDPJW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:22:58 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id BC5E4107809
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 02:20:00 -0700 (PDT)
Received: from 102.localdomain (unknown [58.23.249.10])
        by app1 (Coremail) with SMTP id xjNnewA36DErilpi+B0VAA--.37S2;
        Sat, 16 Apr 2022 17:19:40 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH net-next v2 0/2] tcp: ensure rate sample to use the most recently sent skb
Date:   Sat, 16 Apr 2022 17:19:07 +0800
Message-Id: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewA36DErilpi+B0VAA--.37S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUY47CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GFWl
        42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW5Jr1UJr1UMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
        IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
        C2KfnxnUUI43ZEXa7VUbgyCJUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch ensure to use the most recently sent skb
when filling the rate sample. And make RACK and rate
sample share the use of tcp_skb_sent_after() helper.

v2: introduce a new help function tcp_skb_sent_after()

Pengcheng Yang (2):
  tcp: ensure to use the most recently sent skb when filling the rate
    sample
  tcp: use tcp_skb_sent_after() instead in RACK

 include/net/tcp.h       |  6 ++++++
 net/ipv4/tcp_rate.c     | 11 ++++++++---
 net/ipv4/tcp_recovery.c | 15 +++++----------
 3 files changed, 19 insertions(+), 13 deletions(-)

-- 
1.8.3.1

