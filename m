Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB97B4B9DB8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiBQK5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239446AbiBQK5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:45 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2137.outbound.protection.outlook.com [40.107.244.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849BD295FC7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTYEdulTOs8scnSHJauNZGfECtgnUn1pROcf74j0MGJO7O+YWYRMpkE/wuzMq/g4vAqUD7YiwKwpsvJc0/zUIIbASD6LzILtHd2TtoG4NK9jhLzLc9ZHXbfJr0twf2IlcKb2lqD+SqEQm+7VxpQJXx1LOCNcQZxdWZwW0Vw+WBSttPQXyyuAPs8+XUpVnV6RWzWUedCyLqppMW+vjAirdiFAakrsQKlea+wFxlC/qBgIf5filnyq+tW/T83DHD+f09811DH4Zidh0i8+Ejg7FYrXtT7x+SpoWwhZx6I0Hh5/ntGBTyXYSmdg3e5aq6XfqzWGWrTAZByU0gdhiOu2uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0/JA8BlNkcs2jLZt2RzbRrCognUoYwHT7FGSqVynaY=;
 b=KbeuFllqeRXoOoYvY6NXKkCQpYuEKj//YrFfz3GLsrJk9/UYEypPCCjoYhH7OHZuYBCQqgx/qSCtSDaVvCriVFgNhtH2jdQECSq4SzlfBZhSR3+bkCeDoKT35eBQa8x72NtVDpq25yKWdU61Su1+7X03QLW5MnebuQqhpJUUUeGa3VkEMqBuGfBrkNaHi2DWDTZ7x9KDGPNvTqrQ+ugChmkDII2Hm0+qPDG/tBNe4xXfEHoti/exSmzz4J/70yrCwXogf4Nor/NZSQqQK7+fD4Zd+U6Vvn2+VR9zD0J+2Ok3FDnpwaVAu+g+3JGF/8ZEwsRGMMABmyIUuFtRbSmTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I0/JA8BlNkcs2jLZt2RzbRrCognUoYwHT7FGSqVynaY=;
 b=Wkbf6kdC4jtBFEqbqxpGVKF8MPdCP9waUf8v1tFVOjb/iFH9xmh7BLZ9ZeGctY+NFTiUazW1U0F9LySbNiLkGmoHtmRDVxo18LBbqhQ731BHIDI+umXMHBpLgoKNPu/aBXBr1aNoY0MCNBcM4WnvCTwDJ6ocZuAoDuysjixZa+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR1301MB2040.namprd13.prod.outlook.com (2603:10b6:910:48::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9; Thu, 17 Feb
 2022 10:57:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 6/6] nfp: add NFP_FL_FEATS_QOS_METER to host features to enable meter offload
Date:   Thu, 17 Feb 2022 11:56:52 +0100
Message-Id: <20220217105652.14451-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217105652.14451-1-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31508f23-d3ef-45ca-05ce-08d9f20445de
X-MS-TrafficTypeDiagnostic: CY4PR1301MB2040:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1301MB20403A5C7DDD4BE41649CE5FE8369@CY4PR1301MB2040.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2nKVrBsGUeKlqwgy09CbM4JCv7P4kFhLmpCCibBA+MpT3edfZh2zkz+dmp6Eg7UpNlLc7dNzgWnqku4tWveJTAZPi+YNS7ntif81Lcz1BDRFzB4Yk9XvrGkAsmypEZT35cgsvhh9QeXC/lAGmBd3W/PgtHZgK3TtcdGQqyod8NO1UfKtuE9uyaOiYujSjOtZXVuk/SM+EuMYNf7rOftAjy0Xy4XIGywzFzDEE/4GbNMMCl6gYNRrn+NdA255mniv5/ph4RW+5Em/UMovcn4ACOoa357Vii+4h8q7kEOBB+Jg+FNCHQ0hDLbKBu8u0hpKRmGABg1f92q53Cxju6LIW0FWceJwGxxYyfgAdVTzEtWBNKmLTYCC3M1vSnW7hksO1SW5/iU3Ni/2V4Cp4wtNhaxRDUAVVSBh/LVc5i7Dy5fStzZRHJ6kUBT6yrtlRN8hlJ4ONoo5wH3f4ZwDfCzrNKxTGxph42WPddvC4fD98OkmsuOT2xY0ATRxiX86erCzrLUFmhd3lgJor9CzuqtHCvYSnyAzI4uYW8GJFIPh1zSp3QqU5k7z2RDDyiLzetga3UCBGtcGJzE3hakfe+uA4aWL3OPfGHzJmjaBuaCPL6w4+g7PFR6jjkGTI4nr5/Tq0VgWL44/Z5V68r3M8Hysk5LBMUDAQ+pPj3wRG1IughVZoAzv7zt0rJsK+s3o0SEF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(376002)(346002)(366004)(136003)(39830400003)(8676002)(66476007)(66556008)(4326008)(8936002)(5660300002)(66946007)(54906003)(6512007)(6666004)(6506007)(316002)(52116002)(44832011)(110136005)(36756003)(83380400001)(2906002)(86362001)(38100700002)(508600001)(6486002)(107886003)(1076003)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1hHSy0tUKQo9jSHXYwFW1ts53wGm2U+twqd9I2cv3JChnyTQZ75/4J1hmXJy?=
 =?us-ascii?Q?9/IKfmreUSzTUuSkw+zW/iYaBIRnsQPmKRaGAy0B6U6xKrVe1yGaugd+HlED?=
 =?us-ascii?Q?gHYcGtLWoN84gzAf+pW/6sOCQa/UZP3ubNUOl9Wr6Uw30qYDnFzLS+470gAT?=
 =?us-ascii?Q?uLzBbmuyxC7eWQmgWwerzHI2YQq6Ol0UtvZRN1m2HyXxr+928sH7UUY7VtbR?=
 =?us-ascii?Q?dnLPgMpnB+yhdhBRthKiwCei/bJ7xWU7kR2xvMRqnQAb+ICjVv5Gienqd7x7?=
 =?us-ascii?Q?URtZIl4xUbBq3AhWZ8hm5Zg+XKr5Mv2N5pdQdk7pYZKVeOmc5cHQrMRKbnee?=
 =?us-ascii?Q?7xQ3i3+kHWvDSUxZGp41tYB1SqPYeltGBuhT8qElCvazW2rnz8HJGnT6YCMM?=
 =?us-ascii?Q?OKEU3l+4BBUo21KNTErbXrtlxUbxrOlDJePCcLbPMA8HocTMaVGD9liTFL4D?=
 =?us-ascii?Q?Wf8jd8eNLc0ttfmF/OZqyiApPQoIo9KjGb4vgWlRmh0dYPe3OVGdvUCtKtf2?=
 =?us-ascii?Q?c5w6DEWWl/7aN9QzoEanSwZoFh07apezPnzEU3OqdtfAt5rlPfx9NmuY/A9b?=
 =?us-ascii?Q?MrEws1MwMtlU3JNaEj4XikkaatfmRuSGyF7w55j9G2E+XR5PMYxoCFt/sCNW?=
 =?us-ascii?Q?xPHKIofPA7Zdcre4kWM5vNtjjQ7dbT/wG0B+3aaORUxBheJiR2SHttlNanjD?=
 =?us-ascii?Q?9Rrm0FjaNZrOveBvQGKsVQJMaSnH2zurtCExliPLMK7EYRwhdkYgvBLqKJ4t?=
 =?us-ascii?Q?eIHPNPi0xNeD1H46KweKWQV3tvgTkjptvzhaVpuWeLZMNHRLU2RgJshlT/6G?=
 =?us-ascii?Q?pAMX7MqCR7TcLCql/h7fZ9Dxdr0/FjTT4IU5bacH+fOTNJJFwGd2lbRquPlt?=
 =?us-ascii?Q?1ehTqTxTQbU2DoaXbdIXPCVLuuo/ugFQc78Rep9kqyWcbPliK2UmUKm4E9Pw?=
 =?us-ascii?Q?WIohNsE9eiQstzbJxsH61f+Zby6LXSoULrO7UABU1CPivLn8xzdWz0SlUAz/?=
 =?us-ascii?Q?NMNLLe5W9MYXBp/4OOU6GuI9Bgt7uHodWNm1FKe0mCT66e/4HGo4RVtXEWiu?=
 =?us-ascii?Q?8kX+v/gLDQpMeFFiQ5YJfOr7mCF4f5IKrpY1CL+96HHWGHBj6XcbpeOP+P92?=
 =?us-ascii?Q?Hku0HyHVQsRaVFUocgLdXcFpZMOn9RknyvQfNNxCuwZOLlP6rLUqahbAbVKx?=
 =?us-ascii?Q?n3lYyYBXGWJpyr0S8ESofx6OYr0lg0bUMyjaCvilYwIPq4S5xxaDDScK/tUC?=
 =?us-ascii?Q?r/TpRj57Ei5QZCl2XZYIv+iFuJZfd9Y3vq+sw3s79sOi3dVEmunp7r/IcaoC?=
 =?us-ascii?Q?GiWK/SX+k/VGqp+ioYJK75x0x+I2gnTLmfIv4blQZ+6OwwyuIQcm2BKYBrSO?=
 =?us-ascii?Q?DwKkeFJRFZz6OJR8AuelJcltpWjwsT7rIScZugAjLLfCUgTMpBO3L/D6UZ41?=
 =?us-ascii?Q?oNug55YGTPyWxBQQv7LRbY6A15begPxb1SKwOt4ZbPtrx0YmeHA0tJoEPflB?=
 =?us-ascii?Q?y51CGD1AeNx9fdCd2rHHmEt8Wu8skzEYqzN8+qf/d2Djq5kJdkokYdA9lCpi?=
 =?us-ascii?Q?kUEEKkINkKCQPNDtsNrfVK2svjxMZdqcfK4DumTxBHd+nptL4W/mR/jQ+yWA?=
 =?us-ascii?Q?OSDmaQosG+SkuPp6rB9ZuKS1V9lQYasKWQ/tJA+X9gfidBTw/qfZJn7JQIlf?=
 =?us-ascii?Q?cppQAOxSGElPSQa04wFyTQJIksmXtMh3Cv66S/vCiiUFVf+Z5uvt0Dt6/Ban?=
 =?us-ascii?Q?8hMmWXn5UA+bKHR35cOT1A6Nx3oDRV8=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31508f23-d3ef-45ca-05ce-08d9f20445de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:21.8417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/52N7yUo6SsXvXdRALBogwAP9eM+xXY5Ma7anmgRf0tEv7d46qKISAW1R1Oh4QQ9uHHdH4UGG9b3tdL+ZP4FeNdIQ/BeIB2lGlY6cq/ByQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1301MB2040
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add NFP_FL_FEATS_QOS_METER to host features to enable meter
offload in driver.

Before adding this feature, we will not offload any police action
since we will check the host features before offloading any police
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 898abb68b80b..627d5155e376 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -66,7 +66,8 @@ struct nfp_app;
 	NFP_FL_FEATS_PRE_TUN_RULES | \
 	NFP_FL_FEATS_IPV6_TUN | \
 	NFP_FL_FEATS_VLAN_QINQ | \
-	NFP_FL_FEATS_QOS_PPS)
+	NFP_FL_FEATS_QOS_PPS | \
+	NFP_FL_FEATS_QOS_METER)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
-- 
2.20.1

