Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A0767F695
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 10:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjA1JFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 04:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjA1JFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 04:05:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824663FF24
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 01:04:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVxUFKIq2EBTriP1NaFD1/bxkJmpgw9FcFdrZbEwMDmoGMgpMKIstICiDK/v2nBSByn23QmuVUJ5UYQxFRktPQka9ZDNCFgrICNZ00yQ4dLDRlW35jU5ZiIYGPTPeo3Vn9elNZQ9e5HIJGZ7CMYlKMg2jq6yxBO0bSnzHTUtaC5JQwg1YKLsg+53efyy2HY8+dxrx0VYpvsH3E+t94w0CcFmZ5NtpkzaqcIIuJhq1MqQBqQa8GWAi0rch0KY9czJtFNu+6LW3avR1wrS7WKssij4srRYQBkC+Qg9pUck75zEz+ucKrj3fHGNS4mdlhCJWwgAL9jn2vPLcNMGWLdJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M430CcMGJs73dgaJRaHaCV9tEn9Wl+Lxc4zE5AF0blo=;
 b=nRP1G/Ch7sNSXQ/tRJle7HXNCSCQHoGOEqC+LxhuJNc4gC3HYCMLNSYlda4oh2y3KyZ8XXyywuAX3m+/4fAITp8KkA+7zZRVxmPYcOPAuWaf37KkVJg4DqeakM4SU45rC1kNNlcECW7AxktOV8s1Wmykjn40orAGrZ6yn+TaIbSOic0rIdhaYQ8iSB/cu/EhLVtS0ldyztxlV7130qo6eYrNK6OjvBLdLSkrUjNOHGpXGliJNXPGXb+EHPJXd87FNH9nhb/klc8l5kGQxdWfGlP/IFr05y0JutOEH7A8xRC0+DHBVE6fIGZa1ld5HT7iEXgz+rGao/nTa0zRouDf8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M430CcMGJs73dgaJRaHaCV9tEn9Wl+Lxc4zE5AF0blo=;
 b=FaZa6sdH29g/QPLZV/Zdv177p2nxmff4QACSKjhqUF2pVCkKoOeKVapeFJnNmRGHQOXg15whXJi8ewKYeCoiuh2JXNbnwVzhuYQLiDbr4GXj8MqaRR2j/ZKjJpeVOhTNYT0s3pwG+sQTDLblyzx44P12AzY3dyL2XGDH6KDVbwt8nj4YNlzNZR4PNCK14xQhBBWuRo0B9dQgHC1uVgcajFQdsRJo/RMCZb+888h70uOKTZBSSESYUs2fV9C6EIRKJQghBEj7jxY501w1cfAskL8Kty1xaC8hrc8LOyJ/t6euBLK4Rwup93b3H/YFuNKk1H5PMddhUJkDD7hsKYdB/g==
Received: from DS7PR03CA0012.namprd03.prod.outlook.com (2603:10b6:5:3b8::17)
 by LV2PR12MB5751.namprd12.prod.outlook.com (2603:10b6:408:17d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Sat, 28 Jan
 2023 09:04:49 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::1c) by DS7PR03CA0012.outlook.office365.com
 (2603:10b6:5:3b8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28 via Frontend
 Transport; Sat, 28 Jan 2023 09:04:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.25 via Frontend Transport; Sat, 28 Jan 2023 09:04:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 01:04:41 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 01:04:38 -0800
References: <20230125153218.7230-1-paulb@nvidia.com>
 <20230128001640.7d7ad66c@kernel.org>
 <20230128001810.08f02b0a@kicinski-fedora-PC1C0HJN>
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
Date:   Sat, 28 Jan 2023 10:59:47 +0200
In-Reply-To: <20230128001810.08f02b0a@kicinski-fedora-PC1C0HJN>
Message-ID: <87zga3do7v.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT113:EE_|LV2PR12MB5751:EE_
X-MS-Office365-Filtering-Correlation-Id: c412e421-cdc8-4daa-6e04-08db010eb5b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JuzD/qSUWLvPWtEOIdBgoE/uE1AycU11P+mOfVWdkAYnM3IURVQOlZVdsnnlsxr54xcrQAzysAHhBKVySz8wm7olhSFpuklviU0fFQ2KiB6XH+Exdexs5j7F5Y2pPO3U+ClYj1QoIj96d7BON8EBB0wOzaP7gAcImLDenWEtp8/FCjhdOJ+Z+FSwIQ5glWp98N/6CRGzkht8bU2UqWWUM485WyOhjfP1UqBZuz7W2/GEJdzrOUeAu0yjpOqv/s82uaOUP4qEikTjIzAVMMGj1YQ2Bvvi2qCvs6b1cOKGenEa9D7pm0agRT+kUyzN4I+PSV813ciKxH+lElHDCGBV3gAdKw85Bg3OvwaJDMWdE+nTETf/7RIGLZrLgwV4JaI3w9dFQeKx+A7u8VdU+A5SNNeCoqpSaUEc+dHPvpOgdmY0YRhAZEqX4nfwz/tIhPH055qLnbh1t88Sxk/c4JFlj2GG7bWR+J8duL9WGLF5a0jCZe4fyMy+HACy1J/Vg1mahEekIF+qSFLVc4uxHj1DXGkbekPYkG8oiEPAevC7sncZ1uSxhUncQlJHR8XLT/kORmVCAul/UdF8dkyUrAwgwm5u4AO1J4uUcp4krXyPpdoSv2+8kvSAqP02w58QZErQrCZo7+uP8SeKDy75tnUOsgJT6MszxY/LPUPE0ypVveleMR5maPTx1StMXLPb9OIj+3RuxtNpoC3TsGVtYLOo+O1uqmWanONDq09I/VL8aXf7vZkkwwuJ5r1PnBza8cC/oJIX8uVWmrwjwEzcbYOX4k7nrJn8/xSaIdLmAswkLVc=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199018)(40470700004)(46966006)(36840700001)(26005)(186003)(16526019)(6666004)(107886003)(36860700001)(82740400003)(83380400001)(356005)(2616005)(40480700001)(86362001)(36756003)(7636003)(40460700003)(336012)(82310400005)(47076005)(8936002)(426003)(2906002)(41300700001)(5660300002)(478600001)(7696005)(70586007)(316002)(4326008)(6916009)(70206006)(8676002)(84970400001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 09:04:49.1427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c412e421-cdc8-4daa-6e04-08db010eb5b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5751
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 28 Jan 2023 at 00:18, Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 28 Jan 2023 00:16:40 -0800 Jakub Kicinski wrote:
>> On Wed, 25 Jan 2023 17:32:12 +0200 Paul Blakey wrote:
>> > This series adds support for hardware miss to instruct tc to continue =
execution
>> > in a specific tc action instance on a filter's action list. The mlx5 d=
river patch
>> > (besides the refactors) shows its usage instead of using just chain re=
store.
>> >=20
>> > Currently a filter's action list must be executed all together or
>> > not at all as driver are only able to tell tc to continue executing fr=
om a
>> > specific tc chain, and not a specific filter/action.
>> >=20
>> > This is troublesome with regards to action CT, where new connections s=
hould
>> > be sent to software (via tc chain restore), and established connection=
s can
>> > be handled in hardware.=20=20
>>=20
>> I'll mark this as Deferred - would be great if Red Hat OvS offload
>> folks and/or another vendor and/or Jamal gave their acks.
>
> Ignore that, it's already Changes Requested.. =F0=9F=A4=B7=EF=B8=8F

Hmm I'm looking at patchwork.kernel.org/project/netdevbpf and the series
state is "New". Is there some other tool for this? Also, since I didn't
receive any other replies to this series, where can I check the
requested changes? Sorry if I'm missing something obvious here.

