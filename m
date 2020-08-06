Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679D023D86D
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 11:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbgHFJTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 05:19:12 -0400
Received: from mail-eopbgr80134.outbound.protection.outlook.com ([40.107.8.134]:4185
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728946AbgHFJRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 05:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6LBG9RaWuxX1ccgW8HoKy1aL3ss1rNNlTZhCsF3SratKn0LqdfnEcn9XhVBb5zutz5/od5+wecd8tSBC379EExASe0Y9Vgac7mUWvqeDn7qt+jQhJix6xK77fMZgbqgz2NSh1ok65KM8LyFpRoatIySme4nE9vjNMfT85lFQzfO3thGzHBt+/ltsP7cOkyNdopPBMKC/9s4hq645YYlLDmdCbgpL3BuB48ZBzYF4ZZK+eYudcbCouXrm08HAFZ22S9Usp+YYA8APEBAaws1fxdQoTY6tX2e8nxtAzjmRFAFF+STn/Y8KrHMz0JGvdoT1S1jhKtSBHbHwcCyAttIxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgkrkfQL6xfsTQn5kGUhISgYeSVePyhYSCkQmjaDenE=;
 b=WrfR6K3tQLLMJNnba64zQb1ZWT//f0M9psPGRgauHC+LWYplNFohAhTZj0f0Cy7o8GcAwA68o8o6Xbf0hNj7h91Cu70dmdSxcjddaEU47qhslKal9SmeXEXEaLXwyKVEK0nzwusql61cKiKduUnv/tQP3Veqh96Os/YGLYn0KyoeS2hGxQGcurhdClzAYFQy9XboYHj2pNntu8WTKZXVHUCFxpai+jCfoLhsnV2WH1DOnhaEmNsuva0+4fyT76c8lt7DjDJ+g+++4OvsVvpWK+nYX/NF83ybghubC8yl132JMWnIq+KLcn7kNUakIuYn2+UkmaSESAW9zhH6NTRokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgkrkfQL6xfsTQn5kGUhISgYeSVePyhYSCkQmjaDenE=;
 b=UKNr0iW+YQG9LZfyK0T2pq5A9TrL2a2Tj852tiPAVQYUdplXEA6RUMRLuklmPIBLKBGz5p2vZi7JpraaeMrFfTWx4pglbrNPnZwGlwbxEgMbkmzOaz+UvZ6FGwP2k5N4XIZpZ/vDEACGaayBzUZmXds+BzKkq5q1HwBYWw+q8a4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3731.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Thu, 6 Aug
 2020 09:17:32 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec%3]) with mapi id 15.20.3261.018; Thu, 6 Aug 2020
 09:17:32 +0000
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Network Development <netdev@vger.kernel.org>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
 <20200805163425.6c13ef11@hermes.lan>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
Date:   Thu, 6 Aug 2020 11:17:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200805163425.6c13ef11@hermes.lan>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0030.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::43) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by AM0PR07CA0030.eurprd07.prod.outlook.com (2603:10a6:208:ac::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.13 via Frontend Transport; Thu, 6 Aug 2020 09:17:31 +0000
X-Originating-IP: [81.216.59.226]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e80ea4d5-8001-4043-4766-08d839e98c81
X-MS-TrafficTypeDiagnostic: AM0PR10MB3731:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3731C628A13BEEEF245CE2CD93480@AM0PR10MB3731.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jBYidRqHht84wa+pnurFuAohkMhC2DdgG6HXAdRguqiMfXN3SAuTfIzRsSQU3ntMGb1uJCnikrHJI68Tn/kz5Y4gWKN9yjDxPtuhu0rOdmimdG72j0urasWQNrZoeDzxvZQXq3WJVO2lrl3ll4mtM9u5gkfl2db++syBePvTeXBDVyLFm5yQ3wLB2uCkTtb0bSdZ50C3sNCgxduOUT+md7aFxjHQQwEsqnubCKGjrZ4CxPypD0fCO/byh3Qt/YFpPeXENnqc5owe36Kgl1d96cTNUfsRz8Tm6eTUNVJGq3Nx2yUZXfibcmGwVUojCQj3tDBGRVJhCsU+LA/rdbdfOmjpop6kqV2PcXq2mNGE6RuJ2JWPEdNXpXa66gY6Hl9B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(366004)(39840400004)(346002)(396003)(52116002)(31686004)(86362001)(6916009)(66556008)(8936002)(66476007)(4326008)(8976002)(66946007)(31696002)(16576012)(316002)(508600001)(8676002)(83380400001)(44832011)(5660300002)(2616005)(956004)(36756003)(2906002)(26005)(186003)(16526019)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: prr1dmv+tT/+iZlIxGD4Aixr/rupaNhbKsThEfpoWmzNw+xTFrlCCskc+A0QJQYCUs9z6k8q6k0VS8pLnANLZMuMhFZJUxvQ9LHypUW6qFkDVkgSHatmDywRkk0gUv0rdi3LR/qaDPWm9tP3Whd8DCa6GQZEYuxA4ImwPWJsiAZpcV+XhPNusiU6191K5Yic6fdAwf/jrrRMHf1cmDOLTTjHnaYnhgXR4cj6jSLoeQNMUM+ku+0/Wpf9TbBkfKMimi3go5WemMv0VgNQCB9nr4f6O4w8e39ZphzJjmaOTjjurCQ2PKLaolx3WA+J6RUE2UN6mVdX//aSaOqSz2fciJQcQhYcBOjnZW8mEfwJfLWGLyDU4Ev3+2rjAyxbPafMH0Hb+askM+tSOilRShThsayNHmtNM5iwGtbzIg6Zkq2Q2mFywyZldlo3bfHVWknY+ZciBGCT9hhmD8E1A+kJE7SYOE2DSednZwN5I8dru17bct7x9+9y5G7GPPzYnO0yVNkrbd+gOFvyP7tN3y1J/f47UBui0NXnZ2Dg/FyQyzU53+cDMWMHJLj/ikwjdAATqNjbtUABOvJzIqKHbhpiLyxQ3zMQtKgnnI21KVD0l2iKNCBEKw6aRYVJqL1ERKTWdVRQxXVAxbfMgLkY4kd2Lg==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: e80ea4d5-8001-4043-4766-08d839e98c81
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2020 09:17:32.2429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: exVQBy8NDdAUOv2wMhxodRjsV+qvWfyl+Z9QlFjV3zn1QPP6Gv7e5uNCtuBiKf2LcyGCqhyB6YEv0tcyu5f2yeh9ZdD0AnKgtrJuTkgPC/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08/2020 01.34, Stephen Hemminger wrote:
> On Wed, 5 Aug 2020 16:25:23 +0200
> Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> 
>> Hi,
>>
>> We're seeing occasional lockups on an embedded board (running an -rt
>> kernel), which I believe I've tracked down to the
>>
>>             if (!rtnl_trylock())
>>                     return restart_syscall();
>>
>> in net/bridge/br_sysfs_br.c. The problem is that some SCHED_FIFO task
>> writes a "1" to the /sys/class/net/foo/bridge/flush file, while some
>> lower-priority SCHED_FIFO task happens to hold rtnl_lock(). When that
>> happens, the higher-priority task is stuck in an eternal ERESTARTNOINTR
>> loop, and the lower-priority task never gets runtime and thus cannot
>> release the lock.
>>
>> I've written a script that rather quickly reproduces this both on our
>> target and my desktop machine (pinning everything on one CPU to emulate
>> the uni-processor board), see below. Also, with this hacky patch
> 
> There is a reason for the trylock, it works around a priority inversion.

Can you elaborate? It seems to me that it _causes_ a priority inversion
since priority inheritance doesn't have a chance to kick in.

> The real problem is expecting a SCHED_FIFO task to be safe with this
> kind of network operation.

Maybe. But ignoring the SCHED_FIFO/rt-prio stuff, it also seems a bit
odd to do what is essentially a busy-loop - yes, the restart_syscall()
allows signals to be delivered (including allowing the process to get
killed), but in the absence of any signals, the pattern essentially
boils down to

  while (!rtnl_trylock())
    ;

So even for regular tasks, this seems to needlessly hog the cpu.

I tried this

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 0318a69888d4..e40e264f9b16 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -44,8 +44,8 @@ static ssize_t store_bridge_parm(struct device *d,
        if (endp == buf)
                return -EINVAL;

-       if (!rtnl_trylock())
-               return restart_syscall();
+       if (rtnl_lock_interruptible())
+               return -ERESTARTNOINTR;

        err = (*set)(br, val);
        if (!err)

with the obvious definition of rtnl_lock_interruptible(), and it makes
the problem go away. Isn't it better to sleep waiting for the lock (and
with -rt, giving proper priority boost) or a signal to arrive rather
than busy-looping back and forth between syscall entry point and the
trylock()?

I see quite a lot of

    if (mutex_lock_interruptible(...))
            return -ERESTARTSYS;

but for the rtnl_mutex, I see the trylock...restart_syscall pattern
being used in a couple of places. So there must be something special
about the rtnl_mutex?

Thanks,
Rasmus
