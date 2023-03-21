Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD346C30E2
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCULvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCULvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:51:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2118.outbound.protection.outlook.com [40.107.93.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370DF1B2CE;
        Tue, 21 Mar 2023 04:51:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9XMd9HgrRFHDaEcQfmU+tpxb/bt2tl4xkA7IR4hMWZ/5qRZKz0ujxDYYE1mYEVcGt3Z4odU9iqG4gr4rmKtkEsELJO925s44Rcbhb9SlNeXHP51R/s8TSH6ohg0t5KSDqOmWyLQvB6MqOSUtsBbxNy53lR5b0Kj63HgFXidZxj2o1APeTp6pRdxvJiI08KrJV600rqNnL+FCEZi8q6IcWHGprvzgnKc5IveLdYn+ie3MZvfvXNVTH24Lpe+XQcU9bpRmPCMvcE3pKwYYmnPkd4Lkz/6jaPLtgLDIMikx2t1SJx5zopiWeIjMbHQb69uA71WX3FowsrnsdCqoSw7wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5L3DAzC7uTcAynBCUfX2Qfclg47irXt0treJ3B6wbPI=;
 b=Yua893LkKcNo3WkgOnyZLhIxEiKuQlcB42FknQkPPmRZrUfAWqvexGsnktVoRg0o/jZy5KEub9b3vrxT9F3BeLOEFhQVIy7Ib6J5VS/RbjrVP/gQhZ6+LSl+MYCfcmM0pPyRoTMnLXHT7q7CJeCXID7FpmrwmN7N/9/taFo+67mVGVVX5lVaDKggOE348jwqFV/vEkmWXj5zuul1UEl8nlTEVmEpYfegOfCvg+aQ7A6h3QwWpVL+j1PxC76ibNFNzoegnsL4d3lEDyzIsHvZGU9rjzr5msBv9l8EV+N5UwMG+zpFWcczbmBYJ2PXUbG+QSXUKedmcHgSFe1hCt8x3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L3DAzC7uTcAynBCUfX2Qfclg47irXt0treJ3B6wbPI=;
 b=DtYf1ymwbOMMsiiVhdwVjtigFMxDuUuQQPtr4//CbwnLrAjTg0gQvoRdN7dfRMfTRrV138ppmELw3VKFOLZh6ekKqyqD6JAYlJOqitODESouZ1UH4SaCi47ZnhwAjxTHUn0ycrxAumgGubij4kfAp+FdetNMam+qA50bC4VOOQg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5075.namprd13.prod.outlook.com (2603:10b6:208:33e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:51:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:51:24 +0000
Date:   Tue, 21 Mar 2023 12:51:16 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     wuruoyu@me.com, benquike@gmail.com, daveti@purdue.edu,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: HCI: Fix global-out-of-bounds
Message-ID: <ZBmaNIij3IRXRwaT@corigine.com>
References: <20230321015018.1759683-1-iam@sung-woo.kim>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321015018.1759683-1-iam@sung-woo.kim>
X-ClientProxiedBy: AS4P192CA0011.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5075:EE_
X-MS-Office365-Filtering-Correlation-Id: c45d5a5a-1d1d-4f96-4521-08db2a0298c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+EXyYcAjqK4xTumpRm+XTxWbdpM+Ti+xzFl3tqsF3c+0hLOjUafB/BgtQROTZPG+09m7L7rPu1NptsISRmP5nkZIhBfqLAOOG4obDb8JHkgcmJiPiCQrV2q0kxdl1kKuQ7/wC7YtO6zSazVUlwNRfT76p9O3r0ngizhMe28zuTfQoyqWUiJ813mGxFiBf03anFQ7LMBN3ya2pyIQQS0PCW4vRY4kDQWQtoSBbuyDR6GevwBEZmzYwcc+60bmyKvn5luAFWP7g6koTUB2b5LQNzB5wQ4cK7lGbzGDtEZRMz8Zi+TtJlyQwlzMuvoW2Q4Q/rzMnpo5i3SVESxGxchxO0vqO5a38fRjs/9s7hcvtgO2SGgOmxW8adVJZA4JHxRpA08lFY67p0kEI/dBCu2ThFwApGj1Q/UF5oJPIlcvGUPL3QBN5zAdYYBUI1RePMZp4mUqemNPWfGzgn3WZlughTq7UHljt2WId5uI0MKTYGMXEHrb2fyDYF8AlBEqkGwcCSIclK/+751vJq2fU/k1BKsrCKXc1h0VJzRPhVD0ezXJmxiciaKX/EgH5+A8MHteg6DU7RxTdk+K9tNmyMtgXvFsZi+281UvEZDCF1HZWK8CABmUQ+txz8NJTyYJMUpax+AYdB0Yi1iKCqSyoFynw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(136003)(396003)(376002)(366004)(451199018)(4744005)(8936002)(5660300002)(7416002)(2906002)(86362001)(6486002)(83380400001)(36756003)(6512007)(6506007)(2616005)(186003)(6666004)(44832011)(66476007)(8676002)(4326008)(6916009)(316002)(41300700001)(66556008)(38100700002)(66946007)(478600001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nZse2Cug09xZUAnVCSwRc7MIeyFCK2JOoJtZZoduGsD83oHBQh6DlkzzRfA+?=
 =?us-ascii?Q?gCjRPLpma3C2yWgcRTRvM0lBqUzayGHWnQ+IRQje1CI0OzSAOdLob4h6E3RH?=
 =?us-ascii?Q?vgrMSUJtN6Vi98GMn32TeEsGBBNLs353bWMQQ7Vhy+9nCxQt8MzP/D9MQMHy?=
 =?us-ascii?Q?FuRZ7+muic8iJdWiWd3LzSzll11IqUtTCQWtOwavb+jXTWzN/2ERqwR9EgJ0?=
 =?us-ascii?Q?UdswnW3Fr/fEyT+NC/VHlXktI0/qy4fEnCtl6rZASYwcuhgRbcwD6qtT9GVj?=
 =?us-ascii?Q?JGnewuunildIcO5zNCZ88/hc0pnp+UN9J1E+OZ8V9J98s9on/L2MNvWh/8p+?=
 =?us-ascii?Q?e0LB4wVPPhli/z0WHmfbMMSSdhAJS64PztKURy5lopeNTRxVj3O20hSUOaAo?=
 =?us-ascii?Q?kgzd38k9xnrtBWGPjG8KvIXCwZgrNx8xj6n5rQiBUrHrtkBtuFbnLiqvPUlT?=
 =?us-ascii?Q?ZH99G6wqHnsfBVqGwEoWwk16DzaCrqh5KgSi9Afr1m24yUiZDLt+JIH7sw3U?=
 =?us-ascii?Q?19QKPiP/nxqJdgWZhwDrm2sgkGJTsz7oqweDAyJ9QDRvxDQ8XrrMd9+HnGke?=
 =?us-ascii?Q?9HfJmMSugJQflf81dEPcZn7QsrbW9/3nCyeWrZ/0EBwZerEHF9CIJNLDC8Qv?=
 =?us-ascii?Q?pswOiEXr8Ue4t/DIKY1DRWINBmUpSiKcQ4u5867FY4/j2zQ3mVcphKNZOZUd?=
 =?us-ascii?Q?SYXD+tHUZ4RzKij64Xwl/GW9vknnmgYHd2qAHeLZTl6XrWiESkfQN12Wl4zd?=
 =?us-ascii?Q?9jmzECDKw/3a0i5O4XzIuuzEB9fmIpnNKv5d2iCPakDgjVkt86zpZw9xGU8g?=
 =?us-ascii?Q?mLJg/0hDTSWEbfuhPNeD4qmhWSc4XB3D3y2Ih/Dve2ZcvsKycw8zzAbGgRrs?=
 =?us-ascii?Q?gFLRkpItdKuIwbDb7kzEzXBMdUN9GEAQTlNW3XNsAzK/O/MIbCIj0UB7log1?=
 =?us-ascii?Q?1FgkujFfelPnQ8xlv/5u1OVB2uOFZ5lgz30RGGCXWPrtgXwGXQSs6q+2v+s3?=
 =?us-ascii?Q?ULIc+oO/IGIf+MURNPu+0m3eL/MUKPh6XVr8lESd9WvqFJttK8XSWWHVGZV+?=
 =?us-ascii?Q?vyqVgvix9UKi/p2oHiOiggmgWw2JBS4xUWnqGfu2IIVs1dXqusoSQl/iMRFT?=
 =?us-ascii?Q?juIurXq9kYB+yl5ok7Ib2EpS6zKkwdoZAZbV56aQ0Q2u+6Y4x1sWasyzlxBC?=
 =?us-ascii?Q?Ldkb7ceJL5czbtEMlU++n38/9z6RX/tsoWIZC1E87IrqAnv+Ch6lEtgVk95V?=
 =?us-ascii?Q?LWjLuV6bGFmHkIIk0rUQ4UJ2HN+YgSKbTkLSjOvd78cH5CTlf8dDO2JAt9Kh?=
 =?us-ascii?Q?t2wVJZfC2TIGmQwHm/O9Q/Q81vX0d23/4SQDAWo0+osJHPu3STBAGzZnuCHQ?=
 =?us-ascii?Q?rY+DrriFrWAmpMk4lwQIQ8ES2tuHgedgYciXfF7os6uOrIIxqJ6wnTDUMUbe?=
 =?us-ascii?Q?NAN+00D/Y7+stYLuh3Ds1ahnusT/IUGVGYfouXvvmbA36OP/XQ3RxdNxNIvL?=
 =?us-ascii?Q?+pA/jrfuVrhY50xRS9wQ/SBO8SaopzU4jO5jrS4B+LWEK5iJoCh38GAg/hOk?=
 =?us-ascii?Q?ll5/n1e0ufa0/ot2UlNBLLtbmuykLsxpR2u1O6BfgePFUEhbSn75CHqcCd/h?=
 =?us-ascii?Q?P2sbsAr1M/r1Jh4pL0bhlcgLTcrMiTFjBv42lAYVU0bnLePRmCEtyzUmFU2F?=
 =?us-ascii?Q?o1C9rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c45d5a5a-1d1d-4f96-4521-08db2a0298c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:51:24.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCKW2FYDBM900juqJU3edj/8ZdvmfNTsTCWFZz9mROxqq0wTDs50+KJl8y6EOKrImcnVmAAh9s6D1b14K6hJrZOqEoJWq33FXOT3ydIRs6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5075
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:50:18PM -0400, Sungwoo Kim wrote:
> To loop a variable-length array, hci_init_stage_sync(stage) considers
> that stage[i] is valid as long as stage[i-1].func is valid.
> Thus, the last element of stage[].func should be intentionally invalid
> as hci_init0[], le_init2[], and others did.
> However, amp_init1[] and amp_init2[] have no invalid element, letting
> hci_init_stage_sync() keep accessing amp_init1[] over its valid range.
> This patch fixes this by adding {} in the last of amp_init1[] and
> amp_init2[].

...

> This bug is found by FuzzBT, a modified version of Syzkaller.
> Other contributors for this bug are Ruoyu Wu and Peng Hui.
> 
> Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


...
