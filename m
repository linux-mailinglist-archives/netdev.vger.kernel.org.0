Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8C368EE1B
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjBHLii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjBHLif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:38:35 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::71f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C878D46173
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:38:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYNrQR8w+3B+1mWohZZYpUtLJDnK8LANC3g9wmGPk7a+nFDzk6hHO4NJrSHVnJrgWJNoHh104u+K9qj070U9oO3lLpmKlRw/JpYaIg7q9XmNllUw/2gxOu2Wwyk8fzFxWQ+h2U3ITIY/WAIk0bmh3ZXG6g9bPRi2lBBYBXxbcj8i0U/dNIIVtA5lmKV2OaNLqYrtnl+87OTOSVytrLy1hLTlwnru6IvQgr7hEWjGtyAW1y9hx3VOLu6nV01lvy4cesdW4SE29Ibxssc0sk9oMDJyXRfJcHsIb4ylwntkAr/yns8c7aMXvrr4IX6Fzii06dIXv3jN6ESlwVOCJ5Y3Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Di4aIbaKufMGeizDI/t7leWFfHi7+qpn7c+fhVkoO0=;
 b=eb70EKwcX4JpXTRvaxHjRCo758/fZoPrvxnax2tMW5ejCzNp9rcm7UTOo7vAPRxlZ4t6AjswiyKcfcF/kkt7+ue5cXwC4osGbWb33NBA2lzXpej6UCm8o1glWJyHOtxe7gLv3RxJypm7C5f9f7GMPggntoLfnjLS2TsqXG/7dVlhS0JjU5RPobindPw6QtVWWv5RMp53/BUVZalo04JkXnQBm2MWlN8Gd3rvXR5rsCQ/ppuXZ9VCw8ySKw8Ncyuad61c6rBi3itl0SuoLp5GKfvt5qnUWD7SB/r6ugEv5l5WdGGZ3isCvx3TaplcSb3nx3jE0M97VFgpS1DpB3PXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Di4aIbaKufMGeizDI/t7leWFfHi7+qpn7c+fhVkoO0=;
 b=CaJCyUTw0pZxt0O2N3Vunh/oDYqe1tJYd3khQno3ITBhpxA+65yKUD9T3jH6mVeti+SA+Cw7YCQIiOfNeXcvaUqnjrIZhCVqRITjf/GbmxFXx6x1RZ3tISNXzmdbRLUoyMuMORI7mehuE1Ol9KLqbRCEe5z4iE8rgCEmBEpaqEc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 11:38:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:38:26 +0000
Date:   Wed, 8 Feb 2023 12:38:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v4 net-next 4/4] self-tests: introduce self-tests for RPS
 default mask
Message-ID: <Y+OJrI6n0dT0J89r@corigine.com>
References: <cover.1675789134.git.pabeni@redhat.com>
 <9f6f87435cc57bfd612846d170b1e9e5774c56a7.1675789134.git.pabeni@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f6f87435cc57bfd612846d170b1e9e5774c56a7.1675789134.git.pabeni@redhat.com>
X-ClientProxiedBy: AM8P191CA0028.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c4e3bec-0b71-4480-8b62-08db09c8fe07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42uDQiNerDCONk+KqyDd+MwanyAVM5K/zKZVF2SkZye3Dd+vQHvdaAuMmOnMw2hFst+1o2rs4DPsGGjOJBYvlJXufFmdpMaojerhSiuev7wM/j3u2YK1B8qNvW1ZgpceEZyXFmLEPwRe6BSbiZE9CJMeqKKdJlriBkgOgRbVbGJLiYNLNwFHvTF/ufQPv+YO074eT5c8sjdpMfio90UUjL1FX0DE3xyXdXSNYHhRvC1UlmQu0ymgrFDZ+YwcAG9Jt1gvc38W1P+jBG3lEY/BNTChUQikIJuNwBnxRa88NCYnx/9cZm/L9ENLSD9MJ83icP6DfO+xtDwnvrDDjKi717QynSd+CkQUTLppyVno+cICfatSoigU2uEjI0L7hbfxu6PCYDc5cu/K9ItfQCjY5bdBa1gJLRQQbNJRsgJ3mcr6Vp+CI7BqAPefvKS9qgCYfRkIId+WE+Q+ujiYVDrnXFQxqqDBHkzw21KmrG+uo82iUDAfgy5jVCDCzO9moDdwLUz+v8Ar6wUN7YGMxT1JcvdUda5QYwI0cSUg6cSBO0bjLMXsn9ue+OxlOJ8embFhSDR2g7gUICjRBVEKbXz/cPCnJ7e5mVWHTi3mc9IyRNNem8OvGqln/Vg0wJkDklG7yE640+8JalIIlhM0/ColWpoQDfRGWRP0ulQo1Lw4ggJ6gSBa0geitYfB/fTK7bKu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199018)(38100700002)(558084003)(6506007)(41300700001)(6512007)(186003)(8936002)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(2616005)(5660300002)(44832011)(36756003)(316002)(86362001)(54906003)(6666004)(478600001)(6486002)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?esr03z0iqksAsSmlfJ+6x9f09t6CeIRoPlWf5KEy8Up/EONjDeqp2YubfhKC?=
 =?us-ascii?Q?W/ygTxu2P7ZfNZraEoqr91e49bSKO3G3uNhSGpdjCy34MqLe0lryCowqRTN0?=
 =?us-ascii?Q?9sKw1fu4spATZTSbKnNV6cCc4S9eU5wMF9vGa/uXzZYdl5cnVra0yeqK79fW?=
 =?us-ascii?Q?Ed7IiizrgLf4VS0C3pPW7Xs3aLFAvsK4Ee5pYK0xvj6x176q4Cz43nLiQawO?=
 =?us-ascii?Q?lCVPGRoplwn975pQUvUjxA2vUvTiR+bCuJSxscKh49plfcRLtz569dgvbT/P?=
 =?us-ascii?Q?iNsSpFRlQVtHCPiFJRNVSFrM00pbceWhalUyRWUIehOzbASobJmgsvl7x9cG?=
 =?us-ascii?Q?oowTRz0pomZlo/FLXTqRnri5krIZKNp/k/4rqvdWUEM5pqgsTCdOIwRqbY9S?=
 =?us-ascii?Q?obA/CQxqL6TYIlDQQMb5zMudOAWw5idxNvnFfXLaweEk4RhSa2ALxqr4IOma?=
 =?us-ascii?Q?VOHGtBr0EWhsThGheO9ZvONVT099U8orcp0ychnThyVY5LKEjDGJRbJSr9lk?=
 =?us-ascii?Q?X645m+M/NULRm8EkM0WgzLFojOCD8TiUpgUDaOi/mlKiDcEJ1ShhMde7IJwR?=
 =?us-ascii?Q?XybVq468LuNZmT6ms+gw1gAtpY3rvKeGkNpmBbbsr3fTrqVTNdAzpQQuLPMs?=
 =?us-ascii?Q?SxEj2pnpxwzWRnTqAKz/HJkQnv2hFRnXvMun36WEtGS0FbXWfYSYg2BxFDV3?=
 =?us-ascii?Q?FXbohhaG95q0gw1QQrChiqDc/a9Tv6iar6qy16NrZC/7Ymye3j1BLSeJlFy4?=
 =?us-ascii?Q?AtHTL6Oecr9IQhLI1ztM4nSqHwqSizbLFqLtHi5iZ/YdWaMGPaFPFiphGIqe?=
 =?us-ascii?Q?gX19lodiAh04C2cJMZeNsa3pXtfmNZZcVPJK6Mt9oxX67GfGqEHv4LVWMykM?=
 =?us-ascii?Q?9ajX61nMnqINRuvG3S0X/DgZGzZ72K7iXYcTei+k9hCXqLvpSQfB19qBJvOO?=
 =?us-ascii?Q?ntJiLglYr62QWEOuNy3x3p9iAeE1wQhvOfCWYGNmRqjJXeLra0wN1PTccZEn?=
 =?us-ascii?Q?YrLc5QJujJAp/CHZJa1Ba30pB1Wz1oLq6MpB95puZcTRcJnnkwdxOwAF4LAp?=
 =?us-ascii?Q?qd1rkP6s5QUdRF+C70VctoIYix5PER6jRovIRX0/3BnbO3GTfy8JkRck9hjJ?=
 =?us-ascii?Q?ofnMgJEVavaOzz96dOq9i7d5phoxK14c0VlfVBGlJ450C/IvC1oUyqKJbjQr?=
 =?us-ascii?Q?WQnl4sg+ZyPXmCgQa3JdnaOy2LhNpVvKiGH0bg1Z1znwmT7mkoeOVqIAzsrp?=
 =?us-ascii?Q?s0OGHeqchaqVMqNF2KP4e10ZJHCHwjq8yApPfZ93Udjz/Ep6DllAKg1igVWZ?=
 =?us-ascii?Q?lY8fMduwiR4F6aYXMQNDzOKEC2Mf1GB6dRHpu4XL/8Ah83T7FOP8jEq6ZI/H?=
 =?us-ascii?Q?NaYJ9AluaddJed1FnnZkgX1BmybO3iabiO+AW2/hC9S+axi+nP7iXBBeKdbl?=
 =?us-ascii?Q?YHZzuf3IV0NvonacYPIFP63OUunWd8Hi9ggdUxIHnL1uxbYNkEcN7gsyIOWD?=
 =?us-ascii?Q?Asz3E2YEB7XGEojlmtJ0cpf7WZwz7dWdMsAnubzcsMEHqXZRr6oTHIbxB/qt?=
 =?us-ascii?Q?JWLTOtIREK/znpVAh9+7sfexycUTcBbobwwT3DTOAJ5hGdb/MyPpa4WUeVW6?=
 =?us-ascii?Q?4UVWjjvS3//LXwMFlhXObal4lGIeIYV+/as7d3iRnjudRP16IoNnOra/DBhY?=
 =?us-ascii?Q?an8RQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4e3bec-0b71-4480-8b62-08db09c8fe07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:38:26.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnS3a+5Lgydw6VGpWXo79o8eH7fBKrMbk/mfxxlx23w5C33AxHaK88bN0cLzquD1jnPIYyXoksC+1sVa+ULhj5WtCrQ8JfIubVxYTdmhc7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 07:44:58PM +0100, Paolo Abeni wrote:
> Ensure that RPS default mask changes take place on
> all newly created netns/devices and don't affect
> existing ones.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

