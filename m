Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF987482485
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhLaPHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:07:01 -0500
Received: from mail-mw2nam10on2135.outbound.protection.outlook.com ([40.107.94.135]:37088
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229453AbhLaPHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Dec 2021 10:07:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQaNc0GNPmKxQckmsvUGJbW3GRXDI5jhV8bdq2of87ykA/NPF/Tw6YSYOp0j55IPtYFM//Wcd/g2fCNzXMRwVePv5qBNbV6cBhZGZoyDnCy2FVXaCXGA1eAYWcVXGu1C/90KdzEvE9UCF2MNx7PEVBCUYA+n6gXvASVxu9hn069mGd/LcA0PLMhNZyAYJDKVjSSrzxz2NcH4ZVeMTCDTdV4iSKwT9QUdudfD/GF0uGNrsvIlEsvw5+Y3k8kmDlBg1EyeaFhF6e+OTMkJVDeZKtoabsZFKvF6XIE7Xvtw4bao0nhHxwZnua8wdSH8F/eh5vBAe8BX3utMd20Y00i83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rjm8CYyJ2EUlCAk0lG3/47/377w/RE94Kz0O9wgPC5o=;
 b=Zl1ZOsILUK2B8o/yBomX2BqlYlFDeF0Hn/qi4qF6yVXFoKWz4evmRLzUdnG5iPpIXiZf2vn7CZTptfS3A6TwW6nR98Pu1g9UD3QysdBF4aCnbV2uyYKaFRa4f3kpK9U6ZWsGpvq/hd2Bjrhw3N5B6I2SElWkwl5Co4rBvP0Ua2TLdXbCxOt5JF8c09BjCtpx8JcS/iWd3MOlx5mPU8fbEA9xCVmRAsxcnKGTAK3WCo/JaVNC1QkiQnRvqDdRjejP7R2HI/zVuB88O/VQOAhfHVs2x9+LguZYK3ML9zZhLw06d46iJBh/S4BOw9GN4YsFmztYizt7J7CIFGrMJOdxuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rjm8CYyJ2EUlCAk0lG3/47/377w/RE94Kz0O9wgPC5o=;
 b=SnWqsCTyuj6RG0p4voyWk/pggeVfxm8CNT7sxg3UUXlohoWYB/HG21fMUaYZTzDkVzajoMHzU4zc3neHWatXfm470Sf+2dM483Mq2y3T0GcU4RYNQdYAJkUdUoS9YXXcxCrjzMf0+a8o8Wyryt8SOJkteY/JsABPU9b9PSLtzmE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5652.namprd10.prod.outlook.com
 (2603:10b6:303:14f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13; Fri, 31 Dec
 2021 15:06:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4844.014; Fri, 31 Dec 2021
 15:06:58 +0000
Date:   Fri, 31 Dec 2021 07:06:51 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <20211231150651.GA1657469@euler>
References: <20211230230740.GA1510894@euler>
 <Yc7bBLupVUQC9b3X@piout.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc7bBLupVUQC9b3X@piout.net>
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b936ffc6-7580-4e5e-95a4-08d9cc6f30b0
X-MS-TrafficTypeDiagnostic: CO6PR10MB5652:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5652EA0439AF62EB8A7CAAA0A4469@CO6PR10MB5652.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PZ5eXGrmsIp2LsU5LqeAlMkyeSbLv06uWp656bJdyBwvKPVrEon4HAHbvmvQCfHBHculovWtZMWw9pUK1mPg4NdUWIQZD0Fx067h8+GVehQIU13B3XaC+kHA0WzuHcTRVocs6q+cY0J0isOyYWV5zwLL+dcCqhR1pYPnhYyX9YnNTrdrba/LK32WHSDcWOZghuwpeXna0JrL7cmhGMel383vZTwAY6nvGG0/pul/Qdzz60EitW3uVGKE7lWxxUaW8KAI7/p8tPAPiFOlHHn9JTzas5WgLFQI3dzFiWnzCODGvhfzmyr4K1CNw6P4HpRMYvzaN4MIeaBqb0eZWoMYHGqkzSIHTZlQFlslWPTUtIIOybjzTDQbdelVzQafj50CSD1NdSpucFFfxLaKT1CjPYn4JdEYrauy7qUPrMg2nBzXrfHdZf9vpUHq04UdB68KtwXgPm5BhsC338jTE0i2T7V0IULq9C/eBfBMnL5alxXw0d9Jr6o68LeqHg3YaDVDq0auOUrmcoz9M6j2a4Tgu622ugCthWA3bKvSEUNPGOkgg16477WkGNolzErWnz0KCdQSkGn/M04lEHBzkm3ucRxmSu+sMuXWyvQhiPEMOE4bOMJxO3mk7fq7M0xKE2x8w/hPvViPjifQVfimaUudGFrnotCRqZzI7N64OZgXFcTrB/fAjDIBgwYPTpGD1k9UrgF0JZABk2Ar9+lBxUU5VTS7US42sxppuocIkoWsx8d/ok9NllUxgOIn4JXWTxZFAR9macNskHCvz+lSiIdA4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(376002)(366004)(396003)(42606007)(39830400003)(346002)(136003)(40140700001)(44832011)(66946007)(316002)(966005)(508600001)(52116002)(2906002)(4744005)(6666004)(6512007)(6506007)(186003)(8676002)(9686003)(6486002)(8936002)(26005)(1076003)(33716001)(66476007)(6916009)(86362001)(38100700002)(38350700002)(66556008)(5660300002)(33656002)(54906003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ehqmqueqvdISxMmIhgMGO2oXLc8EbGMA+HzicRL+DB3TJFbTA146sEc2QAUY?=
 =?us-ascii?Q?p8DlCXhbNRQyFONuvIIx9C3UVCXV9QhosAbC4AWiDC8X8aP3UAPBrzJs9aWR?=
 =?us-ascii?Q?3y2mvOJIFGtT5h0tBBxjGy0wW17TwenU3r4c87CBJpmIyi6nsAh7/WnncPvM?=
 =?us-ascii?Q?eFjAFwqkbevVkuILmB/WdaR1PGGOmskkn+1sb7eF4PBn0E2QuE+VISHO+euR?=
 =?us-ascii?Q?TmUTjRu7nittzxXsh+EskniytW/5826haUhJMxyBbM0+U5i4d0YuFpcOtkfW?=
 =?us-ascii?Q?3ppuu7zZIgHcdrU2TNCLjXM2iJXFiDpuHDiD+gt/2+UGgjQj0Fs6hbfMiWeN?=
 =?us-ascii?Q?CDjgi8PpzSXLfsXUu/vfVvH7+Jj0jgaK1zvLW/t0tEm6izpR+ltgeK1LsAsS?=
 =?us-ascii?Q?5cYNNkfPnVNT4O1fkn1hLj4wMnGunVtY9TZg8CSxVUEscxGMqkz8oTinO9bc?=
 =?us-ascii?Q?QV4j/VSMJAMhpkkEewElwG3+RGZCwy3mVK9VVaPPFJUMTb2K1w9xFXnfWfD/?=
 =?us-ascii?Q?Th1M01ACnHEOXsxVSkbKyQnMCMu0VA77iPsiXw37IZwiuBzU0JGKD1jk9hP/?=
 =?us-ascii?Q?4ZtTdHYVf878UmH9TvKJUalk4zTDR3xwaMQ1kLlDpy1xMXwkxTR7dzZaIlqE?=
 =?us-ascii?Q?djsjy9rXUJ7ZalxUwP/8dYWkBXnFzAwsDjfmsMYEoyOtdHyr0NN0+aa3eFGO?=
 =?us-ascii?Q?RIPm8aHx0yQQUSbNQVe3C9ekBUaAx65JtUNmW8MDTsia+CaRJfkCLItF1aNL?=
 =?us-ascii?Q?Db+uxndqGn0uSkhtPvMGqcuDuKBrE5VM64/al5poMnEgsAoxYpq3sS2kFGCn?=
 =?us-ascii?Q?5Sr6ZNxalwi0uTpzAfHev/DjJCimT9jjzzQnE+ss4ePTJAEL493byylbg4Xs?=
 =?us-ascii?Q?8cOrdkOyBXR3sUjt6jVrxu/ruQd1mkLaMtOYARsdZN27dWhPSMUHAoHpwqdg?=
 =?us-ascii?Q?ygKv4ZHdMQp8Ct26v7tWujULgnWM5n7Rr/ReKYH03aFmjla7+cAwb67ss2ma?=
 =?us-ascii?Q?KSPj1+kOrYahy7r4mV8o2c0bcX2bTKwXDA745etxMwjIoKHVrnZrdDTd5+em?=
 =?us-ascii?Q?xdO1t248oHA3aIA0hoPVX/wesQVlgGlPcobVDz3Re01n1fh/Ed1qA8nO4+bB?=
 =?us-ascii?Q?qpF6Mk7f753M6NVEfTlGIvw5tYgVFRiZhJicGNi65gSFoj8Zye0bLATRsbfp?=
 =?us-ascii?Q?EjFS9VH3qH7GjjhqrNRTbdsnL8VN1oS5nNUqHROHvssPMqgF9XrgGBheKI8F?=
 =?us-ascii?Q?7Wx2buVb2yQ2hFbxAMsTJzYt/DxyKXV2HFVcuBUn1y+NTyPqcR+LJ2IL4ZZl?=
 =?us-ascii?Q?C/K1Poo6V98hwMlkdgFpTLGmc0tUbvDi7Mss9oENhikGRohfDIkCO+txA1zc?=
 =?us-ascii?Q?aLEPiYtxRfcUPwXLBxOcohVF7uGIa66vZx+d0jpJVbjRfNg9/OxH6F4CEjWS?=
 =?us-ascii?Q?R4dU47RGrfwRcVaGySGlRRqVMLzqGCRzHelQuZnQ7NG6aGiSghd4Nhgf6CQ8?=
 =?us-ascii?Q?phFliZVU6Wi8QAPcg5Ie2xz/dJ9V7mMc1qXL72RZ3gMBeuJb1NfbxI3J9Lz+?=
 =?us-ascii?Q?7lAtmTvEr7s8aMwduHZexf782SzQR/Kf01aym5CDDjxeVNE+PI7Xs/kbI61u?=
 =?us-ascii?Q?/XwKhssfBDebZF2Xrn4BVOn0GX48d0KgnjB9aMKLfCJHD8TlXe8WPmnQCJ1w?=
 =?us-ascii?Q?r2p05w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b936ffc6-7580-4e5e-95a4-08d9cc6f30b0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2021 15:06:58.2763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJF9VPEAgY4GMdxPr3aMhblqrmbLZKgQfXSvwEeA9vAHBMkosRT/5QFF5NYbbbsfFIgqT4xYSAlOz1s9t1+8O1y7TODHQaiqyfXnEAUs0lY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre

On Fri, Dec 31, 2021 at 11:27:16AM +0100, Alexandre Belloni wrote:
> Hi,
> 
> On 30/12/2021 15:07:40-0800, Colin Foster wrote:
> > Hi all,
> > 
> > An idea of how frequently this happens - my system has been currently up
> > for 3700 seconds. Eight "own address as source address" events have
> > happened at 66, 96, 156, 279, 509, 996, 1897, and 3699 seconds. 
> > 
> 
> This is something I solved back in 2017. I can exactly remember how, you
> can try:
> 
> sysctl -w net.ipv6.conf.swp3.autoconf=0

That sounds very promising! Sorry you had to fix my system config, but
glad that this all makes perfect sense. 

> 
> 
> -- 
> Alexandre Belloni, co-owner and COO, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
