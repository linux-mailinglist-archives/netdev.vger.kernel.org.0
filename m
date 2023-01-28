Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97D967F96B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjA1QEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjA1QE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:04:29 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B10814EAF;
        Sat, 28 Jan 2023 08:04:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4fLr3d06nctMbGilPDnPb+BEiQJygE9WKOtwwL5fN50uWbvj4fvU6gBcLGVzPo8aI/5GOPPWzvS7fAyl83AY+ZzRvwhy++EWgdbGoIWiLT3P6pqPejrkd6d7g308tg6rkWWiXuHAqsMLvUkjGT70ZlYDGAWmFqfSmVSW01krxH2WzewFsc5o6MA2FowPu6DKd1HZZfj2fkJeQ3mnXbYUS/sWvBcJ0/aVxzN9KsYlSNIXSpvXuzhC4LrP+tdYCD60fYj9fEySMf9VgQtFjJ3PerGr5iD1HyA+1LKO54AvbGqH6usSi0iQ7Fd13YEYNFWummQkPyQ1UbGj/qIaPP6Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrRrgSqgKZTEyIGZuEorWK0XtkBxwLGObWTI6h/FOgY=;
 b=E5HOyYJj1qS2U7vgnWxQTx5/7NZDnkBj50akhoxdeFyE8q+6lCfBobELoCxalOdFtZjKd6yWFOv6RTwU/yt7WBYNU2pJgOEev1UBQRIAMEa3WpnUjANnswW64TW5pul+1yFCCTpfUwwYf56Ae5TErZYO6IcKFMVtXy9A1/k8WYMhWRLpxwWX8AzWF0k5XKoIerVWpaQFaYIz/NF9aAXW/tWJR+lF0iFlQTXe5QADxp5ZgD8cZedwswzC5qggzbpolzsQznGBdq5XiXKO5YYA/nTP5lQKcTCaMeRJYK6Hzu2KLuKmsNJedLHCvrj07WdD+lYJeDWseV3ibF+6Qy7dXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrRrgSqgKZTEyIGZuEorWK0XtkBxwLGObWTI6h/FOgY=;
 b=pWqxrAv3k785oC23aSbNTIdxjm9SMqkJrTogUoXc2oSNRh2YpCfi7rTdIkThzdRFtV5WGmMSKOtfUWF/yVM/PXOnnFlk+b1r6Ak5TKRoZp+O4pSMHdJ3MZJ3RpIAILX0kW+Cw8i+bfDj77VNPYwGfOq2W+ixtfkBacd4vTWKEhX5lr+CooEQO6Pjh7FIt4UwojfP5YvNRWRlq3rwZyenIKopT++MYe++0Xed00MYg/MGBG2b5r50WqRwCnggx+J/4swcedhcM1swU7thvqqyAo8a5OFEIBzoBvj1ejAX2zyFGP1gzAJpFO/OBKC2fTiKTySgbIpHPAIqvSjsEkg5sw==
Received: from MW4PR03CA0179.namprd03.prod.outlook.com (2603:10b6:303:8d::34)
 by IA0PR12MB8205.namprd12.prod.outlook.com (2603:10b6:208:400::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Sat, 28 Jan
 2023 16:04:27 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::bb) by MW4PR03CA0179.outlook.office365.com
 (2603:10b6:303:8d::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30 via Frontend
 Transport; Sat, 28 Jan 2023 16:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.25 via Frontend Transport; Sat, 28 Jan 2023 16:04:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 08:04:16 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sat, 28 Jan
 2023 08:04:12 -0800
References: <20230127183845.597861-1-vladbu@nvidia.com>
 <20230127183845.597861-3-vladbu@nvidia.com> <Y9U++4pospqBZugS@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v5 2/7] netfilter: flowtable: fixup UDP timeout
 depending on ct state
Date:   Sat, 28 Jan 2023 18:03:37 +0200
In-Reply-To: <Y9U++4pospqBZugS@salvia>
Message-ID: <87mt62ejd1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT113:EE_|IA0PR12MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 7411f794-1146-4522-b11d-08db0149544f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: npP2db/n4zsDKEJ8/inKg4+sjUov6drbV+xkezxw9jVjgwDpTa4SCsoVl0ZiysA4Hvw62Ef0GgIJnDkW9i5w3UmhxLWwjG0T+atNFi6EzKrf75mggo2hjugheblj81/Y2+EJDW79XCPUoRgpDUlUQpSWYQdz8ASRgCdy3Zs4ox81sAhMcHXniXqFaYzR3LYHxJ6TXz6her0YuKh6G5WxoQq6ID34zKrR9nJeSUZwD40vVpl0azmO+QcRAGQokPBeipe64BNAHUpvPccQyoRtcku4yBaZVYZw1OKabPXRAsrGG6efWBFzEitH9b1GzsNj06nSj5+Kq/Ro2CmVUxVBKs0SmwgF9he0bQ93PitonNJZ035QI5PPblFthf5uRdn3Hp1pUyMUOxnTUjPvr91XS2RDOijW2gv+F4g/pI/bqi/RrSRGlCKesTsYCoPy3ryGUrD9rOOVIn7S+WKEceuOocXGDvEVubrGgn1pkgH13J0sgfzYJ/5R+XAu60BOWZvt69Hklp4ZUayWZexYk9JGBTGLnLBZZNxH0vFi47dPoqFtVVsdZY90UBKB1iYvQXBqej73HgCKe7bbJNJ2p6l4v8P4P+elwRJEpP4HJs1EPL76FvVKiVUxjSZGzcekKHMsMDI7PmOtW4k8CFyl/zjTBjgd4gE3srF6IBkCnVJI4MJCqIAyZvvMqK8hABidE1oqvI+DfEcAsq8gxcsKx1ktOA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(5660300002)(186003)(6916009)(8676002)(41300700001)(8936002)(16526019)(2906002)(70586007)(4326008)(70206006)(83380400001)(6666004)(7696005)(336012)(426003)(478600001)(26005)(2616005)(82310400005)(316002)(47076005)(54906003)(4744005)(7416002)(82740400003)(7636003)(356005)(36756003)(86362001)(40480700001)(36860700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:04:25.9619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7411f794-1146-4522-b11d-08db0149544f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8205
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 28 Jan 2023 at 16:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
>
> On Fri, Jan 27, 2023 at 07:38:40PM +0100, Vlad Buslov wrote:
>> Currently flow_offload_fixup_ct() function assumes that only replied UDP
>> connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value.
>> Allow users to modify timeout calculation by implementing new flowtable
>> type callback 'timeout' and use the existing algorithm otherwise.
>> 
>> To enable UDP NEW connection offload in following patches implement
>> 'timeout' callback in flowtable_ct of act_ct which extracts the actual
>> connections state from ct->status and set the timeout according to it.
>
> I found a way to fix the netfilter flowtable after your original v3
> update.
>
> Could you use your original patch in v3 for this fixup?

Sure, please send me the fixup.

