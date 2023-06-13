Return-Path: <netdev+bounces-10482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC6A72EB36
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8F4E28127E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49C81ED45;
	Tue, 13 Jun 2023 18:45:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EA81ED3F
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 18:45:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1651BDB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686681935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SIDR2dqRwvLDufVgXSXj8KatzblZX0gs/2FHCG5UpAY=;
	b=h0ku6a2aIZa4cQbhSCtohVB9tPYhTSMnmKpX+Uh11jfbbDdRql5cXZTdBYVtbJ5562u3oZ
	1m6MY2SeVLArzZ9nq5b1i5fyaxpU0BAqGydOB1pMmkrvNP4AXtv/NKhqmARfLOvbkK7k3n
	La3gVkI4aN+eCu3oI+RTSiplnH4OOmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-xTvb-8OnNO2OYEr7YExcXQ-1; Tue, 13 Jun 2023 14:45:32 -0400
X-MC-Unique: xTvb-8OnNO2OYEr7YExcXQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9C97101A53B;
	Tue, 13 Jun 2023 18:45:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF880492C1B;
	Tue, 13 Jun 2023 18:45:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230613111505.249ccb18@kernel.org>
References: <20230613111505.249ccb18@kernel.org> <000000000000ae4cbf05fdeb8349@google.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com,
    syzbot <syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com>,
    bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
    edumazet@google.com, linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org, pabeni@redhat.com,
    syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [net?] KASAN: stack-out-of-bounds Read in skb_splice_from_iter
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <920481.1686681922.1@warthog.procyon.org.uk>
Date: Tue, 13 Jun 2023 19:45:22 +0100
Message-ID: <920483.1686681922@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> wrote:

> Hi David, are you fighting all these fires reported by syzbot?
> I see another one just rolled in from yesterdays KCM changes.

I'm trying to pin down a bug in the old DIO code whilst attending the AFS
Workshop.  I'll get to the sendpage reports in a bit.  I think a bunch of them
are probably the same issue in AF_ALG hashing.  They do at least have
reproducers.

David


