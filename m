Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0559468A9F4
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBDNTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBDNTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:19:02 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2113.outbound.protection.outlook.com [40.107.223.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2772E0F4;
        Sat,  4 Feb 2023 05:19:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDDoqC0s9wJ6pXp5JC1olZ+gXuiKjNij1zfuA2xELoNFGDwh0GcwbxFmZvhTl/1yB8045F6ute3N3sXSWzJIUqqrdMT9ZTqW9MRGMeZ9If76wMgvA91A1KscOBk5gnDJ4M2gK6mtGEhG55u79Z1qWgRsllgWOvIboN+iEWhiFcScc9qyn4aIicVcafmXAIn7fWpwCblgDTPk+2fZqjPBPKhFbv1macc0iSZAsgor5DC53lFX5ynKuxbC5LX+pMCUH5YWQcV1s8axKEvmCmieE+TZtPKJ1H5dINDxofi7qDMyPaclyRczz6BNM1KBRaC49xV77OttlJ2axQ8cIilS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XNo7GHGJKm1AZkLm0TOJd/gWJ13xa1zqnYuDo0zZNs=;
 b=OXpBoogQS3WItkQx6AAYo56caBK3tHNlvt68T1kOVOifaU9hzM17VwimFL4/OILgMpHKrKo3GxuJ761mXr6ML7mtkCH0P9RiSLUWK8gNwQKQVInfSEw2Mf5GcRQ9sdz9ji5CXJpo+RKFTTXa0X22aYC6ooSMADrjRRtjl743p7AT+UqAj5p2iO+I4/Ckt/llEOZanhPq9FSw6rvcJRpNJg1OGHEqMC46zHoxwrERjrOIwxYg7+UBt7VkPeTVaNvbNTeLZ31yB8lf55QHxKLIpYhxeO0NMVQYHzvxRkoQpJKvkplF2bbjYhCOyCkGsqlKV6vmfSJ9OFFwmTszELx4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XNo7GHGJKm1AZkLm0TOJd/gWJ13xa1zqnYuDo0zZNs=;
 b=tYeE9Iac/O053ZBiPdowhbbjw2vZGJmwuUyCii2NrzndGTNcS3TeMKFK5EqfJdrmaC+Mz2yzTuVvCi4j64sAwU+qI6QxWKjC2fzr3cUol4zX+fwDNQ5p7wNiHkdzZN2DhlV4V+aQC/mYlm0l3c5ua2TFfG1Ew0yemV0U1U5Be68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4784.namprd13.prod.outlook.com (2603:10b6:806:18b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 13:18:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:18:58 +0000
Date:   Sat, 4 Feb 2023 14:18:51 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd-xgbe: fix mismatched prototype
Message-ID: <Y95bOx9iYYRmTHtI@corigine.com>
References: <20230203121553.2871598-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203121553.2871598-1-arnd@kernel.org>
X-ClientProxiedBy: AS4P189CA0042.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4784:EE_
X-MS-Office365-Filtering-Correlation-Id: 936f7379-9a06-4a4b-ed26-08db06b25fcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KX5wCKeMaU/sSF7CUeyJXTr1bIJpeDZQdSBhGbSieybrU/vTK7oU1k04ioFZ+Qp0zyaUlV8ipM+RrFN7fAdso3PCf+FlUo9cDj++kdH2iAIUT2xXbhx5gSdId7HyimmWdBwrWufI0f+WmPRjV4vhXRSXRKTivMGQEXgNbSlTGMmJ9YLLf53jpI0jiXw9mLXjjhQbfqJcWN3vhvoqA+zR3dhWVmnrEnFcHJFeZCAG8JI1kCwW1saE/aWZh1weTSKrjMmEqZdAzs55YwGtG5Z9rHjNG8H3IIdF4+lnKGqKLUSIU3V+3w5F3U25Up2hWZxj7EaYAqXXi694ZDvvrURc7gaMv90ZJSl54nhWzrtijTYrgMRZhmJOMrOD18KefvMfpcyZ8uVlIN6zW8SfLa705dfYpGrPLploYVIr3fBS9+bhd2Svj7G3PDJITnxXocljk11P5f7MKz7AkhBw+JJvpLcnU6QY0F+90A9b64WoJJD9eTxAqiRSBvB3PLa45UDPrlKhCxbdwqT3EXQ8xMC/sXbRbgTSdo3BDrRmS1J3RCCEOKJoLjV2ivUOmz7IrMNzGxUicGt58+heAVlUWvxMRs05U3pFRklLkmZnwzE0dnONEkR+F3MdjuPmTZrqC8QlZVTbsmzCUi7bK+so3PGjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39840400004)(136003)(376002)(451199018)(66899018)(2906002)(66946007)(6666004)(41300700001)(44832011)(478600001)(36756003)(7416002)(6512007)(186003)(5660300002)(2616005)(8936002)(86362001)(6486002)(6506007)(66476007)(6916009)(8676002)(66556008)(38100700002)(4326008)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b4rFmcap4kc0FtLL5VYZGSSMZiGpEt3ybbk1HC6pm0u5O941DTioNAOn2HyG?=
 =?us-ascii?Q?EXYpB1VyxGdpD3wN0PpETEZEGmyjQmW27pMbvKY4mH30jnFO4WFVxraj+eTD?=
 =?us-ascii?Q?S6vfF2NwhJNT6pHcZiq7GxTA8oSlfraUsdWPsfmWtqQF2dOeJHUwhv+LE7v/?=
 =?us-ascii?Q?PFafyA/VZFIE4D4JE1MvzNUIRTN12TmKO9lpI2BF0FOPmKOhnLZYtiSSOOGD?=
 =?us-ascii?Q?oIAMa3J+V10MJLX4eU7julnQXChEIyK4lFWGRmJRhV0phEBtt5IlldFEsebU?=
 =?us-ascii?Q?iFAeAPEL6WIZnoiQWSwMw404t/tCNEeMa03WPGodenzzDd3+eeXQJJzOBjq8?=
 =?us-ascii?Q?+N7LjN1urJuYLJHQ9Gpg6LnRwkwhIcnO9bqwmbIjeLG2BNrb6ClGa6vfGpZN?=
 =?us-ascii?Q?kGsF1KlklNJxS3f2cyCncTLoPnrvosKsor840Leh8xfP3yfmnLh8xpnK2J8S?=
 =?us-ascii?Q?FSYI+QxJOtC+rPf0qkJT/0eXMg3YXA/bgSwm/gB4ikIE1yGe3oznzePTKUMl?=
 =?us-ascii?Q?oigk/dWlKjC1Kg51GIvbJZ4JxFQUtBVfk1p9t40oupnTj4XBqOURhPk9wz5M?=
 =?us-ascii?Q?gi+/PWgJacwbDegxA5SBjp7F2x35RRfacqjTENFGnLeBwxovNbe0yadsRmAD?=
 =?us-ascii?Q?5XP+FLclEdR8i6ggFLMvU2sm/86hUz1s7r0O+EOavtKh1f7xR4N+psXJjBd3?=
 =?us-ascii?Q?//8cooMv49r9j0AUvdBGc/WalTLp5TBrVUB0YsLP3tdH956veVgLVLzJCDyN?=
 =?us-ascii?Q?bNixm2Gc6n2RpxUJ6dt/WIna1kLK2MKy/1yLRnpeZMt52gQ+oMZf52SekgCz?=
 =?us-ascii?Q?liz3/c+LDTLzwYL+9X7ATl5/1vUgLLfFPyXwhKLvyTwA9Hrm0Z+yTFMm5HZ8?=
 =?us-ascii?Q?Dhf4P1Gp6oXdZvr5lFdPxYASTpo8SJVXu8pjS/pUh/PqyeYbMC+Hm8XFtV7d?=
 =?us-ascii?Q?cQpxuGlNO30HW4e2CUneUj8627slj7wkOd5bq2jbTCYZeBsbzdZzucWi9Bj1?=
 =?us-ascii?Q?z4SrqvgXjtu9i+cBjwLRwFlxoabK10/5GYbHQFyosq62SxL+4qm5IKJ7O129?=
 =?us-ascii?Q?idwngvL0+QWDdEInG8GT0LUT7yxR5VxOKhgkZFqUVM+QoguaqS3aahfkoKGa?=
 =?us-ascii?Q?+DrB+yHjy3yzdvGKtM4zF8haDy59B24tAT0depVnSz9bqCyVPzMcZ3wGFL7T?=
 =?us-ascii?Q?qGblNduNLesltfLcb8hEcSzyC0N3mDUKJVg4IizCxUCMJeq83QEk71uuugN0?=
 =?us-ascii?Q?4H8f6AlReLOjLNLcGu8+GWwrIMfqIWOZLAdGdRaKj9wuhSwqACO4D3YKGTmU?=
 =?us-ascii?Q?NnYgxxwJHEnPytJTEuweBgEszOa6y+TFp99mJ3QF8lTXNEbi8XWGNRvjJUKz?=
 =?us-ascii?Q?WIfT7CQe6USzqm9FmeB+ereikml6I2LqIsWkzwgTVoogTyfsVDnHT6TmVxlq?=
 =?us-ascii?Q?sT2Zke4AbGQdA2Ej4UdxDW+JpvNOYGkOAuBDKy2oXIbRt+VDo/t7dVz3JrpT?=
 =?us-ascii?Q?IrjyCZ7QazIpcGBig+kFG5iuTiqbKWU/YgN2unmpMbH594PcO6k9KKXW67Me?=
 =?us-ascii?Q?NcXstTC4bOX3zhTQu/N0stCLh47Bfh87/fWaaoVC89NilUEdw/Jgo8L6FdXz?=
 =?us-ascii?Q?apvBUG9kKqKqC1lOudTCLKRrJQTRr8iT/s1bOkoHmhHenHiPOKx+fiRry22Y?=
 =?us-ascii?Q?Gginmg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936f7379-9a06-4a4b-ed26-08db06b25fcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:18:58.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QorHx5BqN6b67aLYOU6tv1k3c/a3O4QQ7qGNSK9Wv0aKwNhmNs0jtBef/jH0h5Z+tJKvVuKEK1iPYBnS+D9Nm3/aLquWWFwJoEtXO9CUvwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4784
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 01:15:36PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The forward declaration was introduced with a prototype that does
> not match the function definition:
> 
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:2166:13: error: conflicting types for 'xgbe_phy_perform_ratechange' due to enum/integer mismatch; have 'void(struct xgbe_prv_data *, enum xgbe_mb_cmd,  enum xgbe_mb_subcmd)' [-Werror=enum-int-mismatch]
>  2166 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c:391:13: note: previous declaration of 'xgbe_phy_perform_ratechange' with type 'void(struct xgbe_prv_data *, unsigned int,  unsigned int)'
>   391 | static void xgbe_phy_perform_ratechange(struct xgbe_prv_data *pdata,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Ideally there should not be any forward declarations here, which
> would make it easier to show that there is no unbounded recursion.
> I tried fixing this but could not figure out how to avoid the
> recursive call.
> 
> As a hotfix, address only the broken prototype to fix the build
> problem instead.
> 
> Fixes: 4f3b20bfbb75 ("amd-xgbe: add support for rx-adaptation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

