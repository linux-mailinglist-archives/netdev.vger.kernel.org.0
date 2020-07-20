Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2FF226028
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgGTMxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgGTMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAE9C0619D4;
        Mon, 20 Jul 2020 05:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BjAfLkPDE3yZtg4lK7QhOgoW888N1+wDiCi2cbIh45M=; b=HIM07y0S6HWIwmCN7WHloUTyD/
        90NWYxEF7A8OOMt+yg4W0FNSTev46GNQHm0M10gQP0DPfw41j+camChNVNUSzdAS2+W9B6xEJFxj0
        4n2KStvYzNC3b3fLRhUHbpg0C1h1bH+rhr3+ykUcvcbFAUG565FRK+y1r6zNQk9xHx3nUtlG0xpfa
        R4b3lYzoJn2Vsv07mi0Lr720W4t4f2K5zuJDLvkLLB7iLOadFMXPV1+OtITvRH1r7qcG7E4NGoir+
        m5wZVdfOiGPje1P9oONZz0Y/9ohF3QfiJ1TkC//hfbo3TJ3Y4xN43vztrFOMr/5DT0r0fJAP1prMs
        TGHdbaAg==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVCm-0004WM-TP; Mon, 20 Jul 2020 12:47:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 01/24] bpfilter: reject kernel addresses
Date:   Mon, 20 Jul 2020 14:47:14 +0200
Message-Id: <20200720124737.118617-2-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When feeding addresses to userspace we can't support kernel addresses
that were fed under set_fs(KERNEL_DS) from bpf-cgroup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bpfilter/bpfilter_kern.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 2c31e82cb953af..977e9dad72ca4f 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -41,6 +41,11 @@ static int __bpfilter_process_sockopt(struct sock *sk, int optname,
 	ssize_t n;
 	int ret = -EFAULT;
 
+	if (uaccess_kernel()) {
+		pr_err("kernel access not supported\n");
+		return -EFAULT;
+	}
+
 	req.is_set = is_set;
 	req.pid = current->pid;
 	req.cmd = optname;
-- 
2.27.0

