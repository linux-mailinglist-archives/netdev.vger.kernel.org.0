Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BD14E1EB5
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 02:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiCUB0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 21:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiCUB0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 21:26:35 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2048B275DE;
        Sun, 20 Mar 2022 18:25:11 -0700 (PDT)
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 22L1OQ9W020821;
        Mon, 21 Mar 2022 10:24:26 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Mon, 21 Mar 2022 10:24:26 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 22L1OOpR020816
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 21 Mar 2022 10:24:25 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <49925af7-78a8-a3dd-bce6-cfc02e1a9236@I-love.SAKURA.ne.jp>
Date:   Mon, 21 Mar 2022 10:24:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: An announcement for kernel-global workqueue users.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_SBL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

The Linux kernel provides kernel-global WQs (namely, system_wq, system_highpri_wq,
system_long_wq, system_unbound_wq, system_freezable_wq, system_power_efficient_wq
and system_freezable_power_efficient_wq). But since attempt to flush kernel-global
WQs has possibility of deadlock, Tejun Heo thinks that we should stop calling
flush_scheduled_work() and flush_workqueue(system_*). Such callers as of Linux 5.17
are listed below.

----------
$ git grep -nF 'flush_scheduled_work()'
drivers/acpi/osl.c:1182:         * invoke flush_scheduled_work()/acpi_os_wait_events_complete() to flush
drivers/acpi/osl.c:1575:        flush_scheduled_work();
drivers/block/aoe/aoedev.c:324: flush_scheduled_work();
drivers/block/aoe/aoedev.c:523: flush_scheduled_work();
drivers/crypto/atmel-ecc.c:401: flush_scheduled_work();
drivers/crypto/atmel-sha204a.c:162:     flush_scheduled_work();
drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c:2606:       flush_scheduled_work();
drivers/gpu/drm/bridge/lontium-lt9611uxc.c:985: flush_scheduled_work();
drivers/gpu/drm/i915/display/intel_display.c:10790:     flush_scheduled_work();
drivers/gpu/drm/i915/gt/selftest_execlists.c:87:        flush_scheduled_work();
drivers/iio/light/tsl2563.c:811:        flush_scheduled_work();
drivers/infiniband/hw/mlx4/cm.c:511:            flush_scheduled_work();
drivers/infiniband/hw/mlx4/cm.c:543:            flush_scheduled_work(); /* make sure all timers were flushed */
drivers/infiniband/ulp/isert/ib_isert.c:2639:   flush_scheduled_work();
drivers/input/mouse/psmouse-smbus.c:320:        flush_scheduled_work();
drivers/md/dm.c:229:    flush_scheduled_work();
drivers/message/fusion/mptscsih.c:1234: flush_scheduled_work();
drivers/net/phy/phy.c:1060:     /* Cannot call flush_scheduled_work() here as desired because
drivers/net/usb/lan78xx.c:3240:  * can't flush_scheduled_work() until we drop rtnl (later),
drivers/net/usb/usbnet.c:853:    * can't flush_scheduled_work() until we drop rtnl (later),
drivers/net/wireless/ath/ath6kl/usb.c:481:      flush_scheduled_work();
drivers/net/wwan/wwan_hwsim.c:537:      flush_scheduled_work();         /* Wait deletion works completion */
drivers/nvme/target/configfs.c:1557:    flush_scheduled_work();
drivers/nvme/target/rdma.c:1587:                flush_scheduled_work();
drivers/nvme/target/rdma.c:2056:        flush_scheduled_work();
drivers/nvme/target/tcp.c:1818:         flush_scheduled_work();
drivers/nvme/target/tcp.c:1879: flush_scheduled_work();
drivers/nvme/target/tcp.c:1884: flush_scheduled_work();
drivers/platform/surface/surface_acpi_notify.c:863:     flush_scheduled_work();
drivers/power/supply/ab8500_btemp.c:975:        flush_scheduled_work();
drivers/power/supply/ab8500_chargalg.c:1993:    flush_scheduled_work();
drivers/power/supply/ab8500_charger.c:3400:     flush_scheduled_work();
drivers/power/supply/ab8500_fg.c:3021:  flush_scheduled_work();
drivers/rapidio/devices/tsi721.c:2944:  flush_scheduled_work();
drivers/rtc/dev.c:99:                   flush_scheduled_work();
drivers/scsi/mpt3sas/mpt3sas_scsih.c:12409:     flush_scheduled_work();
drivers/scsi/qla2xxx/qla_target.c:1568:         flush_scheduled_work();
drivers/staging/olpc_dcon/olpc_dcon.c:386:      flush_scheduled_work();
sound/soc/intel/atom/sst/sst.c:363:     flush_scheduled_work();
$ git grep -nF 'flush_workqueue(system_'
drivers/block/rnbd/rnbd-clt.c:1776:     flush_workqueue(system_long_wq);
drivers/infiniband/core/device.c:2857:  flush_workqueue(system_unbound_wq);
include/linux/workqueue.h:592:  flush_workqueue(system_wq);
----------

I tried to send a patch that emits a warning when flushing kernel-global WQs is attempted
( https://lkml.kernel.org/r/2efd5461-fccd-f1d9-7138-0a6767cbf5fe@I-love.SAKURA.ne.jp ).
But Linus does not want such patch
( https://lkml.kernel.org/r/CAHk-=whWreGjEQ6yasspzBrNnS7EQiL+SknToWt=SzUh4XomyQ@mail.gmail.com ).

Steps for converting kernel-global WQs into module's local WQs are shown below.
But since an oversight in Step 4 results in breakage, I think that this conversion
should be carefully handled by maintainers/developers of each module who are
familiar with that module. (This is why I'm sending this mail than sending patches,
in order to ask for your cooperation.)

----------
Step 0: Consider if flushing kernel-global WQs is unavoidable.

    For example, commit 081bdc9fe05bb232 ("RDMA/ib_srp: Fix a deadlock")
    simply removed flush_workqueue(system_long_wq) call.

    For another example, schedule_on_each_cpu() does not need to call
    flush_scheduled_work() because schedule_on_each_cpu() knows the list
    of all "struct work_struct" instances which need to be flushed using
    flush_work() call.

    If flushing kernel-global WQs is still unavoidable, please proceed to
    the following steps.

Step 1: Declare a variable for your module.

    struct workqueue_struct *my_wq;

Step 2: Create a WQ for your module from __init function. The same flags
        used by corresponding kernel-global WQ can be used when creating
        the WQ for your module.

    my_wq = alloc_workqueue("my_wq_name", 0, 0);

Step 3: Destroy the WQ created in Step 2 from __exit function (and the error
        handling path of __init function if __init function may fail after
        creating the WQ).

    destroy_workqueue(my_wq);

Step 4: Replace e.g. schedule_work() call with corresponding queue_work() call
        throughout your module which should be handled by the WQ for your module.

Step 5: Replace flush_scheduled_work() and flush_workqueue(system_*) calls
        with flush_workqueue() of the WQ for your module.

    flush_workqueue(my_wq);
----------

Regards.
