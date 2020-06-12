Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3F51F788A
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgFLNKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:10:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgFLNJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:09:59 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05CD18G3042685;
        Fri, 12 Jun 2020 09:09:56 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31m2yfn4p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 09:09:56 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05CD6o81020081;
        Fri, 12 Jun 2020 13:09:54 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 31ku7c0fq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 13:09:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05CD8ZXc62259618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jun 2020 13:08:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 716B5AE056;
        Fri, 12 Jun 2020 13:09:52 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 339CCAE045;
        Fri, 12 Jun 2020 13:09:52 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.186.41])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Jun 2020 13:09:52 +0000 (GMT)
To:     Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [REGRESSION] mlx5: Driver remove during hot unplug is broken
Message-ID: <f942d546-ee7e-60f6-612a-ae093a9459a5@linux.ibm.com>
Date:   Fri, 12 Jun 2020 15:09:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-11_23:2020-06-11,2020-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 cotscore=-2147483648 clxscore=1011 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006110174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Parav, Hello Saeed,

our CI system for IBM Z Linux found a hang[0] when hot unplugging a ConnectX-4 Lx VF from a z/VM guest
in Linus' current tree and added during the merge window.
Sadly it didn't happen all the time which sent me on the wrong path for two full git bisects.

Anyway, I've now tracked this down to the following commit which when reverted
fixes the issue:

41798df9bfca ("net/mlx5: Drain wq first during PCI device removal")

Looking at the diff I'd say the likely culprit is that before
the commit the order of calls was:

mlx5_unregister_device(dev)
mlx5_drain_health_wq(dev)

But with the commit it becomes

mlx5_drain_health_wq(dev)
mlx5_unregister_device(dev)

So without really knowing anything about these functions I would
guess that with the device still registered the drained
queue does not remain empty as new entries are added.
Does that sound plausible to you?

Best regards,
Niklas Schnelle

[0] dmesg output:
[   36.447442] mlx5_core 0000:00:00.0: poll_health:694:(pid 0): Fatal error 1 detected
[   36.447450] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[0] 0xffffffff
[   36.447453] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[1] 0xffffffff
[   36.447455] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[2] 0xffffffff
[   36.447458] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[3] 0xffffffff
[   36.447461] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[4] 0xffffffff
[   36.447463] mlx5_core 0000:00:00.0: print_health_info:375:(pid 0): assert_exit_ptr 0xffffffff
[   36.447467] mlx5_core 0000:00:00.0: print_health_info:377:(pid 0): assert_callra 0xffffffff
[   36.447471] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): fw_ver 65535.65535.65535
[   36.447475] mlx5_core 0000:00:00.0: print_health_info:381:(pid 0): hw_id 0xffffffff
[   36.447478] mlx5_core 0000:00:00.0: print_health_info:382:(pid 0): irisc_index 255
[   36.447492] mlx5_core 0000:00:00.0: print_health_info:383:(pid 0): synd 0xff: unrecognized error
[   36.447621] mlx5_core 0000:00:00.0: print_health_info:385:(pid 0): ext_synd 0xffff
[   36.447624] mlx5_core 0000:00:00.0: print_health_info:387:(pid 0): raw fw_ver 0xffffffff
[   36.447885] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=B, anc=0, erc=0, rsid=0
[   36.447897] zpci: 0000:00:00.0: Event 0x303 reconfigured PCI function 0x514
[   47.099220] mlx5_core 0000:00:00.0: poll_health:709:(pid 0): device's health compromised - reached miss count
[   47.099228] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[0] 0xffffffff
[   47.099231] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[1] 0xffffffff
[   47.099234] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[2] 0xffffffff
[   47.099236] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[3] 0xffffffff
[   47.099239] mlx5_core 0000:00:00.0: print_health_info:372:(pid 0): assert_var[4] 0xffffffff
[   47.099241] mlx5_core 0000:00:00.0: print_health_info:375:(pid 0): assert_exit_ptr 0xffffffff
[   47.099245] mlx5_core 0000:00:00.0: print_health_info:377:(pid 0): assert_callra 0xffffffff
[   47.099249] mlx5_core 0000:00:00.0: print_health_info:380:(pid 0): fw_ver 65535.65535.65535
[   47.099253] mlx5_core 0000:00:00.0: print_health_info:381:(pid 0): hw_id 0xffffffff
[   47.099256] mlx5_core 0000:00:00.0: print_health_info:382:(pid 0): irisc_index 255
[   47.099327] mlx5_core 0000:00:00.0: print_health_info:383:(pid 0): synd 0xff: unrecognized error
[   47.099329] mlx5_core 0000:00:00.0: print_health_info:385:(pid 0): ext_synd 0xffff
[   47.099330] mlx5_core 0000:00:00.0: print_health_info:387:(pid 0): raw fw_ver 0xffffffff
[  100.539106] mlx5_core 0000:00:00.0: wait_func:991:(pid 121): 2RST_QP(0x50a) timeout. Will cause a leak of a command resource
[  100.539118] infiniband mlx5_0: destroy_qp_common:2525:(pid 121): mlx5_ib: modify QP 0x00072c to RESET failed
[  141.499325] mlx5_core 0000:00:00.0: wait_func:991:(pid 32): QUERY_VPORT_COUNTER(0x770) timeout. Will cause a leak of a command resource
[  161.978957] mlx5_core 0000:00:00.0: wait_func:991:(pid 121): DESTROY_QP(0x501) timeout. Will cause a leak of a command resource
