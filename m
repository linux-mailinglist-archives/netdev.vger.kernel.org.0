Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB76D2592
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjCaQcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbjCaQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BC82658F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680280071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dzj4wq9FaG2NZQlDvyNIG6SZjlNuX69PXAW+edzOmqo=;
        b=ehrq3tuJBAWvtDb0F7anbqvs2HzTMms9GQTEiJJenLsp6NQ32cjuGEux3JckP7n8R403zq
        mGRVXhXVvmGdwFtIsQqeUcNUL1ZvGaor+yEUVJ6bt0JiWVqSthGwfUK4z3lADA7jqF785T
        uC++4cr4H5tr0wZ3zb5Q72lV+zGIZbk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-E3iaPG3wNlaU_2VbzkuVhw-1; Fri, 31 Mar 2023 12:27:48 -0400
X-MC-Unique: E3iaPG3wNlaU_2VbzkuVhw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D2331C0879A;
        Fri, 31 Mar 2023 16:27:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A3E4492C3E;
        Fri, 31 Mar 2023 16:27:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-30-dhowells@redhat.com>
References: <20230331160914.1608208-30-dhowells@redhat.com> <20230331160914.1608208-1-dhowells@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Trivial TLS server
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1610390.1680280064.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 31 Mar 2023 17:27:44 +0100
Message-ID: <1610391.1680280064@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a trivial TLS server that can be used to test this.

David
---
/*
 * TLS-over-TCP sink server
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <linux/tls.h>

#define OSERROR(X, Y) do { if ((long)(X) =3D=3D -1) { perror(Y); exit(1); =
} } while(0)

static unsigned char buffer[512 * 1024] __attribute__((aligned(4096)));

static void set_tls(int sock)
{
	struct tls12_crypto_info_aes_gcm_128 crypto_info;

	crypto_info.info.version =3D TLS_1_2_VERSION;
	crypto_info.info.cipher_type =3D TLS_CIPHER_AES_GCM_128;
	memset(crypto_info.iv,		0, TLS_CIPHER_AES_GCM_128_IV_SIZE);
	memset(crypto_info.rec_seq,	0, TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
	memset(crypto_info.key,		0, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
	memset(crypto_info.salt,	0, TLS_CIPHER_AES_GCM_128_SALT_SIZE);

	OSERROR(setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls")),
		"TCP_ULP");
	OSERROR(setsockopt(sock, SOL_TLS, TLS_TX, &crypto_info, sizeof(crypto_inf=
o)),
		"TLS_TX");
	OSERROR(setsockopt(sock, SOL_TLS, TLS_RX, &crypto_info, sizeof(crypto_inf=
o)),
		"TLS_RX");
}

int main(int argc, char *argv[])
{
	struct sockaddr_in sin =3D { .sin_family =3D AF_INET, .sin_port =3D htons=
(5556) };
	int sfd, afd;

	sfd =3D socket(AF_INET, SOCK_STREAM, 0);
	OSERROR(sfd, "socket");
	OSERROR(bind(sfd, (struct sockaddr *)&sin, sizeof(sin)), "bind");
	OSERROR(listen(sfd, 1), "listen");

	for (;;) {
		afd =3D accept(sfd, NULL, NULL);
		if (afd !=3D -1) {
			set_tls(afd);
			while (read(afd, buffer, sizeof(buffer)) > 0) {}
			close(afd);
		}
	}
}

