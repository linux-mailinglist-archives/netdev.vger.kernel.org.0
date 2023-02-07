Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DF668D33F
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 10:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBGJvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 04:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBGJvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 04:51:08 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E692E814
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 01:51:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8M3OiSMwEPpZFsOCt84BaoVNyOeTPELw66+WEbFDHQJi7AVVI9QeMeR7BXteLZRbsjsBzyqUEtPEaDwwyL9hnt2pfIaHJfFEBf69GRPqzFjzE5CQ5DgdXA2/+6GiMyndExsLuG3FRssNO/PeDKJ5o6yt/d3ZJ/R6brw0ti00SNJNT1Don4gzWBO041Mr4x3UjTF+e/ridonxrQEApmH4T4cU93/2Mi/FWlIFFxuYYND3H6sfGthaYOSMhCwTXoB2EGrPzJR5+TNUnR+5/BdTZWiILAQ5IqAy++6ojiEElSiO7xhUxhnkOozta7weETcdEduFy1n5gmwy4nEsAC4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvmJscHgU3wgywTmjWrp8SJ8U8Zb9Yzx6EjkQoEu+No=;
 b=beVQQseM5In0BCVviO9MHsC1J74SjpFyEuxhx+5vOlHsvLjN2NTFimZZbAXFIT3MPUF/vkIm9I/QQKcM51MXaYebj8I56v3C6KSvgBSy1aKnRXiTa3iuWJ95vOWCd7FXNTLQ7B0+q/2a/piriu3kjK0Uq4qF66meANydH3yqSb0l9F4p5zcDdwNUa1j+3wxu6VXpbVSyWsxnCrUnObIa6cK+Ctuo4a/eRIK9Wbdy0m/Ggb1hK3stxC7TCGUXLVZtODK/oZ4LFDQDnhRuQADwyE9yQTrn/Z+ZrNw4fz+ezagLIgJJKQ4Cf7W9YSoDBtsDLcO4bPmRaPhPdEy85kpM/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvmJscHgU3wgywTmjWrp8SJ8U8Zb9Yzx6EjkQoEu+No=;
 b=btZBv3np4StjNGxvDJYrNNqMwkwsbhU9/1BXRxwfUyChYV9SRzL617RMNfgfq0vuaI38lDSxucxjg6iPBEWwyy4jEPvplqtZepNLZ1TANjkwCssgsIiXqTwIXWPXv33H0w7yST9mKn8QPvc42DzJr8idSMBNlumOdz+43+5Nn+z5EXzGZ/tbIOevpqUFAdT3WPBN+m+Az320IaArIL3XdJ5HCvVF6oxUX+LDGsNte2VcU5zUVY5Cp230+TGgE37y1HSDJH98J8q8HK11+mZ+opwKpW/lsuzob7i2oBLEOMTW8fFxWJhgvH0VGPKEFMHz1dc2K0f8PRj3ldt7sz6i1w==
Received: from MW4PR03CA0099.namprd03.prod.outlook.com (2603:10b6:303:b7::14)
 by BY5PR12MB4259.namprd12.prod.outlook.com (2603:10b6:a03:202::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 09:51:00 +0000
Received: from CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::1e) by MW4PR03CA0099.outlook.office365.com
 (2603:10b6:303:b7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36 via Frontend
 Transport; Tue, 7 Feb 2023 09:51:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT048.mail.protection.outlook.com (10.13.175.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Tue, 7 Feb 2023 09:50:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 01:50:54 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 01:50:51 -0800
References: <cover.1675705077.git.petrm@nvidia.com>
 <924ecbb716124faa45ffb204b68b679634839293.1675705077.git.petrm@nvidia.com>
 <0b6635f8-1b5a-80ec-8cc8-5b463d963d2c@blackwall.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next 3/3] man: man8: bridge: Describe
 mcast_max_groups
Date:   Tue, 7 Feb 2023 10:49:32 +0100
In-Reply-To: <0b6635f8-1b5a-80ec-8cc8-5b463d963d2c@blackwall.org>
Message-ID: <87sffhdcsm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT048:EE_|BY5PR12MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e2bf766-a20d-4f5c-cade-08db08f0d15e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+/3pqM0fo+LPp0F8etyNEupu0ioAjDDA+by6XmnhH/jTw7eNfGSExplDhph6IW6Bi2XY8Owrd+ZG+xBsD/UDE5e+nOCGtTVLs3KzGzw0b3wNxeBNh6PDu2IzyTBB2PMszMNKHeCFIIjMYdvkkZ2417O+yvJKhvIl6QliPzLnzJBs9jvwZT+pbruTaa7ySNqeAtCNpJKbkWs8juVNKvXGFl4lhJ8fUUTE1HOhDLm4az5s9tUTpRWG02R9Xtr0huNBWSIJ8m2IfqoVzgNfHp3PE6zli/qMCpWabr9etFEQG+Iu6cRxXCX0pQn/BTyE1aXqLftnQEpdBQZFhTZCPxjW9g+GdrWVoISCFjvRszFe9j7qw7BzbWRgZtlpxtjRdOv5PKi/GhM0w2lt0UrUHIYv2Xx93XTN5b7V85zBayWjNiX2ueOIhWDy+Gu8FyzMBY1bLdHL/S0fokPGPQUnM8E+KSgwbWm/AWPr0z3FIRy2nA/icmBkNdcISk11ht6KED2/IHo/geI5djwGmMRDjbOKOGAuSJbVK9kL3Fy8hRfdVitavjglaPJMcqoKNZUvcCBvvU0vB8BjNA2gAMvF/EK4Y8IHcUm6PkcHSDvYFKe2DoTE2Q9umadY2EzzO7fDpxba/5NmgBZw0e0bLuPaFF5YqBTLXL7E3o81OBQZoKL3m0=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199018)(36840700001)(46966006)(36756003)(41300700001)(316002)(54906003)(6666004)(107886003)(478600001)(5660300002)(53546011)(2906002)(6916009)(8936002)(4326008)(70586007)(70206006)(8676002)(36860700001)(26005)(356005)(82740400003)(7636003)(83380400001)(40480700001)(86362001)(426003)(16526019)(66574015)(186003)(2616005)(336012)(47076005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 09:50:59.9787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2bf766-a20d-4f5c-cade-08db08f0d15e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4259
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nikolay Aleksandrov <razor@blackwall.org> writes:

> On 2/6/23 19:50, Petr Machata wrote:
>> Add documentation for per-port and port-port-vlan option mcast_max_groups.
>> Signed-off-by: Petr Machata <petrm@nvidia.com>
>> ---
>>   man/man8/bridge.8 | 22 ++++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
>> index f73e538a3536..7075eab283fa 100644
>> --- a/man/man8/bridge.8
>> +++ b/man/man8/bridge.8
>> @@ -47,6 +47,8 @@ bridge \- show / manipulate bridge addresses and devices
>>   .BR hwmode " { " vepa " | " veb " } ] [ "
>>   .BR bcast_flood " { " on " | " off " } ] [ "
>>   .BR mcast_flood " { " on " | " off " } ] [ "
>> +.BR mcast_max_groups
>> +.IR MAX_GROUPS " ] ["
>>   .BR mcast_router
>>   .IR MULTICAST_ROUTER " ] ["
>>   .BR mcast_to_unicast " { " on " | " off " } ] [ "
>> @@ -169,6 +171,8 @@ bridge \- show / manipulate bridge addresses and devices
>>   .IR VID " [ "
>>   .B state
>>   .IR STP_STATE " ] [ "
>> +.B mcast_max_groups
>> +.IR MAX_GROUPS " ] [ "
>>   .B mcast_router
>>   .IR MULTICAST_ROUTER " ]"
>>   @@ -517,6 +521,15 @@ By default this flag is on.
>>   Controls whether multicast traffic for which there is no MDB entry will be
>>   flooded towards this given port. By default this flag is on.
>>   +.TP
>> +.BI mcast_max_groups " MAX_GROUPS "
>> +Sets the maximum number of MDB entries that can be registered for a given
>> +port. Attempts to register more MDB entries at the port than this limit
>> +allows will be rejected, whether they are done through netlink (e.g. the
>> +\fBbridge\fR tool), or IGMP or MLD membership reports. Setting a limit to 0
>> +has the effect of disabling the limit. See also the \fBip link\fR option
>> +\fBmcast_hash_max\fR.
>> +
>
> I'd add that the default is 0 (no limit), otherwise looks good to me.

OK.
