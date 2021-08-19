Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF33F0FE5
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 03:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhHSBRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 21:17:55 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38387 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232954AbhHSBRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 21:17:54 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3Aoy8nKq8o5aNhzGtzKHluk+DkI+orL9Y04lQ7?=
 =?us-ascii?q?vn2ZKCYlFvBw8vrCoB1173HJYUkqMk3I9ergBEDiewK4yXcW2/hzAV7KZmCP11?=
 =?us-ascii?q?dAR7sSj7cKrQeBJwTOssZZ1YpFN5N1EcDMCzFB5vrS0U2VFMkBzbC8nJyVuQ?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,333,1620662400"; 
   d="scan'208";a="113098373"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Aug 2021 09:17:17 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 754484D0D4BB;
        Thu, 19 Aug 2021 09:17:16 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 19 Aug 2021 09:17:16 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 19 Aug 2021 09:17:15 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 19 Aug 2021 09:17:15 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <philip.li@intel.com>, <yifeix.zhu@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        "kernel test robot" <lkp@intel.com>
Subject: [PATCH v2] selftests/bpf: enlarge select() timeout for test_maps
Date:   Thu, 19 Aug 2021 09:15:06 +0800
Message-ID: <20210819011506.27563-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 754484D0D4BB.A0EA7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0Day robot observed that it's easily timeout on a heavy load host.
-------------------
 # selftests: bpf: test_maps
 # Fork 1024 tasks to 'test_update_delete'
 # Fork 1024 tasks to 'test_update_delete'
 # Fork 100 tasks to 'test_hashmap'
 # Fork 100 tasks to 'test_hashmap_percpu'
 # Fork 100 tasks to 'test_hashmap_sizes'
 # Fork 100 tasks to 'test_hashmap_walk'
 # Fork 100 tasks to 'test_arraymap'
 # Fork 100 tasks to 'test_arraymap_percpu'
 # Failed sockmap unexpected timeout
 not ok 3 selftests: bpf: test_maps # exit=1
 # selftests: bpf: test_lru_map
 # nr_cpus:8
-------------------
Since this test will be scheduled by 0Day to a random host that could have
only a few cpus(2-8), enlarge the timeout to avoid a false NG report.

In practice, i tried to pin it to only one cpu by 'taskset 0x01 ./test_maps',
and knew 10S is likely enough, but i still perfer to a larger value 30.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

---
V2: update to 30 seconds
3S is not enough sometimes on a very busy host
taskset 1,1 ./test_maps 9
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
Failed sockmap unexpected timeout

taskset 1,1 ./test_maps 10
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
test_array_map_batch_ops:PASS
test_array_percpu_map_batch_ops:PASS
test_htab_map_batch_ops:PASS
test_htab_percpu_map_batch_ops:PASS
test_lpm_trie_map_batch_ops:PASS
test_sk_storage_map:PASS
test_maps: OK, 0 SKIPPED

taskset 0x01 ./test_maps 9
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
test_array_map_batch_ops:PASS
test_array_percpu_map_batch_ops:PASS
test_htab_map_batch_ops:PASS
test_htab_percpu_map_batch_ops:PASS
test_lpm_trie_map_batch_ops:PASS
test_sk_storage_map:PASS
test_maps: OK, 0 SKIPPED

taskset 0x01 ./test_maps 10
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
Fork 1024 tasks to 'test_update_delete'
Fork 1024 tasks to 'test_update_delete'
Fork 100 tasks to 'test_hashmap'
Fork 100 tasks to 'test_hashmap_percpu'
Fork 100 tasks to 'test_hashmap_sizes'
Fork 100 tasks to 'test_hashmap_walk'
Fork 100 tasks to 'test_arraymap'
Fork 100 tasks to 'test_arraymap_percpu'
test_array_map_batch_ops:PASS
test_array_percpu_map_batch_ops:PASS
test_htab_map_batch_ops:PASS
test_htab_percpu_map_batch_ops:PASS
test_lpm_trie_map_batch_ops:PASS
test_sk_storage_map:PASS
test_maps: OK, 0 SKIPPED

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/bpf/test_maps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 30cbf5d98f7d..de58a3070eea 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -985,7 +985,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 
 		FD_ZERO(&w);
 		FD_SET(sfd[3], &w);
-		to.tv_sec = 1;
+		to.tv_sec = 30;
 		to.tv_usec = 0;
 		s = select(sfd[3] + 1, &w, NULL, NULL, &to);
 		if (s == -1) {
-- 
2.32.0



