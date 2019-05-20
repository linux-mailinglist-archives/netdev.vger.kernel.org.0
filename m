Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F306240B9
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfETS5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:57:39 -0400
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:34144 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725536AbfETS5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:57:38 -0400
Received: from pps.filterd (m0083689.ppops.net [127.0.0.1])
        by m0083689.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4KIuCRB019705;
        Mon, 20 May 2019 14:57:37 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0083689.ppops.net-00191d01. with ESMTP id 2sm16d1cwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 May 2019 14:57:36 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4KIvZpY109542;
        Mon, 20 May 2019 13:57:36 -0500
Received: from zlp30493.vci.att.com (zlp30493.vci.att.com [135.46.181.176])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4KIvVqI109433
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 20 May 2019 13:57:31 -0500
Received: from zlp30493.vci.att.com (zlp30493.vci.att.com [127.0.0.1])
        by zlp30493.vci.att.com (Service) with ESMTP id 60B46400B579;
        Mon, 20 May 2019 18:57:31 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30493.vci.att.com (Service) with ESMTP id 4F9B8400B578;
        Mon, 20 May 2019 18:57:31 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4KIvV3k128512;
        Mon, 20 May 2019 13:57:31 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4KIvPr0128333;
        Mon, 20 May 2019 13:57:25 -0500
Received: from MM-7520.vyatta.net (unknown [10.156.47.136])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id 07A2A360065;
        Mon, 20 May 2019 11:57:23 -0700 (PDT)
From:   Mike Manning <mmanning@vyatta.att-mail.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: [PATCH net] ipv6: Consider sk_bound_dev_if when binding a raw socket to an address
Date:   Mon, 20 May 2019 19:57:17 +0100
Message-Id: <20190520185717.24914-1-mmanning@vyatta.att-mail.com>
X-Mailer: git-send-email 2.11.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-20_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=935 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905200118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 does not consider if the socket is bound to a device when binding
to an address. The result is that a socket can be bound to eth0 and
then bound to the address of eth1. If the device is a VRF, the result
is that a socket can only be bound to an address in the default VRF.

Resolve by considering the device if sk_bound_dev_if is set.

Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
---
 net/ipv6/raw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 84dbe21b71e5..96a3559f2a09 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -287,7 +287,9 @@ static int rawv6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 			/* Binding to link-local address requires an interface */
 			if (!sk->sk_bound_dev_if)
 				goto out_unlock;
+		}
 
+		if (sk->sk_bound_dev_if) {
 			err = -ENODEV;
 			dev = dev_get_by_index_rcu(sock_net(sk),
 						   sk->sk_bound_dev_if);
-- 
2.11.0

