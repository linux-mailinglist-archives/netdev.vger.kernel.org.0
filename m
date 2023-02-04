Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C2368A9CC
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjBDMrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBDMrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:47:13 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2116.outbound.protection.outlook.com [40.107.101.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BE41F5E2;
        Sat,  4 Feb 2023 04:47:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmsWdCVpODCs1neVJtaNTr3gk2rggeNIWHkA+w9rItAGwbwJ7RRjRy3u0iBKOOD2wqU1aCAyhQCwc22w49OJrcRIwpx0NEpgxV7VmdF3hrfwrGeLQD1T9sa8UHRtl1ZosBg47McA1neZy6Jnd0k3gIIgOFR0v+n7jodyGWkRrEMKjKEdfr4k9I/A6pO6/mMpgpmqpeV2AsYSPTzUUFrPn+nMsNI+pri45qHdQZks2p5U6xZTPpIVrWBcOQq8xeyZke/EDsHggcAtHapmbKtfwSRE2ryihyYzbBdSRP8QRSPE5BA6qKcPwjS5DpoyvZfSmIQS3PckiugH1/Ah3wF51w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOyAODXuwFL8fGyD8D5nbaMu8jU1NY7EA+3lHCiKHJo=;
 b=MTHQMzjYcin7yszpatf83Ja3ZKq8tHP5sHw3aSRdSqYCHZAlYQR4W4OA0VrcMXo06vISbCJc6XUv98raI5LzN7WPBlgPgFnjoYhw28dgkhRu5uTmJipPojiIbpD5m64Flnc3OMk9QwLEM1L84uUQe1hb80zjJWulAO3hsBXn5dKtnnZnvS99+S1U0NVrRk5Jp85KyvM6zXpaLoL+yluJQVHJynYGGhcCHWu0af3A4FWqOrHZoOx51WnmSOkf9aOqVF/CqPGNy+9rU0x4OKx/JbT8MCRuWQW6dUnIpapYp3TMbNALBdj1PERiHZ0FJVGAGnJihvzvZH3n8W9blX94yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOyAODXuwFL8fGyD8D5nbaMu8jU1NY7EA+3lHCiKHJo=;
 b=JrJBnp/dqGKtJZbC4V06Ce9dVfYyDct+hxHMKrDHKi6JcfGe/hj6wuiaSJnGLwkv94h4NsVTPyggCOxld//3e/ucEhiNqD24W60gLiy/WITwSdH7bsHasHmzgN4eR+UEYzXTmsmdbV+rNDHpmGnWei4k3TnVOE4DNrhlyKBNVZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5454.namprd13.prod.outlook.com (2603:10b6:510:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sat, 4 Feb
 2023 12:47:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:47:10 +0000
Date:   Sat, 4 Feb 2023 13:47:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 01/10] net: microchip: add registers needed for
 PSFP
Message-ID: <Y95TxrY5ogHFnUV5@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-2-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-2-daniel.machon@microchip.com>
X-ClientProxiedBy: AM8P251CA0005.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 646091f4-7292-477a-32eb-08db06adee4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YfQftv8iuYUee0TgV838S+1oB8CBXvi82kVV/E9LGhr2qN5TiHNgEXk/NKDdZFozTvgpGSILCWygw6/H+jzd8WMeBGUt1h26ggw2lRzmtAMHsmy+2RaB0+XdAi+t78GzfSB4NHPTGz3BWsXAtsI0waIBa5M323lre4xAUel0wRObbkYvRlEMsXUjqmYrJNUfTr9vAotpkAGr3hJJUO+fLdtRH2sD6Bs1q7cvmD429aET/AKPxfwyT4EJ5q6+OUV7i4BeoTjhAEqMcmroBZXY24p12zJAqtb4RXB/0znHA1tW+aF/8lXo4K8OKngSF+AZVktGdKYCjwjxtpcxj4DyAGdj/+eDd/238cx/R8IhRMXI4mGqtzi+KmxHr9LeHfzU1cJE3c2ZqdepESQQBMgg+bp9RhXe+6qNe8gBlWR09lqLqIX6cN4vqYWo6lP87jGyQosLFvadj/mIhXxt/f9AtSlUK1qwdBY8tVNxjGGt0C8jFXaSLvRcvj1pkIIBHX8ujk6ur9a0wqnz9gu+z+q28UInYAS/LqBSQ6H2Hud7uwsD+IfUz/Iz8Rz7fSGgVVf66iGfcmZIVGW0qkDLA5+T5t6Y4gqO4zfvVuf005Zkzsq30gWQNwmgnVKVe71/7kft07CXr3SYiKkMFrRxXLzKpqiUIQOFKirdMLbRHz2BzcW+SDEdtLIuB0I1phyzVgng
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(136003)(346002)(366004)(396003)(451199018)(2616005)(6486002)(8936002)(478600001)(7416002)(41300700001)(6666004)(6512007)(186003)(5660300002)(6506007)(316002)(66476007)(6916009)(8676002)(4326008)(66946007)(83380400001)(66556008)(86362001)(36756003)(4744005)(44832011)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rtlq2mzed/XV1oUSDQfhJl4uwQ6OJH13gLhk15xPDRvfnfGNI421DidLGO4b?=
 =?us-ascii?Q?yYslLZl6ZgNd3UinmU9yzukzhO3CFl87T6xSWv7bQR2nU8kEQ55yg3B4vSvc?=
 =?us-ascii?Q?+v19KFcNp/oOU2GOPLDIYFNkcAwpugIfMX5PpNPwJkETQsqZZhLeFh9lsdH8?=
 =?us-ascii?Q?ecsGltrUksHsDC6eLwCcgYe9FTrRtslyztDZbfmmcYic/LBc/4cxc1aS7L4x?=
 =?us-ascii?Q?8TGyXdi0EEvB9deFrzZetgPm5h7uf7muBY3KmjRl4p/IkKOnqsVsp5zYegC3?=
 =?us-ascii?Q?ZtuQGElCXuY+oXWXi8519kzn0q3pJZHiA03PAXwMecfRycu04mW14RAmBxAe?=
 =?us-ascii?Q?9CB5JzSyggabga0QV3uMQIo/JY9Ud4vh8qlfIGRCQvqgnvcN36QAugshcby7?=
 =?us-ascii?Q?Msp/BMfDZPl2RkKGq7JOLQzx+38yLAq15NTM1fpVYSXJ+w1dvAJkv65wzTCT?=
 =?us-ascii?Q?f7w4wxEBLCCCis1ivBmhvo5kvglh6Di5pfcDa8WhrvLJCW/Snxd/MSbLlK0E?=
 =?us-ascii?Q?wYlsa8MQfyg3cTc/m65l0iWzt2L4pkRpHCldOAvxWe1H76rhbfVpENwOPTfN?=
 =?us-ascii?Q?YmoCDKneaWDDepripD8hP96DBIDBehgEdkcW7eRxXpJ44NFF3kDC55NvW4Tf?=
 =?us-ascii?Q?8HhGVkt7XqLkLZOkTpLASAVGZ8uVqel1TbA7ZxOVnwdeI1w4o6H7w5T32o0Z?=
 =?us-ascii?Q?QA4vUbwWS4utDy8Z/lcta4RcifiLrW6jF17a3p93xGvTB679CYqlxQG2anEv?=
 =?us-ascii?Q?/P8cHTB8PTx39J5X3wOg9Z47HaUR/yC2wzYAqVHODtIdSst2htY57Uud0X0I?=
 =?us-ascii?Q?1UgDzX9c/Y2+sGQ7QlShQyurTCp1wVuS3V2lVt/ycUkYaLgX6o0b5hUL9JsS?=
 =?us-ascii?Q?8CeAHP4g2c7in85udjtwVxrPBqJKPdNzJ4cAMKwAO34ZuclzPqEwxcrfbzf5?=
 =?us-ascii?Q?D6l70SB9NPTZH3Ua4nhAu04ZRyNlTezmR9WPMGlvVwvvlyP17eo6ASOcD1zw?=
 =?us-ascii?Q?Czc/U2oapD++tdz6Lp0rF3jspmVqaRVecVeX9CmgIC/+grs0O3icnPkuSn3P?=
 =?us-ascii?Q?sok0vgGTGw02V7CdUyVi93Ucn4D2sNcHeUCh28OciRWcku4obCt59MIefBfe?=
 =?us-ascii?Q?GLGZlpZXTfbJXSVzyVHevQTLA9zxR22dlcosw3CNtET4vN/WA0jEeWhJFLzE?=
 =?us-ascii?Q?Cj1CxLLXblpsiBg0WwerLlxPZQHnKKlY5nJT71y+1eSKVaj4TD/j8YwcUqR7?=
 =?us-ascii?Q?87FaIVeZk0gyktVzdfX2njhRtgyiexz8xDlZ9eZy9vVGOj1ruyNv9NbR/Ln5?=
 =?us-ascii?Q?+MtCtODiUOpyudbqg5a4bW6gzQTAXV6SQ0DVSxMdV80VjqnDMHM2RDXL7JhT?=
 =?us-ascii?Q?1Z6WJeHCBwbmLHnIf+EwK2KfO8lyTIKUV1YmBSXhUGy6mUp/QJX82LL96+eC?=
 =?us-ascii?Q?NVnqF7P+EzQrMsUe1yAgI0ehGERFBLIF6ptseKVrvkiQkHJjW/xgXO9kRUeH?=
 =?us-ascii?Q?07O7L0PvUUW0ejDm/mjZzH5LAkParBBrSLCgf6OWMy+Ad+JbBgiHQ23ePyjA?=
 =?us-ascii?Q?wFOSjUMqtQMe41oabQxeOzXzKG61CKw152W9XpfOPaQqGeZYjiBWvXE8PGQd?=
 =?us-ascii?Q?++LIkDpsbWPNXbwgzmnzkv4484MlwJRDgiKLUIGmONacN7ZLtx9eqg4cjQzZ?=
 =?us-ascii?Q?OA18cw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 646091f4-7292-477a-32eb-08db06adee4f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:47:10.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJ9IMSV6cPgxwClCFF555Qwk2teCU7CQfgZOqX9kk76uGzGO7A4i0MBcZkEcxFt+7630+ETuL+NKUspoxPIa369qUWxy93WaAnKRi8xqxaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5454
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:46AM +0100, Daniel Machon wrote:
> Add registers needed for PSFP. This patch also renames a single
> register, shortening its name (SYS_CLK_PER_100PS). Uses have been update
> accordingly.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

