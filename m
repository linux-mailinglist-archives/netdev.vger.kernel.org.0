Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2685A6D86C9
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbjDETZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDETZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:25:04 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6244C12;
        Wed,  5 Apr 2023 12:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=wMrpySGpngdxkYZFUvmKAfkjwxHnSqapRJ0yQFW05PI=; b=SR5z0ngxJZJsujL19KJfQh9GnC
        48uiadhsREvn/30irELw1zqI6nLCzAOjDKaQLTnzBxVTMZmE5uTkKkxpU3Ur9YHza/8NYUTp6FQQ+
        kMCXcA6fhsXeM2ZKPzDy/5M0+cDB7UGqgZBNWh7upiItRxkili5T8X25TAd6Ci3p258wzbTZ5rCZC
        e/MeZHiyGGVxOWVSHban5xgUKxzQZHtN6K11gy4R858E5V/KOZFUiz5rMAEg8pg4DvA5ntoMvqUOa
        0JrDmR/ROerzQX7IqmOS14hE7Qagrf8XyEhunINqqIX/8b2jF2+Z6TzcRdsKs4u2zxT381IufPZNN
        793EOsQQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pk8kW-000J2D-Eg; Wed, 05 Apr 2023 21:24:52 +0200
Received: from [81.6.34.132] (helo=localhost.localdomain)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pk8kV-0003L2-Vo; Wed, 05 Apr 2023 21:24:52 +0200
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge>
 <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
 <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
 <20230404185147.17bf217a@kernel.org>
 <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1e0a055f-072e-d151-e063-06e9628debb4@iogearbox.net>
Date:   Wed, 5 Apr 2023 21:24:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26866/Wed Apr  5 09:23:41 2023)
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/23 7:22 PM, Andrii Nakryiko wrote:
> On Tue, Apr 4, 2023 at 6:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> On Tue, 4 Apr 2023 17:16:27 -0700 Alexei Starovoitov wrote:
>>>> Added David's acks manually (we really need to teach pw-apply to do
>>>> this automatically...) and applied.
>>>
>>> +1
>>> I was hoping that patchwork will add this feature eventually,
>>> but it seems faster to hack the pw-apply script instead.
>>
>> pw-apply can kind of do it. It exports an env variable called ADD_TAGS
>> if it spots any tags in reply to the cover letter.
>>
>> You need to add a snippet like this to your .git/hooks/applypatch-msg:
>>
>>    while IFS= read -r tag; do
>>      echo -e Adding tag: '\e[35m'$tag'\e[0m'
>>        git interpret-trailers --in-place \
>>            --if-exists=addIfDifferent \
>>            --trailer "$tag" \
>>            "$1"
>>    done <<< "$ADD_TAGS"
>>
>> to transfer those tags onto the commits.
>>
>> Looking at the code you may also need to use -M to get ADD_TAGS
>> exported. I'm guessing I put this code under -M so that the extra curl
>> requests don't slow down the script for everyone. But we can probably
>> "graduate" that into the main body if you find it useful and hate -M :)
> 
> So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
> everything locally. I'd expect that at this time the script would
> detect any Acked-by replies on *cover letter patch*, and apply them
> across all patches in the series. Such that we (humans) can look at
> them, fix them, add them, etc. Doing something like this in git hook
> seems unnecessary?
> 
> So I think the only thing that's missing is the code that would fetch
> all replies on the cover letter "patch" (e.g., like on [0]) and just
> apply it across everything. We must be doing something like this for
> acks on individual patches, so I imagine we are not far off to make
> this work, but I haven't looked at pw-apply carefully enough to know
> for sure.

I always use pw-apply based on the mbox, e.g. ...

   pw-apply -b https://patchwork.kernel.org/[...]/mbox/ -m <branch-name> -- -a "Foo Bar <foo@bar.com>"

... still manual, but it will propagate the -a (Acked-by) / -r (Reviewed-by) /
-t (Tested-by) to the individual patches.

Thanks,
Daniel
