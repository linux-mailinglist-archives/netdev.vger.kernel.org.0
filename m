Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E36DA216
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbfJPXYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:24:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfJPXYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 19:24:38 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 685F28535C;
        Wed, 16 Oct 2019 23:24:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-121-84.rdu2.redhat.com [10.10.121.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F62210013A1;
        Wed, 16 Oct 2019 23:24:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20191014130438.163688-1-edumazet@google.com>
References: <20191014130438.163688-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     dhowells@redhat.com, "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net] rxrpc: use rcu protection while reading sk->sk_user_data
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8141.1571268276.1@warthog.procyon.org.uk>
Date:   Thu, 17 Oct 2019 00:24:36 +0100
Message-ID: <8142.1571268276@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 16 Oct 2019 23:24:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:

> We need to extend the rcu_read_lock() section in rxrpc_error_report()
> and use rcu_dereference_sk_user_data() instead of plain access
> to sk->sk_user_data to make sure all rules are respected.

Should I take it that the caller won't be guaranteed to be holding the RCU
read lock?

Looking at __udp4_lib_err(), that calls __udp4_lib_err_encap(), which calls
__udp4_lib_err_encap_no_sk(), which should throw a warning if the RCU read
lock is not held.

Similarly, icmp_socket_deliver() and icmpv6_notify() should also throw a
warning before calling ->err_handler().

Does that mean something further up the CPU stack is going to be holding the
RCU read lock?

David
