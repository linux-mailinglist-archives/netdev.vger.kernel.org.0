Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED6E150923
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgBCPIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgBCPIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 10:08:06 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 119DE2080C;
        Mon,  3 Feb 2020 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580742485;
        bh=K/wRk9Mo7taae+TxofgZMKUL4Bw+cp1ibWYgzzyd8Fs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O8Y3pFun9CYr1EuITEo0Wiqc6BetFwqCj5c8zjSOf4rsF23OEmhDpiN8sIMsJJtG5
         oDt5jGaqgrR29x5KDUiUzABMD792Z1nm4ErXaHLcwxLftyoqMh+oZZu5+xmLUz/I1/
         c1nbSHkYvfFo0A/jy3iMRYqpyVR6ZyKxy3SLBKas=
Date:   Mon, 3 Feb 2020 17:08:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>
Subject: Re: [net-next] seg6: add support for optional attributes during
 behavior construction
Message-ID: <20200203150800.GQ414821@unreal>
References: <20200203143658.1561-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203143658.1561-1-andrea.mayer@uniroma2.it>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 03, 2020 at 03:36:58PM +0100, Andrea Mayer wrote:
> before this patch, each SRv6 behavior specifies a set of required
> attributes that must be provided by the userspace application when the
> behavior is created. If an attribute is not supplied, the creation
> operation fails.
> As a workaround, if an attribute is not needed by a behavior, it requires
> to be set by the userspace application to a conventional skip-value. The
> kernel side, that processes the creation request of a behavior, reads the
> supplied attribute values and checks if it has been set to the
> conventional skip-value or not. Hence, each optional attribute must have a
> conventional skip-value which is known a priori and shared between
> userspace applications and kernel.
>
> Messy code and complicated tricks may arise from this approach.
> On the other hand, this patch explicitly differentiates the required
> mandatory attributes from the optional ones. Now, each behavior can declare
> a set of required attributes and a set of optional ones. The behavior
> creation fails in case a required attribute is missing, while it goes on
> without generating any issue if an optional attribute is not supplied by
> the userspace application.
>
> To properly combine the required and optional attributes, a new callback
> function called destroy() is used for releasing resources that have been
> acquired, during the parse() operation, by a given attribute.
> However, the destroy() function is optional and if an attribute does not
> require resources that have to be later released, the callback can be
> omitted.
>
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 226 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 198 insertions(+), 28 deletions(-)
>
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index 85a5447a3e8d..480f1ab35221 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -7,6 +7,13 @@
>   *  eBPF support: Mathieu Xhonneux <m.xhonneux@gmail.com>
>   */
>
> +/* Changes:
> + *
> + * Andrea Mayer <andrea.mayer@uniroma2.it>
> + *	add support for optional attributes during behavior construction
> + *
> + */

The lines above look strange in 2020 when all of us are using git.

Thanks
