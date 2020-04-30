Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01AFB1BF7C6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgD3MDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:03:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726127AbgD3MDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:03:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03UBWBFT146592;
        Thu, 30 Apr 2020 08:03:14 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mggwuwbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 08:03:13 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03UBjbL0005767;
        Thu, 30 Apr 2020 12:03:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu72gwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 12:03:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03UC20Y349938938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 12:02:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DCE0A4040;
        Thu, 30 Apr 2020 12:03:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F346AA4055;
        Thu, 30 Apr 2020 12:03:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 12:03:08 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH 0/1] net/mlx5: Call pci_disable_sriov() on remove
Date:   Thu, 30 Apr 2020 14:03:07 +0200
Message-Id: <20200430120308.92773-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_07:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1011
 mlxlogscore=672 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300092
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm currently working on improvements in PF-VF handling on s390. One thing that
may be a bit special for us is that the s390 hotplug code supports shutting
down a single PF of a multi-function device such as a ConnectX-5.
During testing I found that the mlx5_core driver does not call
pci_disable_sriov() in its remove handler which is called on the PF via
pci_stop_and_remove_bus_device() on an orderly hot unplug.

Following is a patch to fix this, I want to point out however that I'm not
entirely sure about the effect of clear_vfs that distinguishes
mlx5_sriov_detach() from mlx5_sriov_disable() only that the former is called
from the remove handler and it doesn't call pci_disable_sriov().
That however is required according to Documentation/PCI/pci-iov-howto.rst

I've only tested this on top of my currently still internal PF-VF rework so
I might also be totally missing something here in that case excuse my
ignorance.

Best regards,
Niklas Schnelle

Niklas Schnelle (1):
  net/mlx5: Call pci_disable_sriov() on remove

 drivers/net/ethernet/mellanox/mlx5/core/sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.17.1

