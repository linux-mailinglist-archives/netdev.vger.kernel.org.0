Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81BF456DE1
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234758AbhKSLBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:01:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231796AbhKSLBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 06:01:16 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJA19pm014534;
        Fri, 19 Nov 2021 10:58:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : content-type : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cQuLGA+1C1h2cNYXzDrXQjXFb4S9v9DENFSoucv9ijA=;
 b=TdtrhdA9Lw3fCDdvXb5yDdC7s7vyHlBa03h5DL0mI95EfV0zhB8bDV/oQNoFaj+X0ioc
 WP43FEGM2Jyd430aQQStgP5mAlUZoPgjSCqjd3+Ll6ogmlrKWN4FKrqLuLMLnf9GTaKy
 8GjSpZFGZJZPyVCbAGnJBmC/qB5IYeR6IGVYWBDGncaLP6MG9Xfc3IdmUTfSAQ2uZf+z
 ubXuct3R5qnf+DgIPdpXNn/2HPk7tgf23Xhjp2Byd/WLXSSwHpljLCbF/rYaUFLW1PjB
 Svz8t1LWydVZR82PylFeD1B5EGw1VS71/wlv3MZwzIxA3Bj4Yx9df2AZS5bVN8LlIvsq +Q== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ce7u33n5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 10:58:10 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJAriGL032682;
        Fri, 19 Nov 2021 10:58:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ca50aw9pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 10:58:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJAp7Fn56557850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 10:51:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 859F94204B;
        Fri, 19 Nov 2021 10:58:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 152A94203F;
        Fri, 19 Nov 2021 10:58:06 +0000 (GMT)
Received: from sig-9-145-57-93.uk.ibm.com (unknown [9.145.57.93])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 10:58:05 +0000 (GMT)
Message-ID: <15db9c1d11d32fb16269afceb527b5d743177ac4.camel@linux.ibm.com>
Subject: Regression in v5.16-rc1: Timeout in mlx5_health_wait_pci_up() may
 try to wait 245 million years
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Amir Tzin <amirtz@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     netdev <netdev@vger.kernel.org>, regressions@lists.linux.dev,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Fri, 19 Nov 2021 11:58:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zH2_SJjrw3r4M6XeocrOtJsjkOKifYsX
X-Proofpoint-ORIG-GUID: zH2_SJjrw3r4M6XeocrOtJsjkOKifYsX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_08,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Amir, Moshe, and Saeed,

(resent due to wrong netdev mailing list address, sorry about that)

During testing of PCI device recovery, I found a problem in the mlx5
recovery support introduced in v5.16-rc1 by commit 32def4120e48
("net/mlx5: Read timeout values from DTOR"). It follows my analysis of
the problem.

When the device is in an error state, at least on s390 but I believe
also on other systems, it is isolated and all PCI MMIO reads return
0xff. This is detected by your driver and it will immediately attempt
to recovery the device with a mlx5_core driver specific recovery
mechanism. Since at this point no reset has been done that would take
the device out of isolation this will of course fail as it can't
communicate with the device. Under normal circumstances this reset
would happen later during the new recovery flow introduced in
4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery") once
firmware has done their side of the recovery allowing that to succeed
once the driver specific recovery has failed.

With v5.16-rc1 however the driver specific recovery gets stuck holding
locks which will block our recovery. Without our recovery mechanism
this can also be seen by "echo 1 > /sys/bus/pci/devices/<dev>/remove"
which hangs on the device lock forever.

Digging into this I tracked the problem down to
mlx5_health_wait_pci_up() hangig. I added a debug print to it and it
turns out that with the device isolated mlx5_tout_ms(dev, FW_RESET)
returns 774039849367420401 (0x6B...6B) milliseconds and we try to wait
245 million years. After reverting that commit things work again,
though of course the driver specific recovery flow will still fail
before ours can kick in and finally succeed.

Thanks,
Niklas Schnelle

#regzbot introduced: 32def4120e48

