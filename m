Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F52C1381C
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 09:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfEDH1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 03:27:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48432 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbfEDH1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 03:27:03 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C338F1F97E7787E56504;
        Sat,  4 May 2019 15:27:01 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 15:26:52 +0800
Subject: [PATCH iproute2 v3] ipnetns: use-after-free problem in
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
Message-ID: <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
Date:   Sat, 4 May 2019 15:26:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
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
v2->v3: add Cc:netdev@vger.kernel.org suggested by Phil Sutter
v1->v2: correct commit log

 ip/ipnetns.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 430d884..d72be95 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -107,7 +107,7 @@ int get_netnsid_from_name(const char *name)
 	struct nlmsghdr *answer;
 	struct rtattr *tb[NETNSA_MAX + 1];
 	struct rtgenmsg *rthdr;
-	int len, fd;
+	int len, fd, ret = -1;

 	netns_nsid_socket_init();

@@ -134,8 +134,9 @@ int get_netnsid_from_name(const char *name)
 	parse_rtattr(tb, NETNSA_MAX, NETNS_RTA(rthdr), len);

 	if (tb[NETNSA_NSID]) {
+		ret = rta_getattr_u32(tb[NETNSA_NSID]);
 		free(answer);
-		return rta_getattr_u32(tb[NETNSA_NSID]);
+		return ret;
 	}

 err_out:
-- 
1.8.3.1



