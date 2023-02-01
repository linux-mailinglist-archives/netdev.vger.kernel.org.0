Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7421E686808
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbjBAOMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBAOM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:12:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2111.outbound.protection.outlook.com [40.107.243.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F855CE7E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:12:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POmVq1VcbJFeAlSW8CqZEtcm9lUGzKrL6Hon7sRmiqFiI+NTK9hZxwjuTkzPErb/Dru9MCbSSNdnoOc6rDAjwi1XElp2dhH8tUjbQcGB/XC4SpnJjW72TV9kJtOjcvrtShY64cVSQfNGGQj+6U2JAx8QD2ZBxEsu0e7XNSK6hxvTDF5Qh2pnF0AqzRQLET9blsVF1uN+1vAZNKERBmy7pAj/KYOjObFkbObFWClQ3pBR4yrmZJVi3ykPJCxNPNfmuNWP/mS0zrDza5qbBr2optXApU0OUBM9jWO/qSk/Ud1izp2QT0SfBwEE7kbjBNL6nS98WXahMEUroICsHcYfDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctrbpWdRr01z/sPjCPTCVrC1wAgUoJDdbVzBL78dY5A=;
 b=MyjbOUk77tMHKUEX3+7obfUCUAg8BtJfaJMcMJH3lOySHmEbsFDD8c9Kli3BFeua8oTGintrDwYsZmll/365YOFcBKzyVOare10VvMDFxiVI3xyPpN1D2BU/4USRC2veddYhrGq2LFFfvOoyt3PrYstVauBC9J5TDvKImT8xVVmcyXvnR9E/pwExrh9YuUHu4pMXQRbJx7pwLWJIH+l0E0k67BsaQCLpvN2wgIb/eNc+OYsLr+narh22WSX6SuYYkIB5M8RMN3DJjyxfmsbCghhdQU6aWRekvL22Pz7oDCwkNp8hj2VttoAERW7sdAlQEwqES62xXvqjcuTge+8q/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctrbpWdRr01z/sPjCPTCVrC1wAgUoJDdbVzBL78dY5A=;
 b=mKq4x6u5j71Q70a1uuI08+XOQh788R9lOv/WseGPWxuVGu6/0S9xDNcef3K9jeKB8Q+F3aGULUOiDU9TSjaQrIRNGTVd+8Em4CvmkbMNJxtjEzbwLC1jN7fyDcPxNi2J5fJLD4rBjAZUImIDqN08q6ZQ03Nn0C78m/Zkeu94LZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5202.namprd13.prod.outlook.com (2603:10b6:610:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 14:12:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 14:12:27 +0000
Date:   Wed, 1 Feb 2023 15:12:20 +0100
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
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 09/15] net/sched: mqprio: add extack messages
 for queue count validation
Message-ID: <Y9pzRNhZ9NaDoWeB@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-10-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM8P190CA0021.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5202:EE_
X-MS-Office365-Filtering-Correlation-Id: 72298b8c-5a16-4bb5-521a-08db045e58fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WzmMylILoZdpPmFnLFuHZ5sOouRA5JIOlHXFywegaFNhJiR58IAKeV0pSLzhTFyrGInZXkEZ5uDfOlYcibRKE71kmCOeH2rE8noqMdK9VowjW6PPZ795IU95w1NIzDZIN7qS2BRJWIqPdsQyq/zAe5ciY7q2AoDnY3Qmsmw7CltSiEIgCcX/3DtPrHPguTvvqtpKk1DGUFfutfjGHlFT4VAxt7yC9kRCrlVdm9j8ipaPN/hPOqfuoObsocP/gUazuzmoC9FrCMyqoydzcpikurWBmIm219HKe1dC929ewmaZQvTVQFw/VFkIm/1AjX2ywGuPr2HHVYlcGSqoEaTeK+YEfaMnE0J/srzB107TBa04LMAeZptLCCS7f5qfunFB7ZK5h0Obo0b3PP6bjJlMXI33KfUaUnHzR/Bna4ZMll8JvURW2EHPNpTAoqFt8QxM23ERKRSgufZSmsTu2tp6Ukd7mP1PxxFyV1rni5g/H15vfyExE76RZJuwCBk/83zPMGNqLIYl1gIPxe68plpdeklo89XW5LoEQWQW/aK5GajxCSZLeai/y4Sedjb65gCwTX0gt15HU7Grt3gS2BuIHs+FEiXtU9CBuaJfM0+OtaA5EI6UG3eOA8qa++7PHVf+iECZrVENtl8XrdK7/gKrcDjmf8kgIYFtQ2Gonx6WRxsPlQLmlspIe5hbdr2v8o/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39840400004)(366004)(396003)(136003)(451199018)(41300700001)(66946007)(6666004)(83380400001)(86362001)(2616005)(38100700002)(316002)(66476007)(4326008)(66556008)(54906003)(6506007)(6916009)(36756003)(6486002)(478600001)(186003)(8676002)(15650500001)(2906002)(4744005)(44832011)(6512007)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4lpgngSPGyWkqxkxByyi8FVHtBMnwbKU1MfFY9Udc3kTSZfrriXFkFTolp65?=
 =?us-ascii?Q?u7UkTK2HjyXTnzTHpiUwcN7/04I/n4ZXvGdJPudZdbxg/sM9TN+pNTFj4mcD?=
 =?us-ascii?Q?hoBZcHR/rM1WtdYCumWldDCDIU5lzi8oiGlWS90ZA14mtqP0nvJbc0YeIbAz?=
 =?us-ascii?Q?k7ZkRlZ1bmXSBaXt9CejBnegRl0PeFsWL/qNwl+Jc5YyiKcZ1qDnatWagnZj?=
 =?us-ascii?Q?4SB5BlpFX5kiROZQv8CNxccPBfnnIUgKf0V8YsqU6pAt5HuNwQwB7DPBp6YN?=
 =?us-ascii?Q?9uk/whTCjL5a2mDngq++frFmWRZ+5n2lFJXZepQBT4TOSWD5g4Rgzxx5YaE6?=
 =?us-ascii?Q?1a6PXd3NybWcj9sM/0HCJQElSV7s9v+DUhfLLNLlj/dyPUdAd89HAHFkhFID?=
 =?us-ascii?Q?LSoy/FEGk77mBNA9RwshZMdQ3R5bt/HnviciYO3A8EDrKeb2uH9wPSrRbs3+?=
 =?us-ascii?Q?gDH7c2dqGxz4ldzcW92cnYWdY7MHWHcY3N0DavbyptADzV/ygNHgGWZXG2y0?=
 =?us-ascii?Q?PmWDOkO9Aw0vmV7PzMOPkm4vjAw70ZV5CyT7cHZdMNFvUp4ozSMmiJYrKud1?=
 =?us-ascii?Q?NAK66KbDBjD9Gy/MYRoI0rU0LFpnggdv0Agx2cC60f1JJ8LStp/HKDB2cEGS?=
 =?us-ascii?Q?tWGigMQ4u37KGrCvveLXms3Cf1FbCaVinJdM0GM6gPuQJDo69sPaYISBc0y1?=
 =?us-ascii?Q?tmg2n8d/Tc3bgqAX80N2AXXOe8L/FBUd1RDAWbzI/CQ8Qin5QqCuK0hn8Lxm?=
 =?us-ascii?Q?BzGLrAExAITWBaW15kMqRiRu4PM6FLL3soytq7NY3sYi/cfCtWxage199eN8?=
 =?us-ascii?Q?ROJ5SAvCnStQBYk80mxCVboFd15SsxvdvFrmKWD6WAXZz1PHB1LgZ9bSja80?=
 =?us-ascii?Q?+6DV3p/5ELLaB5PDBkQUiAOK/iMV+y+CVml1aCSi8s50qSgH93hrf7FaH9TK?=
 =?us-ascii?Q?4VfRhcZduqUNMZ8405ir521dNrntjY9qOb2VnVNvgNsGYtCX+/V3gJUiUyGT?=
 =?us-ascii?Q?GHFgjY2Zt8kLAe9EVTk5RT4p38ptrkwIxqVr8BYhlofUd1krNwgOJJvja6L9?=
 =?us-ascii?Q?AQi5JF2MUKyKgzljK7Q5RL+9qypoBPsDSF6sUnCNe0CNMsSFenocDfXZc5sQ?=
 =?us-ascii?Q?37dQUZl/cb2m3/jhXH4wpwg0++UnE2CRvz1RDOS8QFtOh6eEof4vlQadt8gf?=
 =?us-ascii?Q?99lEjNxs2mr8QV3rQVZhXNE27a8LmroXPaJZ+puFKxasrlFU99meTxSH5E4P?=
 =?us-ascii?Q?KBrThF0IQndxdu96emflXSkw4lgqZ61K9CgKi4hSaAmRk/FAlFMUKkZvxnuk?=
 =?us-ascii?Q?5iRgxM4O6n9/x/eljMANHnVIebK1Ji+aRu0X4tM/QE6WyAhg3qUkXhL6ImV6?=
 =?us-ascii?Q?nXN19fpPlvbMAbKWQGYUNzfjVGqwuale7HvbXkR06C5raBJxHl3eeL3rKwqy?=
 =?us-ascii?Q?jtKU94250NThXI4OuQXJ+5O6UvC3Ddo/GwOQAgnlP//0HoLEFx5CV1OEAQr4?=
 =?us-ascii?Q?vIi3dn/JPvIBuubJIbuOfr9i0NMgV0hVg/tjpz2dCIbpVONG5MIDHx/jV9ll?=
 =?us-ascii?Q?9n7ixhKx/ZZu7uLaIjNuo/DaTijDvEU7RmfxW/kqG2s2+eukEmUwvcJHhl6G?=
 =?us-ascii?Q?prybTOjFigNXDa+OU7dJdFNa6Wm4Snuq2ZnlN7XSR7ho4sIGFUHEv+o3KvLo?=
 =?us-ascii?Q?FXvCDA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72298b8c-5a16-4bb5-521a-08db045e58fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 14:12:27.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jvYE/pn7uSaifMUoz/M+NXNR4azcZjqFsf/0Q9USZ/H7BLaKNHvs9sreg2eFk2DuO9i/7ksjtPLYqrwE5l9GOlIpOiVH7tDprdR2tb2fiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5202
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:39PM +0200, Vladimir Oltean wrote:
> To make mqprio more user-friendly, create netlink extended ack messages
> which say exactly what is wrong about the queue counts. This uses the
> new support for printf-formatted extack messages.
> 
> Example:
> 
> $ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
> 	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
> Error: sch_mqprio: Queues 1:1 for TC 1 overlap with last TX queue 3 for TC 0.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

