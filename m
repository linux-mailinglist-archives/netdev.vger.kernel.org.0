Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D62D3AAE03
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 09:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFQHyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 03:54:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4829 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFQHyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 03:54:01 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5Df15mp4zXg6h;
        Thu, 17 Jun 2021 15:46:49 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 15:51:52 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 15:51:51 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [BUG] Crash after module unload if it use DO_ONCE mechanism
To:     "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Message-ID: <eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com>
Date:   Thu, 17 Jun 2021 15:51:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

We met a crash[3] after module unload if it uses DO_ONCE mechanism,
also we could reproduce by the demo module[1] and the hack patch[2].

The DO_ONCE mechanism could be use directly(eg, testmgr.c), and there 
are some macro which is used by lots of net drivers,
"prandom_init_once"
"get_random_once/get_random_once_wait"
"net_get_random_once/net_get_random_once_wait"

The analysis of crash is as follows,

init_module
  get_random_once
   DO_ONCE
   DEFINE_STATIC_KEY_TRUE(___once_key);
   __do_once_done
     once_disable_jump(once_key);
       INIT_WORK(&w->work, once_deferred);
       struct once_work *w;
       w->key = key;
       schedule_work(&w->work);                    cleanup_module
                                                    *the key is destroy*
process_one_work
  once_deferred
    BUG_ON(!static_key_enabled(work->key));
       static_key_count((struct static_key *)x)   //*access key, crash*

I can't find a good way to fix the issue, any suggestion?

Thanks.



[1] test module
static int test;
int init_module(void) {
	pr_info("Hello\n");
	get_random_once(&test, sizeof(int));
	return 0;
}
void cleanup_module(void) {
	pr_info("Bye %x!\n", test);
}
[2] hack to add some delay
diff --git a/lib/once.c b/lib/once.c
index 8b7d6235217e..b56b8ced4bab 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -14,6 +14,7 @@ static void once_deferred(struct work_struct *w)
         struct once_work *work;

         work = container_of(w, struct once_work, work);
+       msleep(8000);
         BUG_ON(!static_key_enabled(work->key));
         static_branch_disable(work->key);
         kfree(work);

[3] crash log
[  253.560859] Hello
[  253.562851] Bye 92bbb335!
[  261.585813] Unable to handle kernel paging request at virtual address 
ffff000001293018
[  261.585815] Mem abort info:
[  261.585816]   ESR = 0x96000007
[  261.585817]   Exception class = DABT (current EL), IL = 32 bits
[  261.585818]   SET = 0, FnV = 0
[  261.585818]   EA = 0, S1PTW = 0
[  261.585819] Data abort info:
[  261.585820]   ISV = 0, ISS = 0x00000007
[  261.585821]   CM = 0, WnR = 0
[  261.585822] swapper pgtable: 4k pages, 48-bit VAs, pgdp = 
00000000e45c016c
[  261.585823] [ffff000001293018] pgd=000000023fffe003, 
pud=000000023354b003, pmd=00000001d4099003, pte=0000000000000000
[  261.585827] Internal error: Oops: 96000007 [#1] SMP
[  261.586458] Process kworker/25:1 (pid: 291, stack limit = 
0xffff0000841b0000)
[  261.586880] CPU: 25 PID: 291 Comm: kworker/25:1 Kdump: loaded 
Tainted: P        W  OE     4.19.90+ #14
[  261.587415] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 
02/06/2015
[  261.587819] Workqueue: events once_deferred
[  261.588062] pstate: 60c00005 (nZCv daif +PAN +UAO)
[  261.588341] pc : static_key_count+0x18/0x30
[  261.588584] lr : once_deferred+0x30/0x80
[  261.588810] sp : ffff0000841b3d70
[  261.589000] x29: ffff0000841b3d70 x28: 0000000000000000
[  261.589308] x27: 0000000000000000 x26: ffff00008131f330
[  261.589615] x25: 0000000000000000 x24: ffff8001defd1c08
[  261.590025] x23: 0000000000000000 x22: ffff8001ff4d3000
[  261.590414] x21: ffff8001ff4cee80 x20: ffff8001f3bbd100
[  261.590868] x19: ffff000001293018 x18: ffffffffffffffff
[  261.591254] x17: 0000000000000000 x16: 0000000000000000
[  261.591638] x15: ffff0000812fa748 x14: ffff0000814f1d50
[  261.592026] x13: ffff0000814f1996 x12: ffffffffffffffac
[  261.592409] x11: 0000000000000000 x10: 0000000000000b80
[  261.592794] x9 : ffff0000841b3bf0 x8 : 3535303030303030
[  261.593179] x7 : 303078302079656b x6 : ffff0000814f0f80
[  261.593564] x5 : 00ffffffffffffff x4 : 0000000000000000
[  261.593978] x3 : 0000000000000000 x2 : 173087582665d800
[  261.594362] x1 : 0000000000000000 x0 : ffff00008055a888
[  261.594748] Call trace:
[  261.594928]  static_key_count+0x18/0x30
[  261.595207]  once_deferred+0x30/0x80
[  261.595469]  process_one_work+0x1b8/0x458
[  261.595762]  worker_thread+0x158/0x498
[  261.596034]  kthread+0x134/0x138
[  261.596271]  ret_from_fork+0x10/0x18
[  261.596531] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (b9400260)

