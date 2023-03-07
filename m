Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650596AE512
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjCGPlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjCGPlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:41:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2101.outbound.protection.outlook.com [40.107.94.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CA885A67
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 07:40:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHEAesg5AAkzykNImd0UtHiontgsAOGIxfqP597l0S+K6eEydXmVUKWmuXf8NIH7gK9c0xhdO3U7iM83npG7YmyM7ST+pyuykilQoS5Kxv6IhRlZF4E7PgE6qtTasaJywJhtoaBiJQzPVoKrHocTXXQumqF3xkjZsS4Kqb6qip9p2V1/jjuvwjS7B88uKIyLpNiMA1XB8fWN7RgrLHPa7TKCQquLzCZkwvyFFhBGWOICO9qreHfWhxsbuoA7mS9tEM8obat0vHA6FSjDm6CiDyNl9Wze1sSZ0XweJnnlbLBuy13u2jYAHAUX5vyM0MdfbdZ7ItnClwLHpAk6cjyIdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8Zp+1XuVmnMrxARqCk+qTOIIGhcryKQDQtlxRG/N6s=;
 b=al9o9LlFTEzaWN9PQ0zlpn3ssW002bnS1WM8Hre77caD2vxBWOzGQbRdegPXYJDtEQ+cEdiAQ3lFr304f4qkSeF4IZEkYcvncjKzogdUCrE2oL1b+pBEarprPzBiO/O6Nkf1vKXKe1nsVSVYTZ9C1Le7I4Oig8+l5U7rictBdXW2FQ5hkTd49dlx8oyIG7u82WhF1DLF10kIGUODepGsz/TluJxTo5R+KY8RQnsbFYix+La8EpbMywbRqyTiFeDJCFVkAMLJ0WMIk5JngOoGHZiyoJsigWmBQi6i8VKJ+AIafkdjGvwZkSlWCJjahtgqFiOxUq8VCz409inMrOucrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8Zp+1XuVmnMrxARqCk+qTOIIGhcryKQDQtlxRG/N6s=;
 b=gQIUx6yelYTUktdxyjFH1naZ8cjrgZohxXYO+cRlyABIFI1a+lK1oS/bacUvmI1Y+fQ0K1JzIqIZJX46q+n5/ScgcQXI69rD1Hg8WsTNMcayvv/HP4VOq/JvE3zluci5tQeijM7BrhXEGSbG6S1L58WUg7rnwqtthfhcEQjn/sk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5035.namprd13.prod.outlook.com (2603:10b6:510:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 15:40:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:40:09 +0000
Date:   Tue, 7 Mar 2023 16:40:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: smsc: simplify lan95xx_config_aneg_ext
Message-ID: <ZAda03WSziLd3juU@corigine.com>
References: <3da785c7-3ef8-b5d3-89a0-340f550be3c2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da785c7-3ef8-b5d3-89a0-340f550be3c2@gmail.com>
X-ClientProxiedBy: AM8P189CA0018.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5035:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cdeb7e1-bd3b-4091-8d31-08db1f223bd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Itlzoue4q6bnu7XeQOOKZnD5Gy3/p/sNrVcC23Kmn6ikL42YvnuMUbfTRzPqWwUU0X5msT7Y3Fz0H6KnvQF5zC9iGiDREc7b+J8Gmyyw9DqzSnzdaE9LPutbbIMqnbfFkZVhCRAXYnE4sWZUjVuNz3bCZ7Zovc4ECUZ5VEV8sVkDS17M4IoEAKR06pkOTCi9/i7HxIDaGrdjfDep0HfYpmQ9hXAtjWARzjFdbcR+MtMwu8hFlwEL2mJ47zuvpISR/ztHJTHjrIXoTogxmKhky5zuUuqxDj+FIrx4dNo913K02dt3+i4wTZkcO0dDUtel8hU8lPwW2Ju1FpFW1UAgUW8IvtmbjDIKHv7usNiQQEjzlM48np+5FRNkKMa4+PAxXtVbcayEsS1OlfBocxG4Vf4weDihGBXN+LZC18i1kGnUOE52zgGAV8FhezNY6MdMR/KnFbn1HWjLq+86gxH+zKyY8o0t72Z7WrdNJnuxQpMbKN3fZ4PfwqkuWQjzNng2Ov0+Ll/3gJemMkpTGzdcrBNYo9IQQDIWtwm5pSQIt29sjO7vOs0PvvwyvjF8BcIWwcc86BteuL3+j9vi/oBU7Dlwx4sbXcimiUc+MSpL2Cl2ATSoDPZcOwgCGqaHFbQ4ZHsxziCQOnD1jYqKZN5w9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(366004)(396003)(346002)(451199018)(558084003)(38100700002)(86362001)(5660300002)(6666004)(36756003)(44832011)(2906002)(4326008)(6916009)(66476007)(8676002)(8936002)(66946007)(66556008)(41300700001)(2616005)(186003)(316002)(6512007)(54906003)(6506007)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uBvhuzJK1aSWzoo8bItr7uUb/64bpGF6+b6p+INUlEXaExuYYNelMsAw+SpG?=
 =?us-ascii?Q?dqoCnETYn42sdPavqATUslYjfAgYIL90TAdYFgyoOY6ewQWLNfYsO/y0DvFZ?=
 =?us-ascii?Q?8ouMTMkb3K9p9wiv/DapuFJj6/3RI92jhc8k0msvj8al/InFR50N/8zLSmTR?=
 =?us-ascii?Q?rWlVFjd4ka26+sqo6bBLrQLx4UhUp3Sp+xFQAR1z5LGLDFvkaxNBmT7VVRbD?=
 =?us-ascii?Q?Ru4DKWtZk8bQKShagkzrsrQpMxUcviq4Nx1RQXSyoFHBHmaARjWH1gXz0QOH?=
 =?us-ascii?Q?0FHiy2PTzBW7eMG1tc6ZqnT8mY5N0sGTybP0v/3TsQRv/PYEeJWVccyLIs6n?=
 =?us-ascii?Q?ibwW4H/uky29iGTF95ocBaPX7nQd1pO+egFqXE/A3/KGP2pVlWTsK6UVdYkC?=
 =?us-ascii?Q?jkGT+uUMd22xo7RzUfaTY5r1eUaANQcAvzpdk+ZYqbAB+asoi6gMJkqd4kUP?=
 =?us-ascii?Q?6w+d4teGIblaUVzOluxlpRic8oU6aGqd0PRGP5FDWxrWd/5CwUmvYMnKmUKp?=
 =?us-ascii?Q?SCgMvdFvXbaTvDWMRO+ovdm7K1HVXddkdMywrxgHo3S83Nazxy+n5EmxYnZd?=
 =?us-ascii?Q?EuVju2cTn2ZC74NSQj5p1glA9sCEAIfiYBzsgXvMPAGZT/RDycew+bDQ01Ae?=
 =?us-ascii?Q?WBnm18b4FmJGR9IMeev84b4QL95FUPzy6mWaZmrni2/+ElDa4FCThBSk/gHT?=
 =?us-ascii?Q?v3LicxhR5qfA3I4EUWy6CipdYD0YKYOJZ66Y46ryLn2S9lJMHhnpmo/+n0OR?=
 =?us-ascii?Q?0SNFzkT3JFSGkJpdOzvDIuHVGItaTUwV3pm6YuJAOz4lIPc5MrVfD8Zpq3px?=
 =?us-ascii?Q?8eoPa/ZtorMSFuROMNWVvAffKmXfAKZ0jLh+Jhk02zC5Kb7O7dnrB9SF3v/H?=
 =?us-ascii?Q?GVUGIrOWhBpQhDthytzj056cZKssAdw/welnyBexOFr/xf5vVMQ1xJDX9pER?=
 =?us-ascii?Q?CocvYWilPDXG9JLV5PWltjPhih3pm/4Aee5TEtWhAISjPqYhkOodFJKgSZRT?=
 =?us-ascii?Q?+InOsJGhgX/9Et/8Kj3FSvDqpki4ou1HzcNI0tZobM0qQgLbVszR+EekRIcI?=
 =?us-ascii?Q?M0pwqVcAsq8rznt2CP8Gqrq97yLuABPf51EMk2aWI4zhCYS2zAQruTE1WV0T?=
 =?us-ascii?Q?pCV2rOKL1SLXntM0iKG6o2A4ICoKfqMz0PFgAwAX05XznkfpnuG5iUnflKwN?=
 =?us-ascii?Q?XSHahypP4KpjBibbhckDYfotp+tCdfpwkM3He1mI0SrxuSHYBSGTNbtlrM3i?=
 =?us-ascii?Q?D2YqWSLf+EpmMYLk4C6xQg537Ppc6JXl0MOIrd0r3s/4rKJsOwy823GgBsye?=
 =?us-ascii?Q?PL28pHi9X0fToS8saQvO/iMwHHieNo8YfeF+n5xEatr99wpQrULrKomEnGx4?=
 =?us-ascii?Q?VD+WmowCb2QpGPa0NEYPgckdmwJHGtcUWC37QkSqRAfnmnELJihoCQtn74Js?=
 =?us-ascii?Q?Zcnhs4Zmi8/lhegTsJMN7hwERbya98nyt3UYRkHUBi4df4JqkNkNjuOBZqMU?=
 =?us-ascii?Q?+bYN+BSPQVDw5WweP/akU3XHV041MKEfSQZCPmfj40J51StXIwhYTEM3RsWu?=
 =?us-ascii?Q?Ko1hR6nHzhjam3hjtQJehNtmch9/DRc3tXDW41NtGyDHbr4UKp+bFh+WYt9F?=
 =?us-ascii?Q?CjFzQoC9YTLMmmMVDDDyrSMKnVkf9zXqs/LK0vvjgkb0ViBvBlSYJYDIy6Rx?=
 =?us-ascii?Q?Pyk9Yw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdeb7e1-bd3b-4091-8d31-08db1f223bd1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:40:09.7713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBSth297zWBHdiQwJmGgX55e8pHAgPFnz/cmNRHcKzwQzjqFilxI5I1Ko1cMPkrGDzumZ3D5LHCTfsvecIOhemCkqRZQ5Ml/18pH23xbZFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5035
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 11:10:57PM +0100, Heiner Kallweit wrote:
> lan95xx_config_aneg_ext() can be simplified by using phy_set_bits().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

