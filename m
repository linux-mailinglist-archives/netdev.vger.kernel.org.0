Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6ED6E484A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjDQM4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQM4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:56:09 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035D1D2;
        Mon, 17 Apr 2023 05:56:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmXo+1MrTMkBvBJ3tF9SVfKTV7bUJwsqmtNgjbJP7eCxUqUPmvz4NP4nzQWcDuSJrtyXDd+TdrI7g5CyKlIffg4DyvY1ruY7YxiNX0XsOAoiycJOyGjIdJQd5/4n73m2H93hfkMljIFpN37z2vB/gr/rRSS33MtV5bbXMYBzCnixDTo65PXbUX7SNRoMI0azpV1J/PFyTzoO3kkRox8XokN84NBqLxiDxegKiqB39z1n0tYK/01F3A0SzLOhcF/SOWnULZ739Eq1aleICpXEA+lqnKPFJne7YPYLfzpEhd5OpC7QkL7aDAm9OVDNSDLLxcetJfGtMqFyL2JkVR0BgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SAr1KF+DuQvUBpFoSK5D4KwSH1mUkyw/8BnhsnwzPmE=;
 b=GM/YI6RoKOKsiq5mCavYjMWTxM2oSfsNtIjjTv097nYw2ZuSfNoCiGlJwRTpiLTjY98qq9NlLoUSsIwXE9IlZTu/fhHNqeLT8qkSnx+BDfN5FzNaC08MhPm6iNthtXOH+9bqdTqaUF8mXDx2NUA9aRWE/DMpnRfS1s960ifOKcNhyqdtXfdEsGcFcFoNvvraGR9NrBNumqZ96ApowCOeVlXOEv/E9n8zSTDHBmaO0yYUsy92y+hmVeAAgmzaV2bXxPioBxV1N9qrYPxFOTb4Dq9yzH325QHdsdIOpmIzGn49Il90P87lXV6ggtOV8DEoYkBOD/H+iOaJaMpFPq5l5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SAr1KF+DuQvUBpFoSK5D4KwSH1mUkyw/8BnhsnwzPmE=;
 b=b5tSRxWy/RWuNXMgEVxr9vjNCZJIzkSOQaGj1tuFWwqMcDikDhio8m1IkpBmg7EQPA1doZgjTtb4xUIkANsaH/GykLQx8+2XEC2qzVHmlRmT0OARfKGgmfWoLM7iETcRNidCyTghRUwkbXydj93p2H9lX/smjV7CoeNIWWDkzdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB3996.namprd13.prod.outlook.com (2603:10b6:303:5f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:56:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 12:56:04 +0000
Date:   Mon, 17 Apr 2023 14:55:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net: mscc: ocelot: optimize ocelot_mm_irq()
Message-ID: <ZD1B3XjvIKxq50dd@corigine.com>
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230415170551.3939607-4-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR10CA0033.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB3996:EE_
X-MS-Office365-Filtering-Correlation-Id: ec69c2cc-8a1e-4d88-8006-08db3f431a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OLBCWms8rTUkxiE2TgSPucUs9rR8hnspmp3aKvFOcX1iis/rszMeffhMwFC9PDkiuIHNg61tLdemPekEeokR5aJQZPt8AXuCJNHpGXca7gIFsbxJ3SFd8jcm8+zf00GretusLQDku99P6HmFfBJVDxDYn4sDJUjkCobxPAi+sPLnScZSdGkcW0lAH6b7aqwH6fRxzdI+BX2+TPReVy0lKv7AG5Ay9LdCXyw6vQXX5xFjJco9JU2SFMagrorfkiscQyOx+Xm/6eU4xLCup0wKLUiuZ7NCZgymZ1cFDn6H9OMJhPCDXHeLvV6mFU8VaYB0Fdfl2IZgfi+GosxF1UuwaclJ2c9yx+3wIAHTZYK+hUqnDxyqXmhGay/ULo3hbzCFMtdbIO9s7WuySorHsYzbVUuOfLxzGi9NQdEw08nFDRhTmY+0B3gfPiZu6Jd5GsT9CCoU9mBrknTcdLajm01Z4agkAXU6c/qras57v2pkS6ORRgCLdqLVgHi0H6GnbsBijxWlNJ8yDBAyyldAWNRT/FgOM6sE24UwK4R26dViN85TtLUVJQs9m91rIXsBytE7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39830400003)(451199021)(36756003)(44832011)(7416002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(54906003)(2616005)(6506007)(6512007)(186003)(6666004)(6486002)(6916009)(4326008)(66476007)(66556008)(66946007)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MnjIxzZnkTLFGb8XBSb1YHcX6jz2pvsstUE4jXlkT2mTV8R10uRwtufDMkR+?=
 =?us-ascii?Q?vB+D3GjLtlsh33P4U5ojy6I2WdOHSDngnKh6vLHGbxGIZAgXIUHTco1AeB4a?=
 =?us-ascii?Q?upUFSIYEAHE1yPEffZbS80GdnaY6n56ofVGCGWqAm4YQ12EQjSddJsnzvR29?=
 =?us-ascii?Q?kYKIy7X7rAG0E07u2vQeuxb4BHSucVBRvRpl2eGHVMGtRYBRlK9+dK2PXpl8?=
 =?us-ascii?Q?2aX6X+pXMfss1uhy8iQ7Ep6UH3TdvkpRmbzxRz7ka7MPNk//qA3qYl3PSEVr?=
 =?us-ascii?Q?SBQk6a763zzSPm3iZOsnaLeci/DXjDFdDx8iA3TLdfSvN2pHEOA0RHz0ON25?=
 =?us-ascii?Q?D4zfsaYfCO62Bfw4UHUjKROzMiNqrpfusMhBrA8H5eBsJRqyUnP+qHogAFeO?=
 =?us-ascii?Q?0Xn6sff9GXRLhh4xrWqKhJoMM1YqZfq6Xz8uobwy1YJowUOs98rw9Snut9fL?=
 =?us-ascii?Q?eysQAMl2CWiE/dLNvp4V+WMZQM+i1IhtCNcxgFRQ7/p9LzRpxdX8umGtd5E2?=
 =?us-ascii?Q?p211IFZqzaFdb/meppAYEHEEdG125/hHK9+NR018/1p7LSWGPaAeWBQLaMUm?=
 =?us-ascii?Q?gFjrk8/OCaSU7UIgoOk5mTYxm8qKudR0+hjfCCdIYQto4gJE+S0sqSAZRZLI?=
 =?us-ascii?Q?VQJeMcoAdY1m3TxZIGatbUDDtNmVkzDeZsEz4MPMhmGaizmI5rs7DWgwPTwQ?=
 =?us-ascii?Q?3z5qPaWFj1M2azBFi5q6mrrPpHWWdNxD/WQMNbz+D/zV8i81q+mFoupNAvFP?=
 =?us-ascii?Q?BW64AioInVs3yuihZ2w/+Sl2C1gTPjUMW353VVGnRFZFXElRQ4lK1SO+C6q2?=
 =?us-ascii?Q?8buw6mJPNRyXBCL7RBaQ+ET/mWKVydSzucnZ49tBn/axy0pZwdhAGQpGBd2C?=
 =?us-ascii?Q?5ZTd100ICNWPmJVEAvpQRHhzwjtaclA7wtuUlAyFLV7N8Jw4IsxIwcpHKgAm?=
 =?us-ascii?Q?zs4TzKU8NSJzHhZzLd33kpgBp9aFlYwlWXAWEpqtx++AX95LHriBMmHxewip?=
 =?us-ascii?Q?U1hV32wvzLeAD/9IUeA06j+mOrm2D01Tg0gn6kFpffQ3JTJwFli4nBRjSOJ0?=
 =?us-ascii?Q?v+KG3+LbOhlrUaDYB5NTU2cOiDTfWNSzqVnNxnNrVTQ9XYmmcRaHDE+RON0D?=
 =?us-ascii?Q?fiBWoTUeWATMXVGA2xFSGNBuw/+2Apgm9GmScsJwOeratAMJ3s0L3OtbKciA?=
 =?us-ascii?Q?kDRxNmRcFnQ5dr+i5IfjFtETUDdIjO8ZDHhBxl5I+GkcVKcSWjMq0DuVVV+n?=
 =?us-ascii?Q?2RCPjsvX6+1+WEtI5X1eFvt67UED2ojh6uPLYoG7Mc7ZRUmrJxgAiZq2csSN?=
 =?us-ascii?Q?+BB6141Zm2TuL5fo2G+oW9m04ALQCK9x5Zpho07QvCZ3qLdGWur/IjC5mwox?=
 =?us-ascii?Q?haPoevejeRphqYS+Gd8S3bJ4kxIq2y2hhAzQl4HwZZBQ1x+YEyMZRkiRPlZh?=
 =?us-ascii?Q?mh+/9xnvDdqX4inoD7f0l/Jx2PRaj80dFKhzHVhEEV5Xx9DoR8zuoO06ZXFY?=
 =?us-ascii?Q?IVdIDBZjpBSWektMZalTwhNUeTiGUvDBVMibDEw/3FboUROCsQNE4O1MMP2I?=
 =?us-ascii?Q?520xFrqhOu8rFnxvx/SNdz27Ayq7jZ4Px+yFsZaUnq4R0tYFAEcktwePSiuh?=
 =?us-ascii?Q?d5uVJAtI9qIGqOJ0fZrfcrgZenrn3VhPUJhWaA3/xo4j2n2FNcSzOElRI+Gs?=
 =?us-ascii?Q?O/iTdg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec69c2cc-8a1e-4d88-8006-08db3f431a3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:56:04.1500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fazZuGF9eac/Nswu4vN7ResSCsrF3QmJMWtwfliP3a807W62C9bG0xaXjdCcFxBouKXgykgxZXk7oqDV+KIoP8avjRV7VkdifQ9iLi25meo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB3996
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 08:05:47PM +0300, Vladimir Oltean wrote:
> The MAC Merge IRQ of all ports is shared with the PTP TX timestamp IRQ
> of all ports, which means that currently, when a PTP TX timestamp is
> generated, felix_irq_handler() also polls for the MAC Merge layer status
> of all ports, looking for changes. This makes the kernel do more work,
> and under certain circumstances may make ptp4l require a
> tx_timestamp_timeout argument higher than before.
> 
> Changes to the MAC Merge layer status are only to be expected under
> certain conditions - its TX direction needs to be enabled - so we can
> check early if that is the case, and omit register access otherwise.
> 
> Make ocelot_mm_update_port_status() skip register access if
> mm->tx_enabled is unset, and also call it once more, outside IRQ
> context, from ocelot_port_set_mm(), when mm->tx_enabled transitions from
> true to false, because an IRQ is also expected in that case.
> 
> Also, a port may have its MAC Merge layer enabled but it may not have
> generated the interrupt. In that case, there's no point in writing to
> DEV_MM_STATUS to acknowledge that IRQ. We can reduce the number of
> register writes per port with MM enabled by keeping an "ack" variable
> which writes the "write-one-to-clear" bits. Those are 3 in number:
> PRMPT_ACTIVE_STICKY, UNEXP_RX_PFRM_STICKY and UNEXP_TX_PFRM_STICKY.
> The other fields in DEV_MM_STATUS are read-only and it doesn't matter
> what is written to them, so writing zero is just fine.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

No need to respin on my account.
However, I do observe that this patch is doing several things,
and I do wonder if it could have been more than one patch.
