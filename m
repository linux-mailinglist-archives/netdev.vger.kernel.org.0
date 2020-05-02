Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8DC1C247E
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 12:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEBK1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 06:27:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41548 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbgEBK1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 May 2020 06:27:35 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 26E951F4C475056ECB60;
        Sat,  2 May 2020 18:27:30 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.99) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sat, 2 May 2020
 18:27:22 +0800
To:     <tj@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "Libin (Huawei)" <huawei.libin@huawei.com>,
        <yangyingliang@huawei.com>, <guofan5@huawei.com>,
        <wangkefeng.wang@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Subject: cgroup pointed by sock is leaked on mode switch
Message-ID: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
Date:   Sat, 2 May 2020 18:27:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.166.215.99]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I got an oom panic because cgroup is leaked.

Here is the steps :
   - run a docker with --cap-add sys_admin parameter and the systemd 
process in the docker uses both cgroupv1 and cgroupv2
   - ssh/exit from host to docker repeately

I find the number nr_dying_descendants is increasing:
linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep 
'^nr_dying_descendants [^0]'  {} +
/sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
/sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
/sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants 
1
/sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
/sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants 
78
/sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants 
78


The situation is as same as the commit bd1060a1d671 ("sock, cgroup: add 
sock->sk_cgroup") describes.
"On mode switch, cgroup references which are already being pointed to by 
socks may be leaked."

Do we have a fix for this leak now ?

Or how  about fix this by record the cgrp2 pointer, then put it when sk 
is freeing like this:

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index d9bd671105e2..cbb1e76ea305 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -770,6 +770,7 @@ struct sock_cgroup_data {
  #endif
          u64        val;
      };
+    struct cgroup *cgrpv2;
  };

  /*
@@ -802,6 +803,7 @@ static inline void sock_cgroup_set_prioidx(struct 
sock_cgroup_data *skcd,
          return;

      if (!(skcd_buf.is_data & 1)) {
+        WRITE_ONCE(skcd->cgrpv2, skcd_buf.val);
          skcd_buf.val = 0;
          skcd_buf.is_data = 1;
      }
@@ -819,6 +821,7 @@ static inline void sock_cgroup_set_classid(struct 
sock_cgroup_data *skcd,
          return;

      if (!(skcd_buf.is_data & 1)) {
+        WRITE_ONCE(skcd->cgrpv2, skcd_buf.val);
          skcd_buf.val = 0;
          skcd_buf.is_data = 1;
      }
diff --git a/net/core/sock.c b/net/core/sock.c
index a0dda2bf9d7c..7c761ef2d32e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1520,6 +1520,10 @@ static void sk_prot_free(struct proto *prot, 
struct sock *sk)
      slab = prot->slab;

      cgroup_sk_free(&sk->sk_cgrp_data);
+    if (sk->sk_cgrp_data.cgrpv2) {
+        cgroup_put(sk->sk_cgrp_data.cgrpv2);
+        sk->sk_cgrp_data.cgrpv2 = NULL;
+    }
      mem_cgroup_sk_free(sk);
      security_sk_free(sk);
      if (slab != NULL)


Thanks,
Yang

