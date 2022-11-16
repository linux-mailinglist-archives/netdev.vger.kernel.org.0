Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03F62B0D4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiKPBzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiKPBzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:55:40 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2104.outbound.protection.outlook.com [40.107.102.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE1825C53;
        Tue, 15 Nov 2022 17:55:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mx5yoIcKwetcJ77s4YWyWHZbuzRwroQ/41rAJpwCXc1BnfYsJieAtQbBx9svgRKAoE8KPgntCRf2eWz5k1O8UaEW8JJ8fPrDWLkr7giRLDFpFNrHLwEmXNCk1+KATvqZJBCwyK/ra74gc5syREJQ/sw8fSCImWcFuwNIqEqqGU5VMbntskceENjzKXbrDpESQkMbGLfoNO3vjNeRZMHga1FC2cNntCghrqgKQcXEqZSN0bf7Ie6hmZWFxmy0Dt4Q4MMLwGv8uHxg0iI5W3xFRmAc7T+Ea13oJOC5CXzV9+jVWGkmOmTOYT7Ias3SxFJxLlw/fDLJVLxpWAQdNA4IdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5b3rxEsHQpZUn7YX/xfk77qqhfJhxIC0SnzkNzLjco=;
 b=Rc1ill5k5FfOfZbNAGDhdpAn0ifSVIQVIrao0WGtG35IQPRRI16y+5G4rG2KF3b1yOeo7JgmSDe9iI3U7wcNgUoSbmrp/XbEtTHXUm5AOg7udMmqE2gkLG8XjiYtzVAqoXKzqvXpL9vVYM7B3SYFrfjEavlmxfYozo/RSS9/Q+DB9W99FHIB9a9jkWeuCixmSNSa1BJovMXdp2F5XRRh+3Tz5b/ojIbbq+n4V8iMKG/n3r7kD9I3Lb6onKU3LgqjwxSNkJ3LA/1Cgeh8wB4W4vNIFtcAMoflUL9URKeEEA1MxMVXGWKYMrbMSCRDtHz6RCPR+0GmPh9M4Utli+rl7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5b3rxEsHQpZUn7YX/xfk77qqhfJhxIC0SnzkNzLjco=;
 b=QgJ6PPuu2FOvH5g3yotIjnYUOaJHZ8GPrhZklHN9GWmGgK1p5fuAU9Kmuq4V+GBk9xON2BZEFlAk5YixM81dpoKrJ/Lquq0qGEaqPmfs5mZeUW1vxQ4477f32g5DPyXPmXB4EnYnxUWcg8toC4P+xvj+cabXLM64zPJDElFHWbI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY5PR13MB3729.namprd13.prod.outlook.com (2603:10b6:a03:218::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 01:55:36 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::3442:65a7:de0a:4d35%8]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 01:55:36 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     arefev@swemel.ru
Cc:     davem@davemloft.net, kuba@kernel.org, ldv-project@linuxtesting.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, simon.horman@netronome.com,
        trufanov@swemel.ru, vfh@swemel.ru
Subject: Re: [PATCH] lag_conf: Added pointer
Date:   Wed, 16 Nov 2022 09:55:28 +0800
Message-Id: <20221116015528.25334-1-yinjun.zhang@corigine.com>
X-Mailer: git-send-email 2.29.3
In-Reply-To: <20221115085637.72193-1-arefev@swemel.ru>
References: <20221115085637.72193-1-arefev@swemel.ru>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::18)
 To DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|BY5PR13MB3729:EE_
X-MS-Office365-Filtering-Correlation-Id: b928969a-9070-478e-b584-08dac775a78f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6JzjoIx9fuX4lSFR2yXKLhtzeCx/LtoFc60gSzML/YVnyvhbKg7QSgeGkr7msB+Bc0dv0WzhJz9aS5aoD+1Axr5fDJv/9qNpq68SPNggVVK30hQyvjoy6YUq+gyAHlphea0HdaqJiD++2eXisXhpVp9fpX8gPUfvGFB/cqyc8W/ttN1N8JgbT+NYe3IzdAG7/2MToc0mFgzA3JxGr/sX/CXr5bqxy+EHMW4NDBpE6TeoWFRrjkVoGlUMhNzD6x5XU/2OALnkkOTLsdl+4P5U/xWD/0ei/+WON0v2/IzsA0oiVgtb1Tz3EtiVELSDuPIT/+JkvbuteoEC5L4ypEUNX3wICFfBiLrwGEoMQqPq1L4CPZB4WIdrfzmwU0+vIxtdrQAyAMorUWZWBlfHg0/u/Q2/IyeYgmshUmblkDX054CxxQz1B6p1AtCSyKPqJjSKO7r1BFuU7xInt2OiXd9NJJLIbnrBcWb224OjIG+5dY2JGUf/FVxoK+V1UEsMTSa6FqllBN+mpO9vEgR8/B6+oC/Fb/gUrbEVjsWPZShjkKcJX8NzPLcEhZCGoWmQUEWOKmIF0z5Te7/bEPc7SbcJNUKYtbESiAf+qhBZWvGklTLv4M3hFJoq5x7qGFWa/N29fKH4d0eXNuNX8XgKdHOTOpCH5mIt1TssIY1ptlAwYPE/3682VOBQdNUj5IIDw2j3mBQYp2MrdM6DrmQcOdrw4/Z1Ssq4J+prbFziTHfwVkkR4fhX12m2h80wzoea5BT8eaOwqg/YYB+AyqsZLQzJ3OB6tBJb5A5pxC1HLlDcOL93449m1FN3Aty45bPBnidj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(366004)(39830400003)(451199015)(6916009)(52116002)(316002)(6506007)(6512007)(6666004)(26005)(6486002)(478600001)(66946007)(66556008)(66476007)(83380400001)(4744005)(8676002)(44832011)(8936002)(5660300002)(186003)(2616005)(1076003)(36756003)(2906002)(4326008)(41300700001)(38350700002)(38100700002)(7416002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zQrKm6IhxmGLCyL2jA8Nflvm5i5scalOVe2SwHqlm0fLzA7l5DdERCS0xElo?=
 =?us-ascii?Q?UQcpnIQsEjqUp8yNVo8PZahz5KiielWnIsua5m51E4EmeXOjFkdUdsFn2AcI?=
 =?us-ascii?Q?qLiqbRu/hDMyJ0VsIWteKGNw0Zhii7blZk1ilHX6FHc0ME1/ZTr8ONGLfffG?=
 =?us-ascii?Q?MCCB7DCp93g6d8xlqaW4+UTCdX5lB/AWUCoolz9Lxl08I7F1iNBsBTkXGmXK?=
 =?us-ascii?Q?KTb/PCc0gKlokSigcLzp0E3xRkNN+AZ0wK1h62zKVYMQ85Xkf32dvN0XJhXG?=
 =?us-ascii?Q?TUm+umI4FsW17gkODIrjr65z+CjxScY4N04sQBrhjpKL6iihjprjXr5GfT+B?=
 =?us-ascii?Q?Hjmtcc7jYuqP1EoMCxdHnXbfpzTBHGsVr28P5hyMG/EmlXIwAyuU7Q3FOynd?=
 =?us-ascii?Q?J/b2w4rqyVQeqJvv/c2qtsR58o2C56zv9xksXtMIl+600xXt8698Fnl0VcMM?=
 =?us-ascii?Q?19q47QMy0qafKtGQzbJSXuo7CmU5bzBIZjj5f00hJHzz9gBooQeyC6F00jww?=
 =?us-ascii?Q?voMIOXKDDTfSuZEEj8irbKuuE92+EI8p6bVoo12+8HjOps/HK65iMYiRZudG?=
 =?us-ascii?Q?C5rxrG8k+8tZeSG70K/iMO/ZeOX/sw6mYMqbtYlp9xj3v6v4h8DphRl6aBS2?=
 =?us-ascii?Q?NtwYJOWuy2xBvHHecSzekYpKDzF5Fo9AIZWCE0Fj+KIoBUacDRZj3y+xMEJt?=
 =?us-ascii?Q?FazJUxk+5ulYp3J0idDQycDd7wYe8SD8qoHu/R0UrJxO8RACC/6/e4OR52J7?=
 =?us-ascii?Q?9EqLXMadZp4Gd5I9q9+wYRl27mLCqo1Q3MHKmY1uhBB8RV9F/h8AbSM5WhpP?=
 =?us-ascii?Q?DYccpWcNqPLcevQUhd+Xm4EoB7rk7IG2lVM+Ky4Sjv6GDGeuYSCnVKvlNXcb?=
 =?us-ascii?Q?nBivvxViBloNYN8y9/ZwiMrNNG39xhh3ERr9x5cmZn3z7qgxV/8k3QSJxaQm?=
 =?us-ascii?Q?XKM7fmPkQJklQdtsm8+IHqLUfnkou34cR/bIhoz2/8ZDD+JHa20A9aiBD53r?=
 =?us-ascii?Q?uu1abjMHafgWRaQmseLdCEcz7jxqQiImzqR6XhZ5CrGqhLzit5IAlAcaXcSH?=
 =?us-ascii?Q?F9rC+4ogJ59C8qFtt8el1743w0YsE3vd48ihKIJEHhCwCQtBI1d0ECiEc4CP?=
 =?us-ascii?Q?TUaPTfKZbuK6HE+5+cvHpdCcF8ythAYlVfT+aJBQEWBKEj12empJFMGNOVJX?=
 =?us-ascii?Q?1LV/EMWtYKE6HLt0xVJkeiOaFw6Fc0C0jgglIc7cZGbdmz/Q2qKlvPKJMZhm?=
 =?us-ascii?Q?seMTPLaf07Lm7JeehttbkiqzljNC04QUX87XQ7Fih8nrjnH2rgnPRDmEkqA6?=
 =?us-ascii?Q?yXtEtF8+PJzWXyMiGjqV7eNW6C5s9IUSeSt9xYHQb79Otq/B3xYCCWwuEd1u?=
 =?us-ascii?Q?rq0uqpQegWCAz0EhmYYPdn947zaNOfEAqMntSP3Sh6Px80JETJ2bS/JQmANW?=
 =?us-ascii?Q?fFqVNrop5W8FHr7feC11rI5VE+rqLVLBkk0q+VA1PSkF1ugq5U/LQnfzXMgy?=
 =?us-ascii?Q?P8vj8dRjYDzfmE1+YlH708sQndJ5Gmqft97CwndH5QSthb4ToBeUP3+HjAph?=
 =?us-ascii?Q?pUL6/7D87sJHW+qzIr6uJi6TOjyuFd4u+BrnkqApjRAkjBczVuPojnmYGP2w?=
 =?us-ascii?Q?Kw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b928969a-9070-478e-b584-08dac775a78f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 01:55:36.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCy8N2OVTrlk6z5d+LTFOX5cfx9BelHh9TI0d9o4XcUGbQrKW/tByXEIodQdjNsbBf1BxmG4BoXTgOtr8gHeEquWFALOYtp6SB65iZd+xUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3729
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 11:56:37 +0300, Denis Arefev wrote:
> <...>
> @@ -308,6 +308,8 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
>  
>  		acti_netdevs = kmalloc_array(entry->slave_cnt,
>  					     sizeof(*acti_netdevs), GFP_KERNEL);
> +		if (!acti_netdevs)
> +		 break;

I think we need give other entries and this entry itself one more chance by:
```
if (!acti_netdevs) {
	schedule_delayed_work(&lag->work, NFP_FL_LAG_DELAY);
	continue:
}
```

>  
>  		/* Include sanity check in the loop. It may be that a bond has
>  		 * changed between processing the last notification and the
