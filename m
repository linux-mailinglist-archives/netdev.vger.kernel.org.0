Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855C160C45B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiJYG41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiJYG4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:56:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC17A7269C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 23:55:03 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1onDq0-0002Uw-Vx; Tue, 25 Oct 2022 08:55:01 +0200
Message-ID: <fd36057a-e8d9-38a3-4116-db3f674ea5af@pengutronix.de>
Date:   Tue, 25 Oct 2022 08:54:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [BUG] use-after-free after removing UDC with USB Ethernet gadget
Cc:     Peter Chen <peter.chen@kernel.org>,
        Felipe Balbi <balbi@kernel.org>, johannes.berg@intel.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everybody,

I am running v6.0.2 and can reliably trigger a use-after-free by allocating
a USB gadget, binding it to the chipidea UDC and the removing the UDC.

The network interface is not removed, but the chipidea SoC glue driver will
remove the platform_device it had allocated in the probe, which is apparently
the parent of the network device. When rtnl_fill_ifinfo runs, it will access the
device parent's name for IFLA_PARENT_DEV_NAME, which is now freed memory.

Steps to reproduce (on an i.MX8MM):

  cd /sys/kernel/config/usb_gadget/
  mkdir -p mygadget
  cd mygadget

  mkdir -p configs/c.1/strings/0x409
  echo "C1:Composite Device" > configs/c.1/strings/0x409/configuration

  mkdir -p functions/ecm.usb0
  ln -s functions/ecm.usb0 configs/c.1/

  echo "ci_hdrc.0" > UDC
  echo ci_hdrc.0 > /sys/class/udc/ci_hdrc.0/device/driver/unbind

  ip --details link show usb0

This gives me following KASAN report (v6.0.2 line numbers):

  [40645.265092] BUG: KASAN: use-after-free in rtnl_fill_ifinfo (./include/linux/device.h:704 ./net/core/rtnetlink.c:1859)
  [40645.271855] Read of size 8 at addr ffff000007350550 by task systemd-udevd/348
  [40645.279028]
  [40645.280552] CPU: 2 PID: 348 Comm: systemd-udevd Not tainted 6.0.2-00001-g749cbdda068b #17
  [40645.288761] Hardware name: InnoComm WB15-EVK (DT)
  [40645.293510] Call trace:
  [40645.295983] dump_backtrace (./arch/arm64/kernel/stacktrace.c:184)
  [40645.299782] show_stack (./arch/arm64/kernel/stacktrace.c:191)
  [40645.303109] dump_stack_lvl (./lib/dump_stack.c:107 (discriminator 1))
  [40645.306789] print_report (./include/linux/mm.h:851 ./mm/kasan/report.c:214 ./mm/kasan/report.c:315 ./mm/kasan/report.c:433)
  [40645.310463] kasan_report (./mm/kasan/report.c:497)
  [40645.313962] __asan_report_load8_noabort (./mm/kasan/report_generic.c:307 (discriminator 4))
  [40645.318764] rtnl_fill_ifinfo (./include/linux/device.h:704 ./net/core/rtnetlink.c:1859)
  [40645.322956] rtnl_getlink (./net/core/rtnetlink.c:3695)
  [40645.326624] rtnetlink_rcv_msg (./net/core/rtnetlink.c:6090)
  [40645.330735] netlink_rcv_skb (./net/netlink/af_netlink.c:2501)
  [40645.334670] rtnetlink_rcv (./net/core/rtnetlink.c:6109)
  [40645.338255] netlink_unicast (./net/netlink/af_netlink.c:1320 ./net/netlink/af_netlink.c:1345)
  [40645.342189] netlink_sendmsg (./net/netlink/af_netlink.c:1921)
  [40645.346122] __sys_sendto (./net/socket.c:717 ./net/socket.c:734 ./net/socket.c:2117)
  [40645.349797] __arm64_sys_sendto (./net/socket.c:2125)
  [40645.353905] invoke_syscall (./arch/arm64/kernel/syscall.c:38 ./arch/arm64/kernel/syscall.c:52)
  [40645.357671] el0_svc_common.constprop.0 (./arch/arm64/kernel/syscall.c:149)
  [40645.362560] do_el0_svc (./arch/arm64/kernel/syscall.c:207)
  [40645.365884] el0_svc (./arch/arm64/kernel/entry-common.c:133 ./arch/arm64/kernel/entry-common.c:142 ./arch/arm64/kernel/entry-common.c:625)
  [40645.368952] el0t_64_sync_handler (./arch/arm64/kernel/entry-common.c:643)
  [40645.373233] el0t_64_sync (./arch/arm64/kernel/entry.S:581)
  [40645.376906]
  [40645.378402] Allocated by task 9:
  [40645.381637] kasan_save_stack (./mm/kasan/common.c:39)
  [40645.385486] __kasan_kmalloc (./mm/kasan/common.c:45 ./mm/kasan/common.c:437 ./mm/kasan/common.c:516 ./mm/kasan/common.c:525)
  [40645.389246] __kmalloc_node_track_caller (./include/linux/kasan.h:234 ./mm/slub.c:4969)
  [40645.394221] devm_kmalloc (./drivers/base/devres.c:116 ./drivers/base/devres.c:823)
  [40645.397810] ci_hdrc_probe (./include/linux/device.h:209 ./drivers/usb/chipidea/core.c:1021)
  [40645.401574] platform_probe (./drivers/base/platform.c:1401)
  [40645.405331] really_probe (./drivers/base/dd.c:560 ./drivers/base/dd.c:639)
  [40645.409001] __driver_probe_device (./drivers/base/dd.c:778)
  [40645.413451] driver_probe_device (./drivers/base/dd.c:808)
  [40645.417644] __device_attach_driver (./drivers/base/dd.c:937)
  [40645.422182] bus_for_each_drv (./drivers/base/bus.c:427)
  [40645.426203] __device_attach (./drivers/base/dd.c:1010)
  [40645.430132] device_initial_probe (./drivers/base/dd.c:1058)
  [40645.434326] bus_probe_device (./drivers/base/bus.c:489)
  [40645.438341] device_add (./drivers/base/core.c:3524)
  [40645.441926] platform_device_add (./drivers/base/platform.c:717)
  [40645.446205] ci_hdrc_add_device (./drivers/usb/chipidea/core.c:879 ./drivers/usb/chipidea/core.c:847)
  [40645.450401] ci_hdrc_imx_probe (./drivers/usb/chipidea/ci_hdrc_imx.c:449)
  [40645.454593] platform_probe (./drivers/base/platform.c:1401)
  [40645.458349] really_probe (./drivers/base/dd.c:560 ./drivers/base/dd.c:639)
  [40645.462017] __driver_probe_device (./drivers/base/dd.c:778)
  [40645.466470] driver_probe_device (./drivers/base/dd.c:808)
  [40645.470662] __device_attach_driver (./drivers/base/dd.c:937)
  [40645.475201] bus_for_each_drv (./drivers/base/bus.c:427)
  [40645.479220] __device_attach (./drivers/base/dd.c:1010)
  [40645.483151] device_initial_probe (./drivers/base/dd.c:1058)
  [40645.487343] bus_probe_device (./drivers/base/bus.c:489)
  [40645.491359] deferred_probe_work_func (./drivers/base/dd.c:124)
  [40645.496072] process_one_work (./arch/arm64/include/asm/jump_label.h:21 ./include/linux/jump_label.h:207 ./include/trace/events/workqueue.h:108 ./kernel/workqueue.c:2294)
  [40645.500179] worker_thread (./include/linux/list.h:292 ./kernel/workqueue.c:2349 ./kernel/workqueue.c:2441)
  [40645.503934] kthread (./kernel/kthread.c:376)
  [40645.507173] ret_from_fork (./arch/arm64/kernel/entry.S:861)
  [40645.510758]
  [40645.512252] Freed by task 343:
  [40645.515312] kasan_save_stack (./mm/kasan/common.c:39)
  [40645.519158] kasan_set_track (./mm/kasan/common.c:45)
  [40645.522917] kasan_set_free_info (./include/linux/kasan.h:59 ./mm/kasan/generic.c:372)
  [40645.527024] ____kasan_slab_free (./mm/kasan/common.c:369 ./mm/kasan/common.c:329)
  [40645.531306] __kasan_slab_free (./mm/kasan/common.c:376)
  [40645.535237] slab_free_freelist_hook (./mm/slub.c:1785)
  [40645.539778] kfree (./mm/slub.c:3539 (discriminator 4) ./mm/slub.c:4567 (discriminator 4))
  [40645.542756] release_nodes (./drivers/base/devres.c:498)
  [40645.546427] devres_release_all (./drivers/base/devres.c:531)
  [40645.550621] device_unbind_cleanup (./drivers/base/dd.c:532)
  [40645.554985] device_release_driver_internal (./drivers/base/dd.c:1257 ./drivers/base/dd.c:1275)
  [40645.560221] device_driver_detach (./drivers/base/dd.c:1312)
  [40645.564414] unbind_store (./drivers/base/bus.c:196)
  [40645.568087] drv_attr_store (./drivers/base/bus.c:79)
  [40645.571760] sysfs_kf_write (./fs/sysfs/file.c:137)
  [40645.575520] kernfs_fop_write_iter (./fs/kernfs/file.c:354)
  [40645.579973] vfs_write (./include/linux/fs.h:2187 ./fs/read_write.c:491 ./fs/read_write.c:584)
  [40645.583385] ksys_write (./fs/read_write.c:637)
  [40645.586796] __arm64_sys_write (./fs/read_write.c:646)
  [40645.590730] invoke_syscall (./arch/arm64/kernel/syscall.c:38 ./arch/arm64/kernel/syscall.c:52)
  [40645.594488] el0_svc_common.constprop.0 (./arch/arm64/include/asm/daifflags.h:28 ./arch/arm64/kernel/syscall.c:150)
  [40645.599289] do_el0_svc (./arch/arm64/kernel/syscall.c:207)
  [40645.602615] el0_svc (./arch/arm64/kernel/entry-common.c:133 ./arch/arm64/kernel/entry-common.c:142 ./arch/arm64/kernel/entry-common.c:625)
  [40645.605678] el0t_64_sync_handler (./arch/arm64/kernel/entry-common.c:643)
  [40645.609958] el0t_64_sync (./arch/arm64/kernel/entry.S:581)
  [40645.613626]
  [40645.615121] Last potentially related work creation:
  [40645.620002] kasan_save_stack (./mm/kasan/common.c:39)
  [40645.623848] __kasan_record_aux_stack (./mm/kasan/generic.c:348)
  [40645.628388] kasan_record_aux_stack_noalloc (./mm/kasan/generic.c:359)
  [40645.633448] insert_work (./include/asm-generic/bitops/generic-non-atomic.h:128 ./kernel/workqueue.c:635 ./kernel/workqueue.c:642 ./kernel/workqueue.c:1361)
  [40645.636944] __queue_work (./kernel/workqueue.c:1520)
  [40645.640614] queue_work_on (./kernel/workqueue.c:1546)
  [40645.644197] usb_gadget_set_state (./drivers/usb/gadget/udc/core.c:1049)
  [40645.648390] ci_hdrc_gadget_connect (./include/asm-generic/qspinlock.h:128 ./include/linux/spinlock.h:202 ./include/linux/spinlock_api_smp.h:158 ./include/linux/spinlock.h:399 ./drivers/usb/chipidea/udc.c:1684)
  [40645.652931] ci_udc_start (./drivers/usb/chipidea/udc.c:1955)
  [40645.656603] gadget_bind_driver (./drivers/usb/gadget/udc/core.c:1121 ./drivers/usb/gadget/udc/core.c:1499)
  [40645.660794] really_probe (./drivers/base/dd.c:560 ./drivers/base/dd.c:639)
  [40645.664463] __driver_probe_device (./drivers/base/dd.c:778)
  [40645.668913] driver_probe_device (./drivers/base/dd.c:808)
  [40645.673104] __driver_attach (./drivers/base/dd.c:1191)
  [40645.677035] bus_for_each_dev (./drivers/base/bus.c:301)
  [40645.681053] driver_attach (./drivers/base/dd.c:1208)
  [40645.684637] bus_add_driver (./drivers/base/bus.c:618)
  [40645.688481] driver_register (./drivers/base/driver.c:246)
  [40645.692412] usb_gadget_register_driver_owner (./drivers/usb/gadget/udc/core.c:1560)
  [40645.697732] gadget_dev_desc_UDC_store (./drivers/usb/gadget/configfs.c:287)
  [40645.702535] configfs_write_iter (./fs/configfs/file.c:207 ./fs/configfs/file.c:229)
  [40645.706815] vfs_write (./include/linux/fs.h:2187 ./fs/read_write.c:491 ./fs/read_write.c:584)
  [40645.710226] ksys_write (./fs/read_write.c:637)
  [40645.713636] __arm64_sys_write (./fs/read_write.c:646)
  [40645.717567] invoke_syscall (./arch/arm64/kernel/syscall.c:38 ./arch/arm64/kernel/syscall.c:52)
  [40645.721328] el0_svc_common.constprop.0 (./arch/arm64/include/asm/daifflags.h:28 ./arch/arm64/kernel/syscall.c:150)
  [40645.726129] do_el0_svc (./arch/arm64/kernel/syscall.c:207)
  [40645.729452] el0_svc (./arch/arm64/kernel/entry-common.c:133 ./arch/arm64/kernel/entry-common.c:142 ./arch/arm64/kernel/entry-common.c:625)
  [40645.732514] el0t_64_sync_handler (./arch/arm64/kernel/entry-common.c:643)
  [40645.736793] el0t_64_sync (./arch/arm64/kernel/entry.S:581)
  [40645.740461]
  [40645.741955] Second to last potentially related work creation:
  [40645.747706] kasan_save_stack (./mm/kasan/common.c:39)
  [40645.751552] __kasan_record_aux_stack (./mm/kasan/generic.c:348)
  [40645.756089] kasan_record_aux_stack_noalloc (./mm/kasan/generic.c:359)
  [40645.761151] insert_work (./include/asm-generic/bitops/generic-non-atomic.h:128 ./kernel/workqueue.c:635 ./kernel/workqueue.c:642 ./kernel/workqueue.c:1361)
  [40645.764646] __queue_work (./kernel/workqueue.c:1520)
  [40645.768317] queue_work_on (./kernel/workqueue.c:1546)
  [40645.771900] usb_add_gadget (./drivers/usb/gadget/udc/core.c:1310)
  [40645.775741] usb_add_gadget_udc (./drivers/usb/gadget/udc/core.c:1360 ./drivers/usb/gadget/udc/core.c:1407)
  [40645.779934] ci_hdrc_gadget_init (./drivers/usb/chipidea/udc.c:2121 ./drivers/usb/chipidea/udc.c:2207)
  [40645.784212] ci_hdrc_probe (./drivers/usb/chipidea/core.c:1121)
  [40645.788061] platform_probe (./drivers/base/platform.c:1401)
  [40645.791819] really_probe (./drivers/base/dd.c:560 ./drivers/base/dd.c:639)
  [40645.795486] __driver_probe_device (./drivers/base/dd.c:778)
  [40645.799939] driver_probe_device (./drivers/base/dd.c:808)
  [40645.804129] __device_attach_driver (./drivers/base/dd.c:937)
  [40645.808668] bus_for_each_drv (./drivers/base/bus.c:427)
  [40645.812688] __device_attach (./drivers/base/dd.c:1010)
  [40645.816618] device_initial_probe (./drivers/base/dd.c:1058)
  [40645.820808] bus_probe_device (./drivers/base/bus.c:489)
  [40645.824826] device_add (./drivers/base/core.c:3524)
  [40645.828413] platform_device_add (./drivers/base/platform.c:717)
  [40645.832690] ci_hdrc_add_device (./drivers/usb/chipidea/core.c:879 ./drivers/usb/chipidea/core.c:847)
  [40645.836882] ci_hdrc_imx_probe (./drivers/usb/chipidea/ci_hdrc_imx.c:449)
  [40645.841075] platform_probe (./drivers/base/platform.c:1401)
  [40645.844835] really_probe (./drivers/base/dd.c:560 ./drivers/base/dd.c:639)
  [40645.848504] __driver_probe_device (./drivers/base/dd.c:778)
  [40645.852956] driver_probe_device (./drivers/base/dd.c:808)
  [40645.857148] __device_attach_driver (./drivers/base/dd.c:937)
  [40645.861687] bus_for_each_drv (./drivers/base/bus.c:427)
  [40645.865705] __device_attach (./drivers/base/dd.c:1010)
  [40645.869634] device_initial_probe (./drivers/base/dd.c:1058)
  [40645.873825] bus_probe_device (./drivers/base/bus.c:489)
  [40645.877843] deferred_probe_work_func (./drivers/base/dd.c:124)
  [40645.882554] process_one_work (./arch/arm64/include/asm/jump_label.h:21 ./include/linux/jump_label.h:207 ./include/trace/events/workqueue.h:108 ./kernel/workqueue.c:2294)
  [40645.886657] worker_thread (./include/linux/list.h:292 ./kernel/workqueue.c:2349 ./kernel/workqueue.c:2441)
  [40645.890416] kthread (./kernel/kthread.c:376)
  [40645.893652] ret_from_fork (./arch/arm64/kernel/entry.S:861)
  [40645.897238]
  [40645.898732] The buggy address belongs to the object at ffff000007350000
  [40645.898732]  which belongs to the cache kmalloc-8k of size 8192
  [40645.911255] The buggy address is located 1360 bytes inside of
  [40645.911255]  8192-byte region [ffff000007350000, ffff000007352000)
  [40645.923174]
  [40645.924668] The buggy address belongs to the physical page:
  [40645.930249] page:000000007de421b8 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x47350
  [40645.939590] head:000000007de421b8 order:3 compound_mapcount:0 compound_pincount:0
  [40645.947080] flags: 0x10200(slab|head|node=0|zone=0)
  [40645.951980] raw: 0000000000010200 0000000000000000 dead000000000122 ffff000003c02c00
  [40645.959728] raw: 0000000000000000 0000000080020002 00000001ffffffff 0000000000000000
  [40645.967474] page dumped because: kasan: bad access detected
  [40645.973049]
  [40645.974541] Memory state around the buggy address:
  [40645.979340]  ffff000007350400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [40645.986568]  ffff000007350480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [40645.993795] >ffff000007350500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [40646.001021]                                                  ^
  [40646.006860]  ffff000007350580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [40646.014089]  ffff000007350600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  [40646.021315] ==================================================================
  [40646.028664] Disabling lock debugging due to kernel taint


I originally thought it to be a regression, because after going from
v5.18.5 to v6.0.2, an oops started to appear on every reboot.
With the script above I can reproduce this with v5.18.5 though too.
Looks like the freed memory is now reused in my configuration, whereas before
it wasn't. Nevertheless, here's the KASAN log during shutdown (line numbers
are a bit off, because the system below is running v6.0.2 with PREEMPT_RT and
a couple more patches):


  [  538.506709] ==================================================================
  [  538.514542] BUG: KASAN: use-after-free in rtnl_fill_ifinfo (./include/linux/device.h:704 (discriminator 1) ./net/core/rtnetlink.c:1859 (discriminator 1))
  [  538.521316] Read of size 8 at addr ffff0000075ec568 by task mdnsd/908
  [  538.527795]
  [  538.529311] CPU: 1 PID: 908 Comm: mdnsd Tainted: G           O       6.0.2-20221018-2-rt9 #1
  [  538.529328] Hardware name: Some i.MX8MM Innocomm WB15 based system (DT)
  [  538.529339] Call trace:
  [  538.529343] dump_backtrace (./arch/arm64/kernel/stacktrace.c:184)
  [  538.529368] show_stack (./arch/arm64/kernel/stacktrace.c:191)
  [  538.529382] dump_stack_lvl (./lib/dump_stack.c:107 (discriminator 1))
  [  538.529405] print_report (./include/linux/mm.h:851 ./mm/kasan/report.c:214 ./mm/kasan/report.c:315 ./mm/kasan/report.c:433)
  [  538.529422] kasan_report (./mm/kasan/report.c:162 ./mm/kasan/report.c:497)
  [  538.529437] __asan_load8 (./mm/kasan/generic.c:256)
  [  538.529451] rtnl_fill_ifinfo (./include/linux/device.h:704 (discriminator 1) ./net/core/rtnetlink.c:1859 (discriminator 1))
  [  538.529474] rtnl_dump_ifinfo (./net/core/rtnetlink.c:2193)
  [  538.529495] netlink_dump (./net/netlink/af_netlink.c:2275)
  [  538.529515] netlink_recvmsg (./net/netlink/af_netlink.c:2002)
  [  538.529533] ____sys_recvmsg (./net/socket.c:995 ./net/socket.c:1013 ./net/socket.c:2701)
  [  538.529551] ___sys_recvmsg (./net/socket.c:2743)
  [  538.529568] __sys_recvmsg (./include/linux/file.h:31 ./net/socket.c:2775)
  [  538.529584] __arm64_sys_recvmsg (./net/socket.c:2780)
  [  538.529602] invoke_syscall (./arch/arm64/kernel/syscall.c:38 ./arch/arm64/kernel/syscall.c:52)
  [  538.529622] el0_svc_common.constprop.0 (./arch/arm64/include/asm/daifflags.h:28 ./arch/arm64/kernel/syscall.c:150)
  [  538.529644] do_el0_svc (./arch/arm64/kernel/syscall.c:207)
  [  538.529662] el0_svc (./arch/arm64/kernel/entry-common.c:133 ./arch/arm64/kernel/entry-common.c:142 ./arch/arm64/kernel/entry-common.c:625)
  [  538.529679] el0t_64_sync_handler (./arch/arm64/kernel/entry-common.c:643)
  [  538.529700] el0t_64_sync (./arch/arm64/kernel/entry.S:581)
  [  538.529781]
  [  538.623543] Allocated by task 0:
  [  538.627558] (stack is not available)
  [  538.631183]
  [  538.634283] Freed by task 2480:
  [  538.637460] kasan_save_stack (./mm/kasan/common.c:39)
  [  538.641409] kasan_set_track (./mm/kasan/common.c:45)
  [  538.645261] kasan_set_free_info (./include/linux/kasan.h:59 ./mm/kasan/generic.c:372)
  [  538.649415] ____kasan_slab_free (./mm/kasan/common.c:369 ./mm/kasan/common.c:329)
  [  538.654041] __kasan_slab_free (./mm/kasan/common.c:376)
  [  538.658057] slab_free_freelist_hook (./mm/slub.c:1696)
  [  538.662640] kfree (./mm/slub.c:3622 (discriminator 4) ./mm/slub.c:4648 (discriminator 4))
  [  538.667522] release_nodes (./drivers/base/devres.c:498 (discriminator 3))
  [  538.671171] devres_release_all (./drivers/base/devres.c:513)
  [  538.675325] device_unbind_cleanup (./drivers/base/dd.c:532)
  [  538.680658] device_release_driver_internal (./drivers/base/dd.c:1257 ./drivers/base/dd.c:1275)
  [  538.687827] device_release_driver (./drivers/base/dd.c:1299)
  [  538.692164] bus_remove_device (./drivers/base/bus.c:530)
  [  538.696317] device_del (./drivers/base/core.c:3705)
  [  538.700697] platform_device_del.part.0 (./drivers/base/platform.c:753)
  [  538.705473] platform_device_unregister (./drivers/base/platform.c:551 ./drivers/base/platform.c:794)
  [  538.710239] ci_hdrc_remove_device (./drivers/usb/chipidea/core.c:897)
  [  538.714619] ci_hdrc_imx_remove (./drivers/usb/chipidea/ci_hdrc_imx.c:526)
  [  538.718805] ci_hdrc_imx_shutdown (./drivers/usb/chipidea/ci_hdrc_imx.c:542)
  [  538.723046] platform_shutdown (./drivers/base/platform.c:1439)
  [  538.727565] device_shutdown (./include/linux/device.h:850 ./drivers/base/core.c:4668)
  [  538.731561] kernel_restart (./kernel/reboot.c:258)
  [  538.735277] __do_sys_reboot (./kernel/reboot.c:769)


Any pointers as to which UDC does this correctly, so the chipidea driver can
mimic it? Or is this something the network stack should've taken care of?

Thanks,
Ahmad

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
