Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89B8D70E8
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 10:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbfJOIY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 04:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfJOIY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 04:24:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32EDB4E4E6;
        Tue, 15 Oct 2019 08:24:27 +0000 (UTC)
Received: from bistromath.localdomain (unknown [10.36.118.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9D9D19C58;
        Tue, 15 Oct 2019 08:24:25 +0000 (UTC)
Date:   Tue, 15 Oct 2019 10:24:24 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        steffen.klassert@secunet.com
Subject: Re: [PATCH net-next v4 0/6] ipsec: add TCP encapsulation support
 (RFC 8229)
Message-ID: <20191015082424.GA435630@bistromath.localdomain>
References: <cover.1570787286.git.sd@queasysnail.net>
 <20191014.144327.888902765137276425.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191014.144327.888902765137276425.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 15 Oct 2019 08:24:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-10-14, 14:43:27 -0400, David Miller wrote:
> From: Sabrina Dubroca <sd@queasysnail.net>
> Date: Fri, 11 Oct 2019 16:57:23 +0200
> 
> > This patchset introduces support for TCP encapsulation of IKE and ESP
> > messages, as defined by RFC 8229 [0]. It is an evolution of what
> > Herbert Xu proposed in January 2018 [1] that addresses the main
> > criticism against it, by not interfering with the TCP implementation
> > at all. The networking stack now has infrastructure for this: TCP ULPs
> > and Stream Parsers.
> 
> So this will bring up a re-occurring nightmare in that now we have another
> situation where stacking ULPs would be necessary (kTLS over TCP encap) and
> the ULP mechanism simply can't do this.
> 
> Last time this came up, it had to do with sock_map.  No way could be found
> to stack ULPs properly, so instead sock_map was implemented via something
> other than ULPs.
> 
> I fear we have the same situation here again and this issue must be
> addressed before these patches are included.
> 
> Thanks.

I don't think there's any problem here. We're not stacking ULPs on the
same socket. There's a TCP encap socket for IPsec, which belongs to
the IKE daemon. The traffic on that socket is composed of IKE messages
and ESP packets. Then there's whatever userspace sockets (doesn't have
to be TCP), and the whole IPsec and TCP encap is completely invisible
to them.

Where we would probably need ULP stacking is if we implement ESP over
TLS [1], but we're not there.

[1] https://tools.ietf.org/html/rfc8229#appendix-A

-- 
Sabrina
