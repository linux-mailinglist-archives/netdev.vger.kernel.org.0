Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DDF6C9488
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjCZNga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjCZNg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:36:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2130.outbound.protection.outlook.com [40.107.92.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41F649DC
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 06:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etecxJ7LodBx89ObmqQ9MW8YzEClJDJxQwMqVpDjUuMYq7NEFrKdVveRAOBPFYHS3/b8R9xeMvJjp8Xhr9bcavZABZ/8rRQaFMQNQYoFaUyNdVXg/nLmBsCJkmiZxJpQPTbsRzfx+6Kiati08fYRLCty53Mb3CjkzG+tzMcYN6s/SrHbeOVVmWO0D+tAJY6D02hrOSbuK0gQ8QVN9pxyvVIWtI/xdHDRfINmf2ggAdj8yf1L6lr9c8zJ/nRKc6ggceR3NEZ261U6baAooPIzklzJIQTmBuWwwynFJZIx0dPxdozwAwoKcqIuHISqonWer/ZM+5XHLH482i1jWYCKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enlYcpHdHcTXbBBM/AVtlEkot0Wlu6n6oHHaUXeUl6I=;
 b=XXzC3A95wEkZRDk8QIk5LG3NYKkiVtvLn+nS4nAAc3bNGWmtrJBlyrSUoL65xkagd10oWEJ7zh7uCI7D9wRX571i5KZFMupIfaYoV26Gg/KvU4TUm2wMofVjEAoxKFFqBE/BIY1VrTJnaPiYj5gMl7PKHEYgDfPK6je8gr0GI9KaI4yyCsNu82H6abaRuw8OulAbc+wWZUfSuxyjQVwfW69QtrueekCQiQTwYqqUE1QRqE0M4kSjXVIUY6wQuIWuyqbU4rS2zaZpvVXQp4xNo5CP22uyMstQlffdCS21OCUDG/O2nTYvuH6Q3cPIRi2iXZYma2S4RFeMi9PxX6LaQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enlYcpHdHcTXbBBM/AVtlEkot0Wlu6n6oHHaUXeUl6I=;
 b=JMul7uYwuxYLzkRg4eXQPkFeWmi1LP+vb1KrTXAtZIxv5FOyOpp+sG87DvgvnLNQuUI/9zrF6xuQn9M6qnieHupuK6+2XPxzvRXQaRjuvvPcPr8z0jKsyy9LaBTAWWvnHwloaAKH/0RRa4D1kmW9/yq0ZLW0w4J3DwOZnQSkgxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4428.namprd13.prod.outlook.com (2603:10b6:610:65::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 13:36:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 13:36:27 +0000
Date:   Sun, 26 Mar 2023 15:36:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
        jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
        lukasz.czapnik@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH net-next v3 5/8] ice: remove redundant SRIOV code
Message-ID: <ZCBKVN8x8aQ2SY9x@corigine.com>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
 <20230323122440.3419214-6-piotr.raczynski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323122440.3419214-6-piotr.raczynski@intel.com>
X-ClientProxiedBy: AM4PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:205:2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4428:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f907f4f-e2ef-493a-a89e-08db2dff1957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9mSBm3wlAdu79jiuocOHKOtMqBp0mlMC9XW1/mtWKRHbFmnEz3AIT1d+phDajLQGPDnpTv3uHx8EIfK4ORcd8m+vl38ESnqr70a03Bw+mgz1FVKFTMsJVI121VzAepk046gqGhrGAu0S6O18f7l67URs67hXZJvrUSxLtcEOywW9nJ2ossGbK1lSo9Z4w/5wWbgxIXEGTZ8rxwgIR9/0E2DTIT0a9kT5kHExrMa0KfcF4/vqfco/H7xKQwsRtaBzI+xITn008715SdGEBFQRoKXJLTrI92KjY1zn4+KZxc7uF8PEgFMkBZmIwUINF4yJxHMAV7rbstFksDEAolmSdxURIquNnrQkJ6vG6LV+Q2u6sJDKr4BxDfJBTt2/cY5m8Qlx+PHIBDslZpM2HvsvRIs8mriLP0qz+vn7hVyX6ueTiRi9rnvOWPE/dwkuYq+ftlpDmYNiu3ekHYqITxqkAMINm6uRi79+iohcc/P6VbqJSG4KfBgISmDT7gniSVsgsSBy1ESKdaRy1fP4CGUiNE2Tb6rFgz++fgzQCR445QvSsZbjIRVItw3uiUniony
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(366004)(39840400004)(346002)(451199021)(186003)(6486002)(316002)(6506007)(6512007)(6916009)(4326008)(66476007)(66946007)(8676002)(66556008)(41300700001)(478600001)(6666004)(2616005)(4744005)(8936002)(5660300002)(7416002)(44832011)(2906002)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xw/2eVerfzYtu18HiUXtBvYcLDAbE/dCgYB9Epa9m3eboEIEpOE5FLxhKHct?=
 =?us-ascii?Q?w3YJUoBxckdN0h3cbuS7xJzOIMwVEmqyRuMEKYSDURH75H64oB6+GjEkkPcT?=
 =?us-ascii?Q?O8uHCHV/8jICf7W8Nlu4IensTQhtp+g7nHzhIbDYaDo3Dqgy7MzDB6zcO10n?=
 =?us-ascii?Q?die53Af5CC2rbaDYhf4pUo7om8KQNDQL6KBwtfEUaA97dmx4b6UsFxfBJ6sc?=
 =?us-ascii?Q?1EggeYdUvIiSZwwRkgGAZEgcab1mmU9nZBvD9B8I+4bkk4ZaLrC1QSVSEIln?=
 =?us-ascii?Q?2wb1EyRrOso9HPB54F9hukNiIWARFXgST5p/MOjGY1j9GoMSrwn8fg0wMztk?=
 =?us-ascii?Q?lz7Vas6CM+nzbtvhh/tg+viFzNkXW6c0IGuBRWdLab0I0NXfx08whQkW28HH?=
 =?us-ascii?Q?NGrML5YUMAg0MZ087bW6GeLMnZlUkutdntXGcmY70yQQjL8kE7IuxL6m6CX0?=
 =?us-ascii?Q?Krl0rGmb8gLptMSZD79AvqjvDIFQc+yC79UtSDa4SYBzzCTtIcIs2ZtaJDCJ?=
 =?us-ascii?Q?XzY16LR4mlnbq65pVWM8zwzzIMTE4hb6VQmflUphbbRxR8cRcdgAdYlXCSIU?=
 =?us-ascii?Q?2EmwmcQdzT0smN4Nqwpdia4TFwFG/YB99DK+emGYDFc+kVRDhU/CcF9F2ZFO?=
 =?us-ascii?Q?TfmnqZpOb7LRu3P5HvGyvbU9IOY4V5byQGSfzkov0W8Fmqdct6dKEHmd65/u?=
 =?us-ascii?Q?PqdxN7671CUMcgbR7rQyTvG0Mr0gdtPPnGbvz7XOBoC9aCsvsBbPvEBDatKD?=
 =?us-ascii?Q?Gm84wWb13CGsOLa0h9KBRtA9w8li6QGZXb0Ao2UbGtybWr85B6veP1+d03Uc?=
 =?us-ascii?Q?0pr/AIphoAsyxTTyZ4pwF/lg1SKjK4DPgeHlBw3YlbCwrak1LfGwpC42wjEZ?=
 =?us-ascii?Q?dJluAT4hjtIWutfz6eMEhNsWYsoInJgZM8p9eY3HzKpU9zFwLu5TwAqKnHnK?=
 =?us-ascii?Q?94WCOCDzyO+P/93PVhkJ6g3ZsbEJ8FAC7OlLXSFCoYAmm8iYzO/d6n6DkgP2?=
 =?us-ascii?Q?AwcJqzWTRQSfMPmlKJEjzsmedcJlZABqKL4jraNyPBkSq6bYhDwrHp6XZOIq?=
 =?us-ascii?Q?Ms+kHlrnHDefDYn8/LM8gRydL8WUvkb72JTkEU0+azKicPPDDMA0KThLQHQD?=
 =?us-ascii?Q?2XeOeuRUoNVraPMG+Im5FIpKsMmv3NqNHY9xTKG9hgJb9UGKAHKfdBXvy4Y/?=
 =?us-ascii?Q?gxOy4nNbArz7BTAVYy4l6jXGGPXWK0paWsmnnF0jVftveEvTGK2b5S/IFLHH?=
 =?us-ascii?Q?29z0aZNpbiH6wvO2fPpIW7nmodhvYPA8UKgWon68y/2GaPvdXauP4hrVb6V1?=
 =?us-ascii?Q?2gSJI2iZa6KFxhOK+URApQO4Bwr8mKofnrX1fPDt5G4UZyzNn6UyA/k/pDOr?=
 =?us-ascii?Q?J/axmIgWPpHZheROF+3pyZ0G06wy3lGKLph/Ln4O0EShfOkh0+Dv88yv7fhc?=
 =?us-ascii?Q?1PcFG7DPGMEIA0m0zHghpO3vfsaIZmkXV7ZX9f8tgSWFrzGq/3lil+lngAJ6?=
 =?us-ascii?Q?oOxBoO+mjU80lo4+pkhsZ/AkN1ACI4ZdTdaZdMrqnREq4Dl77wcVSUTpOvZ/?=
 =?us-ascii?Q?s5cUbwYSj6/7KIAU3P+8w3I0VKvd9x9QOF7i+rmKOSVEMHDWWzqif50f41zd?=
 =?us-ascii?Q?TFpUbS3uhkNS67oJXtpD89xz9Pk246Oro7HO3+yvOIviTDYMxWse1sqZnEcv?=
 =?us-ascii?Q?aWgx5g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f907f4f-e2ef-493a-a89e-08db2dff1957
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:36:27.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: axkPey3mAxjuITgTOr3UpI2r09zD0WAY8wZ9XGQaL588lnM4HTDG9rRxRLShCCbZ/jk2z58PdABIEBwLcrAJ/KyKA1Yg65BfxFA8oDddJdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4428
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:24:37PM +0100, Piotr Raczynski wrote:
> Remove redundant code from ice_get_max_valid_res_idx that has no effect.
> ice_pf::irq_tracker is initialized during driver probe, there is no reason
> to check it again. Also it is not possible for pf::sriov_base_vector to be
> lower than the tracker length, remove WARN_ON that will never happen.
> 
> Get rid of ice_get_max_valid_res_idx helper function completely since it
> can never return negative value.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

