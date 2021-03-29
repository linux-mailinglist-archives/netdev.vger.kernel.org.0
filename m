Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192B34D30C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhC2PAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:00:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhC2PAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617030018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EESeojbqeVR2ASo5IFJfG55+A5xo+WiBGyPWEwtfTjg=;
        b=aQJrVY/pmnJ6VESc9eibgXVV/g2HPOWQts5hS2kYEGoSLQJMANGQ/JPznT4tmEuLkajM1j
        GBf7u/Clv4VW/ABfSeD+9HMlRexkRRQaDRm3VVuGqzFQOgHNUTTfUDJCNDzD+NNKNxPU4T
        QWgkRvDrw8+NuC+fnsbv0zUMActS08A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-EUzCiIqKNOOzPxdGbMNTjg-1; Mon, 29 Mar 2021 11:00:15 -0400
X-MC-Unique: EUzCiIqKNOOzPxdGbMNTjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DCEE18C8C06;
        Mon, 29 Mar 2021 15:00:13 +0000 (UTC)
Received: from ovpn-114-151.ams2.redhat.com (ovpn-114-151.ams2.redhat.com [10.36.114.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D01710027A5;
        Mon, 29 Mar 2021 15:00:10 +0000 (UTC)
Message-ID: <c296fa344bacdcd23049516e8404931abc70b793.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/8] udp: fixup csum for GSO receive slow
 path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 29 Mar 2021 17:00:09 +0200
In-Reply-To: <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com>
References: <cover.1616692794.git.pabeni@redhat.com>
         <28d04433c648ea8143c199459bfe60650b1a0d28.1616692794.git.pabeni@redhat.com>
         <CA+FuTSed_T6+QbdgEUCo2Qy39mH1AVRoPqFYvt_vkRiFxfW7ZA@mail.gmail.com>
         <c7ee2326473578aa1600bf7c062f37c01e95550a.camel@redhat.com>
         <CA+FuTSfMgXog6AMhNg8H5mBTKTXYMhUG8_KvcKNYF5VS+hiroQ@mail.gmail.com>
         <1a33dd110b4b43a7d65ce55e13bff4a69b89996c.camel@redhat.com>
         <CA+FuTSduw1eK+CuEgzzwA+6QS=QhMhFQpgyVGH2F8aNH5gwv5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-29 at 09:52 -0400, Willem de Bruijn wrote:
> > > That breaks the checksum-and-copy optimization when delivering to
> > > local sockets. I wonder if that is a regression.
> > 
> > The conversion to CHECKSUM_UNNECESSARY happens since
> > commit 573e8fca255a27e3573b51f9b183d62641c47a3d.
> > 
> > Even the conversion to CHECKSUM_PARTIAL happens independently from this
> > series, since commit 6f1c0ea133a6e4a193a7b285efe209664caeea43.
> > 
> > I don't see a regression here ?!?
> 
> I mean that UDP packets with local destination socket and no tunnels
> that arrive with CHECKSUM_NONE normally benefit from the
> checksum-and-copy optimization in recvmsg() when copying to user.
> 
> If those packets are now checksummed during GRO, that voids that
> optimization, and the packet payload is now touched twice.

The 'now' part confuses me. Nothing in this patch or this series
changes the processing of CHECKSUM_NONE UDP packets with no tunnel.

I do see checksum validation in the GRO engine for CHECKSUM_NONE UDP
packet prior to this series.

I *think* the checksum-and-copy optimization is lost
since 573e8fca255a27e3573b51f9b183d62641c47a3d.

Regards,

Paolo

