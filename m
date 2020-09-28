Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D2527A9E2
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 10:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgI1Ipo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 04:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgI1Ipn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 04:45:43 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601282742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/p+lmIVfxbJUcYSj4nC9UmZQslqUK3jR+nD79F1NfM=;
        b=Saju/COAmcJtGI8H2ahFQoLwhmxzmyJk6+rRT4sV2CrJxPZuKPdi463t7Efzty8+ab+Piy
        2JMgfikY7w2MKdF6rgtnB/uT2oE6A3naUdsFWv59kFomP4WlPJnxw5R4R8/s+Ce5gYH1GI
        3B8RzcYuYaCTMFzILO5GZtteIikKYwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343--tLdz3qgO32GPoQyiYpOiw-1; Mon, 28 Sep 2020 04:45:40 -0400
X-MC-Unique: -tLdz3qgO32GPoQyiYpOiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B99A2801F97;
        Mon, 28 Sep 2020 08:45:38 +0000 (UTC)
Received: from ovpn-115-6.ams2.redhat.com (ovpn-115-6.ams2.redhat.com [10.36.115.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B49678482;
        Mon, 28 Sep 2020 08:45:36 +0000 (UTC)
Message-ID: <f4cb4816d70e480f1b9bc88bfee1ec5d9017d42a.camel@redhat.com>
Subject: Re: [RFC PATCH net-next 1/6] net: implement threaded-able napi poll
 loop support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>
Date:   Mon, 28 Sep 2020 10:45:35 +0200
In-Reply-To: <021e455b-faaf-4044-94bb-30291e1c9ee1@www.fastmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
         <20200914172453.1833883-2-weiwan@google.com>
         <2ab7cdc1-b9e1-48c7-89b2-a10cd5e19545@www.fastmail.com>
         <CAEA6p_DyU7jyHEeRiWFtNZfMPQjJJEV2jN1MV-+5txumC5nmZg@mail.gmail.com>
         <021e455b-faaf-4044-94bb-30291e1c9ee1@www.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2020-09-26 at 16:22 +0200, Hannes Frederic Sowa wrote:
> On Sat, Sep 26, 2020, at 01:50, Wei Wang wrote:
> > I took a look at the current "threadirqs" implementation. From my
> > understanding, the kthread used there is to handle irq from the
> > driver, and needs driver-specific thread_fn to be used. It is not
> > as
> > generic as in the napi layer where a common napi_poll() related
> > function could be used as the thread handler. Or did I
> > misunderstand
> > your point?
> 
> Based on my memories: We had napi_schedule & co being invoked inside
> the threads 

I just looked at the code - I really forgot most details. The above is
correct...

> without touching any driver code when we specified
> threadirqs. But this would need a double check. 

... but still that code needed some per device driver modification: the
irq subsystem handled the switch to/from threaded mode, and needed some
callback, provided from the device driver, to notify the network code
about the change (specifically, to mark the threaded status inside the
relevant napi struct).

Cheers,

Paolo

