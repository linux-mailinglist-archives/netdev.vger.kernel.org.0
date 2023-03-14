Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD3B6B9A63
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCNPwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCNPwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:52:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2129.outbound.protection.outlook.com [40.107.243.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C39B3727;
        Tue, 14 Mar 2023 08:52:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEnuwo8elZSRBHxVcah6JlkgbAwVSibIB02z2Xqm5DJbTwv39Tzehj6tJnsOaBKVoGNAxJiBRijJ6qzp5txNLq4ozL8O62rcPbYrg3IsxV/xFGzB1EBBFzGtuxPqi2RmEya3si03nzpK/SkfDyN57vb4XyGxSGq341ITefc42tJANKbR1+SLOfTyrS9xsCYohBDQTX2gHpA6NgXFscKH+0P8ZWmWWpytbkgtKwg++tr1VXdEJZ/bhkQUViddvf3nmco2+vdvfgdA5RsqlGs2HKohOxL9+vFMfEFQbIW1tTYfEpYX2M29j6KH+qtKi15eRE8OndI03oK+chdM2SqNtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sIQI8OwyGCCxuO9UnGn/dbqu6R+eUhbXW/AivNIehs=;
 b=Ws5YTYU/suhCYCYUL55O4nPHcte4umkCsO66xgsgso8JjGTe0sN3rXHCXmjunY8Jxwe6j8UG2S7zqlnCito4PWYVMqGyjfbStbZwxc4hoYnWpOv1GeBeu2XpWyeE311GIYED7EDuGorhSw3lCFW1fhjJy8THRxchgOZmvpAHcIc9Yla60gFkMFnrwfVEa1K8aSQ59knj0GYok6VMAq/i1xN+t2HFVK8ZZZagydaqdRhsLWt4qOtV3we5TiU70xTlywHDBs7vT82tQMF4pCKCEqlNAW+BH2T5aBlLTDzma5z4fNlXv/clImUO39IYp1O5bbfeW0E3pdt8rPd3rphDAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sIQI8OwyGCCxuO9UnGn/dbqu6R+eUhbXW/AivNIehs=;
 b=RLZcyV1/ZYXaUBIDU2VIdC7OOmw3iMstcIXlxUT6j41eKBZwH2I/Yj/HxhGblbUqJu7JpmdUprqelOQ8FZQadJXSWbe1RYJ8bIiqbkUfJxNnWZVr2ZrPTc2VZqIzl6UfmGBfswaTMDsgogizQAtIaaFbbXOcCGo+D5fX8zelVsQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4432.namprd13.prod.outlook.com (2603:10b6:5:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:51:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:51:44 +0000
Date:   Tue, 14 Mar 2023 16:51:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] can: rcar_canfd: Improve error messages
Message-ID: <ZBCYCrrYSdXpvGbJ@corigine.com>
References: <e67f2f58d00faeba74558ae2696aa22cd0897740.1678784404.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e67f2f58d00faeba74558ae2696aa22cd0897740.1678784404.git.geert+renesas@glider.be>
X-ClientProxiedBy: AM3PR03CA0054.eurprd03.prod.outlook.com
 (2603:10a6:207:5::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: bbe42ae2-77d1-429d-e385-08db24a402e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H95RE3ckCRawdInFOtSHAmlgN40w74uwWml4VUMQicVqHtMecNS5pz+NzxBV1TkFlHEDHhjZlI6yQ/sAGbrWPZ0HJcMUjdJfjlPV3zfyW6K40PcfXw9mA/FXdwSdmdf1JfzjaLXAN7ZhXzGf45A/0nCyJZzRxXiCAbE//szkVufX1e7eLopEPYOXKpOGBwUV7kcnPnDD/hLxlLTJDhlGBlbIh3gTjq1ujubai5s2Ltvt1ZyjezcTua97jqR9HL2Kr8q1Ddp/BK0YSdf8IgAJhR6mflfFc3w5QLHP8L8ltIK6Q3NZcvr7By56b7Qi6QNgtWYJBIbwXM/C6mhM5RvbwtHcNIr7DJo4gIFX9QfitK0pwWvPUctQf0OH1l8kUN7aLnfHLfopr0/y6ieHyCirTO2nOfeFHOS8wfxXzkkp7SwDjvEemRwYasFGdcD9q31mt1SIJfTrWsErmnVA7wtP+4+kBrR3aUIdmd1bsiiASnl4Puhdg2Fu8tMSe1RY+383hJARCm8oul8W0wEfQ0BWVvCAH5FiuSacAKGWFI3LabhDE3gTe/i8oQwIgUZ/O+CqDlfoeZ8CtunYT68B+ArySPuYl1LA9vXxAjVHd3KK8rKnvuTQCRO5bttdSTP5SgGx9erPjGcO2BDxWqLHpzEnJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(136003)(396003)(376002)(366004)(451199018)(2616005)(186003)(44832011)(6506007)(6512007)(8936002)(83380400001)(6666004)(15650500001)(2906002)(38100700002)(4744005)(6486002)(5660300002)(66556008)(8676002)(41300700001)(36756003)(478600001)(66476007)(54906003)(4326008)(86362001)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbhTjrvWWVW4rExdvmIAGU8bvgaisAt237Q8E+zg3d+eFQILw7KNsPgSzM6g?=
 =?us-ascii?Q?X03IWqTQGi3TKfDd2O5yOFsypfo9ekIcY4RHRs0cw3M0T8SftoixVgyCIF21?=
 =?us-ascii?Q?XrvfIb2FP9ZysYiwOx9PRJHQSCC+7sLWFS4rMv+aKmem2bqmodkn40lzXnWS?=
 =?us-ascii?Q?U7o0MWL4JGyV9jU/UhJ19yWYdEZbF+KC+zqWcRW2PKVmAc0Kr88m/24rv4dG?=
 =?us-ascii?Q?H9/0agEggtnl2W18jtDnK5JYoPRJkWhg+aPDYPDn0CJadQUcqXxaaJD/KCWz?=
 =?us-ascii?Q?vhhJTO3ech6yAKZEeUIUwuBXj62yUQXzXTWm7Y4u4BPsBVpdvyjtE8y7u7nH?=
 =?us-ascii?Q?cul+Z4bYk+fWf3jjlnVZ/fFvKfSgNDMFnq9sJzKCz5sP0O2Kjwwr4iSw0/Oc?=
 =?us-ascii?Q?DCDyhFVpFgyhqfo7hgxVeyvC+171K2A1W39KcGPKGPnyKS27rzdRJXRH37M3?=
 =?us-ascii?Q?aSzQJhlAxwqtD+iQiaooj9SDh5N4dW1o1E6maAGeAwhZEOvDWjM94Bb/pmNB?=
 =?us-ascii?Q?mTOgCo3dH4xtHVxWwZbHs/KOPzFOi34qGA3GD+CGKGhkor2fcJiuJC6okh1s?=
 =?us-ascii?Q?gmERArYcDj3owxrmcJnuaUZA8zJRYCAapCX1rCRc8ypwvLXoq2qr4peR/a4q?=
 =?us-ascii?Q?BXNKYTLospNj6CSzEBc1cMQBrrYJoCCEO/bvECpdxaey/FpHH6hAw8izueN4?=
 =?us-ascii?Q?tF0z+xxmkQZbNnvXb6in8wBfufokBTkuwAeS6tqDfC4/zrufTt4S3KVhhac9?=
 =?us-ascii?Q?HFSTdG8wL2qiTGk7zK9KQYcq9Lkby20Cu+c2Zcrpksgpct/3ZcY2NxsznDO3?=
 =?us-ascii?Q?bfmugs0ASen2nDGaJCW0aSLP6zL0lbnzDe2tGPP42xKXC2pYFpypBPIF6I8k?=
 =?us-ascii?Q?iFFGbCRpOy1Qjr1BZ33ACPhtAVVHaJUBdwI/XOD1yqwvysPyQU2xTBYr6TrS?=
 =?us-ascii?Q?J3nDm7GcUNwQsXDvtRHTq24OTg6SWBcpwcCgYrivUJAXcijIWRxVh1cJ+yha?=
 =?us-ascii?Q?FQEjTc3ieznqHuUCfuRcYpYz9sSu0nE/BQwCoqhksQk6KOmG3GE+XycMKqh1?=
 =?us-ascii?Q?hUtcIEKs0FcCVB4/gBiMN1LAAaxW78j40yVm384YSGui/agsnXRojy6K0s3J?=
 =?us-ascii?Q?VSc//0XeQ3+s8jprQrz2ZKxKozXTIBonENWzi1cMj2myQJqiYgmcvGQr0261?=
 =?us-ascii?Q?jdxZn70Az6QwtXJ3ucAXkf0TfRZ9AYq6IAfalQZCd9ajGCitDbZa60z7b6Co?=
 =?us-ascii?Q?0G+9XnMTu42IUWVWmvUTmQM7L99ZCn/fsANrsIVZkjU8xhFFZVaa9Qg93ibH?=
 =?us-ascii?Q?gjOUJ8JyxPpY/I0Cdm4ZKUxHkWCmTbDAJyMm9xYFiRxv0VoP+8n6svNofKLb?=
 =?us-ascii?Q?8zhciW3XfQfWlNKAfWM7Jqs8Xby4DSCOC0XRnBpa4eQIlgMMJu6TIlFmYiBG?=
 =?us-ascii?Q?z8LIwljE3wulZHfT0L/inerwqOua6Q8avYy0ynP+tyBW7rIhBkOGYClon+/I?=
 =?us-ascii?Q?ATx5eWEC44OQdD68zsjx+IlSdyhacBkDeIKWk/mrlgFacjTrxH7X3vAqvL34?=
 =?us-ascii?Q?KXGJsZM1xMDPuwky+VKii0Z5gLWrjvkZBW/IqMubdVhlc0wsXYz2sxz1p2OD?=
 =?us-ascii?Q?bavQdlGfRxK49gIITOFeIJ6yn5jBbhvEc5Vas3JE6JkEBwpveoosYhbqn/i0?=
 =?us-ascii?Q?5VB4Rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe42ae2-77d1-429d-e385-08db24a402e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:51:44.6411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAT3nAHlhYJCAMlFfxNTJQvcQHMkU/OIqf5nRgzuYcrgwEmOd8BVNSxOcd3dq+6XvSQVsOJ9lGo823/MrvgtHyl15NHt7kFYvkHfmNWMeCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4432
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:00:26AM +0100, Geert Uytterhoeven wrote:
> Improve printed error messages:
>   - Replace numerical error codes by mnemotechnic error codes, to
>     improve the user experience in case of errors,
>   - Drop parentheses around printed numbers, cfr.
>     Documentation/process/coding-style.rst,
>   - Drop printing of an error message in case of out-of-memory, as the
>     core memory allocation code already takes care of this.
> 
> Suggested-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Hi Geert,

you forgot to sign-off.

> ---

...
