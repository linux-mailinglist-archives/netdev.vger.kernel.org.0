Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F31D89C4
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 23:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgERVGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 17:06:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:46322 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERVGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 17:06:52 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jamy4-0007Qs-LP; Mon, 18 May 2020 23:06:37 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jamy4-000VMY-6O; Mon, 18 May 2020 23:06:36 +0200
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
 <87h7wdnmwi.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
Date:   Mon, 18 May 2020 23:06:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87h7wdnmwi.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25816/Mon May 18 14:17:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 8:00 PM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
>> On 5/18/20 3:08 AM, Toke Høiland-Jørgensen wrote:
[...]
>> Less powerful how? There are only so many operations you can do to a
>> packet. What do you want to do and what can't be done with this proposed
>> change? Why must it be done as XDP vs proper synergy between the 2 paths.
> 
> I meant 'less powerful' in the obvious sense: it only sees a subset of
> the packets going out of the interface. And so I worry that it will (a)
> make an already hard to use set of APIs even more confusing, and (b)
> turn out to not be enough so we'll end up needing a "real" egress hook.
> 
> As I said in my previous email, a post-REDIRECT hook may or may not be
> useful in its own right. I'm kinda on the fence about that, but am
> actually leaning towards it being useful; however, I am concerned that
> it'll end up being redundant if we do get a full egress hook.

I tend to agree with this. From a user point of view, say, one that has used
the ingress XDP path before, the expectation would very likely be that an XDP
"egress hook" would see all the traffic similarly as on the ingress side, but
since the skb path has been dropped in this revision - I agree with you, David,
that it makes sense to do so - calling it XDP "egress" then feels a bit misleading
wrt expectations. I'd assume we'd see a lot of confused users on this very list
asking why their BPF program doesn't trigger.

So given we neither call this hook on the skb path, nor XDP_TX nor AF_XDP's TX
path, I was wondering also wrt the discussion with John if it makes sense to
make this hook a property of the devmap _itself_, for example, to have a default
BPF prog upon devmap creation or a dev-specific override that is passed on map
update along with the dev. At least this would make it very clear where this is
logically tied to and triggered from, and if needed (?) would provide potentially
more flexibility on specifiying BPF progs to be called while also solving your
use-case.

Thanks,
Daniel
