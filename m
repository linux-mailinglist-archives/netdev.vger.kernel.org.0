Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B565D3C8
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjADNHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbjADNGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:06:50 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070AA395C3;
        Wed,  4 Jan 2023 05:06:23 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304BjZfF013293;
        Wed, 4 Jan 2023 05:06:16 -0800
Received: from ala-exchng02.corp.ad.wrs.com (unknown-82-254.windriver.com [147.11.82.254])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3mth87tbv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Jan 2023 05:06:16 -0800
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 05:06:15 -0800
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 05:06:13 -0800
From:   Dongyang <dongyang626@gmail.com>
To:     <eric.dumazet@gmail.com>, <sargun@sargun.me>
CC:     <brucec@netflix.com>, <ghartmann@netflix.com>,
        <hannes@stressinduktion.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <penguin-kernel@i-love.sakura.ne.jp>,
        <rgulewich@netflix.com>, <dongyang626@gmail.com>
Subject: Re: Deadlock in cleanup_net and addrconf_verify_work locks up workqueue
Date:   Wed, 4 Jan 2023 21:06:12 +0800
Message-ID: <20230104130612.1361350-1-dongyang626@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <75e34850-54f5-6d08-e4f9-dd6e1e9ee09d@gmail.com>
References: <75e34850-54f5-6d08-e4f9-dd6e1e9ee09d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: gxFvnkUrMpq_PVicKZoRuvvxea8O_0Z4
X-Proofpoint-GUID: gxFvnkUrMpq_PVicKZoRuvvxea8O_0Z4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 clxscore=1034 mlxscore=0 suspectscore=0 phishscore=0
 mlxlogscore=816 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040111
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello guys,

At the beginning of the New Year, I also encountered this issue.  

Hi Sargun, 
Did you finally resolve this issue?  As it was passed ~3 years, hope you still remember something about this case, thanks. 

Hi Eric,
Below is my log, please let me give some feedback about your previous comments. Thanks.

Jan  1 00:06:30 kernel: [109121.968881] 000: perf: interrupt took too long (3914 > 3912), lowering kernel.perf_event_max_sample_rate to 51000
Jan  2 00:00:06 kernel: [195138.235171] 026: audit: type=1400 audit(1672588806.418:41): apparmor="DENIED" operation="capable" profile="/usr/sbin/cups-browsed" pid=6221 comm="cups-browsed" capability=23  capname="sys_nice"
Jan  2 00:04:08 kernel: [195380.604772] 027: INFO: task kworker/u56:2:6079 blocked for more than 122 seconds.
Jan  2 00:04:08 kernel: [195380.604776] 027:       Tainted: G           OE     5.4.161-rt67-rc1 #1
Jan  2 00:04:08 kernel: [195380.604777] 027: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  2 00:04:08 kernel: [195380.604779] 027: kworker/u56:2   D    0  6079      2 0x80084000
Jan  2 00:04:08 kernel: [195380.604789] 027: Workqueue: netns cleanup_net
Jan  2 00:04:08 kernel: [195380.604790] 027: Call Trace:
Jan  2 00:04:08 kernel: [195380.604793] 027:  __schedule+0x3d4/0x8a0
Jan  2 00:04:08 kernel: [195380.604799] 027:  ? __switch_to_asm+0x34/0x70
Jan  2 00:04:08 kernel: [195380.604801] 027:  schedule+0x49/0x100
Jan  2 00:04:08 kernel: [195380.604804] 027:  schedule_timeout+0x1ed/0x3b0
Jan  2 00:04:08 kernel: [195380.604807] 027:  wait_for_completion+0x86/0xe0
Jan  2 00:04:08 kernel: [195380.604810] 027:  __flush_work+0x121/0x1d0
Jan  2 00:04:08 kernel: [195380.604814] 027:  ? flush_workqueue_prep_pwqs+0x140/0x140
Jan  2 00:04:08 kernel: [195380.604817] 027:  flush_work+0x10/0x20
Jan  2 00:04:08 kernel: [195380.604819] 027:  rollback_registered_many+0x1b2/0x530
Jan  2 00:04:08 kernel: [195380.604824] 027:  unregister_netdevice_many.part.0+0x12/0x90
Jan  2 00:04:08 kernel: [195380.604826] 027:  default_device_exit_batch+0x15c/0x190
Jan  2 00:04:08 kernel: [195380.604828] 027:  ? do_wait_intr_irq+0x90/0x90
Jan  2 00:04:08 kernel: [195380.604832] 027:  ops_exit_list.isra.0+0x61/0x70
Jan  2 00:04:08 kernel: [195380.604835] 027:  cleanup_net+0x269/0x3a0
Jan  2 00:04:08 kernel: [195380.604837] 027:  process_one_work+0x1c8/0x470
Jan  2 00:04:08 kernel: [195380.604840] 027:  worker_thread+0x4a/0x3d0
Jan  2 00:04:08 kernel: [195380.604843] 027:  kthread+0x133/0x180
Jan  2 00:04:08 kernel: [195380.604846] 027:  ? process_one_work+0x470/0x470
Jan  2 00:04:08 kernel: [195380.604848] 027:  ? kthread_park+0x90/0x90
Jan  2 00:04:08 kernel: [195380.604850] 027:  ret_from_fork+0x35/0x40
Jan  2 00:06:11 kernel: [195503.484781] 000: INFO: task kworker/u56:2:6079 blocked for more than 245 seconds.
Jan  2 00:06:11 kernel: [195503.484784] 000:       Tainted: G           OE     5.4.161-rt67-rc1 #1
Jan  2 00:06:11 kernel: [195503.484786] 000: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  2 00:06:11 kernel: [195503.484788] 000: kworker/u56:2   D    0  6079      2 0x80084000
Jan  2 00:06:11 kernel: [195503.484797] 000: Workqueue: netns cleanup_net
Jan  2 00:06:11 kernel: [195503.484798] 000: Call Trace:
Jan  2 00:06:11 kernel: [195503.484802] 000:  __schedule+0x3d4/0x8a0
Jan  2 00:06:11 kernel: [195503.484806] 000:  ? __switch_to_asm+0x34/0x70
Jan  2 00:06:11 kernel: [195503.484809] 000:  schedule+0x49/0x100
Jan  2 00:06:11 kernel: [195503.484811] 000:  schedule_timeout+0x1ed/0x3b0
Jan  2 00:06:11 kernel: [195503.484815] 000:  wait_for_completion+0x86/0xe0
Jan  2 00:06:11 kernel: [195503.484818] 000:  __flush_work+0x121/0x1d0
Jan  2 00:06:11 kernel: [195503.484822] 000:  ? flush_workqueue_prep_pwqs+0x140/0x140
Jan  2 00:06:11 kernel: [195503.484825] 000:  flush_work+0x10/0x20
Jan  2 00:06:11 kernel: [195503.484827] 000:  rollback_registered_many+0x1b2/0x530
Jan  2 00:06:11 kernel: [195503.484832] 000:  unregister_netdevice_many.part.0+0x12/0x90
Jan  2 00:06:11 kernel: [195503.484834] 000:  default_device_exit_batch+0x15c/0x190
Jan  2 00:06:11 kernel: [195503.484837] 000:  ? do_wait_intr_irq+0x90/0x90
Jan  2 00:06:11 kernel: [195503.484840] 000:  ops_exit_list.isra.0+0x61/0x70
Jan  2 00:06:11 kernel: [195503.484843] 000:  cleanup_net+0x269/0x3a0
Jan  2 00:06:11 kernel: [195503.484846] 000:  process_one_work+0x1c8/0x470
Jan  2 00:06:11 kernel: [195503.484849] 000:  worker_thread+0x4a/0x3d0
Jan  2 00:06:11 kernel: [195503.484852] 000:  kthread+0x133/0x180
Jan  2 00:06:11 kernel: [195503.484854] 000:  ? process_one_work+0x470/0x470
Jan  2 00:06:11 kernel: [195503.484856] 000:  ? kthread_park+0x90/0x90
Jan  2 00:06:11 kernel: [195503.484858] 000:  ret_from_fork+0x35/0x40
Jan  2 00:06:11 kernel: [195503.484863] 000: INFO: task kworker/26:0:6200 blocked for more than 122 seconds.
Jan  2 00:06:11 kernel: [195503.484864] 000:       Tainted: G           OE     5.4.161-rt67-rc1 #1
Jan  2 00:06:11 kernel: [195503.484865] 000: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  2 00:06:11 kernel: [195503.484866] 000: kworker/26:0    D    0  6200      2 0x80084000
Jan  2 00:06:11 kernel: [195503.484873] 000: Workqueue: ipv6_addrconf addrconf_verify_work
Jan  2 00:06:11 kernel: [195503.484874] 000: Call Trace:
Jan  2 00:06:11 kernel: [195503.484875] 000:  __schedule+0x3d4/0x8a0
Jan  2 00:06:11 kernel: [195503.484877] 000:  schedule+0x49/0x100
Jan  2 00:06:11 kernel: [195503.484879] 000:  __rt_mutex_slowlock+0x8a/0x150
Jan  2 00:06:11 kernel: [195503.484882] 000:  rt_mutex_slowlock_locked+0xbb/0x280
Jan  2 00:06:11 kernel: [195503.484884] 000:  ? __switch_to_asm+0x40/0x70
Jan  2 00:06:11 kernel: [195503.484886] 000:  rt_mutex_slowlock+0x76/0xc0
Jan  2 00:06:11 kernel: [195503.484889] 000:  __rt_mutex_lock_state+0x75/0x90
Jan  2 00:06:11 kernel: [195503.484891] 000:  _mutex_lock+0x13/0x20
Jan  2 00:06:11 kernel: [195503.484894] 000:  rtnl_lock+0x15/0x20
Jan  2 00:06:11 kernel: [195503.484897] 000:  addrconf_verify_work+0xe/0x20
Jan  2 00:06:11 kernel: [195503.484899] 000:  process_one_work+0x1c8/0x470
Jan  2 00:06:11 kernel: [195503.484902] 000:  worker_thread+0x4a/0x3d0
Jan  2 00:06:11 kernel: [195503.484905] 000:  kthread+0x133/0x180
Jan  2 00:06:11 kernel: [195503.484906] 000:  ? process_one_work+0x470/0x470
Jan  2 00:06:11 kernel: [195503.484908] 000:  ? kthread_park+0x90/0x90
Jan  2 00:06:11 kernel: [195503.484910] 000:  ret_from_fork+0x35/0x40
Jan  2 00:08:14 kernel: [195626.364781] 027: INFO: task kworker/u56:2:6079 blocked for more than 368 seconds.
Jan  2 00:08:14 kernel: [195626.364785] 027:       Tainted: G           OE     5.4.161-rt67-rc1 #1
Jan  2 00:08:14 kernel: [195626.364786] 027: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  2 00:08:14 kernel: [195626.364788] 027: kworker/u56:2   D    0  6079      2 0x80084000
Jan  2 00:08:14 kernel: [195626.364797] 027: Workqueue: netns cleanup_net
Jan  2 00:08:14 kernel: [195626.364798] 027: Call Trace:
Jan  2 00:08:14 kernel: [195626.364802] 027:  __schedule+0x3d4/0x8a0
Jan  2 00:08:14 kernel: [195626.364807] 027:  ? __switch_to_asm+0x34/0x70
Jan  2 00:08:14 kernel: [195626.364810] 027:  schedule+0x49/0x100
Jan  2 00:08:14 kernel: [195626.364812] 027:  schedule_timeout+0x1ed/0x3b0
Jan  2 00:08:14 kernel: [195626.364816] 027:  wait_for_completion+0x86/0xe0
Jan  2 00:08:14 kernel: [195626.364818] 027:  __flush_work+0x121/0x1d0
Jan  2 00:08:14 kernel: [195626.364822] 027:  ? flush_workqueue_prep_pwqs+0x140/0x140
Jan  2 00:08:14 kernel: [195626.364825] 027:  flush_work+0x10/0x20
Jan  2 00:08:14 kernel: [195626.364827] 027:  rollback_registered_many+0x1b2/0x530
Jan  2 00:08:14 kernel: [195626.364832] 027:  unregister_netdevice_many.part.0+0x12/0x90
Jan  2 00:08:14 kernel: [195626.364835] 027:  default_device_exit_batch+0x15c/0x190
Jan  2 00:08:14 kernel: [195626.364837] 027:  ? do_wait_intr_irq+0x90/0x90
Jan  2 00:08:14 kernel: [195626.364841] 027:  ops_exit_list.isra.0+0x61/0x70
Jan  2 00:08:14 kernel: [195626.364843] 027:  cleanup_net+0x269/0x3a0
Jan  2 00:08:14 kernel: [195626.364846] 027:  process_one_work+0x1c8/0x470
Jan  2 00:08:14 kernel: [195626.364849] 027:  worker_thread+0x4a/0x3d0
Jan  2 00:08:14 kernel: [195626.364852] 027:  kthread+0x133/0x180
Jan  2 00:08:14 kernel: [195626.364855] 027:  ? process_one_work+0x470/0x470
Jan  2 00:08:14 kernel: [195626.364857] 027:  ? kthread_park+0x90/0x90
Jan  2 00:08:14 kernel: [195626.364859] 027:  ret_from_fork+0x35/0x40
Jan  2 00:08:14 kernel: [195626.364863] 027: INFO: task kworker/26:0:6200 blocked for more than 245 seconds.
Jan  2 00:08:14 kernel: [195626.364865] 027:       Tainted: G           OE     5.4.161-rt67-rc1 #1
Jan  2 00:08:14 kernel: [195626.364866] 027: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  2 00:08:14 kernel: [195626.364867] 027: kworker/26:0    D    0  6200      2 0x80084000
Jan  2 00:08:14 kernel: [195626.364873] 027: Workqueue: ipv6_addrconf addrconf_verify_work
Jan  2 00:08:14 kernel: [195626.364874] 027: Call Trace:
Jan  2 00:08:14 kernel: [195626.364875] 027:  __schedule+0x3d4/0x8a0
Jan  2 00:08:14 kernel: [195626.364878] 027:  schedule+0x49/0x100
Jan  2 00:08:14 kernel: [195626.364880] 027:  __rt_mutex_slowlock+0x8a/0x150
Jan  2 00:08:14 kernel: [195626.364882] 027:  rt_mutex_slowlock_locked+0xbb/0x280
Jan  2 00:08:14 kernel: [195626.364885] 027:  ? __switch_to_asm+0x40/0x70
Jan  2 00:08:14 kernel: [195626.364886] 027:  rt_mutex_slowlock+0x76/0xc0
Jan  2 00:08:14 kernel: [195626.364889] 027:  __rt_mutex_lock_state+0x75/0x90
Jan  2 00:08:14 kernel: [195626.364892] 027:  _mutex_lock+0x13/0x20
Jan  2 00:08:14 kernel: [195626.364894] 027:  rtnl_lock+0x15/0x20
Jan  2 00:08:14 kernel: [195626.364898] 027:  addrconf_verify_work+0xe/0x20
Jan  2 00:08:14 kernel: [195626.364900] 027:  process_one_work+0x1c8/0x470
Jan  2 00:08:14 kernel: [195626.364902] 027:  worker_thread+0x4a/0x3d0
Jan  2 00:08:14 kernel: [195626.364905] 027:  kthread+0x133/0x180
Jan  2 00:08:14 kernel: [195626.364907] 027:  ? process_one_work+0x470/0x470
Jan  2 00:08:14 kernel: [195626.364909] 027:  ? kthread_park+0x90/0x90
Jan  2 00:08:14 kernel: [195626.364911] 027:  ret_from_fork+0x35/0x40
................
Jan  2 00:14:23 kernel: [195995.004768] 000: INFO: task kworker/u56:2:6079 blocked for more than 737 seconds.
Jan  2 00:14:23 kernel: [195995.004771] 000:       Tainted: G           OE     5.4.161-rt67-rc1 #1
Jan  2 00:14:23 kernel: [195995.004772] 000: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  2 00:14:23 kernel: [195995.004774] 000: kworker/u56:2   D    0  6079      2 0x80084000
Jan  2 00:14:23 kernel: [195995.004783] 000: Workqueue: netns cleanup_net
Jan  2 00:14:23 kernel: [195995.004784] 000: Call Trace:
Jan  2 00:14:23 kernel: [195995.004788] 000:  __schedule+0x3d4/0x8a0
Jan  2 00:14:23 kernel: [195995.004793] 000:  ? __switch_to_asm+0x34/0x70
Jan  2 00:14:23 kernel: [195995.004795] 000:  schedule+0x49/0x100
Jan  2 00:14:23 kernel: [195995.004797] 000:  schedule_timeout+0x1ed/0x3b0
Jan  2 00:14:23 kernel: [195995.004801] 000:  wait_for_completion+0x86/0xe0
Jan  2 00:14:23 kernel: [195995.004804] 000:  __flush_work+0x121/0x1d0
Jan  2 00:14:23 kernel: [195995.004807] 000:  ? flush_workqueue_prep_pwqs+0x140/0x140
Jan  2 00:14:23 kernel: [195995.004810] 000:  flush_work+0x10/0x20
Jan  2 00:14:23 kernel: [195995.004813] 000:  rollback_registered_many+0x1b2/0x530
Jan  2 00:14:23 kernel: [195995.004817] 000:  unregister_netdevice_many.part.0+0x12/0x90
Jan  2 00:14:23 kernel: [195995.004819] 000:  default_device_exit_batch+0x15c/0x190
Jan  2 00:14:23 kernel: [195995.004822] 000:  ? do_wait_intr_irq+0x90/0x90
Jan  2 00:14:23 kernel: [195995.004825] 000:  ops_exit_list.isra.0+0x61/0x70
Jan  2 00:14:23 kernel: [195995.004828] 000:  cleanup_net+0x269/0x3a0
Jan  2 00:14:23 kernel: [195995.004831] 000:  process_one_work+0x1c8/0x470
Jan  2 00:14:23 kernel: [195995.004834] 000:  worker_thread+0x4a/0x3d0
Jan  2 00:14:23 kernel: [195995.004837] 000:  kthread+0x133/0x180
Jan  2 00:14:23 kernel: [195995.004839] 000:  ? process_one_work+0x470/0x470
Jan  2 00:14:23 kernel: [195995.004841] 000:  ? kthread_park+0x90/0x90
Jan  2 00:14:23 kernel: [195995.004843] 000:  ret_from_fork+0x35/0x40

After "task kworker/u56:2:6079 blocked for more than 737 seconds.", 
the network seems down, both ssh, ifconfig can't work.


>> Sure, PID 1369493 addrconf_verify_work() is waiting for RTNL.
>> 
>> But PID 8  ?
>> 
>> __flush_work() is being called.
>> 
>> But from where ? Stacks seem not complete.

__flush_work is just from the work queue, so, Yes, 
we don't know who put it into the queue.  And don't know whether the clean netns work is reasonable. 
Maybe I need to add a trace at the put_net. 

 put_net
     __put_net  queue_work(netns_wq, &net_cleanup_work);
         DECLARE_WORK(net_cleanup_work, cleanup_net);
         cleanup_net
             ops_exit_list
                 default_device_exit_batch
                     unregister_netdevice_many
                         rollback_registered_many
                             flush_work
                                 __flush_work
								 

>> But PID 1369493 is waiting on a mutex, thus properly yielding the cpu.
>> (schedule() is clearly shown)
>> 
>> This should not prevent other threads
>> from making progress so that flush_all_backlogs() completes eventually.
>> 
>> flush_all_backlogs() does not care of how many threads are currently blocked
>> because they can not grab rtnl while flush_all_backlogs() is running.

In my log, we can see even the schedule is shown but the task is still in the D status. 

It seems the "addrconf_verify_work" is blocked by "cleanup_net". 
But why the "cleanup_net" is blocked?  
Currently, my plan is trying to add trace/print at the "__flush_work" to see: what work is blocked,
then research this work is owned by who. 

As an expert, if you can give some advice, it will be very grateful.

BTW, this is a RT kernel, I'm also checking the system workload.

BR,
Dongyang
