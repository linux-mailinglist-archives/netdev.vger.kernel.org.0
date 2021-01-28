Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B5308098
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhA1VdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:33:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231374AbhA1VdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:33:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC4B664DEB;
        Thu, 28 Jan 2021 21:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611869557;
        bh=SOehIj07NmgFC5qrn/E3mmRYGPwBdT0yjeUDK7dCkWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tayG+Y6iMbkShZTYn+a0vzOaLQ9lcfgQZmTQrOvhikUDBKYS92B03bAoQpEICIns3
         HJ5rKbxybDlrRi+ks5yGYZawF1y9IqKjDxmidyEeaZugQkcagnz+tZ4G2KCZku/FbX
         V0/D3/BihVisLlOWzCuBPWR3YagB8hxPodP1c3rAVhCf2w9Y99JzXGMY9IypOtAaG4
         IdvLZ27qFeI6J/kkIy8CCejKYBgACOXIOb9+sb6SxFU1lBYlgZbAQF/YMfD4t2DHhS
         sbIvh1pAB2JWDj/1Cr8RI6QoJwRYz+vS0WTjZ1AIaQL1Hx8hbEeE1bLR8N3o5t7zKw
         wqvbBYVZmHsGw==
Date:   Thu, 28 Jan 2021 13:32:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, zeil@yandex-team.ru,
        dmtrmonakhov@yandex-team.ru
Subject: Re: [PATCH net] net: sched: replaced invalid qdisc tree flush
 helper in qdisc_replace
Message-ID: <20210128133235.0c75b81e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210126215641.545645-1-ovov@yandex-team.ru>
References: <20210126215641.545645-1-ovov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 00:56:41 +0300 Alexander Ovechkin wrote:
> Commit e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge helpers")
> introduced qdisc tree flush/purge helpers, but erroneously used flush helper
> instead of purge helper in qdisc_replace function.
> This issue was found in our CI, that tests various qdisc setups by configuring
> qdisc and sending data through it. Call of invalid helper sporadically leads
> to corruption of vt_tree/cf_tree of hfsc_class that causes kernel oops:

The patch in question indeed does change the code, but I wonder if the
problem isn't in HFSC. Why would the caller depend on the old qdisc
being purged by qdisc_replace()?

Please add some more info on this..

> Fixes: e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge
> helpers")

... fix the tag (it shouldn't be wrapped), and CC the right people
(especially the author of the patch you're pointing the tag at -
scripts/get_maintainer is your friend), and repost.

> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Reported-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
> Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  include/net/sch_generic.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 639e465a108f..5b490b5591df 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -1143,7 +1143,7 @@ static inline struct Qdisc *qdisc_replace(struct Qdisc *sch, struct Qdisc *new,
>  	old = *pold;
>  	*pold = new;
>  	if (old != NULL)
> -		qdisc_tree_flush_backlog(old);
> +		qdisc_purge_queue(old);
>  	sch_tree_unlock(sch);
>  
>  	return old;

