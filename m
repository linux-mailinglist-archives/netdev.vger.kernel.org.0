Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AB868BFD1
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjBFOP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjBFOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:15:46 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E732196E;
        Mon,  6 Feb 2023 06:15:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0ZL15MVRV01oguRdGwbJ+YJYn8tWsEk5+hcOMJfmthZg0lV8WZJ2su3ZF9kxtXRvJV+KKXvmqjBKxgGQ3tLBSGzr3AC/7gCdVSPRJZAgmPyA4PfZck+9vSuuQa2kvANS7euPwSt+Bk929s9lXAPSAoq/bMzwbcm5Fq3Z3TgNu4i2teYDD4UIa6HdGTMzC9rxmiyVtfiN0ZVxOoaNl1YoiYaI4Jtf8ZZHWgYLrozqgPom/R200ZThkkPmL2SvQ6AbhttQrHoPNkHaw3DeZ4NyNm2yvsudw3WIEFQAExwALpbHz1QvJh05r54+TE1Fa/ToQeeZhITqbeESbihAshOyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16Z8UQOQQNiFV7GwZ9TQEvgt/s2izAOJGdm+es/lLrc=;
 b=TmzanUmjcwIR0lCwQYDYVO3xLzjObLiyeM3llxSHwQkNw62skv6Koa8SGEfJh5BefxKOa4soFObk9OwEt/RY8JUpM/2289q+4FwHzwCSd3uTSTFRrjaUH/TKcVlSmImvPvzkwdlPfk7SStaQfWZhsjgztqEmOyXutNSQRnGE+MLZ3ZGAp7J+8ho86WI4jcMVqwmkR4HLfs+ICuwovSxCYVj1Sl37MUHdDLC4G0mmPVzfDO011YGBBZ1MiQG8rdlSl7tosjhV2BW2JINw+49Dwprj0ic3fsZhC+LbwZ1N5DyaapXmz6c4s9/H/JXjb9Pp2T1L807uWZ7o+Yv408d7bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16Z8UQOQQNiFV7GwZ9TQEvgt/s2izAOJGdm+es/lLrc=;
 b=QJP/chEph8Bnu8BRUi3nqdx55aV1McwJvpeLmhZckcqJh043jCZ5A29ElUt7FVbLZOa9/aruFwTkgDrIGft0vkYnP1UWhYz0d7Q65dcIMgd047JZlghLpOP1F2JkzG3HEBTTFaDqJqs5J6dn9hD6JMaORN1Wrwo6xjvJ7HEuJ20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4704.namprd13.prod.outlook.com (2603:10b6:5:3ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:15:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 14:15:10 +0000
Date:   Mon, 6 Feb 2023 15:15:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Kees Cook <keescook@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: sch: Fix off by one in
 htb_activate_prios()
Message-ID: <Y+ELaMoPBAFMaTbU@corigine.com>
References: <Y+D+KN18FQI2DKLq@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+D+KN18FQI2DKLq@kili>
X-ClientProxiedBy: AM0PR04CA0059.eurprd04.prod.outlook.com
 (2603:10a6:208:1::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4704:EE_
X-MS-Office365-Filtering-Correlation-Id: b0fc14b8-e3fa-4ead-f801-08db084c8ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EOIrcbhcVScGTMaNoDda8zq6HAravnwZqmjqCNNZTSb4mpOFPzWjZeAOW78oHa/ztGAHqquf3j0EAaika60731TOahGE1VVgXqL9P1RHzAClF8Z0trAhBXfybSUK7c1xOjmwoKEsI6n+QtIlr5eapdBYe9oJ3EbTxQy2dfGi6QnQvkQayBpFKWyh+mypk71l6lHGvn5rBJ3zpCebRxeNvC6Dak0F83Hju0yL34XdPhE+T0w25bYrxivBXHltJCb2JpE/j3FpmjPMAvnToTYPBgTXPsdB9Pd5J+drz/O13Y0WhZSqcC26NbUmvgjivUw1vi0Jk3+t4IXuy/czY2OOBAYDZqPRYhRZQ9LBK4jbYnhT7T9LlpVjpQYtwKsW/FQFsgzrc6ckxYeYJU+b/8u6v51dgu8XchU1E3eqMAD2kZOKTyk2/K/Faa7mZiMnPjECGN+wR0cWxGp8RlFYbePcTD6BPIYYkKx5LmQTVEcNG1XqlJhf7zfE+wH425HRHz2X8d93v+i9ncWdg6WZcUlyUqw12G2siKWsbTqArJccy8lgIsfuxekr9upFX2U9DJ/KCxPc+SNvrQ/04uhJJgUY7hgbPq778aBeKZNeINJ/Vjn/am8Y6CjhQ6Wffm2iwi/zkAEvPLEIVBuY4dvuUR8AHMcyBrjc0/5RHA5eYjgOcQ4vbviRNUnHjdA6JyQyx1T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(136003)(366004)(396003)(376002)(451199018)(36756003)(86362001)(38100700002)(558084003)(316002)(8676002)(4326008)(66946007)(6916009)(66476007)(66556008)(478600001)(6486002)(54906003)(5660300002)(41300700001)(8936002)(2906002)(7416002)(44832011)(6506007)(6512007)(186003)(6666004)(83380400001)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3pJHPHofVHovbGDX27cNyMkm8RsN2D2jBRgAuubIuG7k33Gb9hmyxJLwU6Bc?=
 =?us-ascii?Q?eDD9dC+ONlhdXQjD0Tap0Aje/3pzOH9kyZ/YOjD/jOhj32p5I8tnnkDOG8KU?=
 =?us-ascii?Q?uTKE9W0VXbAKWWD8kxftmwpfGEseowhRnR+WykshMvvhCs/3OanNiMS1Kmih?=
 =?us-ascii?Q?/I4sdiHPq3+8ffGre1Aze3LkhyOSyRLpCeHuhFIilciCEUVngYZG2rAdpmHZ?=
 =?us-ascii?Q?W/XH0w4TwooAW03inZDLMEtOF/NCYyGzzn1ejco/ZrykV+tb2qVpy8qaI9bn?=
 =?us-ascii?Q?luT1Pxf1xgoTGbQB7xOOl4bK5WgBm3LLub8cWe6jsOiT+pvKCCZ/uCDqUSlU?=
 =?us-ascii?Q?sckhnhQpQOe6Nxhb0VHE1ENEF+mmT2a5d+5c/ddIMvKmHKBEPRM7Fxk4XPCm?=
 =?us-ascii?Q?oCnmM88MfjKUGQlCMFmaLHrde0vMuYvhbW0USWIn02EqZpAn1VWRTyFaLHAL?=
 =?us-ascii?Q?vppsnYr+2hEkehAED3VJWXiaYZfcF+nYIqYRM/DS7QLBXI9sIwQI5mEfWsbr?=
 =?us-ascii?Q?ls/160qcyYKoLLMD52LN7MU344PdY3P5n2UhI7y09UzPxiuxbheZeS5YcSzW?=
 =?us-ascii?Q?bcmQ4BEFBxWBsHJePgAwMl6GRFowOL+F2IQZhcfn3WFt2GuqExbUY7oTuoeN?=
 =?us-ascii?Q?WfZpiuCH3oIAvQUwk3Vk3p6W8F/SurCF8STT4z87zwCnnauaeiNrIy68Xoiu?=
 =?us-ascii?Q?UQgTohmPEUmUpg/OwQH+JR9AqPl2myYR4wDdG4Zq8EBDgldWNxnZEiYkhVY8?=
 =?us-ascii?Q?32UpYbhD7qAeEy4U1o7x3wzLJMXH9ExvmMqbtlJAhzO9VVhjyQKXR6yztDQr?=
 =?us-ascii?Q?+n72dKANiZplNmOxEYcVdrcgUnSCkzGFSezPvLYB9RDLT3vneo/ywq3+VXc2?=
 =?us-ascii?Q?OJ1S/8JbqNEGua57IMneSAfxP7DVj4pHGjvWIiN0A2KUjXFur2j8O9cV+jg7?=
 =?us-ascii?Q?AS6KwZwrE9JY+VYvgzM/6zg0XfVQcyiEzO/tzogfN87V9fKcUZT8T9aCYqzO?=
 =?us-ascii?Q?5d3MT4mvw5lAJuXmfCKZ1xFUcZDSlVgykAUqYQ6lAEjuHQysLPqw7wrkRimI?=
 =?us-ascii?Q?CCoolZscrC6/tI37YIcidzsmrms5Zbijjxx732tVyAPAIcnSXl71MH3EMp0T?=
 =?us-ascii?Q?pb4hV0BdCdqnFMconXpF427f40yHymbJ/i84TYLzhfrVOCAO5UorLnI6hUBy?=
 =?us-ascii?Q?qSGhpL/Hxc9I5Vm6cMBXR+IaKvrqQGpIcWUVwbNAUzRlzSjKPWX1EV+57okI?=
 =?us-ascii?Q?e1FvsKl1VXD8xB12qmIX5aiRAFoidVtv1Mb0S9U4X0JzV7+DTem4htYX9Tzg?=
 =?us-ascii?Q?mL7quPHtJy2+ScoUxR8FxHtgDd1Ket1uT4vuFqvzkZ2kPhQ68lWIuVAFZxXN?=
 =?us-ascii?Q?RgRzSw9DrSmknkTXOZu3KRN6tSYr2puZXJya2gbshIhsA0ZC19aSmo77msMr?=
 =?us-ascii?Q?5HBtzZCrIx9IWWlFrvX+4YsvERyOE6P9DNjkWZ73nsDdEsberTg8zDrNw9Od?=
 =?us-ascii?Q?2fmwCMzwiO+Y00y+dJMsaUv2xcYhbZedinMnJ2TLirruLZw7rER+kmbjlxr3?=
 =?us-ascii?Q?6WevVpuX+tTLe07BGJLQlfHM6vndWcCTMhzYIE80V0Y7ouXFwOkZeoq8Bl/Q?=
 =?us-ascii?Q?4Ba8fEs7HfqUIrqk3/WJTDFaqgYU1htV2LB3Sj2mYx3euEKGzMUQqyVjXbsY?=
 =?us-ascii?Q?7ST3Sg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0fc14b8-e3fa-4ead-f801-08db084c8ea6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:15:10.8307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smJ4c53BayyNiYpJfjV9Xo3Y2WU2XrQznp7gudHH36ARsOG5/zjGbbKWmoUWgOjiowvu27DChExIXIw6Mmw1NawFzGcPi6Z5bBTC4YOPwHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4704
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 04:18:32PM +0300, Dan Carpenter wrote:
> The > needs be >= to prevent an out of bounds access.
> 
> Fixes: de5ca4c3852f ("net: sched: sch: Bounds check priority")
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
