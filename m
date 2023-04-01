Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8CA6D2F25
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 11:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDAJDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 05:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDAJDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 05:03:36 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2102.outbound.protection.outlook.com [40.107.96.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABA46E99
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 02:03:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzTc3dZIJwsrZdsvKGWXw33XflGEKUfSd7UuYddB401hkIOsP0xvmunwIj6YSE8uznJeovX7KX508IKxZ5tOYoOc9bX3cCMBc8h5K7mSakA88iCQoFLhPWENniMel4DVxEP0NPDMr3to/u3d04nRwbPPSHZ+EfMBacca2gayTL+EjvPEqV4GSQjtMyhofCVBOBx08Q7JRsg+J2ggnGsgYENZ/ReiGN+1Doudn+NDoC8sGm7eO3BIJkE3i11OGruNEFoZ0+7E3tdqHbxWou+Y4oAlNzg2LtN/GmtMDd8tTK1RdriICNIt+GyCYyk+wWD31vrlKWaBSqbDEqHopRm+Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j03lzofr57141ojfxjRABL2dJPrXYTOwmHqPmVPbHVM=;
 b=n9jRnD/Hv345aY/tmTnGUtFvyrMdkO2QmmDzyU7f7Z4xwvnpVGoerO8c4WCFpEWjBDj36RI+N7ua7tpIbwvcCnn9aMIdcHMXB7FukkkyH1Ogt9z4tTK/IOVteRbZOz24Efnty2qBCwb7Oy+4fTWpP+BHbfUON4q5ng31hYtFylzXaDN1jEds5R43/gr6FHMTq1usoXO1tOYqRm4dbwQ7gMg3u/+DNoVsS2uTk8FkWT2t0IUCztv4Y1/cmNzlZc0TMyZSM2ZLJTCP049QhhYpydi9OE8825dLZohSoumoTuAHcAEoK08eCR09eLCfJcAQEJfkMWpLrksMbojZXpn/jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j03lzofr57141ojfxjRABL2dJPrXYTOwmHqPmVPbHVM=;
 b=fw4gTfZC2EPj6b1xrlG8/73v6eY7Yk/A5N94HQDg630B/D+1+JWRN58xtLglFiCWfx2lEF1Uvgj24wU1U7JIX6TjiR/hHi+Xoonte8nvwuL8NBLNmaS4UDDZnQm/cMQjdC8ZkgGDUwdjMFw0YQHwyGWj4xEeSdvCzK4G401ptoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3644.namprd13.prod.outlook.com (2603:10b6:5:1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.22; Sat, 1 Apr 2023 09:03:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 09:03:32 +0000
Date:   Sat, 1 Apr 2023 11:03:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com
Subject: Re: [PATCH net-next 2/4] ice: remove redundant Rx field from rule
 info
Message-ID: <ZCfzXuoLHxoxqa/C@corigine.com>
References: <20230331105747.89612-1-michal.swiatkowski@linux.intel.com>
 <20230331105747.89612-3-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331105747.89612-3-michal.swiatkowski@linux.intel.com>
X-ClientProxiedBy: AM4PR0501CA0045.eurprd05.prod.outlook.com
 (2603:10a6:200:68::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3644:EE_
X-MS-Office365-Filtering-Correlation-Id: 53af3f10-2d39-4ee8-e1e7-08db328ff7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLqhVRRWHT3w5ALEJ42n+e/c86g5FdM3rA3yD8jpDV8/bujcmaFt3cScGBT2qVAsuaLYL7UXax2415q4X5QQ/SZIbrn0IcASebZlnHfwt5tnjIaN0nz31edM5VoRfoJKuSPiFi+zT8mSA2ZSQ8fU6kn304Nkuy59Y5FpjY4lWwgXxXctXN4bIRaG5o3FqVX6FdRaLWQVIUVY+rJN4j/WQW4TCjK4JxVWfCY33xopGlk3O4HbTeyrn76YP6XMZwSYpTKSHpUPjiRz0dwGQ8gTnpAgXcxCIJq0KX1pAo4P5tAiII4xeFuEwUv4MhXWlpurXvu/1luDBF+GAIm2csKoB1OUPrf/dVG1GMNvWTWpheg8Y7pR4/ppvZ2BF8ruZ+Cxfo6EmLVv+rYhQnlPkMXxR3v1rDRZw4Pl5Ayw9Y6jaGzzWYXvG7RNIYNgJnzWNqoA+xJclTBkf3k6Vl2eRfa30u+LwJmPFlY7bvxDnD4C8OoarTLsj7CnBNcLfnE+gnC8w+5qPPtHtlTcJ8+CGTgrIyx70hr53DfeyM/Y0jVzcHN+dcaRtmIoSiZdr18nPCBvev99vcExtYBCmbvGgbaTANnXW8JMDFkhFF/06Q0cmk8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39830400003)(366004)(396003)(451199021)(316002)(6506007)(66946007)(8676002)(66476007)(6916009)(4326008)(6512007)(478600001)(8936002)(2616005)(186003)(5660300002)(44832011)(66556008)(4744005)(41300700001)(2906002)(6486002)(6666004)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vaQYEoCqO78m2j9W1vTBt1CMieq2kNSkhMVMsRwg5kn2UdCBlle8476W3Vnj?=
 =?us-ascii?Q?AekbWrmEvQ+ErHxkjiw28H0oMwcz++ponzQv87xVtIrlbB/2DOHEGoTSYuMa?=
 =?us-ascii?Q?sBzCmXo8podtDB5XOUq6KPs50omxwLAw+3/4WHOV0juWisXFeHxFnpqkFHSV?=
 =?us-ascii?Q?4ZuXszbvIW/TH42awJ+9baMmfCoP4k5pya0j6hiI8oJNOiKoMgo6WJeKk/tx?=
 =?us-ascii?Q?hXr/06u0xiZiugGRS1xgwr4bchqKD8xqg7Qj7B2wLU/+3a8k8Xbw9+K38eey?=
 =?us-ascii?Q?yES+q1sbeuFy+MHPEFLRWacA38xUVXd37fzfbTDR4Ng2rdYe+C1FkMtsGS53?=
 =?us-ascii?Q?cc4tXtsmKLjSEtVXX2cbX4A8TKqx/x5hcl+uVTnDPE2AO4KTithDMfAy0eTr?=
 =?us-ascii?Q?aVeoEtfUKUfui/jlOIaxfSD97+jSzuCMlYhbf41+7E33Bd0M8SEStT7KosBv?=
 =?us-ascii?Q?rZ38/8ukyRM9M2Nt2bHZ74gWStjYTAQRv/uMTk6L4t0Tu3xk9YmmGBymClrv?=
 =?us-ascii?Q?1invwzHM+ERC0CWYLxQ7Q17/SxK3UOPeOdgfJUhrBSmQaj65khUNDcAdMsCE?=
 =?us-ascii?Q?njW4jlaxINqWlLkke/wM2OnmcLxskixuNnX7FenB6dY+8l8Gz0sjmcqNn4SV?=
 =?us-ascii?Q?2rvqRGGPBp8O0suJtwyve7wPhXDF5bBK1nVU5XAFFadq6Rpa6BoqzyjYEpsS?=
 =?us-ascii?Q?IPzVg0x252R5pgFit2fOTuDnqDIpVOz5p2Qf4sl2Iu7Iu1BqE9ZKUf9/NdzH?=
 =?us-ascii?Q?2ftBiscVVpDOP6l/M3vfpAYV3Wfo2az1By1w3gjRrMYZrHeDm2yxsZJxemBV?=
 =?us-ascii?Q?NCRKYhdrs/zfYMUZUCHXQPVvq4HGN4fOoS+a0kxuZN/ud+kp0wUttjTse1ZV?=
 =?us-ascii?Q?TVCD0TyOmhY6sZwj11WJ55JUfr749sanX4NMf7pMILr/hYhDXG8GQq7c2yxV?=
 =?us-ascii?Q?bBzD4KJ3aFUwYpl18jr361I2yKHyZvs9s6BeqmmgJc6xZdpSeHj35B1P5kFx?=
 =?us-ascii?Q?5OnMFxL7rQ8YZGy16a197X7803ix4qssSwxOxgGM+Ks2JuZfmDkKuJ4FTHSC?=
 =?us-ascii?Q?wi135KhkHH/azspBpak61ntRhfT3UxbXe4OLVo9TljBg9/YCe+ZAlTqo1LiS?=
 =?us-ascii?Q?+XqC0U/duogK/7OtzmsmLLQwN7gaM1mjfpeUrsuo1jwlkGyQVAXnRkg+wOUy?=
 =?us-ascii?Q?plmtbKBpvvRD4+oJxmQCVRkj4f2sEJWuUVMAvitZBjX8ZhIusXQ/UY94Qdi2?=
 =?us-ascii?Q?iANFBVMiMi6FcMlQZ9u9scNNwSNq7xs6RIqBviE9UgyvTF+mtttEaw+oSh0A?=
 =?us-ascii?Q?6dJZKITeGzJWeMPAUUZCwQZiPCgeTCoeE5rafwEEZKo2LcYGoonYM+B4LFeU?=
 =?us-ascii?Q?nXxLFyuFZlKdgtMlnlcR+4svf5REYFSpAmwBV/MUMyT0XkkAuJFOLGVV2Ycg?=
 =?us-ascii?Q?litL09XyRXFganovOSF9sLiiIT3ud74QXmpkS+xL00fbVN1y3xb/0WtS/CiY?=
 =?us-ascii?Q?5m4W0MXHnBoSLzGCjrCAEmNneif6SSUUSdvDfYGEo6l5bxSHL5oUzVoyU2Bc?=
 =?us-ascii?Q?MNsulYZSOGY1yUIBP9CgluJ4r4zjNt09A0ZEnPpic363pEz+zcJfFWkklBoZ?=
 =?us-ascii?Q?wC6Pn0SuLzP0XEfumf541bg46yCq+erh/Pq/uWb9XS4eDntBfAg2afe5cyXR?=
 =?us-ascii?Q?eYWaBg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53af3f10-2d39-4ee8-e1e7-08db328ff7d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 09:03:32.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kEwJe2HFpecZuPGo6PQJnt1h2CmrOUxGpATL+ulpYBrIFxgI5jnpFCN3cvWtvuc3siWL7ZNL5oLVZMI1Ov6/+C+tf90Brek8OBZQiPRVXTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3644
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 12:57:45PM +0200, Michal Swiatkowski wrote:
> Information about the direction is currently stored in sw_act.flag.
> There is no need to duplicate it in another field.
> 
> Setting direction flag doesn't mean that there is a match criteria for
> direction in rule. It is only a information for HW from where switch id
> should be collected (VSI or port). In current implementation of advance
> rule handling, without matching for direction metadata, we can always
> set one the same flag and everything will work the same.
> 
> Ability to match on direction matadata will be added in follow up
> patches.

nit: checkpatch.pl --codespell tells me that 'matadata' is misspelt

> 
> Recipe 0, 3 and 9 loaded from package has direction match
> criteria, but they are handled in other function.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

