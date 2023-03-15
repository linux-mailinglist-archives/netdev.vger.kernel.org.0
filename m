Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6C06BBCBA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbjCOSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjCOSxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:53:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25CB1712
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:53:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Izga2irw2LzSwu4ry+qtVJUljTHVpv3elMpsCyPm0NdYpRBjkd9W5bL60ZHKYFHek8WOSgZqEearRlX/idiJWY3CCiiCiB5c/J25B64lkDa2XQPClRUj83xavaYvBAP7Hk9cDD+lSw0r3bUiVOzNsFp4G5AK0nfwNGOXnlNwlXSn65j3+h78DNsF+BoY/OsTz/jF2L7wPBPxLKGXSrh6mR/kXPwgLsZg0GWrlnVz3HF+1iz55h6lb8yAnls+xZmZoUrHR21FQG9Xxd78cN2i2vw+6y9sZCsiStMbIfl60+1M0Bol1+6bEht4JaOMILqRwr1HZoWSIcBXQ2PG17yLwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SI+x0nGL2IgPCEHURBZAIOSOL1LBHiLMOMpyLmgEem4=;
 b=TUlT6DRsCEK10ixLq1E9CAldQkoWWj7KKtxU7DZzJSIPtarcKsaTG4VPRjHv0y80HxxUhGJBkVeXMEE0aHISf/sSL0Yxhmej+yotPVgoo9ltq/IMrOSZtSRmhdULPgZFZQyJSZQ7gIGIrYK+zKfjeAlDC3azUV3P01fPDT6G++785uZ0H14giyccBNhUuo28h3t0Koho4G7hWLJUAKRgMGqNQEMKXIKTLszT+6QBYPXMELWPfLksRLyxN+QHl4LMRuwTfrsJ7ZDON7UzTEzZsgqikuL1LzRvCyM7O6vMxf4sEgwHOVGyUgnHd4l0ARS1hjp3m87e9j5hor2WHm7CAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI+x0nGL2IgPCEHURBZAIOSOL1LBHiLMOMpyLmgEem4=;
 b=IRhUpOMnJooh/2S2BwenYz9mVT7+092Mc+h5Yjwgkk+3Fk0/gEogDgthCGgnXsc2cr3MZK7qlz2uPIzBFRokhySf1+I6ueYARDOcliotGUsL0zC62wfVIU+l+zeWazwJ6xZclD4BLJYDttHh1lYqGkweq8/IeoKDAICfGgFSVbo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 18:53:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:53:13 +0000
Date:   Wed, 15 Mar 2023 19:53:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 3/8] udp: constify __udp_is_mcast_sock() socket
 argument
Message-ID: <ZBIUEj9BjWnaaAZF@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-4-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-4-edumazet@google.com>
X-ClientProxiedBy: AS4P189CA0038.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 85ffaa29-dc34-4877-e3aa-08db25868735
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CC3jeubYAfATAWDwxKY9O/8ZKgVJL8drEVa/4n+tikcA2WeVvN05gHMxX/p33aizDFIwmtLu4lmJ9y7+noTjPaC81Fhis2s818VfWSi0lIPip1Ln3jHD6O0NeoZedkJo2TxmS75AQA+Ux3iVwbbALz6NXqjDwn8FUk8+aJywH8gA83Sk3x5mv1hRiEN1yPJ5UbFxgKhRq7248puKnX4G6k07PhB8Pu1BWooZxDtSu4wRdy8f1RqNUs+nVbemISJa1G8qRBq4AElMCpe9y9VFglkGhQkyNNBEukcHWipKYbk5HDALOiO29TFQ5H1d72a9cxVPAwj+bY1q3BipoEN91vnetK4rAbFUkgErTBcoLoPUYg8fzkERpt9TrbiITCrKeymtjpFpNcNqH89jlZt/waeadG8s+Vdxf3QWsbEKTYZ5Tgn4d6W92QY4Ur5VBGijUae19WYq+VYbUQ85KoDNuXRJEyp1uVtDNBQA0seHbmZSeM8vPMC14F1bjEwxCufDYE9Qi3etQMpwntinqVEwfO+xobsh1GIyt/2XQFPcOmU5w5fKok78K4gKucHNhTGMoFeNvH/5SnY/dkRMKyv8VEj5u231xMtby/KKwnzDHPJIxsTLn4hMxf5pWtiFtO4IX3gFL432GyTa3m+FYPMMLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(346002)(39840400004)(396003)(451199018)(38100700002)(2906002)(2616005)(316002)(478600001)(6512007)(54906003)(6666004)(86362001)(6506007)(36756003)(558084003)(41300700001)(6916009)(4326008)(66946007)(66476007)(8676002)(66556008)(8936002)(44832011)(6486002)(186003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cBlEsNl8B3Rf9DZvfCa0AeCriVwuDVeHJbohwxfzu7rKgB/+F7pEExOKxiwl?=
 =?us-ascii?Q?+1ywWGCkDGMhr/mYY5GNB50ZuchBnLxL4z3pyIWgPzNPiAwavjdyR3FEHgDa?=
 =?us-ascii?Q?AtaGr/DOxZrrIGCS1NUyqcb3JZIt2LVIv5khpHPBg9W5rgaxRNvOMhVncfw0?=
 =?us-ascii?Q?suXgk0L3dL8DadnWt3bufN8MrDxpt6CJAhDlgvAXGHOH/TLzsBoawSfQ8MD0?=
 =?us-ascii?Q?oI2dDsk6i5GlMr2HtDDQQiWdLp2xphXUZQNDnfTpFNQ8lbMjRq3nw65co38B?=
 =?us-ascii?Q?MNPwraFJj+a0RsvW/cguoYNUd6w3dz3h7DA0rjwVcixmMbuli+c3chfqAyvK?=
 =?us-ascii?Q?KAih+nchbhCbnAoZxFKJNBxkHnzFkCj4Xb1gRvzSFI4sAmS0yEjMfQsPu7iU?=
 =?us-ascii?Q?wj32CxRJ1OuwHR3iIoyhuaCWq9EAY1s0lOTM9zjpanY+76TTrbwmgEfqcMA1?=
 =?us-ascii?Q?RiyRmS6DULu81NetW75RENM3bnnnT3HWfEZtBxWDH7CYFHIc1Z0mtL7eABKe?=
 =?us-ascii?Q?mnhYVkUpL9JHexHOTt0nFiGmYhknmgHbK6ya51sBimtNHLEQPtgsOWgVnSWu?=
 =?us-ascii?Q?ME3SFuibryICPbrdve3JfOxfg1WE32HzShRx+Mzjv8Pwom2T8qs87zLENsGh?=
 =?us-ascii?Q?mXauXx7b1FIQiA74pZmcJeyyou/f3ZFaiOXIxsquIPd2vFgOw7HEpagcKCG4?=
 =?us-ascii?Q?4aEtG1W1rOG68ToN29iRV4U2Zi2qwUOsyelQ4mCDObRb4hNv6PDv2ppHCzEC?=
 =?us-ascii?Q?gG5JdpygkdiWQLhw4Hq4p7O+sF1eCUPIx/sKsF8wZzAvXZTqZWvWReHKQFjR?=
 =?us-ascii?Q?hu4FSbLfYt1sbQz6mUnPbi7F8R1fXK2dGBIoyQrWd7iNuRZ3ZwIKEQJYG+qP?=
 =?us-ascii?Q?U5c4gvu1tW9xdLsfgxz/VJWM/CF3o2y15x/LAk3lqOUiNPR9v1EXU7mgic87?=
 =?us-ascii?Q?zWxBn6n3iB/jCEY3Ykdp8IegBPVjMD0wfzrPH3MVMMXVY0Ptz0PKcoGgntvr?=
 =?us-ascii?Q?lDbv+r9cy6WYtvNxAd6rCBPw8CghbARMkFy9tYuDLM44wQa/fUlP+Klt6Fq3?=
 =?us-ascii?Q?7nVAnpop9bnwWMg6nW4btlK1CG/OR66bsLgQna2TsPe4KVpr/xTK3SItLten?=
 =?us-ascii?Q?m2gvND+TsWllDKnep4WpOwejgR9kGxSJtO9OYSk4cbZ5d7YYHY+gS5XwMCYr?=
 =?us-ascii?Q?893ZBrvugQSOIPgpr1qXtsY+XmdWUDQ5wyFOsPVOyIsmonkVYDyZk/mkqTVj?=
 =?us-ascii?Q?8bM3t14T2xoddmgAKRGRTx6/0uVdaENCtYo+gRDmg6CBJPqlm1TrwPZU3Jnx?=
 =?us-ascii?Q?UgrS/Sf4u3VDSK9P5jFcJLGLqByIozPi1uoLNbBeAF3fdU0eSt/AvcBiTWjW?=
 =?us-ascii?Q?VjbwhHzSIR9bGYR2XNa6S8OIJBG4ubEpoP513ScgrFoUveYZzFIqGugK+o0b?=
 =?us-ascii?Q?V8wn6AHHMekLgErnOo5uObzd8Z34TDiQfkHXvkNGkvMJSTHlegg4D6CqRmg2?=
 =?us-ascii?Q?H6QLAaKRDbUQR+7aNaUFX1Zx1+qtUfhy4cObqufws4cO8dtXCoqW7324sf7F?=
 =?us-ascii?Q?agHLJP3U8S9cPeGFAn74RG/UtOJT5lYOVQnMOr4qYqx+A3cpqWkm7KfANZrj?=
 =?us-ascii?Q?ypRNAiwmiSMN54WOc925Ux4PIWYkcUKgMEsUKNoZrkrR0b5YZsDqdYWENoXI?=
 =?us-ascii?Q?TwsL+g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ffaa29-dc34-4877-e3aa-08db25868735
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:53:13.0326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AUXHJn0QrHAauQvli03NtKjGmH9bRj9rf4WbHJsQjpqclr+t0budz+LE5JuCkiIiMRq/g1HVEMASTYX5ETZwXe6Y/yGVWXVj51i1bsLock=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:40PM +0000, Eric Dumazet wrote:
> This clarifies __udp_is_mcast_sock() intent.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

