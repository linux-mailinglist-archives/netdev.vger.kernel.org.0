Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1738360F426
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiJ0J6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 05:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiJ0J6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 05:58:06 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B291741E;
        Thu, 27 Oct 2022 02:57:44 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29R6kqo8006375;
        Thu, 27 Oct 2022 05:57:18 -0400
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3kfagcm4y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 05:57:18 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 29R9vHdV030181
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Oct 2022 05:57:17 -0400
Received: from ASHBMBX8.ad.analog.com (10.64.17.5) by ASHBMBX8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.14; Thu, 27 Oct
 2022 05:57:16 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx8.ad.analog.com
 (10.64.17.5) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Thu, 27 Oct 2022 05:57:16 -0400
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29R9uxW5027251;
        Thu, 27 Oct 2022 05:57:01 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lennart@lfdomain.com>
Subject: [net v4 0/1] net: ethernet: adi: adin1110: Fix notifiers
Date:   Thu, 27 Oct 2022 12:56:54 +0300
Message-ID: <20221027095655.89890-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-GUID: MgzdioJp20FzslDgL5cxGUT_cNBAlDn4
X-Proofpoint-ORIG-GUID: MgzdioJp20FzslDgL5cxGUT_cNBAlDn4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_04,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxlogscore=809 clxscore=1015 impostorscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210270054
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ADIN1110 was registering netdev_notifiers on each device probe.
This leads to warnings/probe failures because of double registration
of the same notifier when to adin1110/2111 devices are connected to
the same system.

Move the registration of netdev_notifiers in module init call,
in this way multiple driver instances can use the same notifiers.

Alexandru Tachici (1):
  net: ethernet: adi: adin1110: Fix notifiers

Changelog v3 -> v4:
- unregister notifiers in case of spi_register_driver() failure

 drivers/net/ethernet/adi/adin1110.c | 38 ++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 9 deletions(-)

-- 
2.34.1

