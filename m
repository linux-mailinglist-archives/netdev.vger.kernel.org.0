Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308B559BCBD
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbiHVJWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiHVJWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:22:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6430531EFB
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 02:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661160103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ixrzf48o81ZG4Mo8flPV032r4wlVh+vKK+0eiWqJd9A=;
        b=K5uOjFTzA1X7u29LTvZDKkWSjiAAPn+I97vE3156Ic4oo2b8uea4jmmb3hs2UNSAWY5dhb
        m5qmaq9azk0hGw2saS+l0uHBhDS2n0cg30GQah+qIxJ+Z0sNDJVsqHJDmrEWjJbmrr6DVx
        m96YCY8lIfvX3VrMY/COAwB64+sF6SU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-X6vpEYv1Mlq9hFQ5ng612w-1; Mon, 22 Aug 2022 05:21:36 -0400
X-MC-Unique: X6vpEYv1Mlq9hFQ5ng612w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6DF5299E746;
        Mon, 22 Aug 2022 09:21:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D640DC15BBD;
        Mon, 22 Aug 2022 09:21:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <924818.1661158094@warthog.procyon.org.uk>
References: <924818.1661158094@warthog.procyon.org.uk> <20220821125751.4185-1-yin31149@gmail.com> <000000000000ce327f05d537ebf7@google.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     dhowells@redhat.com,
        syzbot+7f0483225d0c94cb3441@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        paskripkin@gmail.com, skhan@linuxfoundation.org,
        18801353760@163.com
Subject: Re: [PATCH] rxrpc: fix bad unlock balance in rxrpc_do_sendmsg
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <992102.1661160093.1@warthog.procyon.org.uk>
Date:   Mon, 22 Aug 2022 10:21:33 +0100
Message-ID: <992103.1661160093@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, there's another bug here too: if rxrpc_wait_for_tx_window() drops
the call mutex then it needs to reload the pending packet state in
rxrpc_send_data() as it may have raced with another sendmsg().

David

