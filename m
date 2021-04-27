Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4229936CE04
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbhD0V4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:56:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:34788 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239075AbhD0V4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 17:56:41 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbVgQ-000DfO-EH; Tue, 27 Apr 2021 23:55:54 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbVgQ-000BQY-52; Tue, 27 Apr 2021 23:55:54 +0200
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
References: <20210423150600.498490-1-memxor@gmail.com>
 <20210423150600.498490-3-memxor@gmail.com>
 <5811eb10-bc93-0b81-2ee4-10490388f238@iogearbox.net>
 <20210427180202.pepa2wdbhhap3vyg@apollo>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9985fe91-76ea-7c09-c285-1006168f1c27@iogearbox.net>
Date:   Tue, 27 Apr 2021 23:55:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210427180202.pepa2wdbhhap3vyg@apollo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26153/Tue Apr 27 13:09:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/21 8:02 PM, Kumar Kartikeya Dwivedi wrote:
> On Tue, Apr 27, 2021 at 08:34:30PM IST, Daniel Borkmann wrote:
>> On 4/23/21 5:05 PM, Kumar Kartikeya Dwivedi wrote:
[...]
>>> +/*
>>> + * @ctx: Can be NULL, if not, must point to a valid object.
>>> + *	 If the qdisc was attached during ctx_init, it will be deleted if no
>>> + *	 filters are attached to it.
>>> + *	 When ctx == NULL, this is a no-op.
>>> + */
>>> +LIBBPF_API int bpf_tc_ctx_destroy(struct bpf_tc_ctx *ctx);
>>> +/*
>>> + * @ctx: Cannot be NULL.
>>> + * @fd: Must be >= 0.
>>> + * @opts: Cannot be NULL, prog_id must be unset, all other fields can be
>>> + *	  optionally set. All fields except replace  will be set as per created
>>> + *        filter's attributes. parent must only be set when attach_point of ctx is
>>> + *        BPF_TC_CUSTOM_PARENT, otherwise parent must be unset.
>>> + *
>>> + * Fills the following fields in opts:
>>> + *	handle
>>> + *	parent
>>> + *	priority
>>> + *	prog_id
>>> + */
>>> +LIBBPF_API int bpf_tc_attach(struct bpf_tc_ctx *ctx, int fd,
>>> +			     struct bpf_tc_opts *opts);
>>> +/*
>>> + * @ctx: Cannot be NULL.
>>> + * @opts: Cannot be NULL, replace and prog_id must be unset, all other fields
>>> + *	  must be set.
>>> + */
>>> +LIBBPF_API int bpf_tc_detach(struct bpf_tc_ctx *ctx,
>>> +			     const struct bpf_tc_opts *opts);
>>
>> One thing that I find a bit odd from this API is that BPF_TC_INGRESS / BPF_TC_EGRESS
>> needs to be set each time via bpf_tc_ctx_init(). So whenever a specific program would
>> be attached to both we need to 're-init' in between just to change from hook a to b,
>> whereas when you have BPF_TC_CUSTOM_PARENT, you could just use a different opts->parent
>> without going this detour (unless the clsact wasn't loaded there in the first place).
> 
> Currently I check that opts->parent is unset when BPF_TC_INGRESS or BPF_TC_EGRESS
> is set as attach point. But since both map to clsact, we could allow the user to
> specify opts->parent as BPF_TC_INGRESS or BPF_TC_EGRESS (no need to use
> TC_H_MAKE, we can detect it from ctx->parent that it won't be a parent id). This
> would mean that by default attach point is what you set for ctx, but for
> bpf_tc_attach you can temporarily override to be some other attach point (for
> the same qdisc). You still won't be able to set anything other than the two
> though.

I think the assumption on auto-detecting the parent id in that case might not hold given
major number could very well be 0. Wrt BPF_TC_UNSPEC ... maybe it's not even needed, back
to drawing board ...

Here's how the whole API could look like, usage examples below:

   enum bpf_tc_attach_point {
	BPF_TC_INGRESS = 1 << 0,
	BPF_TC_EGRESS  = 1 << 1,
	BPF_TC_CUSTOM  = 1 << 2,
   };

   enum bpf_tc_attach_flags {
	BPF_TC_F_REPLACE = 1 << 0,
   };

   struct bpf_tc_hook {
	size_t sz;
	int    ifindex;
	enum bpf_tc_attach_point which;
	__u32  parent;
	size_t :0;
   };

   struct bpf_tc_opts {
	size_t sz;
	__u32  handle;
	__u16  priority;
	union {
		int   prog_fd;
		__u32 prog_id;
	};
	size_t :0;
   };

   LIBBPF_API int bpf_tc_hook_create(struct bpf_tc_hook *hook);
   LIBBPF_API int bpf_tc_hook_destroy(struct bpf_tc_hook *hook);

   LIBBPF_API int bpf_tc_attach(const struct bpf_tc_hook *hook, const struct bpf_tc_opts *opts, int flags);
   LIBBPF_API int bpf_tc_detach(const struct bpf_tc_hook *hook, const struct bpf_tc_opts *opts);
   LIBBPF_API int bpf_tc_query(const struct bpf_tc_hook *hook, struct bpf_tc_opts *opts);

So a user could do just:

   DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = 42, .which = BPF_TC_INGRESS);
   DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1, .prog_fd = fd);

   err = bpf_tc_attach(&hook, &opts, BPF_TC_F_REPLACE);
   [...]

If it's not known whether the hook exists, then a preceding call to:

   err = bpf_tc_hook_create(&hook);
   [...]

The bpf_tc_query() would look like:

   DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = 42, .which = BPF_TC_EGRESS);
   DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1);

   err = bpf_tc_query(&hook, &opts);
   if (!err) {
          [...]  // gives access to: opts.prog_id
   }

The bpf_tc_detach():

   DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = 42, .which = BPF_TC_INGRESS);
   DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1);

   err = bpf_tc_detach(&hook, &opts);
   [...]

The nice thing would be that hook and opts are kept semantically separate, meaning with
hook you can iterate though a bunch of devs and ingress/egress locations without changing
opts, whereas with opts you could iterate on the cls_bpf instance itself w/o changing
hook. Both are kept extensible via DECLARE_LIBBPF_OPTS().

Now the bpf_tc_hook_destroy() one:

   DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex = 42, .which = BPF_TC_INGRESS|BPF_TC_EGRESS);

   err = bpf_tc_hook_destroy(&hook, &opts);
   [...]

For triggering a remove of the clsact qdisc on the device, both directions are passed in.
Combining both is only ever allowed for bpf_tc_hook_destroy().

If /only/ BPF_TC_INGRESS or only BPF_TC_EGRESS is passed, it could flush their lists (aka
equivalent of `tc filter del dev eth0 ingress` and `tc filter del dev eth0 egress` command).

For bpf_tc_hook_{create,destroy}() with BPF_TC_CUSTOM, we just return -EINVAL or -EOPNOTSUPP.

I think the above interface would work nicely and feels intuitive while being extensible.
Thoughts?

Thanks,
Daniel
