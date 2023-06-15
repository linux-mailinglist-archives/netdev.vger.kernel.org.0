Return-Path: <netdev+bounces-11063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E026473167E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D2F91C2034A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DB411CB2;
	Thu, 15 Jun 2023 11:28:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2FB10798
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:28:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9C02695
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686828513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qyCBoM4N2aiuoQmn2+32hlRq3a7hiH/dLr9/SKDhV4I=;
	b=FTjyCpP5RL8gS4qlkjHIevsZpMHGdDgDkO32ElrHjUsLlYMDHZKUgqBviSj8dRVPlp79HX
	J6ylOtg+tclkCF7jX8MmVk7DCW62uP3Ai0SgCZWY73XWEgORG4mCihAedMYVKONKdkklq1
	SURDtSdsiItnX3MzlK/U+Zntuep3xKQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-stO62m1XOT6sugztNaDFDQ-1; Thu, 15 Jun 2023 07:28:30 -0400
X-MC-Unique: stO62m1XOT6sugztNaDFDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24E11101A529;
	Thu, 15 Jun 2023 11:28:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68AF5C1603B;
	Thu, 15 Jun 2023 11:28:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZIrZoKSFTibdKa95@gondor.apana.org.au>
References: <ZIrZoKSFTibdKa95@gondor.apana.org.au> <1679829.1686785273@warthog.procyon.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com,
    syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com,
    syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com,
    syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
    Matthew Wilcox <willy@infradead.org>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20659.1686828504.1@warthog.procyon.org.uk>
Date: Thu, 15 Jun 2023 12:28:24 +0100
Message-ID: <20660.1686828504@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> In any case, this patch doesn't fix all the syzbot reports.

One of them I can't actually reproduce locally, but I have two more patches
that might fix it.

David


