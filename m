Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1635B3A7E22
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhFOM0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:26:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:52418 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhFOM0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 08:26:02 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lt86n-000FiE-1A; Tue, 15 Jun 2021 14:23:57 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lt86m-0008RZ-S7; Tue, 15 Jun 2021 14:23:56 +0200
Subject: Re: [PATCH bpf-next 3/3] libbpf: add request buffer type for netlink
 messages
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <20210612023502.1283837-1-memxor@gmail.com>
 <20210612023502.1283837-4-memxor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <75ee8cc8-e793-ca15-0c8f-0de99af451d8@iogearbox.net>
Date:   Tue, 15 Jun 2021 14:23:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210612023502.1283837-4-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Kumar,

took in first two already, just few small nits in here, but overall looks
good to me.

On 6/12/21 4:35 AM, Kumar Kartikeya Dwivedi wrote:
> Coverity complains about OOB writes to nlmsghdr. There is no OOB as we
> write to the trailing buffer, but static analyzers and compilers may
> rightfully be confused as the nlmsghdr pointer has subobject provenance
> (and hence subobject bounds).
> 
> Remedy this by using an explicit request structure, but we also need to
> start the buffer in case of ifinfomsg without any padding. The alignment
> on netlink wire protocol is 4 byte boundary, so we just insert explicit
> 4 byte buffer to avoid compilers throwing off on read and write from/to
> padding.
> 
> Also switch nh_tail (renamed to req_tail) to cast req * to char * so
> that it can be understood as arithmetic on pointer to the representation
> array (hence having same bound as request structure), which should
> further appease analyzers.
> 
> As a bonus, callers don't have to pass sizeof(req) all the time now, as
> size is implicitly obtained using the pointer. While at it, also reduce
> the size of attribute buffer to 128 bytes (132 for ifinfomsg using
> functions due to the need to align buffer after it).
> 
> More info/discussion on why this was a problem in these links:
> http://www.open-std.org/jtc1/sc22/wg14/www/docs/n2294.htm#provenance-and-subobjects-container-of-casts-1
> https://twitter.com/rep_stosq_void/status/1298581367442333696

Would be good if you could provide a small summary instead of external
links to twitter, so that this is ideally self-contained and doesn't
get lost from the log.

> CID: 322807
> CID: 322806
> CID: 141815

CIDs are not official commit msg tags, and given this is just a coverity
false positive on top of that, I don't think we need them here.

> Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/lib/bpf/netlink.c | 107 +++++++++++++++-------------------------
>   tools/lib/bpf/nlattr.h  |  37 +++++++++-----
>   2 files changed, 65 insertions(+), 79 deletions(-)
> 
[...]
> diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
> index 3c780ab6d022..cc59f9c02d88 100644
> --- a/tools/lib/bpf/nlattr.h
> +++ b/tools/lib/bpf/nlattr.h
> @@ -13,6 +13,7 @@
>   #include <string.h>
>   #include <errno.h>
>   #include <linux/netlink.h>
> +#include <linux/rtnetlink.h>
>   
>   /* avoid multiple definition of netlink features */
>   #define __LINUX_NETLINK_H
> @@ -52,6 +53,18 @@ struct libbpf_nla_policy {
>   	uint16_t	maxlen;
>   };
>   
> +struct netlink_request {

nit: Could we either name it struct libbpf_nla_req or just struct nlreq ...
to better fit the naming conventions of nlattr.h and not create yet a new
variant? Either is okay with me..

> +	struct nlmsghdr nh;
> +	union {
> +		struct {
> +			struct ifinfomsg ifinfo;
> +			char _pad[4];
> +		};
> +		struct tcmsg tc;
> +	};
> +	char buf[128];
> +};
> +
>   /**
>    * @ingroup attr
>    * Iterate over a stream of attributes
> @@ -111,44 +124,44 @@ static inline struct nlattr *nla_data(struct nlattr *nla)
>   	return (struct nlattr *)((char *)nla + NLA_HDRLEN);
>   }
>   
> -static inline struct nlattr *nh_tail(struct nlmsghdr *nh)
> +static inline struct nlattr *req_tail(struct netlink_request *req)
>   {
> -	return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
> +	return (struct nlattr *)((char *)req + NLMSG_ALIGN(req->nh.nlmsg_len));
>   }
>   
[...]
Thanks,
Daniel
