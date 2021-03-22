Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8CC344BF1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhCVQlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:41:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbhCVQlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:41:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616431295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJs/8i/2hkoGdB658bHnbrqVNm/IrfHamj6wRjahfew=;
        b=RNwQ8BqaSxV/AP1cn09E7o34KOboRI9rMUEV/HZJ9pubWvWHs2c5iF3kqCgp7f2sKLqv0Q
        e07wIs2yyZO0VcWSiN8LqoI+5FS5u8YZ41ImbNc3S7JuSW0YHZH7A4udrtjAjcgdN4XkmQ
        i1QKia71j6sx28fk8f659LPkYzSsvsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-wJ7d-O2dMIe37-v8OfdiSQ-1; Mon, 22 Mar 2021 12:41:31 -0400
X-MC-Unique: wJ7d-O2dMIe37-v8OfdiSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0902B81622;
        Mon, 22 Mar 2021 16:41:30 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5470617D7E;
        Mon, 22 Mar 2021 16:41:28 +0000 (UTC)
Message-ID: <efa5f117ad63064f7984655d46eb5140d23b0585.camel@redhat.com>
Subject: Re: [PATCH net-next 2/8] udp: skip fwd/list GRO for tunnel packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 22 Mar 2021 17:41:27 +0100
In-Reply-To: <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
         <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-22 at 09:24 -0400, Willem de Bruijn wrote:
> On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > If UDP GRO forwarding (or list) is enabled,
> 
> Please explicitly mention the gso type SKB_GSO_FRAGLIST. I, at least,
> didn't immediately grasp that gro forwarding is an alias for that.

I see the commit message was not clear at all, I'm sorry.

The above means:

gso_type & (NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST) 

:)

> > and there are
> > udp tunnel available in the system, we could end-up doing L4
> > aggregation for packets targeting the UDP tunnel.
> 
> Is this specific to UDP tunnels, or can this also occur with others,
> such as GRE? (not implying that this patchset needs to address those
> at the same time)

I did not look at that before your suggestion. Thanks for pointing out.

I think the problem is specific to UDP: when processing the outer UDP
header that is potentially eligible for both NETIF_F_GSO_UDP_L4 and
gro_receive aggregation and that is the root cause of the problem
addressed here.


> > Just skip the fwd GRO if this packet could land in an UDP
> > tunnel.
> 
> Could you make more clear that this does not skip UDP GRO, only
> switches from fraglist-based to pure SKB_GSO_UDP_L4.

Sure, I'll try to rewrite the commit message.

Thanks!

Paolo

