Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E815F6CA79D
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjC0O2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjC0O2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:28:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2139.outbound.protection.outlook.com [40.107.93.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F0065A6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNQIGYlpASMTtCKRt/DtItIegRHvM4B/ydW5KhDC16zJaPARPy41Xm3E4FCFKshRaFuLVq52D31qNuRx0bA4HtiIlNqfSBQBziS6Cq5Kvj4BEbqdU5Fi/1M6zeBq3gBMHSG83Px2fNlyYO+bG7F8pJCgdmlUg18/7UEkFW3Nr8C+hYw359UlQA16ogrNCinLlhMinyRy6mz50QEAZP5dzfxU6WlxqRAfLUcprENEoipIrUMnlpqn1vDD+A+uf67810uI0Hpl8j1yraAMdsVFxkp7BtWAGbOwo89lWZPh4MbisHs7OLc0X5twksjMC5HHKKImg6eAWdVTvSqgEXKTiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMUHmDeo/qRbkhSrUd9IhZui2CPkcV7uemF6YXUVYzg=;
 b=ONTdzsUh6Tr2ywLqeZQip6hc3wlQPi+X4Hh4h4qvQN5KPJbtf7y1H7IJZ/A1TFmzLQP5E+/CqDI+R9lt39KntDqbGhQaRFzuGnoQS2+d3mKi0n32RhbI8/zU8NMGodFeBfaXS2NKUtIC0dVRtPyRxUfJqnjihoUX0Apjx+U491tzrcimRmJquUTptSvmWdwvojoYrW2Y6QADMVzrIdHOBZLedh4XAWLRuiw0NDOWSS8puRicYqFQsYMojl3tGBlaj1O6kTmL+JzZsxIVyZkQrew2zmCoPsdLJeUIStlM1MQlzsNt+xMURlkuJ9D0ns4wqnqT+4ezORqvSBs2SWolHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMUHmDeo/qRbkhSrUd9IhZui2CPkcV7uemF6YXUVYzg=;
 b=j8JK9qoLtPESDHUq8/2a6u9/PLSWGM8nf1dXSFKIa3EaxYPnD3KEzTkNyqA3s9xyI9nOoNWcqqXIUZuLxafARtDJkjcNmiT7ydnKD7KVBRrX+BS77wnQ6acxGCAxbJ+SmCsNvnjaOChpYKF1hzipQAcZjRAYaCj1UFKps0ISSkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5545.namprd13.prod.outlook.com (2603:10b6:a03:424::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Mon, 27 Mar
 2023 14:27:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 14:27:39 +0000
Date:   Mon, 27 Mar 2023 16:27:32 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v3 2/6] sfc: add notion of match on enc keys to
 MAE machinery
Message-ID: <ZCGn1PRIqti7/Ruv@corigine.com>
References: <cover.1679912088.git.ecree.xilinx@gmail.com>
 <6753bf9b0c144635dd5ed7ff3f26270d60ec8d73.1679912088.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6753bf9b0c144635dd5ed7ff3f26270d60ec8d73.1679912088.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AS4P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5545:EE_
X-MS-Office365-Filtering-Correlation-Id: cc77c46f-4f01-4788-c9cf-08db2ecf6b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2OwE54/U7P0dKMmnkZn1eSRAjItk7BQpfzsrj21aOn7FcJG1wpo+fKpg9iKClP52KIHAZuLcE9BNS/bZVygJA2s2ufhQVg+DV9GCs4KFZH1coHmbJ6dwboyBmukrBQlJwe7MyYNMJrDvFkhzNIuP3qjOtiiUZIewr4aixZYSGlDP3+aRnW2xC4eX7P3aNaQLZO/jw0EptsRcEoJat5tFs89ZRMk+NVQFAix02AStQp822CTUS6WDBn6B+A3DM2VLSSPzu6zWNxjWqgPt6vScSlQKYHE9sv6AhWlVEyNq1MGwXdBy045wW0mfGGttxt6BTjwl6fSZL2008g4BLeHgrtWN2y7tBQy1wqMbDOli6m5X9O1kB6GE0W/L1icCiBaVlHnolDOJuSFxnsHT5ZVIic/6SNXErfIb1bUWdd5m844wedMPy571NZxDtsxDnb7301sMvsV4pEN0NjG6mqMbETnQlSg7mnYIYJQB9Un99/nUpZ0yXQpl/Zgn5eP5L3IVQSCJS3Bo83WxufVkYGla8BUX3hDyOvxosYp33bBoxwGUOY6ng2E1/tVk42j91L5c0cu0NUFZk0wPr5HNUFEEXimUjJqv0M9QQ3KL59rongU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(396003)(376002)(136003)(366004)(451199021)(2616005)(83380400001)(41300700001)(44832011)(86362001)(36756003)(5660300002)(38100700002)(8936002)(6486002)(478600001)(8676002)(66946007)(66556008)(4326008)(6916009)(2906002)(66476007)(4744005)(7416002)(6666004)(6506007)(186003)(6512007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TnFqs6fLdDjBTQszdqQkmpGhO0vILumhOqIw6Kk8wff+P6PRJrA3chBs0ZmC?=
 =?us-ascii?Q?IgGZgtEK4zfXV/qw4HUhW/t3Q0LCQt2/EKyEgkTueqfXgBJfU8oQkVLT6sJt?=
 =?us-ascii?Q?ACgcHslN9wZugkDkgfTICqaDIrk/A9pb4tKIe/voFnqMUUIctPNhJhCL6U01?=
 =?us-ascii?Q?MOdNAfb/UyNpvhN/74w8mJMjqpw1F4sKARUnVxanMy6V4YOZDcqzOHOsKMVn?=
 =?us-ascii?Q?mBLMdH8VviKgOSw40Xs2u+7mIhisLTXCOxuP1q0ILCe3icoPOA3aeX0hOhns?=
 =?us-ascii?Q?QfNmr/hrUsvAlpQXqxhh9U6sL/qZCOgj2T9WmCt4M9C1IWyKzeEfFqv1CKiO?=
 =?us-ascii?Q?A3tncU7cpfT1ieAPG4Ts1ZjLhJbIVrzK6GwNv/6xPV+U43GbN5GU8iufERL6?=
 =?us-ascii?Q?64EJmVacmuIIUQDuso/aihCvRdc9EsoVgIlZoTc4CYzFyeoNVe1Btg9ctF0O?=
 =?us-ascii?Q?54kw21rP7XemycU/3rguEvksQg03pSH+LYEH36ASaSwYMq4TSbIi9zdSOY9I?=
 =?us-ascii?Q?rIwQ9INPC3NogenNpkTjvnO5MOTCr+5y3gdOOXL5SzsyRvPCw3R1rAhgh+hW?=
 =?us-ascii?Q?nOQsDeajH2eowUBh8pqT8JHBrxIR6JfZEpzxMCz5M10xliqMRJ5rEGAzw0JN?=
 =?us-ascii?Q?Q0WEjTw0K4Xsw6pCg1FSe0rGfp5hE8jY3MVwBNVr0BcAG4LDcepEZR6hPR17?=
 =?us-ascii?Q?GvTg3459W2PHW+fAsqTWx4sel19zezSH/a/u5Wdid7rCKog/aFwcP3qKq+MU?=
 =?us-ascii?Q?7ol9/OpeWyKV3IFcuhuJmZze5vaNp3yb86Yfi/eDLJs7jPVim85Q4Lj0TJvk?=
 =?us-ascii?Q?IteRIF3sZunSWXPx2xZ++L17au47d9OdipUQx0kKgrg+gy7cuJKA0hUJSmqO?=
 =?us-ascii?Q?dnk9aa/jtA5rrpz0PhXHqF7NnjYU6kmjQKIM3ZeGATNSEChFIPD5mckm+k4T?=
 =?us-ascii?Q?y86+uew3EkZDhqwBeaDrmGBiE/5G9hign4rIvEVdXGlcGyXraEy00yOfbZSD?=
 =?us-ascii?Q?vas7paHwrq9rCfm8iHdnLQmpIlpZosLAJB/FBq4tEgtwlEyxke+0cQ3Ai4ka?=
 =?us-ascii?Q?eV4NhDx3FE3Zjyy5oYabIJrTrs43QqkqTFF3ZAIj+UUqzPowY6mzNQ72rZ3f?=
 =?us-ascii?Q?M5dCmul9TTrqTnx/5u694cmXzVBxjgPfOV6ks55ubhPrs9WWEKrpwABI6XbQ?=
 =?us-ascii?Q?G80eHXJEF2gQJM1U6a1R/zViG4zal3CA+h3Ya9lOj81EmjwzM15msJA3YtTP?=
 =?us-ascii?Q?gzNsnGhQsUomabOd3Wl1aJzooOvLDZwJP/sDDzkfDMWixgN52oSNC28Tm1y5?=
 =?us-ascii?Q?MjmBbNo8E+he0C0dU9hsPcfEM2MMUIYR2LSDuAUiApu5uXJhGWp3xb9IHl2F?=
 =?us-ascii?Q?kTVaEdEuwsfDC8SGsymmaYKadg8crxqBTVaaEG7uV4ifHEG0dx5WI7OElZvJ?=
 =?us-ascii?Q?CcJRe9jp3aAiOHjbAXUBHtvlbjwKIcPzQ89EGAZBIBiAglRFTeEayd2gq2r7?=
 =?us-ascii?Q?wbOfTFPDkah0cy2sS9hiLcFJXDvxUK7QvSDPSmpNA64zn3RuDt17abBruFHB?=
 =?us-ascii?Q?E6kCJjd3qVaaBMVtqeDSwewibCVY14gWeB438lKzOBS0a66aRgybdgoVMG0B?=
 =?us-ascii?Q?fEm39mtfe2uw3ossdy305x+6P0rb259r6XianeR6Ba6CXOLDK4pTTz8ZOHc+?=
 =?us-ascii?Q?RJ9WkQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc77c46f-4f01-4788-c9cf-08db2ecf6b4f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 14:27:39.9042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWGdkby8PnwyqyCM+e9o2rOIQ1mDLy3Jj9QBZtFbdDvzU5VBWW+B3kjzbJETB+W3q8+R3+xjbtklFT8EvMDkGAkYvCc1GNQ18fq6Z0yvL0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5545
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 11:36:04AM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Extend the MAE caps check to validate that the hardware supports these
>  outer-header matches where used by the driver.
> Extend efx_mae_populate_match_criteria() to fill in the outer rule ID
>  and VNI match fields.
> Nothing yet populates these match fields, nor creates outer rules.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
> Changed in v3: adjusted description to clarify caps check
> Changed in v2: efx_mae_check_encap_match_caps now takes a `bool ipv6` rather
>  than an `unsigned char ipv`, simplifying the code.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

