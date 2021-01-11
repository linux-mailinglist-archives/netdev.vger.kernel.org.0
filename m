Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1696B2F0FE5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 11:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbhAKKQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:16:51 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:11682 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729068AbhAKKQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:16:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1610360211; x=1641896211;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=9LgLPiA7E4OKb6fUglyLH8zzNFflSvtRwTymsavl7R0=;
  b=TdeU3bFJEG7Imhh81eqH7C0zhg9qahKx6zSk1evmS81RIImpHuKz3fo+
   Es1R3KkX4FMoqJ4+jHDhfw9qU8YCg1i7k1eduej67F2/LH1aSYEYbd6iF
   i75jwE2SIvBJ+r80YtuIbo+nbdPGGKnVgzDdm+3VCxnn0zRMRwT9tVa6t
   k=;
X-IronPort-AV: E=Sophos;i="5.79,338,1602547200"; 
   d="scan'208";a="74053483"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 11 Jan 2021 10:15:57 +0000
Received: from EX13D28EUC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 812A33226DA;
        Mon, 11 Jan 2021 10:15:54 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.94) by
 EX13D28EUC002.ant.amazon.com (10.43.164.254) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 11 Jan 2021 10:15:50 +0000
References: <20210109024950.4043819-1-charlie@charlie.bz>
 <20210109024950.4043819-3-charlie@charlie.bz>
 <pj41zlpn2cpukf.fsf@u68c7b5b1d2d758.ant.amazon.com>
 <74a67121-99f6-4321-a54d-888ddf14ae2f@www.fastmail.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Charlie Somerville <charlie@charlie.bz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] virtio_net: Implement XDP_FLAGS_NO_TX support
In-Reply-To: <74a67121-99f6-4321-a54d-888ddf14ae2f@www.fastmail.com>
Date:   Mon, 11 Jan 2021 12:15:29 +0200
Message-ID: <pj41zllfczpyny.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D01UWB002.ant.amazon.com (10.43.161.136) To
 EX13D28EUC002.ant.amazon.com (10.43.164.254)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Charlie Somerville <charlie@charlie.bz> writes:

> On Mon, Jan 11, 2021, at 04:31, Shay Agroskin wrote:
>
>> Is this addition needed ? Seems like we don't set VIRTIO_XDP_TX 
>> bit in case of virtnet_xdp_xmit() failure, so the surrounding 
>> 'if' 
>> won't be taken.
>
> Good catch, it looks like you're right. I'm happy to remove that 
> extra branch although I would like to add a comment explaining 
> that assumption:
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ed08998765e0..3ae7cd2f1e72 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1472,8 +1472,10 @@ static int virtnet_poll(struct 
> napi_struct *napi, int budget)
>                 xdp_do_flush();
>
>         if (xdp_xmit & VIRTIO_XDP_TX) {
> +               /* VIRTIO_XDP_TX only set on successful 
> virtnet_xdp_xmit,
> +                * implies sq != NULL */
>                 sq = virtnet_xdp_sq(vi);
> -               if (sq && virtqueue_kick_prepare(sq->vq) && 
> virtqueue_notify(sq->vq)) {
> +               if (virtqueue_kick_prepare(sq->vq) && 
> virtqueue_notify(sq->vq)) {
>                         u64_stats_update_begin(&sq->stats.syncp);
>                         sq->stats.kicks++;
>                         u64_stats_update_end(&sq->stats.syncp);

The comment itself looks good. Note that the code style dictates 
that multi-line comments should end up with a line containing '*/' 
alone.
See 
https://www.kernel.org/doc/html/v4.10/process/coding-style.html#commenting 
for more information

Also you'd probably need to send a new email containing the new 
patchset (see V# tag on emails in the mailing list)

Shay
