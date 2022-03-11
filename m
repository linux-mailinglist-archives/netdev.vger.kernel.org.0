Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9334D6019
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238713AbiCKKuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347758AbiCKKuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:50:04 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B201B01AA
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:49:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmIFrAUM4dTPLE6zj0Fjr4pVnRw/0ckPysfZeuGi6QUl1Xo4fseJAAWfCQr0AWTC4iqV69ZosIa8nizONIwQAe8UevuWbdOS+zcFI5vTeoeI7+HLfwgL5NW03o/Vt6SmTrt04XleXHmvlx8T8rYFbJxxZnVpoE2UzKp6t95YTrNQXhdJNdu8M6zx42d6Z/yd8h62hOfSjBJTsXnrGqmQn978LrkftxI/iyKhxoJVJlnndkfn4hGtvXc0oVz0Vu35vMkATXmOqOyKQ0W9OkUyvCVZcYcy+nN4phE9s772Y8+2p90yL48K0ndRKwkBFRqX/V1riHTXJkwy7XcsERak4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZcXPJt4fH/ghOxuM54IynawcdoCYapE3dfJWkjQzWw=;
 b=c6QVERyWti5rtrz4DHMb+rPZGhM5RyKMsTH6+IGbjbOMSzaORPAXJ0+1cOYXhR99ey5OcMHyRrKt1DEuaGPBoSOKD6UVVE2xenBYhwqQZb2/XAlNslPO4B+dQ9Voe0Xnf5KwerZk+yJxhLE8rDZGqtfpbfX8NzdhEORGxASzzizZOmEK12pzVPMg0Mt8qQM+TYwK/ydzCM7ipHdOTiv6wRyn8bmrgaGYXTPtP/AkOhXwt+71HS08y+gmX4lRpVGnhJqq/payiO20dVgrWL8QndwdN87+FRCYum1EzRh6lo3C/mJb4/C+yAkCo8L8tm6euB0zvc9G4Aomf6TMXg72nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZcXPJt4fH/ghOxuM54IynawcdoCYapE3dfJWkjQzWw=;
 b=kQRyz/s5zNIpIEujJSzXHYkQ9cN1BmzWMaHqYVfMN8C/Lh4D39IMZ4BjN+U+NKWhf9/H1/Mp1m3F0uUqQ/p+wh0i33ZlYNrHrB6pW4j0qssZgP1lX5wHW723Cn3mQ/RSn9Hh8+3dBqc1xvHceSzzZrEpvxowHSHJpQ0Uf3Uy/h4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR13MB3169.namprd13.prod.outlook.com (2603:10b6:405:81::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:48:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:48:59 +0000
Date:   Fri, 11 Mar 2022 11:48:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     idosch@nvidia.com, petrm@nvidia.com, netdev@vger.kernel.org,
        leonro@nvidia.com, jiri@resnulli.us
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <YispFfBergpOXltY@corigine.com>
References: <20220310001632.470337-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310001632.470337-1-kuba@kernel.org>
X-ClientProxiedBy: AM0P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d40b1d6-e904-4ec7-a863-08da034cbf52
X-MS-TrafficTypeDiagnostic: BN6PR13MB3169:EE_
X-Microsoft-Antispam-PRVS: <BN6PR13MB316961E3100F2D80B89C62BBE80C9@BN6PR13MB3169.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RIw1hGvzuJ+vK0/CR2m+w63a2ubLB1kl2K38fhL+jE4Re2e12eLbRCOMJHWkSkTDL8iyjXRyO3kGpFKoZul/+WQd5N75It7LvdeU9PGqg/yGokDSz0r9IX+b5oHEF89hi3K4uGGVAscBlBGk5k0QDzDVkx+dEFSqYl/rgM1WhbmqogL235jgWOuGELqUb46l4H3N0GNoCzWSXidPtokwf6v5HCyCXy+ykjjVVA8lSme8A0E9CcHwnvx97sC7EHE6GVZtJtmZyiTNKyLmMZOaxFLw8mU3Hh1l3Dl32PNOTQG7K3lkjMN5Sw3fhiflBH4cRQb2yPNbJND2GI/MWhCvAwKxRBi4ju5zPy3hcDoOiUS2Uh7VmfpV2zawhc7Pa4QaHJwGCmtjejP5s+imdTSN+V5KcMtynTuCwhkrp6j0UXijNF6IzhwlpVOLa2TZQX6kxZLtsx+ODscMYkBZLBPQKz1aPzkxYxFPcm6asAkcHoiP5+AYIum/pIA4ClomMs3Ea4/Qvqzjc+jWEoRvqYdiRyeag1rKD4M/FL5w2wvZdYNDxjo9l2w+ZFVVnRKjYNhPkk6VosWvzzpRdF8pY2dBqeKvHa+hKRKdVCLE1BwSSd4o5KifnL0bfROynRWlbjTsZB65Y2POYPggbRZySdHTWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(39840400004)(366004)(396003)(376002)(6486002)(316002)(508600001)(6506007)(186003)(52116002)(6512007)(2616005)(83380400001)(6916009)(6666004)(66476007)(66556008)(66946007)(8676002)(44832011)(4326008)(8936002)(86362001)(5660300002)(2906002)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tBXRrzcs4qMvdLuGEv5dYKJZi0f4RH1CFusZsA6JN68naSatQEiz9ALrybW7?=
 =?us-ascii?Q?JbSXn73u9Q2PUD62fsDerBH8cbGZHDwUe7mujRpRAPHIZrET1a671EcggDoY?=
 =?us-ascii?Q?QOM0Bmp4uZXaQ+ngFHozAowDNqGDVfOlYtqQ95ibev7sskTRgrRG1vWDr+Ts?=
 =?us-ascii?Q?2jVFuS7j0fUKYHTqGKJpDYpthEHWgbcJ+hB/RDiRbpJkgPJS/oAAqVpu3Slj?=
 =?us-ascii?Q?It672YAkMiT0AZZ3i2kD5h4RhTpcTmNBFnMxuR9FKBzbngLhttRCbQJuQMxT?=
 =?us-ascii?Q?eZHNxf8ton9ntICXoG4BRQ/ZC53U5zOE5ZGrbk5DZnn4Jz+dP63KBlRaFR3Z?=
 =?us-ascii?Q?aRJ7NmWn6J7891a6LhUVybJAhNATO0cILSnTrmkZHZa0gDZSpf25NoDUt7qR?=
 =?us-ascii?Q?9hbBJ6UsBvOOrQy9l7ZtocDjMYyTVlpyMW4QpJ3rYlHZMmwezaNupGSkio/c?=
 =?us-ascii?Q?id3YzFMT58TuwUUjLfes2VHKAvLYsrgcspXbaNyg9uUqlxkjhDK5dD55LA4d?=
 =?us-ascii?Q?Ueiialg2Uekt8ItgQtawTfVmZRIRcMUjRk5T6gJwqp2HUJeVuJW7Q5rkHgP9?=
 =?us-ascii?Q?bYqM1vBnyAtMdZwkdW2JiKOhmx5IejAuk+VDoGACOlefX92DX9db12Rancko?=
 =?us-ascii?Q?zHSg/TQUy7DQwsCvVgLJdDvNV+NjKhzkdc8c2Lk+GQbo3GNXsLGEIwFvS7FK?=
 =?us-ascii?Q?B33Qufdc/HIIBPt7YQgrqFrZQqiVO9pqJbAqdJKl+upvn346ABexJp/tD/Dd?=
 =?us-ascii?Q?W6V2be2hBZHc00ngdojpo5QoJ+rLEuWaTUEtzQGcWyEbDd6QDOSQBmdq6u7p?=
 =?us-ascii?Q?FRlk4R5X4ShC2qFEj0q0jmaFQQafYD1UzshSWOS/D6nGcYC33cBSBc7/8wo/?=
 =?us-ascii?Q?8qPj0ln05dsTUnJdo8jfQmF65T6vrwjJvWWixcalNpsf8W/VmCmPTQ0yoLeE?=
 =?us-ascii?Q?6fNK0ZHyF7yZyDlKBLt37JZjCuVUvmuXRhpaXzjMfohZ2qgIEUVcmUx8v/Nk?=
 =?us-ascii?Q?7ippFJ6eOb9LBI8hUTNkqjJsnbudokn9NMfJ98bxXqSuVw9dTBkvSL3DmSQH?=
 =?us-ascii?Q?sAyCJ2t7jvnEiciHYiE/9U59PYDuUbuXR6RgRLDSJb2RWxbG6xoHCye2vqis?=
 =?us-ascii?Q?XSNSyZGRGo/ByVPIHM8WBhBnmkXcDpQ5TjzKj6/YEIattcOjqBg9GHflxg/5?=
 =?us-ascii?Q?hJMUGrhnBNcQJE4Dn6byPjx+K8ZWuR50Ysy/0RmC1vSxOuTcL72f1mSSgbl5?=
 =?us-ascii?Q?ROT9HoFfrCS1VEAEKCnjrlsXqZQimfSEGY3vrkNDiIjx0dxHL33rnXm9QOVx?=
 =?us-ascii?Q?PX/KJGx0Uv0raCQsmxqdaZkrc9fxOnYwW8sIRz72M3E+YdiNqWFtlD+FsQxf?=
 =?us-ascii?Q?K+Zw4PlNhjsbYecOCuEm3xvx7YiTBa6iD/WirAhyrsk3QThUh2xhqwKYyc53?=
 =?us-ascii?Q?hZlZmn4/ntQDh3ifap3seuZnsTAYWzyvxrI4nmBp5K+tLescxJqVHcqK0ArM?=
 =?us-ascii?Q?3QFVrMPyNBhk709dzVuEK8XXc9yyBhvm1lUOsf3QO6PtK22HVLZoWHpgFQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d40b1d6-e904-4ec7-a863-08da034cbf52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:48:58.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cT2OEbY+HzoE8Y9rdNZemAt/2dRjUtxZESTb96CoBwy1l3fk+WM4Q0TFoqeRgPwpo/R9X4vfxuMdo++CVDUFznO+MfLSEe9jfjrqMNupk+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB3169
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> This series puts the devlink ports fully under the devlink instance
> lock's protection. As discussed in the past it implements my preferred
> solution of exposing the instance lock to the drivers. This way drivers
> which want to support port splitting can lock the devlink instance
> themselves on the probe path, and we can take that lock in the core
> on the split/unsplit paths.
> 
> nfp and mlxsw are converted, with slightly deeper changes done in
> nfp since I'm more familiar with that driver.
> 
> Now that the devlink port is protected we can pass a pointer to
> the drivers, instead of passing a port index and forcing the drivers
> to do their own lookups. Both nfp and mlxsw can container_of() to
> their own structures.
> 
> I'd appreciate some testing, I don't have access to this HW.

Thanks Jakub,

this looks like a nice improvement :)

We have exercised this patch-set on NFP-based NICs and have not observed
any regressions.
