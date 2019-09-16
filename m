Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E28DB362B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 10:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbfIPIIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 04:08:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:41816 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbfIPIIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 04:08:22 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9m3U-0007bw-I3; Mon, 16 Sep 2019 10:08:16 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9m3U-0006Yc-AD; Mon, 16 Sep 2019 10:08:16 +0200
Subject: Re: [PATCH] libbpf: Don't error out if getsockopt() fails for
 XDP_OPTIONS
To:     Yonghong Song <yhs@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>
References: <20190909174619.1735-1-toke@redhat.com>
 <8e909219-a225-b242-aaa5-bee1180aed48@fb.com> <87lfuxul2b.fsf@toke.dk>
 <60651b4b-c185-1e17-1664-88957537e3f1@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9271a44f-1bbf-1305-bff9-8cbb8bae9098@iogearbox.net>
Date:   Mon, 16 Sep 2019 10:08:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <60651b4b-c185-1e17-1664-88957537e3f1@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25573/Sun Sep 15 10:22:02 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/19 8:53 PM, Yonghong Song wrote:
> On 9/10/19 12:06 AM, Toke Høiland-Jørgensen wrote:
>> Yonghong Song <yhs@fb.com> writes:
>>> On 9/9/19 10:46 AM, Toke Høiland-Jørgensen wrote:
>>>> The xsk_socket__create() function fails and returns an error if it cannot
>>>> get the XDP_OPTIONS through getsockopt(). However, support for XDP_OPTIONS
>>>> was not added until kernel 5.3, so this means that creating XSK sockets
>>>> always fails on older kernels.
>>>>
>>>> Since the option is just used to set the zero-copy flag in the xsk struct,
>>>> there really is no need to error out if the getsockopt() call fails.
>>>>
>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>> ---
>>>>     tools/lib/bpf/xsk.c | 8 ++------
>>>>     1 file changed, 2 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>>>> index 680e63066cf3..598e487d9ce8 100644
>>>> --- a/tools/lib/bpf/xsk.c
>>>> +++ b/tools/lib/bpf/xsk.c
>>>> @@ -603,12 +603,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>>>>     
>>>>     	optlen = sizeof(opts);
>>>>     	err = getsockopt(xsk->fd, SOL_XDP, XDP_OPTIONS, &opts, &optlen);
>>>> -	if (err) {
>>>> -		err = -errno;
>>>> -		goto out_mmap_tx;
>>>> -	}
>>>> -
>>>> -	xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
>>>> +	if (!err)
>>>> +		xsk->zc = opts.flags & XDP_OPTIONS_ZEROCOPY;
>>>>     
>>>>     	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
>>>>     		err = xsk_setup_xdp_prog(xsk);
>>>
>>> Since 'zc' is not used by anybody, maybe all codes 'zc' related can be
>>> removed? It can be added back back once there is an interface to use
>>> 'zc'?
>>
>> Fine with me; up to the maintainers what they prefer, I guess? :)

Given this is not exposed to applications at this point and we don't do anything
useful with it, lets just remove the zc cruft until there is a proper interface
added to libbpf. Toke, please respin with the suggested removal, thanks!
