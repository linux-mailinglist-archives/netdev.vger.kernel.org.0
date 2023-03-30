Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C886D05C3
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjC3NCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjC3NCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:02:34 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2100.outbound.protection.outlook.com [40.107.94.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0734DA266;
        Thu, 30 Mar 2023 06:02:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nccYyxDLWkc33P4h73/5VwOFz+8LZNQBoVtYpa7Awi7RHCUT0w9HWjOx8KNTd/yJChWaRGcOUzoO6lfss4FiJbULj0Ju4h4AJKYNiQPpk7u0/IRR8UEAK/MwMn7KwnY3KBljBGP5no28tJUUrrATE9bYwfIO9AAdggMKaMoPrtmvEZkL/AHvZtW9DtxOGRFO4b4Ua7d3WmIdvOe7s5ISSvKSfjUQeQvsY2OhrDKMCG1IXwh3nb7VwemTwCZLIggxAEgTspillCGCf9LUucgn93495B+oJDBUOr5iyacDOvW4iRZg8Hffs+wCdDaQx7HSOlqbHDjSzxNU4QVJBWzNxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36ydgif6Uj5MkSyC5HICKfQXM0iKtLTtTV2N9CJwwPI=;
 b=hE2L15eDXTCGAu7EDpOLJ4MCNESbxKhNGLK4pJ8XRqjGJElD6C8uJw1rLlDi9q4l8HdkGK9OoAdeqH6SANuUfaAoff6tzZFXhgi+DZkQ9cUEAi4bTvRZXoejbzss1DIG5G3YaYUBmWIgjJ2T+wR/nE0LUqZYshdjXPofNoIZLI4+rv6YWiM99x4NO4pfXsJHWpe3JRCIuHSYnOClJg7bfjTfWyX0oHf1pxatWP+mD49/P4DDPQfXoo9c67lSbpeumzXX6Yk3xkqSGuG89+akhzk/TErlId0igIf8Rp5SLmOIIOVF4UUYosIv6L+2b3/s4nZVBJWIkXfUK2idU/RVuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36ydgif6Uj5MkSyC5HICKfQXM0iKtLTtTV2N9CJwwPI=;
 b=o+6UunmyG9Ns/n4+IoDB+NQLNfjCK2W2VValZwQfB9zhdi5ydB7ZhexE7K2kT6mY8rGCLg2usqQsPKBUssAXGa6mJBlJkFL3ekDVk9uuBmkudoqqjZPp6GPMRdhPRHWEcV6WKcflmFt5A/zsbQEB/yUofHqJ0LCugqwIjAIyUKA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4434.namprd13.prod.outlook.com (2603:10b6:208:17d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21; Thu, 30 Mar
 2023 13:02:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 13:02:28 +0000
Date:   Thu, 30 Mar 2023 15:02:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        Jason Wang <jasowang@redhat.com>, eperezma@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 5/9] vringh: support VA with iotlb
Message-ID: <ZCWIXZbeWanvPJA3@corigine.com>
References: <20230324153607.46836-1-sgarzare@redhat.com>
 <20230324153919.47633-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324153919.47633-1-sgarzare@redhat.com>
X-ClientProxiedBy: AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4434:EE_
X-MS-Office365-Filtering-Correlation-Id: 26032a34-fe19-46f9-efbc-08db311f0394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ryR1tODxkRKz7B3qS8vc3PQccihhdY2l3tXOIAL/OM/HiY3yP+/wKoBboLh2j0UIrl3PMQfQJKhRpTC5wpoyNem0s6FE+zh/ImHC7mJ6hE0n3abUqDvrufvYPvnmIrQuIUEdDVRgwu8lSwydcxMSnp+eHzGbmcZiWpVa4fWitLXWepjBk94Xtfs/lpODIjQpd9iiuJiPxtczXNU6rti6MS6BGqR5OEGNOG64L82M1pWZOlmjfgaabsiEihr0bQj13MHZu2pPlSVx2IYRlQWJdCw8x/MmM66NMckrm9imE082afdN5TePoltTFZpMhZY9VT9pYMghKiVOB9VpDHCDITvcrUHCOUUWwR2bNpLRwPzXo3+32lBjhU74osU6apk+m9166CCEQibtJTcNhXF0SKnu1ANlg3Xn3C3OJ7npe9dxCf6di2/LatrqKCp39336KkWM9LgKrs0xGLugXYX75qPjxF6WSywCf5ZW0nNUjYnWYwjBnHx8vaAmeDTE/8hrvWI5inl3oRfx0Xc/MqdpjLn1s8lcutraPRAXcYlf26i3YSNnaDTdoYjE01yzhRh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(376002)(39830400003)(451199021)(36756003)(83380400001)(2616005)(6506007)(6486002)(478600001)(316002)(186003)(6666004)(2906002)(6512007)(54906003)(5660300002)(7416002)(6916009)(8936002)(38100700002)(66556008)(66946007)(8676002)(66476007)(41300700001)(86362001)(4744005)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7f3JjgG3bryTXg/nycFnwmqFsR8HAtHsKmqMUFx9EQtuUcxL3vRFbBbVtSq/?=
 =?us-ascii?Q?6V2TV0RBfl/jpX9LGBBsUWTGv0/BTIiw9eVaSmYUP82Tf7Ssebj2t0jsghNG?=
 =?us-ascii?Q?3SslzPIpV/pqR4M7te21ELvTCuoFgyxzg/wj0bQlsE+AARXZxhVrvsX2Ad6n?=
 =?us-ascii?Q?xfPdkASFcV8JKgQ5m1ukuBjc29PMA6TVD/8dvv4xaaVY+YV5NaAdRf+5KWHx?=
 =?us-ascii?Q?W6mmHShlVha0iyG617rvrkggwYKgbLMMtM+haJ8e1fISu1nrE+xTPOs885qf?=
 =?us-ascii?Q?9WEQgRO8S6Ly5Zyzrgi+nNTO6ryEv0Oz4eOzcnmtu/Y2V/slF55eVD6MMNST?=
 =?us-ascii?Q?xgaJQz4hVzHIXuiAC7OUj2M2URvyalpm1LXZuTLjEKNnMsfLmN+a1JkM6o6p?=
 =?us-ascii?Q?k4C0OPRO8MhQzq/ZFW/EZ6bOlzWUL7XOVVe0tg34b7rj4p3BjZkCBu9qe8g3?=
 =?us-ascii?Q?HESey4fHlob3zaHbttQIPwGZZQ4TcBAZ3ysFjf+RMbrV4AieFNDfTJPs8gXT?=
 =?us-ascii?Q?D1po1UkMKNkDv6qOIdpSNLK+7RgOhdQJLTmb6iGGoj0Mcb+YzsmgNlJcDxIX?=
 =?us-ascii?Q?idMAl+sTA5K6mVxiuP6go+iysOLXzVQQc8V2Igiek9nItTqBNsfXtluvpxdt?=
 =?us-ascii?Q?KXgEleIXricVA9Q0aYgdgr49E5TwGPNEuidylhWCMnMfHRQnp61DAGYujTVp?=
 =?us-ascii?Q?5vZX3zK0yZmVUf+vF3Vx7DduYxKa6GwHNMtMMfFfXS/scDgqtjvhNw5tZk2o?=
 =?us-ascii?Q?fexu79kiHw4TWdNAqFeD47WeUdrDgBJj+uTv0BxgjpUF3xSR9GutW0RKDDIQ?=
 =?us-ascii?Q?q/ctMMeR4eceT5cWAEMyFTVujkSqEnh8dCeRf5Z1Eg8o6KTEqvcu/CN5ETYz?=
 =?us-ascii?Q?sCfVEEawg2s+KL6OEN1MfKMd6/jB8d/Ef/2Z5n/ycFZVtg5DED2Ug13ld9hx?=
 =?us-ascii?Q?Er7RmJNFlu+NZDu4Af4hPbUF8+aCrYIhu7qSz3Gj+TG+dlO7c5W8HIqZfHhf?=
 =?us-ascii?Q?C6R6Qmf528TXLasqnwg+Vho2FGnz6m4M7FPjETuayxKtPg86F2mpm2G+cX2V?=
 =?us-ascii?Q?he0pWhyhN6FET4L3c5Luo4bWgVhj2b+dAVQhlsecbltwu6xl2D4dEtutWOVM?=
 =?us-ascii?Q?0LgftwKnPchghC0Cuq/68/wwXar91ooyR7sJVT/BUoQ46tl4DkIehuT1NEoc?=
 =?us-ascii?Q?auxig1I/QHNb3yHu9Cpo3vEHMUeU1uro+V/uumng9FaER04j0dpgvrVmNhLS?=
 =?us-ascii?Q?l8Z0GbN7S5IO3AkjYs5ZdQLGzNmMfvrchDlGYr21vek3DNiWXF+WpGTOl5y1?=
 =?us-ascii?Q?TLNp4EQuF72qzUyKr3lNewnFVrzpT+PX+g4ed0Xt3PsIEsnw1lw8MA1WHj0z?=
 =?us-ascii?Q?7nuPtC3FYyOOlcLeT6bX1l1f0ABDQFwwxC5+irU3FW+buvJN0cTv8Hb6QNTF?=
 =?us-ascii?Q?VGCIS4L4uQ3Fbo72JuKhWYgpavMGgEFlY/1LTcE2WaE0LmeMtm8+0tNaky0/?=
 =?us-ascii?Q?XZp9kbXYO93xRWJChgUgbEB3CNB9Svt3JXE8ZXzh9edJuE3b8KyOh30v/jIK?=
 =?us-ascii?Q?9sb7j0x0fqL+xXiFpfITKNiIKPZdsg23fxe09MG1UVZM79G0gdEY+MjKvXg1?=
 =?us-ascii?Q?yrBCRTPKACOQUA/6QeXkMOtuS/e6szg4mBBTePs/B7WQlLS75A3MTOqiI7OG?=
 =?us-ascii?Q?wPyRQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26032a34-fe19-46f9-efbc-08db311f0394
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 13:02:27.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOhvSfjnhQsUYpDGJ2hbmk0uoDh8QMBa7uw9UlvfmonDgDrdgtrIGzpVE31f5dY3rqa/O4HbzVVkPuyFElUb1xprAJjEuiU6YwP4CjN5nBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4434
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 04:39:19PM +0100, Stefano Garzarella wrote:
> vDPA supports the possibility to use user VA in the iotlb messages.
> So, let's add support for user VA in vringh to use it in the vDPA
> simulators.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

...

> +/**
> + * vringh_init_iotlb_va - initialize a vringh for a ring with IOTLB containing
> + *                        user VA.
> + * @vrh: the vringh to initialize.
> + * @features: the feature bits for this ring.
> + * @num: the number of elements.
> + * @weak_barriers: true if we only need memory barriers, not I/O.
> + * @desc: the userpace descriptor pointer.
> + * @avail: the userpace avail pointer.
> + * @used: the userpace used pointer.

nit: s/userpace/userspace/

...
