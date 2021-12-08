Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52AC46CCB6
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbhLHE6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbhLHE6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:58:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA4C061574;
        Tue,  7 Dec 2021 20:54:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E72BAB81113;
        Wed,  8 Dec 2021 04:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50484C00446;
        Wed,  8 Dec 2021 04:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638939290;
        bh=QzpLNlXkFfImyVZGOh/uOxoZ8fvFbbhdu2ggxLvDANU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=of5R5Yt/xECfd/NJ78cGUvMnIREShsexgwsFyBuA8QSYv/hX0VN7y29spOCfZF0R7
         UYqsZXE53+Lr2cOplex9zr1+XNJb2AwTv/FBmZwUgFqkNyB5C8sCb3NnSvbXFiDssQ
         Nd8xM7aL9THxGyFH1u0nXOzTsolYhvIgVbl89wLkcabdEUmbD7tnS+XVIRDARiFbuM
         BgI7of7L3n1Xk8WDbi3uIjMDe3frLTPqOF9xQHxv/Nvj/Gdc67UqJzq5ncWemsryWM
         PyIMSV1RtEg3PMKmF1mWIZBY0fXk4wQyWLoxrsGckWTzK9R/qWbpk5C06RvlCzHsKq
         ljCR+KdVLCs6w==
Date:   Tue, 7 Dec 2021 20:54:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: lantiq_xrx200: increase buffer reservation
Message-ID: <20211207205448.3b297e7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206223909.749043-1-olek2@wp.pl>
References: <20211206223909.749043-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 23:39:09 +0100 Aleksander Jan Bajkowski wrote:
> +static int xrx200_max_frame_len(int mtu)
> +{
> +	return VLAN_ETH_HLEN + mtu + ETH_FCS_LEN;

You sure the problem is not that this doesn't include ETH_HLEN?=20
MTU is the length of the L2 _payload_.

> +}
> +
> +static int xrx200_buffer_size(int mtu)
> +{
> +	return round_up(xrx200_max_frame_len(mtu) - 1, 4 * XRX200_DMA_BURST_LEN=
);

Why the - 1 ? =F0=9F=A4=94

For a frame size 101 =3D> max_frame_len 109 you'll presumably want=20
the buffer to be 116, not 108?

> +}
> +
