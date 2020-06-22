Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A135B203D82
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgFVRKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:10:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729812AbgFVRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:10:37 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MH4JDR002415;
        Mon, 22 Jun 2020 13:10:28 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tys21wst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 13:10:27 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MGkBDI031249;
        Mon, 22 Jun 2020 17:10:27 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 31sa38s6b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 17:10:27 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MHAQZh26214664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 17:10:26 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E3B6A04F;
        Mon, 22 Jun 2020 17:10:26 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CECF56A04D;
        Mon, 22 Jun 2020 17:10:24 +0000 (GMT)
Received: from oc8377887825.ibm.com (unknown [9.160.23.249])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 17:10:24 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, wilder@us.ibm.com,
        mkubecek@suse.com
Subject: [PATCH v1 0/4] iptables: Module unload causing NULL pointer reference.
Date:   Mon, 22 Jun 2020 10:10:10 -0700
Message-Id: <20200622171014.975-1-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_10:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=0 impostorscore=0 cotscore=-2147483648 phishscore=0
 malwarescore=0 mlxlogscore=928 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A crash happened on ppc64le when running ltp network tests triggered by "rmmod iptable_mangle".

See previous discussion in this thread: https://lists.openwall.net/netdev/2020/06/03/161 .

In the crash I found in iptable_mangle_hook() that state->net->ipv4.iptable_mangle=NULL causing a NULL pointer dereference. net->ipv4.iptable_mangle is set to NULL in iptable_mangle_net_exit() and called when ip_mangle modules is unloaded. A rmmod task was found running in the crash dump.  A 2nd crash showed the same problem when running "rmmod iptable_filter" (net->ipv4.iptable_filter=NULL).

To fix this I added .pre_exit hook in all iptable_foo.c. The pre_exit will un-register the underlying hook and exit would do the table freeing. The netns core does an unconditional synchronize_rcu after the pre_exit hooks insuring no packets are in flight that have picked up the pointer before completing the un-register.

These patches include changes for both iptables and ip6tables.

We tested this fix with ltp running iptables01.sh and iptables01.sh -6 a loop for 72 hours.

Signed-off-by: David Wilder <dwilder@us.ibm.com>

David Wilder (4):
  netfilter: Split ipt_unregister_table() into pre_exit and exit
    helpers.
  netfilter: Add a .pre_exit hook in all iptable_foo.c.
  netfilter: Split ip6t_unregister_table() into pre_exit and exit
    helpers.
  netfilter: Add a .pre_exit hook in all ip6table_foo.c.

 include/linux/netfilter_ipv4/ip_tables.h  |  6 ++++++
 include/linux/netfilter_ipv6/ip6_tables.h |  3 +++
 net/ipv4/netfilter/ip_tables.c            | 15 ++++++++++++++-
 net/ipv4/netfilter/iptable_filter.c       | 10 +++++++++-
 net/ipv4/netfilter/iptable_mangle.c       | 10 +++++++++-
 net/ipv4/netfilter/iptable_nat.c          | 10 ++++++++--
 net/ipv4/netfilter/iptable_raw.c          | 10 +++++++++-
 net/ipv4/netfilter/iptable_security.c     | 11 +++++++++--
 net/ipv6/netfilter/ip6_tables.c           | 15 ++++++++++++++-
 net/ipv6/netfilter/ip6table_filter.c      | 10 +++++++++-
 net/ipv6/netfilter/ip6table_mangle.c      | 10 +++++++++-
 net/ipv6/netfilter/ip6table_nat.c         | 10 ++++++++--
 net/ipv6/netfilter/ip6table_raw.c         | 10 +++++++++-
 net/ipv6/netfilter/ip6table_security.c    | 10 +++++++++-
 14 files changed, 125 insertions(+), 15 deletions(-)

-- 
1.8.3.1

