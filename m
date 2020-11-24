Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEF92C19D3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgKXALG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgKXALF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:11:05 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD8920729;
        Tue, 24 Nov 2020 00:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606176665;
        bh=pEYJSKGv95WDkizhr/Cu+RJdd9sJEmv+bgtYXhjlqHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dH7+jq/yBkHa2KIrAxdH4xgcv2wiOzz5jElmQrW6vW91PsrA3Ktp53geoHupLnzUB
         e6Wg4sEJOH2d0rp7LxoZgCVgJzHAm1YyFBKPv5BnD4jrLH6lukQ36DNG8dtogT/bym
         st1so8Qcab3O9jnRZufLVhnyEup1cJBumGIOplL0=
Date:   Mon, 23 Nov 2020 16:11:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, maciej.fijalkowski@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        qi.z.zhang@intel.com, edumazet@google.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: Re: [PATCH bpf-next v3 01/10] net: introduce preferred busy-polling
Message-ID: <20201123161103.7bb083f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119083024.119566-2-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
        <20201119083024.119566-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 09:30:15 +0100 Bj=C3=B6rn T=C3=B6pel wrote:
> @@ -105,7 +105,8 @@ static inline void sk_busy_loop(struct sock *sk, int =
nonblock)
>  	unsigned int napi_id =3D READ_ONCE(sk->sk_napi_id);
> =20
>  	if (napi_id >=3D MIN_NAPI_ID)
> -		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
> +		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
> +			       READ_ONCE(sk->sk_prefer_busy_poll));

Perhaps a noob question, but aren't all accesses to the new sk members
under the socket lock? Do we really need the READ_ONCE() / WRITE_ONCE()?
