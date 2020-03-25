Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F365192D9F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgCYQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:00:11 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54450 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727538AbgCYQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:00:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585152010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jx3fIM00QqkeK8qc5H/T95S4XN7fh+fI9pSZ3ndg7X0=;
        b=B2/uL6C6xcFs9umLEIPc6gDTFKpN8FV4jeUy2YaVIJOnCxnAXEn//j430S+iGG44Fg3r31
        2Nozte3RHx5md9xdzVVPOnFGardW5Gdb8cCV5JAECT3ymB9yHl+iFfiZOU3xKi1q4Bf7lT
        IW76CtB4kVp/w6p5JezWgevNyl05XOo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-_DexzrpoNwewXgEa8Hgn2w-1; Wed, 25 Mar 2020 12:00:06 -0400
X-MC-Unique: _DexzrpoNwewXgEa8Hgn2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 413AD800EBD;
        Wed, 25 Mar 2020 16:00:05 +0000 (UTC)
Received: from ovpn-114-87.ams2.redhat.com (ovpn-114-87.ams2.redhat.com [10.36.114.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B080953AC;
        Wed, 25 Mar 2020 16:00:03 +0000 (UTC)
Message-ID: <2b5f096a143f4dea9c9a2896913d8ca79688b00f.camel@redhat.com>
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 25 Mar 2020 17:00:02 +0100
In-Reply-To: <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
References: <20200325022321.21944-1-edumazet@google.com>
         <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
         <CA+FuTSdO_WBhrRj5PNdXppywDNkMKJ4hLry+3oSvy8mavnxw0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-25 at 10:55 -0400, Willem de Bruijn wrote:
> On the UDP front this reminded me of another indirect function call
> without indirect call wrapper: getfrag in __ip_append_data.
> 
> That is called for each datagram once per linear + once per page. That
> said, the noise in my quick RR test was too great to measure any
> benefit from the following. 

Why an RR test ?

I think you should be able to measure some raw tput improvement with
large UDP GSO write towards a blackhole dst/or dropping ingress pkts
with XDP (just to be sure the bottle-neck is on the sender side).

> Paolo, did you happen to also look at that
> when introducing the indirect callers? Seems like it won't hurt to
> add.

Nope, sorry I haven't experimented that.

For the record, I have 2 others item on my list, I hope to have time to
process some day: the ingress dst->input and the default ->enqueue  and
->dequeue

Cheers,

Paolo

p.s. feel free to move this on a different thread, as it fit you better

