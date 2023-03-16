Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9856BCA5E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjCPJIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCPJIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:08:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2116.outbound.protection.outlook.com [40.107.243.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308901A655;
        Thu, 16 Mar 2023 02:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WW6QUJC/3FmfXxHsvMSQoNRlFlyv50dpQx1JNPtAd3qJk76J/1hk5T0ir3lJF1kYx1HmayOeDpThjafgLbaEt4mWD/FFRyY3zDVMIMC5uxR9DJpDIiOXbqciYUacpMdeu5u//KPI98ARYjAYXTQDRhTmX8k2RFV01RVkY63buJphCIozPseKqLZG3IbSmvDmrr/CBI28tUrVIOaut+g/bzMTcAlQiajJEE4jiq8dvyysGZjiedbCFca7Whdqs56ojQEqeRpunRA5WqQUGAdMPwxO8vBSMHupPd8hkJaqHsVWnOxdTcIco9KdVMhSmOwV+yVNEUqHrQQBYvI9XVc3Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OyaPRtd0wQ1XY95ZwX2VW7/V+0WrcamlclQb8xMA94w=;
 b=B+bDCrwodgqhVcxDomzOUIRJdW1BZIHeHfdBmeyXHTR4m8wLCpClxVfRg2p4BTx7gRA4UX0NohPMAYY1uLXpOAP2QdtTQQvlKJ9qRE24sKU/zkprqr5GQ5jxUmpsAJcnfe6UdMOr+PbazH3mh3/HlWZVrwMDN72JC1HPafD4CgPqaBuEDJzll98EoApXn+0KynQSMq5iP1Z8Vx3V56jIoV/rZxgI9ykpVQIlyiGD6LCQE/Ffjgf6j2PuEi6rw7F6FWxnM8xndR+7+3/z8xohRWpnqK8zZIk1FV2cqxkYO7+gXYe2GgIbFkJqz9CFOBJg6SE7OgBaP/ikA170hMVyiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyaPRtd0wQ1XY95ZwX2VW7/V+0WrcamlclQb8xMA94w=;
 b=kF0rF8luMRLBIwby5MP4qnrzwYzlGnEp7Z+yPx9y5I7haWEKJLABvgX6rB6zVVMiJkXxN14pBky3jVxSWFO/8HNsDyqJ02eF02OIBD07Msf7NJYxnVXM7y9pP8dmbYik3/ATYcq0Q6B4dJsDmoJ+/ar0/8zAmvAOPpAmCpQu/LE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5112.namprd13.prod.outlook.com (2603:10b6:8:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 09:08:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:08:42 +0000
Date:   Thu, 16 Mar 2023 10:08:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/16] can: m_can: Always acknowledge all interrupts
Message-ID: <ZBLclCO2cDh3zmFO@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-3-msp@baylibre.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315110546.2518305-3-msp@baylibre.com>
X-ClientProxiedBy: AM9P195CA0015.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a40e461-f1f0-44f3-726d-08db25fe0a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4jtc2mIb4UK0XQVAgEvFQjdUzX5W7ytbMe6VDTfhEfQPSRUbM1qVEkd4q7uikGiV0O4SzRggCvxGjPfxqxRBZ5/b0khJcciplArMtm+mrk+X6469rRpDS2ipVLuyJOLGMOTc0Vq169Ly6Tkk3WfauUSJSk319fl2cttnbPNDL44oQOsN2yQK24HpzPAbScs0hlpk80kA6A4vryaotgDdqWuC3v21BB3HC/cDFRCgUcyNFgY+sw4kQT6ayHzua+2mm2Op7oR68Si8xTQz/BOY89H8VDMKwM3D77lkB830iCmM/r3vHn5Aw4ZRY92EaiF4laZJ2ovXdFHUEyjltwyIuq88z0r9cIdqKC9aL2DiMM0GYlq8qqW4X0ZK2sSiSDLf+FjXqQD0owopDDZD9ye0P6aum5uWPDh7qbd2gCeg25JyzQu9YurxVrmmdXUcbjlv9cI/XZiESAsve+/PZQ2eGY/sgHXqhtp440LJ2LbAidBmMEzULCgdlUzRrEwG6+jZh2hgh/WxrecFYrLqst89jwH29ycncvyhV/fd3zNCE05gqn4taxhfQGjPfh1OG9qSaE+FqfOoBQaBOSIjt7oLN9/d+KJujjYl1EU/H2HCauht4Ac4z30kjmir/9W0F+w/wdLF/Z4v4fr+/v+KiUOuvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(366004)(396003)(376002)(136003)(451199018)(41300700001)(5660300002)(4744005)(2906002)(44832011)(36756003)(38100700002)(86362001)(8936002)(478600001)(66476007)(66946007)(8676002)(6916009)(66556008)(6486002)(6666004)(54906003)(4326008)(2616005)(316002)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dLEjMJpJlGE4f7TOqRJ+tHT5D8TnwUktBNtLWcDHya5JY5hvgTLgzktIr7P6?=
 =?us-ascii?Q?ab48psktSu5IDYVLuatMoBMjH6K5/18kWrsHODLLD3jnsHKlbgWZd/hmDdiA?=
 =?us-ascii?Q?ppvgbcgfgoxKtfHzA4QXKrZ2cQfWfqLbpZr4F7tOMCbXm5MaBuQ4sIP4WK8W?=
 =?us-ascii?Q?6nh5728YzGQ1IZfLt+N5ch/YBXVwr/W7XLewBP7aW3IM+iOk/EvOPf1OZP0W?=
 =?us-ascii?Q?4AmwOftuEk3s3wqqVk5+5h/2lHJEwgkdyI3sXgLU300CBluDESHIUVyutVHl?=
 =?us-ascii?Q?FjLe6R35n+PDMQi9UHYjie9A90RhEziPLwu8oQFxg3lhZjXs1lLivqPN1DsF?=
 =?us-ascii?Q?8H4q4asXQYg/T+Lcuq7mIS0lY0OIudx0ILMZMo/F1YAD0DH1R+Z2lMftCYV5?=
 =?us-ascii?Q?fSxei63pb5LxVvfaK/avfdWyDlGTZk2zP7pqdPk9akKoTVeUM0PVriId8WIt?=
 =?us-ascii?Q?vc21BUT7tnJfhj9Xgjp13rDGFuWfCgHR2sMz2bZ+2U567jadb3gzqkKK8br6?=
 =?us-ascii?Q?jwSyPkEbqaTiuyujEKmhSkKSfdRRRuCsRFlF4O4T1+B+rieOXvnT+HKmJNPS?=
 =?us-ascii?Q?qbMi0SGubyU/Wr7uf4HmAiNldSrVeC7UUrFcZSxPl1fIwfb9ckAnxPPb8YMf?=
 =?us-ascii?Q?B12DmszqyaWiUr0brPR4IM8xdtREfpazBa1e9JAyXslI3vMGj0GxaBzmnB+4?=
 =?us-ascii?Q?BB2uVvw4uWBuT31omgewxNpu2+/VYcK9gaZrNSXlhdnc0wIyhuitkAPvdvTp?=
 =?us-ascii?Q?O3qmB6z3Ukdv3mylzaMltWTxqrPgNZ3hkb7YKW+pI/Y0CakJGJMuv82srOJf?=
 =?us-ascii?Q?Kiz5tvAinmULAxS0HijjIF3Co2mtb/0v6nea11FaY36xAxcytxVidD6RMVyL?=
 =?us-ascii?Q?Iu8mHS8CH0t0Nn45SWZNtsPXWPrM/LA+O/h4tOoT1hiuXQlPEr+1sB6+X03Y?=
 =?us-ascii?Q?whYdzoHVFLicfFYjajkfejEakd5mmC1Ver5DRIoGJko22v6hIG69hZY7ZeJr?=
 =?us-ascii?Q?lhlD2l16rwbORRnBlrK9c3bdJwlV+UtoFckmhxRUxU+IwIGf7E42KB57hLOW?=
 =?us-ascii?Q?/qNsQu0LB/HB/TcphakSU6BrMUnW+BmhHVTJx9XCq3XuPtCAOkxpmTtnxFD1?=
 =?us-ascii?Q?jv/MSjDMk8zLnKqppA+GEuWAfSwXIT1QjRaazeD582/URJ7hFdOB9H/F/q4M?=
 =?us-ascii?Q?0KNAIFUsL6+ZWnbXRLU2q0b8anOfhvuH1GVqWLudFKcVVkzc3+dwYBRxATgU?=
 =?us-ascii?Q?IUoAVXWBulh2EOZBMRiPBv2S9RxSZufeENicD0+SiHcl4XE+MW4/a7NtO1/1?=
 =?us-ascii?Q?WNnx6cMruzkSbcRCybQI/6Jc6bypqoM8TRYc+azW/1HtxWALgZx0hOgFqM9S?=
 =?us-ascii?Q?cgFmSNw0T3uK3ctkZgobGlsR7Wh2AcRFCz6rYft8faDtQ79ng19U+NKmDhUI?=
 =?us-ascii?Q?RryPeFEFDyaToNO0nnkfQGxy+wmgTwtnj+h4G4kl73Ihnp2mqfr+5iNfONGA?=
 =?us-ascii?Q?Xv9hAc6wkO7tEFS+HD/zjUV5V9EvNqfx3y1RWxnkHN9PV6m0CskcyrHTGm26?=
 =?us-ascii?Q?oLUHZU/jIzu9U02nh9mq7x9y3mbJE8nL+bDkSyU7LWs4F9mrmdx6z0SRZ/ZQ?=
 =?us-ascii?Q?YmfM+u8MM+8zE8oNFXCOo4hgU6XcqKUza9xdkrgh0ZTrm40jNzYeFgNA4gjD?=
 =?us-ascii?Q?fyNy0A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a40e461-f1f0-44f3-726d-08db25fe0a09
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:08:42.4775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RzUCGUFqYilGHml9e9ce+U0ryCF0DPShmXyKS11KAwzTdi/aXZYGgn91F4kNgZ6vIx3txIsWEu7S6vqsOBOgVt2HhO7CqH/N6GMD7VmklhM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5112
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:05:32PM +0100, Markus Schneider-Pargmann wrote:
> The code already exits the function on !ir before this condition. No
> need to check again if anything is set as IR_ALL_INT is 0xffffffff.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
