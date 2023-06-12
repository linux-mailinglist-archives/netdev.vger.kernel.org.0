Return-Path: <netdev+bounces-9958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEBF72B655
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8EBE1C20A32
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 04:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967DF1FB6;
	Mon, 12 Jun 2023 04:18:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F51317CE;
	Mon, 12 Jun 2023 04:18:45 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFF491;
	Sun, 11 Jun 2023 21:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7VuDlLSYJdW+nNu3X898l9wqFn63pIrv3O6konR/Pjs=; b=l5yxoaiDbF4Ou9V0nCQhlIWYsk
	RvKJmlX4OqkVLWP/g42QdE1H/0q529Wq0qDLw9jJgvDorAOir6w45u5eJPIeDVquDB4bSpeV4Wl9/
	jq8OVYC8HWqFZhYN/nJ5OOA+IQijKAlcdHkoX/HSUVd3D3EwkdEM8AB6z3Ioq1yVhzZGL87ip574U
	EPotdZX9edn5ho9GSBE6c+AtugqdQq7hGTj4ZTTi/S9QQaGA2t3pX62/b6ZsyGj2GTatWNCIdXdNL
	qG+a+hK6+ORfHc+Bm5FwR1ICJIlN1GtBY/Y2vGS/TsSKKb9S64Ia3hyPR198Qp2r4LjjVghOpzE6B
	CMjzDNlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q8Z0b-002Vpz-10;
	Mon, 12 Jun 2023 04:18:25 +0000
Date: Sun, 11 Jun 2023 21:18:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yi He <clangllvm@126.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
	jolsa@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Add a sysctl option to disable bpf offensive helpers.
Message-ID: <ZIackaLpA3APFFvj@infradead.org>
References: <20230610152618.105518-1-clangllvm@126.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230610152618.105518-1-clangllvm@126.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 10, 2023 at 03:26:18PM +0000, Yi He wrote:
> The default value of sysctl_offensive_bpf_disabled is 0, which means 
> all the five helpers are enabled. By setting sysctl_offensive_bpf_disabled 
> to 1, these helpers cannot be used util a reboot. By setting it to 2, 
> these helpers cannot be used but privieleged users can modify this flag
> to 0.

That's just a nightmare API.  The right thing is to not allow
program types that can use the helpers from anything but a global
fully privileged context.

And offensive is in this context a really weird term.  Nothing is
offensive here, invasive or allowing to change kernel state might be
better terms.

