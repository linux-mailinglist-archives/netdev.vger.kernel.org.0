Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D785D67F902
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjA1POz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjA1POy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:14:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6827023856
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:14:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVOHf6prTtSluxq09mX/tmgKHm3d24vt2v6isMSK0zHnYwg84pbfhovWgxjlOiOw9HB4rVsmaSca2Hs5yP1Q61g4fCu/0GY6lRlOr1j4KMALOQOBxMRDJPy9lxoECUEQNZGxjngKqhtlfhOWAQ/sVy9q/vLz5Vwx9LQo1J4otxle0ZHCOYm7evQ/GiTZcbWvOUXRThbI/Z8Kz/dK6AzoXCmvPzlVTWJzOdLNTbK/fmDzNFh5sU7jFklPfyYMRmR4uEzD3JVm7Tt5KMnT/8CxSLt2VOfCo9TlP+kVar1r5ZD9K3F1xempZDJ6F8LgP/UwpxpwhLjMMMeW4d3cyygOtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=763kwId1CCkTXQsBFDK4g7OZbsMMxGbwWnF9q1Pgs5A=;
 b=Ar0ykw2chcdt5HvIOUEEbxLMyr4WJT1Wr7s0wptpsvKecnEH9SI6jqCDmmLzcyN8pgmHEG3SDPSdpjaFqieaZwkAgcV8hhxaxS4Wpt8DF4+tF5888VIv4UB+BiC2bqrDQSc5rZ/I1/cEe6pA4ysu3CBjitb4eaM2gaSINpbxv6HsDc6rFKmM69YVZSPNozNHY67fEeL232FTL4kTl9lu9sEuSJn40PsZ2ndNfQl18AmvLfD7sCHEDYQGicvXVgywOk4ly0sHFPH3zTaOuQZrw1eX4yv5yeAEPElOnSwLS80tB7IvvNW5KX7xq16rMZLiwIf662HSafNT8lu3XWYMkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=763kwId1CCkTXQsBFDK4g7OZbsMMxGbwWnF9q1Pgs5A=;
 b=eVS1s5O9N2lkYqaM3N0xAEpEI5KvGDVEDE2K9+WeTWViMLE1zeoGay74OJq2byXnnnvvn6CEWey1K8tzHM8s+CI7TcdQyKEl2sBrJDRJSOG8Fd1rasBXixPhvmTRSeCGzVa5cjffQcPCMLujPXZL2LxYaRfPe6Il6q5SbZnQqaINALQ6U8uK+EXjsZHPlt9lCefl/JxR7mTIFQgoViWE0dEPk31m7xDH3SmwSJfrheIKRbN+w8dcIHcZ8FrqXVL5u7kgIMxKowl2RnCXCPNYex3gKJfZwGUaadP/10IiKPLbzYg6djyUigXwgccOmZ/a5FMqwdtcPX9sZYcy6k/ygA==
Received: from DM6PR06CA0020.namprd06.prod.outlook.com (2603:10b6:5:120::33)
 by PH7PR12MB5653.namprd12.prod.outlook.com (2603:10b6:510:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sat, 28 Jan
 2023 15:14:49 +0000
Received: from DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::71) by DM6PR06CA0020.outlook.office365.com
 (2603:10b6:5:120::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30 via Frontend
 Transport; Sat, 28 Jan 2023 15:14:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT102.mail.protection.outlook.com (10.13.173.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 28 Jan 2023 15:14:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 07:14:47 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 07:14:44 -0800
References: <20230125153218.7230-1-paulb@nvidia.com>
 <20230128001640.7d7ad66c@kernel.org>
 <20230128001810.08f02b0a@kicinski-fedora-PC1C0HJN>
 <87zga3do7v.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Oz Shlomo" <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net-next v5 0/6] net/sched: cls_api: Support hardware
 miss to tc action
Date:   Sat, 28 Jan 2023 17:12:12 +0200
In-Reply-To: <87zga3do7v.fsf@nvidia.com>
Message-ID: <87v8kqelni.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT102:EE_|PH7PR12MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: f1edf210-f468-4bd7-c6d9-08db014265c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTBXl3RzXrXsm1viUDiZ+hLLl5fmuPL3FR7kvpGPW6THiFpnlqmcIgHrqnH9bU3WSSj9H6GuZvwrzRMl2PT21zc1rMyZR/DWFwxjOt7yOa1OG7CaHNZ97vf9/FDJBRR0eScYlybP1Tyi2mKhOSw35X3hvJDpkBMlC9wOEQFX/o8JCiwwP5rlPrbsCMN946GDhJKCY+r7Kbdqmi5XQCHz1OxIBUEmZjJlGe6PGliQswFArUZovVjUVHIKI3YFs5VccMO/c1K7Dwx/Ek/wUjfuj5wewl4UfVo6rCHiqYVJc8+8BwSnSYDoZiIRQRg5yuFPAxUKVI8Fwb/cq1f29aeWWP1cp5mn6cHOtf00yA6slCQBnc2UbSx7sQMOjD4sOhnYaUmxV9/nqt9b060+fL20it0qgbOcgbfF0Fso48/FrQtjnQs/lP2BXSL8wXKOrEwWLQqo4FJo3oZ7Zsufh/s81nkR4p8sRrlYPUgyXM6AWli/XCG4jyzsAWhlfpiZGyTVV1QfYRGwd/JG0z53z0tCyGm3a/C5M7L6/skFwXkF1rYSu9MRbjfVo6q7HpAH5njIHCKJePOiaMHhA+j5I6iWzgTT8CWNE2xuM4fINVuSsFu2Br1jEFJZig7xxEfOPNnlhqbjJHeyFP72kmVYcMfhkzIeePs65Lfpmao/RLR5QRrFXVgj10NFCJeTO0Vz0sYAB30Lwx7BToa2WEqLxbIseTiHlfRWTKfRL+V0oD116ApgJnJsrX7QiUXpFjrh5wb8aoKUqSrU4sv91sxuZ2GdS5qyMibCZUGp1s8QKUIEhKQ=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(316002)(47076005)(426003)(54906003)(5660300002)(36756003)(82740400003)(2906002)(36860700001)(8936002)(40480700001)(356005)(7636003)(82310400005)(86362001)(83380400001)(70586007)(70206006)(4326008)(8676002)(6916009)(41300700001)(40460700003)(186003)(107886003)(6666004)(26005)(7696005)(478600001)(16526019)(84970400001)(2616005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 15:14:48.8071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1edf210-f468-4bd7-c6d9-08db014265c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5653
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 28 Jan 2023 at 10:59, Vlad Buslov <vladbu@nvidia.com> wrote:
> On Sat 28 Jan 2023 at 00:18, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Sat, 28 Jan 2023 00:16:40 -0800 Jakub Kicinski wrote:
>>> On Wed, 25 Jan 2023 17:32:12 +0200 Paul Blakey wrote:
>>> > This series adds support for hardware miss to instruct tc to continue=
 execution
>>> > in a specific tc action instance on a filter's action list. The mlx5 =
driver patch
>>> > (besides the refactors) shows its usage instead of using just chain r=
estore.
>>> >=20
>>> > Currently a filter's action list must be executed all together or
>>> > not at all as driver are only able to tell tc to continue executing f=
rom a
>>> > specific tc chain, and not a specific filter/action.
>>> >=20
>>> > This is troublesome with regards to action CT, where new connections =
should
>>> > be sent to software (via tc chain restore), and established connectio=
ns can
>>> > be handled in hardware.=20=20
>>>=20
>>> I'll mark this as Deferred - would be great if Red Hat OvS offload
>>> folks and/or another vendor and/or Jamal gave their acks.
>>
>> Ignore that, it's already Changes Requested.. =F0=9F=A4=B7=EF=B8=8F
>
> Hmm I'm looking at patchwork.kernel.org/project/netdevbpf and the series
> state is "New". Is there some other tool for this? Also, since I didn't
> receive any other replies to this series, where can I check the
> requested changes? Sorry if I'm missing something obvious here.

Sorry, what I was missing is my morning coffee so confused this series
with V5 of my UDP NEW change =F0=9F=A4=A6

