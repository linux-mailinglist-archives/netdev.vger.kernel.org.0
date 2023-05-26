Return-Path: <netdev+bounces-5710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D238771283F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98584281888
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAB015C1;
	Fri, 26 May 2023 14:31:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E566E261DE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:31:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF230E45
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685111475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AN3wUYIRzonhCzYuNraybexj9Op6B4f47YxRrWuA7cY=;
	b=XgaROPBIe3j9GpadDaUxe9IBWaq61qR4lTyIcUuhNCex7NIUHtRJ6kYP7AqQ5x+a1tzpQ4
	X+rY8yZ3IGskwfd4BGY+Sxf/egtaEnwAbTuTfsTZAHyk55VMi3OL2fkSLP5GvvKQ+RXAtw
	TXW5l20gEfFzfPOTwf6GGD+LmcauYDs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-kDUtvQS7PwezkQVOO1pcxw-1; Fri, 26 May 2023 10:31:10 -0400
X-MC-Unique: kDUtvQS7PwezkQVOO1pcxw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C755C811E91;
	Fri, 26 May 2023 14:31:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88ABC2166B2B;
	Fri, 26 May 2023 14:31:07 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] crypto, splice, net: Make AF_ALG handle sendmsg(MSG_SPLICE_PAGES)
Date: Fri, 26 May 2023 15:30:56 +0100
Message-Id: <20230526143104.882842-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here's the fourth tranche of patches towards providing a MSG_SPLICE_PAGES
internal sendmsg flag that is intended to replace the ->sendpage() op with
calls to sendmsg().  MSG_SPLICE_PAGES is a hint that tells the protocol
that it should splice the pages supplied if it can.

This set consists of the following parts:

 (1) Move netfs_extract_iter_to_sg() to somewhere more general and rename
     it to drop the "netfs" prefix.  We use this to extract directly from
     an iterator into a scatterlist.

 (2) Make AF_ALG use iov_iter_extract_pages().  This has the additional
     effect of pinning pages obtained from userspace rather than taking
     refs on them.  Pages from kernel-backed iterators would not be pinned,
     but AF_ALG isn't really meant for use by kernel services.

 (3) Change AF_ALG still further to use extract_iter_to_sg().

 (4) Make af_alg_sendmsg() support MSG_SPLICE_PAGES support and make
     af_alg_sendpage() just a wrapper around sendmsg().  This has to take
     refs on the pages pinned for the moment.

 (5) Make hash_sendmsg() support MSG_SPLICE_PAGES by simply ignoring it.
     hash_sendpage() is left untouched to be removed later, after the
     splice core has been changed to call sendmsg().

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-4

David

Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=51c78a4d532efe9543a4df019ff405f05c6157f6 # part 1

David Howells (8):
  Move netfs_extract_iter_to_sg() to lib/scatterlist.c
  Drop the netfs_ prefix from netfs_extract_iter_to_sg()
  crypto: af_alg: Pin pages rather than ref'ing if appropriate
  crypto: af_alg: Use extract_iter_to_sg() to create scatterlists
  crypto: af_alg: Indent the loop in af_alg_sendmsg()
  crypto: af_alg: Support MSG_SPLICE_PAGES
  crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
  crypto: af_alg/hash: Support MSG_SPLICE_PAGES

 crypto/af_alg.c             | 183 +++++++++++-------------
 crypto/algif_aead.c         |  34 ++---
 crypto/algif_hash.c         | 110 +++++++++------
 crypto/algif_skcipher.c     |  10 +-
 fs/cifs/smb2ops.c           |   4 +-
 fs/cifs/smbdirect.c         |   2 +-
 fs/netfs/iterator.c         | 266 -----------------------------------
 include/crypto/if_alg.h     |   7 +-
 include/linux/netfs.h       |   4 -
 include/linux/scatterlist.h |   1 +
 include/linux/uio.h         |   5 +
 lib/scatterlist.c           | 267 ++++++++++++++++++++++++++++++++++++
 12 files changed, 449 insertions(+), 444 deletions(-)


