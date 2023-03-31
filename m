Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11796D21B3
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCaNti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbjCaNth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:49:37 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2109.outbound.protection.outlook.com [40.107.212.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D742D63
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgKEYm2ioEcgh72sc8Xfs8MNBpIZcIGH7yapYzjR0s/2RkaJoOuKPK3E3Xx9diNK6fxp+Nf14v0oEgfVc8HnnWhW9f4L84/QHT1A2+cJDFV7LkonWxgyBIplSzk9lVz7eQodJ6DOA8J2xHadM6wbNy/snlm1DGN2MTyxXsvzsZLrS6xJegzRi8g0aPU4q4Sn/M96AvGe9KYgHJZacU7cK7aKPm08A1snBUDKMzfBhyEQ7vbeZRlbRVYOHPSnTMNTygg7YjTVserPeNeVo/5fQxhlBskbD0Cbv6s21+6eisb+XPl8a829HnUyLY9H1DPWecC/B/jZcaO87jDQXE5jBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eBKzMt+O/xNt0RzKKam0JJoNWOyjX76cXB/EfDKWw68=;
 b=YYGrcSdMOMaxxG92XuFGKu5ux7i988tqnL53t2CPHEZ1gLo+b/Ck227+tE8yLA1WsPfGDZqfHusSQwzaUqfCFTOVBzkfKQnSe3WOL7E9LMDrc4jzP5rkt3C0PGgdfNxlHe+EK3MBhsKVi/3bm6dkSSVVERTV2oEJuy5ziDLHO3ptnOz8fbCJRAhocBaNrq6KA4ZClqqcir+3v4C25ELHqX8ViEWlhskuLWxZ+gfrEQUUdm8y9tqu+X5OASYnnKkpGzQGMyRnxmLJP1a5qAcGsJCzvlm0T9taKIpsnoZho8JEWsJZpm9ICKCATkhVfGvqweBqWvA4i7KbQ+PU5qM2OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBKzMt+O/xNt0RzKKam0JJoNWOyjX76cXB/EfDKWw68=;
 b=bUfyORRJWnLMCsOzaKqHjnDe8bo81v5fbvM+3Ce14X0HvswHe6GNtKFtU6uzszJpryI1345v4pN2jQ2iBzZ5mmoUP4IMKdJZwk6H8Oyt76mj3VPKHMVZl+EyTl9VfAxJ7HT1Q/TnrimWXp7Tyq3HV179YTzSnWzJDSgjgOvy/2o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5509.namprd13.prod.outlook.com (2603:10b6:303:190::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 13:49:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 13:49:32 +0000
Date:   Fri, 31 Mar 2023 15:49:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net-next v3 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <ZCbk5o96uyPA38o3@corigine.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
 <20230330135715.23652-2-ehakim@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330135715.23652-2-ehakim@nvidia.com>
X-ClientProxiedBy: AM0PR01CA0154.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: a436de84-5e31-490a-2994-08db31eec150
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHf+RIgIjx3SyPqD7MIOwyHdUi85SpRRYt8/GnuBYWVAny/SZjiXJ9Ar5aMfK1FO+pGeheUxfIN9hsFJcNNSk0jLALPj6i5Xd7HjACPdfHAh6YN24rC9HdnIndhleb5yBpc+9TgTq2b3I/B1sNjHjy9Jiu8QhlILJ42JOZNDPl96CoP7/RPOqB0OwGLWPAwf4A8FyYnHTC32Fd3OwT7Z2iZiK/iA8/c0Z+aXmvJkqZKg11wkp1UzoNTF2be7UfkIAhAHOl+kO8V4VKLZ07S8Y85qiNSezn9/RdA/nhY/UiFyDc2xelaHBodTRtP6tw69kBzhMq5UWj/2v4vZAYLdE3TrRkMC/YtsrCF/+cD2qzCONrJTREQFosfUe6SNbvDAPn2eeJlF3JEMCbx38KX/SQIHx6Yxb7ME+y0o/JHuJgzvBWB9RX8AjoHt4RThN1bS2D/rJCPfRp8LzRopUtPVFsigqz0Og1bItInZYmAVTrIlTDpm/kcOpYuLixs7HvBNH5blADzgDv/dryyF3G/cGjABJNPMoVhf66ytA8uCPHzy52I5Z0lMMslqrpq038NiUwigmgvQ1AYAWeZtcD6a/3g7xah7sxXPm1uftV4kWWk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(366004)(39840400004)(451199021)(4744005)(2906002)(83380400001)(2616005)(44832011)(478600001)(5660300002)(6916009)(4326008)(6666004)(41300700001)(316002)(8936002)(66556008)(66476007)(66946007)(6486002)(8676002)(86362001)(36756003)(6506007)(6512007)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rp1/YvSEabmU5oPrOXiAOw5oe97wru3ftwQ+nlQfbW2ip7L77vhc97BvTk31?=
 =?us-ascii?Q?12RTPInthF7iH4kKW4vODKZzNPvExqwGldEoFWGjaFieeBXX6P0boHYJA8bK?=
 =?us-ascii?Q?DPVE49ngWvDwd0DVqD1smBQXdvxsXAltlGQ+0Pb9dTZdJP9pyyIpOTUU87dP?=
 =?us-ascii?Q?w4rYcvAin8IjQ9bMcfV8DzrRwNpNLweaR1fbD14lLFJJbEaEHBiRw/+pj/0z?=
 =?us-ascii?Q?+iw9CGd2DwNn7S1bPEQwpX4Z9k4LueuiU5hmsW2YTW62aYPLhuL2Dp90bY7K?=
 =?us-ascii?Q?AHPGLALys8M+fSVzvqDjbEYt1l2siwkJoPxo7/Q37M64cYzrnlW8Lk42XqUO?=
 =?us-ascii?Q?oyV5BzcAdyKUoHQog/rr4T0G4vS/tNfz6gGZbZLDjO8QtfhrnNhYoycGpC56?=
 =?us-ascii?Q?XoYBIeq1wJ554yT831frdnZ0OVdtGN12sMBNyXqq/o4UUKi5zztHGCRDl+i/?=
 =?us-ascii?Q?vnpRvZu010vsHrbZRvLIWdHsh6O5vx/j/TqNXhaRsJsrJf2q8VipKv/y67PN?=
 =?us-ascii?Q?NI9/RhVWNAU4dijeFN5eHCDjLq877m3iq2/wjTAf0RqBq67fuKuIrgCLgjW+?=
 =?us-ascii?Q?RiQNv2Jbgi4GXf+AHaxUJnRY1SJHphnq5Nj9JpuFDZDBQhBgm1FADF9bKkhe?=
 =?us-ascii?Q?ylMPQEZcTs0hoewX7GQrrHeI1LZj+oGKIyHd0v1nyY9zwJ6pEAHmcFcGKtx/?=
 =?us-ascii?Q?1x3GmVMPii9ZLSgdSim80WCTo70MIZueVkUYYZjgwc9ZQHYmIq/Fm9KJ6GD3?=
 =?us-ascii?Q?fYJKD8Trlx9J0fXrtn4LK5fbN95u/kI9X6kq53YSB/MWxNopii2UfE7d88hU?=
 =?us-ascii?Q?1cy93bSj3vm6juCHRJ4dPnl5h0mA2IoevC/GGnwQ0j0tms98gBAOkQNmReGa?=
 =?us-ascii?Q?dgjAwR/UjsosZO9VJubTNFz5+/HsD76DvQoBqz7YnBOPBexiglJqqKPmKmAo?=
 =?us-ascii?Q?hzl9u3yS5nN3lMFAFxDVoJT6i+gM10/8QPz2TgP5/sU7VUO8mn+VrjBWICdC?=
 =?us-ascii?Q?fcs9+4guVpz8vg3xGPQKEaRtCQM/ce1JpJV8uHFSMcubAFgxw1FyUN+FNq0J?=
 =?us-ascii?Q?MSdLDjRANcMLEENYsnN2YkwXnA7nfFsLotrA84PabWXh3ldCWpZHhMwQh/WD?=
 =?us-ascii?Q?+Xj0OBKX3Afx17Pi5HPYLfe/8W6DBKX51px+TbV0SzME65obwJi9H1Pf5bmK?=
 =?us-ascii?Q?rCFs3Kst1yuFQkUxUcnZjcFCDA1lqlAEmGFZ3W6H2HZu8iqM/rH3W1IvbvLi?=
 =?us-ascii?Q?viqkimOthwQ09UpokKIpUhXonDaq3WyXRBfc2S7H7W4Vk+3by/hHOHGABQOe?=
 =?us-ascii?Q?uZ3snXXd8/+jzEwVC61IPfnQcNsDp+HHznYjuk1OgtzIryj3beS1md0U7TM/?=
 =?us-ascii?Q?/L/fGTZZf2bNG40PaZTDc5okMxp6d5eCBPjrkfF+hFoOy5natM0enrJesSC/?=
 =?us-ascii?Q?thpSNTCWm8rm1LUkoiiMNYLUvo3DFUHTPneexpXBaqkW5lCY8DeFjkn0fW13?=
 =?us-ascii?Q?mpaEV+Y4ylhsiWTuAml4NiFkXgsGgIABsLvbMEYl9d8VGDYaQZMGlf3AwN2Y?=
 =?us-ascii?Q?5RK1bP1UfK8njb5R0H+3tyhVLdAyRf6G1ff8Zc5Vr3wE+H6AeaHRA67Fqb41?=
 =?us-ascii?Q?rfaLZnXOSsyNAxl4Z2fjYDicb++z2UMuASLMwaSfPnhRECVWhtHqX7KmA8f5?=
 =?us-ascii?Q?8VoMRg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a436de84-5e31-490a-2994-08db31eec150
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 13:49:31.9884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkJc6l5i+XGkgQGA9vg9cScy538odAgi32yL0f1+phdX7UvFJ5u/AmI45ArF6kPHLv0nEMZY2Fkqr67i3qIE4tiCjPERULewC2mTyQdXczM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5509
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:57:12PM +0300, Emeel Hakim wrote:
> Add support for MACsec offload operations for VLAN driver
> to allow offloading MACsec when VLAN's real device supports
> Macsec offload by forwarding the offload request to it.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

