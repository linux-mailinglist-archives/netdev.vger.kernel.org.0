Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574EB2A7504
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbgKEBpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKEBpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:45:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D29A206F9;
        Thu,  5 Nov 2020 01:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604540722;
        bh=JWNgdBCXyhHODoQkUCi68D41Ql07Hr6bmINvKaLjDoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H1tILDJ/7mU3c0m7OLwEs/xOMZZSvKf9NhZrO4hv4YumFQXDh7VamMjzM9Um2x9lA
         1trToasDNkcVPyNN49VwOX7d2KaJ+4ypoSgkM+XS3xywPK81XVuZkSWqincTT1Wfan
         90TR4T+IGU23EX7nr0MdhBxF/3oD+T4j3ZkuJPJs=
Date:   Wed, 4 Nov 2020 17:45:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Plotnikov <wgh@torlan.ru>
Subject: Re: [PATCH net] r8169: work around short packet hw bug on RTL8125
Message-ID: <20201104174521.2a902678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8002c31a-60b9-58f1-f0dd-8fd07239917f@gmail.com>
References: <8002c31a-60b9-58f1-f0dd-8fd07239917f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 18:52:18 +0100 Heiner Kallweit wrote:
> Network problems with RTL8125B have been reported [0] and with help
> from Realtek it turned out that this chip version has a hw problem
> with short packets (similar to RTL8168evl). Having said that activate
> the same workaround as for RTL8168evl.
> Realtek suggested to activate the workaround for RTL8125A too, even
> though they're not 100% sure yet which RTL8125 versions are affected.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
> 
> Fixes: 0439297be951 ("r8169: add support for RTL8125B")
> Reported-by: Maxim Plotnikov <wgh@torlan.ru>
> Tested-by: Maxim Plotnikov <wgh@torlan.ru>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!

> @@ -4125,7 +4133,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>  
>  		opts[1] |= transport_offset << TCPHO_SHIFT;
>  	} else {
> -		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
> +		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
>  			return !eth_skb_pad(skb);
>  	}

But looks like we may have another bug here - looks like this function
treas skb_cow_head() and eth_skb_pad() failures the same, but former
doesn't free the skb on error, while the latter does.
