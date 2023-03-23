Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FCC6C7057
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCWSiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjCWSiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:38:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2112.outbound.protection.outlook.com [40.107.102.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F57265A0;
        Thu, 23 Mar 2023 11:37:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/hcN16jY36sxMLB3z7+L75iUdY09K0n251foiD3vdpvKgAory41IhjC+zqpVw1WpprLCXLBf0JynWMaNf30dPcM/LiII5AwLx8K3GJ0Vhct4u8ZurLj1E46j2SN975cFzMurL2FJ/ZpaYtqpX4KrmmhcjwDnsneLd8wLgkKMwqDPjs3LYVWm4tzyBmqzu6HBOViOLFvO0mRCm+8mWVUFNojdeK69Rw1AIQ3ov41G9MFdrPTJSnZ1jkUMDYCnXFy1i93iH35PQmaWtgCIruDnaU+Zwtkpu75385B3yUCc+ALWSKXm03u4MceaEEEYPs+TlgC4eOb/2jHpOmYsrfS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ly/PnNEouOfm5OJX+dxWhQWKYrNof3JTI1Gabd6lB0Q=;
 b=jJuE9oouDKR9QaqVv3IWLTQj+vfz7eWpQxZoqqKM2oP8XBnjwOHB23qF3C9HolLh6yxIL4vTeVkKPvhZvOk6XShry7lU6d8oC2gps1GcJWMNRgL7w8UHiCTIRjjJsfMameyNVCEsHsGg2C5Jek6DbvoZcQOR0WKFAu7WvEwgKpIjyzlzqzmXNkAKnOwgw7teKI3EogRhcv/LAO+Isg460URKq2iY7O73L6dO7F1lEtbXD3FWGS/opBlf6ZKmkFFfuvB9MfQaJiKUq0iTwy60hxLnddhxplzupBnfSpfkDHC3kCXmqPhv9gNM7Fi/w8+ZwlKwuT/2YyZJ12CFd6Ckkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly/PnNEouOfm5OJX+dxWhQWKYrNof3JTI1Gabd6lB0Q=;
 b=RvtDPgpw9X9+K+UcOiAXknWrBodp+Kh5UPAtLNQypgWBGMwzegtvZpbqI8vpFqlfalyxvfZAOewBiBBMgdctP7BC4+OVia2UfVAzHiIaBjlEZLvAcgtqDQgElX61eUnf7yGxRDxk/3TLuYfN2pY/nsBQvJGKE+Ar9GpHeonLPYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4723.namprd13.prod.outlook.com (2603:10b6:208:30e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 18:37:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 18:37:57 +0000
Date:   Thu, 23 Mar 2023 19:37:50 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     isdn@linux-pingi.de, nathan@kernel.org, ndesaulniers@google.com,
        yangyingliang@huawei.com, alexanderduyck@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] mISDN: remove unused vpm_read_address and cpld_read_reg
 functions
Message-ID: <ZBycfvJT1cZe3kKs@corigine.com>
References: <20230323161343.2633836-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323161343.2633836-1-trix@redhat.com>
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: 06a09c2a-766c-4e16-592e-08db2bcdb88e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xtR8xSDSROHkWIQh7rd4Akt/ct7RMyesxKp2EsUkUza/QhCGpP6nFw7MSG414s9oB1BQ2lPIe+k5hjqkDYTOQvww/IMWU5NriJs49PXiT+yd5XtdSq0nvy5AKDSkUSycUvJ9TuynfetMidHKTyjyBzJa6EGtr9+iZWuFogYfVDwMMvjySCJ63/uNrDPqLsXgGI4VryBYravvvLNa35EcjU2NAPTzFlXLxvBx67PgmmUwW/uLoeO3xmk9cQtHfSf2OTUIcU7Pg/eGO1kLf9KUUjjDcxLd3ZPCj/mq131tqSaF+awS4cyMLk+XEhgUO8i0VTOdX7oitAKL3pWpQMwQfxdb5G/901oOKm48suOpdv5Ix7HMhEO7bQPlfsYFZa7opnws4nkOGuaCXsNQn+BzrZ8PE4p3YIp36RF7r7HanVo5rnObzz/Fpmqz+nAguf3tunbRAD3gErBcNAW63JrXJPH6CCND8oBI7jtYtuGXOiAPSyfWX4YYetbEYaJpjnO3gpOYQ8L1/aN0YXXWC4ijMUIA24R2FjZTl0h9esVqr6EnRSz7VXuYP/Omenip8pyghfQ8Y9PTpM67MuoFnqdANS6yI8kN1DHkBCsFme51F7vRdvD4efXy5wFkxYcdvpPJNRIqCW72HKGj9Sq0ItXD9WiM+CDbKuJh8fBSOU/Pw5A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(366004)(39840400004)(451199018)(38100700002)(2906002)(6486002)(478600001)(966005)(186003)(2616005)(86362001)(36756003)(4744005)(8676002)(4326008)(66556008)(66946007)(66476007)(6916009)(5660300002)(6666004)(8936002)(6512007)(6506007)(316002)(7416002)(41300700001)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62CB9DAqDBfzcgW7TDSH1HoeAviYsz1N3VfgWMTBBtHIrM3c59Ofrq+Tj8KJ?=
 =?us-ascii?Q?39rJDflieXdOVJ88P7Jf8pqOQz67blcBy3nEZ7jIMRe8qb4kHiEZwLfZaWPM?=
 =?us-ascii?Q?3dhM2//jL3ht56IyrgTMO0mAINg0Ao/KVsgWmmcd5gQckG2T+5Y5EvyedU1d?=
 =?us-ascii?Q?gfHghw7BFM5dlh2m2vKXAoZLlZG9lb2RpkNM28jKuYpTDMwBvRn2fZwcAetz?=
 =?us-ascii?Q?tNS3dykSVG92ddYGqeBTxlxutM0tV9sqxm2Xco4fyVwijQ1Iy1X1EgTSHBLj?=
 =?us-ascii?Q?7wZLE5ORaNRExRfRsiVHyKESXSy8f2LZTjHhMTJArc1RlUdg/3m+YFXydK06?=
 =?us-ascii?Q?FtNXUNZArN9g5ELe57neUpMW4Mkn0TuRMxFeQv+r2unsfyQVSUmc21zK7HfV?=
 =?us-ascii?Q?EsMxRXcs6VNqqAx2NnFau1SCG2WaeKlr3a305sDMLmgkmH0SnL0HCe22PCgu?=
 =?us-ascii?Q?Mlh6BYmhNPrdvRpAvopMeyfCLkulQJBhQtPmEo0hfJvy67Ey0k0i07UEjEtM?=
 =?us-ascii?Q?mQMz+Lrw8GKSQQX/DX98HF+Ddz8DEL9CFXPQjwVKRq/yj8GMqjVjKyT3OGzo?=
 =?us-ascii?Q?YzVhBr+09SGTaiVdMW3byQt3XO+bNIbQd11TjG13uxWdkomfQwCfnXQ/3Y41?=
 =?us-ascii?Q?gKUW2MuAYFACBjxukLZRLpuKizGDWRLc3uq22Mp/Z7H2PqcnSJormiFLZZhX?=
 =?us-ascii?Q?5OuHhDeD9SlduJTMc8+5yy8iRXPrZa8IHnWY9lkqjHT5ktjpgXwJDsdCmg+9?=
 =?us-ascii?Q?E6aDEO5okx6/AtN8qyZxLROwwK4pHadZ3s4AkeGsnC0silxFlRHqB955bzxQ?=
 =?us-ascii?Q?0AFe6kJhPsn7QWW1abLA4t1ZyQIZC/IOLoCTV/aHbMZZ1mU1WbJeBD5EJYsq?=
 =?us-ascii?Q?L+HpkdY9/vNL3PsXxfhdRMBFQpE8WL4boZ3ePZlKlo2fI1nqZXnsLoUBLdSs?=
 =?us-ascii?Q?jEu1kKvuI8oKiTAWBz/bqfXbkeG0kRRDs3R2Ylmg0JRFYhxYYFX/iqV7R+67?=
 =?us-ascii?Q?Gs92/wEcrMWkFKbR1i8WdlunicyIA0YS/GBRD0yeL4RP3aKbLa/bE6KC7St6?=
 =?us-ascii?Q?x8uQLxHw28CQy+VYL09dUPpF+W0SRDa2kqr2ZgEwmpTZOpccQSlZoKm/HknV?=
 =?us-ascii?Q?AD5g7xjgmFza+Zh0vCvqCkflCrrjxPKEg2JgYOPUlg+fAXKc/SXcKuY/pO1N?=
 =?us-ascii?Q?xgBVLa8Xn7gxifn07bCbPhTxsQOU1Y7lpWGDdZXXn+q+Jx+ck/xq0BsNiRxb?=
 =?us-ascii?Q?6IjtyKZLBe3q7xrvRCcc436WGmOBTkuOpS+UMbP3KNfFCNU6spMB5owZAUkR?=
 =?us-ascii?Q?34lxPFVg4rnJORnoigoyvqHxyqs4vx6fDdLjIcaKuviHM9GH19yuiGqLUPie?=
 =?us-ascii?Q?gSvTYxWk2GF2IxOnVe0si4G42/bjx69h9SxEkn5ahN4CMy4L8aH7FbFNkMku?=
 =?us-ascii?Q?h6xnOv+oHvtaeDL804S7tvwGPhtu/UKUsTAdPl2dN0KZsK66NiaA/qtmQqai?=
 =?us-ascii?Q?hds3/j/BoB/i94vPFifGMQHZxaPwtDA1Pb+Cf/lJMj9dcw/V4iiRghTcCyAw?=
 =?us-ascii?Q?BYnSJVCvA8hek89ZiP9TzQyMQ4jau55LB55r9vCIB9ClfPPChlM+QQLOouIu?=
 =?us-ascii?Q?N6BnlVV54sEfMttsQRJ5XIUWxVfIVKxrXUrhGge4mpnwFMbDez+pkUrFe5lw?=
 =?us-ascii?Q?Hsec+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a09c2a-766c-4e16-592e-08db2bcdb88e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 18:37:56.9714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uY8/CtaboMkebfn+wC5z1nSXFlU8Cy83+bTT/MrQYAOCgC70bYXhoNWrk17p5cl95A9oCCNhRG3MCo86uwu7vP3wyAGD/TAmkOVzXRRk4so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4723
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 12:13:43PM -0400, Tom Rix wrote:
> clang with W=1 reports
> drivers/isdn/hardware/mISDN/hfcmulti.c:667:1: error: unused function
>   'vpm_read_address' [-Werror,-Wunused-function]
> vpm_read_address(struct hfc_multi *c)
> ^
> 
> drivers/isdn/hardware/mISDN/hfcmulti.c:643:1: error: unused function
>   'cpld_read_reg' [-Werror,-Wunused-function]
> cpld_read_reg(struct hfc_multi *hc, unsigned char reg)
> ^
> 
> These functions are not used, so remove them.
> 
> Reported-by: Simon Horman <simon.horman@corigine.com>

FWIIW, says this should go here.

Link: https://lore.kernel.org/netdev/ZBsArtzFkgz+05LK@corigine.com/

> Signed-off-by: Tom Rix <trix@redhat.com>

Patch looks good, thanks.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
