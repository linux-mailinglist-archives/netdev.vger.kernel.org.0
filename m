Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0846DC840
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjDJPM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDJPM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:12:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2106.outbound.protection.outlook.com [40.107.244.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7488035B7;
        Mon, 10 Apr 2023 08:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKROnHI9pvqOIDyLWFQNfwvjgOLQdiCj+Jwq+GaIKCiEPkJayRW8zZGVDvQBViIjHgOsONgE4CUn2y7IXjCfTSnstaiIubRTbEFVSHq1JTcHqPzn5dIv4dJXfDgnlm78Ylp5xslr6Peu2fjvOBNvU8QMFqa0+FkE1ySQfrExjJzvBBFfZSybIifQAMV74wdoO51/PC4WJeL8qwRkQ/SsxKhxs0gOWbxNGxjoRbX1vxJGgTjKWTfao6uaGOUXINtTkoS6WH6D/Ut/hw7i504qaqXpCwysBzCJzF6KcFMLJTppCuBBR5Q9yxMozY6qEx92fobP5RSuH8uy/2D4kX3JDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2XOkVrsyx5loF4I4U/XeYO4ZK+PLPN42PMPWmgUTnI=;
 b=db6UyVJuwyDqMd7E3KhbMm2ZCD1xaEaEws0+zsJw5zlaG+iThP3mbSh0PoSmD39vBTDuMEFmoNit5IK0C1akKcJd8DlM4fZwCl/RapwY6LrWe2JwAx/+tjg8bf1nOJbMn32djRX+tsjPfX611xBMD/Mtvx/j+hQng/wE4q0WQctX6hrkpuIWaLhrKOrwyAnU2Rp4k/Sz1+K+0Tn8k/Qts73035uSocjhRKw77atvG+RBTGirKEWnme5mcnTD6eTW9r7lsSfp99qH/Jpy4ln5HggRiJGRVl/aGEttN/2V5+7yGfBVe5KFehCiFZ2TTyE5rEsAK3msA+gqZY7yE9VRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2XOkVrsyx5loF4I4U/XeYO4ZK+PLPN42PMPWmgUTnI=;
 b=Tzn2EdXbr4ADiLlNF4d1bDWsuxHwIXnA2iILeUJWtWGpxJ+BY5w+mzNRiNgE7Nus+9YnryGVM9VuPR7pMiUaQOIUmawRCTTt2jLkrC9GBsHdfAvohv7igRNtZE5rMvtY16I84TrbOXtrlwFqS+qXP2NhfrNprg4fxI31Z7Ph0RA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5418.namprd13.prod.outlook.com (2603:10b6:806:231::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 15:12:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 15:12:24 +0000
Date:   Mon, 10 Apr 2023 17:12:16 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH bpf V7 6/7] mlx4: bpf_xdp_metadata_rx_hash add xdp rss
 hash type
Message-ID: <ZDQnUPVcKk4bzGFl@corigine.com>
References: <168098183268.96582.7852359418481981062.stgit@firesoul>
 <168098190669.96582.15579713988345319189.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <168098190669.96582.15579713988345319189.stgit@firesoul>
X-ClientProxiedBy: AM0PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5418:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c8b587b-d2fa-4c12-7f32-08db39d5fd41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 97L2T+v7iP8Jwq/nW1P95KXsfCHsBb9Apv1MGjmn0Qi7S1Nlwko6yCyokyTKZXoEcaqgqD5QQOH4HKUq/yRBp151sZbBiVlvzDJ+HKpESV3wXsLHe6rYLv1AgJ0b4lcqkEsuLx3IH27y49LzWPkyMJaqmlfJQsy/ot6PbttlTG3vUaiJ8UZlZe/syIhLynobL7T8J3LRZ9Mp+OEXJ/1N6aVX5+uL3kCTKfVFpZQjS+GWcbjlTLF0/bs/T2OxzxMf3zpLpUr6UcQpDubSD970XGVh0eB+8cl/w/c5ZHzbtpzn33vivmK/D1u2GvrEkaDmp1yQJo9oHboTnR80ODvD4PmDXWksn8S09vHT4MfZrF6dXgpylRIyxQh9C/MDdKENMTMYC8tNxqYUSmQmiqadvrBgHz44Wu8Qc2MMXL0+9sTv69CsFGX/YV2OaZsDCleItRMhzxkelHbCBXuxlh5yMTwPWyNN+WTW96NK4t6fDf5iSyShKeeqV3HGVR0U1gQQXTVdpz7y7FniiyT1nUvjZzM9xpEbn+Np1pDddSaXdXvibRAJPVfTI92DPBDEZb6t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(376002)(39840400004)(451199021)(478600001)(316002)(54906003)(6512007)(6506007)(186003)(6486002)(6666004)(2906002)(4744005)(44832011)(66556008)(4326008)(66946007)(41300700001)(8936002)(6916009)(7416002)(5660300002)(66476007)(8676002)(38100700002)(86362001)(66574015)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW5NdGtwSGZGUDFKKzg4djFXVjRaODFVbFdBbjdtc210QXZxeEtjQ1hzMHA3?=
 =?utf-8?B?QVZUalVUZHRnTms5OTQ3TEllL0t2SnhjNUVOYW80cktCbUJVNFFIYnROV0Vs?=
 =?utf-8?B?M0lHM3cyaTFrbS9OdkVXUXgrdC80b3VseFNrT1NHY3c0ZjNTNHFWckJLKzlX?=
 =?utf-8?B?bHF3TkJzNU42aW1PaGVZUkZNUnJPYTZZZHlWK2tYd0hVdDNRL2oydUVEOGpu?=
 =?utf-8?B?YXZBQjE4UVpBbmt3Ukc5Mjh2N1NwNUwzWW9ieWM0L1puR0lOanFDUzFFMFM2?=
 =?utf-8?B?cHJYc1JyM3lMYWlPajVERG5URjF3SUszaHZCem5CcDhTWW1HSE5XaEV2dkZO?=
 =?utf-8?B?S2x1UDZ1T2tNWExEbG83QmZLRWFVRFNZak9KaHZvL0pyRjQvMnNuRStjM25t?=
 =?utf-8?B?bUlaT1RvRTdQNzJRZ2MvL2I1V2EzaDhKTDQrbW00QUVQVko2SkFIdkU0OGtM?=
 =?utf-8?B?SmlCUnJHY1dIMzI4dGZVMjJwdlFzRmVpUVZEaGU2NUdlV2NOazU4aXN5U3lD?=
 =?utf-8?B?UENWSFpBMXgrOGR0ZkdxTjlsSk1ydFEyZkVNdExORVJyRXBINm1GYnU3MWJn?=
 =?utf-8?B?YmRBSDl3QWMyWFpaWDczR1cvb253aTU0VGR4ckY4cGtkTmRXYVNHSGZFbzVC?=
 =?utf-8?B?ejlGUmsvZEM5WHlHc05na3BCNDl0bXZ6dlI0ZDhobnRkZVorQ0JjTTlXQU1x?=
 =?utf-8?B?NnZ4cGExYXhoRUhZc2ViYnZybVZDcFdJaFdUNUVWK1VESGQyNkd1WXN6QWtR?=
 =?utf-8?B?VjZqdmtSVnJQOU5GTUFOTGtnRHE1eElrK3RBeXM1eG9ya1c5bFFvU3dpamll?=
 =?utf-8?B?SkRlQnUxTXVuWFhud3A0UTArV0xxQlVWdjhnYjFqWHE4NzlPS2NGV3BJTUxh?=
 =?utf-8?B?Sk9CUjNxQVV2bHlTRDNyaEsyNWo1VG1LcXRpN3ByQm5ZYkZqTHVibzJ2NGY1?=
 =?utf-8?B?dUdZcUgvVjBOaEwxU2QreGRncDQvYTdudkY1WForWDZCWUJDV04zV0dNM1lG?=
 =?utf-8?B?cW5PVUdTTnRXR2hoL1pYN3ZaV1Y1ZVRqVmw3ek9Ka29mam1aK2RLZkxNZUhs?=
 =?utf-8?B?T0Y1U00wa1FpcG9BSlpRYmwzckNTMUI4UmRCMk45dWtKSmhIRFZ2T29VZ1hr?=
 =?utf-8?B?NnAreUxlZ1FUUFBVK01CMDRnYXNuaU9PamxjbmhzeERjTHlZUmxUbmMweTZi?=
 =?utf-8?B?NENwZ0oyVzNKMkhqYU9zNEpzVHRIaEtQZlMvZGV5WkpISHU5N1l3NTVDVGhj?=
 =?utf-8?B?TE1nY0hpbFk4T2syQ1owT1phZnNCYlhVZEZiMG45Y1BFcmVtaTdSd3ZELzg5?=
 =?utf-8?B?UmNEMGt2WkZoT0FZNnVrY3RqdzBOTFQzTGkwSFVQakIvZThXQTRnYlZnN3My?=
 =?utf-8?B?OUFhYUdRcnVqOVIrSEgrRUZVVTR1aXEveHEyNDNxTFpoZGhFSzhMVVhCYUEz?=
 =?utf-8?B?enNvRy9KRy9KaHlxZ2hpcTRHcXorNzhwUmwyMFRWUS9QM3g4QWFMbVRXQ0RK?=
 =?utf-8?B?UVdtdG9taldnc3YvVDhXckd3bW9BdlcrZzllZlloWERkcXhqWWQvU1gzWFZw?=
 =?utf-8?B?ZTZTSm42TlJ5Q3R5aTVOMWU3djVjTTlBbDNnOXVGcEhrWG9UaU5XK0M5QUI3?=
 =?utf-8?B?OEZFTFQ1QmdWZWEzOVVUMzEwNzdVUFlLeHFOZEtxalE4eDRBY3lSSUc3aFJ4?=
 =?utf-8?B?REwzWGVKcUVScHphREhBZldMeFF5MHZsZU9oWnFFcllPY3p4N2M1Q3JlQk1r?=
 =?utf-8?B?cFVFQTNlQmdsYnFIemozQ3NHSWJLQ1lrSVUvdm15VjBpYkpTMG1XMjFWWktD?=
 =?utf-8?B?NW9GZVJoVFdtQno5OThKNDJLRm9vVTFZSlZqZFFiK1NHTGNkNXloZ3pZZ1dZ?=
 =?utf-8?B?QTBoUDl5Q2ZkbElhaDRmUWZMOG1BMVdVMjRtdXBMYm13NUFTUE8yd2drZkt2?=
 =?utf-8?B?eDc1TWlkTWp3dmhGNHJ1M2QxQWxTbkxnditkNkhZZjJwdHcwS1JBdVJHMDNM?=
 =?utf-8?B?WE94Z0MvU0FwSUJRc3pCTmUvSDZjaXRnam9DUHJnZ2VpZTVHRVRSaVpKRU54?=
 =?utf-8?B?YXBuWHc1Z1Z5VjdWcU85blZOMnBSeHpiSnZEeDEzQ1BjdWZldURpU290WG04?=
 =?utf-8?B?a3MzREsrdEdlbFZYTjBBdExEK09CUm95emxTYkdPMG9HZmlLSW44TlpwemUy?=
 =?utf-8?B?cUp4elNodTUrdi9KZGN6bG1wSUZESlBmQWluWWpqSTlPZEUyc1UwQ0NsM1pP?=
 =?utf-8?B?OW9sUDRXM3A4ZHBVYWNqazZYSzJRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8b587b-d2fa-4c12-7f32-08db39d5fd41
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:12:24.4601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ggW0DsdPkbioiTR7shuDl+FKTkpoADl/pFhDx3TBNGSt6Rz5rzakJzMCDwWrrLrmXXUZCxbpi2NVBHs3d0PwK4uryrwJ8INalRGth2fUyOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5418
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 09:25:06PM +0200, Jesper Dangaard Brouer wrote:
> Update API for bpf_xdp_metadata_rx_hash() with arg for xdp rss hash type
> via matching indiviual Completion Queue Entry (CQE) status bits.

nit: s/indiviual/individual/

> 
> Fixes: ab46182d0dcb ("net/mlx4_en: Support RX XDP metadata")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>

...
