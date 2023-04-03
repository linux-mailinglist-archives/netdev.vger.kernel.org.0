Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2D6D4CA3
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjDCPw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjDCPwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:52:41 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7674233
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8HMnQ+3i12dumyWpAufpRAyc+5/rK0zFmZqIil7D299i8qkz/FU2EepvYumeYLeGb/TPqvmyz7zDEU6w6d4XAtPC6aPvmIqaXgXMpMH+DAaTGfMrulq3twTs9035O+a90yn94xpDI8pJxY01i71pACck3c+gRfNjL6bpR7TIziLA0dfALbhf8GVSEAK9IswtBKvtsbjO/Lm+Pmdy1/9Iabqkl34+RgSdgjMeaSfkoN5e9d/VVX9wqOBfmQ52C9sYUFrAjsB8uRqnQJl26qPLmpGn28lL2FuxTz52yKbNtW9LBTuo4QK65r/Xy7GZhKQR6cKMQiFrNiT1hl09eDT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIvdoodUW5/yNICs4uQ4wr5/7pqOucKFcKF5pfoDmyk=;
 b=hA+LtcTKTgcZ/fR4jn2oCJLptwjgLIOIhIqe6iA1smTYuCQkU4BKD8Ec3yueLEFqVflXN4M7xpfpA4yKZVXf/kJszBwc6RfTSP0dPjq0BB7UENeNFAiZryCW48f6H9HyxBLjOL4a9lcYjIFlf/nmINnUNXGFRYs5MYs4VrdtVgrR5VJCwg96AFRs2jqXfSw13A6drKASgsxspe80jfIrtnphWyS3KRAebP3SO+cYvplukI4MgtPrkwVLXB5JYOflHG3hbFTJEOSiQSmx04967V2x8SJChVw3wcNXr2eFE/A5RgE5/QPf5SVBBa7RhDATm/GWYTTwa8dfSmylkYNYEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kIvdoodUW5/yNICs4uQ4wr5/7pqOucKFcKF5pfoDmyk=;
 b=H85ICRLx95YJ8moqWzMd5MBUOu38jJpWyv0I0HJ49ckLdnGRsaOU5TznZQReHsa/37alNR/toyWpnkrYMN4H/38wlgjOUG5G7qjUhIP5f5fUZqcYYttlGuENB5ZWa6GJW/d6kB5JkEyUUA2gvGbcUHW+MuUncSXHI3WJst7PpUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5018.namprd13.prod.outlook.com (2603:10b6:510:91::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 15:51:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 15:51:43 +0000
Date:   Mon, 3 Apr 2023 17:51:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v2 1/2] net: flower: add support for matching
 cfm fields
Message-ID: <ZCr2CNNhfwLrlg3j@corigine.com>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
 <20230402151031.531534-2-zahari.doychev@linux.com>
 <ZCrolLu2cLbB0Xim@corigine.com>
 <fokufd5lc6mcexzte3x22dfd4x4sdjo3i24tjucdolfwmrx2au@3l45wabn7cuz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fokufd5lc6mcexzte3x22dfd4x4sdjo3i24tjucdolfwmrx2au@3l45wabn7cuz>
X-ClientProxiedBy: AM0PR01CA0127.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: 0224149e-5817-495b-cf7c-08db345b5255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nY8dGBI+CxKHGBP+lcsDBrz3v0L7u3Mjn3Txpckm9H5Wce1tW9wI9TocfbFwplmIcMKaQVvgMF0kkExDaxWldSVSezIx5OP4qezQD4BbzZwktFu706pzvIVQzvCjxejQV+tb6ic3/F/gjFfcFgSwDe8MGkihQoBXHeHEayqdoLyF/mZVUbtQiS66aqHvwU6o3gqoUgkqoiA5b2emrrhlLxjSIkbv334Xi63wU1J7vcoNTgnhuyDFt6Xkf7SOVNOvm2BTv8rAp3MLyYE7eIAEZioTVa6xHnsz+zKxHJ6h1rJ+B96NngWmJQkucO2lRLXzD8D5dYNxknlM9ws9MerY7xmjMaGf/XI67IwUyKQIgYBKEka1GOS821uubObIscJDeQBd1/0B9eF5g7qo3z+UhifV1WYxbJgAQ+AOtjqABapBTpJHecKCwJ2efu242ALgcc8j9nG8/1W5WURHLm6IxDe46O7ya6KjTstaw9waUo63gfgpwOBvK57qX9uuoJJopT8TzHuqpNqyWalJvl+CBSLbewUvG9IQR/i+pD9n9LL2+0CCRNv09x3yGn7dB4Xd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(366004)(346002)(39830400003)(451199021)(86362001)(36756003)(2906002)(2616005)(186003)(6506007)(6486002)(6666004)(6512007)(6916009)(66556008)(66476007)(478600001)(66946007)(4326008)(4744005)(41300700001)(5660300002)(7416002)(8676002)(38100700002)(44832011)(316002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fFnp5oLH9CpMg6YSpP+g4LhpFiHamHd1Gijb3NBuJa4XGeS+v6pvUhNqY6bB?=
 =?us-ascii?Q?MxZQ44S674A5wXO/uKDsmamdxL4IY/vnnBsHghekMTm4U2/XWTKvi0BaknHx?=
 =?us-ascii?Q?M5ZUzT7jxIq8QQLrce3xlm+wRCjPEbc+QOmhjxTEFUesF7pPaoVLvehOVZMS?=
 =?us-ascii?Q?cPJHm4Q6mmmOl+Sfp11Ok7G/E1QYiaMWef9TEJDM5pN1DzSnFWmJNhydluF4?=
 =?us-ascii?Q?swVbyjYTq1Eb3xNWyGvswUIiWb73yzD1sHlOIQ1tcVnSD1X1h9Aw/WrXOLfp?=
 =?us-ascii?Q?5SBbCemmHqOyDIPjg0E81Nwek0ajjeRXqM3qSQTA/rv3gU11yF12WunmDeIq?=
 =?us-ascii?Q?uxfyCByt8rosCH1im7XF+FGC6UpeSjkD/qxfJp0lqE+q8SJyqTaODTcLY9b+?=
 =?us-ascii?Q?8nrs1Afh82LyXiTSRQlMahT7/ZWy4n1g+0GPQDbEL7WSKDJn2s3sPWWUGhgf?=
 =?us-ascii?Q?/NgCE9/PjkCS8a+xPwCEKfO5HiWCkv+wgXopF8Q5LdJyzQtpVy1sYzgYl/0u?=
 =?us-ascii?Q?9Ru7RlZZfEVDwWh6kO85fg7sj4dmTUmENpMmFSbTjLFxtTkl0nSV3DMe6PZm?=
 =?us-ascii?Q?0qnEJM7rpgYeJaKglDtLzj3GiX9E7wv84SOh3r5pwptGFEcrL5XhEK7s7E65?=
 =?us-ascii?Q?UY6jzCDgIJKxWpOFZsJaF7jrwwlNh4YSAItxsJ6KHyNnLcO4LLBC8Q0Ldd04?=
 =?us-ascii?Q?8mKW9GEaV3DaRcv+L4FTK2tYtO4kGTWgLB0UcdtUX2evaFeQ4vXRd9chKDaT?=
 =?us-ascii?Q?ngFAAObSRgHYRq+HfHvdPh5LdLU3WGHq//fA6LpYKSTbBCFVSyS2NdcQjM2v?=
 =?us-ascii?Q?F3O5/RllQZXoKg/nKlIPZ+R40dUNxm9NU3LwrvtuKE6UK8qDzpnJdy3dWEJD?=
 =?us-ascii?Q?vE0D+JuQCcOCRwoIsgPJmyy/fYu274U2QDobxqpybkTseXe035OM+cUMLpmq?=
 =?us-ascii?Q?nZ6RIemPwaTNClUpcLbcVa+sz823o1y2GCdivPj+OXu1xgcyC489i5Y8NZGd?=
 =?us-ascii?Q?+zJlpxBi42MVkMr8iIi9dHtY54HY44bYfNQlbcUVyBDtQy7eI+AdBIWbgQ8/?=
 =?us-ascii?Q?CvA3CyLnusvyCBeSpxFgebFRknRH9oCf77OLPYd7+2vk/jAfHhZYfryj6in7?=
 =?us-ascii?Q?Ckx2Akj9u3miW4x5kAmNkVmesVENNbPdnyI7jEUMNBBip+T0Afpkl1pno6oG?=
 =?us-ascii?Q?SrjLKUIJr2ok2Bw41814F0KBQFy92OiTp+kwLvUbNjGOBfaUjB6RMI+r8N0d?=
 =?us-ascii?Q?7H/iQWDFrMtLwpXQgrbM1WbJ+df3S8GyTeyRXMrlHKfIxmjrOsC2N3XYOAJ4?=
 =?us-ascii?Q?zu5K/DyRbgqtZSSDpZ0UrTiieA9aGAP4goC2k0Cm+DS79cGgnenin0GGMgRC?=
 =?us-ascii?Q?WBqL2i2tsrv7NlLeJ9DZnnFuQcqreJCLND8JAJ+3e8wgXEXFtQc2o9l+KXOf?=
 =?us-ascii?Q?XMzCSxlqbGYIuKeC9Q4ERHF8LaxKWp9rAQi3istW/NpAXyvdPVSrP8zPCnEY?=
 =?us-ascii?Q?npdgeH5e4eQcJdMZ2l10oGq7yUqKE5rKgPUPlHooxUXNrCsgqitYr0mGkqAB?=
 =?us-ascii?Q?ctu/Pw2/AcCaUsSxameDL8uLIMSbHKPdaBXTwkm/Tryl3ujDicvSLQ3PnAZJ?=
 =?us-ascii?Q?42IFaadCgAvh5ltyW+ZzJvpHdWrFgCozENh2Ri+2LwiEiVwnrXZdCRJj6UKk?=
 =?us-ascii?Q?RXW6pA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0224149e-5817-495b-cf7c-08db345b5255
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:51:43.2925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYMPI3IFXWitPibP4JIqxQYCGaHXAtTbp6fwjP2lx4zWXFczbCNo3djVHvqKDBnzHkBqsZqWu1M9//lvq3MnmC6hUigAC9F2BN3BDlQulnY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5018
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 05:36:22PM +0200, Zahari Doychev wrote:
> On Mon, Apr 03, 2023 at 04:54:12PM +0200, Simon Horman wrote:
> > On Sun, Apr 02, 2023 at 05:10:30PM +0200, Zahari Doychev wrote:
> > > From: Zahari Doychev <zdoychev@maxlinear.com>

...

> > > @@ -1390,6 +1413,12 @@ bool __skb_flow_dissect(const struct net *net,
> > >  		break;
> > >  	}
> > >  
> > > +	case htons(ETH_P_CFM): {
> > > +		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
> > > +					       target_container, data,
> > > +					       nhoff, hlen);
> > 
> > I do like that you moved the handling into it's own function.
> > But I do also note that this style differs from adjacent code in this
> > file.
> 
> I would prefer to have an own function here as I find __skb_flow_dissect
> long enough already. But if you insist I am okay to change it.

I don't insist.
I like it the way it is.
