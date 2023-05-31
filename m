Return-Path: <netdev+bounces-6769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D049717D97
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18E752814B2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680D2C2EC;
	Wed, 31 May 2023 11:05:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58860C2E0
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:05:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD34112B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685531072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Bz65D2xx0gb4qdpRkIQI3YTwLtyS701r/8WE2ftqUAI=;
	b=PaneWmNamdT3Pqo9G6nuY6ysQTT8pZhnOCoIC/DIJlVOow/WqY9a/g2c3qhi6IZ5sPi0/E
	IQQdzsPIM8CRvtXHF82O7HHVQj3YxH2aLHzHGerlGfcFZig7I86L6AB8EWm2QpJ5TB/r4o
	yMgQVPmJ3VjQ/+aMLlDfj8m3sF95y54=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-YLiSyU6kP3mOCadzX03i4g-1; Wed, 31 May 2023 07:04:29 -0400
X-MC-Unique: YLiSyU6kP3mOCadzX03i4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 640EB1019C87;
	Wed, 31 May 2023 11:04:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A90CC154D7;
	Wed, 31 May 2023 11:04:25 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Tom Herbert <tom@herbertland.com>,
	Tom Herbert <tom@quantonium.net>,
	Cong Wang <cong.wang@bytedance.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] splice, net: Handle MSG_SPLICE_PAGES in AF_KCM
Date: Wed, 31 May 2023 12:04:20 +0100
Message-ID: <20230531110423.643196-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Here are patches to make AF_KCM handle the MSG_SPLICE_PAGES internal
sendmsg flag.  MSG_SPLICE_PAGES is an internal hint that tells the protocol
that it should splice the pages supplied if it can.  Its sendpage
implementation is then turned into a wrapper around that.

Does anyone actually use AF_KCM?  Upstream it has some issues.  It doesn't
seem able to handle a "message" longer than 113920 bytes without jamming
and doesn't handle the client termination once it is jammed.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-2-kcm

David

ver #2)
 - In kcm_sendpage(), only account the amount actually copied.
 - Wrap at 80 chars.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=51c78a4d532efe9543a4df019ff405f05c6157f6 # part 1
Link: https://lore.kernel.org/r/20230524144923.3623536-1-dhowells@redhat.com/ # v1

David Howells (2):
  kcm: Support MSG_SPLICE_PAGES
  kcm: Convert kcm_sendpage() to use MSG_SPLICE_PAGES

 net/kcm/kcmsock.c | 218 ++++++++++++----------------------------------
 1 file changed, 58 insertions(+), 160 deletions(-)


