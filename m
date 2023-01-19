Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6A6746D7
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 00:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjASXCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 18:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjASXBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 18:01:55 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2050.outbound.protection.outlook.com [40.107.249.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FE9C9;
        Thu, 19 Jan 2023 14:53:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OrMojIu4K3CyPS8JTyT8N92bZPsI9DCES1YcZWHPiYWtW6dDTsGzewN1dVTM6t4qtoLuJS4gHWqXEjCCMd7JZrm9o6zP5+wp/Naeq2Y4k3EwFVDqNk8OBrvPpxPqR/YNeOP05mDQ0sB3l2lrUMJV31kOPVe4aw3fqp36hPaWCYJi3YV4gHe+FMgk2GilGxrai14q2+htXsh4yeR0LwxHB0tu5N0vX3fOI6hQ/1TNnHepc1SvV1Bj7AkY3tAnzDYw8WxXqHtMmXNSvf00ht1ZJCDrUzvtB1piG7sQIuFdbrM/rmolkTp8AAyBHUpLh+/Q6wTPob0lQQzmXuoveoWyCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcbOfTlztRJxmJlL3nojiZncrqK7+cn5WAdDcU2+S3Y=;
 b=HLQVr5ODo/fKsz5Kia6CY30NvlEX59hlAYzeiIWczQkNZR2lEz8x3WOXv/G8cxXCjlaZC82UJDr4tL27f/n4r6Mgz4Ok2kdJXKPayM/dtFi3OliHskpZMvspgjs+n20wzfv7Nh8ylpWKcb4uMhK0Apzgcs5awETql1YojzL/hKXhV+fVKdVOKz3ii53jlE+Tmq6fyI/AfP+Z15U5EmA67n2AbzK6k7TCJJXbzHdMUA5JxI9L1a60AdqwSoD3FBReZ/tkPGpSjJSIY6CJU1qJN+gk5H3wy/qxg2ou/aWIqRb7Yfwx8O/yuDxfvoyD3D4Phiam2ZP9z1jm2VoMf+wABQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcbOfTlztRJxmJlL3nojiZncrqK7+cn5WAdDcU2+S3Y=;
 b=gl0+Hdz3gYgWSW8LPQNt7r/8LlKdxVfByjwHIbEulntvSjRYoOqnY03IndyoXwDO6HjFRpCkL44nX27D7nxC7nunB8fK7qTdH4AnK3T8HeIF0LvWzrhw19qIZiXWZC8BeNWSY203GWOWfTjJAPYyz8+MkqIq22bK5KUu0+QijPc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8553.eurprd04.prod.outlook.com (2603:10a6:20b:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 22:53:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 22:53:05 +0000
Date:   Fri, 20 Jan 2023 00:53:01 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     nikhil.gupta@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org,
        Yangbo Lu <yangbo.lu@nxp.com>, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vakul.garg@nxp.com, rajan.gupta@nxp.com
Subject: Re: [PATCH v2] ptp_qoriq: fix latency in ptp_qoriq_adjtime()
 operation
Message-ID: <20230119225301.tjf5cxaigokho4nf@skbuf>
References: <20230119204034.7969-1-nikhil.gupta@nxp.com>
 <20230119204034.7969-1-nikhil.gupta@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119204034.7969-1-nikhil.gupta@nxp.com>
 <20230119204034.7969-1-nikhil.gupta@nxp.com>
X-ClientProxiedBy: AM0PR10CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8553:EE_
X-MS-Office365-Filtering-Correlation-Id: 152ba557-31b3-439f-84c1-08dafa6fecee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0arwLSWPoeHOoXKOrjYFHAl8wkUGTeggvkrPYQQO2tuhpTOukbU/OcX+ffUaMAyNr1t09thpkRWVmyIEGNpz2nL72+/hacaiMFPdDerpp8s7XzgHv8ECFyQ7L4z3Bo5OJoYUQf6/NpZyyFNsiNu248nkt+yVPQ3GsWrbs1JfjfyXavcuY4z2IckZBeGICToJchMyCwFTsAufOmeSB4GNJYCYje7tcAK0cel5hWB0csOe5tQMBcTqZ7LvmiuePa7ebJCRuswKE/Rj7YRzHerL2p5k0FUH+2JgT6+9MV3XYJikwS03gVi+/cSPKlV2o0PEBuFZEbS+ZKycTi073fqGuIi+UyGU8RT3HgH7LGnLyS10kZAjQvKCjX839KJoE/+T5KNsZg1FTYWT+JoeTC38INbzb6JdDptwafxniNHuVaWqErJht2tm1uuWykB8RlQBbBdb4bztOYq9bQytfIgVUGHF+xg6AGNYSa3QVSzU5L6ev+giQT6zbbY3rsDig6P8NvCcQKDuJfmJMvUKAhLLyllWu4W0cnXpAxHCRmBZXU6AwhnNW0xVUxqp5oYOCkCFrZslgIkrBaDRXLC/J2Sl1pYiQHTaM5XO2FNrVK8t+WTg/XIkMe7RAsMGfMevqvszv76/mgh0ZZqgxT63zTocg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(366004)(136003)(376002)(346002)(39860400002)(451199015)(66946007)(4326008)(44832011)(8676002)(66476007)(66556008)(34206002)(5660300002)(83380400001)(8936002)(38100700002)(6666004)(478600001)(6636002)(2906002)(316002)(86362001)(33716001)(41300700001)(6512007)(1076003)(6486002)(9686003)(26005)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6ZajaMDjXcJSGj0tUU9N8reqTR4/JsJmS77ENEUE4vwa8PVi0tQdNyZRI64?=
 =?us-ascii?Q?Ppu8lraGa6AZX8LhClJP4qvys7AjSfm7Uayzm4hs8y+s0gblzew4+0sFmcaG?=
 =?us-ascii?Q?4VJap0SILeAHtwsKmpc7/pSzoi2LqYxxBczjJYBkFWiVBZWjzChfGtunHo/F?=
 =?us-ascii?Q?4pDV9eMDZwD1bjK8IC9fxvih2dBzyP135udFvy1eRhT35too4ZblMEiXVEAo?=
 =?us-ascii?Q?PBYCNZ5SO4dV0hQrdwd6tT5K2DYTnQVLosn8faIIUAxB5D7NRvPj7ZrG8Xvc?=
 =?us-ascii?Q?qJ7Ww0hWz54JegqdZGyxJi9DC/w1nKfyLuyd7Mpop8NADbq7CQf16VxD9yFh?=
 =?us-ascii?Q?+jwZH5FL9lDfoI9uRdI1jOBWZzgIGmsZEoNOMQh++HGJ8f+hBwYUxN9o56/D?=
 =?us-ascii?Q?xOhS127fzBI2MXAmCQ60eIaCe0HDpBglJwztBV5P2qqVwsHSYpUK/XAUCBpf?=
 =?us-ascii?Q?9xaigmMB4A6VUF0cRj+yWS4pQWMRkpYXf5P3fd5sRou51SGc1SbjbRsGksO7?=
 =?us-ascii?Q?dpC2imh6gyhqwNlQuuHb0XwkhVocKGQTb+q15QgUcL9f7kuc5aO5V7MYghwg?=
 =?us-ascii?Q?kHOqcCGuTGqavv1shSOlysF/AAPEZsU0K6p2kbs8Zfo9HzyPaLLZlhPTe0Yu?=
 =?us-ascii?Q?ir78H8RzNmHYGPap3gVgG/ocyyDq7Zh87NUDd4rRZnfKNXu9Eu5O/1xCK5nR?=
 =?us-ascii?Q?JV0wMhSQyDR5oxa91I8/8NRBzfZr+4dU7YRaGUw14zz+pYGY/meF+sXsEq1M?=
 =?us-ascii?Q?mM/e1kfXOKgztOB/EbD4ZQiNY3B9TN7YJ/A7qShXfAZSw4REQ/HZVcO4q+eD?=
 =?us-ascii?Q?f/45K7SYykiLuvbxUxHfdPNHwxR6MPU4VwkELbqDO4smm9ngLGFxS1YcHcFU?=
 =?us-ascii?Q?31y34aca3UPWEyOzvD3v/iE6KXRgX3HrvywzYL664fLuMn6mdgAZAEbJ0gIt?=
 =?us-ascii?Q?amw+ceett7CtColbvDvspWTlEyTrZDlIPSOa227Thrk4K6WIp2IkEiuhCA6x?=
 =?us-ascii?Q?xXUrisbGlEGSicr4qFwAktY/3cq75C2ppfIMMju8p31BJyqhf7xnwRJ1H9S5?=
 =?us-ascii?Q?VZbz+9ykZ3Uh9FhvAvhRnKKypmpOjDdzH0EgpG8Jfue3uytiI/5GwHEQEHAm?=
 =?us-ascii?Q?jP6OXdmm2oyPnwU7/troT3h85oNZY4KYadxBGtRf61iZUDHtElV+AO5Frm8D?=
 =?us-ascii?Q?UQqRP8J5dUjHCfaGYj6j6Oi7Zofi6HnsW+1jjVk1ZtX/vApdobEZ4DkJtrl5?=
 =?us-ascii?Q?LXMnXQZw92HTHd3xWgTG2U28zAf1W7cZjnekN2W43HmkfZ+vKwJjJaYE4pEm?=
 =?us-ascii?Q?Rvk+hIbkf0C7/wXox4L8aP0YI6Ueqwc3rezOrQ/MK0dsGFqLHpgbGMFv7xb1?=
 =?us-ascii?Q?e8e//vENIqRrMuc9Gvh3dzuMF8IZ+Zj/OInfDbWiA7fbGV6Qu8MuvluoLePR?=
 =?us-ascii?Q?3QVWxBy2HRkOR7QVBgHlx9u72Oe2yxGCUU683cNhztv+CkSbttCllxoFW+d9?=
 =?us-ascii?Q?deVARJ+q6yS0dSeQk5DnoqRP+uVdIEZVZyvmriRpUie0P1k1XOCSN7YvsO7l?=
 =?us-ascii?Q?TP/BURF2BzWZ/B7uXWMtM/6u+8C83oJm+dKvI6Tv4gSgCwhzHSZ3yen5m9DQ?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152ba557-31b3-439f-84c1-08dafa6fecee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 22:53:05.1433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+ZVtPw7Os8gHmeE0+TIOkX/jbaUIsgm1GziWchLTpRM3rqYcV62UpXNUhLRk01RiMUpzbfeXHAvZhCMxTmkCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8553
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 02:10:34AM +0530, nikhil.gupta@nxp.com wrote:
> From: Nikhil Gupta <nikhil.gupta@nxp.com>
> 
> 1588 driver loses about 1us in adjtime operation at PTP slave
> This is because adjtime operation uses a slow non-atomic tmr_cnt_read()
> followed by tmr_cnt_write() operation.
> 
> In the above sequence, since the timer counter operation keeps
> incrementing, it leads to latency. The tmr_offset register
> (which is added to TMR_CNT_H/L register giving the current time)
> must be programmed with the delta nanoseconds.
> 
> Signed-off-by: Nikhil Gupta <nikhil.gupta@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

One detail regarding the process: you should have clarified your
expectations, i.e. the patch should have explicitly been generated with
git send-email --subject-prefix='PATCH v2 net-next' since it is not
targeting the 'net.git' tree for bug fixes on the master branch (which
are also backported to stable trees), but rather will be included in the
pull request for the upcoming 6.3 kernel.
