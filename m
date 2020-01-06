Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9B8131B85
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgAFWe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:34:28 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38382 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgAFWe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:34:28 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ioax7-0007Wf-FD; Mon, 06 Jan 2020 23:34:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: conntrack: dccp, sctp: handle null timeout argument
Date:   Mon,  6 Jan 2020 23:34:17 +0100
Message-Id: <20200106223417.18279-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <0000000000009cd5e0059b7eb836@google.com>
References: <0000000000009cd5e0059b7eb836@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The timeout pointer can be NULL which means we should modify the
per-nets timeout instead.

All do this, except sctp and dccp which instead give:

general protection fault: 0000 [#1] PREEMPT SMP KASAN
net/netfilter/nf_conntrack_proto_dccp.c:682
 ctnl_timeout_parse_policy+0x150/0x1d0 net/netfilter/nfnetlink_cttimeout.c:67
 cttimeout_default_set+0x150/0x1c0 net/netfilter/nfnetlink_cttimeout.c:368
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477

Reported-by: syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com
Fixes: c779e849608a8 ("netfilter: conntrack: remove get_timeout() indirection")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 3 +++
 net/netfilter/nf_conntrack_proto_sctp.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index b6b14db3955b..b3f4a334f9d7 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -677,6 +677,9 @@ static int dccp_timeout_nlattr_to_obj(struct nlattr *tb[],
 	unsigned int *timeouts = data;
 	int i;
 
+	if (!timeouts)
+		 timeouts = dn->dccp_timeout;
+
 	/* set default DCCP timeouts. */
 	for (i=0; i<CT_DCCP_MAX; i++)
 		timeouts[i] = dn->dccp_timeout[i];
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index fce3d93f1541..0399ae8f1188 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -594,6 +594,9 @@ static int sctp_timeout_nlattr_to_obj(struct nlattr *tb[],
 	struct nf_sctp_net *sn = nf_sctp_pernet(net);
 	int i;
 
+	if (!timeouts)
+		timeouts = sn->timeouts;
+
 	/* set default SCTP timeouts. */
 	for (i=0; i<SCTP_CONNTRACK_MAX; i++)
 		timeouts[i] = sn->timeouts[i];
-- 
2.24.1

