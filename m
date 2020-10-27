Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90A229ABF7
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751251AbgJ0MVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:21:45 -0400
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:50779
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2440631AbgJ0MVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 08:21:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLlrvziaIyuU3SspzYokz812M6cAod9QDKRsYTjeVro9M9hRQj7GGw7BPR11x2cN1uLC6DJssjbXuhiQ0L+yR2tZfVSBxjuzoiOJmAjVIMmbFYkt1oiLTIFtFSnyJXFECom9XqjoiFGTi9kLxE/2UfRmSAEzA8h2sCIqTZGe7A5k5OFfikGzDcHKgn7WMqDC1Q5SDou1EsnyzT8X5UPY67SqzkCOfvxJT8qlj9SpuitPsqKc2iQ1Fhpeixn5s2dwl91IfEBmPiwe1foLrgcKuu9EOrnwE507Ep3ExZudvwlyEtcT0IvyGWVybbwAj+fTl9w2/h56WpZDufSwZlZ5Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0uywEG7ytgt5hsUFXKH12dLQ6cokqZFnsWdRhpAxSs=;
 b=flQrEhDqknXkt2sCJuTO1KNW94HMgu43a/2yhpYZzhqPEb67GWtAJTEglRNDTqyVPexm8r9lCnynn1V8CbpmOzRsmRZnuF768h9IuzCtSkgTcI0+r5y+LdA1hqsyIOMkb6coLwu7+D+WBu5d1vfverFBpkJqF1APxaneI4tOcLprgjPG3HyB7RhSCcrEQkKNgAqsIcSRUr+xIHZrgnY943oaPnwDsnK6RAa5WmBCvi9t5CwPj/YyVZF65JKhUM2sBFybGz2vluHsMLG5XhXhTXAsowXsUQm0pqtFQ1+O+pi3LpjMMehXSAfOlQTBN0/GiLHe39Pi1K+ZmuuKV7evuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0uywEG7ytgt5hsUFXKH12dLQ6cokqZFnsWdRhpAxSs=;
 b=1BNOWCazcq7ahc70MoqU1trdaxNis6GohUxx3jzCA98xFHWR7SURRJNv5VqHsjjiZ9JzcV0S3t2selQp5r1wwDDrs1J6Bhu6WZmCc0JId52tWvLW6gWqHiRlDgpAuG18kXXKdaD6B25uN/2ofrPdV5tLTaPZnrWGY1SegCZ3zOQ=
Authentication-Results: baylibre.com; dkim=none (message not signed)
 header.d=none;baylibre.com; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4536.namprd12.prod.outlook.com (2603:10b6:208:263::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 27 Oct
 2020 12:21:40 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::f8f7:7403:1c92:3a60]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::f8f7:7403:1c92:3a60%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 12:21:40 +0000
Subject: Re: [PATCH 8/8] dma-buf: use krealloc_array()
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20201027121725.24660-1-brgl@bgdev.pl>
 <20201027121725.24660-9-brgl@bgdev.pl>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <0b41d541-30a9-a020-f065-fb55dc766bc1@amd.com>
Date:   Tue, 27 Oct 2020 13:21:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201027121725.24660-9-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-ClientProxiedBy: AM0PR04CA0005.eurprd04.prod.outlook.com
 (2603:10a6:208:122::18) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM0PR04CA0005.eurprd04.prod.outlook.com (2603:10a6:208:122::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 27 Oct 2020 12:21:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a9ccb29-0bf0-4bbc-8097-08d87a72dbcb
X-MS-TrafficTypeDiagnostic: MN2PR12MB4536:
X-Microsoft-Antispam-PRVS: <MN2PR12MB453650BEAA05349A6A4E2BA283160@MN2PR12MB4536.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqEq0WXz7JKgB6Ql3KJBLH5AYrTjK5M2jtAgZS6kH16rbGMXsVzP+JfXQ7zg8W69imE0I//FAjeKtQnAD2TIhsEiBUwKveQd4GNpiZ8yylbm7Jo9XSV3isikrahqC98Wy9DyBPGDIKgL3GFq47D2+03ouhYdRXwuSlIhrYKdBT3WRcB0uo2g1m3Dsh/3vwIvxUHq9zYmJHagvGRHwmNyGgJshBakvkmsOxNy2PlAFU+1p7FmH+xcizm15aKfdSC9HAQZ8usGklEJFwFGrkeY0RSB8H1Wx7VB0dzabYQej+qYBNkaVsjHHHWi2SRxyczrreMc/2KPgliWfBJi/aLcnDtWVjvpduwqEr3fo5Yb24OTL1jrpkAW0b4VBzxvpnk2v0QlMFTGy+8CD7/dszJWow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(4744005)(7406005)(5660300002)(83380400001)(66556008)(16526019)(66946007)(52116002)(8936002)(316002)(186003)(66476007)(6486002)(31696002)(110136005)(2616005)(6666004)(7416002)(2906002)(4326008)(478600001)(86362001)(8676002)(36756003)(31686004)(921003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 97vJT1bWj4JuIqlB3lM08hOS0mbbkIwaaXA6HIMCZNnSevvdudkGUonMw0ndN+QpRlA3y/XWlf7zdiV3f60aiQYfbK7Tuu0gok7qk8Kl4TtW79Z7FeFIk1HsvnAP+Zmo2/deeOl+GNycCCX/ePKCNbThOaY8bQWv/LKUJ794ioHxdrFjF2EE40yqHrqZXlGhsc6t+I4WvCjqt7ly60LO6dFIDRDCYa7+2jDo7JtpulC9ytwm0TfqnuILkPJkGod2Si10tRDxSTD3YbcQorkCNTDRccQAGoCBCGKn0qt24xJIrZLswFNBb8rSvGBTu3oPpieaN9G4b9qp7jZ4E8OSOzTKaxKh0pEA7oHFxtv7HRHDJ8KScCMGjOdazN6IarDcf2jYchVCQYWactUH82DiKZJNQdy7tU3WVEMjf7W9y7hkWJIMOhzOlP/qeN9QpKC4UWJXzzH0z25BhlJCvYeCg55+ik2Wbe2MA0E8w6hkNtvdZKm59W6/JOCPWqC/uYvlUuTKFo4lewjVZfO9egZcJtNyWpX5Cnt8jcUiyeXOCo1Q5mVHaOazxJ+8hqYEABObaNNuMLo9QMuAYlP0Tg/YpLq7PNSaGJ9q9w6r9h+wfBvv7MOvej0d9laooqe/jvbEXyzdahKmpZVzcDACJCTJqp3RCr1ukyHHzTTj+/BYVJc4vZO0ue9kBNsIHg955Dio0EYLPZmb6JNURZI/lHBgJg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9ccb29-0bf0-4bbc-8097-08d87a72dbcb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2020 12:21:40.8550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEKxYQK0NHX7xk+/r0yZhJpur2OX1UekLRtALy6oFy5OGVfFhixUWxfCnPfM0nef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4536
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 27.10.20 um 13:17 schrieb Bartosz Golaszewski:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>
> Use the helper that checks for overflows internally instead of manually
> calculating the size of the new array.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Acked-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/dma-buf/sync_file.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
> index 5a5a1da01a00..2925ea03eef0 100644
> --- a/drivers/dma-buf/sync_file.c
> +++ b/drivers/dma-buf/sync_file.c
> @@ -270,8 +270,8 @@ static struct sync_file *sync_file_merge(const char *name, struct sync_file *a,
>   		fences[i++] = dma_fence_get(a_fences[0]);
>   
>   	if (num_fences > i) {
> -		nfences = krealloc(fences, i * sizeof(*fences),
> -				  GFP_KERNEL);
> +		nfences = krealloc_array(fences, i,
> +					 sizeof(*fences), GFP_KERNEL);
>   		if (!nfences)
>   			goto err;
>   

