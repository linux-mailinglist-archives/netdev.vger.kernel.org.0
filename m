Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7932968A9D8
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 13:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbjBDM4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 07:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBDM4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 07:56:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2E02596C;
        Sat,  4 Feb 2023 04:56:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDSWEuFPZxI6WhJDgOfja/61LJ2VEEYuGPxygjncvG1ZmRPTNGXlC7gBEjEThcu4CU+gxHkqYII6W3/7IkASKagXlmrrhQsxhB70m0h9TQUa9UVUlg3WX5Asy+r9uK5/EB6oqMKeHXiafxLMmEm6x+optOXd0qfL7IOJ7JM3b2+8s200h1RU6WM/+KrcxLwhop/AnU6Xg3PEhG51ypl5OOZpsCSASRng812iza6u0U4QuNL2pi5Wc5VP5U0e6zUPFQHpthmiipq/Chl23GDVv6OGu+Z44tqwbljW0+zWlelCpjDKPVMLd+RmZhPenQlDtipX34WWutPBsbj5hOECiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayOvugje1SbgIk0Bufl+FCt1t8Hl1bAfkCWGMY5MP6E=;
 b=e4BStnwxQH5wJNhgkm6n+3tPtQA3MAQKMnwKbynGDPCmQZ83/ChDOStPReKQYhJLYZbAyxATGOE3Stddvy+6Y0j17k140/8zHTJLDVqNEVnFoQx9oV3faxLbd0Ap6UHeLjE7VC3534M2swqdUl7wVd601fcldUZZKBQF8VjdKVBua9IU3Pgix8vPcudsx0/0W/lvMb+GfxGlNPcXeg0y9+g/8jaLhx9vg14iKblG36btkxaWDdDy1j3OsxeFwTZDqVb9YS3WEcKnOZdF7c4wsR3cvAkMGf9aova9n5D8/S7B/ASfUAOEFQjlzcCj/gH1xgRfUqqrwPaFy5Lz33qyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayOvugje1SbgIk0Bufl+FCt1t8Hl1bAfkCWGMY5MP6E=;
 b=F22xxMdpE2MOLJcQTJVh7M7glCUfvu2F21A4n/UPH4JWPjsbwS9+p5TpPW3jSiUNSMA9b9HU4kgi/1w/YLllNI+o+Ut8g+UO4YWsWhJhPlogrzCnu5+N+f9W413j/Pzm0M2K6hCV3T8h3Of/+Q63th6/AzwW3QEPBFVLcCQo8jo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4675.namprd13.prod.outlook.com (2603:10b6:208:321::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 12:56:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 12:56:33 +0000
Date:   Sat, 4 Feb 2023 13:56:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, richardcochran@gmail.com, casper.casan@gmail.com,
        horatiu.vultur@microchip.com, shangxiaojing@huawei.com,
        rmk+kernel@armlinux.org.uk, nhuck@google.com, error27@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 07/10] net: microchip: sparx5: add support for
 PSFP stream gates
Message-ID: <Y95V+sTxDOm8pDj6@corigine.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
 <20230202104355.1612823-8-daniel.machon@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202104355.1612823-8-daniel.machon@microchip.com>
X-ClientProxiedBy: AS4PR09CA0013.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4675:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb59211-1489-480c-4742-08db06af3df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sJrSzA+oS/LdZxErdMVN/ukFMfPP2EzXXWxbf0onc/hIGBOTBRE65ngOpVL0OboGN/2OXOXCZho5ZKv7Sn4DdqReJyoL0iH/N10pERwU3W/hh/nEUs8gl49LG8FPsc8HKsEZscNIXRi4kz65ABppnXuNbAmWmr29r96NCBcMTlRuHkjXwh5pv+kXcPvdzZ1e8SfNV4NmcXednDZcsHegoao7N1QVTG29gFcmFPhJ2xHV5WDYCqPgsQrpVynkd8KjssdWoQGPKTYY1Kq6lFcZjo37ghKhPcLs006trC/jkckxCBMsKbXuLsmuGpjn753Q1B91KbO4wTKa55XWKtotGf9Co8QLlXy5Ptz3RhVsaxu4yCDjp9EkGUDvFHjIuTeyuJRcf0MXMC00uTdMSjPd8U2mUvs1W2qF8E2S7U6/KDI6GDz9Q+hWoPxxvJngEc18amji9KFPNUymX5hN5SgHahXQ31lkUOSUsfxI6Np5yZhs+f5+EBWWSyZ1GsRyQ8qwzBDO8+A48a6qXNRdXd1bn9gZxF9qwPw7gQfgMyLn75Du3S82ziWIbhhd29zBb+QSqF4fqpkPQdklKwK8T8/1mXV6kyYo4+s5+2rjQbXkZxoEL8I3JQWd6GOuQ4N6FDzldyRPeqd1DjOiu4Zq0Ye4v3XJTISChXxv1eIqmaJGxqavEi9xSXxRkdAeyR6EgCf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39840400004)(136003)(346002)(451199018)(316002)(8676002)(66556008)(66946007)(6916009)(4326008)(5660300002)(41300700001)(8936002)(66476007)(36756003)(86362001)(38100700002)(6512007)(6506007)(6666004)(186003)(44832011)(2906002)(4744005)(83380400001)(7416002)(2616005)(478600001)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ty0WTkeH1jUk8hkHr0RasHk0hdisVXkja35d/lIsZHjYE+6jRi1Agwzs+4aI?=
 =?us-ascii?Q?HHFcsm/09eq5cbG4QoZDTD188A1aphiNRLk2CM3Gq2OB1MAmVR0GjHlK4ZDz?=
 =?us-ascii?Q?yq2hasNGQg2NYHqRDVnDe48foCvZ8Kw+9WbVRJ5mYgb5BqWZzoWK7pxmCQkX?=
 =?us-ascii?Q?DWFshl4YSGmDOuZPjc/5xxX9x+wQh4qn8ZgcSs7nt6aph7idXs/m4YtIxDTf?=
 =?us-ascii?Q?I5pUPnvZTCWyl59Nt+a3xcTyfUG4xNuNeT72fLXtKUpg31EzBOHQ+kQhYEg3?=
 =?us-ascii?Q?dVIogoCcWpSqX+TNh+VxxOcT7/7hJ84K0EHNbKoDP55xDpoTcb+dwT2jg63/?=
 =?us-ascii?Q?wHpSEXiSfJF96zTNS2NDSNyERW+MTMy4wzMLEWPBx+i6W/AID8uvAqeJk0/a?=
 =?us-ascii?Q?w1VWVvM9QjZhPR/M6tf8vvceTdfollr65TEegMVfJNAqJjruT+A5VzvSXUAU?=
 =?us-ascii?Q?TfgQjaPmUCxLD/Awgh5TDsWnUbsDvMEJ71wrrxnEP9ZnB6oVO99Ek7CJJFk0?=
 =?us-ascii?Q?PIlRQN5SHWzQxkfhejzhXmxf2utfGpwufhuiyKOuNIVJU6nwnFjh3AVPqeJ/?=
 =?us-ascii?Q?Yy4V8R1o+pDp0pkbLOqQDbhTq6iYlqMWaX79kQPRHj9z3PgWL+hlx76q+VC2?=
 =?us-ascii?Q?5VgPDGYT5d/viJ9A+IQXA1SAl2vEfcsfmo2lp96DnqHGaMLpcLaHxyWZzMoU?=
 =?us-ascii?Q?b4YzfLNDfCE19c96Cqpw5jRUMLVBonGXssvAuV/l2pDEl1HaBXPkWR82/7ou?=
 =?us-ascii?Q?U/8yJvHcAe5gsvAXSREVZfU3gD9K7BGyUraGcwao175fW/sZ+lgHdPvnW+7I?=
 =?us-ascii?Q?NGVuk3Bb8KeaIEZAfGJ2zMBtJ3M+eadsKp4VWfSbxYcVtwfA62wR+ToKLPqE?=
 =?us-ascii?Q?Zwsu8nllv+8tWCN9nQhqFxFMUYhfEp+4ys9QHsdRGJcbgQg8bAeeEB801vI4?=
 =?us-ascii?Q?6zPa1gnGLW3spqErv9j1QL0edy4k1ih8Dn9HaqABTf63JTCbJhtBmB+wi+po?=
 =?us-ascii?Q?Hv8cqOC4QFcWneGzSemyxjthcgWZwDCJcDDP+SajB3qIXNBJBwlmF1hu/XGY?=
 =?us-ascii?Q?lmKBSdPYv9q+xjasOoDWEZPpNrT6tPqHFMokp4fHnR6f8bxWZ7BUAc5M85mX?=
 =?us-ascii?Q?DryeUYU/7BJkQt7N782DGbnDeMXE4O4YaeJND7rwvmAK1QiSSEdrXn6TZ4/g?=
 =?us-ascii?Q?gIRqoIW8pE70yJKW4zn9eKyrxYX2pKapAshGvSa6m+0kAs7tDTcm33eyfBQp?=
 =?us-ascii?Q?zE69Zsuy41BSK5RCobQcTlYYfZ9AqLmys5dEpPmwCpfV1a8b45hw/FzaGLLQ?=
 =?us-ascii?Q?J8UaIQypR5Y4mY+Ugr1hN7grhcqB98vMiB6Dq4jp2er6mxZCu/9cyFGUDTWZ?=
 =?us-ascii?Q?Jt8rbeJx35tqQPg3BJ/nRAq6Rxv5fCngY0B+r/mWXRD2PutJfpwfyzVoqoWp?=
 =?us-ascii?Q?x5OrTGmVHKMOnUBALFPj+lhkPUtN/DCMdN01igaQRIpUAhOdscHU2FtQ+OSw?=
 =?us-ascii?Q?2S6/VuFSR3OZ9wB65pPEMh6KL9wrQXqwmmkcBygjHz9g7WHQpTBKZ1GLdbXX?=
 =?us-ascii?Q?rI01Xnh/jyX/bJCj3dnA4JRwn0XnDZNbJswkhYngCPvFybyIpxVK2fiAdiJa?=
 =?us-ascii?Q?oYPCZxXu26JAx+JWNqZ01GsfBFnkXWsEz22/oQTAs6q4TgzSAUZ8g8LLoRCr?=
 =?us-ascii?Q?IMtTsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb59211-1489-480c-4742-08db06af3df5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 12:56:33.3627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZ0Gx4vPneSpemzSFVi2jurumoABY2IdYax1yYOcJY30Ob82Tmg20RenadGAMBALluPZD3bwRriqtzKz3R2Wvl1Xnj/uhGX8Ex2C/iFPCL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4675
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 11:43:52AM +0100, Daniel Machon wrote:
> Add support for configuring PSFP stream gates (IEEE 802.1Q-2018,
> 8.6.5.1.2).
> 
> Stream gates are time-based policers used by PSFP. Frames are dropped
> based on the gate state (OPEN/ CLOSE), whose state will be altered based
> on the Gate Control List (GCL) and current PTP time. Apart from
> time-based policing, stream gates can alter egress queue selection for
> the frames that pass through the Gate. This is done through Internal
> Priority Selector (IPS). Stream gates are mapped from stream filters.
> 
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
