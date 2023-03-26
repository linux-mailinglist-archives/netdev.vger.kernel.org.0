Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB96C94F0
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCZODU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjCZODT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:03:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C787A97
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 07:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gpy0sYkYFPJcrIy+R+GA7EjtX7aDCM0tJK1hhQTa27HFX7MBQJm93sVtaZHQ+3v9BX6KmmQ4oSUmL35/RYQKK0zDV5JovEQ6IAzpmXhnghysv1kUv5tUqijIbD7BZquPtCSZbbbWQmsv+Q+zI0X7xOWR4INHWOcnOO6+ZSWA9Yxl4Qk3+ujWieo8gjU0YlLWzcCqXZ/XskIrNP+6a+/K2de7F8WXBT5kfkbJYFOSFOQPDLrGMpBEVoTpAk+jUwByp4DJIuEsCvrqGB/Izclkv+Rwvv1MWMipXs05XAr0vtbJtHMjYTLVwvkUaY3ZeUT6x+j27gyW86C4YgL/2x1pew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUHWkQdGPlyqyb6E/jlnxPv+5Y+Y0ULRWaWDFmTHdzg=;
 b=FjtDpRbO5e4+L1EUyY4S2/stGzkYEQgClCRic4B2dIi7N4sSPqD6Nnpd/FA/KzvLPsfCKBALphkmJcWJMpVCGxtGT2BxpcisxxGXBA7+QlVs/i0bg+uDvs72OfkKbknhFQw08Zrx8+unMsIXI8BtswfmXrNgv0i2SYFsoNiXEijmpGtMiuWG+x3pcPr2OnrbzTeBaGgCExCMZAzu6pPRanYIhkFEgVTr3U+9OJXvGrSUvi8uYzueCfd6N24luwXTeCpYWAj1GR8H6RpZLXNC+uQ8kp9vZPd+QCurRG7Ovt0RwZUNGwocoZID4dx9z2kMMVrRxi0b40PsXq1EUxScOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUHWkQdGPlyqyb6E/jlnxPv+5Y+Y0ULRWaWDFmTHdzg=;
 b=VYMQ14YAz6UMA5wEuazwNQEju3gvzzSB1hOk5XH1oNQhTojuXL7ywyl5CdAr+C4SwzmanQGGfWZQkttca6jkduY7mr3fGrdeCAHjTNBcvqSIu2L9yKUkHen+DgQoeNcn3LPEito67ZSLZFIfunINV50htujRyCBR27XtEiADOlU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Sun, 26 Mar
 2023 14:03:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 14:03:01 +0000
Date:   Sun, 26 Mar 2023 16:02:54 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 4/6] mlxsw: pci: Rename mlxsw_pci_sw_reset()
Message-ID: <ZCBQji3aUK3o40pw@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <7e957b01082f6251c2554f4299150e1821a5976e.1679502371.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e957b01082f6251c2554f4299150e1821a5976e.1679502371.git.petrm@nvidia.com>
X-ClientProxiedBy: AM9P192CA0001.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: ad776ab2-62c5-417e-104f-08db2e02cf73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yt6vUh5x9T5pOX50OsDff4RqZ1tyoDpFdRYZoWkRFeBA1BUTfIaaYZ81MCbFh7VfQT7vgFmmBKrPPIt24IkBzp/JwN+tEJNWEY/HNt5yCgt8H9nxUU+CCH8sSWESagRFvzF46P65kXiTIRjSCM9Ax7XHG57tY3rvZMsekp0z7nmbvgLQYsAb3G8KhHKxPKjWW+wox5l7izDm9DOWo2OJ5JahNbpiJy/Fr+4mMbFU7G3OAeqGDuKtg/JF/fRv9DpOueHrRHcEScTdjp2aWBxAMhp2+FCzd2CE/lSdJlBuqVeLZ5yTKo2tbzUHKaTRkG9FUozt08nKMYSaT7kgKZCQjhAS+sSpWPKIabA5+I4GpkdH12FbOTSK+QjUmGPvNnXh6gwgkTqn2tiL5FO7c2NMvl6KitAkFGv94DfoxNS0AKcTiRyFiDLC8qh7ztad83Egg8oJ67Bjq1J4s/IReeRgZYII8Kf72c+v/se2El2fG0jWXY5bUmnvEtDqueXB0JsjpVJBeV5FhjHs7lo+LkxQIzgzZZFJDrXh2Deb/jNefMFFl3FTPMFdfOhafXSTdBr3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(346002)(366004)(396003)(451199021)(2616005)(4326008)(66476007)(66946007)(66556008)(6916009)(8676002)(6486002)(54906003)(478600001)(6512007)(6506007)(186003)(316002)(6666004)(2906002)(4744005)(44832011)(36756003)(86362001)(41300700001)(38100700002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jt4D/QZQkavYnVTRr8BOwsy6q4E2O5kpfQpCOrJQY6SKsLFUVa1u3ygbYx6V?=
 =?us-ascii?Q?411QtaGrnlTfH+1AOPlPBSRgXktQm7+2ft9t8qJJCKi9qAmsaVD5aLoW93uC?=
 =?us-ascii?Q?zPG5+op5HJ4QAVTCn2Q33mn0GZfoA99m9UB5lb0Tc89D2gImGcPeQAEZ0hgt?=
 =?us-ascii?Q?aG8Os8jmqaPqF1gPI+O6n3Vu32wRc6VW4j3AxdJRKUk2JOr3dKh5ScvgSmnz?=
 =?us-ascii?Q?njCdpx/Oe+N76z13DT0Enqg4MR6iCfYh+Qls4aDTmh7yrbN3PnG9wmJymkrx?=
 =?us-ascii?Q?NA4tQBa8eleVvy82/mHdxXwPcX5uovQKU0UJSiiUhllv+Cc8bGHUv3XqIncH?=
 =?us-ascii?Q?5lMJfvdIg8/23M0nLrbEeEI6xZBfxqYzU4AwQOg5pSHoRMtuA9nFI7KFzJ2d?=
 =?us-ascii?Q?zY3hHxmvL3yJrSbhXS7Sn+zzfdl3/OEN5meV6n/PZUHyrekFF21cRv6aaxp8?=
 =?us-ascii?Q?gYvLqO2Kd6dI+qDjVgBMGsE5EspzGPYOIf2/Euxh5VzBDDotr9+nljjA7g0f?=
 =?us-ascii?Q?gc5lojFX7I8tjdwREw5vL7Pl5DuGuglqPnYfl1vmlNih0ZajxAmOG0d3DBmU?=
 =?us-ascii?Q?+zPr9D865c+dLskO0knQeT7TZ9evRoDv3jQK+Aws4XgMsUJQ6Nsj8CwRpmPX?=
 =?us-ascii?Q?axSOzDLj/3+WjSK2MfQwJ8+FJ90Vawx7ffATZiu7z0UrvTORYk0hHotFbyTA?=
 =?us-ascii?Q?4KP29Bg1SRgUncsS/mlLkvzSF4+0ZRVST5T4OJeBZbtUWuXbzRErhj24GLty?=
 =?us-ascii?Q?MeaQqcTUmVIAXLJvcVQBZcFQk50Q2AGZH3V5cjnWmS9FQ4Q286pmyk2eMECS?=
 =?us-ascii?Q?g/JWXvL437XfbngrR8HSlkIC5uMokBpEwzCGBHOofTI9ALuQeBm6tUrFPwvC?=
 =?us-ascii?Q?LDidD0qPnnd3B+ca/aCIk3BwJkmmb5ZpwV7nn3ZrpYCc0SPSiDAuncgp+9i3?=
 =?us-ascii?Q?l6X8bXZljG2LExQvANz/ZeL97DdoMHAIOC2jNkDe/x1UZ9uyzouwH8hCELI8?=
 =?us-ascii?Q?wHf6CY5Uh+o9cFk0L7bsPo0+mpH+CETyhK2GsYDH3DUWMY4F0jdCjeVouZnM?=
 =?us-ascii?Q?/bGzBsU3Hhve6q4JFrVYt868P6J+C2LkItu3hLdAkv4PkZCq1NluYhGjyRQP?=
 =?us-ascii?Q?p97U8S+m78LSpyM8azNuI+fvUwGxxafJaxEdJD9bFNsbjwQ1mdu5OVqwbBUd?=
 =?us-ascii?Q?4M6VIB9C5jucP22lZi4Rh14c3ntrAwXdCeu2VkaS8Hj81am5DkPRzu8aC0z8?=
 =?us-ascii?Q?Vjgq4MCSUEc2u1uHLe/36IX+XxDhDxY6Zhx25fZpFzpQjlvQp0udAIDm3YYe?=
 =?us-ascii?Q?Vo//TIvNhMX53KJxuNMFNEkf7Q0Q9x3pmccbZ0ChuToMyOPGid8ycOWcSoM3?=
 =?us-ascii?Q?AGAWikMrFMGS/tEN1RhqZmFqEWs1BSCCqf7f76Fn5mSV7m9QPzIsehub0Av4?=
 =?us-ascii?Q?QJzwdUPcoCF/Vu6SOKe1N33wq254yDplt0N6aNOEoPMQEMalUjwX9KX3r3DD?=
 =?us-ascii?Q?q8Wn4qb5LfTYYdvnvnSGBZxC8AoR5VrFpqTKkuE+xdGoX2sXJ/u5Ait91Gov?=
 =?us-ascii?Q?g5dbm7E4CMlIkpwvZiB8HX68/+e+mESnm3BQrW/EM7yDDH2mMO8GnUIbiCVh?=
 =?us-ascii?Q?e8P2zwjgtEgHZ7LkGdA/SXMnF+fBSTqOEftcZwldkiESZrbzw9zJ1AHn/pUa?=
 =?us-ascii?Q?loKRlA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad776ab2-62c5-417e-104f-08db2e02cf73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 14:03:00.9966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7EYGWkMBU2u0bBVcQ+6m2rA8QIVeZRyMtGOPXmkf7VOOcIKctLB4Ht2k9PEKgIMZ7EHCU3GZ7CjEEdYLEKNxqP7CLzxX//vffwbYE6RKoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:49:33PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> In the next patches, mlxsw_pci_sw_reset() will be extended to support
> more reset types and will not necessarily issue a software reset. Rename
> the function to reflect that.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

