Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8BB63E06F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiK3TKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiK3TKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:10:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49A654459
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669835355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QVNS4KGKiQlkWq9pmeMaxREOPvT9GqK+wYyEoJX7MI=;
        b=T7ynfhFtqmwsPBLvCaVsABngFOOuHP48IytLsiuy45LchbraWqwMkfKrBGsCEX+I1VrKD+
        EGKZXxFyRnuKVcv+lnXSAnHd6ksV0DUZHM+JccqIN83gwggzkrXdqtk04pkCkwJSzX6nOw
        xaZOtc7I6HP5O0Fjpe2c9QGrZj7lN5U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-bh4-bCdXMWOFNg7UvKspPg-1; Wed, 30 Nov 2022 14:09:09 -0500
X-MC-Unique: bh4-bCdXMWOFNg7UvKspPg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92AD31C0896A;
        Wed, 30 Nov 2022 19:09:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 043FF1121314;
        Wed, 30 Nov 2022 19:09:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
References: <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com> <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1> <20221130181325.1012760-14-paulmck@kernel.org>
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
Content-ID: <639432.1669835344.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 30 Nov 2022 19:09:04 +0000
Message-ID: <639433.1669835344@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note that this conflicts with my patch:

	rxrpc: Don't hold a ref for connection workqueue
	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/com=
mit/?h=3Drxrpc-next&id=3D450b00011290660127c2d76f5c5ed264126eb229

which should render it unnecessary.  It's a little ahead of yours in the
net-next queue, if that means anything.

David

