Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F2E6BB8A2
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjCOPx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjCOPxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43927BA2A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:53:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGimniGVv/P5vOQsRd75FaInBnyeTSuFFUmx8QDuyUq/hUzxkHBBleifzUQzN69hzClOgUnT6UloZSaLXtsaKW2EDZEFoHOE9k/FHF+mElrh3W0Dygk/Hk2bspPCQ3grFc2Z0+IPTf9B+5M6t9inO5YSXOplvNeuMnHS+xTWOQafs+kypvgpv8/gqqDqnOje6QdbrOLIyA/+Re641/QwIpk5KsX5KTZALshEuAb+3YFJtHteVGvcbfgp1VpKb2N7QABkVPGDg7chpu+1PwcrFXKfMQU6NMe1lutINHSzbcFMRvT4l7T92j0azaO3UmzxMgxv0o0PRAB4aHHSodYXDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nV+lZ6o2I8KZGFL7Axkl8PoIGr3w/CHZvcGkANiUjjM=;
 b=X7QCc8RlxYkWQCf15fzVh6D4YA8M8WfoImcFldXHm9bhARBMbCARtsgXRrxi60VFO01sTx87AJ3JMQB7ZwCar1t3yCrq08m7kmZNz3UqLBeQ85DwVPX2CvOVNqfZW+Agihg2eB0BFV5vQfpnV8OP9fW+ZBtGtqmqu0u3MZgEzXjYHHk8AKAWfbJ012Q32g5fU23GKu7mDYXUaLCFN8R/VfpFjjGO1FVOs26wQweZEKlBIF/hm+MhrPkdadx5+oQ+UUcZwMdzmlOydX3Duv6IfSAMR65ktVP0f7xQXlANhIVE9xBxj7yWQp7iOFRGgp1ImyE+mfvXcEDOu8GM50hdiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nV+lZ6o2I8KZGFL7Axkl8PoIGr3w/CHZvcGkANiUjjM=;
 b=KuEhbK5JueDpPZFpnVBC87l3ATP0Mk5ukPDDFW4lcmGRC/FQax00g97rNWp7h5ZXMlIhOwS2gMgGszP7CwAWzKdFqqwQeDHwxWSOl5DSbUqt+ENGcRzrf6zKGeXLE5w+orJ0HSxnbWMzrd16Y4RuIsWMsNJR7WHXOoLvUg34HGw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5768.namprd13.prod.outlook.com (2603:10b6:303:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 15:53:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 15:53:06 +0000
Date:   Wed, 15 Mar 2023 16:53:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 3/4] net/sched: act_pedit: remove extra check
 for key type
Message-ID: <ZBHp3GQa70jbVYvx@corigine.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
 <20230314202448.603841-4-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314202448.603841-4-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: bcd21bc9-b6dc-4b04-d403-08db256d5e3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGRs9YRh9+Ywp3nvlaMdK+Wm3aooBE1anuEHIDbMkjZDAUQDMVY/LJd79M8Md7pSxoSCNOuuYgdBKVU/iqT8IpALWGd2sCPBAJg7LBTjH2oicBp25tkMoE+dBwMOKgueGozgBiD6tsphOQPTjMFMLTrsx7HM/Icaxd+IyOudPalwhNE6q5MVMhFlMhdX2UiIX5aYEiAgpYMmkk15mD54Bf+GszhFsYwFD2ZQJ8Rz2IerI12BRSuzRS1f1a01gv8Gw4Ly8Vy4SGICSqOiYgE6J/0l0w4yUE70gyRgK3hW40WhSs0skXvPBMBamKu3IjQspOIOtg+hcznExJLxltIq9mUpMnEACAfuXzLkqyQPfyhh+ZXtiQADz7iPEdwWe4iQJEvUY920Xz1zd93+G13a32IEUqCxLUc/1IORp7Prq/bWY/0TtqxjSDHf7EdiOifDsQSO31zUueB7aG+zSedEjqW63DXOH01QuGsh7dOkI5mU0FBs5jHwdfuQdFXe6loFHkK35Gab3scXraLG974mxGAdyWgCm9vvLbZ6+/xNKGtI4VezFGfF/usQUBOsRedF60j6OMoJA7ZyRaxk2uWP2d0DoulUQTKQUVGgN7yoe4iQFYsTy5pTtRHrCeHdt5LClCcz+c8aFwRhlbfrcb62qQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(396003)(366004)(136003)(376002)(451199018)(86362001)(66556008)(36756003)(8936002)(5660300002)(44832011)(2906002)(41300700001)(478600001)(4744005)(8676002)(316002)(6916009)(66476007)(66946007)(83380400001)(38100700002)(6512007)(6666004)(6506007)(2616005)(4326008)(6486002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Ta4jlB2SRi1qo0/zxOes+8mdZINgWWsM647USPvoeO3JkGOy5BXN6+YX16y?=
 =?us-ascii?Q?iNYjBleMjViHNBwrak28gK9IBh5/HycjDef6PXInkPnvp808NcyIA8pXaeMz?=
 =?us-ascii?Q?5jEPJLAmL/Ew14ROYAqP4hz8vuj5g4EhgGJRr8rF7WL3q91gOBMseUkVq8La?=
 =?us-ascii?Q?FpnqrPmqi9p+f5Ifmnuw4RobgmRSxAeG/OfippiIDdhBw0ww4s/ZJNDDUIcd?=
 =?us-ascii?Q?Q+vv8cRp9831hMSmMHxF66KpyS31yWnvn4ALVHGcWCROUxYpX8sy438a+hxn?=
 =?us-ascii?Q?UI/2wGXNP9AHle4enwfYPwLP4fY1Rhaf9dix9annanjJJGPxte86Nrr/EGil?=
 =?us-ascii?Q?/brVMFJZvCkr9IhGzjgJiN+5CC3CGWe75AdwDH3NtNH5l38opkNRDK3ORBx+?=
 =?us-ascii?Q?HGF65z9ZFhK19MQ8cH/J7XB0+lScibF8VEkoUqnaUhECH7zKYRfPYJ8GQ/NN?=
 =?us-ascii?Q?nGyhlYMwIQrYXSXIDS2BWEzbjPRmxTCEUtpikgKuAXprmh116Wu/b/rdh6qo?=
 =?us-ascii?Q?SVswFYCEFg1Z0O4nyCzvq6p847AdQBntT7oGoBeAzspM3MY29xvKmuN9Swg/?=
 =?us-ascii?Q?4NQ5J44CF+i2xdXFu50WS2XkLLHgSzGjvBSREa7v6J1WqjNJDQW+YuieAtVp?=
 =?us-ascii?Q?0sDHZ+4ZYOVEa7B+rCxi3nxD2WeXiENDEbj/4XFw1vBujMgZQfsWIGhWuOMl?=
 =?us-ascii?Q?sSzF2dVJYPeelA0Oklo9E/UdWNDFuUY09S7QpWXKojDBctatBCyFCXAhSGTH?=
 =?us-ascii?Q?AySK4d5AZfj4wifLUgRYICp0MzryV4AGoauurZlSP+cE/mvO1g1Gqj+nM5kW?=
 =?us-ascii?Q?Ax6OUzVO9+cGoOw5BtHhS10NDnOdFlcbYXzaI6MBIVC3Ad5RR0U8ky7l6Gv5?=
 =?us-ascii?Q?vePdIi1yi2bs+arHIy5HLIDx/ElPL8WcUNQfVHK7cBagC976jPYHwp1rpcKl?=
 =?us-ascii?Q?09p5yi4J6GRpEvh4fg6u6NOueMI+7LrAiNTNdi7E8Fo9d/MruR26zglhO8SH?=
 =?us-ascii?Q?ThTZK8dUpRiz1XnvGLsARNcq55uh06kmignjHmnVVVTNNAe/BoqhyNguNvZ5?=
 =?us-ascii?Q?61DZ/rDmOncZutGcUQAcA0P4qrhvmNO5B0wYMqPzpJOXc1BZNS0U3CNPTEWx?=
 =?us-ascii?Q?u0hBqVj1MCpQmJAUStEfE5H3zwgF9qtc5+p1u58vGYZjWuTK27O8Nl2n6FH1?=
 =?us-ascii?Q?ngMR0CYpWKO5ORouknB5ByHuX4IZ6g0KdiYbOYTGQHDSwef5ApJJ+enp1Uuq?=
 =?us-ascii?Q?5dLQYOntRDqg3uHxZDwUyHe2yM6vrxmEbSSYCCzcr3vM5QIHFdMHJe9YOCH4?=
 =?us-ascii?Q?bMG8T2daxnLM3y0iV+vVrP1utxHMNearpJJjKL7JmlKvZQzTUimJDdWjzx0b?=
 =?us-ascii?Q?vpohxmPuqfIDqBqs8d3SjXxD4GE3NTioYykLWvuKTthcuk7GcUjLdO8FZsPJ?=
 =?us-ascii?Q?WXgsfrgBP7VYhTSN9JysG/7NSXAmjL4EgkvvFf3/jY0359EI5YwNIqBmetBe?=
 =?us-ascii?Q?Kau7ezD1E/+gZDQzRmENhnDLOyarCvTe66REJUz98WM+0x//ykmcZCZ+IDhP?=
 =?us-ascii?Q?yAoMJe+3N2hDOKTACvMIeR5OgPPjDsTJY5LCXjmVCCWM/ZNajn0oUE8AOSqT?=
 =?us-ascii?Q?B0oMVsE/Wnuo8xU9BWHKeVRu7gye9w9GBhP/JiX3gKkTJgg9CvFlJnpI81eN?=
 =?us-ascii?Q?pAOy5g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd21bc9-b6dc-4b04-d403-08db256d5e3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 15:53:06.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHnLtYZE6aIGU1Qff0hbesKJbO0vB3Aj+cfP22g5FKVryPBnLiLxaQTRojCoMfVf4xaA3Jq9Wrrz8tZ8TVmf+pefeDZcGV+WOijOqJ2fEyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5768
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:24:47PM -0300, Pedro Tammela wrote:
> The netlink parsing already validates the key 'htype'.
> Remove the datapath check as it's redundant.
> 
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

