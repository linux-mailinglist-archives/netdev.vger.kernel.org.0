Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793556D21B7
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 15:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbjCaNud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjCaNuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 09:50:22 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2119.outbound.protection.outlook.com [40.107.212.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA901EFEC
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:50:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhqjKkdSGwmFmpyNgDArFuiPFknku96eRpEP38FNTUHHo8RyoKORQg/8jXrU1jIHpuRbwzWX6H8QWA4dntQIA1Izq+gOhBgpEZlHTagBa2jQC/gkEIgpWNgHlKWlFlePNYhYyiqavlmjq3xdj2IL/bnkVgDo+25Lf6GkwfKYTt3Cy06V6SxXOkEggpLuKANdU2BcrHJElPAnGXpFcmvYtjQjft5fqEOiO8/f1IYnTUXFdb8AwL5Z/rCN0tFbnLhg06b/OHiFHR8om3HXmc+VlnqwShlTF7w7Xkg8d1Uz8q9PRNh1hYgZT5xzSJNvTQy29+P03M8Uhq0bqBCBU89vJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maKwhTxSvTBFvZpz/TmTKbANw/fVMk8IFQSWPY49zXQ=;
 b=eSVOQaIl/vlTY5ePMvIcHc7VHPgVDa/LKHsFaPqmSbamDnS4BeUU4jinRn3QuE1LQP5uNbg6V21qPcTsY7cvK1uJstg+IbMVJEXKtk6EL9y5ELS4rUixqLYPmj0Z4yRHcd5x7DJzwATUWu+VDlzYmloOtba8OvcbJFUrAj0DANs9ymJ2EfLdeSGsr6I1kcJxovcLGGd3lT6YsR+TB7Kh8aCcfL3vnn52/8jl86+VJpiPxR6h4/KsLAPx54JbV5gdPd1laiW/isIM/rxsShy7Dm5DDGCMy9/Qq24fRSkP3vleo8EFKPs70F/ZAIOvYrI4+nQ96dspGc4bt8C18B1ySw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maKwhTxSvTBFvZpz/TmTKbANw/fVMk8IFQSWPY49zXQ=;
 b=dWNBKfhYl4s6TugOSyh6sy9/Ha8/ytCWAuzcmh08O9ODCPlIltFRP/wy0qWRPe76DGVe1zS27ujIDo29zjEHo9t6mh4cfD9q8B5IFgaJjxeIG0DO6tpIAltk1plD1MFJF0OlS1iqjQKGjXVR7LTMO/b6Dt9k/iivgTaQOTD36Gg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5509.namprd13.prod.outlook.com (2603:10b6:303:190::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Fri, 31 Mar
 2023 13:50:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Fri, 31 Mar 2023
 13:50:08 +0000
Date:   Fri, 31 Mar 2023 15:50:03 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sd@queasysnail.net, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net-next v3 4/4] macsec: Add MACsec rx_handler change
 support
Message-ID: <ZCblCw2BFaQaX4ds@corigine.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
 <20230330135715.23652-5-ehakim@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330135715.23652-5-ehakim@nvidia.com>
X-ClientProxiedBy: AM0PR06CA0129.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5509:EE_
X-MS-Office365-Filtering-Correlation-Id: 6082857d-9fcf-459e-24c7-08db31eed70e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arjKBjKUb3O6DTcKcL5rdeVZ9mRD9AbAnMsAOGj9WMRRfWYygBhXkjYGRS2Z+U7pMUMQy+1UiBtikY82OtYLDRuShv4Xo1sEKpVLMaWSpnHZs9G6En9SpGYMTAf3aTcItEaVXh2hWx7KTa3oPq5kiFRVj68ZJ0TC4QY/jGHu9sNccR77Tfw+UqwYwjjNLFNaTx3wdPxEe8PLNFKzqaMwkLrqVZiE40SjFSMglGNOGJTDaO4M1wb/hizfYwtcLjom4+4xQwIDHlb0q9F1P4Ce6RXn6A5XBsF9PCqqBZ9RaVNmMpBIt2ueXWct85M9DU0mVvY+8ti9Y6pX/S3xHNrgRuyKED18AeGHIkIS4GdiUsiCes5y6HOqLtyucrjg19PQUOQJO+ltEijtX8SieRMLDpnFwrZkLBVr9QpYqTbGUIAcqzb7aVaBLLmjzynmrVHA3YxxhAh36UHVkRIZ+LqJP6DgiiPOErbwQTs10RpmRHBC3L7SqaLKcv5rKI0QvhBUN9ZKuO4bleFxQWXiYRYM8McYHuKemNVq7umynfvf2lp0EhMg/LQb3i++F37LXWG8ShA2Sf9Xg5F8oIhXo39srMTYln4SEB7IuCM8olK8FtU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(366004)(39840400004)(451199021)(4744005)(2906002)(2616005)(44832011)(478600001)(5660300002)(6916009)(4326008)(6666004)(41300700001)(316002)(8936002)(66556008)(66476007)(66946007)(6486002)(8676002)(86362001)(36756003)(6506007)(6512007)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/p9SslYYmKlNL2CzK8daGtg4CmonKLwtfLeNiwFJgaDYJmUBConw2FbirG+C?=
 =?us-ascii?Q?bkXhXFV/jtEh0RWVICVlHyq3YF47m8yZjKaQfRDJfcyu1UToDJSeZl5ww/Kp?=
 =?us-ascii?Q?fnXjNFWX4aMi7pn/9XQ+JmNjzlsPzYsgEvEn6uRmGR5NnbW7veu92lejSQYP?=
 =?us-ascii?Q?WecLusbZOpH0GHSz9wSlIZvGv3RhYvwy3BpK+jwAXSbhq2J3owgmOO0IcSId?=
 =?us-ascii?Q?bhy1HoJxuU4UHeGVgUA3/r6JAjNpj30ANs+2+t3KmBo+LS1F9HS9Xw7lwz32?=
 =?us-ascii?Q?JkJ2Ki3mGojekvXHUoi4bafMgB+cmTLsHL1j+ZzIu/NUB/yiDxb9q800+zha?=
 =?us-ascii?Q?jxuxGRqYtIbowMvAdXo4/WTWiWGsfvMCaMEnQMAbhPUkBvDmG8pZM8qvkrtj?=
 =?us-ascii?Q?+vNjq5BP0T8m9ABaZoQTw+bZ+N50lCY8nZMwvIaxpwIa+NvJ8mT36Ggf61ZZ?=
 =?us-ascii?Q?N1EmiZWybB0XDtsrJWnjDpfVzhlLP6Js/0WtYLhNbbVQb8Jzx+jA7jRz/VGg?=
 =?us-ascii?Q?nJfA1wKM2woyiFd+ajrO4LIWU1t9w3is0Ocv1gv6l6j1d76SGV0nTXq3flDj?=
 =?us-ascii?Q?lLKvVmijqxbS4c3WFMvkgsXwsjuW8qiO2nUzQPRmKEM0KokCfofUWm2tDFeE?=
 =?us-ascii?Q?wmdQ8TcxdN2UF/umhoNqx6yv6bwKjkwEddIcAjlCD1sWjgNjmYnDRhVGXEYd?=
 =?us-ascii?Q?AFgwE8fmcPmQ2bi1Y4+/eaV0u2B1HkMoG6hmnAIoEDpRJdWfI7fJ3dXV3r/u?=
 =?us-ascii?Q?4yL+bLLygOHJHVLECrTZ4zXPrnqwfUMJ4qGicZ/T71lCiGAcPh56iJlNk2xr?=
 =?us-ascii?Q?wc1+XM/11LPDvXdO3TdRNPckTBVYtMyxcoEDq1xJBWubQuiW3GmO1tweArLi?=
 =?us-ascii?Q?I6VQUfRQSLerG0LZbGvd3H3ysbEzS5HPCMJdiafPsurH7RHQvWP+asXmtwuY?=
 =?us-ascii?Q?RtV/Rb2QngAMXfkU5s38KktE3VldgFs2dm7A/J+bBzg89eO8xYkPQlwk2ryh?=
 =?us-ascii?Q?4fxFTwH2T3B+nKFg/F96uvaE889uxXsjGkTisBXq+lVpOGzLoKvcwO8UB5zf?=
 =?us-ascii?Q?NTjjsVULv9ExUETrs30dd39Giwv+ufI9+jmLmh3+79VoSPuZqOF2iAojqY2E?=
 =?us-ascii?Q?HFeJypLtQ3aEybRS7qS8NToLKSXQlu90KPJdti5Obt0eBOhlU/2KOdzpBtaH?=
 =?us-ascii?Q?t63i9OTBFR30K1Q+OhphNDvkQp5KOUDHCfUOodOIFO63Lo69cCCYow6C5zeU?=
 =?us-ascii?Q?3pKTvoJiCfgkllrV9qqiQ3AUQTccdu2FojRJtsAagB8MR1ObQV8srrQ8sFRs?=
 =?us-ascii?Q?R0FS+mfBuRzFnmRBcN68XpvJw42EJJX6S8XSGmjEQ/t+AzHNzcFWFQtnDk1l?=
 =?us-ascii?Q?3LudqJBDHKra/mBTGPIxGj6fak3dPBY5K0y8OtHgQFXzN0FAs3J3vzUTKuFH?=
 =?us-ascii?Q?EfKuXQWHh58EVIDHVm1dz5D8PpGVEh/QZb/oS77h/Q1LYbac0U6cgTYkwet5?=
 =?us-ascii?Q?YLxQzxJaIj76LRrEAoUv+aiOWSB9AXgussnxmeqTpY/STE6Cqaw1wT5DAqCn?=
 =?us-ascii?Q?6KeocYMI7T1JvGSkAGwp6o+xBtX+2qpoRfop9ib7lLnCASKm/auus10sNgZK?=
 =?us-ascii?Q?uQqVdwTdcYqvtLcc+dRsLGMLGeHSvTCj1D9C6G8vvYA/xHHzma4RDS8yBnYh?=
 =?us-ascii?Q?wgZRcA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6082857d-9fcf-459e-24c7-08db31eed70e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 13:50:08.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak5UyFg7CU9SRNK4m+zbfssImwjONO93H+TzRjQK/LXnqRNJhnazx1uePgte0AjyzxkUzE/pi6CChc6MEXesiSPLPQdh5eZRiJTKIX1lLHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5509
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 04:57:15PM +0300, Emeel Hakim wrote:
> Offloading device drivers will mark offloaded MACsec SKBs with the
> corresponding SCI in the skb_metadata_dst so the macsec rx handler will
> know to which interface to divert those skbs, in case of a marked skb
> and a mismatch on the dst MAC address, divert the skb to the macsec
> net_device where the macsec rx_handler will be called.
> 
> Example of such a case is having a MACsec with VLAN as an inner header
> ETHERNET | SECTAG | VLAN packet.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

