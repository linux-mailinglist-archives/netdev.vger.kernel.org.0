Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DCC9AAB6
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 10:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393068AbfHWIwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 04:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729690AbfHWIwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 04:52:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B3CF8980F2;
        Fri, 23 Aug 2019 08:52:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6734117D08;
        Fri, 23 Aug 2019 08:52:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190822.121207.731320146177703787.davem@davemloft.net>
References: <20190822.121207.731320146177703787.davem@davemloft.net> <156647655350.10908.12081183247715153431.stgit@warthog.procyon.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/9] rxrpc: Fix use of skb_cow_data()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27347.1566550348.1@warthog.procyon.org.uk>
Date:   Fri, 23 Aug 2019 09:52:28 +0100
Message-ID: <27348.1566550348@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 23 Aug 2019 08:52:30 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> Why don't you just do an skb_unshare() at the beginning when you know that
> you'll need to do that?

I was trying to defer any copying to process context rather than doing it in
softirq context to spend less time in softirq context - plus that way I can
use GFP_NOIO (kafs) or GFP_KERNEL (direct AF_RXRPC socket) rather than
GFP_ATOMIC if the api supports it.

I don't remember now why I used skb_cow_data() rather than skb_unshare() - but
it was probably because the former leaves the sk_buff object itself intact,
whereas the latter replaces it.  I can switch to using skb_unshare() instead.

Question for you: how likely is a newly received buffer, through a UDP socket,
to be 'cloned'?

David
