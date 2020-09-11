Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C15266983
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgIKU0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgIKU0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 16:26:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB961208FE;
        Fri, 11 Sep 2020 20:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599855981;
        bh=EyWfBUveRP9IoMM890E0z2ZXTCirLKVWsF8PPWPdQ6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rvoSAermSAMNmHomiZikmgd/l6o2UZMy8d07sZjC5fasDuokA70B4xaOsyHl85SJU
         a1Krqr4XoV4iKzzxXAZetwOil9jgB0dkgEv221TM5KObwb0xbkPndc0xN3AYOWQwX8
         92fWWzrFi0azFWvVp+1zrV2XVUqJ5jOrDDGRl+qA=
Date:   Fri, 11 Sep 2020 13:26:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/7] sfc: decouple TXQ type from label
Message-ID: <20200911132619.20ad2500@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <81283b4d-8176-3db2-dc95-87a37c06b7c0@solarflare.com>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
        <6fc83ee8-6b6c-c2ea-ca81-659b6ef25569@solarflare.com>
        <20200911085358.5fdd3f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <81283b4d-8176-3db2-dc95-87a37c06b7c0@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 18:36:04 +0100 Edward Cree wrote:
> >> +		/* We don't have a TXQ of the right type.
> >> +		 * This should never happen, as we don't advertise offload
> >> +		 * features unless we can support them.
> >> +		 */
> >> +		return NETDEV_TX_BUSY; =20
> > You should probably drop this packet, right? Next time qdisc calls the
> > driver it's unlikely to find a queue it needs. =20
> Hmm, the comment at the top of efx_hard_start_xmit() claims that
> =C2=A0"returning anything other than NETDEV_TX_OK will cause the OS to fr=
ee
> =C2=A0the skb".=C2=A0 Is that not in fact true?

Old drivers routinely return TX_BUSY when their queue fills up,
so the skb is put back in the qdisc to wait for the driver to restart
its queues.

> Should I instead do what the error path of __efx_enqueue_skb() does -
> =C2=A0free the skb, kick pending TX, and return NETDEV_TX_OK?=C2=A0 I hav=
e to
> =C2=A0admit I've never 100% understood the netdev_tx_t semantics.

Yeah, I'm not sure what all of them do either. But in modern drivers
which stop their queues before they fill up really the only return
value which makes sense is NETDEV_TX_OK - either after successful
submission to HW, or error and freeing the skb.
