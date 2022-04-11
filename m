Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6304FC415
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 20:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244183AbiDKSb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 14:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346436AbiDKSbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 14:31:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429A315733
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:29:39 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BIBLTo005384;
        Mon, 11 Apr 2022 18:29:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : from
 : subject : to : content-type : content-transfer-encoding : mime-version;
 s=pp1; bh=r741SLZHw9la+4j0x/klNzO1RUK3lAH1Rfy6ps6fU5M=;
 b=ODSkmuUnIUeu7llOi/V311FNwN4Jiul9ryKR5SuPsoG+Nqm2CCpwJRJZQl15lW9zVjqG
 zoBd0g5+g9dEHqJGbZqCgfbsIgoseb1aD2V1kHRFqEg1MacmHu2T47QzQ0hdSMYIx6aj
 m6TGMj/pSupk4lAGpVyK7CA/X9Ma9/5eOQlLeqXd+iEIdyzg3f+fmF4eeLdBCv0F7fsj
 ndm+tXNoM3dOEmmEjwdM+pUurDawwM4s9A/dKYAeqdUHD6nUn6PGac4RtBAEf4oCD9QB
 rrAsIFhqv+gRrWZQnH2sbdUDOPktSnUJelL37P1reDPOextu4glOH3LQ+WrABIMBzttq 3Q== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcscxra8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 18:29:38 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BHvkpL016904;
        Mon, 11 Apr 2022 18:06:27 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 3fb1s9hj6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 18:06:27 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BI6QOl29032802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 18:06:26 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6EC6E060;
        Mon, 11 Apr 2022 18:06:26 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85D416E05B;
        Mon, 11 Apr 2022 18:06:26 +0000 (GMT)
Received: from [9.211.78.158] (unknown [9.211.78.158])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 18:06:26 +0000 (GMT)
Message-ID: <e478c5c4-3c0f-705b-6215-8bad6084f536@linux.vnet.ibm.com>
Date:   Mon, 11 Apr 2022 11:06:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
From:   David Christensen <drc@linux.vnet.ibm.com>
Subject: EEH Causes bnx2x to Hang in napi_disable
To:     Netdev <netdev@vger.kernel.org>, aelior@marvell.com,
        manishc@marvell.com, skalluru@marvell.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y4mg_gCf4UPd4N2hj3QPE0JAMFiP3g50
X-Proofpoint-GUID: y4mg_gCf4UPd4N2hj3QPE0JAMFiP3g50
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_07,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Experiencing an inaccessible system when bnx2x attempts to recover from 
an injected EEH error. This is a POWER10 system running SLES 15 SP3 
(5.3.18-150300.59.49-default) with a BCM57810 dual port NIC.

System message log shows the following:
=======================================
[ 3222.537510] EEH: Detected PCI bus error on PHB#384-PE#800000
[ 3222.537511] EEH: This PCI device has failed 2 times in the last hour 
and will be permanently disabled after 5 failures.
[ 3222.537512] EEH: Notify device drivers to shutdown
[ 3222.537513] EEH: Beginning: 'error_detected(IO frozen)'
[ 3222.537514] EEH: PE#800000 (PCI 0384:80:00.0): Invoking 
bnx2x->error_detected(IO frozen)
[ 3222.537516] bnx2x: [bnx2x_io_error_detected:14236(eth14)]IO error 
detected
[ 3222.537650] EEH: PE#800000 (PCI 0384:80:00.0): bnx2x driver reports: 
'need reset'
[ 3222.537651] EEH: PE#800000 (PCI 0384:80:00.1): Invoking 
bnx2x->error_detected(IO frozen)
[ 3222.537651] bnx2x: [bnx2x_io_error_detected:14236(eth13)]IO error 
detected
[ 3222.537729] EEH: PE#800000 (PCI 0384:80:00.1): bnx2x driver reports: 
'need reset'
[ 3222.537729] EEH: Finished:'error_detected(IO frozen)' with aggregate 
recovery state:'need reset'
[ 3222.537890] EEH: Collect temporary log
[ 3222.583481] EEH: of node=0384:80:00.0
[ 3222.583519] EEH: PCI device/vendor: 168e14e4
[ 3222.583557] EEH: PCI cmd/status register: 00100140
[ 3222.583557] EEH: PCI-E capabilities and status follow:
[ 3222.583744] EEH: PCI-E 00: 00020010 012c8da2 00095d5e 00455c82
[ 3222.583892] EEH: PCI-E 10: 10820000 00000000 00000000 00000000
[ 3222.583893] EEH: PCI-E 20: 00000000
[ 3222.583893] EEH: PCI-E AER capability register set follows:
[ 3222.584079] EEH: PCI-E AER 00: 13c10001 00000000 00000000 00062030
[ 3222.584230] EEH: PCI-E AER 10: 00002000 000031c0 000001e0 00000000
[ 3222.584378] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[ 3222.584416] EEH: PCI-E AER 30: 00000000 00000000
[ 3222.584416] EEH: of node=0384:80:00.1
[ 3222.584454] EEH: PCI device/vendor: 168e14e4
[ 3222.584491] EEH: PCI cmd/status register: 00100140
[ 3222.584492] EEH: PCI-E capabilities and status follow:
[ 3222.584677] EEH: PCI-E 00: 00020010 012c8da2 00095d5e 00455c82
[ 3222.584825] EEH: PCI-E 10: 10820000 00000000 00000000 00000000
[ 3222.584826] EEH: PCI-E 20: 00000000
[ 3222.584826] EEH: PCI-E AER capability register set follows:
[ 3222.585011] EEH: PCI-E AER 00: 13c10001 00000000 00000000 00062030
[ 3222.585160] EEH: PCI-E AER 10: 00002000 000031c0 000001e0 00000000
[ 3222.585309] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[ 3222.585347] EEH: PCI-E AER 30: 00000000 00000000
[ 3222.586872] RTAS: event: 5, Type: Platform Error (224), Severity: 2
[ 3222.586873] EEH: Reset without hotplug activity
[ 3224.762767] EEH: Beginning: 'slot_reset'
[ 3224.762770] EEH: PE#800000 (PCI 0384:80:00.0): Invoking 
bnx2x->slot_reset()
[ 3224.762771] bnx2x: [bnx2x_io_slot_reset:14271(eth14)]IO slot reset 
initializing...
[ 3224.762887] bnx2x 0384:80:00.0: enabling device (0140 -> 0142)
[ 3224.768157] bnx2x: [bnx2x_io_slot_reset:14287(eth14)]IO slot reset 
--> driver unload

Uninterruptable tasks
=====================
crash> ps | grep UN
     213      2  11  c000000004c89e00  UN   0.0       0      0  [eehd]
     215      2   0  c000000004c80000  UN   0.0       0      0 
[kworker/0:2]
    2196      1  28  c000000004504f00  UN   0.1   15936  11136  wickedd
    4287      1   9  c00000020d076800  UN   0.0    4032   3008  agetty
    4289      1  20  c00000020d056680  UN   0.0    7232   3840  agetty
   32423      2  26  c00000020038c580  UN   0.0       0      0 
[kworker/26:3]
   32871   4241  27  c0000002609ddd00  UN   0.1   18624  11648  sshd
   32920  10130  16  c00000027284a100  UN   0.1   48512  12608  sendmail
   33092  32987   0  c000000205218b00  UN   0.1   48512  12608  sendmail
   33154   4567  16  c000000260e51780  UN   0.1   48832  12864  pickup
   33209   4241  36  c000000270cb6500  UN   0.1   18624  11712  sshd
   33473  33283   0  c000000205211480  UN   0.1   48512  12672  sendmail
   33531   4241  37  c00000023c902780  UN   0.1   18624  11648  sshd

EEH handler hung while bnx2x sleeping and holding RTNL lock
===========================================================
crash> bt 213
PID: 213    TASK: c000000004c89e00  CPU: 11  COMMAND: "eehd"
  #0 [c000000004d477e0] __schedule at c000000000c70808
  #1 [c000000004d478b0] schedule at c000000000c70ee0
  #2 [c000000004d478e0] schedule_timeout at c000000000c76dec
  #3 [c000000004d479c0] msleep at c0000000002120cc
  #4 [c000000004d479f0] napi_disable at c000000000a06448
                                        ^^^^^^^^^^^^^^^^
  #5 [c000000004d47a30] bnx2x_netif_stop at c0080000018dba94 [bnx2x]
  #6 [c000000004d47a60] bnx2x_io_slot_reset at c0080000018a551c [bnx2x]
  #7 [c000000004d47b20] eeh_report_reset at c00000000004c9bc
  #8 [c000000004d47b90] eeh_pe_report at c00000000004d1a8
  #9 [c000000004d47c40] eeh_handle_normal_event at c00000000004da64
#10 [c000000004d47d00] eeh_event_handler at c00000000004e330
#11 [c000000004d47db0] kthread at c00000000017583c
#12 [c000000004d47e20] ret_from_kernel_thread at c00000000000cda8

And the sleeping source code
============================
crash> dis -ls c000000000a06448
FILE: ../net/core/dev.c
LINE: 6702

   6697  {
   6698          might_sleep();
   6699          set_bit(NAPI_STATE_DISABLE, &n->state);
   6700
   6701          while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
* 6702                  msleep(1);
   6703          while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
   6704                  msleep(1);
   6705
   6706          hrtimer_cancel(&n->timer);
   6707
   6708          clear_bit(NAPI_STATE_DISABLE, &n->state);
   6709  }

EEH calls into bnx2x twice based on the system log above, first through 
bnx2x_io_error_detected() and then bnx2x_io_slot_reset(), and executes 
the following call chains:

bnx2x_io_error_detected()
  +-> bnx2x_eeh_nic_unload()
       +-> bnx2x_del_all_napi()
            +-> __netif_napi_del()


bnx2x_io_slot_reset()
  +-> bnx2x_netif_stop()
       +-> bnx2x_napi_disable()
            +->napi_disable()

I'm suspicious of the napi_disable() following the __netif_napi_del(), 
based on my read of the NAPI API 
(https://wiki.linuxfoundation.org/networking/napi).  Though not 
explicitly documented, it seems like disabling NAPI after deleting NAPI 
resources is a bad thing.  Am I mistaken in my understanding of the NAPI 
API or is there a bug here?  If the latter, how can we fix it?

David Christensen
