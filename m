Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E2D5D0C0
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGBNhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbfGBNhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:37:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 049C1A96F1;
        Tue,  2 Jul 2019 13:37:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-219.rdu2.redhat.com [10.10.120.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6ACB417966;
        Tue,  2 Jul 2019 13:37:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <0000000000004c2416058c594b30@google.com>
References: <0000000000004c2416058c594b30@google.com>
To:     syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>,
        ebiggers@kernel.org
Cc:     dhowells@redhat.com, davem@davemloft.net,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24281.1562074644.1@warthog.procyon.org.uk>
Date:   Tue, 02 Jul 2019 14:37:24 +0100
Message-ID: <24282.1562074644@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 02 Jul 2019 13:37:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com> wrote:

I *think* the reproducer boils down to the attached, but I can't get syzkaller
to work and the attached sample does not cause the oops to occur.  Can you try
it in your environment?

> The bug was bisected to:
> 
> commit 46894a13599a977ac35411b536fb3e0b2feefa95
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Oct 4 08:32:28 2018 +0000
> 
>     rxrpc: Use IPv4 addresses throught the IPv6

This might not be the correct bisection point.  If you look at the attached
sample, you're mixing AF_INET and AF_INET6.  If you try AF_INET throughout,
that might get a different point.  On the other hand, since you've bound the
socket, the AF_INET6 passed to socket() should be ignored.

David
---
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <linux/rxrpc.h>

static const unsigned char inet4_addr[4] = {
	0xe0, 0x00, 0x00, 0x01
};

int main(void)
{
	struct sockaddr_rxrpc srx;
	int fd;

	memset(&srx, 0, sizeof(srx));
	srx.srx_family			= AF_RXRPC;
	srx.srx_service			= 0;
	srx.transport_type		= AF_INET;
	srx.transport_len		= sizeof(srx.transport.sin);
	srx.transport.sin.sin_family	= AF_INET;
	srx.transport.sin.sin_port	= htons(0x4e21);
	memcpy(&srx.transport.sin.sin_addr, inet4_addr, 4);

	fd = socket(AF_RXRPC, SOCK_DGRAM, AF_INET6);
	if (fd == -1) {
		perror("socket");
		exit(1);
	}

	if (bind(fd, (struct sockaddr *)&srx, sizeof(srx)) == -1) {
		perror("bind");
		exit(1);
	}

	sleep(20);

	// Whilst sleeping, hit with:
	// echo -e '\0\0\0\0\0\0\0\0' | ncat -4u --send-only 224.0.0.1 20001
	
	return 0;
}
