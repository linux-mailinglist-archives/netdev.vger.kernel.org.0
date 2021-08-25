Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD843F7BD6
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 19:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbhHYR5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 13:57:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:42586 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235032AbhHYR5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 13:57:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217614869"
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="217614869"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 10:56:24 -0700
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="527422217"
Received: from jambrizm-mobl1.amr.corp.intel.com ([10.212.224.56])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 10:56:23 -0700
Date:   Wed, 25 Aug 2021 10:56:14 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jiang Biao <benbjiang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel <linux-kernel@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Jiang Biao <tcs_robot@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] ipv4/mptcp: fix divide error
In-Reply-To: <CAPJCdBmTPW5gcO6DO5i=T+R2TNypzbaA666krk=7Duf2mt1yBw@mail.gmail.com>
Message-ID: <f9b97b7f-cb48-f0bf-2dfb-a13bf1296b19@linux.intel.com>
References: <20210824071926.68019-1-benbjiang@gmail.com> <fe512c8b-6f5a-0210-3f23-2c1fc75cd6e5@tessares.net> <CAPJCdBmTPW5gcO6DO5i=T+R2TNypzbaA666krk=7Duf2mt1yBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 24 Aug 2021, Jiang Biao wrote:

> Hi,
>
> On Tue, 24 Aug 2021 at 15:36, Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
>>
>> Hi Jiang,
>>
>> On 24/08/2021 09:19, Jiang Biao wrote:
>>
>> (...)
>>
>>> There is a fix divide error reported,
>>> divide error: 0000 [#1] PREEMPT SMP KASAN
>>> RIP: 0010:tcp_tso_autosize build/../net/ipv4/tcp_output.c:1975 [inline]
>>> RIP: 0010:tcp_tso_segs+0x14f/0x250 build/../net/ipv4/tcp_output.c:1992
>>
>> Thank you for this patch and validating MPTCP on your side!
>>
>> This issue is actively tracked on our Github project [1] and a patch is
>> already in our tree [2] but still under validation.
>>> It's introduced by non-initialized info->mss_now in __mptcp_push_pending.
>>> Fix it by adding protection in mptcp_push_release.
>>
>> Indeed, you are right, info->mss_now can be set to 0 in some cases but
>> that's not normal.
>>
>> Instead of adding a protection here, we preferred fixing the root cause,
>> see [2]. Do not hesitate to have a look at the other patch and comment
>> there if you don't agree with this version.
>> Except if [2] is difficult to backport, I think we don't need your extra
>> protection. WDYT?
>>
> Agreed, fixing the root cause is much better.
> Thanks for the reply.
>

Hi Jiang -

Could you try cherry-picking this commit to see if it eliminates the error 
in your system?

https://github.com/multipath-tcp/mptcp_net-next/commit/9ef5aea5a794f4a369e26ed816e9c80cdc5a5f86


Thanks!

--
Mat Martineau
Intel
