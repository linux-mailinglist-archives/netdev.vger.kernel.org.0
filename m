Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB021A08D1
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgDGIBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 04:01:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22426 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726725AbgDGIBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 04:01:38 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0377YrZ6011065
        for <netdev@vger.kernel.org>; Tue, 7 Apr 2020 04:01:37 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3082f260bk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 04:01:36 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <schnelle@linux.ibm.com>;
        Tue, 7 Apr 2020 09:01:12 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 09:01:09 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03781VKk29949990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 08:01:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B53652052;
        Tue,  7 Apr 2020 08:01:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BAD6952050;
        Tue,  7 Apr 2020 08:01:30 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [RFC 0/1] net/mlx5: Failing fw tracer allocation on s390
Date:   Tue,  7 Apr 2020 10:01:29 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20040708-4275-0000-0000-000003BB2C25
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040708-4276-0000-0000-000038D08C01
Message-Id: <20200407080130.34472-1-schnelle@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_01:2020-04-07,2020-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1011 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I sent this message before, but it seems to have fallen through the cracks so,
as this remains an issue I wanted to ping you again.

On s390 the MLX5 driver generates the following stack trace when
initializing a device with support for firmware tracing.

[  331.531819] WARNING: CPU: 7 PID: 2156 at mm/page_alloc.c:4727 __alloc_pages_nodemask+0x25c/0x320
[  331.531820] Modules linked in: mlx5_core(+) mlxfw tls ptp pps_core s390_trng chsc_sch vfio_ccw vfio_mdev mdev eadm_sch vfio_iommu_type1 vfio sch_fq_codel ip_tables x_tables btrfs zstd_compress zlib_deflate raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 linear dm_service_time pkey zcrypt crc32_vx_s390 ghash_s390 prng aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 qeth_l2 sha512_s390 sha256_s390 sha1_s390 sha_common zfcp qeth scsi_transport_fc qdio ccwgroup scsi_dh_emc scsi_dh_rdac scsi_dh_alua dm_multipath
[  331.531833] CPU: 7 PID: 2156 Comm: systemd-udevd Not tainted 5.4.0-14-generic #17-Ubuntu
[  331.531833] Hardware name: IBM 8562 GT2 A00 (LPAR)
[  331.531834] Krnl PSW : 0704c00180000000 00000000735d720c (__alloc_pages_nodemask+0x25c/0x320)
[  331.531836]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  331.531837] Krnl GPRS: 000000007418d687 0000000000040dc0 0000000000040dc0 000000000000000a
[  331.531837]            0000000000000000 0000000000000000 000000000000000a 000003ff8042607e
[  331.531838]            0000000000000dc0 00000000002203b0 000000000000000a 00000001c9480120
[  331.531838]            00000001ecda4400 0000000000000055 000003e001943680 000003e001943600
[  331.531844] Krnl Code: 00000000735d7200: a7212000            tmll    %r2,8192
		      00000000735d7204: a774ff87            brc     7,00000000735d7112
		     #00000000735d7208: a7f40001            brc     15,00000000735d720a
		     >00000000735d720c: a7890000            lghi    %r8,0
		      00000000735d7210: a7f4ff83            brc     15,00000000735d7116
		      00000000735d7214: a7180000            lhi     %r1,0
		      00000000735d7218: a7f4ff1b            brc     15,00000000735d704e
		      00000000735d721c: e31003400004        lg      %r1,832
[  331.531851] Call Trace:
[  331.531852] ([<0000000000000201>] 0x201)
[  331.531856]  [<00000000735a20c4>] kmalloc_order+0x34/0xb0
[  331.531856]  [<00000000735a2172>] kmalloc_order_trace+0x32/0xe0
[  331.531880]  [<000003ff8042607e>] mlx5_fw_tracer_create+0x3e/0x500 [mlx5_core]
[  331.531899]  [<000003ff803ffa88>] mlx5_init_once+0x148/0x3c0 [mlx5_core]
[  331.531917]  [<000003ff8040152a>] mlx5_load_one+0x7a/0x240 [mlx5_core]
[  331.531935]  [<000003ff804018d8>] init_one+0x1e8/0x310 [mlx5_core]
[  331.531939]  [<0000000073916e16>] local_pci_probe+0x56/0xc0
[  331.531941]  [<0000000073917ef2>] pci_device_probe+0x132/0x1e0
[  331.531942]  [<00000000739a1374>] really_probe+0xf4/0x460
[  331.531943]  [<00000000739a1a60>] driver_probe_device+0x130/0x190
[  331.531944]  [<00000000739a1dae>] device_driver_attach+0x7e/0xa0
[  331.531945]  [<00000000739a1e86>] __driver_attach+0xb6/0x180
[  331.531947]  [<000000007399eae2>] bus_for_each_dev+0x82/0xc0
[  331.531948]  [<00000000739a030a>] bus_add_driver+0x16a/0x260
[  331.531949]  [<00000000739a2b38>] driver_register+0x88/0x150
[  331.531967]  [<000003ff80362080>] init+0x80/0xb0 [mlx5_core]
[  331.531968]  [<00000000733648bc>] do_one_initcall+0x3c/0x200
[  331.531970]  [<0000000073495fc0>] do_init_module+0x70/0x270
[  331.531970]  [<00000000734983b2>] load_module+0x1142/0x1440
[  331.531971]  [<00000000734988e4>] __do_sys_finit_module+0xa4/0xf0
[  331.531973]  [<0000000073c54ec2>] system_call+0x2a6/0x2c8
[  331.531974] Last Breaking-Event-Address:
[  331.531975]  [<00000000735d7208>] __alloc_pages_nodemask+0x258/0x320
[  331.531975] ---[ end trace 5985b580c6dbfd3e ]---

This happens because on s390 FORCE_MAX_ZONEORDER is 9 instead of 11, such
a large kzalloc() allocation will thus always fail. As the tracer is
a debug feature and failing allocations are checked the device remains
usable but of course we still want to enable this feature and get rid of the
warning.

Looking at mlx5_fw_tracer_save_trace() I would think that since it is
actually the driver not the device that copies into the trace array we can
just use kvzalloc() instead. This patch prevents the above stack trace for
us, though

I haven't yet been able to test the tracing as the devlink command given in
the initial commit fd1483fe1f9f ("net/mlx5: Add support for FW reporter
dump") always reports 'Object "health" not found' for me even after
enabling it via

echo traceon > /sys/kernel/debug/tracing/events/mlx5/mlx5_fw/enable

Still I wanted to get your comments on the proposed fix and maybe a hint at
how to test this.

Best regards,
Niklas Schnelle

Niklas Schnelle (1):
  net/mlx5: Fix failing fw tracer allocation on s390

 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.17.1

