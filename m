Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC93C62D75B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiKQJpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239510AbiKQJpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:45:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5711C1FCF4
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668678272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qPdqiETw6KBVWJ2kQN4t8lwK9egbW/zCGd4bRWajDn4=;
        b=DkF/AG7Xr+nEA+UAILX0/3Rt0mFM+hQqSqshS2R/wnQY79UxunH5vMR4RL8McohOyIID2y
        vK+BYfiRvRFJAMqzZwzwhcbnMfHg0aIZbcGfrc8rZXhRSN2+wFqYbIpIhTYAhQBKi8p2JN
        q9vHXpSsedrTiVwNnZVzosttGCp71Ho=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-WUpux3s7MROl-QecBuA1Cw-1; Thu, 17 Nov 2022 04:44:29 -0500
X-MC-Unique: WUpux3s7MROl-QecBuA1Cw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FD4E3C025C8;
        Thu, 17 Nov 2022 09:44:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7625D1415119;
        Thu, 17 Nov 2022 09:44:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <Y3XmQsOFwTHUBSLU@kili>
References: <Y3XmQsOFwTHUBSLU@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] rxrpc: uninitialized variable in rxrpc_send_ack_packet()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3475094.1668678264.1@warthog.procyon.org.uk>
Date:   Thu, 17 Nov 2022 09:44:24 +0000
Message-ID: <3475095.1668678264@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:

> The "pkt" was supposed to have been deleted in a previous patch.  It
> leads to an uninitialized variable bug.

Weird.  I don't get a compiler warning and the kernel doesn't crash, despite
transmitting millions of acks.

If I disassemble the built code, I see:

   0xffffffff81b09e89 <+723>:   xor    %edi,%edi
   0xffffffff81b09e8b <+725>:   call   0xffffffff811c0bc1 <kfree>

I'm not sure why it's sticking 0 in EDI, though.

David

