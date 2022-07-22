Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4557DCFC
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiGVIzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiGVIyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:54:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D199FA0B80;
        Fri, 22 Jul 2022 01:53:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUT4P7/7GAhzNPvYajhMGiLj4XXUPOgJ/o7ZlKCLaVSdG0pZV3VBFZswIjZMAGJbjuOkEenDHRRAyN3vtbOq7JSKLj4coMmcrWlSCZugiAT5AguRNMaoOcy2zWmEKU3aFwGfiOpTTiz827Tkhz6c2Udj/juKyuWYGZ2u4BWRfSfI6Cao9eTt4TU2OXdjxzv1x7+YlexnpIBVycYUDW8W7BNS3wrSY0QoP64JvTXO3DcGZrWA6psa80RMZ/nyGnyGnwip8fDQa3FOUs5SEZEoOI7MrhbpyEtVJoOqCCHnxhIr7w4F2v93xho02VnQTZZae4cmzTvfauf6SeV17ZqQYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVwRpbipWuWX8pljeQzZQrRNdqFLoWAYvGc/vW1we4U=;
 b=I7FepW0g/8AeWELhv0dd08JQI594/gIniY4KHceMn34rV8u1AKA6S/kjExHpb96qIrR23HRQj0HVlmsIT9OcWI0dOpoZUVMEI6eops1X8YJ0OP5lw1+bxkKVqizbE2HfGWR/PVwVSwRChGg7KFAEjUhgTJKiYePSffTZMeMoy/AOI+aYO8/gCZkwGVDtovHkgndfxB93ybiFMp/dNdD8u1vt7Bqeu86RlMFMj+arFGrv4oebMh+fuS8CMb+9FGdn4qUWYgLDKsq3dqi5iRME0PIaKeBQ1X29p79oALQ/cVRYnbCBHhWZ5J4xBVS8AezMu0+fzV6PFrq5X1jFKXXzug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVwRpbipWuWX8pljeQzZQrRNdqFLoWAYvGc/vW1we4U=;
 b=l40/X6xEgKdhCjzgMP1ETAJmmux6HLJhUzTOUaJmZCpTl1rHwuWZQmrDFtOkGVL9fQHXmrKEacG9vW56aDNAAnepRoC8ZY8uTIpzuvMwYlWeuftWJgsRYz9kYBq0O7fXJUk9VoFtYrHYgOXxkWWf3cBi5KSXg0RUni1RyGV/2jE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB5046.namprd13.prod.outlook.com (2603:10b6:303:f4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Fri, 22 Jul
 2022 08:53:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5482.001; Fri, 22 Jul 2022
 08:53:38 +0000
Date:   Fri, 22 Jul 2022 10:53:31 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH] nfp: bpf: Fix typo 'the the' in comment
Message-ID: <Ytpli3DNkg1HlJJ1@corigine.com>
References: <20220722082027.74046-1-slark_xiao@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722082027.74046-1-slark_xiao@163.com>
X-ClientProxiedBy: AM0PR02CA0102.eurprd02.prod.outlook.com
 (2603:10a6:208:154::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5d5a489-ae83-44e8-5663-08da6bbfaac7
X-MS-TrafficTypeDiagnostic: CO1PR13MB5046:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liqj1lfQQvC4j8YN+N7RAd6eRSilZIh551Sd5oDRyj7+M/QjjyzeG2Z80bAlIsGdt1KH9FFhVJkvOkXtx7RGef0WyYu2pc3AS+/ExodyXBhLovYPFIB3GftVA+411Hcqg4KbfXuY+jEHbiBYflacAa8rjqzakLv0aRCKf6KJNiDP8m8fnnJfnqN2o1r8fFetZmzC6hbDhphpfsjm5wpmPc8do89VAs+k33VD8sUkAx6txQXN2YY/b2rzYbX6Esw6rFH7VAD+IHv0AdlEwOResE1zefMOi+1P+E1ymSnO+hQSYbzkbJI0XOWJvFuJpQEZPp5NnBND+tkbBqX7Se+zYlI4zAU3kYDLigLc6cy8q5FfGJlh8SW+TAxtgG71kT0/WEPlwE6gPDlvfBYSPxc+OBpGYrag8mFDkyq9x4JTz/hs6jzcMtF1QTZRD4Ti5iCTSJo6M1MqL5mPBsAzj8k8HQXtteBKWKMT19jJLWBzfyn15WEFI97abpHAV/5Am8qci76VKqDVXwaHV+WisnjP3lWekPJGY/0ew2tzsDGgL7gKd2UikW+/z/2WOvRFOsnn+WraVDQfCGw1YbF77RI+tBi569Cr1ZmdS97tkUpqpTyv+QaGNo+ZtWyMK3EK1igsLkesNB7GrA3ONWELR1NAjCkgEqaCuFnK1z8R19olXM39+kMvQgk4iNsDyobo5hSKr+IkMqkzIBgEnELVumTI9upNDBJEbkXIF0NvtapAe/80mx1XxU1DvPpJzk7YexCo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(346002)(376002)(396003)(366004)(136003)(66476007)(186003)(66556008)(4326008)(8676002)(36756003)(52116002)(66946007)(6666004)(41300700001)(2906002)(2616005)(6506007)(6512007)(6916009)(6486002)(558084003)(86362001)(8936002)(44832011)(316002)(5660300002)(38100700002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3ChEa5G3C2j1ilNXtU5hlE8+j1YaIifRrBZn3Pdu/Amr+/ci+qzsYL4O+eQK?=
 =?us-ascii?Q?iP+KtrOR42thNFb2MWjyRq7uGq6jNIblMTlA7uFWZJOqTGVQElMqu+UQ1Ttq?=
 =?us-ascii?Q?Wmrz7V1m7O+RRpUJ5+DyznD/JvjLZPVimc0abZeud8iFyczKhYhANhdQy1Da?=
 =?us-ascii?Q?NhAGx4no2ojIWI1sWsaUPANmN+OnwbzdO4YcZ/KPG5AvhfxOj6U26n3G3PNI?=
 =?us-ascii?Q?W8VR1jJCLQJZzlrKj73zuPj76AT8CV6DP4T9DIK5RdwQvfWcBpWnf2e2Aa84?=
 =?us-ascii?Q?T6NiBgQkA/tEQFOALzXjP8jM2xjZiezCoC3w2ID9KZe0tWoCmBDc9cByaOfE?=
 =?us-ascii?Q?jkHG4rdWyLtquVd5EaGKxsjcAY2ZVnznhPH1AK1oJFFYG2UTGqnERjIzJfyF?=
 =?us-ascii?Q?+O/yvOyYbd98jiEM2o2RPBrMPGKWygLG7PnC19zgkA6WFSStcDGP0vJa8YYQ?=
 =?us-ascii?Q?AYdBvLx2ZNO+2wcH2AmJjc+c3MGXkFivpNT9emkS6df8aq/Jn1E7ZnjH1HwS?=
 =?us-ascii?Q?t/Mz6AKr+fgTYhSDgWkU5DKhhSF6k8jhYxdugr9Ooo3gZxsKvuWBUC0kwjUn?=
 =?us-ascii?Q?gcAa0U2QjyqO6IRv7T05GNSuy3DDYkc2IYdetfgN1sZTZBdLZmSAcMGUnCNA?=
 =?us-ascii?Q?AnGE0Rtnc33si3uuyVZCpohl03TdWZnKtH/QhlBc7cCg0msn4OS0DMSv2r8X?=
 =?us-ascii?Q?u1heNvXtjccGv8tqIC0yrU8qxx7Ao7YpJLmqxUOIt+aY2xKaZDGlsMoCAVoB?=
 =?us-ascii?Q?2vcKIai+aVV6faPgsrIP2EufDMqagmPO6BNrWeObGMs7xfkOADKrBsJK/qI/?=
 =?us-ascii?Q?6MekPXSMNKf6CcMRqZGOlVCPi+nNU7U0ZWBcvhnxrBJ8NQyfCn7I2cWipCau?=
 =?us-ascii?Q?PO8wZxlk7D2x//6dsk4PJh8a2R8uv35TyNDDreQWva9IZmAftTVh8QwUkzE3?=
 =?us-ascii?Q?0djBf8umjXzbHJYXnGbUoXAlcL7yeCC/85AjMQvvW6wI85mvKkRkehKvw3q6?=
 =?us-ascii?Q?oANY40PLjv603qwnGkOrTRDk8JHinCbnG2KaRvG+5kbfh16ayK7P8banvxct?=
 =?us-ascii?Q?hSe9HFI9/wi+/kHvbpooshTNZ7mdbt6i9YC/pij1hBTMp4XQn/eF7wYToVQ6?=
 =?us-ascii?Q?dV4K8t4aGzE9KyuD05PEkQeznZpBzDL3L8SJlyAw5RZI5gEdHDOY5mfzABLX?=
 =?us-ascii?Q?b+BR7PKUtMK7OU3rOCH6sBS/vTIY3CBMhxhcSIsVT7S6XxMyhmxYtl1X5VLO?=
 =?us-ascii?Q?EGUzoH41/nuISkpy98nQpCHrLjFEmVsVseFqQNDIQ/FJk1i2Shtv6+s/vYwC?=
 =?us-ascii?Q?GNJimQPqgx6MCx15xB8K5YIGFlzSW9IaNzxCdqQ39CGaOwpMXkpktAAta1yr?=
 =?us-ascii?Q?c37a8Qd8ArpsmjOWXEzSCexSJXe3/DPuut1w2Ir2D0bTIr5cnIdr9PBbfISi?=
 =?us-ascii?Q?TBIRhWMn10OhkJiWzC27Cvoy8RJGXfcs5bMWumKfm8+69uGso5i2Fi7Ye/RQ?=
 =?us-ascii?Q?NzwA6kMiZmUf9EjPj6Ir3/OeztXYYSXr/WW+EYhHZKZspxTN2G0/IRl9bPlf?=
 =?us-ascii?Q?ui7eUL9SRNSBzlSrSBCWTFBcx5+7i2e4PLTPBzpuwPI6DFsSo5IBkf6qgN+5?=
 =?us-ascii?Q?FzpFEsQJKc0+0lHOkitMoTRWbtRzmX6ieJpt42OrkgXXo0NdHYeUvPRX7s2p?=
 =?us-ascii?Q?H3O2qw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d5a489-ae83-44e8-5663-08da6bbfaac7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 08:53:37.9305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HGyEY8AyL9Z6/QlpntnNTDR0NLeqzSh/+CAQy6pPUdgMpOipNr2FLGYrVh1VyK6mUnVf8Q2ERzQyJ09ILlp4Ag/oOwpAhowRvjgfNy+JCXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB5046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 04:20:27PM +0800, Slark Xiao wrote:
> Replace 'the the' with 'the' in the comment.
> 
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Thanks for noticing this and helping to improve the NFP driver.

Acked-by: Simon Horman <simon.horman@corigine.com>
