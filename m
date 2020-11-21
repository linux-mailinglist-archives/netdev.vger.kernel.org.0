Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7F2BBDE6
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 08:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgKUHvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 02:51:17 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:36807 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgKUHvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 02:51:17 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 76da2853
        for <netdev@vger.kernel.org>;
        Sat, 21 Nov 2020 07:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=+mBar1jqyE81Vzj8AfasNIJe5mI=; b=qZz0S3
        DYtJPI1XQarBXjQt7Hg7IytNWKiSRzSlMRSPm2HC87BWMS9Du+8uapXEEu9rPqAB
        GUBpDkbIKPWilwClPiTpZn9E7gmjO3pvUA+g9grgkhhyQ58YK4SSwwUnLECgT2Re
        ejfTxBNWrrD9fyxic2c6tLDg+5eYZGe73T0ZGKe1ZJI/Ly9P1d6GMcLke4tDbDb3
        f9lqheyx4vjN+VFH6HO0VD8mYpD206y8A7TBduU7/RS8H8ncdufE9HuwYvjgtOgG
        mcDrxMWeDVKlurxOdorZcFyiWaxIyMUtlJNXO+HhTehertH6+It1EZ+wGnEPsqeG
        rS6OSut0e6c0ICdQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aae8203f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 21 Nov 2020 07:46:54 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id w5so10821224ybj.11
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 23:51:14 -0800 (PST)
X-Gm-Message-State: AOAM5321ednX43ryErmG+k51HX7280rWTEuzWnCXkFhVGrP4uSLSLf7v
        PrSs6anyNaO9ixJJuRgC9Z1XuMKG8QT/hM78wk0=
X-Google-Smtp-Source: ABdhPJxr34+gpDKiTkT6R3Pwo/lPuPQoz42hBx+CjVwdYZPn4M/iPdn29TvGkUUWNA6HD85JBmOcccKpMcxWgSWun98=
X-Received: by 2002:a25:6089:: with SMTP id u131mr29513797ybb.456.1605945074009;
 Fri, 20 Nov 2020 23:51:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:474a:b029:2b:bd99:a3dd with HTTP; Fri, 20 Nov 2020
 23:51:13 -0800 (PST)
In-Reply-To: <20201121062817.3178900-1-eyal.birger@gmail.com>
References: <20201121062817.3178900-1-eyal.birger@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 21 Nov 2020 08:51:13 +0100
X-Gmail-Original-Message-ID: <CAHmME9rYRrWOs247vFJX-MAY+Zn3yUudOxVhqL13mWp8E+i0-A@mail.gmail.com>
Message-ID: <CAHmME9rYRrWOs247vFJX-MAY+Zn3yUudOxVhqL13mWp8E+i0-A@mail.gmail.com>
Subject: Re: [net,v2] net/packet: fix packet receive on L3 devices without
 visible hard header
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, xie.he.0141@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/20, Eyal Birger <eyal.birger@gmail.com> wrote:
> In the patchset merged by commit b9fcf0a0d826
> ("Merge branch 'support-AF_PACKET-for-layer-3-devices'") L3 devices which
> did not have header_ops were given one for the purpose of protocol parsing
> on af_packet transmit path.
>
> That change made af_packet receive path regard these devices as having a
> visible L3 header and therefore aligned incoming skb->data to point to the
> skb's mac_header. Some devices, such as ipip, xfrmi, and others, do not
> reset their mac_header prior to ingress and therefore their incoming
> packets became malformed.
>
> Ideally these devices would reset their mac headers, or af_packet would be
> able to rely on dev->hard_header_len being 0 for such cases, but it seems
> this is not the case.
>
> Fix by changing af_packet RX ll visibility criteria to include the
> existence of a '.create()' header operation, which is used when creating
> a device hard header - via dev_hard_header() - by upper layers, and does
> not exist in these L3 devices.
>
> As this predicate may be useful in other situations, add it as a common
> dev_has_header() helper in netdevice.h.
>
> Fixes: b9fcf0a0d826 ("Merge branch
> 'support-AF_PACKET-for-layer-3-devices'")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>
> ---
>
> v2:
>   - add common dev_has_header() helper as suggested by Willem de Bruijn
> ---
>  include/linux/netdevice.h |  5 +++++
>  net/packet/af_packet.c    | 18 +++++++++---------
>  2 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 964b494b0e8d..fa275a054f46 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3137,6 +3137,11 @@ static inline bool dev_validate_header(const struct
> net_device *dev,
>  	return false;
>  }
>
> +static inline bool dev_has_header(const struct net_device *dev)
> +{
> +	return dev->header_ops && dev->header_ops->create;
> +}
> +
>  typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr,
>  			   int len, int size);
>  int register_gifconf(unsigned int family, gifconf_func_t *gifconf);
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index cefbd50c1090..7a18ffff8551 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -93,8 +93,8 @@
>
>  /*
>     Assumptions:
> -   - If the device has no dev->header_ops, there is no LL header visible
> -     above the device. In this case, its hard_header_len should be 0.
> +   - If the device has no dev->header_ops->create, there is no LL header
> +     visible above the device. In this case, its hard_header_len should be
> 0.
>       The device may prepend its own header internally. In this case, its
>       needed_headroom should be set to the space needed for it to add its
>       internal header.
> @@ -108,26 +108,26 @@
>  On receive:
>  -----------
>
> -Incoming, dev->header_ops != NULL
> +Incoming, dev_has_header(dev) == true
>     mac_header -> ll header
>     data       -> data
>
> -Outgoing, dev->header_ops != NULL
> +Outgoing, dev_has_header(dev) == true
>     mac_header -> ll header
>     data       -> ll header
>
> -Incoming, dev->header_ops == NULL
> +Incoming, dev_has_header(dev) == false
>     mac_header -> data
>       However drivers often make it point to the ll header.
>       This is incorrect because the ll header should be invisible to us.
>     data       -> data
>
> -Outgoing, dev->header_ops == NULL
> +Outgoing, dev_has_header(dev) == false
>     mac_header -> data. ll header is invisible to us.
>     data       -> data
>
>  Resume
> -  If dev->header_ops == NULL we are unable to restore the ll header,
> +  If dev_has_header(dev) == false we are unable to restore the ll header,
>      because it is invisible to us.
>
>
> @@ -2069,7 +2069,7 @@ static int packet_rcv(struct sk_buff *skb, struct
> net_device *dev,
>
>  	skb->dev = dev;
>
> -	if (dev->header_ops) {
> +	if (dev_has_header(dev)) {
>  		/* The device has an explicit notion of ll header,
>  		 * exported to higher levels.
>  		 *
> @@ -2198,7 +2198,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct
> net_device *dev,
>  	if (!net_eq(dev_net(dev), sock_net(sk)))
>  		goto drop;
>
> -	if (dev->header_ops) {
> +	if (dev_has_header(dev)) {
>  		if (sk->sk_type != SOCK_DGRAM)
>  			skb_push(skb, skb->data - skb_mac_header(skb));
>  		else if (skb->pkt_type == PACKET_OUTGOING) {

Thanks for fixing this. Patch seems correct to me.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
