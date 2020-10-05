Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AA72837EC
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgJEOhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:37:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:57326 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgJEOhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 10:37:19 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kPRc2-0006Yg-51; Mon, 05 Oct 2020 16:37:14 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kPRc1-000QdQ-TA; Mon, 05 Oct 2020 16:37:13 +0200
Subject: Re: [PATCH bpf-next] libbpf: fix compatibility problem in
 xsk_socket__create
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, ciara.loftus@intel.com
References: <1601645787-16944-1-git-send-email-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <75f034e8-09c4-9f43-03ed-84f003a036d3@iogearbox.net>
Date:   Mon, 5 Oct 2020 16:37:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1601645787-16944-1-git-send-email-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25947/Sun Oct  4 15:55:07 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/20 3:36 PM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix a compatibility problem when the old XDP_SHARED_UMEM mode is used
> together with the xsk_socket__create() call. In the old XDP_SHARED_UMEM
> mode, only sharing of the same device and queue id was allowed, and in
> this mode, the fill ring and completion ring were shared between the
> AF_XDP sockets. Therfore, it was perfectly fine to call the
> xsk_socket__create() API for each socket and not use the new
> xsk_socket__create_shared() API. This behaviour was ruined by the
> commit introducing XDP_SHARED_UMEM support between different devices
> and/or queue ids. This patch restores the ability to use
> xsk_socket__create in these circumstances so that backward
> compatibility is not broken.
> 
> We also make sure that a user that uses the
> xsk_socket__create_shared() api for the first socket in the old
> XDP_SHARED_UMEM mode above, gets and error message if the user tries
> to feed a fill ring or a completion ring that is not the same as the
> ones used for the umem registration. Previously, libbpf would just
> have silently ignored the supplied fill and completion rings and just
> taken them from the umem. Better to provide an error to the user.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> ---
>   tools/lib/bpf/xsk.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 30b4ca5..5b61932 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -705,7 +705,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>   	struct xsk_ctx *ctx;
>   	int err, ifindex;
>   
> -	if (!umem || !xsk_ptr || !(rx || tx) || !fill || !comp)
> +	if (!umem || !xsk_ptr || !(rx || tx))
>   		return -EFAULT;
>   
>   	xsk = calloc(1, sizeof(*xsk));
> @@ -735,12 +735,24 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>   
>   	ctx = xsk_get_ctx(umem, ifindex, queue_id);
>   	if (!ctx) {
> +		if (!fill || !comp) {
> +			err = -EFAULT;
> +			goto out_socket;
> +		}
> +
>   		ctx = xsk_create_ctx(xsk, umem, ifindex, ifname, queue_id,
>   				     fill, comp);
>   		if (!ctx) {
>   			err = -ENOMEM;
>   			goto out_socket;
>   		}
> +	} else if ((fill && ctx->fill != fill) || (comp && ctx->comp != comp)) {
> +		/* If the xsk_socket__create_shared() api is used for the first socket
> +		 * registration, then make sure the fill and completion rings supplied
> +		 * are the same as the ones used to register the umem. If not, bail out.
> +		 */
> +		err = -EINVAL;
> +		goto out_socket;

This looks buggy. You got a valid ctx in this path which was ctx->refcount++'ed. By just
going to out_socket you'll leak this libbpf internal refcount.

>   	}
>   	xsk->ctx = ctx;
>   
> 

