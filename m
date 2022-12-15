Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA49A64E465
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiLOXBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLOXAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:00:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288CF1F60A;
        Thu, 15 Dec 2022 15:00:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B357261F7F;
        Thu, 15 Dec 2022 23:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C83AC433F2;
        Thu, 15 Dec 2022 23:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671145249;
        bh=Djdm7yrApwJBy69Ip/DuJwgUSqX8oSrRhkL3U4rd2ro=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=adYZYLy89dOD94Qz3+rHILw/9uFzdizCtlHF2PQgUgorAlEjoqPHXKTqMLCw+i5b4
         VA5dBKwrdSw7sLDW4RWprT21j8uz5ekpC55gi/uPfXsK9ifSDDfy+APwr/qIbBqZFx
         D68arIofycDHddIo9Z1n099WKExUnVgvcff1N2WNraHtGUubSJJlWET09Pg1cwLvZ/
         OQanTt2UrTOlvQ/5PQm8Qq5s6veb7gS3ZMJZSh+6LZoUKsH4OFq2kRpENB8fOcSlZX
         are8hDOhrnf+sKKI/fD/IFeNsDrkIsq/rVGNQYvAASihI6jqMOyR3lN4zTdO6fCeBa
         NbbXsNF3o4npQ==
Message-ID: <c584ef7e-6897-01f3-5b80-12b53f7b4bf4@kernel.org>
Date:   Thu, 15 Dec 2022 16:00:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v2 1/1] net: neigh: persist proxy config across
 link flaps
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Decotigny <decot@google.com>
Cc:     David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
References: <20221214232059.760233-1-decot+git@google.com>
 <7211782676442c6679d8a016813fd62d44cbebad.camel@gmail.com>
 <CAG88wWZNaKqDXWrXanfSpM_h6LP7s3F5PppyWqwWRyA7g=+p_g@mail.gmail.com>
 <CAKgT0Uea8JztZfKsR_FUAjt5iXEyRhjySwysZSoeeobWv3Cizw@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAKgT0Uea8JztZfKsR_FUAjt5iXEyRhjySwysZSoeeobWv3Cizw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/22 1:08 PM, Alexander Duyck wrote:
> On Thu, Dec 15, 2022 at 9:29 AM David Decotigny <decot@google.com> wrote:
>>
>>
>> (comments inline below)
>>
>>
>> On Thu, Dec 15, 2022 at 8:24 AM Alexander H Duyck <alexander.duyck@gmail.com> wrote:
>>>
>>> On Wed, 2022-12-14 at 15:20 -0800, David Decotigny wrote:
>>>> From: David Decotigny <ddecotig@google.com>
>>>>
>>>> Without this patch, the 'ip neigh add proxy' config is lost when the
>>>> cable or peer disappear, ie. when the link goes down while staying
>>>> admin up. When the link comes back, the config is never recovered.
>>>>
>>>> This patch makes sure that such an nd proxy config survives a switch
>>>> or cable issue.
>>>>
>>>> Signed-off-by: David Decotigny <ddecotig@google.com>
>>>>
>>>>
>>>> ---
>>>> v1: initial revision
>>>> v2: same as v1, except rebased on top of latest net-next, and includes "net-next" in the description
>>>>
>>>>  net/core/neighbour.c | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>>>> index f00a79fc301b..f4b65bbbdc32 100644
>>>> --- a/net/core/neighbour.c
>>>> +++ b/net/core/neighbour.c
>>>> @@ -426,7 +426,10 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
>>>>  {
>>>>       write_lock_bh(&tbl->lock);
>>>>       neigh_flush_dev(tbl, dev, skip_perm);
>>>> -     pneigh_ifdown_and_unlock(tbl, dev);
>>>> +     if (skip_perm)
>>>> +             write_unlock_bh(&tbl->lock);
>>>> +     else
>>>> +             pneigh_ifdown_and_unlock(tbl, dev);
>>>>       pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
>>>>                          tbl->family);
>>>>       if (skb_queue_empty_lockless(&tbl->proxy_queue))
>>>
>>> This seems like an agressive approach since it applies to all entries
>>> in the table, not just the permenant ones like occurs in
>>> neigh_flush_dev.
>>>
>>> I don't have much experience in this area of the code but it seems like
>>> you would specifically be wanting to keep only the permanant entries.
>>> Would it make sense ot look at rearranging pneigh_ifdown_and_unlock so
>>> that the code functioned more like neigh_flush_dev where it only
>>> skipped the permanant entries when skip_perm was set?
>>>
>>
>> The reason I am proposing this patch like it is is because these "proxy" entries appear to be a configuration attribute (similar to ip routes, coming from the sysadmin config), and not cached data (like ip neigh "normal" entries essentially coming from the outside). So I view them as fundamentally different kinds of objects [1], which they actually are in the code. And they are also updated from a vastly different context (sysadmin vs traffic). IMHO, it would seem natural that these proxy attributes (considered config attributes) would survive link flaps, whereas normal ip neigh cached entries without NUD_PERMANENT should not. And neither should survive admin down, the same way ip route does not survive admin down. This is what this patch proposes.
>>
>> Honoring NUD_PERMANENT (I assume that's what you are alluding to) would also work, and (with current iproute2 implementation [2]) would lead to the same result. But please consider the above. If really honoring NUD_PERMANENT is the required approach here, I am happy to revisit this patch. Please let me know.
> 
> Yeah, I was referring to basically just limiting your changes to honor
> NUD_PERMANANT. Looking at pneigh_ifdown_and_unlock and comparing it to
> neigh_flush_dev it seems like it would make sense to just add the
> skip_perm argument there and then add the same logic at the start of
> the loop to eliminate the items you aren't going to flush/free. That
> way we aren't keeping around any more entries than those specifically
> that are supposed to be permanent.

exactly.
