Return-Path: <netdev+bounces-9486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD2D729634
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B0221C21129
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD5214AB1;
	Fri,  9 Jun 2023 10:02:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5142714A98
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:02:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06164203
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686304954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SombcmEIcaRaYVTgKnrWY9WG1lMYc9bVEGm8HvALgWY=;
	b=Ue0ZL1f/4VfGSZE22fHFToxA+rGG7dQ3owlKMLzli7TGGkXfzRyYQ1eL1K5ZukGNN8EmXx
	+qBrpgiaRuamRMCikrwBVEvvTnDtCWaYehoWSxgLlGu59KpODP8Y4d+0wNJhpT3b2t8gdq
	6BbvwoGD4UCqcleshg+/SIvVsRCXhZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-qreM6B3JMVajOcjyMrQ3tQ-1; Fri, 09 Jun 2023 06:02:25 -0400
X-MC-Unique: qreM6B3JMVajOcjyMrQ3tQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 383D3803791;
	Fri,  9 Jun 2023 10:02:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3271121314;
	Fri,  9 Jun 2023 10:02:23 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] splice, net: Some miscellaneous MSG_SPLICE_PAGES changes
Date: Fri,  9 Jun 2023 11:02:15 +0100
Message-ID: <20230609100221.2620633-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now that the splice_to_socket() has been rewritten so that nothing now uses
the ->sendpage() file op[1], some further changes can be made, so here are
some miscellaneous changes that can now be done.

 (1) Remove the ->sendpage() file op.

 (2) Remove hash_sendpage*() from AF_ALG.

 (3) Make sunrpc send multiple pages in single sendmsg() call rather than
     calling sendpage() in TCP (or maybe TLS).

 (4) Make tcp_bpf_sendpage() a wrapper around tcp_bpf_sendmsg().

 (5) Make AF_KCM use sendmsg() when calling down to TCP and then make it
     send entire fragment lists in single sendmsg calls.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-3-misc

David

Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=fd5f4d7da29218485153fd8b4c08da7fc130c79f [1]

David Howells (6):
  Remove file->f_op->sendpage
  algif: Remove hash_sendpage*()
  sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  tcp_bpf: Make tcp_bpf_sendpage() go through
    tcp_bpf_sendmsg(MSG_SPLICE_PAGES)
  kcm: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
  kcm: Send multiple frags in one sendmsg()

 crypto/algif_hash.c        |  66 --------------------
 include/linux/fs.h         |   1 -
 include/linux/sunrpc/svc.h |  11 ++--
 include/net/kcm.h          |   2 +-
 net/ipv4/tcp_bpf.c         |  49 +++------------
 net/kcm/kcmsock.c          | 120 ++++++++++++++++---------------------
 net/sunrpc/svcsock.c       |  38 ++++--------
 7 files changed, 77 insertions(+), 210 deletions(-)


