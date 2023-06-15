Return-Path: <netdev+bounces-11139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6518D731AF7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 937111C20B3C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97947171BC;
	Thu, 15 Jun 2023 14:14:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A480171A5;
	Thu, 15 Jun 2023 14:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415DFC433C8;
	Thu, 15 Jun 2023 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686838461;
	bh=8rQHH3i3Wo5LBZJWaXmkXUPZ8PkbfaTGdpx89FRgdlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eVcq7D+at5yU0wLc1QcYhsVui8Qh4sjzCQOmfZTW/SkJguIl18b8rCQ87bK+4S6ce
	 GTgYQ7a3ULd9Q9jbw0aKUE53rEzMtCacbOkv2PyXg2zyT5m6znaljpCNOFAOeSouF4
	 H9sDSyYWUXO0HIyFl8MP44EHK6fW3R9G82sHpJwCPTP8rJ20OLktaLOdKRt7ncF2TO
	 Hg2BAqej9rLPAXu76YWTd+9Kr7n5uYZQrVHTFGh67kRibKGkHGy/r1HNfcqNKWBkpz
	 b6YIDKE3+0OPG98Hw+JduIooHL2+58pZtetJmmJUlxR3+NpGUpGj8Drl9dkgrccw66
	 wSJUxdl44hiXA==
Date: Thu, 15 Jun 2023 16:14:15 +0200
From: Simon Horman <horms@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andre Guedes <andre.guedes@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Kauer <florian.kauer@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Jithu Joseph <jithu.joseph@intel.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Vedang Patel <vedang.patel@intel.com>,
	intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH RFC net] igc: Avoid dereference of ptr_err in
 igc_clean_rx_irq()
Message-ID: <ZIsct/J9NeY874b9@kernel.org>
References: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
 <ZIrgEVVQfvJwneLx@boxer>
 <ZIr1s6KHVGh/ZuEj@kernel.org>
 <ZIr/iX7qNbUpXocP@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIr/iX7qNbUpXocP@boxer>

On Thu, Jun 15, 2023 at 02:09:45PM +0200, Maciej Fijalkowski wrote:
> On Thu, Jun 15, 2023 at 01:27:47PM +0200, Simon Horman wrote:
> > On Thu, Jun 15, 2023 at 11:55:29AM +0200, Maciej Fijalkowski wrote:
> > > On Thu, Jun 15, 2023 at 11:45:36AM +0200, Simon Horman wrote:
> > 
> > Hi Marciej,
> > 
> > > Hi Simon,
> > > 
> > > > In igc_clean_rx_irq() the result of a call to igc_xdp_run_prog() is assigned
> > > > to the skb local variable. This may be an ERR_PTR.
> > > > 
> > > > A little later the following is executed, which seems to be a
> > > > possible dereference of an ERR_PTR.
> > > > 
> > > > 	total_bytes += skb->len;
> > > > 
> > > > Avoid this problem by continuing the loop in which all of the
> > > > above occurs once the handling of the NULL case completes.
> > > > 
> > > > This proposed fix is speculative - I do not have deep knowledge of this
> > > > driver.  And I am concerned about the effect of skipping the following
> > > > logic:
> > > > 
> > > >   igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
> > > >   cleaned_count++;
> > > 
> > > this will break - you have to recycle the buffer to have it going.
> > 
> > Thanks. As I said I wasn't sure about the fix: it was a strawman.
> > 
> > > > Flagged by Smatch as:
> > > > 
> > > >   .../igc_main.c:2467 igc_xdp_run_prog() warn: passing zero to 'ERR_PTR'
> > > 
> > > how about PTR_ERR_OR_ZERO() ? this would silence smatch and is not an
> > > intrusive change. another way is to get rid of ERR_PTR() around skb/xdp
> > > run result but i think the former would be just fine.
> > 
> > Sorry, there were two warnings. And I accidently trimmed the one
> > that is more relevant instead of the one that is less relevant.
> > I do agree the one above does not appear to be a bug.
> > 
> > But I am concerned abut this one:
> > 
> >   .../igc_main.c:2618 igc_clean_rx_irq() error: 'skb' dereferencing possible ERR_PTR()
> > 
> > If skb is an error pointer, e.g. ERR_PTR(-IGC_XDP_PASS), and
> > it is dereferenced, that would be a problem, right?
> 
> IGC_XDP_PASS is 0. -0 is still 0 right?

Yes, I missed that point.
Though I could have chosen a different value which is not zero.

> this means skb is NULL and igc_{build,construct}_skb() will init it. For
> ERR_PTR, igc_cleanup_headers() does IS_ERR() against it and continues. So
> you will get to line 2618 only for valid skb, it just happens that logic
> is written in a way that skb is supposed to carry XDP return code. We
> removed this in ice for example but i40e works like that for many years
> without issues, AFAICT...

Thanks. I now see that the key point I was missing is the IS_ERR()
check in igc_cleanup_headers().

I agree this is not a bug.

