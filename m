Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD6468AFB4
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 13:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjBEMXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 07:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjBEMXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 07:23:09 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2089.outbound.protection.outlook.com [40.107.241.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC174EE1
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 04:23:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1wlWQaU5Yx1aAbFYB5fZSiv4Zoy5n70pcsxAlwfkinniaxPiLhs0onwe0xJe9DV2TdkPGKoyGtTefpokXCHbaAW+lt/04iEV1uLvm1+QeQpxR7wBSSjlJNLz3BSWnZh9CSAMo95s6zIYXto1IMoOBeJud7LvDxF65/Vn1RB4+LRoktg9Yx0U0NNP4iSXx0SRNKcQ9+pKtw7ZsDAu5ssA1Uv3yjaUv21/vOI3vIWmjccssHiI/Jhpq/ZfpJBM1yISa3U/F0gpyBfVEXgIqIV7c3H+rEeO4C63uNX+Qz4sPmtJBtWwAq8fABFihDY5bi76GGyfv6bQKOUarYHGgSUeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/3vMlC1yISwFI/t9pQ8nMWTPDVMEYk781hQgrMa1QQ=;
 b=ZkxAW9HsDMh7WBGSOGmJ7EuTJysseV2vw9mhZxXOQUvsra9fTMnuC6s/3yLHa3ZFz2okQEGHMXTLLiSWfUKd1tzuSF2XjaNlACQQ30n1/Ich6SWgeEF6JXszvX8tE/kJj/v5Oq5mt44wPuum93eBqEBA9FBaPpZZ95Q00LLScxjskWFvwAycgTDK31xtVqTztrXTOouewq3yXdX1l6wF+oMEr4CxuRpzUE8S7WpyhDUnPKbrqzqAGeFJqRXZfc8O2t2UnL2scVM2Ad1sD7SmTGIdCtbwj46hbtzsSzDGbVHheE2gvxNy5wxDEbpwS2/AJ+aVOEmDoMxN+0XXyHtc1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/3vMlC1yISwFI/t9pQ8nMWTPDVMEYk781hQgrMa1QQ=;
 b=Zli/guW2jGwxhtCxFGzWOVNK0VsXekxkGUULKF3ZSibq0H/6snt5dx0wpi+nerPGNWWr46KXpg0JFos5nBu7SC2xeIjt745+q4it6QU+fxjLk6flUMtIVvl62z5O6UNMnOUwRrHIPaeotuBJuQkniXqP2Hg1N1hsuxXaELGROmc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7766.eurprd04.prod.outlook.com (2603:10a6:20b:2aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sun, 5 Feb
 2023 12:23:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sun, 5 Feb 2023
 12:23:02 +0000
Date:   Sun, 5 Feb 2023 14:22:58 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
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
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v5 net-next 08/17] net/sched: mqprio: allow reverse
 TC:TXQ mappings
Message-ID: <20230205122258.4zgcudfdazr7s354@skbuf>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-9-vladimir.oltean@nxp.com>
 <68933529-2e83-7755-0184-9cd882a61a70@engleder-embedded.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68933529-2e83-7755-0184-9cd882a61a70@engleder-embedded.com>
X-ClientProxiedBy: VI1PR08CA0176.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a1bc90e-91f0-422d-8465-08db0773b99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uAOmaFbum1ZBEYSfFOEzJoHk+rrN9elZJ/aMJgqurQjx9qUCIUVbfZ4ll41n4Axs/uM6Lw8inQ2tqXOYyn5+LXT+tMqj2SUCIikiL7RCbDNdf2/qsVNPTCzP39ar1mqzaJaF94ED1OqoQjcEI1kAYOPMNnoyz3WlcxVOXaHtktzUB4goBw0PKR6MgFNLom85e5ZiCWwZg5pmjXWeiwsROM5tNDC+FiXfcc+9b1pydNwDnvdK+izjA7TlJuyf6jNvDqrH8qQE4LU4XTxgMccmpcCJ+HzjZO6axfYpi//wVvTy2wDAQc6SjGa/WmbWmI+KdcF6KhvLzGp27Irwyw87+2CeNSUns5iMWXH8ZyBFVDFVuwUmbxj5yHbGRRonGPCwefubZIH82q2aDXyFv4haBJ2mjwHpjP+7Ibxc2xDr5WOCygjGI9zxLZGNux7ZJ7a+RwFAmQrUcRXjKCGPwqyosHoW/XeqZJ3cnkJWWgUG5w/+WsMFVjHzlyEbCrpbyVStRUZHlbdDDTGrvLf36oI4dPzoPfypUIdadNzLaj2UQ4wpsFv2oOdj8ebndLNefiNctnUM8EdqCSeWpiOO8ShXzLJFUw4l0nQZtiiDcZfy59QdsaL47J9uEPrX/835dwzD5y/rNJ7U6p6njc0DYRRfWfUc7Qu3VX0Sn4Z+H9ABAs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199018)(38100700002)(316002)(66476007)(8676002)(6916009)(4326008)(66556008)(54906003)(66946007)(8936002)(41300700001)(558084003)(86362001)(6666004)(966005)(9686003)(6512007)(186003)(26005)(6506007)(1076003)(2906002)(33716001)(44832011)(5660300002)(7416002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CYl/sjlDUALFwxDKlCyhIft+GzAmZKhQ7VM+RXUWJruKmlUeWVgT3ncpHCEy?=
 =?us-ascii?Q?IiRgDyoKfJT+Jt9AdTRm742FEzC0IV4kLebF/SVMtQVE7dmiHddMti1oSXGh?=
 =?us-ascii?Q?EayDeGbBqQHZrAS3GtkGFntn/AwU6aoC4SN2CvFtj/c9Vpuz1Ui7uKs5xgrN?=
 =?us-ascii?Q?mQw54rma0/PaoAe5SAVmkghXAJNBGqKPuCy041NzNsgUbIXxgs+nVUGh3zcT?=
 =?us-ascii?Q?4wpjzZG0ex0oxFhKfpj3W/iRWp1xnhj+YbxGZQziztOcZPcRYF5erolysHFS?=
 =?us-ascii?Q?cmfU7M66/A2mKU+t5uFdP3w4U+29GytKhJbs+llFZAQv/p6NFXiGzVc9m8s1?=
 =?us-ascii?Q?nARwKO9++fGWbjyfzKT69aJ4/kpsnJfE9uRq2ijscw8jWJl+3C25TtAK2Osr?=
 =?us-ascii?Q?s5exPBuX0WF3rs9Rgbkhf/fFXiPndm3emU3F9TIDdImIGumAz2EsHLSLiQoT?=
 =?us-ascii?Q?wDX25RUmn9kzjttmLRjNVeqHMIHpavwRxpZihy2/dL8luNJpherC2+GshAY3?=
 =?us-ascii?Q?rUWE72E9rG4/kMfffNctvDckMjdBUo6xKODXgod5CEIdX4PqQIGL7OGnF4xY?=
 =?us-ascii?Q?tGUCUPoqmp6zeRNv41LI15lAC6OLAAp3QYnLmJT+6547zIOXKl6TdbotK5Hd?=
 =?us-ascii?Q?CVTb1WxLnQgXvW0w6Egy0M+jnLL5RLP4ByWz6EQEXGBFQFXvOVTJCukbYBbC?=
 =?us-ascii?Q?KDHx1mC3827bD6uIXn9Z3yuGQShOWCIzmxfL4ZFajYwlBfW7vGXfpa5lF4yb?=
 =?us-ascii?Q?zb9Pb0OMDYjo1eqlJn84/lo++l4oWKJJOoQjxY7Vz3KRB6gp7An44JxpaAss?=
 =?us-ascii?Q?TPhlanlvf3zqyQDD8P3jT/XPmphZpU6lQvTca0zQ3qQmBhRw3H76uWf/49Vu?=
 =?us-ascii?Q?4en8lobWNUR5XB98XJs8F1Po5disZIB93/EGTObEguKEAH8sGbxpP+7m8OUZ?=
 =?us-ascii?Q?hYPQNlpYP5WdQ9mczvltC/ib7cCPsBy8HayQ04km8jP/VvSS5+xG8VmwgKJp?=
 =?us-ascii?Q?GHI0uJi/y0xEeqN0S07daakvB1XmUlYzffDB+MemkqJIbKQjwBoYKISC7UKm?=
 =?us-ascii?Q?eWWsNJ7VRibt4gBVO55425SIvu2OyodoRVdjj6n5sPLO5mULzYcNyrPMe+GQ?=
 =?us-ascii?Q?qx8lO4gZkMFZ8pGEpfn4jrJjnvW59UphTu5pZmpkrhBzagSkJ78PXjCvTd+H?=
 =?us-ascii?Q?76Ca1Lw++ti6OJXXSJesC/7Grsk3TC740Fc/rdxKN/shCJl/212wdQT/oDI5?=
 =?us-ascii?Q?OTDBVEVBs7l5PrYiv5R8E/3wbLWi/zJCZpSTlRo/bQTCkhPYfWVEXUyjOkIZ?=
 =?us-ascii?Q?9Ubmnpx7qQDLgQAfkmferN0zqiHx4QsCPLPXsDmH0WNaNH54UayzgO3AHsPl?=
 =?us-ascii?Q?mXsco5EVUNZJurayj7lQ9G7zKiugSscIvWaKbFZbCDoDLlAKlF6T9L0sHLq4?=
 =?us-ascii?Q?lBIQuNhU8TJA6jvmViUqiWapEFkNq8vLFn6LqJZdQJZC0wwXc5vFAo/jAP1N?=
 =?us-ascii?Q?DYKiMLi+OzXiKmrv37ambptk+T04U8xwZfxaB6qo9ZFu3PMAxEW9kc6RmHE6?=
 =?us-ascii?Q?1GQrzcKqPvVm3/MpkoIE7qxzSEx+15sNcaUEK7fEUm9Kn6WURMqqLgdSsZc0?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1bc90e-91f0-422d-8465-08db0773b99f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 12:23:02.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4XPjS9s4uheuyw61kI7KVkLKBVwZwuiP8LvcI4HVNrYvywokU7slHtesqk6BQOfe7PIbphB1TXN8KHvNWWNgaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7766
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 12:55:13PM +0100, Gerhard Engleder wrote:
> Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Thanks. Could you please put this comment on the v6?
https://patchwork.kernel.org/project/netdevbpf/patch/20230204135307.1036988-5-vladimir.oltean@nxp.com/
