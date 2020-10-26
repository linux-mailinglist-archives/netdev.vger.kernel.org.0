Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4912995A6
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790272AbgJZSqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502899AbgJZSqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:46:35 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77A2420732;
        Mon, 26 Oct 2020 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603737994;
        bh=41zTD0uKHN/7L9+6DDscKiefNyVnH7VUtCoENm6S22k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C04dpnuCOWi9kk9WlbVfybJbhFI6JwC/iNh56xPlSywRO0TZtXoj6ZTjUKzo9Le4C
         UhjPcz+yBYDAlAS8MdEG5VgRw/AUGLLJa95hsqRGdTBAoKgKM9xQRAdxr+TNWZUXhv
         H8G2qp706gbJuENBMPJ9ueAfsOY+wD5dKTBJCeDA=
Date:   Mon, 26 Oct 2020 11:46:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Masahiro Fujiwara <fujiwara.masahiro@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andreas Schultz <aschultz@tpip.net>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] gtp: fix an use-before-init in gtp_newlink()
Message-ID: <20201026114633.1b2628ae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026072227.7280-1-fujiwara.masahiro@gmail.com>
References: <20201025140550.1e29f770@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201026072227.7280-1-fujiwara.masahiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 16:22:27 +0900 Masahiro Fujiwara wrote:
> v2:
>  - leave out_hashtable: label for clarity (Jakub).
>  - fix code and comment styles.

Thanks!

> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 8e47d0112e5d..07cb6d9495e8 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -663,10 +663,6 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  
>  	gtp = netdev_priv(dev);
>  
> -	err = gtp_encap_enable(gtp, data);
> -	if (err < 0)
> -		return err;
> -
>  	if (!data[IFLA_GTP_PDP_HASHSIZE]) {
>  		hashsize = 1024;
>  	} else {
> @@ -676,13 +672,17 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
>  	}
>  
>  	err = gtp_hashtable_new(gtp, hashsize);
> +	if (err < 0)
> +		return err;
> +
> +	err = gtp_encap_enable(gtp, data);
>  	if (err < 0)
>  		goto out_encap;

This needs to say goto out_hashtable; now.
