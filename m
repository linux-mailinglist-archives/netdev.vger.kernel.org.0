Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333DC270060
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgIRPA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:00:27 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61950 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIRPA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:00:26 -0400
X-Greylist: delayed 7316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 11:00:12 EDT
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 08ICvm7X029634
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Fri, 18 Sep 2020 05:57:49 -0700 (PDT)
Received: from pek-lpg-core2.corp.ad.wrs.com (128.224.153.41) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 05:57:27 -0700
From:   <zhe.he@windriver.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>,
        <trond.myklebust@hammerspace.com>, <anna.schumaker@netapp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhe.he@windriver.com>
Subject: [PATCH] SUNRPC: Flush dcache only when receiving more seeking
Date:   Fri, 18 Sep 2020 20:50:52 +0800
Message-ID: <20200918125052.2493006-1-zhe.he@windriver.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

commit ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()") introduces
svc_flush_bvec to after sock_recvmsg, but sometimes we receive less than we
seek, which triggers the following warning.

WARNING: CPU: 0 PID: 18266 at include/linux/bvec.h:101 bvec_iter_advance+0x44/0xa8
Attempted to advance past end of bvec iter
Modules linked in: sch_fq_codel openvswitch nsh nf_conncount nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
CPU: 1 PID: 18266 Comm: nfsd Not tainted 5.9.0-rc5 #1
Hardware name: Xilinx Zynq Platform
[<80112ec0>] (unwind_backtrace) from [<8010c3a8>] (show_stack+0x18/0x1c)
[<8010c3a8>] (show_stack) from [<80755214>] (dump_stack+0x9c/0xd0)
[<80755214>] (dump_stack) from [<80125e64>] (__warn+0xdc/0xf4)
[<80125e64>] (__warn) from [<80126244>] (warn_slowpath_fmt+0x84/0xac)
[<80126244>] (warn_slowpath_fmt) from [<80c88514>] (bvec_iter_advance+0x44/0xa8)
[<80c88514>] (bvec_iter_advance) from [<80c88940>] (svc_tcp_read_msg+0x10c/0x1bc)
[<80c88940>] (svc_tcp_read_msg) from [<80c895d4>] (svc_tcp_recvfrom+0x98/0x63c)
[<80c895d4>] (svc_tcp_recvfrom) from [<80c97bf4>] (svc_handle_xprt+0x48c/0x4f8)
[<80c97bf4>] (svc_handle_xprt) from [<80c98038>] (svc_recv+0x94/0x1e0)
[<80c98038>] (svc_recv) from [<804747cc>] (nfsd+0xf0/0x168)
[<804747cc>] (nfsd) from [<80148a0c>] (kthread+0x144/0x154)
[<80148a0c>] (kthread) from [<80100114>] (ret_from_fork+0x14/0x20)

Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 net/sunrpc/svcsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index d5805fa1d066..ea3bc9635448 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -277,7 +277,7 @@ static ssize_t svc_tcp_read_msg(struct svc_rqst *rqstp, size_t buflen,
 		buflen -= seek;
 	}
 	len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
-	if (len > 0)
+	if (len > (seek & PAGE_MASK))
 		svc_flush_bvec(bvec, len, seek);
 
 	/* If we read a full record, then assume there may be more
-- 
2.17.1

