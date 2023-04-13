Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED16E1601
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjDMUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDMUkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244187EE4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681418373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Quj1iiD9LgkSGI0NKmJzsno1BF3Rj6KCB6GiyGlg2P0=;
        b=d5S895mS0A0Gvjey/xAMxeGIKX1sDhiBQufWBja1lkQTPuV7V5ShIm+iN9T9Kqvvxx7GhZ
        ZcmsJrdz/akQr9/rYyUker9WIxIr+YH/OoE8aO2dZzwhFIi19cAM5jPl1HydwRaZHpLMdE
        3qG2aVU2nwW/ObI38FJEFRhHWv7It4o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-U6VXJyF_P7SHq6_28nlFzw-1; Thu, 13 Apr 2023 16:39:27 -0400
X-MC-Unique: U6VXJyF_P7SHq6_28nlFzw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA11C2814255;
        Thu, 13 Apr 2023 20:39:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CA6340C6E70;
        Thu, 13 Apr 2023 20:39:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230413042917.GA3390869@ZenIV>
References: <20230413042917.GA3390869@ZenIV> <20230411160902.4134381-1-dhowells@redhat.com> <20230411160902.4134381-2-dhowells@redhat.com> <20230413005129.GZ3390869@ZenIV>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next v6 01/18] net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1147765.1681418362.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 13 Apr 2023 21:39:22 +0100
Message-ID: <1147766.1681418362@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> wrote:

> Note that io_sendmsg_prep() handles both IORING_OP_SENDMSG and IORING_OP=
_SEND,
> so this pair of functions can hit the same request.  And sqe->msg_flags =
is
> not sanitized at all - it comes straight from user buffer.

Assuming ____sys_sendmsg() is fixed, I think it should be sufficient to ma=
ke
io_send() and io_send_zc().  io_sendmsg() and io_sendmsg_zc() will go thro=
ugh
____sys_sendmsg().

David

