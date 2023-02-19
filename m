Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5360269C057
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBSNZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBSNZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:25:06 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2105.outbound.protection.outlook.com [40.107.92.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905C2E3B4;
        Sun, 19 Feb 2023 05:25:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFQj95N6QQr80EGN8lt2JW63QYJ4pHDNU+H28SMVIDUm1UFKl+VN6QOvODqKbIaDv4Qqu5xif1VmNdMiSGx3jWlaE/BY2SXE34cbJTViOOfcK/MR9aBLHb99aUU+b/E+IsrXyfxqa+BFPjdvpxCDL/egF14pnuGOhmAvESfKJT7ylsLj0s/zuNx0ApV41CzJXZkriSbS7+F6svnIvaTnRKf1cbZBS2kodGzoMPEioEgf9cwk2FGMWEYz68prhkMeyC7o7/pF0ykjDMNjppLcuJUUpeSeYqf7uI33lvb9F8+y1we9RIu1DHwjEW68C4ZwGXxMHz4FcYIpNg5GddjYew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtNm6+yOdmrjPZHeTEUVC8rYXnLoLYsu6L613he3q+M=;
 b=GtxT7ftHxXghm78jl9O2Paxlhub9xH/NmjZN12h0DZO2LAovxcZqr6v4lpq6qwmlw4HLne9wZVqYUwMzED1Bye42KdSE3FF2rlwngZP3qeKFWuDzhk9kpAplirm5imUVVeSoohuo0K72+aY+yaFDB6g2ELzwEA7oYixSplDFDPkrjZf9IDAHtY5lNIl6LERlelyO0XCUmcPKrm+4CHzkl6RMUzZzRsJExp8cNuAWay7KTbgGbHCHAg09Y5Dg1IoIyVP/7x6TEqcr7VE0wen4qQL4QJTYm/YlWue84mul7nd8yqpQ9xyxZaHdR09jDGZWdQhdgvdH58iuyh/B/5sNNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtNm6+yOdmrjPZHeTEUVC8rYXnLoLYsu6L613he3q+M=;
 b=mTQHrl/FbtNYT1kBZl6fE0z+QIX/I7wYbwvlaUhnk1/IP06Zul5XR8xqQHgYR1V6NIyPW4AG/N3K3Skf8FrEH/FdYIxY7OjJHC3GiZ6NSDlcC33ux4CVnoJAqTonlgvJhT7jVjqWu70YXgZoLV2v6iW6lklwEvjp4icVpYaqrcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5456.namprd13.prod.outlook.com (2603:10b6:510:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:24:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:24:57 +0000
Date:   Sun, 19 Feb 2023 14:24:50 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v3 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Message-ID: <Y/IjIlQSaX6iSmWc@corigine.com>
References: <20230218005620.31221-1-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218005620.31221-1-alejandro.lucero-palau@amd.com>
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: 5963919d-7107-40aa-d2dd-08db127cb1d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K8B2ziAOP32Zl+J/dSbGS0jtyfIE194cQcj9c5yE0oASiQK+G9AUZtqYr8N3DF2HzuSLLPsZAWU2/Nwvf4MYelV6n7HEHw5SW44wxzDTW8OlCk0Bm/Y89nKl5qasDR3Y/NWWWCYeoXMC1Ed0P/6LerAtv1ow8EnD5hW7j4bGDaUFVq/PgzREVXFEeOGUq7vx9Az6lUYfRDrsaxY4gI7vG+ajnUd5uWwEkjgVZ3r2PTmsac7L0zW6EoqrqMdtrSb0QaAUmOn1hGP8+F/FOjt7sg/0YmJsavbwMGf+KreC9YVO7y9Cd6/taSDU/EvxoGlaM1IAl9FSXAS8t9+5sun583Hg6plKuV8+fm+g5z2v8jZnkxx0H5pX+tNhac0SHLWysu7ctah+bp/0cRDNg+VvCRobJAxCD0ydR1Xb6TRY5HbozsC0rFek2dT0rWQ4OWrsTfwerwd5yVZ3o8raokRJjUmXftQ26K5QNSaHwXwIh/1esynb0mOi5GT67mXfpirO2AtVi+fjYwrWSYSJt/LmgpeNxWEJ6TJA85cTFg0g6z/1Qe1cVRDq/7zwTt9SZ2/luAgSMru0smGaE4WrJ1CBDvC8fD82120Dvl6yP0dv87+1OyFYz8RcsYZULVkBPwOA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39830400003)(396003)(376002)(366004)(136003)(451199018)(86362001)(2906002)(44832011)(38100700002)(186003)(6486002)(966005)(6506007)(6512007)(478600001)(36756003)(66946007)(6916009)(66476007)(316002)(66556008)(8676002)(41300700001)(83380400001)(8936002)(2616005)(7416002)(4326008)(6666004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mi6yK2tNKAgFU3xRTrmEPxTNlMc2ZUYXH8Lu+OIpGwc8Cr0YOOOFkQjQiDpg?=
 =?us-ascii?Q?MfIgJdcVOxtZAH1acTyy0jutr3ZFHEOU1W6BGZ1fVHQ1ZesAl+Y54mNQA8bn?=
 =?us-ascii?Q?PkqGXpG/Vs60ohTzz2Bf8SbDrVYCXAI+V3wZwWFazjuCoAA5lcKXaLxY/QI6?=
 =?us-ascii?Q?1eeuG7zmNSBzJcvinm+XGPrP89vP0pxKtSwUpx3h5a1Df/+DaXiuEpMGT+r9?=
 =?us-ascii?Q?jUnJbN+AnfqT7eDEGuyi6MUgbIuQ1MpTBHTTb3nbwoteOVsJ/Y5j9Fu+dtxw?=
 =?us-ascii?Q?Mk+Zn/wfEuKaEp4zaVv6j4UdJjtet/P6yJQu8qQi6+PLEJA+bLNdQYWcIfPP?=
 =?us-ascii?Q?FwZb86VvCi4Gpb6FkDFBiyOQ8iOMHyike/7eFrfvbYEoj9FNU35HkNcWvX5t?=
 =?us-ascii?Q?yeLxE/keqodoS4Dc30hOhahfea9+id+RCEkJ8ezE4ORg7IU0V1AtOvLk/TTT?=
 =?us-ascii?Q?tNYn8KJexAdYJpJDIp1XsTATK91CmTUMpoaAMChwptvNNpJd2Adu0Czd0Lh4?=
 =?us-ascii?Q?LPLcOfBy90rOntU6rZPSkaQ31AGugN2tBurFMfoeDJChXDWxa2fMgF2VMbiJ?=
 =?us-ascii?Q?lBOI6IbQCQ5WmwxnZRYBmLn7vO698HZJHB7SHB3IqQx7uhOVKDzLIJqmqM0f?=
 =?us-ascii?Q?0RZfKSEgTsaoslp3963TV3ZmgLsBvzb/8EztxfHK8T7Lf8TDTfhdUDLdnzTD?=
 =?us-ascii?Q?+zNDWuVDf2+Q+EFbtJDavOlL9d3Jb54wQRtXuc3KjIHu+oe9pqOs+IaaMrFP?=
 =?us-ascii?Q?ASm+aEc8g5lIVdsFKhPxsudizJeKC1XvbDN/Dze1bSG7EXD654vj2wO6SVAe?=
 =?us-ascii?Q?PN7ofU4fIEbZvNfNwUnl2Zw/5RwdLZP1fr4iGazqyRn9MRNpTBP17S0wg/G5?=
 =?us-ascii?Q?WtjQFsU9nOcDOqOrHWl62QjasMlUvfSYI9TiVd8vN/3ss7VdoAX4x0SDvOSc?=
 =?us-ascii?Q?+e40VMSj4sAr33GkSOz1Ko8IMqWi6eXpPEcNKoVgPWt6+zJ/5aFeI0rtLECt?=
 =?us-ascii?Q?s46N0ZD/0YTYm8ZtpI+G3vfDGmMVMlBDZ4vylT3qkX3cpN73kCXFEdiTfFGc?=
 =?us-ascii?Q?5pI1qgZavI5lnG0/ugVt+p29k2NYHct6K3YkV1B7PbciSQSm1iWzqP+cuXgB?=
 =?us-ascii?Q?sbpm9o9ZuACBJpSFl5DFVC85pBOQ2kJMZpzy+xw7Mi6BxntidAyVsBtlRTn2?=
 =?us-ascii?Q?5vpsqwpJho6BnwqQaSWvl9OY0N2yxJUEbnGHA2ElOMgKgSNyaGIez1KUfSBV?=
 =?us-ascii?Q?KkEA6hilmEMYn2iqG3OxG6V6TucpeMc4A3MlZF99ArpPGZcfvqRrGfdarcoq?=
 =?us-ascii?Q?9adxxNhVz0tNqRVTgGA4oAuMIEdDASaWcuzj0xg62dhQoPQxDo1GAHdWNor9?=
 =?us-ascii?Q?RSQi8fXObD0XlUQOymyScpvJwlG38sBwpKvq4/ASEb6dHe2vkMxlTYlH4u4p?=
 =?us-ascii?Q?+hYqaHxVyo9SJl+MEWMDsxsU/tPdwiJVPwDGjMa7KQSwOMAFd3zl5mNtxBR8?=
 =?us-ascii?Q?btXYZfjvKNQQ4mp2PPyFyct2RL/KeXwoIrik68tA+S1tOLsxpWSHkpccPmbG?=
 =?us-ascii?Q?wPnIP/e9WociERNSK+EBN/N1LqBieiz5E/gircV7/9M3O8ODdVfd6R6ahkNr?=
 =?us-ascii?Q?OgiVyDj0L3pLapk1cI6TC+xEyinys47Nwbbwa0XVKiviqa80CktpKF1GK+XS?=
 =?us-ascii?Q?0Mer3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5963919d-7107-40aa-d2dd-08db127cb1d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:24:57.3897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SeLOBI5rlv4duvkMChcI1OP2ihcSKqHKhu15oTyNJA+c/CMRz0UrPvLpalcqXT/IR20uGxZKVhUEomQjeRNDLVUcSSArHa8XFNUvxOVUkrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5456
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alejandro,

On Sat, Feb 18, 2023 at 12:56:20AM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Add an embarrassingly missed semicolon plus and embarrassingly missed
> parenthesis breaking kernel building in ia64 configs.

I think this statement is slightly misleading.

The problem may have manifested when building for ia64 config.
However, I don't believe that it is, strictly speaking, an ia64 issue.
Rather, I believe the problem is build without CONFIG_RTC_LIB.

Some architectures select CONFIG_RTC_LIB., f.e. x86_64. But some do not.
ia64 is one such example. arm64 is another - indeed I was able to reproduce
the bug when building for arm64 using config based on the one at the link
below.

I think it would be helpful to update the patch description accordingly.

Code change looks good to me: I exercised builds for both ia64 and arm64.

> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
> Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
>  drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
> index d2eb6712ba35..c829362ca99f 100644
> --- a/drivers/net/ethernet/sfc/efx_devlink.c
> +++ b/drivers/net/ethernet/sfc/efx_devlink.c
> @@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
>  				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
>  		rtc_time64_to_tm(tstamp, &build_date);
>  #else
> -		memset(&build_date, 0, sizeof(build_date)
> +		memset(&build_date, 0, sizeof(build_date));
>  #endif
>  		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
>  
> -- 
> 2.17.1
> 
