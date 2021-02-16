Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEE31C7F3
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 10:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBPJVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 04:21:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:30603 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhBPJVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 04:21:40 -0500
IronPort-SDR: mp36r1ZNwifQ6Y+o7C+mkj8n9M47F+p2d3tA/49gFgaXqbvZvJDDOy0+V7lxVgZH34qXmwsOuS
 DVPoW7zPp9cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="161978560"
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="161978560"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:20:58 -0800
IronPort-SDR: jKRxVNMnXLPtCFKPCXXBcpY+0sD70Wo/FMFD9AEBrJAKESYCDoEwTmXo/pL4arDH70eb9RwNuK
 dkd0mk+lu4PA==
X-IronPort-AV: E=Sophos;i="5.81,183,1610438400"; 
   d="scan'208";a="399438755"
Received: from tkanteck-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.159])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 01:20:54 -0800
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
To:     John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <4a52d09a-363b-e69e-41d3-7918f0204901@intel.com>
Date:   Tue, 16 Feb 2021 10:20:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-15 21:49, John Fastabend wrote:
> Maciej Fijalkowski wrote:
>> Currently, if there are multiple xdpsock instances running on a single
>> interface and in case one of the instances is terminated, the rest of
>> them are left in an inoperable state due to the fact of unloaded XDP
>> prog from interface.
>>
>> To address that, step away from setting bpf prog in favour of bpf_link.
>> This means that refcounting of BPF resources will be done automatically
>> by bpf_link itself.
>>
>> When setting up BPF resources during xsk socket creation, check whether
>> bpf_link for a given ifindex already exists via set of calls to
>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
>> and comparing the ifindexes from bpf_link and xsk socket.
>>
>> If there's no bpf_link yet, create one for a given XDP prog and unload
>> explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.
>>
>> If bpf_link is already at a given ifindex and underlying program is not
>> AF-XDP one, bail out or update the bpf_link's prog given the presence of
>> XDP_FLAGS_UPDATE_IF_NOEXIST.
>>
>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>> ---
>>   tools/lib/bpf/xsk.c | 143 +++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 122 insertions(+), 21 deletions(-)
> 
> [...]
> 
>> +static int xsk_create_bpf_link(struct xsk_socket *xsk)
>> +{
>> +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
>> +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
>> +	 */
>> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
>> +			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
>> +	struct xsk_ctx *ctx = xsk->ctx;
>> +	__u32 prog_id;
>> +	int link_fd;
>> +	int err;
>> +
>> +	/* for !XDP_FLAGS_UPDATE_IF_NOEXIST, unload the program first, if any,
>> +	 * so that bpf_link can be attached
>> +	 */
>> +	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
>> +		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
>> +		if (err) {
>> +			pr_warn("getting XDP prog id failed\n");
>> +			return err;
>> +		}
>> +		if (prog_id) {
>> +			err = bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
>> +			if (err < 0) {
>> +				pr_warn("detaching XDP prog failed\n");
>> +				return err;
>> +			}
>> +		}
>>   	}
>>   
>> -	ctx->prog_fd = prog_fd;
>> +	link_fd = bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP, &opts);
>> +	if (link_fd < 0) {
>> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
>> +		return link_fd;
>> +	}
>> +
> 
> This can leave the system in a bad state where it unloaded the XDP program
> above, but then failed to create the link. So we should somehow fix that
> if possible or at minimum put a note somewhere so users can't claim they
> shouldn't know this.
> 
> Also related, its not good for real systems to let XDP program go missing
> for some period of time. I didn't check but we should make
> XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.
>

This is the default for XDP sockets library. The
"bpf_set_link_xdp_fd(...-1)" way is only when a user sets it explicitly.
One could maybe argue that the "force remove" would be out of scope for
AF_XDP; Meaning that if an XDP program is running, attached via netlink,
the AF_XDP library simply cannot remove it. The user would need to rely
on some other mechanism.


Björn


[...]
