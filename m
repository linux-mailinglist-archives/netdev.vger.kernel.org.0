Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E06311FCC
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 20:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBFTv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 14:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFTvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 14:51:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1273A64E0D;
        Sat,  6 Feb 2021 19:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612641041;
        bh=m8WrAh681nUwKPtjq8duKCxuFDDTH9VjLnNFHpxjTV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZlDvuOsDdkHpT7X1GgC4TC1NzFoz1NLeOh2/XHk633At58Qa/U/Iua67joweaiz50
         7NxFepL08c25rajM9Cg4XQZwKi4VlCKQ6eyP8eNlS9eewcH9auVuO4gIsRe9A+1T78
         5q2toB2dBlc0nR7/KZbbM301J1mBlzaeUbt6WixdGjByGl5M2xY8YOqxT4rAEBSPJL
         QyZiM90rpHsOs9gGN6c4NhEiLkcJKBYLbNKKPd5b81EE3jf+SJa2K5+2nidgP0CAp7
         zpteTNG/SMN1flMbXDfjs08NJqZ7L8pyyThAuG20GqQPQg5izPgBRFvbXQd9n3S/G4
         obLi0KXx+DlRQ==
Date:   Sat, 6 Feb 2021 11:50:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-drivers-2021-02-05
Message-ID: <20210206115040.0d887565@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206194325.GA134674@lore-desk>
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
        <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210206194325.GA134674@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Feb 2021 20:43:25 +0100 Lorenzo Bianconi wrote:
> > Lorenzo, I'm just guessing what this code does, but you're dropping a
> > frag without invalidating the rest of the SKB, which I presume is now
> > truncated? Shouldn't the skb be dropped?
> >  =20
>=20
> Hi Jakub,
>=20
> I agree. We can do something like:
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wirel=
ess/mediatek/mt76/dma.c
> index e81dfaf99bcb..6d84533d1df2 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -511,8 +511,9 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_q=
ueue *q, void *data,
>  {
>  	struct sk_buff *skb =3D q->rx_head;
>  	struct skb_shared_info *shinfo =3D skb_shinfo(skb);
> +	int nr_frags =3D shinfo->nr_frags;
> =20
> -	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
> +	if (nr_frags < ARRAY_SIZE(shinfo->frags)) {
>  		struct page *page =3D virt_to_head_page(data);
>  		int offset =3D data - page_address(page) + q->buf_offset;
> =20
> @@ -526,7 +527,10 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_=
queue *q, void *data,
>  		return;
> =20
>  	q->rx_head =3D NULL;
> -	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
> +	if (nr_frags < ARRAY_SIZE(shinfo->frags))
> +		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
> +	else
> +		dev_kfree_skb(skb);
>  }
> =20
>=20
> I do not know if it can occur, but I guess we should even check q->rx_head
> pointer before overwriting it because if the hw does not report more set =
to
> false for last fragment we will get a memory leak as well. Something like:
>=20
> @@ -578,6 +582,8 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76=
_queue *q, int budget)
>  		done++;
> =20
>  		if (more) {
> +			if (q->rx_head)
> +				dev_kfree_skb(q->rx_head);
>  			q->rx_head =3D skb;
>  			continue;
>  		}

=F0=9F=91=8D
