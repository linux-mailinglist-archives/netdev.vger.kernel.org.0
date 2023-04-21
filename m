Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3146EAC45
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjDUOGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbjDUOGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:06:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2110.outbound.protection.outlook.com [40.107.244.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20FD7AA5
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:06:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hDLm1B4Yow1gxaj7i/CPjHmtG9Qlmg3z25UajR5C8afg8DJIOqd16IthUF4m5vGLOkOp36jU0lFRwzgeYdmJ7Ti90IaKqNW42f4uWMK6Ms33N3VLJe+Usn+cXFlc2fggibEKOFMBQh1emoYKM9jeMFy+bZG6TdQ/Qnj+4pm82WZTGf57lwWw0sB0AArjif9KbjYISbh0SWOVdhg2SfesVZZVVLWEZwFMjRD3M3J6qxt6pC+tdHQWPB9HMNkhjpoUdLihJsjqv3k4HwSTUpFNp5HoNl4YO5oyOKiHX8YVjEPPTfDqpWruseZ7BNn+LQ8+QY5BrFZ+j/8yX9q4JS6aKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4RDmpJVMed+uQYDqUzREh08kqCZOD9PCc/X4KDthMo=;
 b=B/03wDK/4jZ+J0mieU2ahyVIHDvWwnkh8zXK+i8tYWsNg0HF6jKE5W5ndEO9OVSiwSyIOXWLCYk+yF+PcVVIsBDCo1YxBptzIMkZ89JF8STGmtjPvphUt5Fgsam5ij7+VcSWu2ttsVLCWQ+Qz0CnRgNR9rlI7Q0oRyEzuzCgMHSEJ2f8bY+Gi6ln291yJneNVT5hCusqZxfUk3Gko9Ctxe3gSdLnsg5zZ6WXsrTQFL+DkoBJRSmoNO+jBSc+Bj7+C22gAEOJ06zBxgvMkzLKM0rsaE/ksjHihJ0HZHl1Gc10KnOclNsr9qJhyHC6p7WjeGtEnreTqhqa2ppsgj39hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4RDmpJVMed+uQYDqUzREh08kqCZOD9PCc/X4KDthMo=;
 b=Hvpr7C5yFlLmISj/3GVlR0I6ysa929ZnibjL7RCLYSP3bgRvn5iV1ElYa22xTpt+6Sa1BttxfDpn2TnhiXAyA8VQH7Alib3OCdo71WqOeL9UZQwX2rD9qS42C93+YG7dNSwGMeteL5o9lAPDyrEMAsJUHh8C1ycLIreeZpVdQcc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4684.namprd13.prod.outlook.com (2603:10b6:610:d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 14:06:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 14:06:42 +0000
Date:   Fri, 21 Apr 2023 16:06:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, netdev@kapio-technology.com
Subject: Re: [PATCH iproute2] ip: bridge_slave: Fix help message indentation
Message-ID: <ZEKYbNM60V9bbti4@corigine.com>
References: <20230419154359.2656173-1-idosch@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419154359.2656173-1-idosch@nvidia.com>
X-ClientProxiedBy: AM4PR0302CA0012.eurprd03.prod.outlook.com
 (2603:10a6:205:2::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4684:EE_
X-MS-Office365-Filtering-Correlation-Id: 2588f89d-d3b2-47cb-718e-08db4271a1f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EZgF1n/M9cKQNgO/O5PvqEvGiuvC1/7oHwbGW3yF17jGyoKF2/d2l7vDmivxNovGPPxEB+Z/ZBgPIoDDciKLdUBoPuQfMcnPsJ4dqqk8z+wITP7O5x0zoSkqFRqyp6CvUFEU+CmIjQ6ITky6O0PhuE1eOwHOqHk7OvBPdeRpne9P1IBqTLSnMrS8Vd0JfDQbTzNtExPOrn92teZfH0+6Lykx9gIembzlUmc2O92c2ollk1/SFfA00pBbMIhIzgQzwj8iVXT+GhOiss2h+Uok2f103//u0peB4Es2f5wFYAZ4U53vC+SJu08DUo/Zj0Gls3uKJmrETK7r+dslPHyty5vJRx1LqYpkuOoAaKfyeGwbaf7drvvhXJtP15CuMq4QoxSHQByRpxEsi2vUtXMFdqAc+koNCK4FoW5CHwA8M78vbj+m7A3VqsYAAmBGfI7S0mgwFDocht5BlG99L5lKqO+Ug36CFGKc5j6SBipwwbb4brE7EehB2PmWtt9d4V2BfSsASgXiTXHf1/UgFCUD5ntzI7cwThQYOPlLZSgzRwF5su2SKXWA/bZ8/HXFTDNg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(39840400004)(376002)(451199021)(38100700002)(8676002)(8936002)(2616005)(36756003)(41300700001)(6666004)(4326008)(186003)(6916009)(66556008)(478600001)(66946007)(66476007)(4744005)(2906002)(6506007)(6512007)(6486002)(5660300002)(44832011)(83380400001)(316002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sfr7ahXrxP8x2fs45NBLHPJV6oL+8zUsEfMKXNhRhon1FAbPF66pgkdBCoyd?=
 =?us-ascii?Q?vQQQBdgx+THJIUum37Yck8dUYVSnbUyxWuLneochaKIRla3gSmbuthKNeQw0?=
 =?us-ascii?Q?b0brJ9ZhlsAClP+VTQYgpY+UPy42dedNQC0gWIFMvc6DDEuMC8Bgw1xwQ7lk?=
 =?us-ascii?Q?nwsYf6W0ISFKx83O7wtur1fdIwALRQQtRbvqEhlQ4RwsdCy7HC9YFAL4i/gF?=
 =?us-ascii?Q?iaSRXLahRcgjIrL6Xqrm1hIwek5mRDJD52qYOL5XI0qTBc6xv670XhCNQCJ4?=
 =?us-ascii?Q?kd6kOWALmG3M5ZKfDvWDYupdif0AZs0JK1RJoQXW9I4Kh6nc0FhRoFum5mlA?=
 =?us-ascii?Q?ajZtZU+/LqN9naj2yTGKOM8lQ3YCUkykBKlVuTR3mp/pTT5C646A1YArg+Kt?=
 =?us-ascii?Q?Du9lKzHIoCAAnvxcJ5vDz4schaNbP2gO4/Iajk/o9hgzZKVWwQfASbsiahzM?=
 =?us-ascii?Q?3YKvuVbS5m/QkeDAMb45pzl9DPpMgg//53GUOLu48wllTNJhRnZK3x/MO+C2?=
 =?us-ascii?Q?nZI5JxlY+ICkwUMMdofKfHzbl67vVhwrm0r36oGTuRTYo0HPYKP/iYT/eBE+?=
 =?us-ascii?Q?84dBe+RSWzgJnipA2wxOdPyyfM8MCrVN9BxOoZbo3jtgYNFUy6M/gzVFyU3n?=
 =?us-ascii?Q?SarxGCSK+DbCtw0rs6PCc/9IZpp0pyf6tbhBV6yLxXfUcusKkDEoL33oB7aZ?=
 =?us-ascii?Q?PafMcTIoi/eZRW4j7VMwvWK7l8a2I6j1UNb5TigZgvNegv3vBFH5ztzw5hkW?=
 =?us-ascii?Q?+6XUGS9M3rVI40z/xdIHRyC+SO5iwfRXSvoPQWxiulFCSHfFh47ji83LTzHq?=
 =?us-ascii?Q?DVfapgu6VgTzNDC8lJvOGzpmnnJPo5iRVSCJrMcmpStHBJXzBXDUKsMbEc77?=
 =?us-ascii?Q?0OoyVw+JQOfdv6Wd/vISiI5mpuuwTKnyjynAUN+SM3RkFZpD87rwlEw3ml+o?=
 =?us-ascii?Q?sMYQpPq2kXVUA3uoxy2j3QXJXP5+phCKtH6/0usYUibkExVcaj+BCFpDULvw?=
 =?us-ascii?Q?T1p3PhcWVcMACdQT2sUXrAYS8+5K7B8n7FJ4uJCZegXv5dd6ZmaIDmryRhtl?=
 =?us-ascii?Q?LJP1VM6V8w3xkczrtnXTNo3HCcrTKGueSSzvcctocT/SBT4WJfw1g4XmCWkq?=
 =?us-ascii?Q?u8EOeXQpm0MLtMOb1kR3lBXks/C1tQ6MYOW57CbA/Kx1KAaMwRjNgmim/0Ua?=
 =?us-ascii?Q?Nudi9KzJTDT4dawcC2SSk4fYLJNEOZ87YDHg3KGB8irmAYPPVHNGhZnfkuFW?=
 =?us-ascii?Q?07p5ENzxT7XS/Rl3tk4H83NrxU/G0/PTOYgBZ+VvpOmfmHpUr0waRmKPEhIA?=
 =?us-ascii?Q?5cXwj53UR38LNOdCVASX+LBY627n0EzSsOZ6ain9i3eQAAhieLVK7KicuxND?=
 =?us-ascii?Q?aFx5tlhLPd3HjtW/4veqyA9ZB6uKfZ+jNzxADJYjCQdm1RRu8JUUAlY98CXc?=
 =?us-ascii?Q?R/1E6377tC7DKSiQuq8XrTRHWOvjuuZjRPzapVr+yHHaLZijLYiJtiKjOnWv?=
 =?us-ascii?Q?ET+kuFaSXP5MjyPhcoaAdcMLt1C9SL998OP2T+SStYKgAbwWW72IT7a0krmV?=
 =?us-ascii?Q?ZvJYBeqS3QX1uTiEdNTEralNJunr8NGzn6cGQ0mV4GoOk8d7RF4qpdOIwmI7?=
 =?us-ascii?Q?hxMwnAiSrRHT7GJo4PqS7t8ykawfigPYJnI6m8gOhOhMJN89sMiZ73RCEP/1?=
 =?us-ascii?Q?4SuVzg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2588f89d-d3b2-47cb-718e-08db4271a1f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:06:42.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blDNxTwDStR63RRDgSQyN1eQYo1oaoP3qPWsR7MEoxGEsfMeOB/c+krZsAWd3MaxN7BuYAS1Mrc7tWwpzVFHqOQrbL6M/0wR9F5WUb8OVAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4684
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 06:43:59PM +0300, Ido Schimmel wrote:
> Use tabs instead of spaces to be consistent with the rest of the
> options.
> 
> Before:
> 
> $ ip link help bridge_slave
> Usage: ... bridge_slave [ fdb_flush ]
> [...]
>                         [ vlan_tunnel {on | off} ]
>                         [ isolated {on | off} ]
>                         [ locked {on | off} ]
>                        [ mab {on | off} ]
>                         [ backup_port DEVICE ] [ nobackup_port ]
> 
> After:
> 
> $ ip link help bridge_slave
> Usage: ... bridge_slave [ fdb_flush ]
> [...]
>                         [ vlan_tunnel {on | off} ]
>                         [ isolated {on | off} ]
>                         [ locked {on | off} ]
>                         [ mab {on | off} ]
>                         [ backup_port DEVICE ] [ nobackup_port ]
> 
> Fixes: 05f1164fe811 ("bridge: link: Add MAC Authentication Bypass (MAB) support")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

