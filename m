Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51F93DEEA5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhHCNB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235635AbhHCNBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 09:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8516C60F58;
        Tue,  3 Aug 2021 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627995705;
        bh=VDNUMBQHWKK42+Ao89Hi8ULJpILTHeCXq/QPa4tn/H0=;
        h=In-Reply-To:References:Cc:To:Subject:From:Date:From;
        b=WTnA8CYW4V/yjq+Q4Hg2X1MQYiifWToTuubOya9wcik2lxn0Q4XoZP7c6+4d04hbF
         Oe4Z7GQ3W9pxJKnM4JICBpm0dArU9wkzX53YekGq0Tz0Tf5ofY/pD34dqgCk6YQJJ6
         ASWScGb9VU5BB6lAcBEugJ3oBtw8fb4KzNKhtAl8EyoDNsv9mM0LF68lW+MAXxcOt7
         4qrvEx0yve2aSKqZK/zp1oAuxuHaazL1h6qRPMBjTAKYZv0mgUuy4C1ThYlfFB4N6M
         tTaglJ5974nbQXE1flZw699SRKD75ZMfyU66xMqiWDmVzsej8hJyAnq7cGBUq+poFU
         fxypVK/AQzcaw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d335ddaa-18dc-f9f0-17ee-9783d3b2ca29@mailbox.tu-dresden.de>
References: <d335ddaa-18dc-f9f0-17ee-9783d3b2ca29@mailbox.tu-dresden.de>
Cc:     scott@scottdial.com, davem@davemloft.net,
        gregkh@linuxfoundation.org
To:     Sebastian Rehms <sebastian.rehms@mailbox.tu-dresden.de>,
        netdev@vger.kernel.org
Subject: Re: MACSec performance issues
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <162799570221.4307.17223951300191730387@kwain>
Date:   Tue, 03 Aug 2021 15:01:42 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sebastian,

Quoting Sebastian Rehms (2021-08-03 13:48:59)
>=20
> We did some performance tests on MACSec and observed data rates of about
> 5-6 GBits/s. (measured with iperf3)
> After a kernel update the maximum data rate dropped to about 600 MBit/s.
>=20
> Due to this huge difference we did some further investigations and found
> that the main reason is a change in the file drivers/net/macsec.c in the
> function crypto_alloc_aead().
>=20
> The change was introduced by commit
> 0899ff04c872463455f2749d13a5d311338021a3 (upstream commit
> ab046a5d4be4c90a3952a0eae75617b49c0cb01b)
>=20
> -       tfm =3D crypto_alloc_aead("gcm(aes)", 0, 0);
> +       /* Pick a sync gcm(aes) cipher to ensure order is preserved. */
> +       tfm =3D crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
>=20
>=20
> According to the commit description, the  CRYPTO_ALG_ASYNC flag is
> required to guarantee correct packet ordering which is indeed an
> implicit provision of the MACSec standard.
>=20
> First, it would be desirable to verify, that the impact of the flag is
> large not only on our hardware but that it is a general phenomenon.

FYI, performance issues with CRYPTO_ALG_ASYNC was reported and discussed
in the following thread:
https://lore.kernel.org/netdev/1b0cec71-d084-8153-2ba4-72ce71abeb65@byu.edu/

Antoine
