Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A91A4807
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 09:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbfIAHLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 03:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbfIAHLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 03:11:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABFFB189DAD1;
        Sun,  1 Sep 2019 07:11:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8640E5D9D6;
        Sun,  1 Sep 2019 07:11:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190901065603.432-1-hdanton@sina.com>
References: <20190901065603.432-1-hdanton@sina.com> <156708405310.26102.7954021163316252673.stgit@warthog.procyon.org.uk>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 7/7] rxrpc: Use skb_unshare() rather than skb_cow_data()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14326.1567321898.1@warthog.procyon.org.uk>
Date:   Sun, 01 Sep 2019 08:11:38 +0100
Message-ID: <14327.1567321898@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Sun, 01 Sep 2019 07:11:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> > +		/* Unshare the packet so that it can be modified for in-place
> > +		 * decryption.
> > +		 */
> > +		if (sp->hdr.securityIndex != 0) {
> > +			struct sk_buff *nskb = skb_unshare(skb, GFP_ATOMIC);
> > +			if (!nskb) {
> > +				rxrpc_eaten_skb(skb, rxrpc_skb_unshared_nomem);
> > +				goto out;
> > +			}
> > +
> > +			if (nskb != skb) {
> > +				rxrpc_eaten_skb(skb, rxrpc_skb_received);
> > +				rxrpc_new_skb(skb, rxrpc_skb_unshared);
> > +				skb = nskb;
> > +				sp = rxrpc_skb(skb);
> > +			}
> > +		}
> 
> Unsharing skb makes it perilous to take a peep at it afterwards.

Ah, good point.  rxrpc_new_skb() should be after the assignment.

David
