Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBBA2D7935
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437916AbgLKP1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:27:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13216 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437886AbgLKP0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:26:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd38f830003>; Fri, 11 Dec 2020 07:25:55 -0800
Received: from [172.27.0.216] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Dec
 2020 15:25:37 +0000
Subject: Re: [PATCH net-next 3/4] sch_htb: Stats for offloaded HTB
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <kbuild@lists.01.org>, Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, <lkp@intel.com>,
        <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20201210082851.GL2767@kadam>
 <7d1a6afe-d084-bdbd-168a-3bcb88910e2d@nvidia.com>
 <20201211084141.GQ2789@kadam>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <d202fb5e-69a8-c7e3-7fd3-cb973845fc63@nvidia.com>
Date:   Fri, 11 Dec 2020 17:25:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201211084141.GQ2789@kadam>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607700355; bh=6qMV+gioyT0eN5j3j8msr23Btm1kBW5mCqXujmjVDGs=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=sRa7Xq2vXe3D2HxjD3HVyFAgRPwUgu6IBNo7NhRIi9X3JIYANsaMLrfAHEaMhKdGT
         JSTS1hnFRlXIcem5is+QaO4HAM/GOLj7+E7aVtwF8EeNt6WU/AWbk/VMHAYxY7B0Dm
         DuQKnKjEpMqlhogbbnIS3WVtnv4O2jfuJ+9FwyqZujCH+y3ptN+3hXEGijOxanHthI
         DtOtgFsMmPZNuGSixFaIPInSTGXhWOGltetrBm+rUvz85SuvitHx6Q1dcjwoVabylQ
         +8Oj8N06T1R1nL6SO3FBR/njHiDgAOVqoaVK4lv9LZVIO9Qk96w36P3q7wwY6Qzta8
         ymrzrdm+KlybQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-11 10:41, Dan Carpenter wrote:
> On Thu, Dec 10, 2020 at 05:07:28PM +0200, Maxim Mikityanskiy wrote:
>> On 2020-12-10 10:28, Dan Carpenter wrote:
>>> Hi Maxim,
>>>
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Maxim-Mikityanskiy/HTB-offload/20201210-000703
>>> base:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>>> afae3cc2da100ead3cd6ef4bb1fb8bc9d4b817c5
>>> config: i386-randconfig-m021-20201209 (attached as .config)
>>> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
>>>
>>> If you fix the issue, kindly add following tag as appropriate
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> smatch warnings:
>>> net/sched/sch_htb.c:1310 htb_dump_class_stats() error: we previously assumed 'cl->leaf.q' could be null (see line 1300)
>>>
>>> vim +1310 net/sched/sch_htb.c
>>>
>>> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1289  static int
>>> 87990467d387f92 Stephen Hemminger     2006-08-10  1290  htb_dump_class_stats(struct Qdisc *sch, unsigned long arg, struct gnet_dump *d)
>>> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1291  {
>>> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1292  	struct htb_class *cl = (struct htb_class *)arg;
>>> 1e0ac0107df684e Maxim Mikityanskiy    2020-12-09  1293  	struct htb_sched *q = qdisc_priv(sch);
>>> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1294  	struct gnet_stats_queue qs = {
>>> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1295  		.drops = cl->drops,
>>> 3c75f6ee139d464 Eric Dumazet          2017-09-18  1296  		.overlimits = cl->overlimits,
>>> 338ed9b4de57c4b Eric Dumazet          2016-06-21  1297  	};
>>> 6401585366326fc John Fastabend        2014-09-28  1298  	__u32 qlen = 0;
>>> ^1da177e4c3f415 Linus Torvalds        2005-04-16  1299
>>> 5dd431b6b92c0db Paolo Abeni           2019-03-28 @1300  	if (!cl->level && cl->leaf.q)
>>>                                                                                     ^^^^^^^^^^
>>> Check for NULL
>>
>> Well, I don't think this is real... I don't see any possibility how
>> cl->leaf.q can be NULL for a leaf class. However, I'll add a similar check
>> below anyway.
>>
> 
> Another option is to remove this check if it's really impossible.

Yes, thanks, I see this option, but between these two options I'd pick 
the one that for sure doesn't make any change to the non-offloaded HTB 
logic. Even though to the best of my knowledge this check isn't needed, 
I might miss something, because I tried tracking down the origin of this 
code, and it was already there in the initial commit of 2005.

Respinning now with the CI issues fixed.

> regards,
> dan carpenter
> 

