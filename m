Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B66D25A0
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjCaQdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjCaQdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF39236B9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680280142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZSAJKtt/ag5B+38eGABocjAtCkqVzXfR0mPd/YeFX8=;
        b=XcChonvQpQK/EqVoWs2aayqvD7vgO4nDFT2PUgWANhaK0DruarDiOEi0qKsRoEBDehiZ1U
        pKphT4LbOFJ1Ku/IiLlOUssKPJ3hpZ+xyILAUpug3sre0DxfrGcPzjK1FUU/wp4amg8Amx
        VcJHqnjVc78OgY0svdNoajzG2dFgPag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-FhZ9Z2msPdG2BL3PnIP12g-1; Fri, 31 Mar 2023 12:28:59 -0400
X-MC-Unique: FhZ9Z2msPdG2BL3PnIP12g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E639885624;
        Fri, 31 Mar 2023 16:28:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8342C40BC797;
        Fri, 31 Mar 2023 16:28:56 +0000 (UTC)
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
Subject: Trivial TLS client
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1610448.1680280135.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 31 Mar 2023 17:28:55 +0100
Message-ID: <1610449.1680280135@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a trivial TLS client program for testing this.

David
---
/*
 * TLS-over-TCP send client
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/stat.h>
#include <sys/sendfile.h>
#include <linux/tls.h>

#define OSERROR(X, Y) do { if ((long)(X) =3D=3D -1) { perror(Y); exit(1); =
} } while(0)

static unsigned char buffer[4096] __attribute__((aligned(4096)));

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
	struct hostent *h;
	struct stat st;
	ssize_t r, o;
	int sf =3D 0;
	int cfd, fd;

	if (argc > 1 && strcmp(argv[1], "-s") =3D=3D 0) {
		sf =3D 1;
		argc--;
		argv++;
	}
	=

	if (argc !=3D 3) {
		fprintf(stderr, "tcp-send [-s] <server> <file>\n");
		exit(2);
	}

	h =3D gethostbyname(argv[1]);
	if (!h) {
		fprintf(stderr, "%s: %s\n", argv[1], hstrerror(h_errno));
		exit(3);
	}

	if (!h->h_addr_list[0]) {
		fprintf(stderr, "%s: No addresses\n", argv[1]);
		exit(3);
	}

	memcpy(&sin.sin_addr, h->h_addr_list[0], h->h_length);
	=

	cfd =3D socket(AF_INET, SOCK_STREAM, 0);
	OSERROR(cfd, "socket");
	OSERROR(connect(cfd, (struct sockaddr *)&sin, sizeof(sin)), "connect");
	set_tls(cfd);

	fd =3D open(argv[2], O_RDONLY);
	OSERROR(fd, argv[2]);
	OSERROR(fstat(fd, &st), argv[2]);

	if (!sf) {
		for (;;) {
			r =3D read(fd, buffer, sizeof(buffer));
			OSERROR(r, argv[2]);
			if (r =3D=3D 0)
				break;

			o =3D 0;
			do {
				ssize_t w =3D write(cfd, buffer + o, r - o);
				OSERROR(w, "write");
				o +=3D w;
			} while (o < r);
		}
	} else {
		off_t off =3D 0;
		r =3D sendfile(cfd, fd, &off, st.st_size);
		OSERROR(r, "sendfile");
		if (r !=3D st.st_size) {
			fprintf(stderr, "Short sendfile\n");
			exit(1);
		}
	}

	OSERROR(close(cfd), "close/c");
	OSERROR(close(fd), "close/f");
	return 0;
}

