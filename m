Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BE336F0B2
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 22:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbhD2TtJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Apr 2021 15:49:09 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:52422 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234613AbhD2TtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 15:49:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-zTDx8Pu5NjSTi2Sze-bisw-1; Thu, 29 Apr 2021 15:48:15 -0400
X-MC-Unique: zTDx8Pu5NjSTi2Sze-bisw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 634D28042B1;
        Thu, 29 Apr 2021 19:48:13 +0000 (UTC)
Received: from hog (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 283145D768;
        Thu, 29 Apr 2021 19:48:10 +0000 (UTC)
Date:   Thu, 29 Apr 2021 21:48:09 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jiri Bohac <jbohac@suse.cz>
Cc:     Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] fix xfrm MTU regression
Message-ID: <YIsNeUTQ7qjzhpos@hog>
References: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20210429170254.5grfgsz2hgy2qjhk@dwarf.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-04-29, 19:02:54 +0200, Jiri Bohac wrote:
> Hi,
> 
> Commit 749439bfac6e1a2932c582e2699f91d329658196 ("ipv6: fix udpv6
> sendmsg crash caused by too small MTU") breaks PMTU for xfrm.
> 
> A Packet Too Big ICMPv6 message received in response to an ESP
> packet will prevent all further communication through the tunnel
> if the reported MTU minus the ESP overhead is smaller than 1280.
> 
> E.g. in a case of a tunnel-mode ESP with sha256/aes the overhead
> is 92 bytes. Receiving a PTB with MTU of 1371 or less will result
> in all further packets in the tunnel dropped. A ping through the
> tunnel fails with "ping: sendmsg: Invalid argument".
> 
> Apparently the MTU on the xfrm route is smaller than 1280 and
> fails the check inside ip6_setup_cork() added by 749439bf.
> 
> We found this by debugging USGv6/ipv6ready failures. Failing
> tests are: "Phase-2 Interoperability Test Scenario IPsec" /
> 5.3.11 and 5.4.11 (Tunnel Mode: Fragmentation).

That should be fixed with commit b515d2637276 ("xfrm: xfrm_state_mtu
should return at least 1280 for ipv6"), currently in Steffen's ipsec
tree:
https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git/commit/?id=b515d2637276

-- 
Sabrina

