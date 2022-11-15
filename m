Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7AA629435
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiKOJWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiKOJWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:22:44 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2112.outbound.protection.outlook.com [40.107.93.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE1C1F4;
        Tue, 15 Nov 2022 01:22:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FA+sUUsbk6x3WXrTAwZrCeXdzULpHUfqITh/RCHZjPc2qpyFkw9KwogyAVaZgkn7CrSx3wVYae4ISObBrIhkH0gONS8LJ6n+g1NSkAJrtjKmsEsdv+t7W8rUSn1gRsz1xhsoAMZveU/+knQVIdBe1qLG/JdnVQAxyqWRbgNU7+Broq6kQkcAEGDNe/e6nLRLoh+NThCbrvHk7lhOXDD8+0V1+TL8I1KV55dSuT1R9od5DCV967xpQl6bS2Ip2te5PQIZfAdiQyhzAlMXf4z6aLyQzu8WWtwmsR6PNIFnAo4eKhKzFbOO7AX8DnpKwiMKcWF4BVexZ/ZSzV3g2EgmQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl7QSnzS48b9cyrDWcFScgDwMgPc2EhOzI+7s8x6km0=;
 b=OtV6eenMnTk5OZwdITfg+eEYV3IFVRpqWtOeBdYNmkWKYd3K+aQdT8Zt5uewXF4+SnWnFtzsMOm7q0qO+anci7XW90wjyhyqSSOtWaefteSUdSzwEatZhpWzxkSIiVMQl38gCmzTIjdZGI6t1nFe596RfXuo7YMdJMvDXFOLBdhs15emp3O/tajJJ6FeJAszw6arw6H799kpnSq9YpIGcZC/r9pk8sMjQvuBp7CngXO2t18Wopl1T7RsYC6FX/o/T272ifXwUnK5zZo3RD5CHDmSG5aPaf80aXEK8YHowLz8jEJxxdeub/6QEL9JMxC7YA83S/4oxMo3HUu/c4fIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl7QSnzS48b9cyrDWcFScgDwMgPc2EhOzI+7s8x6km0=;
 b=cqQ6S3dQSVnOekJ9siDyoCv3DTr2mcTK+fI3r7iHzOEfE1EepxJQ6N8tKZd+UJnQ5tK1pLeiFud469h7VExXvzcxTRonUaOpJICnYgLlXUm4HKU45ECtna89a/b8LJPCAWeWvxa3so5pNUdturreqGA3aj7vgm/TEObVpSz0Dw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5854.namprd13.prod.outlook.com (2603:10b6:303:1c0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Tue, 15 Nov
 2022 09:22:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 09:22:40 +0000
Date:   Tue, 15 Nov 2022 10:22:32 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: Re: [PATCH] lag_conf: Added pointer check
Message-ID: <Y3NaWM91RLUKFrLg@corigine.com>
References: <20221115085637.72193-1-arefev@swemel.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115085637.72193-1-arefev@swemel.ru>
X-ClientProxiedBy: AM4PR0501CA0049.eurprd05.prod.outlook.com
 (2603:10a6:200:68::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5854:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1a5ca3-ef85-4902-06a9-08dac6eaf087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QdKHM3KZo6yfYtnEC5knl1qm8tRjPNnB1TRUYCXqc82G//CjTy+qJxrhehbpWu0aPoAq5NFLX0kzjc6bVj/vhphQROsM4+zIi7v1tgOP39huL8XSVK8KxjZdyo5uysGv2/NHBFUirFGi1gjR4FgBNyh1FJCxZmObFOzfLbExA61dJ05vh5Z4RXW3xKk/qQjFSPVabhpqiy0bYfQ3qdf+/rWjOIWSGxW7GsymjrueRGhLucotYBlGVliVlpGaH/KjPx7JqvjCxnNepvXDc+Tyd3K2GYtROkt6//3s3Def+luvoF2lA6yTIETqB/ac+JjGMjT/dv8rY5MC8wTFnuiwn5fUKZjgq+4z2x4cZRXpAkGLgD7nyKrCf8KvzAkM9Z9Evn1fAFAkVBmdR+TJefKA167RojyOXVu2z5KEx4LTdN8cF+74RtUJCcTRWyroB+RgkdN8x42Qim6GZ60uSKm3srFKARpCYH7Zb8+F5kb10wKR5lhi7pCS5UtR8LbwDVq27FQqORm2DXazugR7no7Fe0XTeCYVqai52KNyjaiuNlhOXq7T7JD7z3zByk2LdPg2HyvmSAcS6DmZGBM5Im7nQ233h3r7A9RjFbItltAnd3feoK2TI2aqeEVIq1LIZFyhXH8TSGxwTI2NdYLKKxcX3OvhTLQvT+CKTsXgVXgc2qjYkuEx285i7M3TNu7p3yfYwwi401uf1AgL0MO0Del66g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(39840400004)(366004)(346002)(451199015)(38100700002)(54906003)(66946007)(8676002)(478600001)(66476007)(4326008)(5660300002)(316002)(6666004)(41300700001)(6916009)(7416002)(2906002)(6506007)(966005)(8936002)(186003)(66556008)(6486002)(44832011)(83380400001)(6512007)(2616005)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H8Gk9H1hEu27g24NWx9Rl8KI/Anq08w/gDPDSgqE3dI+hjjd4WERlUJinPX9?=
 =?us-ascii?Q?eOV41fo7rsYlnoj9qTbNi38EooFpj5+KQEY95jjYVRrmqVwhko/DcdgEI0Sl?=
 =?us-ascii?Q?f1DvkGr2mh+uWqzrA9J17VzYxwvvPl850ij/d46XJdCdowQZCML8TaCYwac4?=
 =?us-ascii?Q?GTJKgzRZV0G99stkhAboYy1lC1qrRJJlXivCHTd2Fnl9P3iT9JrPCjqW2oxY?=
 =?us-ascii?Q?2r1Gys7CGoyPJ4z+aj8/J7TUwyR1w4/VQ+WEPcLvLeFyhjIAgR1JjvDwNS6O?=
 =?us-ascii?Q?u5lLD/6JA3s/buCjl5KX4ehAi0zbk5lITzMkZTwazElXDlXI+uerPwHE4691?=
 =?us-ascii?Q?ph30uaXkTNcX9R7OJhQK0Ik2cPXVCd2eNQG6GwEqvqUX7l/BdruDxVeZOMs6?=
 =?us-ascii?Q?mXbEh9B7KVNuaFY7VRyKypWRMdfEiEbv7An09I1m0T4W0AEzWT6o6l+JSx8E?=
 =?us-ascii?Q?eyDMq8rFWwVOcDR+rCXN48lanrJIpmqOv0o7usnL5FvTE2+T6BsaUxurU0ij?=
 =?us-ascii?Q?HlSjWDjd3QANulGhW2reGQzjIme/neM0wS9LK5Qevh5Qq3GzQNH/zGh6mzlx?=
 =?us-ascii?Q?IxdMmRUvC9bnEHGjacrKUn3SFllLrJjiMpUYcEHMVyHVlcag2wCwP2l7ekAp?=
 =?us-ascii?Q?qlVMpvcrq3nhNwIu7+okGx//bxQlDXTd946K0sqZVxU+4x0Dz686i1VGHNou?=
 =?us-ascii?Q?axkA9O+SfAVcGusMlS/kbB1P6Or/UqPR2Y+g67p9v8TL03wm3YbUvS1ETKhH?=
 =?us-ascii?Q?YCxWpcscXzksfMQsvVyPWHoqNW/SMUOZjmJd2YI89BO8JBk6WJLsnUd+vVF3?=
 =?us-ascii?Q?XvQMa9zpG24+r48Iwl7oiQKwFixlaEpSKnjRmFSKD4FbiL8A1rTpvnUocnOH?=
 =?us-ascii?Q?tem447rWc5x5HUA2mnZ9q6X/iySPMj9KyiqvWx7+ufoIgz2dkMhDjVddB2xl?=
 =?us-ascii?Q?e7fqKJ3LCBgTUjU+hcYJSTKaExRSB0WwTRgptSH24qmrc0h0dYC8lTzS73yw?=
 =?us-ascii?Q?1vuNpdBWu5X1/Nxv9Usqeuf3IQZEJGZXXP8C/U4ZvTfZKP/2tVpFjmZNSC3u?=
 =?us-ascii?Q?Vd83y9FgFVu6oTtExvEljF7V6VL7xvw2xQMZ+RbnHwIjc3MBLmHeEVrYQpzp?=
 =?us-ascii?Q?iPJPLISWqLPfbBc207bt4jLtZMeA0XxQYo++mTxrNRTs1Ef27o5QYNunyNl+?=
 =?us-ascii?Q?lccB1LzeVkHeD2lYcJIV8rEnOiUmpOWs0PmdksblUfq54EjgEDpvPtl4w0bx?=
 =?us-ascii?Q?oQ0tkjsNC6p0aDucSU747l2HYJZaRNIsP/q+tV0ymDDsknOmA8jQBPz110NJ?=
 =?us-ascii?Q?lwX17mcxDELgPS9DD8fWXQSeELgLN+0ZRvedhDPua6LQ02kMZ5VeZde56UFn?=
 =?us-ascii?Q?c/MqtcIGYVISQCHEod+juNdZ9AcIOYj4bdZLWuPBcgcROqpfsbXdcoDEyLwD?=
 =?us-ascii?Q?EpH/XupW9KgQjSe4+WEwmyZlE2zcz/tHL8Hphya2bQ8WL6pJZw1dd72AObx0?=
 =?us-ascii?Q?6suRAJ1NXLfwE50VgOpXdDc8vNLsgGdOKRx/Xh1+cTwHMNyCkmegEG4NPJ4U?=
 =?us-ascii?Q?gE3OQ7nDO2uK+nfIHYGW4p5Ml6eXZd5ijgaXA1HY/bN6o/ZJ0xEchitg+CRZ?=
 =?us-ascii?Q?Dt54LPVOGqe/NLjN76eYQM8J8Q4nwk/lVBzaAPgr8NFa4nM2FOyL+MAC3LBa?=
 =?us-ascii?Q?NtvyEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1a5ca3-ef85-4902-06a9-08dac6eaf087
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 09:22:40.1059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGo6eQeNhYhOsXourtScdmAc6xwwMdYyhCuIOJD6Zq8vHEwaQo6Sp9xcxjT1djiNh01G6TCiYXESRUwFdWkslXexrlrg/k8aEi327kz9vaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:56:37AM +0300, Denis Arefev wrote:
> [You don't often get email from arefev@swemel.ru. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Return value of a function 'kmalloc_array' is dereferenced at lag_conf.c:347
> without checking for null, but it is usually checked for this function.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Denis Arefev <arefev@swemel.ru>

Hi Denis,

thanks for highlighting this problem.

> ---
>  drivers/net/ethernet/netronome/nfp/flower/lag_conf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> index 63907aeb3884..95ba6e92197d 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> @@ -276,7 +276,7 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
> 
>         mutex_lock(&lag->lock);
>         list_for_each_entry_safe(entry, storage, &lag->group_list, list) {
> -               struct net_device *iter_netdev, **acti_netdevs;
> +               struct net_device *iter_netdev, **acti_netdevs = NULL;

I don't think it's necessary to set acti_netdevs here as
it is always set before use by the call to kmalloc_array().

>                 struct nfp_flower_repr_priv *repr_priv;
>                 int active_count = 0, slaves = 0;
>                 struct nfp_repr *repr;
> @@ -308,6 +308,8 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
> 
>                 acti_netdevs = kmalloc_array(entry->slave_cnt,
>                                              sizeof(*acti_netdevs), GFP_KERNEL);
> +               if (!acti_netdevs)
> +                break;

The indentation here doesn't look right.


Regarding the problem at hand, yes, I agree that it seems
that kmalloc_array() should be checked. But I am concerned that
simply break'ing here may lead to a bad state. And I'd like to ask
for some time to examine this more closely.

>                 /* Include sanity check in the loop. It may be that a bond has
>                  * changed between processing the last notification and the
> --
> 2.25.1
> 
