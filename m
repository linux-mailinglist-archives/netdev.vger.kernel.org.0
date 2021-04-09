Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45A735A1DB
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhDIPUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234131AbhDIPUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617981621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/rFstnykHQeNclhdi0h7ql02LzRcMRsUQS50PPEytI=;
        b=isnIfqpss58GzLo4bH4TaTN4lug73RF+CJecVbRlJON/UAhgVn+x33s7TDulBnuTrUgP4I
        XTnHG9HHLkhl6PyGNMsd3vJzReJC0KzCC4Np0dlnLEmSndNaCG30i5KcUfUDoF/JlE6SgM
        skwaTHAEZOwQZKJxb1+dwFukQ7j6T10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-HJQJufhZOtSp3IFW5dsO7w-1; Fri, 09 Apr 2021 11:20:20 -0400
X-MC-Unique: HJQJufhZOtSp3IFW5dsO7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F37A1802B5B;
        Fri,  9 Apr 2021 15:20:18 +0000 (UTC)
Received: from ovpn-115-50.ams2.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CD9360D79;
        Fri,  9 Apr 2021 15:20:13 +0000 (UTC)
Message-ID: <d9b5f599380d32a28026d5a758cc46edf2ba23d8.camel@redhat.com>
Subject: Re: [PATCH net-next 2/4] veth: allow enabling NAPI even without XDP
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Fri, 09 Apr 2021 17:20:12 +0200
In-Reply-To: <87v98vtsgg.fsf@toke.dk>
References: <cover.1617965243.git.pabeni@redhat.com>
         <dbc26ec87852a112126c83ae546f367841ec554d.1617965243.git.pabeni@redhat.com>
         <87v98vtsgg.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-09 at 16:58 +0200, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> 
> > Currently the veth device has the GRO feature bit set, even if
> > no GRO aggregation is possible with the default configuration,
> > as the veth device does not hook into the GRO engine.
> > 
> > Flipping the GRO feature bit from user-space is a no-op, unless
> > XDP is enabled. In such scenario GRO could actually take place, but
> > TSO is forced to off on the peer device.
> > 
> > This change allow user-space to really control the GRO feature, with
> > no need for an XDP program.
> > 
> > The GRO feature bit is now cleared by default - so that there are no
> > user-visible behavior changes with the default configuration.
> > 
> > When the GRO bit is set, the per-queue NAPI instances are initialized
> > and registered. On xmit, when napi instances are available, we try
> > to use them.
> 
> Am I mistaken in thinking that this also makes XDP redirect into a veth
> work without having to load an XDP program on the peer device? That's
> been a long-outstanding thing we've been meaning to fix, so that would
> be awesome! :)

I have not experimented that, and I admit gross ignorance WRT this
argument, but AFAICS the needed bits to get XDP redirect working on
veth are the ptr_ring initialization and the napi instance available.

With this patch both are in place when GRO is enabled, so I guess XPD
redirect should work, too (modulo bugs for untested scenario).

Thanks!

Paolo

