Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 959F73883E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 12:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbfFGKuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 06:50:03 -0400
Received: from mx0a-00191d01.pphosted.com ([67.231.149.140]:49678 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728115AbfFGKuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 06:50:03 -0400
Received: from pps.filterd (m0049297.ppops.net [127.0.0.1])
        by m0049297.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x57Aj5hN035109;
        Fri, 7 Jun 2019 06:50:00 -0400
Received: from alpi155.enaf.aldc.att.com (sbcsmtp7.sbc.com [144.160.229.24])
        by m0049297.ppops.net-00191d01. with ESMTP id 2sym462ga2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Jun 2019 06:50:00 -0400
Received: from enaf.aldc.att.com (localhost [127.0.0.1])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x57AnxXD025199;
        Fri, 7 Jun 2019 06:49:59 -0400
Received: from zlp27126.vci.att.com (zlp27126.vci.att.com [135.66.87.47])
        by alpi155.enaf.aldc.att.com (8.14.5/8.14.5) with ESMTP id x57AnsVm025123
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 7 Jun 2019 06:49:55 -0400
Received: from zlp27126.vci.att.com (zlp27126.vci.att.com [127.0.0.1])
        by zlp27126.vci.att.com (Service) with ESMTP id 81E094030700;
        Fri,  7 Jun 2019 10:49:54 +0000 (GMT)
Received: from mlpi432.sfdc.sbc.com (unknown [144.151.223.11])
        by zlp27126.vci.att.com (Service) with ESMTP id 6F82E4013F97;
        Fri,  7 Jun 2019 10:49:54 +0000 (GMT)
Received: from sfdc.sbc.com (localhost [127.0.0.1])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x57Anspr014433;
        Fri, 7 Jun 2019 06:49:54 -0400
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by mlpi432.sfdc.sbc.com (8.14.5/8.14.5) with ESMTP id x57AnqA6014386;
        Fri, 7 Jun 2019 06:49:52 -0400
Received: from debian10.vyatta.net (unknown [10.156.48.137])
        by mail.eng.vyatta.net (Postfix) with ESMTPA id D9A603600A4;
        Fri,  7 Jun 2019 03:49:48 -0700 (PDT)
From:   George Wilkie <gwilkie@vyatta.att-mail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] mpls: fix warning with multi-label encap
Date:   Fri,  7 Jun 2019 11:49:41 +0100
Message-Id: <20190607104941.1026-1-gwilkie@vyatta.att-mail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-07_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906070077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you configure a route with multiple labels, e.g.
  ip route add 10.10.3.0/24 encap mpls 16/100 via 10.10.2.2 dev ens4
A warning is logged:
  kernel: [  130.561819] netlink: 'ip': attribute type 1 has an invalid
  length.

This happens because mpls_iptunnel_policy has set the type of
MPLS_IPTUNNEL_DST to fixed size NLA_U32.
Change it to a minimum size.
nla_get_labels() does the remaining validation.

Signed-off-by: George Wilkie <gwilkie@vyatta.att-mail.com>
---
 net/mpls/mpls_iptunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 951b52d5835b..20c682143b01 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -28,7 +28,7 @@
 #include "internal.h"
 
 static const struct nla_policy mpls_iptunnel_policy[MPLS_IPTUNNEL_MAX + 1] = {
-	[MPLS_IPTUNNEL_DST]	= { .type = NLA_U32 },
+	[MPLS_IPTUNNEL_DST]	= { .len = sizeof(u32) },
 	[MPLS_IPTUNNEL_TTL]	= { .type = NLA_U8 },
 };
 
-- 
2.20.1

