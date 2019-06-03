Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5778F33A0E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFCVrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:47:05 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45424 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbfFCVrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:47:05 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hXtmw-0001Jg-AD; Mon, 03 Jun 2019 22:42:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     syzbot+bad6e32808a3a97b1515@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] net: ipv4: fix rcu lockdep splat due to wrong annotation
Date:   Mon,  3 Jun 2019 22:41:44 +0200
Message-Id: <20190603204144.28320-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <000000000000bec591058a6fd889@google.com>
References: <000000000000bec591058a6fd889@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot triggered following splat when strict netlink
validation is enabled:

net/ipv4/devinet.c:1766 suspicious rcu_dereference_check() usage!

This occurs because we hold RTNL mutex, but no rcu read lock.
The second call site holds both, so just switch to the _rtnl variant.

Reported-by: syzbot+bad6e32808a3a97b1515@syzkaller.appspotmail.com
Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/devinet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index ebaea05b4033..ed2e2dc745cd 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1763,7 +1763,7 @@ static int in_dev_dump_addr(struct in_device *in_dev, struct sk_buff *skb,
 	int ip_idx = 0;
 	int err;
 
-	in_dev_for_each_ifa_rcu(ifa, in_dev) {
+	in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 		if (ip_idx < s_ip_idx) {
 			ip_idx++;
 			continue;
-- 
2.21.0

