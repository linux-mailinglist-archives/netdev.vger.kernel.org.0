Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E413112E8C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfLDPfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:35:12 -0500
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:58022 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728328AbfLDPfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 10:35:12 -0500
X-Greylist: delayed 1021 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2019 10:35:11 EST
Received: from pps.filterd (m0049463.ppops.net [127.0.0.1])
        by m0049463.ppops.net-00191d01. (8.16.0.42/8.16.0.42) with SMTP id xB4FF7rK037180;
        Wed, 4 Dec 2019 10:17:53 -0500
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049463.ppops.net-00191d01. with ESMTP id 2wpdx7jdpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Dec 2019 10:17:53 -0500
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB4FHqV8020656;
        Wed, 4 Dec 2019 09:17:52 -0600
Received: from zlp30494.vci.att.com (zlp30494.vci.att.com [135.46.181.159])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB4FHjUl020507
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 4 Dec 2019 09:17:46 -0600
Received: from zlp30494.vci.att.com (zlp30494.vci.att.com [127.0.0.1])
        by zlp30494.vci.att.com (Service) with ESMTP id EBFA54009E76;
        Wed,  4 Dec 2019 15:17:45 +0000 (GMT)
Received: from tlpd252.dadc.sbc.com (unknown [135.31.184.157])
        by zlp30494.vci.att.com (Service) with ESMTP id D9E804009E72;
        Wed,  4 Dec 2019 15:17:45 +0000 (GMT)
Received: from dadc.sbc.com (localhost [127.0.0.1])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB4FHjQW070077;
        Wed, 4 Dec 2019 09:17:45 -0600
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by tlpd252.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id xB4FHfNr069002;
        Wed, 4 Dec 2019 09:17:42 -0600
Received: from mgillott-7520.edi.vyatta.net (unknown [10.156.30.108])
        by mail.eng.vyatta.net (Postfix) with ESMTP id 167F53600A8;
        Wed,  4 Dec 2019 07:17:39 -0800 (PST)
From:   Mark Gillott <mgillott@vyatta.att-mail.com>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        Mark Gillott <mgillott@vyatta.att-mail.com>
Subject: [PATCH ipsec] xfrm: check DST_NOPOLICY as well as DST_NOXFRM
Date:   Wed,  4 Dec 2019 15:17:14 +0000
Message-Id: <20191204151714.20975-1-mgillott@vyatta.att-mail.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_03:2019-12-04,2019-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=764 mlxscore=0 suspectscore=1
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912040127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before performing a policy bundle lookup, check the DST_NOPOLICY
option, as well as DST_NOXFRM. That is, skip further processing if
either of the disable_policy or disable_xfrm sysctl attributes are
set.

Signed-off-by: Mark Gillott <mgillott@vyatta.att-mail.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f2d1e573ea55..a84df1da54d1 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3075,7 +3075,7 @@ struct dst_entry *xfrm_lookup_with_ifid(struct net *net,
 		xflo.flags = flags;
 
 		/* To accelerate a bit...  */
-		if ((dst_orig->flags & DST_NOXFRM) ||
+		if ((dst_orig->flags & (DST_NOXFRM | DST_NOPOLICY)) ||
 		    !net->xfrm.policy_count[XFRM_POLICY_OUT])
 			goto nopol;
 
-- 
2.17.1

