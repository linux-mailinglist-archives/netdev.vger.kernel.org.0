Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6E53A7500
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFOD1J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Jun 2021 23:27:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6499 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhFOD1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:27:07 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3tsW4b0DzZdwX;
        Tue, 15 Jun 2021 11:22:07 +0800 (CST)
Received: from dggpemm100021.china.huawei.com (7.185.36.105) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:25:02 +0800
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggpemm100021.china.huawei.com (7.185.36.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:25:01 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2176.012;
 Tue, 15 Jun 2021 11:25:01 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: use-after-free in i40e_sync_vsi_filters
Thread-Topic: use-after-free in i40e_sync_vsi_filters
Thread-Index: Addhk6+18AK5wpDhTAOw8dGLx5Y4sA==
Date:   Tue, 15 Jun 2021 03:25:01 +0000
Message-ID: <bce7022aba1a48fa9fd2454bd56d66b7@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jun 11 21:32:45 euleros-pxe kernel: [17883.745427] BUG: KASAN: use-after-free in i40e_sync_vsi_filters+0x4f0/0x1850 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.745826] Read of size 4 at addr ffff88897b8fd518 by task kworker/0:3/1078495

Jun 11 21:32:45 euleros-pxe kernel: [17883.746184]
Jun 11 21:32:45 euleros-pxe kernel: [17883.746410] CPU: 0 PID: 1078495 Comm: kworker/0:3 Kdump: loaded Tainted: G
Jun 11 21:32:45 euleros-pxe kernel: [17883.746414] Hardware name: Huawei 1288H V5/BC11SPSCC0, BIOS 0.59 02/24/2018
Jun 11 21:32:45 euleros-pxe kernel: [17883.746449] Workqueue: i40e i40e_service_task [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.746453] Call Trace:
Jun 11 21:32:45 euleros-pxe kernel: [17883.746466]  dump_stack+0xc2/0x12e
Jun 11 21:32:45 euleros-pxe kernel: [17883.746481]  print_address_description+0x70/0x360
Jun 11 21:32:45 euleros-pxe kernel: [17883.746491]  ? vprintk_func+0x5e/0xf0
Jun 11 21:32:45 euleros-pxe kernel: [17883.746502]  kasan_report+0x1b2/0x330
Jun 11 21:32:45 euleros-pxe kernel: [17883.746604]  i40e_sync_vsi_filters+0x4f0/0x1850 [i40e]

 2492                 /* Now move all of the filters from the temp add list back to
 2493                  * the VSI's list.
 2494                  */
 2495                 spin_lock_bh(&vsi->mac_filter_hash_lock);
 2496                 hlist_for_each_entry_safe(new, h, &tmp_add_list, hlist) {
 2497                         /* Only update the state if we're still NEW */
 2498                         if (new->f->state == I40E_FILTER_NEW)   <------------------------------------------------------------------------------------
 2499                                 new->f->state = new->state;
 2500                         hlist_del(&new->hlist);
 2501                         kfree(new);
 2502                 }
 2503                 spin_unlock_bh(&vsi->mac_filter_hash_lock);
 2504                 kfree(add_list);
 2505                 add_list = NULL;
 2506         }


Jun 11 21:32:45 euleros-pxe kernel: [17883.746756]  i40e_sync_filters_subtask+0xe3/0x130 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.746790]  i40e_service_task+0x195/0x24c0 [i40e]

Jun 11 21:32:45 euleros-pxe kernel: [17883.747296] Allocated by task 2279810:
Jun 11 21:32:45 euleros-pxe kernel: [17883.747539]  kasan_kmalloc+0xa0/0xd0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747546]  kmem_cache_alloc_trace+0xf3/0x1e0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747578]  i40e_add_filter+0x127/0x2b0 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.747617]  i40e_add_mac_filter+0x156/0x190 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.747653]  i40e_addr_sync+0x2d/0x40 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.747661]  __hw_addr_sync_dev+0x154/0x210
Jun 11 21:32:45 euleros-pxe kernel: [17883.747691]  i40e_set_rx_mode+0x6d/0xf0 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.747699]  __dev_set_rx_mode+0xfb/0x1f0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747706]  __dev_mc_add+0x6c/0x90
Jun 11 21:32:45 euleros-pxe kernel: [17883.747720]  igmp6_group_added+0x214/0x230
Jun 11 21:32:45 euleros-pxe kernel: [17883.747727]  __ipv6_dev_mc_inc+0x338/0x4f0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747736]  addrconf_join_solict.part.7+0xa2/0xd0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747742]  addrconf_dad_work+0x500/0x980
Jun 11 21:32:45 euleros-pxe kernel: [17883.747749]  process_one_work+0x3f5/0x7d0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747755]  worker_thread+0x61/0x6c0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747766]  kthread+0x1c3/0x1f0
Jun 11 21:32:45 euleros-pxe kernel: [17883.747773]  ret_from_fork+0x35/0x40

Jun 11 21:32:45 euleros-pxe kernel: [17883.748016] Freed by task 2547073:
Jun 11 21:32:45 euleros-pxe kernel: [17883.748262]  __kasan_slab_free+0x130/0x180
Jun 11 21:32:45 euleros-pxe kernel: [17883.748268]  kfree+0x90/0x1b0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748299]  __i40e_del_filter+0xa3/0xf0 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.748330]  i40e_del_mac_filter+0xf3/0x130 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.748366]  i40e_addr_unsync+0x85/0xa0 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.748373]  __hw_addr_sync_dev+0x9d/0x210
Jun 11 21:32:45 euleros-pxe kernel: [17883.748403]  i40e_set_rx_mode+0x6d/0xf0 [i40e]
Jun 11 21:32:45 euleros-pxe kernel: [17883.748414]  __dev_set_rx_mode+0xfb/0x1f0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748421]  __dev_mc_del+0x69/0x80
Jun 11 21:32:45 euleros-pxe kernel: [17883.748433]  igmp6_group_dropped+0x279/0x510
Jun 11 21:32:45 euleros-pxe kernel: [17883.748440]  __ipv6_dev_mc_dec+0x174/0x220
Jun 11 21:32:45 euleros-pxe kernel: [17883.748449]  addrconf_leave_solict.part.8+0xa2/0xd0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748457]  __ipv6_ifa_notify+0x4cd/0x570
Jun 11 21:32:45 euleros-pxe kernel: [17883.748465]  ipv6_ifa_notify+0x58/0x80
Jun 11 21:32:45 euleros-pxe kernel: [17883.748474]  ipv6_del_addr+0x259/0x4a0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748480]  inet6_addr_del+0x188/0x260
Jun 11 21:32:45 euleros-pxe kernel: [17883.748486]  addrconf_del_ifaddr+0xcc/0x130
Jun 11 21:32:45 euleros-pxe kernel: [17883.748493]  inet6_ioctl+0x152/0x190
Jun 11 21:32:45 euleros-pxe kernel: [17883.748501]  sock_do_ioctl+0xd8/0x2b0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748509]  sock_ioctl+0x2e5/0x4c0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748516]  do_vfs_ioctl+0x14e/0xa80
Jun 11 21:32:45 euleros-pxe kernel: [17883.748528]  ksys_ioctl+0x7c/0xa0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748535]  __x64_sys_ioctl+0x42/0x50
Jun 11 21:32:45 euleros-pxe kernel: [17883.748543]  do_syscall_64+0x98/0x2c0
Jun 11 21:32:45 euleros-pxe kernel: [17883.748552]  entry_SYSCALL_64_after_hwframe+0x65/0xca

The problem is obvious:
CPU0:									CPU1
i40e_sync_vsi_filters()
	spin_lock_bh(&vsi->mac_filter_hash_lock);
		new->f = f;
		new->state = f->state;
	spin_unlock_bh(&vsi->mac_filter_hash_lock);

									 __i40e_del_filter()
										kfree(f)

	spin_lock_bh(&vsi->mac_filter_hash_lock);
		hlist_for_each_entry_safe(new, h, &tmp_add_list, hlist) {
		
			if (new->f->state == I40E_FILTER_NEW)
				new->f->state = new->state;
	}
	spin_unlock_bh(&vsi->mac_filter_hash_lock);


Do you have a way to fix it? 

Thanks

