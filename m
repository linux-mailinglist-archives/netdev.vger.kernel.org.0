Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56695686807
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjBAOMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAOMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:12:01 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2125.outbound.protection.outlook.com [40.107.243.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC9349968
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:12:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q09SiLhZcvjnuL7QFtIV0QgDNgtru9xUpkFyCFpTjQuCvjAS1ckEesK+qs/Gz+NMX1Os6Axfady7BM6dirppJflv/BUOdgHCIDTzhGEA0Lg94FQyw3qeHVMGMsX+5UEuLjqACArI5p7A1WOhUhmqC91vH8v1wpqVLw8DVeeHoo9q7nGr09/jJSSLkr2eRPKRgN0NH1HL3ar1ooupGZ8hJT4fGY4FgVnprwX6hL2baRKrl4RjV/PwX5GE9L1eIY5wj4911reqtIjnG9LGJLcidmEVN3FGxsoPOitDGIVZbHDr+7td/Zx9Z0W0b3WxxYG3Sv/iiUEsgnsCoL6xmiEVhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMaqgQOMOkaE4oYQZ4cB3LoSdQpF5qeSnqatOIIO4Yw=;
 b=JTEdFFPvegDfCkUrcHHFQNxZEClFf+WmfvZjt3yQk++o7XeYNaoYVxIPIIvbsP5gM/rNcLPGnjCrnNwkNsQa2RHKmdgOuRLKzgeI+yvPLsJ9xjleN3oRfMf2UUDHj2nH3bLj4xa0y+LQUR/PNxZxXJ/7WArzQUklNAzpmQF8+S/DaUJJd7PaPuT6e8+oF16NJXiAabLfIg0rUHrQ4QJMFSJOd+IW9hjUJ210MIRepyV3MB2qSaquKov44kgglC0Ao2v5apnvLJG+VO1RP2yOK42BjOzGf8uCYRgUgdrPhfG7SjEL56dCzM05+LjA/PQgkBdwtsWugq74ek7QqoM6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMaqgQOMOkaE4oYQZ4cB3LoSdQpF5qeSnqatOIIO4Yw=;
 b=UXD2MFMD1lfPGLkS+/Zy4WVOS63DORT6gI87CgN2aS5DxBiSh4oXklG7Jd8yEVAamV8nGbtQGlh/vj817mBMGdhLZAP/cwE8iysGXdNwCDc2FX1DpYQLYSmgTy+JrdOCn0wF/6GTnoHdoHyPOCxcUZbGad1Q3vVC+eeL8BaAW6M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5202.namprd13.prod.outlook.com (2603:10b6:610:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:11:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:11:57 +0000
Date:   Wed, 1 Feb 2023 15:11:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Igor Russkikh <irusskikh@marvell.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 07/15] net/sched: move struct
 tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
Message-ID: <Y9pzIz3OALdCeNVH@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-8-vladimir.oltean@nxp.com>
 <Y9pyPKHPLuZ7Ba37@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9pyPKHPLuZ7Ba37@corigine.com>
X-ClientProxiedBy: AM0PR10CA0024.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5202:EE_
X-MS-Office365-Filtering-Correlation-Id: d8488149-c69b-49d2-d865-08db045e4736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHXpg0Ly7TX2yNv/lEIXmah8ids4PErKsXhzXyWJ7A8b9/oA1jU6D/O+q9n7e80US3hZLTfY79UuTUuNgiKF8Mv5VP5eQf9xlf1AQGgRJ7HYpL4uXCuxihVtQ8ssbccyVklb+O3jsh5bPfzwMsqUZd7trmmUmR8rGsDDEsHHj8dDBeGr5Wq6CuP0wTn5XDmYqmKaWVOoyHYAPbUfmJKreJoxx+DGayz0+49yq4zIIIHaKRePJOct1u8PJehr/8WWms7hhgM6YpaFsde7mpYbwdAPPeaaP1fAztpFS5tG6xYOGLpzct6TxERSQbkzCJYGY0cCMcDVzE0+yKlyUZZ43JKRC19Zpu2ZrVBjNRb90mvB6ZMP9WoqoW4pWMN2hh89t9a1nW2Y8AUI2kOpSCXXnMJlfSwg/rjZ06vQvTCfO7z/D/lRFie9q+yP3E5ccc/q8oXEbLEZwv++EWupe8m69ioVPySHyOYWtNvquP8VgpyoucdvXdMOfesqIGigV/to7RZdvVoSIYg+K/CGRXG5xluf+R8h6b9YAa2z1c7NWI6RxNq+xjoaqtwolNXdL8RM2as6KXO2pndVuD1NQjS1MNd1dHlI9hzIqdQWl3MYZY0uPipRnQBEvphIx6S4tZIqGvspA2D/qaR4U1UhxLU81zB55OSTWfZz6jxNgfZw7mnav5BKFv/R1Vi+u/KwWx1l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39840400004)(366004)(396003)(136003)(451199018)(41300700001)(66946007)(6666004)(83380400001)(86362001)(2616005)(38100700002)(316002)(66476007)(4326008)(66556008)(54906003)(6506007)(6916009)(36756003)(6486002)(478600001)(186003)(8676002)(2906002)(4744005)(44832011)(6512007)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WFl18PXijgfgaW2Hm/LA4AVTGBtbSUtW/BCniiKMqGZtXZLSPd93FU3X+xVw?=
 =?us-ascii?Q?WRDifDvHiiPHLA+a6kP68Fd/LVCiowZkWEfhGkwjd3Pe5DvYOxEEBGTZdGHH?=
 =?us-ascii?Q?dd609BF67FvUw8uF0VR8YhtJmzJImv7atJnZnV1AA0/Zpn+knGkrYw2ifTyz?=
 =?us-ascii?Q?p1eEnjuRXA8B3bOPR/rdKJXR1Di+T+rw8KsWKEwKt+y9b43wkxPL51TQ006s?=
 =?us-ascii?Q?GVpHS25RkVkYqfvKzsBnrhR96bLTI1uf5MD/jvY2otn1Zdt96r3QPeMq46Kg?=
 =?us-ascii?Q?Xv1p8AkbYS7vGufaKu0UwibdMO7Jo9eZAyar3fJzjfyHWFuXw2Kp4594A4FT?=
 =?us-ascii?Q?XvdHi1zObFqU+MEpeAJfUiIAZN86nUXqarUGA+HekktCKa+mHjLsvzyUqZ4/?=
 =?us-ascii?Q?QOlMyw9AcckndqCa9OLNHGlxX6lKqGf6H8h53HtCTQNPqtrlqfKfCcS2ox4i?=
 =?us-ascii?Q?ixHrT/tFFzYssQ2TmGv3dqlEWoz6vpdm14wAifhKKuweUiKsjxULOTTsIEfZ?=
 =?us-ascii?Q?Z1o2bdeio5S4i5SobI2RvbWV1Vd6nkqTPJKKAmkIKs+o2SDWDzSBnL/0csy9?=
 =?us-ascii?Q?L7PHqrf2X3h5Dxxgl0U30sWZq/ddyKP7Jsjv2yTMJQWA0cyJhcsTpCNGyiS1?=
 =?us-ascii?Q?pLWoT9PL1Er4pYHhhzESM0A7W4KoJGwNIe8x2bMf2s4q6FJQPK8z5UiHz1JU?=
 =?us-ascii?Q?quAUYiKfgmdnqH03jO/dj/n4YIlEJcjgg9ewzoQ3oCGHJlEMKVrE/0LSbYjJ?=
 =?us-ascii?Q?XSyGeCQsxRB0A02KyTGBP2tMX3m0y2B2p668MrbeWcAs2BlTPbVjZQB/5LOW?=
 =?us-ascii?Q?hNKQHrGaWnjEjswP9qkfTivlUaK+rmzTy1qm6pWaKcB0z4lswKv5AtFm73yC?=
 =?us-ascii?Q?5nK7ZThiMrmyWg/ESc7bUEOhFM22AAfaWp5oyTmh1vpP+2gNZ4DgcDGg6WXH?=
 =?us-ascii?Q?fxZRDI4N29karNAnd8yAsGeDHer+7vmBClLtVme362XRNkAtID2Bqlc2UQ//?=
 =?us-ascii?Q?pswyVXMX0se6zMilJKFcG6tafthi3E3cjboP1J/DmpJF5TY4tyYFBJRDznTw?=
 =?us-ascii?Q?+F00vpbXdNMMhig2nVh22X0KCi7+fj46wYLv8eYy/pYMx6EFbeqyzOeLMiW7?=
 =?us-ascii?Q?MF4TK7bU9sNTwzP+DWrffUpr0DCTHXCFdkHI3aibpnyoQ6eEfibbq2W0uNy2?=
 =?us-ascii?Q?bzCc1vNT7TcU2P5ZrIAknAwRcr8yWCzGbrPWiSFfuAT7ittoCT3GDnXSSLMB?=
 =?us-ascii?Q?ysCTp1jNCkhnuAI5WGXL3FRy848xExlLBawmyP4dMO7sKu2MEniPkLZY5p/h?=
 =?us-ascii?Q?THceSvd99MXTEK4jVWfIYLXwArAP3glqvkG3rSFjSpClccg7d5mJeDcqlURQ?=
 =?us-ascii?Q?WT2BocxJno+EMr0yYtmNigCS3A310ULMu/8BZKPxF2dNAFmuOZshHGmcZI9K?=
 =?us-ascii?Q?0GBgfTzneZbsIna6/AlcT6oYC5TXgOGoR0PmXZxgND4AVhpoqr43ou2j7rN5?=
 =?us-ascii?Q?5sJuS4uowN6kbgz2qI9SdHjcKGwkSKmYQTRvWa8T6rfsjtqpt2QEonxcbhmz?=
 =?us-ascii?Q?RZWoKD0wRZ/YUywTKHQ+F+UtktNVg4Grej7TVCk8Is8J2arkIVcU2sPoZSAG?=
 =?us-ascii?Q?LeSN42hNXHI6K9f07zQghUeaROnzoYuezihXa+uJhQfUfj0jUT1MDUufkFdx?=
 =?us-ascii?Q?hc/q3Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8488149-c69b-49d2-d865-08db045e4736
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:11:57.3783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqJtg3r1nlCh63/QwNJgZqIGOXIXPi0sGzG5YeEwkYCgdjAt79qbu3xL0B0/kGEwYyNyV4rtVxJ0PU4h4OkUY9JfSZJKq5l14jds3Dyl9M8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5202
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:07:56PM +0100, Simon Horman wrote:
> On Mon, Jan 30, 2023 at 07:31:37PM +0200, Vladimir Oltean wrote:
> > Since mqprio is a scheduler and not a classifier, move its offload
> > structure to pkt_sched.h, where struct tc_taprio_qopt_offload also lies.
> > 
> > Also update some header inclusions in drivers that access this
> > structure, to the best of my abilities.
> 
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Sorry, I hit the wrong button a second time here.
I meant:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

