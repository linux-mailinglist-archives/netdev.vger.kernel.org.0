Return-Path: <netdev+bounces-3353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0384E7068D6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:04:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03F3A1C20A41
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD901549B;
	Wed, 17 May 2023 13:04:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A104C18B0D;
	Wed, 17 May 2023 13:04:16 +0000 (UTC)
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFD110D4;
	Wed, 17 May 2023 06:04:14 -0700 (PDT)
Received: from hillosipuli.retiisi.eu (82-181-192-243.bb.dnainternet.fi [82.181.192.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sailus)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4QLtbV1QG8zyVk;
	Wed, 17 May 2023 16:04:05 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1684328652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qroAO/01zVC5BeUS1oPJjvMgFXQbPQ5wLZQknG7YiBc=;
	b=KI5xLqxAreFfTVONtxIvWUWwB6MTDQj7RtmKmQdExNpcu0TTzvVSri6CgDzfn/Cvel5yIF
	peJPQn6GiZwvSCe1d9YgeARR10JKXstw9T0rA85J5gW4iNziKdRCMcnWXYP0+H6llDqTu+
	dlJg7YsYYMHPUazplrk3fr+MLlrvNQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1684328652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qroAO/01zVC5BeUS1oPJjvMgFXQbPQ5wLZQknG7YiBc=;
	b=tq4IDVw8v8U/8GsVfhSpzk5/qRBC75wFpFFUJgfBv9u3M7Nh/LDCouHEa/Yf2TAbdyN9RL
	s9DHY+YDHwdk5UhlkrhBxeP2H2uUN2GWxD/ThDKmfJpRrOdCf8iI3cZweO5gCffPclWh3T
	72d3B2jMq4cIupzPEIlKtqOR6tjzSWQ=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sailus smtp.mailfrom=sakari.ailus@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1684328652; a=rsa-sha256; cv=none;
	b=NhylTHQjTF5WnCPKZ7JS9gpIQVkp7jw/Go3W19TSMVVJzM3XuHh1EGsfnax0pohXqM0PST
	9D9wqdiwjRp9aDijZ5JN+bmSBC6eMjAtZznB5usfmHDH3gVQKs7r3mGmGqix5OK1JPosO8
	b8VJFUZikNPWWHwmwu7R15M7dw0pr0I=
Received: from valkosipuli.retiisi.eu (valkosipuli.localdomain [192.168.4.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by hillosipuli.retiisi.eu (Postfix) with ESMTPS id 4BC90634C94;
	Wed, 17 May 2023 16:04:05 +0300 (EEST)
Date: Wed, 17 May 2023 16:04:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org,
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
	netdev@vger.kernel.org, io-uring@vger.kernel.org,
	bpf@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v5 5/6] mm/gup: remove vmas parameter from
 pin_user_pages()
Message-ID: <ZGTQxbiFnTADjLgv@valkosipuli.retiisi.eu>
References: <cover.1684097001.git.lstoakes@gmail.com>
 <acd4a8c735c9bc1c736e1a52a9a036db5cc7d462.1684097002.git.lstoakes@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd4a8c735c9bc1c736e1a52a9a036db5cc7d462.1684097002.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 14, 2023 at 10:26:58PM +0100, Lorenzo Stoakes wrote:
> We are now in a position where no caller of pin_user_pages() requires the
> vmas parameter at all, so eliminate this parameter from the function and
> all callers.
> 
> This clears the way to removing the vmas parameter from GUP altogether.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com> (for qib)
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com> # drivers/media

-- 
Sakari Ailus

