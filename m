Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0196294379
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 21:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438340AbgJTTra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 15:47:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:36910 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438331AbgJTTr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 15:47:29 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUxbR-0007Yg-3b; Tue, 20 Oct 2020 21:47:25 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUxbQ-000JZV-U5; Tue, 20 Oct 2020 21:47:24 +0200
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
 <20201020093003.6e1c7fdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9f422jx.fsf@toke.dk>
 <20201020120128.338595e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <19519442-7c40-5115-de04-e0616931fa4b@iogearbox.net>
Date:   Tue, 20 Oct 2020 21:47:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201020120128.338595e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25963/Tue Oct 20 16:00:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 9:01 PM, Jakub Kicinski wrote:
> On Tue, 20 Oct 2020 20:08:18 +0200 Toke Høiland-Jørgensen wrote:
>>> Isn't this backward? The hole could be named in the internal structure.
>>> This is a bit of a gray area, but if you name this hole in uAPI and
>>> programs start referring to it you will never be able to reuse it.
>>> So you may as well not require it to be zeroed..
>>
>> Hmm, yeah, suppose you're right. Doesn't the verifier prevent any part
>> of the memory from being unitialised anyway? I seem to recall having run
>> into verifier complaints when I didn't initialise struct on the stack...
> 
> Good point, in which case we have a convenient way to zero the hole
> after nh_family but no convenient way to zero the empty address space
> for IPv4 :) (even though that one only needs to be zeroed for the
> verifier)

Technically, it's uninitialized, so zero or any other garbage from BPF stack's
previous use of the program. We could use couple of __u8 :8 after nh_family to
have an unnamed placeholder (like in __bpf_md_ptr()), or we might as well just
switch to __u32 nh_family and avoid the hole that way (also gets rid of the extra
check) ... given we have the liberty to extend later anyway if ever needed.
