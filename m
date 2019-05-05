Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86E1F13CB6
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 04:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEECAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 22:00:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726390AbfEECAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 22:00:34 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 96B4D66BF88C1F477657;
        Sun,  5 May 2019 10:00:31 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sun, 5 May 2019
 10:00:22 +0800
Subject: [PATCH iproute2 v4] ipnetns: use-after-free problem in
 get_netnsid_from_name func
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
To:     <stephen@networkplumber.org>, <liuhangbin@gmail.com>,
        <kuznet@ms2.inr.ac.ru>
CC:     <nicolas.dichtel@6wind.com>, <phil@nwl.cc>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>, <kouhuiying@huawei.com>,
        <netdev@vger.kernel.org>
References: <f6c76a60-d5c4-700f-2fbf-912fc1545a31@huawei.com>
 <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
 <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
Message-ID: <c28161a3-0a5a-a55f-485a-c5c44a697e6e@huawei.com>
Date:   Sun, 5 May 2019 09:59:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Follow the following steps:
# ip netns add net1
# export MALLOC_MMAP_THRESHOLD_=0
# ip netns list
then Segmentation fault (core dumped) will occur.

In get_netnsid_from_name func, answer is freed before rta_getattr_u32(tb[NETNSA_NSID]),
where tb[] refers to answer`s content. If we set MALLOC_MMAP_THRESHOLD_=0, mmap will
be adoped to malloc memory, which will be freed immediately after calling free func.
So reading tb[NETNSA_NSID] will access the released memory after free(answer).

Here, we will call get_netnsid_from_name(tb[NETNSA_NSID]) before free(answer).

Fixes: 86bf43c7c2f ("lib/libnetlink: update rtnl_talk to support malloc buff at run time")
Reported-by: Huiying Kou <kouhuiying@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Acked-by: Phil Sutter <phil@nwl.cc>
---
v3->v4: optimize code suggested by David Ahern
v2->v3: add Cc:netdev@vger.kernel.org suggested by Phil Sutter
v1->v2: correct commit log

 ip/ipnetns.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 430d884..52aefac 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -107,7 +107,7 @@ int get_netnsid_from_name(const char *name)
 	struct nlmsghdr *answer;
 	struct rtattr *tb[NETNSA_MAX + 1];
 	struct rtgenmsg *rthdr;
-	int len, fd;
+	int len, fd, ret = -1;

 	netns_nsid_socket_init();

@@ -124,23 +124,22 @@ int get_netnsid_from_name(const char *name)

 	/* Validate message and parse attributes */
 	if (answer->nlmsg_type == NLMSG_ERROR)
-		goto err_out;
+		goto out;

 	rthdr = NLMSG_DATA(answer);
 	len = answer->nlmsg_len - NLMSG_SPACE(sizeof(*rthdr));
 	if (len < 0)
-		goto err_out;
+		goto out;

 	parse_rtattr(tb, NETNSA_MAX, NETNS_RTA(rthdr), len);

 	if (tb[NETNSA_NSID]) {
-		free(answer);
-		return rta_getattr_u32(tb[NETNSA_NSID]);
+		ret = rta_getattr_u32(tb[NETNSA_NSID]);
 	}

-err_out:
+out:
 	free(answer);
-	return -1;
+	return ret;
 }

 struct nsid_cache {
-- 
1.8.3.1



