Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94BC205435
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbgFWOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:12:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62288 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732657AbgFWOMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:12:51 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NE54Z8119634;
        Tue, 23 Jun 2020 10:12:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31uhcqvar3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:12:04 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05NE5a9c122692;
        Tue, 23 Jun 2020 10:12:04 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31uhcqvaps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:12:04 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05NEBNq1019088;
        Tue, 23 Jun 2020 14:12:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 31uk4wr05b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 14:12:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05NEAew058851746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 14:10:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FF0E4C072;
        Tue, 23 Jun 2020 14:11:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 818524C071;
        Tue, 23 Jun 2020 14:11:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 23 Jun 2020 14:11:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 04F32E13EA; Tue, 23 Jun 2020 16:11:58 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     mcgrof@kernel.org
Cc:     ast@kernel.org, axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390@vger.kernel.or
Subject: linux-next: umh: fix processed error when UMH_WAIT_PROC is used seems to break linux bridge on s390x (bisected)
Date:   Tue, 23 Jun 2020 16:11:57 +0200
Message-Id: <20200623141157.5409-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200610154923.27510-5-mcgrof@kernel.org>
References: <20200610154923.27510-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_06:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=1 mlxlogscore=865 spamscore=0 bulkscore=0 lowpriorityscore=0
 cotscore=-2147483648 mlxscore=0 priorityscore=1501 malwarescore=0
 clxscore=1011 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jens Markwardt reported a regression in the linux-next runs.  with "umh: fix
processed error when UMH_WAIT_PROC is used" (from linux-next) a linux bridge
with an KVM guests no longer activates :

without patch
# ip addr show dev virbr1
6: virbr1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:54:00:1e:3f:c0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.254.254/24 brd 192.168.254.255 scope global virbr1
       valid_lft forever preferred_lft forever

with this patch the bridge stays DOWN with NO-CARRIER

# ip addr show dev virbr1
6: virbr1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:1e:3f:c0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.254.254/24 brd 192.168.254.255 scope global virbr1
       valid_lft forever preferred_lft forever

This was bisected in linux-next. Reverting from linux-next also fixes the issue.

Any idea?

Christian
