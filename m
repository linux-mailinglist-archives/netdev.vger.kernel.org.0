Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A320673448
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjASJW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjASJWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:22:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6E56EAE;
        Thu, 19 Jan 2023 01:22:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpLT0lsd+XZG+wQI6YVX4jHAJuo+z18X6YJ95MeT3KmEIBIeCQgMygmiQgGs3RC7DywZ9+/7do58OhMqswvivXtk6TVmuqbsIShGFC8Qnz07l1QSb2wDeZ3+nmmrDhrtJvaV+3OSQmMa92Pv2pY45auGO/AzQMs49yBN7xsg1NW085pr6pOEUEEQGwleIlmzvp5AQgDEUNQ47jzWNVHBKzx3pHtt9e8B+SNKa0+UEJ/VZM/Dgkr4n/jVliR1MFXyfaibuCdabneySoQ4YG4Vv7k7NYwGwhaRbPuvN11INq8yVwspqJKXxgBD79EC4F4PpSUSXDcOgcCBX6wBW9WRbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZH2g4EGj0pSke2PXJN/Pa28HsZertV4fcib9qfp9e/E=;
 b=fanktw3qmQ4CxxFEkfZaG7MaiUR+TD5Fnpr0Fo92fNH/p+OuOoFGBnfy5paZfbBjOXKjHFMXgoWZqXnw7cvne6I1BgtUlrxOCMYCT0ZaMkiYhAmWAowY+V9JNbNaScM/aoEgNwc4auSNbuScowWThnAy/Add+TOg3vZBnjb0Bz18Xbh/C+mVicnck/ZdZ/Gdz8FIbd0qYxa30Fzje87lpnXpWSJTLPEi9Zafc+oRg+U3L8ZfWBltEhV+vn24eoXSSCeCXzPCCBOxo1NpuS9+hZP3slY+z3ViH13AMSp//vcbjZ3IOsHhyo+QJm39HfrTia2RC8XqbIBDkyur965PUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZH2g4EGj0pSke2PXJN/Pa28HsZertV4fcib9qfp9e/E=;
 b=Y7v3ZG6/uvEkfXty4GXHPyC2Q8EoH5J9+WtZUzIEzSIn9SMLjaOqlyolV+NTnIh4ipX/SpdkCjdBozgusJBkuEnAgNZ7ShRGkDHr04uF3OQjbu9lfgAIIU4gplaTtXEtwBZidTFH1vlgw5s2w3BdBhgar5ksGX+yA/L3jD8hKauD8xFEs9NaYb6uWsTOMDkW+3InPpZeODxNdxSVGTwqIV8HiVj8/oEPN3pvCIbkrnmnxLU5SfglaRO47BbaUeKDWOvUEzLfT+7VsKwVGcKRUrcG9j4JLMG9MsGLpwdTFDWJvAiVJp+nslHiCnhibld5iVpxGQWmnRrzYwfR1sF+7g==
Received: from BN7PR02CA0017.namprd02.prod.outlook.com (2603:10b6:408:20::30)
 by SJ2PR12MB8064.namprd12.prod.outlook.com (2603:10b6:a03:4cc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Thu, 19 Jan
 2023 09:22:43 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::8b) by BN7PR02CA0017.outlook.office365.com
 (2603:10b6:408:20::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 09:22:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 09:22:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:22:27 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 01:22:21 -0800
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
 <20230118210830.2287069-4-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/6] net: dcb: add new rewrite table
Date:   Thu, 19 Jan 2023 09:59:37 +0100
In-Reply-To: <20230118210830.2287069-4-daniel.machon@microchip.com>
Message-ID: <87a62e98vp.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|SJ2PR12MB8064:EE_
X-MS-Office365-Filtering-Correlation-Id: ccb5e57c-04c9-4005-379b-08daf9feb750
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMqXjy36RKc06ndFRaGlLQsBW/cTkJtfTAiXqHX7EUq+CscwGD9rMvCgp+xRm6q0RhQbprWezv2I095RYdQBdgEmmD79eYdPQHB0ksChMP85wmXg9Cv4SMVkwljeF8HGyMsHvHbG9tKpselbLaXUmsoUMWIDp+2AWaRmHuwPp6PWi9pF0kiiRv/mB6R6/V7zUnvDejMssp/MhAxzb27QN6wouQhM3tvJB1dHbA84M00DWcu8zh+2PrNwVMhCRH5H6iJ0hnX3DG544upD9IfeNKsWbU6X/8Ph09Eg3Nq81CEC5BX4AqA7q96DJVPWk9rpl8qwclscm4uqQVoLyHRqCKd3EggtJhnQG7ntEZZwAblNbNv32LlmQsz51FH+1qjEQdnIMDa3DeYYLTN9cY8pcywI7Yy/CKiMoOmzKGBGKeatWfVBcGF6NG0KzJMVeELUH97kOo4j27Z31ioDXps1d2Dqrxj7PnTdl22mi3CdjWHqDJ+iNCUmDnEJq4ZKt+2e7T2Quwosq/MZn11sXbRQA3K3GeOOSOIEFhiaU6+Jp+kZUt2cfdEoS1840wPocWt8Rkx6L2T0iCICvIOZxN5rhRNwqe+9UJsiG5mzXqyJxymnXhskIkwAt1hnN22xnKUt6VrpdwLssE4D7aSyiJaSD39DNyh1jJBgmZOATp3tslOS7MK5y1y5AlqnY+tbxh4Ecihf478+IZu2UAI8vhx3mg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(46966006)(40470700004)(36840700001)(316002)(54906003)(41300700001)(8676002)(83380400001)(6916009)(336012)(4326008)(70206006)(86362001)(70586007)(36756003)(36860700001)(47076005)(356005)(82740400003)(426003)(7636003)(478600001)(40480700001)(2616005)(40460700003)(26005)(82310400005)(186003)(6666004)(16526019)(2906002)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 09:22:41.6812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb5e57c-04c9-4005-379b-08daf9feb750
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8064
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new rewrite table and all the required functions, offload hooks and
> bookkeeping for maintaining it. The rewrite table reuses the app struct,
> and the entire set of app selectors. As such, some bookeeping code can
> be shared between the rewrite- and the APP table.
>
> New functions for getting, setting and deleting entries has been added.
> Apart from operating on the rewrite list, these functions do not emit a
> DCB_APP_EVENT when the list os modified. The new dcb_getrewr does a
> lookup based on selector and priority and returns the protocol, so that
> mappings from priority to protocol, for a given selector and ifindex is
> obtained.
>
> Also, a new nested attribute has been added, that encapsulates one or
> more app structs. This attribute is used to distinguish the two tables.
>
> The dcb_lock used for the APP table is reused for the rewrite table.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
