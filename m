Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9779063E43F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiK3XGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 18:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK3XG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:06:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D29950E5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 15:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669849529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=chCgMEOdPcT2pjDuX1oaF0+9J3jNNFoDJQhqkxGPISA=;
        b=h7hHT419mpZn7L0A+INRNceHcGUftkeEvaio0744bs1m0mrnUqi3TjteYJ5L6VvIU5wTl9
        IYxO3CZn/jwJ1sPBZmVkp9DItHKTIP2a81w+7mWYFJmeMLWKSwQw1Oaj2bfL3siKmSgizE
        v1+PasCE9ZP/Jxb5/b0v8DJZjenhsHs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-hLY3PVO3Mv259JTv7fsqyw-1; Wed, 30 Nov 2022 18:05:27 -0500
X-MC-Unique: hLY3PVO3Mv259JTv7fsqyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E622E2999B58;
        Wed, 30 Nov 2022 23:05:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56C42C15BB4;
        Wed, 30 Nov 2022 23:05:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAEXW_YSd3dyxHxnU1EuER+xyBGGatONzPovphFX5K9seSbkdkg@mail.gmail.com>
References: <CAEXW_YSd3dyxHxnU1EuER+xyBGGatONzPovphFX5K9seSbkdkg@mail.gmail.com> <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1> <20221130181325.1012760-14-paulmck@kernel.org> <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com> <639433.1669835344@warthog.procyon.org.uk>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     dhowells@redhat.com, "Paul E. McKenney" <paulmck@kernel.org>,
        rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, rostedt@goodmis.org,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of call_rcu()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <658623.1669849522.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 30 Nov 2022 23:05:22 +0000
Message-ID: <658624.1669849522@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joel Fernandes <joel@joelfernandes.org> wrote:

> > Note that this conflicts with my patch:
> >
> >         rxrpc: Don't hold a ref for connection workqueue
> >         https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux=
-fs.git/commit/?h=3Drxrpc-next&id=3D450b00011290660127c2d76f5c5ed264126eb2=
29
> >
> > which should render it unnecessary.  It's a little ahead of yours in t=
he
> > net-next queue, if that means anything.
> =

> Could you clarify why it is unnecessary?

Rather than tearing down parts of the connection it only logs a trace line=
,
frees the memory and decrements the counter on the namespace.  This it use=
d to
account that all the pieces of memory allocated in that namespace are gone
before the namespace is removed to check for leaks.  The RCU cleanup used =
to
use some other stuff (such as the peer hash) in the rxrpc_net struct but n=
o
longer will after the patches I submitted.

> After your patch, you are still doing a wake up in your call_rcu() callb=
ack:
>
> - ASSERTCMP(refcount_read(&conn->ref), =3D=3D, 0);
> + if (atomic_dec_and_test(&rxnet->nr_conns))
> +    wake_up_var(&rxnet->nr_conns);
> +}
> =

> Are you saying the code can now tolerate delays? What if the RCU
> callback is invoked after arbitrarily long delays making the sleeping
> process to wait?

True.  But that now only holds up the destruction of a net namespace and t=
he
removal of the rxrpc module.

> If you agree, you can convert the call_rcu() to call_rcu_hurry() in
> your patch itself. Would you be willing to do that? If not, that's
> totally OK and I can send a patch later once yours is in (after
> further testing).

I can add it to part 4 (see my rxrpc-ringless-5 branch) if it is necessary=
.

David

