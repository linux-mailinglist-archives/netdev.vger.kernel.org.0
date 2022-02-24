Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74F94C3377
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiBXRUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiBXRU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:20:29 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBBB29EBAF
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:19:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=le18Z7ZGYd5y5ymLprsLI1GZZ9lMhl+atunEZ5h3u3t300gUMiwjsjX4VwUPExz0TerRC1zaKrotqBCUH7NrAAqXrIQ5eh6P5XyjD5KWfXMpheZRgxTpQKl/cFtrvwvVXL1rvX/xbFku4YOo/Kl8KQhd8+WWVkhBu2IhKT4WxGJcPFR+9qCwy7LeEeBRuvw9ewipyh0X6F1mp5p7IMVyl7rEKJ5qs+qmmMCNpoXgYqc+URmCDVOdw0jaJGsf8BBtn3LbQ4YCGrqraavXABgbQxuC4QcVJRrPGNYDJz0XeFw/tWKxHCgXN2sXBBkKuzGZF6q1G/tlxAV+L0KqxcC5Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/v11k+lSgURsDXRY3DKAnErK9p2GhCU38pSV5f21Wg=;
 b=PWJWHK147Ni3V6VkldmYm+uBC/vJoHF3rhGnhAtVKhoBHbZ/FJOWQ1Gmf9Gv2s8sx/8SRZGwsrNRRVL3BGu8JqAlMigkhaCpXOXvauPSfjP4jvJ4wJlAQu1E4W0NeFM7qbzt/DbJ0LQ2o9VcaHGfGxbfT1DzoEbqGpIbrAHHsM4cIPSvXJxkyLS1QCzq849V3NOr6kevZwE6FgmPY/hCBAXTRVHw/SJUVHhliE7YR56/No5Mgc3uwwdyrkhkMFa1XqmNrfiA3Jk1B4Q4ArtdKapOzMdpeXoEuOhBGmkyZ5Ixmuhox1J4YOZ9UjgAAOPmr9g7fGsaI3geQpwNF0XtZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/v11k+lSgURsDXRY3DKAnErK9p2GhCU38pSV5f21Wg=;
 b=J5Cm8LksC+JtgLF1jwXhYnXaOyfyJsi2/MZHrZUqymR2sp3KmXjNsT+kzipOeVmAJNAKhK37F9Iti2MuvHk1W7+7zidCT1BV3IgzoS0OdHd4x2CSgl7A4CuJaGxlLICB8r3dhD4TYX8tRm2heqiRgb7py2IzyHt+Bs3UlxgvlzTZ0eJjsKwrZHP3/xXgW/jIyrkTIa/tRSeetUzh3t4uIQT521GJNBFJBEl/HS75g6a6KMWQ87+SoFW7ZK309S8Az/U62XTBsFTmoBFUUSvmt+GOLbCUvvYhWc4eowBu/kJMU7QxzacrQzMy6+SHqtSi0Xo1r+ghdmO3wlUihEsRww==
Received: from DM3PR14CA0133.namprd14.prod.outlook.com (2603:10b6:0:53::17) by
 DM5PR12MB1564.namprd12.prod.outlook.com (2603:10b6:4:f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Thu, 24 Feb 2022 17:19:55 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::bf) by DM3PR14CA0133.outlook.office365.com
 (2603:10b6:0:53::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 17:19:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 17:19:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 17:19:53 +0000
Received: from [10.2.168.79] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 09:19:52 -0800
Subject: Re: [PATCH net-next v2 12/12] drivers: vxlan: vnifilter: add support
 for stats dumping
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
 <20220222025230.2119189-13-roopa@nvidia.com>
 <20220223195628.21b279ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <3f02087e-22f6-f6a5-86c9-4a9a20b6f534@nvidia.com>
Date:   Thu, 24 Feb 2022 09:19:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220223195628.21b279ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46852353-4d3c-4032-9291-08d9f7b9e072
X-MS-TrafficTypeDiagnostic: DM5PR12MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1564A91C78E2A5C0CFAB3AEDCB3D9@DM5PR12MB1564.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/MnqcEdD+9VPi1ggYtieSlWMK6repV4L32ZBD+HBhPPORox8G8Cv34hH2jObMMOPVjtoLOjBiHmlnrmiEUjf+jTMu0fDHtQkVP7sDzhVKFcHdH1QPV4nvftlpmCZUdzYe505PXo2thbQecrZPqcwbz2334wkc4DgSGj9tZY5PJK/1hqF2k9Mt69+LQ7uV6Y1OqixaMegqSt901jSoHWrWqCwaHWpntfNFasX3ocJBFCJxkskzMQFzjwp2HWAbciEuVEYjJzYGKhBjYv+wXA8lCj6s2jV27OjFRCWIAIIqc3Khu+k0Xn4QlfCxoJliNLODqlS1HCJlneoWfxjgjNETcX5YqOCJivlQYBbI+gAGaENTltnYQZ0tLbf1NN0dINZeqNph16TB9OxfOmhIiAaCv8kL1PwU19NEpjFSoQUgMQHpaaM1vR1WsKNuPt+9l1HN6LJz7XYhPB7g8y40pytMVTZqEpYE9S7bMAVOWynF8CPW3uhWf/KBNsXxjVAP5dF+0Pkz0n+4tAtTaJJ4OWhy9shlMlEKrR5TCJxCiPpxJghYwXu15m818gVY8V9uNJNEjG70gYVpcaw/lBYq6v0Rtt09E5tgyWHlyz5hL9zzETA08utBDrjganiTYw71x7Zw+B8ct/JpMDJyr2npVL0cRscI2ertNSsO98rjsbVEQNXxaaoJGSJ5MU6RlkB/sdDGMwWhXhwp6NEdE5sMF8Zncor2tZ2D+ucdiI6uMxGCOhtn5RwTyLhI7kYYKepxTp
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(558084003)(2616005)(16526019)(5660300002)(26005)(426003)(82310400004)(186003)(336012)(8936002)(508600001)(40460700003)(2906002)(86362001)(31696002)(36756003)(4326008)(6916009)(356005)(36860700001)(8676002)(316002)(70206006)(70586007)(81166007)(54906003)(53546011)(107886003)(31686004)(47076005)(16576012)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 17:19:55.5001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46852353-4d3c-4032-9291-08d9f7b9e072
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1564
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/23/22 7:56 PM, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 02:52:30 +0000 Roopa Prabhu wrote:
>> +	dump_stats = !!(tmsg->flags & TUNNEL_MSG_FLAG_STATS);
> Are unknown flags rejected somewhere?

you are right, they are not. Will fix. thanks

