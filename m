Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7478671B02
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjARLow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjARLn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:43:58 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CAA6E99;
        Wed, 18 Jan 2023 03:03:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N62ReVw23/Pn3ohF6Mc80GMYjT2wbG9AdrrbSNbnTpE/IsWLTwD8uoaXhjYs4b4135YAP3rMnF4KEqTo1E7CTsHVHFTm6poK+xLJns3Je68kyGOWKGe7ypt/lOG5bfVr5Q2wHAyPh3jC1jEKk1ZLw25fCDYTLef1YwD8JONUtxYFlQpE05plXSqlSlKP/W6IPfvpVdGeNSx6w0HBz+IRmB4+3KvUEaa+cIWPVM0tlLO9BPXdPSD9w2TwzrRQZ971AN6d5T9FnUP6mPVtZyOnRgkIiPbmuP8LadMPF8jWC8AHH6pdurF0oCUjTAHqyYN7jh5XlwOtpZ30IQC2z5Z+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6Sz1xr/zN8yTKtBrT3EOlTrS7FDfurlxRFFmdncDPs=;
 b=dtLcD+bkz8tCwMK0Vtp9gs4og/jnGPO9cBDigaJKNggin3JIF9/DWX5hwYmIArEThcE9g7ZDhK4V4zqvBVkN4kCAsT2PUWntDhINY72YICQqvQ3gk7QLhlJnkUEiNrhZ4b07pWvrBDuxTGUeOddfqnUnYGJ2xWH9SJ4lVwcyQum9c6hAqkiCyDONaXryz8B6RKY++CQqHht8475uTrhlcp2j5LOmh4XXUOhnGqSdbddPGaKXYm9oaeywPajduW+CR4IqWA4CA8DRecnqycqwfDCGP4kA7ku0p20LO8LQaD+YgRKfLEGqipuUDc5Fg913D6i3/ttLdj67zdAZZ84q/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6Sz1xr/zN8yTKtBrT3EOlTrS7FDfurlxRFFmdncDPs=;
 b=I1IxgcTT0FZCyYpLJdHz2e4KZpL5XJgcLhLMECic0nZOvQE4R2huM8YRLejOeNJzwGPuqb5KInMoEY/S9nDVo/27SGssYNsfUpygxHAlql6BjbVLha2jeLWB9LcatcTCxD3EODIjxlpbh8tUpQgDH649aKy6rORsTapEA+TPTOsDkHHtbyLP9QCI4uiRHCLOQyEgXcH+3gsSnGAE/QMwpNg8iP1/UzeCpQuge9LIQWleIloDAyXmfrP+/gcbBpc9vX8XJ8bwUX/ZvXiQ3FRTKgif5h0JImXY26XqX7dNaNKo6Uh45W6b4hKixwjZk/hXO6edRwqKR3GM/5CvP7zzYQ==
Received: from BN0PR02CA0040.namprd02.prod.outlook.com (2603:10b6:408:e5::15)
 by SJ2PR12MB8035.namprd12.prod.outlook.com (2603:10b6:a03:4c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 11:03:13 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::55) by BN0PR02CA0040.outlook.office365.com
 (2603:10b6:408:e5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 11:03:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 18 Jan 2023 11:03:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:03:02 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:02:57 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-2-daniel.machon@microchip.com>
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
Subject: Re: [PATCH net-next v2 1/6] net: dcb: modify dcb_app_add to take
 list_head ptr as parameter
Date:   Wed, 18 Jan 2023 12:02:39 +0100
In-Reply-To: <20230116144853.2446315-2-daniel.machon@microchip.com>
Message-ID: <878ri0w1ep.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT003:EE_|SJ2PR12MB8035:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f3b5cbf-276e-4e87-2a34-08daf94397b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UN34sjZrVzTP5lEJqvRO54VQp0O5V2UCN71s4+B7IZNRhq6tcN7y7zR8l2Pqx1WN2birNvH1WB/+pHnGJg+LW/AHMXjDpNrHqvXk/hbCV10JsmfjIopWZoQQQvOCiW//G75M4OSu6jNKsi+9pSywuz1NbG+rlJ6YjhV8ZDL2mZjBDAXJgcLemAlxM2vNcxPl9vDcpN0Rt7bR46xoBrJq/tuD+alKXgn29vmNTQ8xgGWP2K8gWRcCVwjLFw56FqSa43AdVAvB6j6fF97KIAh0jBG+9YfHXdE+YGq0ysD1kpGuRiJU0sUb6WQ1KQmsbzkyd4rc+P4Qjy+5e61rqGkc8iqNloBVSdxT7IVkOGOGKG1QRY1Bo8ZEOnzQj0kwGRT8DWNnLWS39TQrLh//ODf9yMthQbo/DW8tAP9TbpFn6fvEehBY1bWOZ24AZO674pr0I9NBQQsW7Dx6wHMBfmBB6Bs/LkPEEUZTnLZOUuJqWLcki1GOwRew1bLtEskLBDQ7xJbhZwuOgGvI6ceC39aCnaWFJ2KMiYqbCM74eO37kRIJeTnQzUMHyuRGco74vh8UowO09j96as+vCGt4ZsH93T47vM0mQVMaBQyC6ZvhYtRYjoJCRtrnbV1mBoIWsiERJDSQIU9AwCGT6/gxIldQ0mIHCxWf3X8OFXdBjXgBxUgJTY6ry3ttCcIOZcc2XKsq0Y2Eko86laci7a9BndBWMw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(36860700001)(36756003)(6666004)(7416002)(2906002)(82310400005)(70206006)(5660300002)(8676002)(8936002)(4744005)(16526019)(6916009)(4326008)(47076005)(82740400003)(26005)(356005)(41300700001)(426003)(478600001)(7636003)(70586007)(40460700003)(336012)(40480700001)(86362001)(186003)(2616005)(54906003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:03:12.7869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3b5cbf-276e-4e87-2a34-08daf94397b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8035
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

> In preparation to DCB rewrite. Modify dcb_app_add to take new struct
> list_head * as parameter, to make the used list configurable. This is
> done to allow reusing the function for adding rewrite entries to the
> rewrite table, which is introduced in a later patch.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
