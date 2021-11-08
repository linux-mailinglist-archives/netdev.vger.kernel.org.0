Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2D8449BFB
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbhKHSxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbhKHSxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:53:23 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF233C061570;
        Mon,  8 Nov 2021 10:50:38 -0800 (PST)
Date:   Mon, 8 Nov 2021 19:50:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1636397436;
        bh=L6MFlY7fncI7DTAhySExlSyQ36N0y6PwyRwcayAnt6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATxD+/7NQrBK6w98+St8hye1dyDqJ/XVefzz3A+E4wsY/9IPnPcEuie7Bx8TdpWPk
         4J+viPttbySzEI1AQl+GCBK8rdPh9ml/P3cCzMXsdQE5e1rtNKA2oja7w51XSXuTau
         3SrTnH6BZR2VbxLua9Vr1Ycbxmyv6lrMv4SP2qXU=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net/p9: load default transports
Message-ID: <c2a33fa1-30b0-4f19-808f-3bd0316a4ed8@t-8ch.de>
References: <20211103193823.111007-1-linux@weissschuh.net>
 <20211103193823.111007-5-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103193823.111007-5-linux@weissschuh.net>
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dominique,

On 2021-11-03 20:38+0100, Thomas Weißschuh wrote:
> Now that all transports are split into modules it may happen that no
> transports are registered when v9fs_get_default_trans() is called.
> When that is the case try to load more transports from modules.
> 
> Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
> ---
>  net/9p/mod.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/9p/mod.c b/net/9p/mod.c
> index 8f1d067b272e..7bb875cd279f 100644
> --- a/net/9p/mod.c
> +++ b/net/9p/mod.c
> @@ -128,6 +128,10 @@ struct p9_trans_module *v9fs_get_trans_by_name(const char *s)
>  }
>  EXPORT_SYMBOL(v9fs_get_trans_by_name);
>  
> +static const char * const v9fs_default_transports[] = {
> +	"virtio", "tcp", "fd", "unix", "xen", "rdma",
> +};
> +
>  /**
>   * v9fs_get_default_trans - get the default transport
>   *
> @@ -136,6 +140,7 @@ EXPORT_SYMBOL(v9fs_get_trans_by_name);
>  struct p9_trans_module *v9fs_get_default_trans(void)
>  {
>  	struct p9_trans_module *t, *found = NULL;
> +	int i;
>  
>  	spin_lock(&v9fs_trans_lock);
>  
> @@ -153,6 +158,10 @@ struct p9_trans_module *v9fs_get_default_trans(void)
>  			}
>  
>  	spin_unlock(&v9fs_trans_lock);
> +
> +	for (i = 0; !found && i < ARRAY_SIZE(v9fs_default_transports); i++)
> +		found = v9fs_get_trans_by_name(v9fs_default_transports[i]);
> +
>  	return found;
>  }
>  EXPORT_SYMBOL(v9fs_get_default_trans);
> -- 
> 2.33.1

I did not notice that you already had applied "net/9p: autoload transport modules"
to your tree when sending this series.

Please note that in this series I modified patch 1 a bit, from the ony you
applied, to prevent warnings in patch 4.
Concretely I modified the prototypes of `v9fs_get_trans_by_name()` and
`_p9_get_trans_by_name()` to take const parameters.

Feel free to roll those changes into this patch when applying or I can resend
the patch/series.

Thomas
