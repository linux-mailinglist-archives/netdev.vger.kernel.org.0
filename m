Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83BB6C4FAB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCVPrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjCVPrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:47:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF06B2311F
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNMssyESnDlhYFVyNUD+O5vJviJxhtbZuoJIPsftoCPL0M4qEyyI6Iu25ZS9Vz50PCJpeHJvCeHJXZUpUO7U5THD+Em7/iyEESJ+T8inKw0wwYC0Swv1RwG+t7QkIfnJv7/VbHNo7TIDSOIEXo7Slp96YONJKIYBORSi0SIPshC5Vybn2Xsu4Un6DUfjzW6pi7WBGqnuSDf7tCgy4uL8+KXmsig7DczX5G4pAKGRy50PioSxBWx33iVH0iRcJZ6t4mf9FGUpka0QoNEtva/gfG8Fgf7DR1e1b8vfjUUNPCN1Q3qusM0U9NbuwrAN2EsPNYAwHjPx3jUpAyYaRoXnLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f2w2tZaPfGs5JiIYFlvB6xzIqODFNkpqnVVqmssmcEo=;
 b=XcNJTNhpi5mq1LdPqY2CZ1n75frpsB86USGxS41SaNbxrtITW4xX65eKWvY18NqbJjxwIgdI9CcFM/i/YRUumKoHOEZ0XJqRte8kjlcy0krFs9d/XZC1qyYpTePUrbk4Aff1p5FIvtZdXUhWNVXCcA8Z0ke0E2JyU+eboa4Vs1Nftw/houQiybLqifDaKDAEAE17aIAdokILtxIJ52lxWQVtCqeWklHTdX6giJtQKvTUOkooahfB1MFWCq0rm0/SwRB2ap+xJ+FBuR58tPgx+EhKXIdzcCSetvUMuaO7ZWoV83rgO3sDPm0ri5ytwhc0Gl+p1S/iTBEYSdF0X3Jb0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2w2tZaPfGs5JiIYFlvB6xzIqODFNkpqnVVqmssmcEo=;
 b=sYYGIC8Sod8Si7FQtJ4csIki2/tO2FGgQwDwjbMfyQLglGQM+9PgryvnDjW/nT1RXmQYgBmggtklFLRfB9LxHzWhFIo8wciG7suEY+3icjVDROdtKJkERLNOZtXgryS5tBy84PK24n6ccXGqn/tVb/uJxqB5jkcPmnpEfObxpGQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4473.namprd13.prod.outlook.com (2603:10b6:610:6b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 15:47:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 15:47:09 +0000
Date:   Wed, 22 Mar 2023 16:47:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: pcs: xpcs: use Autoneg bit rather than
 an_enabled
Message-ID: <ZBsi9gUsI9HsVedS@corigine.com>
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
 <E1peeNt-00DmhP-8i@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1peeNt-00DmhP-8i@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P191CA0003.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4473:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ae58531-5ba9-4b25-c210-08db2aecb1a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rdczmpRkO99TrsfjG+EZLL7Nr4g75WszFzeM8bznZ1NCtaTO2NG5zvXdwDF68M72YU4rokSPHxxTqn7kMOStvhH9ODekqxm6wgRpyDviDw1Sym8UNLO8Wp+oBYcYYqpdhyfzdx/oMn3ClncFjGRTbURu+XWASDoZp4R7UIeZeDDfMarpftrD49lW8+bzRk3Xk5rUNnSxizi5wGsiJHm09Yep1du94nTkaKimCw2IYztAacfnguURGXCHlTtvVTkGdhs/tA/88Odd0kwe3wLkc5p+0uK8QX3DoHQeVMHorgZjmbEW6q0mcx2Qnu8w2PPmiKNqP/ro2nLzEIldLjKjhsvUlJGZTWrKItkVSWUZ0vWONMwXcS8BompwZlQuH4VWfODJIfH9x1o37H6hy0R+N5SLdwYS/YZGS0EzfjYsRMnqgEwEuWgYvpGaYFH48nvb7TzhHGy/VLgOiPcVPgDtizmgdHpzWlRKGiEk+uAqArP2SeqZqDslr89SxB/tqV9A/s3kEfSLbCWJfuNNLCtYZx9svEWExJyOSe4qnv18bvUb5kY4k8K6s88EMkT/rXzPf4M75D1JvPdGfenTlBMev6qA+jYHHTbBBAlRnT/QC4qbz8tEmHxucPf6NxTz5Sw2SPrta97uZRnOt2iWV0VzTy+C8O+HgFRUakwnR+7qapR9oeLvKIsSWI1rNHqmljZu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(39840400004)(376002)(346002)(396003)(451199018)(54906003)(6512007)(2616005)(6666004)(478600001)(186003)(6506007)(7416002)(8936002)(86362001)(6486002)(316002)(5660300002)(66476007)(66556008)(2906002)(44832011)(38100700002)(4744005)(4326008)(66946007)(36756003)(8676002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jmi6S5lc4E+xaJDHo4lcbsACI7uxSBK8Cz807LL80pVLtvoiMxAFz5OobFsh?=
 =?us-ascii?Q?gv1ochTWTWjp3zDmAT96CkBVX6gjIqNGdiFxqk4UhNG/46SzptO7RDY2Mho3?=
 =?us-ascii?Q?Buv5ipMaXTc4F9DdKkLYA5gzakw+IZpoMrKWejt/HJNYhZL2H1IWai6YRDkR?=
 =?us-ascii?Q?eMXSnuJuQDTkwVMNkF8YHornSzOeOURczdxR4cc4o1Qj8ODDdr1c62j3J/mi?=
 =?us-ascii?Q?W0xIK8hBI/h8wdQSdW2RoVhBsAwUWu/cpvn0DzE2jr0TaCg9aLN0OZVVQLFx?=
 =?us-ascii?Q?cFAjtTpczNYX9EXgqLgvdoTnWi2Kr8axdJ3lvEdSo/oJ15PBtf5F6IzV0hrf?=
 =?us-ascii?Q?J0Ngr0Ymhxw7MixcWtNBK6J4eQDklPKrzI8X3sSkAo/iOXxI9qZNruG6d/1h?=
 =?us-ascii?Q?5245QT0IyDnBh0Q21n13fms9mrHml8hZoKs9TWZMokq+t8+5zkm0e1DpM8vP?=
 =?us-ascii?Q?bBFwgfjZyg9ioevNhIEoSqK0qn420URqrBIZxHPVz28qIigAVUh/PcwiELio?=
 =?us-ascii?Q?j+AJs5oepsV0xjvk4iJbmnaddlat1vqmBx9yvar3qzuWk+nDzxYMPruJ807t?=
 =?us-ascii?Q?wiyHL6TOvaCOZwZgtzs7iNfl/vMRHh6FKDUX8lK4UfM8Ddm+lOyPz4oJnrvA?=
 =?us-ascii?Q?l8jCwGLLVJGwMPn9HcyXJlhpeAU7lr6v6kCWaTVUbBJkAT4s+wSCv6l4bwaO?=
 =?us-ascii?Q?Uk3XhjuIpo17cXq+pVZNCY6mSduQ3aTaaQ+32ss0WcLhC9f8TG38hvEdy5Vx?=
 =?us-ascii?Q?kzTXRmNhXScOTyKLCfgz4YICOPpor9IXgxE0qW1B0yCMxUzILaF3kVeFeqy1?=
 =?us-ascii?Q?BfXp9LbrFgk7cCKdWc4Fr+8KMs4aMRc+caijBHl7fqzAzn5wBfuKdoRcE3t1?=
 =?us-ascii?Q?0OCAjQestVXB6WidPx++GlNPirGlrxLCYBrWUf5RkhpQTrMdOhY2LOEW6tpc?=
 =?us-ascii?Q?UNO8HJ1ExWMTBqM9qkECgNo9oOK7qZJ5zBs5TGECRJSB1jddaTD7Rb1uQKqD?=
 =?us-ascii?Q?2hzLwpscWXcU/5UcikPhmwfS8M1gebGBIyJEATTyAMtbzsTRjTuPa4lDEDM5?=
 =?us-ascii?Q?mmMAZLtulnJ93Nt/C1FnftxTtcljNLY50ufop9sgGgbUj01R98/SRXLidp4B?=
 =?us-ascii?Q?v2z/n3RlNkB40U4K8LeCjb+SC8cJ7ZLhTUevVDGhyRgphnerRE8jfMRIjJdA?=
 =?us-ascii?Q?J/b61C57NdQHKDa9ZcGEpsxTTw1TxDfvgbTiuUdKa7aeFbnTzbD3FCwFSeBx?=
 =?us-ascii?Q?8Jl8cc6X3q+1lvdgDV+6yETBZo6I07i+po7Lm4521SgEnVBYnXmr4C4MmTLa?=
 =?us-ascii?Q?cm2io3mxAoZ7xyA+DDFamrV0lPtyg7oA9yom0k00v89x4wOx5poKEwyyPpHM?=
 =?us-ascii?Q?k4eIY6kYJdOaJp+yPVQ9Hh88dzbyLCyMHILZkKmBxoeVVGsPGLv5oskLtg0T?=
 =?us-ascii?Q?9lT1Cv4LJwtwJ3gSWVr0GHcwZyzOESMt8jGyaW4TqjXdowjG1ibgUM92GlVJ?=
 =?us-ascii?Q?zcAmiG5NL6I0cTPnwYOlDAcpe17xo/HoUBi4mkW7SH1XoDCauEE6WZc+q0Se?=
 =?us-ascii?Q?QpBvh6/ar2GHRwdVIQHqwLDDLum9G0OH+kioPsnwvQLvfD7gDEwbStTNTTwR?=
 =?us-ascii?Q?l0tT7JQ6X/vX7vZhkHq5uUAq0kc2o3+T/fYl3vjREsg3dk73zQ/ZDGJmt9N2?=
 =?us-ascii?Q?IZkBOQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae58531-5ba9-4b25-c210-08db2aecb1a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 15:47:09.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfOYeI7y2NFzKWt/whP0RAgbPFcWvs3oFxnn5vBqFBBk2zH0GvNPIHn84M3yd4xo3VDjRZkrrovFPN7ZOTL+tXNwjkh6lBqG4SD4i/GeI+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4473
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 03:58:49PM +0000, Russell King (Oracle) wrote:
> The Autoneg bit in the advertising bitmap and state->an_enabled are
> always identical. Thus, we will be removing state->an_enabled.
> 
> Use the Autoneg bit in the advertising bitmap to indicate whether
> autonegotiation should be used, rather than using the an_enabled
> member which will be going away.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

