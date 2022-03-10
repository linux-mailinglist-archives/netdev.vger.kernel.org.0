Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3EE4D4888
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242640AbiCJOE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242649AbiCJOE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:04:28 -0500
X-Greylist: delayed 829 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Mar 2022 06:03:23 PST
Received: from smtp.tom.com (smtprz01.163.net [106.3.154.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC1C814FBFF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:03:23 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 90DE2440134
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:49:33 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646920173; bh=ScMuHjAXfamD9Fmid4TX5rIBXmPUVWR9zJbXFToXGJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=JjgfVvPK42GEWmWbNAjIcLQWQSRcQbhoy76MOZZZFI6XZpaP9JyG893N5ONF1Fmqm
         Hyl0JHWmgEi3WurpPMZNz0WA9u6LEBL3rLvFOtF0KgUatpgtzMbdb8Al95ZlBJpt3O
         46vj7TWKAtP9lnOeiZPhvUCrfiOw9OD/WSzlSjBo=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -209168645
          for <netdev@vger.kernel.org>;
          Thu, 10 Mar 2022 21:49:33 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646920173; bh=ScMuHjAXfamD9Fmid4TX5rIBXmPUVWR9zJbXFToXGJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=JjgfVvPK42GEWmWbNAjIcLQWQSRcQbhoy76MOZZZFI6XZpaP9JyG893N5ONF1Fmqm
         Hyl0JHWmgEi3WurpPMZNz0WA9u6LEBL3rLvFOtF0KgUatpgtzMbdb8Al95ZlBJpt3O
         46vj7TWKAtP9lnOeiZPhvUCrfiOw9OD/WSzlSjBo=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id C02B615414BB;
        Thu, 10 Mar 2022 21:49:28 +0800 (CST)
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, sunmingbao@tom.com,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: [PATCH] tcp: export symbol tcp_set_congestion_control
Date:   Thu, 10 Mar 2022 21:48:30 +0800
Message-Id: <20220310134830.130818-1-sunmingbao@tom.com>
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

