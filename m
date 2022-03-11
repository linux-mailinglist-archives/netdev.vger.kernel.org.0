Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D04D4D589A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345886AbiCKDD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345883AbiCKDDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:03:24 -0500
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8F48F1E97
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:02:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 08C4044017A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:02:22 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967742; bh=ScMuHjAXfamD9Fmid4TX5rIBXmPUVWR9zJbXFToXGJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtYK0p0wjAoQBZD17mfNjHOqKcrWYTtVv89I7EsySz4YZfAC18TLTaMlZn2kJwba4
         ikH/BKGWD49vA/Hlo1jxt3aq7yU2OXO1CJHejrsPYvxIvqsROMEC9qaNoR6CgJRQAu
         Ldoe5lc3sPcCst5a7FQRwbjGDvtFj9wLpfhfHPCU=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -1383741510
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 11:02:22 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967742; bh=ScMuHjAXfamD9Fmid4TX5rIBXmPUVWR9zJbXFToXGJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtYK0p0wjAoQBZD17mfNjHOqKcrWYTtVv89I7EsySz4YZfAC18TLTaMlZn2kJwba4
         ikH/BKGWD49vA/Hlo1jxt3aq7yU2OXO1CJHejrsPYvxIvqsROMEC9qaNoR6CgJRQAu
         Ldoe5lc3sPcCst5a7FQRwbjGDvtFj9wLpfhfHPCU=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 4BA691541574;
        Fri, 11 Mar 2022 11:02:18 +0800 (CST)
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
Subject: [PATCH 1/3] tcp: export symbol tcp_set_congestion_control
Date:   Fri, 11 Mar 2022 11:01:11 +0800
Message-Id: <20220311030113.73384-2-sunmingbao@tom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220311030113.73384-1-sunmingbao@tom.com>
References: <20220311030113.73384-1-sunmingbao@tom.com>
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
 net/ipv4/tcp_cong.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db5831e6c136..5d77f3e7278e 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -383,6 +383,7 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
 	rcu_read_unlock();
 	return err;
 }
+EXPORT_SYMBOL_GPL(tcp_set_congestion_control);
 
 /* Slow start is used when congestion window is no greater than the slow start
  * threshold. We base on RFC2581 and also handle stretch ACKs properly.
-- 
2.26.2

