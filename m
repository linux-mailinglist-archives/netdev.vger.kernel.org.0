Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F0A6DC6DD
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDJMr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDJMr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:47:57 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3D24C0A;
        Mon, 10 Apr 2023 05:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2iyzoCbSKbb+QErxFejrBGR00CyLZmPD+enX/ahcx14JF5xSo7AKmJ/5KU74UWaJf4E2F+gvC8YqV6yGbrd/YwT+02YLPCP+wc0qfahKCcwYOHzzk747vroH6bgR3EVlRUXncw3YZt/NYTWzzzgWcveV7BFztnXT+Pd1pr8OS91r2+8UwxQ3WBQ2c+nc9yEXNil5rgm6v5b8H3P7RBOYHIj07Wvpn8Bpk8PIzx/aNQmlBbX8bXMpxKa62k2Wse/97blgqhttgYd2YLT3sHSLswWBigFQzyCzIwyvSnQTgYvyvoBObI09yvlL10ImqjJBmq57BUcy5x98arMp2PgKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ix9VkuqKn8pW/NhquYHyVn4zlZSlLBcYdoM/BHx//c=;
 b=hNOCoiyOrM0eZOk/Bcz6bBLm00GtZFNvKjV5nysh1d/WbyUehw39WQ3UIYusfMeVs5cZxJFQitbJFEiESSHIwuEMwi/+pp8giSsPeBgFcNMlmrPx31FKw3jcTOeTOVL2frdG0C8HGV98mCC/h3PvG8yrPMnki/HRT+Hj3AJu66gX26W6ZDfpE42ijXy3pf9ntbL86yOlT4/yTo4G0fEgJU7RVYhKNk3sp6ZM9zDls5V2WlHrtva7qz5zx7B1Q/p8BTSs/2//8jxzBMc++NNLLj63XajnEV+lu5KC2eo1WlGmeIgSYXxMeXFYq2q2ftgW6jtn9I5suuD0gyVOCLNOjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ix9VkuqKn8pW/NhquYHyVn4zlZSlLBcYdoM/BHx//c=;
 b=Uq4kaMBAp5TZtb0jQbzLEAgYDE9EU+MYSSj4Y4b94lcM23WKDvydM0lzBMTWVkyr4yMXmOuFmieA9yF2fHs0ADFXOmMqQJbjmtTEpR9ZKnU3FMtLty8nJk+O0k0X7Dg3cKif0r7WQ/5NZpQGBICgSGJBjPuonwPPnpXq9UmMOfs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5314.namprd13.prod.outlook.com (2603:10b6:510:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Mon, 10 Apr
 2023 12:47:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 12:47:52 +0000
Date:   Mon, 10 Apr 2023 14:47:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 09/14] sfc: implement device status related
 vdpa config operations
Message-ID: <ZDQFcAUdQr+5NRYY@corigine.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230407081021.30952-10-gautam.dawar@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407081021.30952-10-gautam.dawar@amd.com>
X-ClientProxiedBy: AM0PR03CA0020.eurprd03.prod.outlook.com
 (2603:10a6:208:14::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5314:EE_
X-MS-Office365-Filtering-Correlation-Id: 4748df9f-afec-4929-2e56-08db39c1cc47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKlCc3HinpvkxRNGq4JniUCOnOVIZa4k7PTa8FTnYblMNClaqZkKEHmNSeu9HSpuHQNicuVdhr6wVsvHI38NRaYiCJlfglCVvgil/VojqKWYLpmq5Ty4r/PW8dkMFG8U42z8ifN6qRu4b4m7hXsQJU3DoJfaYTkdCOrO7etHNrC+iy3tzVkkHMnfQAPnMXSmkwfoNb9zKLGXA2GcYROvc76CDr7YGDkd0CWllRpirrTAbaPBIoyDaDt7+mwhYrX7HVAznIGaxFJJwaoRjnpWEtcrs2qAmpfZxaQ6UlT7z0nnbqOoAXn6p5BgGsBKGGZBxSgdhKWbyr9EhKgqKalTsHVkqO5Ru26B7sP/K2e1T2XYTpmwmiZww6BOUk4IqrGoltyovh7am2eLJ1WPXTlrgBfXrz8Hy7rcMYDPPlbvgEVtpdmha4i/DgmIOEb1vg+T+GgiX/aJPvDjV6b35gLvOr8IwplqHks5Aoik9rQb7Kv3qBJRHAEpoc6nAvvjeJQenTeP60xhPwYpnYcF0nbtemfMdG5CI0XCUoxi52G2wbxkRub5W2p11FgvYvhSa+MhDPsVZfVMz4mRoxglNZEktET9YctnZbaWZC0LGuFqvHn4osRL0wg7w/Ip39Ek2RQQ9TPVmrxYVcQGdYHVehWGh66i0zTG96LD9W8BHtwpIHM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(396003)(346002)(136003)(366004)(451199021)(38100700002)(2906002)(6916009)(4744005)(7416002)(44832011)(5660300002)(4326008)(66946007)(8936002)(41300700001)(86362001)(66476007)(66556008)(8676002)(36756003)(2616005)(6486002)(83380400001)(6512007)(6506007)(186003)(6666004)(54906003)(316002)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6oWgC3ySf4cpwq742OyzNOmES4mkhT8YuMxZM8V0aT9PkL1SUvXjUUaGcjDR?=
 =?us-ascii?Q?NLQu4K19/vDrNohWOS9KCNaVsZOenb2gg6OXugjZGsytkDadaKmNKMQiejck?=
 =?us-ascii?Q?fzqGJM+7VESA5FskWNcgD69Q0/RHho6S/iqKoIFl+/7IFRd2juLy3lKmMWYG?=
 =?us-ascii?Q?lXqX5I+0VmefbzPFpw/g/OSTh1cJFGsxA2pQOfWgdPYX/VP/50+IiAtGcJmH?=
 =?us-ascii?Q?JIqP7NAdsBsP0zkR8FOHlaP9NnxqSLJMtu2HIWzU4CmuzPMR+xS6dQh+6I6Z?=
 =?us-ascii?Q?Mmh0GVBt6WgaZ1yQtv/SmqE5U9BBX5vLXrtiWmnSC59CHl1bj0SsN0PeJmgk?=
 =?us-ascii?Q?lNJrOOrlqn6Wdv4FDE4dBqtK6WKBnQclSCHpuGLomzgtibI1THvRPo7OzOh+?=
 =?us-ascii?Q?VNj5SL8FRlzaPi6ITdl7i6c146CWggmcbj7wmlCtt59K5uB/UpDv8UZpfPNa?=
 =?us-ascii?Q?E8K5ebXVvZCHgpg4LieTR4sCWgQTI/LImB0N8id2HnYMcfbQcSqWsaiSyZzz?=
 =?us-ascii?Q?2KGZdRxUb4LPvs/k6jM3USk95R5xDGJEwF0+CH3eF6r74K0OQ0bEoblRMk90?=
 =?us-ascii?Q?dUJGhPf9hV+IDIZIzJsZhC4U/YzjVYQ/xGl+eoOblgCYS1lQFDZZlVvnm1hD?=
 =?us-ascii?Q?OKdkrJar3ulV3wj28hBdbYpLVHSW4TzI6vKnGPdSwT7Emkn8Oll3jMzBfF8I?=
 =?us-ascii?Q?0o5ts/aOUQSlip3JyRFmx02ecVnTDKOl3QtpKXiXWpstX3MMuV1aDqEjYSeT?=
 =?us-ascii?Q?hz/iCliR1NggA4ckaCza03yWOtftpTdbj3r/TatjLP72MQz6KkVFaOXjQJQg?=
 =?us-ascii?Q?V+SToK0sL9nSbe2MuFz7gDMdS9BudDFXqdMcN6mfSLweeqG+B4Fssnw4SxOK?=
 =?us-ascii?Q?W7Y6wZhAMQtn8MBuzUfAUHZpKVeS4lzSJRBm/sl80OGHDA1kkrVuVPU+k7Md?=
 =?us-ascii?Q?hBFKSS2WmcJciuUqEtgmTNSD97v4+Osh/68nXC+t4DrqmRkOwwU9Z9mqu3JX?=
 =?us-ascii?Q?xIEEQx9xUac0bt6B0bmyZUFx5KdBGjPf6BUY79l+js/PJunub0ILX/TDFCZj?=
 =?us-ascii?Q?Ku2iMVI+LBQKbZitWeCWSL0doYV+bCivG4k6IlUQC8vRNR+30hgTYHBv9wrH?=
 =?us-ascii?Q?JsxUb7ZP5dCxbtD743jwyj0MuE8wlleJ2RR2mTfdBU11AMh5jL3zVbaRWSYP?=
 =?us-ascii?Q?nyFErjptlqdV9FTGIOPWkt/yrLuavqajec8QPAdk1m0LyU6sR7i3euyK1MN6?=
 =?us-ascii?Q?VY08cyWd7QlUA46ijNKp9s3WYiL3053edhYVYtUg0UW0yvVBp8Js/EhoMuH7?=
 =?us-ascii?Q?d6LKIOMoGu2rMHEDNe2hgibt1mmWSfj1NKOZ2x0xHChXSRzLxM4mFG334UQc?=
 =?us-ascii?Q?rJB/Wv0Lx0hJUwpmpuznCiDqkovEKi7ZF5fQh+g28meVctnms6MKB1mOv6Pf?=
 =?us-ascii?Q?K3NfocjAmykrcCGDAli8a9IbAvkVac3aXy/hZ8pHDQd3G69GrczDtf4wl79G?=
 =?us-ascii?Q?drD9FbtLgkkeKQq4VSzKXKrUymy9tLNNNfHl3xGlABrNL8U/Dm05lxyhrOnh?=
 =?us-ascii?Q?JqtvuZ+muDRLrUjcetJiLZcEoGBpAf88uA2wwXc1P7ro2HLnTPiYAl6IEInT?=
 =?us-ascii?Q?lVdf/oqIm8BA/PoDsv3ZsoCN/EkZnDLLkN4BR1aKD5jXOxbMSrhnGeMcpYRl?=
 =?us-ascii?Q?q1V0vA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4748df9f-afec-4929-2e56-08db39c1cc47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 12:47:52.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBpF1UDlFaSFG9VMUMF5AmB+JOiWFu4Qq03eNh1znIIyyILt2pgZntv13r+zJ5yqJkMSb6ToTmdKwJmISKGZ/ZOYDRqxd0pzxBlu0B8ONh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5314
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 01:40:10PM +0530, Gautam Dawar wrote:
> vDPA config opertions to handle get/set device status and device

nit: s/opertions/operations/

> reset have been implemented. Also .suspend config operation is
> implemented to support Live Migration.
> 
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
