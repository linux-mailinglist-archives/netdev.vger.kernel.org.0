Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3345B2F5253
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbhAMSi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 13:38:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728308AbhAMSi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 13:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610563051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JYLa2cOxqmc+CvxuI8h3Yk6+SIJRgLOEwT+NkOwhWow=;
        b=M7Zoa1TS38sD1ljldzmmnREK1DB6JpY2tn7+YSlFAnnUpHnUW2l5oPDN5r+vnbIVhHzOYl
        M1hY3rGYEHXlNyNajeQZwJ3EJ13/vEYmLH+wwdFtOHW5QvqXsKAzHgfYe0AefpznSl9BNd
        GTv6EA6SL/AmZ90yqquVWCimHxxiyl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-rBzvAVxYO7q4tdJY0Df7tw-1; Wed, 13 Jan 2021 13:37:27 -0500
X-MC-Unique: rBzvAVxYO7q4tdJY0Df7tw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF673180E460;
        Wed, 13 Jan 2021 18:37:23 +0000 (UTC)
Received: from ovpn-115-228.ams2.redhat.com (ovpn-115-228.ams2.redhat.com [10.36.115.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01AA319C47;
        Wed, 13 Jan 2021 18:37:19 +0000 (UTC)
Message-ID: <532f2d63cc7b842f6d75a22da277c2a841dcb40e.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] udp: allow forwarding of plain
 (non-fraglisted) UDP GRO packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 13 Jan 2021 19:37:18 +0100
In-Reply-To: <20210113103232.4761-1-alobakin@pm.me>
References: <20210113103232.4761-1-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-13 at 10:32 +0000, Alexander Lobakin wrote:
> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
> not only added a support for fraglisted UDP GRO, but also tweaked
> some logics the way that non-fraglisted UDP GRO started to work for
> forwarding too.
> Commit 2e4ef10f5850 ("net: add GSO UDP L4 and GSO fraglists to the
> list of software-backed types") added GSO UDP L4 to the list of
> software GSO to allow virtual netdevs to forward them as is up to
> the real drivers.
> 
> Tests showed that currently forwarding and NATing of plain UDP GRO
> packets are performed fully correctly, regardless if the target
> netdevice has a support for hardware/driver GSO UDP L4 or not.
> Add the last element and allow to form plain UDP GRO packets if
> there is no socket -> we are on forwarding path.

If I read correctly, the above will make UDP GRO in the forwarding path
always enabled (admin can't disable that, if forwarding is enabled).

UDP GRO can introduce measurable latency for UDP packets staging in the
napi GRO hash (no push flag for UDP ;).

Currently the admin (for fraglist) or the application (for socket-based 
"plain" GRO) have to explicitly enable the feature, but this change
will impact every user.

I think we need at lest an explict switch for this.

Cheers,

Paolo

