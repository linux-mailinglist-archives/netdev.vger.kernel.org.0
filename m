Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8D86BBCB9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjCOSxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjCOSw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:52:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2136.outbound.protection.outlook.com [40.107.96.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9BFA5CE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:52:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZlz2jBPQkmjcrCRqV5btbYOq9vvNZcuwCWvAcksvZPh7PuNQn5PftVN1e2hbJdmGFnn0fR+r+M+gH7BEqUIKJnx9q5db3uEKht3cvqcXIEAguLiiToW/+zSQIE+2VudAjLKSOBxYA+PI/OWiFHDUNWg6k8JpV9mxZfWe/71k22MuB/QhMX7qhdzJs0R3/G/wMG7iOvtKgjkdMo830WNySl6hkQ16IJgXRkBlf0ez+l24Z9951beaxu92JZ8FD7BvpyYYZtxIsmW2uurFZ+4R4SyqtED65tA8W7WB8eGVf9rDHYn3iev4exVsvZ+ToftHeQIIXqxqT6qm+ZtLIjuOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBs5CrNGL1l15WneTw0br3V3mKsshrbVLah96IReU8w=;
 b=M+x+34h12eLmlh8E4iNigqhlU5lXLpfFIp9Sgz837WDj4nH3s6in1QfdJQt0hbf1A+so0k+KgERciLp0AKWA6FYnWeat3fej8TV3ndieVLNFHumvisXJn9PtAnbLzjUV7+XD3VGdnxmfewWR8Bqqn3IgM+9uUTsCuRi7UjH4jbpbeZRKbwyy6gxAJDlBryj6MFUhldtGzHAV8eTLw3DgbdEg34Q0pGdWB2WJNOfZgurHeJloRCo5yjHoTRXETfC+RK+HeAP13VfZ4pkBbcNN1d+rUZp6rsU8XHEnL1fp4EPt3g9suIrcRmE5kTCGhN/gvI8TCOuco22zldZu1ROA8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBs5CrNGL1l15WneTw0br3V3mKsshrbVLah96IReU8w=;
 b=bCTbHFjVaZT8NT24jtl8VV6fnMrLXBdLMLVIn6JAtfRWxzz/mHH+oDYrQWyZk+OFcU8lIORLCea7GHUAorvZsvihtvSVHKE3PpBRhHPEGuYtryqcoOCTqBKbCSEqYqC2h6Da/C7eo/xRNfvTnHo4kCY53PFjJCahppbSZrd0U3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5584.namprd13.prod.outlook.com (2603:10b6:303:191::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 18:52:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.030; Wed, 15 Mar 2023
 18:52:55 +0000
Date:   Wed, 15 Mar 2023 19:52:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 2/8] ipv4: constify ip_mc_sf_allow() socket
 argument
Message-ID: <ZBIUAQd7mCog9wJN@corigine.com>
References: <20230315154245.3405750-1-edumazet@google.com>
 <20230315154245.3405750-3-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315154245.3405750-3-edumazet@google.com>
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: ec1648c4-03eb-4c1f-33fe-08db25867cc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6d1NJF4x7cYLt9WWM/AOyVD5c0ytVxTPrYSAyt5F98scL8m17lS/AFb/IP3ln5n6yjN+/8n93QH+LB0573ujqh4lsy3cDJvKpNCMlVZvipPiGu4aXBBmdqEL8sImmyaJ0kHATHCbBIjQhvDES36A7IzzdmoYXWStulL+n1Z2IxUmJIvq1Un/OEtibFbgxVNSVlBuX02XPUwipdVCVwaf1VisNTnCWV5+pIDteWtkSODcu1PbL0gAaRtv3BCWxnrchTEvjA4vvTU1sTSr/G0zpeSZTKHibk4P7DgX6ibih4nBEGFp73ivUcpQLkN9tHgAnpoEzJ26PzRvJzqSAQ9sSvmhzFyb3Gi6dE7PWsAXn7aLK0BDqFTbNnW5IspH0jn6MsvHXRfca0aDz+mJtET9nrFpp7LcoZNg3VWt2cCrxlk6ug5LxlWYsfDpcG1A6d3jEuD42X+f3Ig+nIgMwggLjXWrtCSTuB6mLNjZeSFRt9+yur9sKOYgPNlRbY/U7MLy7E+WUwrEJpPrGzyXmq8ufXwWaMQnNgoPVsfiPYZOxSqdFxJfI3kLWP9Cd1LB/a+I4qCtEDGQlEVyhOdxiWqWRycNzVgYpsiOkb+zWKtF7zXsgOVwYfr7SmUNwsGq+9FLkvtvjVi6vdGFpgvttn8FXNJyR/7gkg/mbs8Uokur34bZLln46a2vPc1ViMW4R+j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(366004)(346002)(39840400004)(136003)(451199018)(36756003)(86362001)(558084003)(38100700002)(41300700001)(8936002)(2906002)(5660300002)(4326008)(2616005)(6512007)(6506007)(186003)(316002)(54906003)(66476007)(8676002)(6486002)(66946007)(6666004)(6916009)(44832011)(478600001)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6rRhfkJotHuJsO32Q6ymeO4r2IVXRsNINT7GvL1GjueFUy5REEjkN2XoMTQ7?=
 =?us-ascii?Q?Zjj7fpc4iO7njWpfHV0QBoBYToFZjLa9qgf2UFcXQYtvScz7bROWwlqON8SI?=
 =?us-ascii?Q?7Ywuq7fXR31fhENUeGZbPjj3sGECAS/7zHQbGP/XGbMjQyTLCBekMWXAY0Aj?=
 =?us-ascii?Q?XcfXLflLUp9o4A9zM0OcyrGN9K5M9WuzYjaqNFAg0Q2a4p5UGnwU8N0CYx4+?=
 =?us-ascii?Q?mo1gvcz8vZtdMnyOxApnVF0bjD/+u4uQTdlpnm8IcX40auwx/3kQIcoTwU3a?=
 =?us-ascii?Q?KHsZKPJlMpnOv6IF4J5ZThonZW7EYcwWPdmUYiNt9dkBzUEhKbRkcBSX2Zvg?=
 =?us-ascii?Q?cB3r3qgciyYO2qfBDJLzxcn1b0M5O5nrdoKoiU+Qlx69dP3A4BXWCSUB7eKF?=
 =?us-ascii?Q?76Lq+NBGFfI0iT3p40M7PfskKxLRjm56hvZnAc2pxRyJRTcwcuLqEpUoeccK?=
 =?us-ascii?Q?o2Gc11Ycwdn0TzWqrPU57vtR2Bz2G4YlENcRds2O+QZ1rJ37I83hIPy8cFgx?=
 =?us-ascii?Q?8ySI+JtrgCOe9SPumsHpe1Q8R/J0Nxmme7V9kHyxLPRbXfR3hmzbqkkWbzC/?=
 =?us-ascii?Q?H7B30NtAzfpSLXQS9qBu1V05kljd3UJIQSsLj7CUAl4AUb/e6go/BEEg5Zgf?=
 =?us-ascii?Q?DerG2zviP1ctNCSmNgHW1D4HdpOT9ptnTnBTu+0cazmRMevaT4shAXoKlpdz?=
 =?us-ascii?Q?WVdl0mA9TETJGNYyMm3H3DIDNOmpdfY91X08fTUw5aDihXpW3Bcr+2WxK2Dd?=
 =?us-ascii?Q?v+09uBssb78qDq2oxKJL92kuZXL3B2Phpso4+rNctZzUblDwwD5qGvEOAhiC?=
 =?us-ascii?Q?C1dFcJiyKpHvtQZsqQyB1lkC+FOZYCrAYjuLiI44RRzVlfZX2sEEfGZ0arkC?=
 =?us-ascii?Q?4ubhGrbqABrXmC3lhbGfRgM/TYz/tXlZWwlD6OZk6VdYVNXopAVCbuPYlTEn?=
 =?us-ascii?Q?hat2fceC0lfmEe7rDZKYHYLO5UOoPP1hvOPdWVhgoHQUDkgm8uaCSL+7ZPuK?=
 =?us-ascii?Q?2pEheVk+46taNkGj1FElak7cyQdIAE0EJERyaYA5Y0BOmhe3nCr6QIDh+GqZ?=
 =?us-ascii?Q?IpAcVs2GOmq1rfLvFNekhe55FCnJiIUb2AiwLLVOcOQ3mF/3QCu+xx2TsHZd?=
 =?us-ascii?Q?cjjzdIQ7aTYUvc/1bN1M3ZuFWHcDKnyS0jFTT74XQD1UV4UKrzuQ6dG3m3E3?=
 =?us-ascii?Q?GZ2/IUfHKg2GqplEpdwMGVDURoKgT3PXbKSe5lAnfCMGtlrCXBAXG7tmF/Uq?=
 =?us-ascii?Q?ODuMHt18Grs8Lp8KlpZ+9tg3xIn3/cDevRVSmz/5MP1tEq8NlNKtDK9u5t2S?=
 =?us-ascii?Q?EwY9QdsvUhMyAQemDwCcfB9X7idWgHt22VWoAP86nwbWhC0QSmq6xWOiCTQ0?=
 =?us-ascii?Q?3HJjLXWwCQwwFxCgpHJ2EiURdVsSX8DeM6UFhuaIl7c2+C6R0pPDyBPCiK8e?=
 =?us-ascii?Q?gRo2FE/lhtT2Wy37q925WHjneoHewva5b3MlO0rta+F3YxggSesBaUwl7fI5?=
 =?us-ascii?Q?dtD8ewNNQgdK/jIJ7VcKdhh9vKBapwsJq0r8J/7MumZ0xbdvnCQjHPenHmIy?=
 =?us-ascii?Q?24/0akYqtz5NqPDbriK1p40N9arGJsOOINPUgPXlBTZSGpZdIuw1GAZttKQW?=
 =?us-ascii?Q?2XcmELbkn1QYLBxnkU6OAv7AiVOQJpkLyQCpeyTV64J/op0GtJMjXsAbec3R?=
 =?us-ascii?Q?rG8AxQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1648c4-03eb-4c1f-33fe-08db25867cc2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:52:55.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LAQPfqw5nnGht3YjiEyUVR3WAZ3nlG+UDnsZ9S8I6eYGiTpgh6OVT5/X7GYvLhYVGvkeAr16h8m6iER+IDSZE6UrzV9f6ieRj6ZecAGU6UI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5584
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 03:42:39PM +0000, Eric Dumazet wrote:
> This clarifies ip_mc_sf_allow() intent.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

