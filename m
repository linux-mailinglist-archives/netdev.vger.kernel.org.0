Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77412C1B50
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 03:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgKXCMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 21:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbgKXCMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 21:12:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3CFB206E0;
        Tue, 24 Nov 2020 02:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606183957;
        bh=sqKYie7uVLawkQgPh0ppY6pbZ/7Cp5NejBMG75XWVfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d1C4B1OOcEzKb9faD2SuSiBDhz0vjHI3Ui6TTo9a57jgDHmm3/lRxeblKBchWrPjq
         MGrK6oS4zxsynqMkC1mjBEEr29FFe+8sxrfGfzeewvkmKx0hjAVH5W3vGt+fBT70kG
         xvG9Uoto6ZbEgN79/3Ve4f9+AGC9v1D6VdD87unI=
Date:   Mon, 23 Nov 2020 18:12:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net-next 4/5] net/tls: add CHACHA20-POLY1305 configuration
Message-ID: <20201123181236.75616d6d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1606010265-30471-5-git-send-email-vfedorenko@novek.ru>
References: <1606010265-30471-1-git-send-email-vfedorenko@novek.ru>
        <1606010265-30471-5-git-send-email-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The series LGTM, great to see chacha support!

One nit here, and when you post v2 would you mind ccing crypto?

=46rom TLS perspective I think this code is ready to be merged, but
my crypto knowledge is close to none, so best if we give crypto
folks a chance to take a look.

On Sun, 22 Nov 2020 04:57:44 +0300 Vadim Fedorenko wrote:
> +	case TLS_CIPHER_CHACHA20_POLY1305: {
> +		nonce_size =3D 0;
> +		tag_size =3D TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE;
> +		iv_size =3D TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE;
> +		iv =3D ((struct tls12_crypto_info_chacha20_poly1305 *)crypto_info)->iv;

[1]

> +		rec_seq_size =3D TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE;
> +		rec_seq =3D
> +		((struct tls12_crypto_info_chacha20_poly1305 *)crypto_info)->rec_seq;

[2]

> +		chacha20_poly1305_info =3D
> +		(struct tls12_crypto_info_chacha20_poly1305 *)crypto_info;

Move this line up, and use it in [1] and [2].

You can also make it:

	chacha20_poly1305_info =3D (void *)crypto_info;

> +		keysize =3D TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE;
> +		key =3D chacha20_poly1305_info->key;
> +		salt =3D chacha20_poly1305_info->salt;
> +		salt_size =3D TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE;
> +		cipher_name =3D "rfc7539(chacha20,poly1305)";
> +		break;
> +	}
