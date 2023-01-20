Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01D5674D7A
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 07:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjATGmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 01:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjATGma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 01:42:30 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E30A45221;
        Thu, 19 Jan 2023 22:42:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekJ7TtYjY1KkaknWF6D4J6rVuRCZXp+bzrWMYEJpRHb0HFmMGkQIH8DR6aAsvME5Ul1Qx1SnR0jQosVbpGxUUcGdp8CVj2EzWN3fDjfDMfk23NNkpUGG3gOZm7mx2RVeGaIPSIrHAaOpJ02QmIq1IYZnCXsIsvVyV/4u8MmY6sAn3FVbKgeiN7tjYEzKBNQVatuVCtgVXvB528Rj50mfb2kl6NzbC8Y8usnWLggZz4zSqspGOxQGvordCZBtjhSdAa72+kyKOuRQZZoottMi0UOTRH+GTeajI+DCXphvJJBRQjcQa6ndN6jxpD+HVA/wDyoIX5XeDlTUaQyjn9cAKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jU+D7f/u3U9i3nM5Rgb9INaeWjZ7vlgcBg+2HV20evg=;
 b=RZ6LJqa9K38xrMj3EfGFktsojcEYonejeYEzPNafQBzKwC9KOeWWBJlHYiFfYO1wJ/Z9EklLkqzQKVHweLB7qwridFhjo0jOMUEo+Dw2/P3hxjamK7Jn9H2zJNxmBCVSOrftSI9tUkMrNK0t9e6SjycwsAWTDRyIFz9oc1L/b/Qd8xLnzwiAleUry4HRlstqn/sbXkjjyWU2aB+KWBOUdj6rH1IYJE0j/xevywRlmZFtPfR4eI6DERUbBIXwNe8m6fuuowCKaKFP8vgRrsrWE9zbneNV/htlzG9X3dng5M//hhHW/NbZr4sXO7eYXEWJeRzW/Hl7vsLCmb7lDa1j6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jU+D7f/u3U9i3nM5Rgb9INaeWjZ7vlgcBg+2HV20evg=;
 b=MlakMKAohz7gz0mIKoW1eBoTZ000lFOTZ18VZTgjwNb22d5Qbr4vrhgpFHEixp5MPocdRGDMqkD7Smeiagkf4T4vU52QYGD5HU57OzgPgaQixapdidUA6jsZzwaNFJyVL1YhMhtFFt31IfRzSzv9usiJyYXFx9V1FLNeCxs7EN5DUQ+EpeUvjLovxc1rDr767tsCughZrjk/OcPq5U64ZXFX9ccHwi8hDdf0/Cu4j7JfBnG2HR1gK0+TkPXjz8J04PZawkCWx6JxBeDFy0BYOvTQjx/v9Bo/z1YajkvIlXIwBpabEuinOOdjSKoxrv1T1kj5WB//9wWxHeuqI04BMw==
Received: from DM5PR07CA0079.namprd07.prod.outlook.com (2603:10b6:4:ad::44) by
 DM4PR12MB7621.namprd12.prod.outlook.com (2603:10b6:8:10a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Fri, 20 Jan 2023 06:42:27 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::b) by DM5PR07CA0079.outlook.office365.com
 (2603:10b6:4:ad::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Fri, 20 Jan 2023 06:42:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 20 Jan 2023 06:42:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 22:42:21 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 22:42:18 -0800
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <Y8m4A7GchYdx21/h@t14s.localdomain>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <ozsh@nvidia.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 0/7] Allow offloading of UDP NEW connections
 via act_ct
Date:   Fri, 20 Jan 2023 08:38:30 +0200
In-Reply-To: <Y8m4A7GchYdx21/h@t14s.localdomain>
Message-ID: <87k01hbtbs.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|DM4PR12MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 71729296-da99-42e3-4979-08dafab17edd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yZw4+hBPBno21G56PkjIydWlgmVQcizoPpZQ8Iq0wBS8wOFc/SAtb+8ZuPT0+jR5mO2n99kIjysDfdDlVE8IVbR8zzCI3g1tGKAY5+SlEDDimyMOSOqVe8HRSZP46N8+AO2J5xP+nSm+Jpz0XojMlsdqCB0ZZDj1JA/k2LpOEBEatgSYL04v0Qlk9eKHuozY4tEuR3LQEufCrHAw26xzj5Iza+ki+nlw2M1f0b4rScj0rqB/fUxUmlUIdprnDJJlxo/hrny+vT1iEtwiEC01Yq1Az0WccWBtuAkkgiqfzNnDzzHSbZ6GjgflNqbr454Vp4nUqbi9ffPi0BbY32/Mqc8wRRUEKGxpKqIY3A+XNyaeFRIDLXxqhHXPpimAjKMnL0n60yxS9SR8opxQ5qQJKQoKBmq0LZB74Wt+AhiSTFS5GKe4TL3chz2Z2WJH0SXUXm7GjNYhZYarENb4E1L6VQHSDIhTTb0+k1hmmUWQSNbNarphhb+I46BD9U1DtTWPlG6RWfBonspHUKkNh1DD7Z5tGJEPptMuxQdbcBVKq9hGWnzpBULXKJn1r70HrH/XUt758dXKEJAqnNATpHcdJjnvjFI6wJP1OFbtd9NpaaKQQrhdW6l5rzqeTD4JdEgL7tWPrMOJNNkEcstS6wOOk8Z6nt3fekyMHK4HNmRBnxF94SZ0mR3iXyvRExlJApYrsUdJPTGthbXHCFohMiwtwQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199015)(46966006)(36840700001)(40470700004)(36756003)(356005)(8676002)(86362001)(70206006)(6916009)(316002)(70586007)(4326008)(2906002)(8936002)(5660300002)(7416002)(36860700001)(82740400003)(7636003)(83380400001)(478600001)(7696005)(54906003)(6666004)(40460700003)(47076005)(82310400005)(2616005)(41300700001)(426003)(186003)(336012)(26005)(16526019)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 06:42:26.9370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71729296-da99-42e3-4979-08dafab17edd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7621
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 19 Jan 2023 at 18:37, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Thu, Jan 19, 2023 at 08:50:57PM +0100, Vlad Buslov wrote:
>> Currently only bidirectional established connections can be offloaded
>> via act_ct. Such approach allows to hardcode a lot of assumptions into
>> act_ct, flow_table and flow_offload intermediate layer codes. In order
>> to enabled offloading of unidirectional UDP NEW connections start with
>> incrementally changing the following assumptions:
>> 
>> - Drivers assume that only established connections are offloaded and
>>   don't support updating existing connections. Extract ctinfo from meta
>>   action cookie and refuse offloading of new connections in the drivers.
>
> Hi Vlad,
>
> Regarding ct_seq_show(). When dumping the CT entries today, it will do
> things like:
>
>         if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
>                 seq_printf(s, "%ld ", nf_ct_expires(ct)  / HZ);
>
> omit the timeout, which is okay with this new patchset, but then:
>
>         if (test_bit(IPS_HW_OFFLOAD_BIT, &ct->status))
>                 seq_puts(s, "[HW_OFFLOAD] ");
>         else if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
>                 seq_puts(s, "[OFFLOAD] ");
>         else if (test_bit(IPS_ASSURED_BIT, &ct->status))
>                 seq_puts(s, "[ASSURED] ");
>
> Previously, in order to be offloaded, it had to be Assured. But not
> anymore after this patchset. Thoughts?

Hi Marcelo,

I know that for some reason offloaded entries no longer display
'assured' flag in the dump. This could be changed, but I don't have a
preference either way and this patch set doesn't modify the behavior.
Up to you and maintainers I guess.

