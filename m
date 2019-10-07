Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14EACDE5F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 11:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfJGJnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 05:43:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:36202 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfJGJnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 05:43:51 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iHPYR-0004PX-5O; Mon, 07 Oct 2019 11:43:47 +0200
Date:   Mon, 7 Oct 2019 11:43:46 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        quentin.monnet@netronome.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 1/3] uapi/bpf: fix helper docs
Message-ID: <20191007094346.GC27307@pc-66.home>
References: <20191007030738.2627420-1-andriin@fb.com>
 <20191007030738.2627420-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007030738.2627420-2-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25595/Mon Oct  7 10:28:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 06, 2019 at 08:07:36PM -0700, Andrii Nakryiko wrote:
> Various small fixes to BPF helper documentation comments, enabling
> automatic header generation with a list of BPF helpers.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/uapi/linux/bpf.h       | 32 ++++++++++++++++----------------
>  tools/include/uapi/linux/bpf.h | 32 ++++++++++++++++----------------
>  2 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 77c6be96d676..a65c3b0c6935 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -794,7 +794,7 @@ union bpf_attr {
>   * 		A 64-bit integer containing the current GID and UID, and
>   * 		created as such: *current_gid* **<< 32 \|** *current_uid*.

Overall, I do like the approach that we keep generating the BPF helpers header
file from this documentation as it really enforces that the signatures here
must be 100% correct, and given this also lands in the man page it is /always/
in sync.

> - * int bpf_get_current_comm(char *buf, u32 size_of_buf)
> + * int bpf_get_current_comm(void *buf, u32 size_of_buf)

You did not elaborate why this needs to change from char * to void *. What is
the reason? Those rules should probably be documented somewhere, otherwise
people might keep adding them.

>   * 	Description
>   * 		Copy the **comm** attribute of the current task into *buf* of
>   * 		*size_of_buf*. The **comm** attribute contains the name of
> @@ -1023,7 +1023,7 @@ union bpf_attr {
>   * 		The realm of the route for the packet associated to *skb*, or 0
>   * 		if none was found.
>   *
> - * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
> + * int bpf_perf_event_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)

This one here is because we have multiple program types with different input context.

>   * 	Description
>   * 		Write raw *data* blob into a special BPF perf event held by
>   * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
> @@ -1068,7 +1068,7 @@ union bpf_attr {
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
>   *
> - * int bpf_skb_load_bytes(const struct sk_buff *skb, u32 offset, void *to, u32 len)
> + * int bpf_skb_load_bytes(const void *skb, u32 offset, void *to, u32 len)

Changing from struct sk_buff * to void * here, again due to struct sk_reuseport_kern *?

I'm wondering whether it would simply be much better to always just use 'void *ctx'
for everything that is BPF context as it may be just confusing to people why different
types are chosen sometimes leading to buggy drive-by attempts to 'fix' them back into
struct sk_buff * et al.

>   * 	Description
>   * 		This helper was provided as an easy way to load data from a
>   * 		packet. It can be used to load *len* bytes from *offset* from
> @@ -1085,7 +1085,7 @@ union bpf_attr {
>   * 	Return
>   * 		0 on success, or a negative error in case of failure.
>   *
> - * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
> + * int bpf_get_stackid(void *ctx, struct bpf_map *map, u64 flags)
>   * 	Description
>   * 		Walk a user or a kernel stack and return its id. To achieve
>   * 		this, the helper needs *ctx*, which is a pointer to the context
> @@ -1154,7 +1154,7 @@ union bpf_attr {
>   * 		The checksum result, or a negative error code in case of
>   * 		failure.
>   *
> - * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, u8 *opt, u32 size)
> + * int bpf_skb_get_tunnel_opt(struct sk_buff *skb, void *opt, u32 size)

Same here and in more places in this patch, why u8 * -> void * and the like?

>   * 	Description
>   * 		Retrieve tunnel options metadata for the packet associated to
>   * 		*skb*, and store the raw tunnel option data to the buffer *opt*
[...]
