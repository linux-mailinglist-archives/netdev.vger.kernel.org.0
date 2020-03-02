Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2213C17522E
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCBDca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:32:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726720AbgCBDca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:32:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583119948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPnoLn7oNLHxpAtuvC2TGo+vHXwJkZ2iH5Hfd7MQWmc=;
        b=Gs6lWsd3qJae3OXUHUvw6+d9DvapaINqzhFHAAQw+ooz9IAdaRlclveDM5qXc6YIP+vBQi
        MLbyCKjZURb6qupa6n7V4yY/oVy83c3ZDDPtUeP7KsJ/qy+BlssWPLVsm0KaJXuJQ054fr
        FNADXwRykhBT7jKGpjPtPhnubVQX6ak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-NKXUG6BGOQSteTbmYaMLGA-1; Sun, 01 Mar 2020 22:32:25 -0500
X-MC-Unique: NKXUG6BGOQSteTbmYaMLGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10189107ACCD;
        Mon,  2 Mar 2020 03:32:23 +0000 (UTC)
Received: from [10.72.13.131] (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6776D90CFC;
        Mon,  2 Mar 2020 03:32:09 +0000 (UTC)
Subject: Re: [PATCH RFC v4 bpf-next 07/11] tun: set egress XDP program
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-8-dsahern@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <25d0253e-d1b8-ca6c-4e2f-3e5c35d6d661@redhat.com>
Date:   Mon, 2 Mar 2020 11:32:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227032013.12385-8-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/27 =E4=B8=8A=E5=8D=8811:20, David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
>
> This patch adds a way to set tx path XDP program in tun driver
> by handling XDP_SETUP_PROG_EGRESS and XDP_QUERY_PROG_EGRESS in
> ndo_bpf handler.
>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>   drivers/net/tun.c | 34 ++++++++++++++++++++++++++--------
>   1 file changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 7cc5a1acaef2..6aae398b904b 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -239,6 +239,7 @@ struct tun_struct {
>   	u32 rx_batched;
>   	struct tun_pcpu_stats __percpu *pcpu_stats;
>   	struct bpf_prog __rcu *xdp_prog;
> +	struct bpf_prog __rcu *xdp_egress_prog;
>   	struct tun_prog __rcu *steering_prog;
>   	struct tun_prog __rcu *filter_prog;
>   	struct ethtool_link_ksettings link_ksettings;
> @@ -1189,15 +1190,21 @@ tun_net_get_stats64(struct net_device *dev, str=
uct rtnl_link_stats64 *stats)
>   }
>  =20
>   static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> -		       struct netlink_ext_ack *extack)


How about accept a bpf_prog ** here, then there's no need to check=20
egress when deferencing the pointer?


> +		       bool egress, struct netlink_ext_ack *extack)
>   {
>   	struct tun_struct *tun =3D netdev_priv(dev);
>   	struct tun_file *tfile;
>   	struct bpf_prog *old_prog;
>   	int i;
>  =20
> -	old_prog =3D rtnl_dereference(tun->xdp_prog);
> -	rcu_assign_pointer(tun->xdp_prog, prog);
> +	if (egress) {
> +		old_prog =3D rtnl_dereference(tun->xdp_egress_prog);
> +		rcu_assign_pointer(tun->xdp_egress_prog, prog);
> +	} else {
> +		old_prog =3D rtnl_dereference(tun->xdp_prog);
> +		rcu_assign_pointer(tun->xdp_prog, prog);
> +	}
> +
>   	if (old_prog)
>   		bpf_prog_put(old_prog);


Btw, for egress type of XDP there's no need to toggle SOCK_XDP flag=20
which is only needed for RX XDP.

Thanks


>  =20
> @@ -1218,12 +1225,16 @@ static int tun_xdp_set(struct net_device *dev, =
struct bpf_prog *prog,
>   	return 0;
>   }
>  =20
> -static u32 tun_xdp_query(struct net_device *dev)
> +static u32 tun_xdp_query(struct net_device *dev, bool egress)
>   {
>   	struct tun_struct *tun =3D netdev_priv(dev);
>   	const struct bpf_prog *xdp_prog;
>  =20
> -	xdp_prog =3D rtnl_dereference(tun->xdp_prog);
> +	if (egress)
> +		xdp_prog =3D rtnl_dereference(tun->xdp_egress_prog);
> +	else
> +		xdp_prog =3D rtnl_dereference(tun->xdp_prog);
> +
>   	if (xdp_prog)
>   		return xdp_prog->aux->id;
>  =20
> @@ -1234,13 +1245,20 @@ static int tun_xdp(struct net_device *dev, stru=
ct netdev_bpf *xdp)
>   {
>   	switch (xdp->command) {
>   	case XDP_SETUP_PROG:
> -		return tun_xdp_set(dev, xdp->prog, xdp->extack);
> +		return tun_xdp_set(dev, xdp->prog, false, xdp->extack);
> +	case XDP_SETUP_PROG_EGRESS:
> +		return tun_xdp_set(dev, xdp->prog, true, xdp->extack);
>   	case XDP_QUERY_PROG:
> -		xdp->prog_id =3D tun_xdp_query(dev);
> -		return 0;
> +		xdp->prog_id =3D tun_xdp_query(dev, false);
> +		break;
> +	case XDP_QUERY_PROG_EGRESS:
> +		xdp->prog_id =3D tun_xdp_query(dev, true);
> +		break;
>   	default:
>   		return -EINVAL;
>   	}
> +
> +	return 0;
>   }
>  =20
>   static int tun_net_change_carrier(struct net_device *dev, bool new_ca=
rrier)

