Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED521F15E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgGNMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:33:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728234AbgGNMdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:33:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594730021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hVuma+JPIoLnapy66Rbpl/t5NgBrYDN1+XEs7dIDswQ=;
        b=HVZKtcrVig211j9sfXq1rQf2tEGMQ9UMo6ZvrZ2/q9QvVG69Fh2oX0d2VN7H++Rl6M9pAi
        /GllVCzq7a5+RP98AeS7J6aJ0RLDTxlfKlzwkaCo3iSK7rTRems1VSDvjMFjVCKiO2n7AZ
        VR2BWCqT5meb0WSrs7CMK2rlaUE8Lhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-Czr79G4mPKq379H48SbUzQ-1; Tue, 14 Jul 2020 08:33:34 -0400
X-MC-Unique: Czr79G4mPKq379H48SbUzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67FDE10059C9;
        Tue, 14 Jul 2020 12:33:33 +0000 (UTC)
Received: from localhost (unknown [10.36.110.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1976F61476;
        Tue, 14 Jul 2020 12:33:30 +0000 (UTC)
Date:   Tue, 14 Jul 2020 14:33:27 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200714143327.2d5b8581@redhat.com>
In-Reply-To: <20200713140219.GM32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
        <20200712200705.9796-2-fw@strlen.de>
        <20200713003813.01f2d5d3@elisabeth>
        <20200713080413.GL32005@breakpoint.cc>
        <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
        <20200713140219.GM32005@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 16:02:19 +0200
Florian Westphal <fw@strlen.de> wrote:

> AFAICS everyhing functions as designed, except:
> 1. The route exception should not exist in first place in this case
> 2. The route exception never times out (gets refreshed every time
>    tunnel tries to send a mtu-sized packet).
> 3. The original sender never learns about the pmtu event
> 
> Regarding 3) I had cooked up patches to inject a new ICMP error
> into the bridge input path from vxlan_err_lookup() to let the sender
> know the path MTU reduction.
> 
> Unfortunately it only works with Linux bridge (openvswitch tosses the
> packet).  Also, too many (internal) reviews told me they consider this
> an ugly hack, so I am not too keen on continuing down that route:
> 
> https://git.breakpoint.cc/cgit/fw/net-next.git/commit/?h=udp_tun_pmtud_12&id=ca5b0af203b6f8010f1e585850620db4561baae7

To be honest, after considering other solutions, yours suddenly appears
to be a lot less ugly. :) Well, I don't think that abusing the "lookup"
functions to do something completely different is a good idea, but that
would be a minor change to do it in another place).

I would still like the idea I proposed better (updating MTUs down the
chain), it's simpler and we don't have to duplicate existing
functionality (generating additional ICMP messages). We could also
decide to skip decreases of MTU on the bridge if the user ever set a
value manually (keeping that existing mechanism as it is).

Both should cover cases with a regular bridge. However, it's still not
clear to me what either solution covers in terms of Open vSwitch. I
think it would be interesting to know before proceeding further.

-- 
Stefano

