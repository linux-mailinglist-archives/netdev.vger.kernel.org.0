Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093B1C6E3D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgEFKUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 06:20:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41660 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgEFKUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:20:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046AHosi054927;
        Wed, 6 May 2020 10:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=PuX6rwaGKKV8LkbfAkFg2knCJQfvM5Hq/d81pqR/SMM=;
 b=ZpbybSrPMqRDG1Ik6hp5HoslntrHfXNgA7juIGJXZ7bUeyQaOS8673E9DQkcBGmm2E5i
 Nrq2ZfhArfEV+zFyNeZfjuAnx0jfL8nEv5JyNLcDF/ydbltwIY8356T7dHgF8LHG4Hyr
 f99mIdMZyjo+zScKsR9RtFE0FFkl0wCgkeIqxd+UzLFSbeU7e/2crWClNutB4cODIqOX
 +z1p5b4ENg1ZUjR19hZg8+ATmc0PLhTdeQ8biwIf5SDROwj5lnfD2fk/iArtJuGVaPyx
 lAUAFcsS1CXEQTegzy/hfJNkBLfKYBwosxqR4y2x4kP00Nj8IBJJI0tJvUzxngmQPANz Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn9byx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 10:20:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 046AHb43028215;
        Wed, 6 May 2020 10:18:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjnhvvjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 May 2020 10:18:05 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 046AI3Am010844;
        Wed, 6 May 2020 10:18:03 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 May 2020 03:18:02 -0700
Date:   Wed, 6 May 2020 13:17:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] netfilter: nf_conntrack_pptp: prevent buffer overflows
 in debug code
Message-ID: <20200506101753.GD77004@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that the value for "cmd" comes from the network and
can't be trusted.  The value is actually checked at the end of these
functions so I just copied that here as well.

Fixes: f09943fefe6b ("[NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netfilter/nf_conntrack_pptp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index a971183f11af7..b4dc567f7fb68 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -276,7 +276,8 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	typeof(nf_nat_pptp_hook_inbound) nf_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("inbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("inbound control message %s\n",
+		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0]);
 
 	switch (msg) {
 	case PPTP_START_SESSION_REPLY:
@@ -404,7 +405,8 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	typeof(nf_nat_pptp_hook_outbound) nf_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
-	pr_debug("outbound control message %s\n", pptp_msg_name[msg]);
+	pr_debug("outbound control message %s\n",
+		 msg <= PPTP_MSG_MAX ? pptp_msg_name[msg] : pptp_msg_name[0]);
 
 	switch (msg) {
 	case PPTP_START_SESSION_REQUEST:
-- 
2.26.2

