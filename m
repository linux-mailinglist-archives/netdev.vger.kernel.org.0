Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37874EFA2F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351397AbiDAS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiDASz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:55:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE318169B28;
        Fri,  1 Apr 2022 11:54:07 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 231IeRmQ024595;
        Fri, 1 Apr 2022 11:53:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=q+6qQA4NpmQx9XWIGLYVcp3e77JJXXO1pEDe+p8i40Y=;
 b=LQwq5wZ94Bg4lj4ZdsFrEUauf8KixcaJFkdvqxHMJjwcOQBmCZWZQRrVSSKviXqbHicj
 CG53KnAX8Xr5UqVefyT6BbSad8xOCkgpFGTIpM+4zAiMbFjLYCGuAAO5sjNVPrZX6geS
 LldiQUczA0m1WnXq7kAkhwUpZb++dLbY5wH49cqnuaycCl2G5S1kxQKQXqZfBSe6nkZW
 eehy4OeEQwnhT7yMT78jEAr/wc9SZ3ocXoNGFwoaLp1m8TFQNO23MHkQZ7xsGo8eAGWE
 oPuOFUXQ/UB+5oj5OtpW+C4LiWfNDn36f3A3up2FTjF4e4ELKH4znI4JnWDgWbmNWQYL Lg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3f5fav5t42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:53:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 Apr
 2022 11:53:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 Apr 2022 11:53:53 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 683F23F7041;
        Fri,  1 Apr 2022 11:53:53 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 231Ira9a003361;
        Fri, 1 Apr 2022 11:53:43 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 231IrB2L003352;
        Fri, 1 Apr 2022 11:53:11 -0700
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <pkushwaha@marvell.com>,
        <stable@vger.kernel.org>, Tim Gardner <tim.gardner@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] qed: fix ethtool register dump
Date:   Fri, 1 Apr 2022 11:53:04 -0700
Message-ID: <20220401185304.3316-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0KN6fYOdAs5dlvBl2a6841yYsb-Mf1w6
X-Proofpoint-ORIG-GUID: 0KN6fYOdAs5dlvBl2a6841yYsb-Mf1w6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_05,2022-03-31_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To fix a coverity complain, commit d5ac07dfbd2b
("qed: Initialize debug string array") removed "sw-platform"
(one of the common global parameters) from the dump as this
was used in the dump with an uninitialized string, however
it did not reduce the number of common global parameters
which caused the incorrect (unable to parse) register dump

this patch fixes it with reducing NUM_COMMON_GLOBAL_PARAMS
bye one.

Cc: stable@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>
Fixes: d5ac07dfbd2b ("qed: Initialize debug string array")
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Manish Chopra <manishc@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index e3edca187ddf..5250d1d1e49c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -489,7 +489,7 @@ struct split_type_defs {
 
 #define STATIC_DEBUG_LINE_DWORDS	9
 
-#define NUM_COMMON_GLOBAL_PARAMS	11
+#define NUM_COMMON_GLOBAL_PARAMS	10
 
 #define MAX_RECURSION_DEPTH		10
 
-- 
2.35.1.273.ge6ebfd0

