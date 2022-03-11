Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE614D5FBA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348029AbiCKKgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348023AbiCKKgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:36:36 -0500
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2106F120F46
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:35:29 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 78527440165
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 18:35:28 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646994928; bh=R3j49KALSMnjuQeiVsymhqxJED/9xKOwSzuBBzckNSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cIxeJUWkDpEfQay55q1OipyMmLqQHo7DQl5MqLx0JGNH+Udw2XOuCcrsAEgWPMyjp
         HrixmJmWEdlm7wzbidMAfucbRiEMN61g2btZCgfmmJkIkO0IrVo1fKqaVWeUQ/6MWz
         dz5ozeAiKablIyHN4QzyIUtgy26Bp9A/Wd6GRi9s=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -1566189972
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 18:35:28 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646994928; bh=R3j49KALSMnjuQeiVsymhqxJED/9xKOwSzuBBzckNSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=cIxeJUWkDpEfQay55q1OipyMmLqQHo7DQl5MqLx0JGNH+Udw2XOuCcrsAEgWPMyjp
         HrixmJmWEdlm7wzbidMAfucbRiEMN61g2btZCgfmmJkIkO0IrVo1fKqaVWeUQ/6MWz
         dz5ozeAiKablIyHN4QzyIUtgy26Bp9A/Wd6GRi9s=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 1DF371541564;
        Fri, 11 Mar 2022 18:35:23 +0800 (CST)
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     sunmingbao@tom.com, tyler.sun@dell.com, ping.gan@dell.com,
        yanxiu.cai@dell.com, libin.zhang@dell.com, ao.sun@dell.com
Subject: [PATCH v2 1/3] tcp: export symbol tcp_set_congestion_control
Date:   Fri, 11 Mar 2022 18:34:12 +0800
Message-Id: <20220311103414.8255-1-sunmingbao@tom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mingbao Sun <tyler.sun@dell.com>

congestion-control could have a noticeable impaction on the
performance of TCP-based communications. This is of course true
to NVMe/TCP in the kernel.

Different congestion-controls (e.g., cubic, dctcp) are suitable for
different scenarios. Proper adoption of congestion control would
benefit the performance. On the contrary, the performance could be
destroyed.

So to gain excellent performance against different network
environments, NVMe/TCP tends to support specifying the
congestion-control.

This means NVMe/TCP (a kernel user) needs to set the congestion-control
of its TCP sockets.

Since the kernel API 'kernel_setsockopt' was removed, and since the
function ‘tcp_set_congestion_control’ is just the real underlying guy
handling this job, so it makes sense to get it exported.

Signed-off-by: Mingbao Sun <tyler.sun@dell.com>
---
 net/ipv4/tcp_cong.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db5831e6c136..1d6a23e42f7d 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -344,10 +344,20 @@ int tcp_set_allowed_congestion_control(char *val)
 	return ret;
 }
 
-/* Change congestion control for socket. If load is false, then it is the
- * responsibility of the caller to call tcp_init_congestion_control or
- * tcp_reinit_congestion_control (if the current congestion control was
- * already initialized.
+/**
+ * tcp_set_congestion_control - set a sock's congestion control
+ * @sk:            the sock.
+ * @name:          the desired congestion control.
+ * @load:          whether to load the required module in case not loaded.
+ * @cap_net_admin: indicating if the caller have the CAP_NET_ADMIN.
+ *
+ * Returns 0 or an error.
+ *
+ * Must be called on a locked sock.
+ *
+ * If load is false, then it is the responsibility of the caller to call
+ * tcp_init_congestion_control or tcp_reinit_congestion_control (if the
+ * current congestion control was already initialized).
  */
 int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 			       bool cap_net_admin)
@@ -383,6 +393,7 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 	rcu_read_unlock();
 	return err;
 }
+EXPORT_SYMBOL_GPL(tcp_set_congestion_control);
 
 /* Slow start is used when congestion window is no greater than the slow start
  * threshold. We base on RFC2581 and also handle stretch ACKs properly.
-- 
2.26.2

