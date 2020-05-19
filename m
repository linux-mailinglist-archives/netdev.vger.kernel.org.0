Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DE61D97CB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgESNbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:31:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:46496 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgESNbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:31:37 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jb2L3-0007aJ-QV; Tue, 19 May 2020 15:31:21 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jb2L3-0002Pz-AN; Tue, 19 May 2020 15:31:21 +0200
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
 <87h7wdnmwi.fsf@toke.dk> <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
 <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
Date:   Tue, 19 May 2020 15:31:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25817/Tue May 19 14:16:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 2:02 AM, David Ahern wrote:
> On 5/18/20 3:06 PM, Daniel Borkmann wrote:
>> So given we neither call this hook on the skb path, nor XDP_TX nor
>> AF_XDP's TX
>> path, I was wondering also wrt the discussion with John if it makes
>> sense to
>> make this hook a property of the devmap _itself_, for example, to have a
>> default
>> BPF prog upon devmap creation or a dev-specific override that is passed
>> on map
>> update along with the dev. At least this would make it very clear where
>> this is
>> logically tied to and triggered from, and if needed (?) would provide
>> potentially
>> more flexibility on specifiying BPF progs to be called while also
>> solving your
>> use-case.
> 
> You lost me on the 'property of the devmap.' The programs need to be per
> netdevice, and devmap is an array of devices. Can you elaborate?

I meant that the dev{map,hash} would get extended in a way where the
__dev_map_update_elem() receives an (ifindex, BPF prog fd) tuple from
user space and holds the program's ref as long as it is in the map slot.
Then, upon redirect to the given device in the devmap, we'd execute the
prog as well in order to also allow for XDP_DROP policy in there. Upon
map update when we drop the dev from the map slot, we also release the
reference to the associated BPF prog. What I mean to say wrt 'property
of the devmap' is that this program is _only_ used in combination with
redirection to devmap, so given we are not solving all the other egress
cases for reasons mentioned, it would make sense to tie it logically to
the devmap which would also make it clear from a user perspective _when_
the prog is expected to run.

Thanks,
Daniel
