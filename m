Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7973F689BEF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjBCOfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjBCOfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:35:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2116.outbound.protection.outlook.com [40.107.94.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEBAE06E
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:35:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f94+th/1gBbGKwuCzP9lrn1iy41MLLyjfGnNpClp7av9F4s1wH32LWYQzBjwu25GcyxN0VQhlURVXaeMzZK5T2HfC8xg1wOpCIfJ12gd0TAXUuCCFPJ6u58OS1guKF5ZHbLF1IT5hpOPvZAZddT7w/BauUoRelPfS3sC8d3Si4DIKfsX2msGci/2cfdEknAe19Xg7YsYg8JnDnuaqGqCm4XTNorcYu1XnBs4h+BMTCBkgApu+dYEZswczzKeq0A9EQ/sahcCBqgbAmlf1AssbWOKLyz3/5Pqx8HO8PMIA4KqGkjMKOAnWqly4Ei3feb0m0wXScuzh9uPS3SHBLvV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uvXKzO+KKYmiuuunVO2FwOgcx6izP1necl8fy9IwoNM=;
 b=NUXUW2lAI9Cy9frd3XiKE6rH74PT3WN7vjRjWbBGUX8c02gM332HoCyvN0bMc95ttZz5jBldmmRXxPKn0nRAT9gvSrSdTCb5mBVSggcjvk7SaH5x+WItnFf0Y0t9aSPfluuE+AMMg0OgD/TU4bH0E9B3XOooczJQhmOHzHDfC33WvpdrLFyAu5XkO4gRitaixJmPyJSbFJKKNyIxyQpmdHfBkmRWmMbdrK/LqF3waZMjZowDiYcQ2/TglxF1hOVhHBzmeAoP1FX8z1y5lMX/qZe2lxz2PBQhJb2oS4OOfI/fLn6Z9EZZAu7EO5ORLujP1DqFXLmnW364qVLVhyO1xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvXKzO+KKYmiuuunVO2FwOgcx6izP1necl8fy9IwoNM=;
 b=in62qDnE6F1ahVz7MUIP5g3I74mKj76rybj58ENKUgXFpkjS28HRK/zzqMR6trnHiTAAsw2oy0uVY20fvcOn8ZBxsJK93+zQpaKYjW01PNhV+c2SjEB4bI21uqANIMWyO19jMStktAmh1A3/PosPR0Zpxdwez+HqXS5y7MaLHTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6225.namprd13.prod.outlook.com (2603:10b6:806:2dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 14:34:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 14:34:59 +0000
Date:   Fri, 3 Feb 2023 15:34:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next 3/9] net/sched: pass flow_stats instead of
 multiple stats args
Message-ID: <Y90bjKyXHZDclNSz@corigine.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-4-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201161039.20714-4-ozsh@nvidia.com>
X-ClientProxiedBy: AM4PR0501CA0061.eurprd05.prod.outlook.com
 (2603:10a6:200:68::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: cd8acea9-2d2d-4c75-51e5-08db05f3d3f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wd+BA1MqcsD3t/GNzWc9kpMlPd/p3mJDsP16qtapLq5U84BUvmJ0G2AeHBtWFM0JEzwmC0+9PoLYlnpfrUWb6B0QY2EtLjo4qLhyLTbh9up9R/XpTBkULgSPW32AH3r421HebmwQdfGdNLMtJL+g/UQlAN30wQudnY+vCnNpeAlNpm/r3iLdmB4o2kPNDLu8xEXaIJ7QTSRmYXRKR/7qEvLtuu6jnSaOz+oHRs4oU8HIgi22EVPSicvQORiO9+A9BusJ2MRYe2/SctyiiKL55mWv9zXpSAOvs34RoWjKV3E0VJNPn+MFoWazH8evj6Mv5/zAB8KxVsaamC2zpT1odTnq2sFx5tFGjgffrjUywlqFXNMhFI1P0WlO2as25UbAbToyJ1FEbSVtcF9HuS06zUaTKD5dCzacPxdcsBkL8Y/NfbDsfeLmkmrw4vvPt4XIW8qxMqCTcbtoux73M5vGA80XGjal2MOoiWmB+MbJF7Rkr878x8uvE8d/NV04zrOoaLs8NVnjOLI2PqOZWbhirSDNx6c5YOVHDTfZeI/5Mprpqe2bsKun5Ub2hx3rgpi0IweRTX0c5Q27BEllROdwdJIjDjBHLUnh5dJq7KtbyRf+JE+H0bJy/bNlFUO0ANkyKcQ09jRiej8uLnkSasfhMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(366004)(136003)(376002)(39840400004)(451199018)(44832011)(6666004)(41300700001)(186003)(6512007)(2616005)(6506007)(36756003)(38100700002)(54906003)(8936002)(316002)(2906002)(558084003)(66556008)(66946007)(66476007)(86362001)(8676002)(5660300002)(6486002)(6916009)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eeMVjDlJKWm2L3ryYjguEUvbVcfNCfZWAWyDEY5yi2k7dR49ifHCyhYENLj/?=
 =?us-ascii?Q?3qPA5f8PjXUogOV7ej2nDdZ7fSlZNIQ9wl2ofZH1qqW0jNQOdG8vK5sncc8a?=
 =?us-ascii?Q?1OYgpylzMVJpfkPvtsrx+BcUKKfUU0+Jyl++huUl/k9RGaH5ooDhnRKZqD0H?=
 =?us-ascii?Q?5vScfESLcnX0WMSXvHUzJtT6+Hvt+yr0gaB30+c1r4NTtki4nk7LDI5Pr8i1?=
 =?us-ascii?Q?bE0GToHoRZFFvD9/89N+Kn9Z9F+Mp+dX1oqxYISgyx+qqxQVpSqlMhgfeQ1z?=
 =?us-ascii?Q?wcDPDfLnckTdfqgoT2cLpolmYs1V6aymivHRLG3wb9j+8xrk+UYqRfnKBhxj?=
 =?us-ascii?Q?WHrWqa9UVWC6rUOW86yRxiM6vBdcQGbFgC5EYf0ZHkFirFQEWUq5jPrG1tkZ?=
 =?us-ascii?Q?C8zNsHS6efER9bl7SgGaTIsehm0YkyYuUfQYbyiLBRZN9uRyp1SQWxo0s0gc?=
 =?us-ascii?Q?gmqxnDVOeWwxZ+pN62+E9YbO9VZlKeYtdRsUxbHylYNqsH4UZX7BPYoJzhBM?=
 =?us-ascii?Q?1sTZ88coclwVnEs6nVUs7KQzON4VcoeAH2lrWEV5C5c3ULqGv1TNaqkq39Ew?=
 =?us-ascii?Q?K1p7+fXFD7WZGHC4912H0ZITJTKEQb/rfU7DBXfdSTo1TC9KQRAIw7LMS07P?=
 =?us-ascii?Q?0RKOHo1IHeMWl3S5AfjOxPbCCZKBFxDmBhIfmS+ZTchTLDPzk/Qg8L5z4d+D?=
 =?us-ascii?Q?Jo3/Bj0YYcco4n/eYCQTQrjIbv3Et3U02ZA2txfXFAbTZybwexKPvmVIpnYh?=
 =?us-ascii?Q?QV4V/qaA6OY6OibWBsB+5odGWO2VCcOiYRGtWPhtj6vYF7XYv8+0QmkhrZ7V?=
 =?us-ascii?Q?buBo3+1Hdr+x0IFyYq+VC+WnppMCFym+a2K5+L7CEvpFjNajnBLVWwZnfeAP?=
 =?us-ascii?Q?HC8BmWOanRNcqIYu06+qKh+EIc8al7611mDur3oSKGSQoWyVKkAkeuIkTDJm?=
 =?us-ascii?Q?7vkxRMTCPRTTgTQCdzKkCd8FEk21JfaWMedo4Wjrt2L++N0NqJXTmtrhn8kk?=
 =?us-ascii?Q?XZepWkXKkQpYT6xVxf5WHBmo+7L5qeGpQuLCUX9n4ur4yc/Kf0poA1D6fGnZ?=
 =?us-ascii?Q?yVAFDMTtgwSo1g58/Iux3oVIi0sbSFRhvsMzYHW3L8hg7Tn+/qFM9H2ZAUxq?=
 =?us-ascii?Q?/cwQ0TpXwTkaEbeLscxXcP5jHebjqaeF8m/5C0xSpbvBYcXivheLDlqzxQ6T?=
 =?us-ascii?Q?b4DTxXFBj1PQVfnoxfugHcWUbOJ5UReuDYheBS0kcTQYZkMxzRmotTb8tMyn?=
 =?us-ascii?Q?uDGyjps2zKdxnAJlzLu520VgjOh0zQpkSmErpkUnKb72mfBZLOKWnHPGuNs8?=
 =?us-ascii?Q?jenqxoBQeKqcNc1bW0Y0jWClSPhydKEwGb3cazNvFmvmgaGjpQKqw4RN6S/L?=
 =?us-ascii?Q?BI8bTTuMQqa+PcxXvjqbwvjeS0eHMsMdj8+HMWoV984OsJdJDXUezK3iS9Yg?=
 =?us-ascii?Q?2Bo/l48snJTNjHPkGVTZVN9ma2Vsrscqt7BCsaSQyPu1DaN5t1jE+LVxO3f9?=
 =?us-ascii?Q?MetAYfue+jF1T7D+giemh2ESBOGlKsNcjWnYDU/ClXQpLSzonGm+ABZ1GKDD?=
 =?us-ascii?Q?hQVjUUblBDCn18SW2VMGfdJjxb+UGXv4X3Amu1b9arJpj3u01GPPy/r6owx7?=
 =?us-ascii?Q?KnyPDcVA2VFORX/ntxqgNeQPtZ/XM0/6IVVDw3Nsr6LdvtR6TYHTKcD7V/Ob?=
 =?us-ascii?Q?t2gD+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8acea9-2d2d-4c75-51e5-08db05f3d3f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:34:59.5618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+NfssOxt0wwZ67SnG3XSz8cuqZpJcwR/TRxo99RtsrguoD9RIBHoE47l61vTZlaZ2GoioYKiVuEshEIwcCEEWrp15wqlI3Wre34bpXETrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6225
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:10:32PM +0200, Oz Shlomo wrote:
> Instead of passing 6 stats related args, pass the flow_stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
