Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F422159BBF6
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiHVItB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiHVIsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:48:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA0DB1CF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661158102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hf0005VbFoqadMHqE2/k8IMSgs4M7ELH98Ps6ciAPSE=;
        b=aSGafKKtp/TJGtA9u8T2qw0XXapOkgE5A5NiEOv2JNBbchzcBEqloyonVdKztHqthDd3rN
        hVA8a72Z5kawKsQb3rpcsVx4u6zL7d9nbS6KeRYeyd9742lBbyROUPAZktNNvk0xCb3fnV
        OIKMh4Ac84Uh2J9r/lEjVJk13ml441g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-Yeqpuf_3Ngep_gSMOePBeA-1; Mon, 22 Aug 2022 04:48:17 -0400
X-MC-Unique: Yeqpuf_3Ngep_gSMOePBeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46FF28037AF;
        Mon, 22 Aug 2022 08:48:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 530E74010D2A;
        Mon, 22 Aug 2022 08:48:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220821125751.4185-1-yin31149@gmail.com>
References: <20220821125751.4185-1-yin31149@gmail.com> <000000000000ce327f05d537ebf7@google.com>
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
Content-ID: <924817.1661158094.1@warthog.procyon.org.uk>
Date:   Mon, 22 Aug 2022 09:48:14 +0100
Message-ID: <924818.1661158094@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hawkins Jiawei <yin31149@gmail.com> wrote:

> -		if (mutex_lock_interruptible(&call->user_mutex) < 0)
> +		if (mutex_lock_interruptible(&call->user_mutex) < 0) {
> +			mutex_lock(&call->user_mutex);

Yeah, as Khalid points out that kind of makes the interruptible lock
pointless.  Either rxrpc_send_data() needs to return a separate indication
that we returned without the lock held or it needs to always drop the lock on
error (at least for ERESTARTSYS/EINTR) which can be checked for higher up.

David

