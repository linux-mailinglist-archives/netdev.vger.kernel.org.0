Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49B3173884
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgB1Nkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:40:35 -0500
Received: from gateway24.websitewelcome.com ([192.185.51.202]:47557 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgB1Nkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:40:32 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id CEB9181618
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 07:40:30 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7fsUjIdnKRP4z7fsUjh2rg; Fri, 28 Feb 2020 07:40:30 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vo0s0HHcKUWbR9UQkp85XxEyo8pNBh5ee/gMXGBhILo=; b=g+4fKStdx4DsG5MhPZ1ImJeoAQ
        nxPmXBYvHhSIK6R/+xXj0oX1FMiZfo/8iRMYOfx1Nws8/MH57qvSkWs0ChCYz09LkM7cYM39s4oYO
        ub7PMz8jrFSTYz8JvlwmwkEIcLCdW7WeOuTzZRwc4EnSDb8gtc0LL6Y8YC5N+VntqTofnMKWQ9M83
        rFgslmPY1Qwp3b677NVkxUmvRelrCatITwxdyCqoGIUXGbTSJL3lOdU2IvUXNIxWIXbRTHUzIwekO
        0uWpJfGWeT0Rh3fEVHLkPFvTX5kOoL4qcH8P7zZy7PsJXwlCCH76ILHktJHSxyyPJ2XJSZuNUEXpQ
        gEwkk7YA==;
Received: from [201.162.240.44] (port=19035 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7fsS-001RcU-L0; Fri, 28 Feb 2020 07:40:29 -0600
Date:   Fri, 28 Feb 2020 07:43:24 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Neil Horman <nhorman@tuxdriver.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: core: Replace zero-length array with
 flexible-array member
Message-ID: <20200228134324.GA29394@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.240.44
X-Source-L: No
X-Exim-ID: 1j7fsS-001RcU-L0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:19035
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 51
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/core/bpf_sk_storage.c | 2 +-
 net/core/devlink.c        | 2 +-
 net/core/drop_monitor.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 3ab23f698221..427cfbc0d50d 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -60,7 +60,7 @@ struct bpf_sk_storage_data {
 	 * the number of cachelines access during the cache hit case.
 	 */
 	struct bpf_sk_storage_map __rcu *smap;
-	u8 data[0] __aligned(8);
+	u8 data[] __aligned(8);
 };
 
 /* Linked to bpf_sk_storage and bpf_sk_storage_map */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f8af5e2d748b..295d761cbfb1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4232,7 +4232,7 @@ struct devlink_fmsg_item {
 	int attrtype;
 	u8 nla_type;
 	u16 len;
-	int value[0];
+	int value[];
 };
 
 struct devlink_fmsg {
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index d58c1c45a895..8e33cec9fc4e 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -68,7 +68,7 @@ struct net_dm_hw_entry {
 
 struct net_dm_hw_entries {
 	u32 num_entries;
-	struct net_dm_hw_entry entries[0];
+	struct net_dm_hw_entry entries[];
 };
 
 struct per_cpu_dm_data {
-- 
2.25.0

