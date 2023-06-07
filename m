Return-Path: <netdev+bounces-8865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0615F726215
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 398F32812F1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729C235B57;
	Wed,  7 Jun 2023 14:05:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1890A139F;
	Wed,  7 Jun 2023 14:05:31 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978471BE3;
	Wed,  7 Jun 2023 07:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q6ZcNKaMmaLtZ2k8Pfp9W7lBG0f901s5qBQB0ForDFg=; b=LvCr+FzBfv2Ob+BZQlPqfSeKFa
	HM4GprvasrzxHoKj4RJADj4wJMIO6MWv4EBmLt1mnjhlP8hA+dVR6Yr3wpL79IJbYDWwSeqx4FrvS
	vCnrAs5hWh/H0qfGUkVsVwo6sH9v+pt6ri6+uaUOaug1oOjQWC3lH+S4DAEuls/wIv8Lna6x/b2jp
	PQ4KwnNANyD/gtHw4B/Uoswx5TZ2qMkMzjQUsIzNLhP36VpnBEr07CFAp1YSThqi6MKJPwjgFK8OG
	jxRFOvzHY5Ye+2cP+dKipV2yLMLf38X1ruXzTHeosuNN9Fd9a2FIMYzYswG8XE4USzhrsykKY1pd0
	uG8kq5Qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q6tmi-006CPZ-07;
	Wed, 07 Jun 2023 14:05:12 +0000
Date: Wed, 7 Jun 2023 07:05:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	virtualization@lists.linux-foundation.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
	bpf@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH vhost v10 00/10] virtio core prepares for AF_XDP
Message-ID: <ZICOl1hfsx5DwKff@infradead.org>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
 <20230602232902.446e1d71@kernel.org>
 <1685930301.215976-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685930301.215976-1-xuanzhuo@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 09:58:21AM +0800, Xuan Zhuo wrote:
> On Fri, 2 Jun 2023 23:29:02 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri,  2 Jun 2023 17:21:56 +0800 Xuan Zhuo wrote:
> > > Thanks for the help from Christoph.
> >
> > That said you haven't CCed him on the series, isn't the general rule to
> > CC anyone who was involved in previous discussions?
> 
> 
> Sorry, I forgot to add cc after git format-patch.

So I've been looking for this series elsewhere, but it seems to include
neither lkml nor the iommu list, so I can't find it.  Can you please
repost it?

