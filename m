Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9269154499
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgBFNJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:09:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58711 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727325AbgBFNJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:09:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580994584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZgKjq5f4oMoXVI4WqrUXov10JILu8ei/f35tvvz5Kbg=;
        b=OBfTtH2gFhM7SMCntNjIjXR3uJk9zGymgCAR1P/c0jHT07pcWczFLetH7YWDjnj9nrWB9S
        ae90wV8BEWt0KUMMyVwrBBqOL23jSNE2rD554ni4ufAi/ik//iBTIp48gFczeBuxs9NJGV
        qwUhR0LxrVnUoo/jhHUs2JrkZ4omM7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-qH7P_AwpP2eTBjAnESgrMQ-1; Thu, 06 Feb 2020 08:09:41 -0500
X-MC-Unique: qH7P_AwpP2eTBjAnESgrMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0E51104D419;
        Thu,  6 Feb 2020 13:09:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B996E90536;
        Thu,  6 Feb 2020 13:09:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20200204084005.11320-1-hdanton@sina.com>
References: <20200204084005.11320-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: inconsistent lock state in rxrpc_put_client_conn
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2183051.1580994576.1@warthog.procyon.org.uk>
Date:   Thu, 06 Feb 2020 13:09:36 +0000
Message-ID: <2183052.1580994576@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> Take lock with irq quiesced.

I think that's overkill.  It only needs _bh annotations, not _irqsave/restore
- but even that is probably not the best way.

The best way is to offload the stuff done by rxrpc_rcu_destroy_call() to a
workqueue if called in softirq mode.  I'm not sure whether rcu callbacks are
done in softirq mode - if they are, then it can just call rxrpc_queue_work().

David

