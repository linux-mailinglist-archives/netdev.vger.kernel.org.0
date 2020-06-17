Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591881FCE30
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFQNPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:15:31 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:36000
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgFQNPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 09:15:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUThR4636UTu99d47DBYLyjnimD7v5DnjZNUU9d+cxUFfqUroekdTWFF5fV09hM6wZtIP1AGeJqwrFv8rPa05L+eWo1Nj16QlMokzUbvlwBTzkHMX/S7dzM3IQaPUzAzQ+UvDwxBj3P1+3YqVqlOCgom5LQcFm6pMrQZrrHpTCCDnYMlpDCODKNRGGIRkO31mMtRIylvfM20UtzhORMVwWgbUFEhXOberIS0exBbz3pP1vK8XGckDmMv1Ao+8WPITV9Z2tZh1bg0FEsLtNYf70P04dTP+guG1jJuNPw5HYD878jwiDpiWUpBnSsE4DPdmuVjV9DmSE+wwdfvFiByvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWy0PHsLV16B4eZrRbitsLu5sqOlm1TlGvPuoF9oX1Y=;
 b=cmkkQE+2YcJABsPu0lxUOxtvxWTsQQfzYGSVpihFmZ2dh+pht5HNvyl68PVc3g40KT66zJC7D3wxAj5Rl9dOGxHhw0JpPDbwR98Oa42gqpWFch9nDulKw0x3LxX0oM6US5iXYJvdjb97i8OtdiwyIUnjM7Syw+qZdbpigiG6aEZSKl0bPL3EVxl+GGtZciEiKdthB7MSJdfs9/KRP7AD0QMopm9aE8FjkgVJGMvx4ax43BZVdhx0Jc0hGFly5b48P6YLNDbl03QgmB0AN/WZiOUiVIcvU+ZqUn3efSI1OgvpuoQdj3VtUrgOV7G4Sik2/cKhb8pFfdHsACHwId3cEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWy0PHsLV16B4eZrRbitsLu5sqOlm1TlGvPuoF9oX1Y=;
 b=tdWDKC7vpIFre8hlKFFks3FbHZf5TCRzdnK/1Hdp62XjyEa00zVq/Lg5rgxfMFARjQL/x+qJ1PrsBhZnDvZUR6PFsfzM/6ICIRuETSBpDhgHBRgrJR712JgIiiysofpDCk9uxO2ZGsF3Zg9eaEo7HhJaVpWqrxqSAKqhfkfAhWA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5799.eurprd05.prod.outlook.com (2603:10a6:20b:93::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 17 Jun
 2020 13:15:26 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3088.029; Wed, 17 Jun 2020
 13:15:26 +0000
To:     Amritha Nambiar <amritha.nambiar@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>, netdev@vger.kernel.org
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: ADQ - comparison to aRFS, clarifications on NAPI ID, binding with
 busy-polling
Message-ID: <e13faf29-5db3-91a2-4a95-c2cd8c2d15fe@mellanox.com>
Date:   Wed, 17 Jun 2020 16:15:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR07CA0023.eurprd07.prod.outlook.com
 (2603:10a6:205:1::36) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by AM4PR07CA0023.eurprd07.prod.outlook.com (2603:10a6:205:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.10 via Frontend Transport; Wed, 17 Jun 2020 13:15:26 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 870f06db-e747-4c6b-2829-08d812c08045
X-MS-TrafficTypeDiagnostic: AM6PR05MB5799:
X-Microsoft-Antispam-PRVS: <AM6PR05MB57998D122A5F5972D5167CA9D19A0@AM6PR05MB5799.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aTWIqg/hgTj4Sv5ZiI7WVvv4NB3Pz4R0NOlSB5nZrxDKVRuRtfSCFIub61jld1LJGnvrimzKqPigZp4MREqLFPfA6c/h1dpV6t5D4H42RsvHywSq0gC+6quP9T4/FOXk6XIgWfW0MHLRRmcusTXGSEbFa2XTBiToyxTbnNf5uG/GGyxFbnbR61uWeXVnsh0ZQJCVAcdwQXsVT5ERQzSy10PPyZGYPVdfp5thMhZOg8/iMUBFikiI9ImWXt3COjys4dfkwUWfQU+BLiKTMrigE1wbFv3D9ROmUmn3uyDEkfepRepyybkOPJ3fnAkR50nKRj+NVPmiFgNQTGitH0nnX1ewMtUjbn77nmzimgPH64DwwAjU1W/w8fdgzd7//CGjLUwRZZRWw2yPU9ul3hHpaC+q7bWCGgH/tTgqCNWHbfsvwDO++AvcqdCDJp8yx8vf7/TithsAlEB/SK/jnQJoBwjdhGEwKujzGe+L4XjAyaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(6486002)(956004)(2616005)(36756003)(83380400001)(55236004)(478600001)(8676002)(8936002)(31686004)(86362001)(31696002)(16526019)(6666004)(26005)(966005)(2906002)(110136005)(4326008)(5660300002)(16576012)(66946007)(66556008)(52116002)(186003)(316002)(66476007)(54906003)(43740500002)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bblfWrTAEZ/TE1gLrVutCWIDQzCUZbSKU/96FO8NQPoGeSUU4Z2vSOqdYabSWy6gu2xZlM0Yavykou2Ey9a/F96uHRim8SdxMrmtLSffrQ8ptSvd6Y6fYMsYdbCXVB3AXxMV0NykfnFW1lMewlcLBQ4UouRcQqhGEk6VZiyzkCZtIGiDiM2989ey1G7dN5S4b/80RKSNCKiDFmstB6gW2DzmzAH60etEcJUv1gzGS/qgy5Xmx6GLOYjXlhgPWFTwWPkQGNdtET/K++oslwwzBK8etcIqTfSDEKb7mDdEzr8wa3RUB1fmQB/ion9Rg+yWZp7/LaE5UY+MQ24B2yxPgsixeN0FvF4kLVmVr1KTxVzG/Gc0EexiyNGEqYS2WGLtnCAqIJFsxtkNX/jW93z72wGseeHDIsbp7twb6dsrELFbFhLKCw5yLSRQzFTagrY5pWIo6iYtDhyvaWzvsxKnGKesKXwYzKyF3fPv+qC6AQ8dVNuDq2LSTGIqFBGHnhmr
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870f06db-e747-4c6b-2829-08d812c08045
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 13:15:26.8811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KS1l5L5sAcCMzue1Dxe7Vk1lzZY5+0M9V7/qlSNbHq7x4yqPPJt/AYcD3Mk8jOtSWUsInx+AJEqg4vZZTT3AMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5799
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I discovered Intel ADQ feature [1] that allows to boost performance by 
picking dedicated queues for application traffic. We did some research, 
and I got some level of understanding how it works, but I have some 
questions, and I hope you could answer them.

1. SO_INCOMING_NAPI_ID usage. In my understanding, every connection has 
a key (sk_napi_id) that is unique to the NAPI where this connection is 
handled, and the application uses that key to choose a handler thread 
from the thread pool. If we have a one-to-one relationship between 
application threads and NAPI IDs of connections, each application thread 
will handle only traffic from a single NAPI. Is my understanding correct?

1.1. I wonder how the application thread gets scheduled on the same core 
that NAPI runs at. It currently only works with busy_poll, so when the 
application initiates busy polling (calls epoll), does the Linux 
scheduler move the thread to the right CPU? Do we have to have a strict 
one-to-one relationship between threads and NAPIs, or can one thread 
handle multiple NAPIs? When the data arrives, does the scheduler run the 
application thread on the same CPU that NAPI ran on?

1.2. I see that SO_INCOMING_NAPI_ID is tightly coupled with busy_poll. 
It is enabled only if CONFIG_NET_RX_BUSY_POLL is set. Is there a real 
reason why it can't be used without busy_poll? In other words, if we 
modify the kernel to drop this requirement, will the kernel still 
schedule the application thread on the same CPU as NAPI when busy_poll 
is not used?

2. Can you compare ADQ to aRFS+XPS? aRFS provides a way to steer traffic 
to the application's CPU in an automatic fashion, and xps_rxqs can be 
used to transmit from the corresponding queues. This setup doesn't need 
manual configuration of TCs and is not limited to 4 applications. The 
difference of ADQ is that (in my understanding) it moves the application 
to the RX CPU, while aRFS steers the traffic to the RX queue handled my 
the application's CPU. Is there any advantage of ADQ over aRFS, that I 
failed to find?

3. At [1], you mention that ADQ can be used to create separate RSS sets. 
  Could you elaborate about the API used? Does the tc mqprio 
configuration also affect RSS? Can it be turned on/off?

4. How is tc flower used in context of ADQ? Does the user need to 
reflect the configuration in both mqprio qdisc (for TX) and tc flower 
(for RX)? It looks like tc flower maps incoming traffic to TCs, but what 
is the mechanism of mapping TCs to RX queues?

I really hope you will be able to shed more light on this feature to 
increase my awareness on how to use it and to compare it with aRFS.

Thanks,
Max

[1]: 
https://netdevconf.info/0x14/session.html?talk-ADQ-for-system-level-network-io-performance-improvements
