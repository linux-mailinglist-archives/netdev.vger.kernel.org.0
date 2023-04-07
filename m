Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9236DB423
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDGT0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 15:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDGT0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 15:26:00 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2107.outbound.protection.outlook.com [40.107.95.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDE546B0
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 12:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4hgQOh99Qfk+EZqY8oplTf4I8IbT2OPlpmafvVgAbU0vqSrtl9nH6uEsq+8BcXSDpwYzmVO9s3WLX/GoGIOm+0tiuZDpcxDStxKOUfefhQMXUIle973WlSmu3GTC/YT5+55sn7IW25/BnKWuMoHi6byQqCN/oLCFdEDAVr7QewXbGUnNNNkcY75hqr9fLBKDNyHoIwqf0EZwNoHSNVvFaid7KriQS1Pn0pZfRiWo6aDmgkGTL3gAsFmYaGtKe3I5J4wCxN5/7QqcxZAPMcRhIQlMYv1hgYNIZx9+UwDBwAXvS3mmp2yZhLACKoIYtjbVhg2ST66vgxlHDrW29FEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=peL24bxXLmVtMAfIYiJRxe8M8k+kN8HSbuvoTrawm48=;
 b=Oxo1nDqsIj5EH2bmacORK8QikTEgDy73OvCWdb3LKBAvV/F7IDF6AfMHr8S8WYtf5I8knC1ncvQ1jLFzTL6mYClj2o7RcV1HZ7xOFbrC8BoiZWcr7vT9sVt5/emLQ9ZxvZL02q6p2tGMcv8Ptnl50LnwqaiGhH9EvntCTOJyAQnPlkrFLLU+MH2iZDeXLoEBfpQAPQMzY7JBKyze/h0owfI+JEO/KGmX8K9wllBw9TuBeqC1ZMRMArhtzXITTTKESdmmzytTsbahazbqBbeleCRav8/o75sSu5vT3bSY1WZJ075zEji0xAphSj0GaWYKy8k98Zpc7VrDbRf4X/9glQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=peL24bxXLmVtMAfIYiJRxe8M8k+kN8HSbuvoTrawm48=;
 b=dXRp9UnrokXNWhOswfJOyLS2UkbhDjRkaBy0SvLuCSA3VkQ/qBlNQFbyo7M3NBUVWhh/90Goou61fkUG6hCKA7FKKnHOuqd5BQZa9+b84GQSUTDBFf/31J0rL0EE0673CP/gxX/qrV/VXq2W0ZQ8mb3aaruWVoxbEwwx66gI1ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5243.namprd13.prod.outlook.com (2603:10b6:208:346::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 19:25:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 19:25:54 +0000
Date:   Fri, 7 Apr 2023 21:25:47 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de, aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next v4 3/5] ice: specify field names in ice_prot_ext
 init
Message-ID: <ZDBuO5yP4kmUWBTw@corigine.com>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-4-michal.swiatkowski@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165219.2737504-4-michal.swiatkowski@linux.intel.com>
X-ClientProxiedBy: AM3PR07CA0136.eurprd07.prod.outlook.com
 (2603:10a6:207:8::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5243:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c785dcb-91f3-44e6-aa89-08db379de7d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SCFOHHSUrNy7mnSu9Zaz8r/TLNxq5NoCP1FF/Ue62YL5mdbRv5M6FpG+45bpxoA2tBS2pPqfHNX8oz3jLYkn0YTlvyzO+QS4uoKqj0a3hze6ZT7E5Cigm0E6wkPs67d7YoWDuOj8NF2wSOUvyPUgIJsvaGCVCgFmykan+wyxhRgUNTNaIbylMtdllDpGFFJW30QxNzIuR2HeUg6rrAA18/6q10FwFKeN0MXO7IRXqof7ByN+9lk39JOq1P8mHx34PJdh+9XvSxGWvzHlLGTNG7OTIcck9lX1EIUw6vHSd2rW/RQVomjC6l/aJO91GtJfuQegdV+kdDZHRmfGDoVo9elPEnYf3TtU7alC01k0h0T9FFjvtDlsLzWV8rk8QZGnSRa9UqQ+NY30Eegqo/W8YuWZQuNjhmQTUMKFS56AcFzHKj8VQDBfgs1wOACGMtMpHXFsZkGuyVe5xYt0D7BpmBBvDPvx0ahdsaz+1F8sbYHj1DMT7rEGFsoXYEbuo0lfX9Pov+jymOdKb7ZqX+a7bW0tuyQzbnJY3OnGZJw2Xnosorlc+x4QbknpIJr9EMPBtTr1uwgI2jGmin+WEzXrExOEt/0AehWs9r4sw9SACIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(366004)(39840400004)(346002)(451199021)(2616005)(478600001)(6486002)(6666004)(6512007)(316002)(6506007)(44832011)(4744005)(2906002)(5660300002)(36756003)(38100700002)(4326008)(66476007)(41300700001)(66556008)(86362001)(6916009)(66946007)(8676002)(8936002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wvEgua2XZXXli7YVjFQ+3vJW//PvwBikVDLRnwrH9raREqEHrys4URFP4+pS?=
 =?us-ascii?Q?F4APmtAf17lR6wU8aV3U6SEQK13K9Dp/cCQC2QCF6xUZETosXnIfmkTEHXRZ?=
 =?us-ascii?Q?uSTP3bjTvKksFori9cCHrXqSdfQhOXWV1aNy3Z30D2cR7G3YHqnTgumeAtW7?=
 =?us-ascii?Q?Ya8EsgBS1BO7hSamsOo1DrRnt1Pas5eizHXKk9nWZfLRz68cwvuBJR9Oa3PD?=
 =?us-ascii?Q?UZVflFCxOFQVHxETMgYEgosgytIetLiUmGKvMeZ4k2G7zJSLRHqTkctmeL8h?=
 =?us-ascii?Q?lkuHag20oSa9P1Vl+0NhCnUuVEgviYDkaq4hJEvH9quQJyJbjU6YbNYCo2wj?=
 =?us-ascii?Q?GICeEXNbzAPTh1vRnHC4d1ZORu/oZh/Cz/NgGNdBzk8gt0M3MV1SyPw649dm?=
 =?us-ascii?Q?id+GC+MMGrGaeNcNMGx3O2Yix8wmK4lwNzQNRYIrFdhF25Au8l/kVVFjP0o9?=
 =?us-ascii?Q?yuj2S1uOWuFKu8z3TbD04X8+wZdOa4vlJ+9AHdvmT58YTM9rtCTtMdYgGAkk?=
 =?us-ascii?Q?kWUE7GGzM8qxmLJVRDpKI8jH4v57q4HT+KlMQHSP6Wr9BCuwC51BASxL/HpQ?=
 =?us-ascii?Q?HK0j2i9UXgOmhHl0/2VhgjYwMANQSYmxMGC8rGOCfMsdXoA8Rj+cgGmPm9DR?=
 =?us-ascii?Q?GQq4f2ILPHmpb7hhtbigABQNcUm+rkCzq5bS94cT0jr6n8gv5honGc8nuvmQ?=
 =?us-ascii?Q?hdoL3x9yV6e8PBRe1JPcZ1FxaWtrwZD+xPLRknUK8bwq+UANytRVxEWW62Ik?=
 =?us-ascii?Q?u6ErMCTyekZFMFpGkN7QfdUOYoxxdEtnlS05tFUwEEtY1lQAu8T5Z04RTFaQ?=
 =?us-ascii?Q?VYAd6lTe+J/4CqixMIm3v5zkI5fmIDVRTBGjgUNkeqdsJFdtohc2EvmDR//r?=
 =?us-ascii?Q?d7ckCr/TmMFO1WTAGC0YRWQRfotxCLwc9vKA2CBtdecR1ham6bH87Wvppvg2?=
 =?us-ascii?Q?jOOF/JDyc/vItmTHwcRkM2kAlBvVBDf285n2OlWUniSJtAfMlUzHTqYBE0jC?=
 =?us-ascii?Q?wHBUVntQtebzpkiZQejSrE8OfRdF6NeOSlx2vKCpkLSbaSaz1NlXLel9kpL5?=
 =?us-ascii?Q?AI6wFSUKGeJ5CtcS0YA0ZQ3NUPijP/7CgTaLMvHWi2vaW8Yv4ONpOOHSW5fv?=
 =?us-ascii?Q?qKxSg3ksqvf2v+0BxSJPPPkPrRhakQVpATK89UGgC7V45w6UBDrO9MWKgM/N?=
 =?us-ascii?Q?PMGljteBzJqjUoT1nr4yRX6dlkO/A7fL9sypEKlZDszpTHdhbyYB/8Im7Bn/?=
 =?us-ascii?Q?cR/Fsj+jYlvOlUzAbll5sbeXwfsiOEavTcuW7h5TVNVLQhEjgG0x2mCo3I2S?=
 =?us-ascii?Q?sCOgIX6N//OaJAySOa2w2Rvo4lQwLqIm/n0hdZMHFKeKmUcPMqyfkqphfmTU?=
 =?us-ascii?Q?IQH3OxPSWcpPXPZLoiSXmwZIYKuaEJhU3iFDm48pfXRU+E+T44POn4bbDksR?=
 =?us-ascii?Q?otJwlrJCft5N1YDVYM8Mt6ffWSqtIoR2RFGyjEai6A7/U4tlzHTl3PcLc//z?=
 =?us-ascii?Q?MeV0nfRFgRB5pHVeIkhRWyRSvDpBQO3VXBhysbPgt7I6jOl6mubnbCyZEYPr?=
 =?us-ascii?Q?WIsdCVm+PC3tKSVjNfNVHgtFWgbY5706I5A7MWRolBYAX/rZ6k5f2vkDVFlT?=
 =?us-ascii?Q?IHitFE/EfcYD0sMNX9F0FJTWEjCB0T1YenooAW5TAFw978m8fO98Z0DnPgug?=
 =?us-ascii?Q?Ss2/og=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c785dcb-91f3-44e6-aa89-08db379de7d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 19:25:54.4532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6DoUC/5mevH1Kuq92j+B6VtmQyPI0IbV0SSwsGEi6Ylr34fCZGPuxB0Ap/NvSKN7NWGLweUwQpj5dOZo3zGwR//997+qiqRT1xH4lFzgUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5243
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:52:17PM +0200, Michal Swiatkowski wrote:
> Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
> macro to rewrite anonymous initializers to named one. No functional
> changes here.
> 
> Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

