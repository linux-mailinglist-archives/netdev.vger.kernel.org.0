Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA7F198A3D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbgCaC7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:59:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:24154 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730279AbgCaC7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585623552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPbiSea3iKmgsPhW5d6VdEOeNmJ89GIMDsuQYNvPcfk=;
        b=Z4R7Th8xzYuwBVNhPCwjK5yzxrDjv7tjy52oSIfbQTfVnnVv4x5qqMvVSxIcJTraxDWS8T
        rCtdkFZUrzyARBPtt4Zz7Hbt01RWmvY68KNEjlwZvKklUqEwJcmhiiHlQdybkXkvQoBCWI
        mt+TaLzaeZcn5dYGx9tfxPabfecjaqA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-wAoZLjByNXaQepDoMefmhw-1; Mon, 30 Mar 2020 22:59:08 -0400
X-MC-Unique: wAoZLjByNXaQepDoMefmhw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72666800D5B;
        Tue, 31 Mar 2020 02:59:06 +0000 (UTC)
Received: from [10.72.12.115] (ovpn-12-115.pek2.redhat.com [10.72.12.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31DCA19C58;
        Tue, 31 Mar 2020 02:59:02 +0000 (UTC)
Subject: Re: [RFC PATCH] tun: Don't put_page() for all negative return values
 from XDP program
To:     Will Deacon <will@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@android.com, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>
References: <20200330161234.12777-1-will@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fd4d792f-32df-953a-a076-c09ed5dea573@redhat.com>
Date:   Tue, 31 Mar 2020 10:59:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200330161234.12777-1-will@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/31 =E4=B8=8A=E5=8D=8812:12, Will Deacon wrote:
> When an XDP program is installed, tun_build_skb() grabs a reference to
> the current page fragment page if the program returns XDP_REDIRECT or
> XDP_TX. However, since tun_xdp_act() passes through negative return
> values from the XDP program, it is possible to trigger the error path b=
y
> mistake and accidentally drop a reference to the fragments page without
> taking one, leading to a spurious free. This is believed to be the caus=
e
> of some KASAN use-after-free reports from syzbot [1], although without =
a
> reproducer it is not possible to confirm whether this patch fixes the
> problem.
>
> Ensure that we only drop a reference to the fragments page if the XDP
> transmit or redirect operations actually fail.
>
> [1] https://syzkaller.appspot.com/bug?id=3De76a6af1be4acd727ff6bbca6698=
33f98cbf5d95


I think the patch fixes the issue reported. Since I can see the warn of=20
bad page state in put_page().


>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jason Wang <jasowang@redhat.com>
> CC: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>
> Sending as RFC because I've not been able to confirm that this fixes an=
ything.
>
>   drivers/net/tun.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 650c937ed56b..9de9b7d8aedd 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1715,8 +1715,12 @@ static struct sk_buff *tun_build_skb(struct tun_=
struct *tun,
>   			alloc_frag->offset +=3D buflen;
>   		}
>   		err =3D tun_xdp_act(tun, xdp_prog, &xdp, act);
> -		if (err < 0)
> -			goto err_xdp;
> +		if (err < 0) {
> +			if (act =3D=3D XDP_REDIRECT || act =3D=3D XDP_TX)
> +				put_page(alloc_frag->page);
> +			goto out;
> +		}
> +
>   		if (err =3D=3D XDP_REDIRECT)
>   			xdp_do_flush();
>   		if (err !=3D XDP_PASS)
> @@ -1730,8 +1734,6 @@ static struct sk_buff *tun_build_skb(struct tun_s=
truct *tun,
>  =20
>   	return __tun_build_skb(tfile, alloc_frag, buf, buflen, len, pad);
>  =20
> -err_xdp:
> -	put_page(alloc_frag->page);
>   out:
>   	rcu_read_unlock();
>   	local_bh_enable();


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


