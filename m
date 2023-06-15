Return-Path: <netdev+bounces-11062-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD68073167C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6FA1C20E5A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E4111CB2;
	Thu, 15 Jun 2023 11:27:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A531420E0;
	Thu, 15 Jun 2023 11:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1756C433C0;
	Thu, 15 Jun 2023 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686828474;
	bh=U9pbntIrNXfG7wu+B1aeTFIpvtosIyr2h3tcLbTgri8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i+umpez4rTb0T0Gfhbn1Qo6jRT/lDlcLnZC7hndaemOrDSx8FT43ipPhAi8TbNSlz
	 ko/kbrXg7ZgjMbc3Ww0yJSQS4654qIk6cQm5XGz7rrslKJxFEmXmUqRzE+G7GuH7po
	 UpVW4AgzAIxJPPiEbyrzMb5QSBY14r0vC2PNNuUsiaXpOr8pt6aDnPBmLE7GSmiyp8
	 rLDmXJajhvT70ygSb91xjfZeA2s1JwPjvJrxZMdcaGNUKUwcXHyKrRfPXq7XhrUUNk
	 wucQFjr76cOeHQd03uhwET/usUzGdIi2SIthQpUbPuhz+wSYEbplMPm9euq3gUc9SJ
	 UKcwpzQ/mOLVw==
Date: Thu, 15 Jun 2023 13:27:47 +0200
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
Message-ID: <ZIr1s6KHVGh/ZuEj@kernel.org>
References: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
 <ZIrgEVVQfvJwneLx@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIrgEVVQfvJwneLx@boxer>

On Thu, Jun 15, 2023 at 11:55:29AM +0200, Maciej Fijalkowski wrote:
> On Thu, Jun 15, 2023 at 11:45:36AM +0200, Simon Horman wrote:

Hi Marciej,

> Hi Simon,
> 
> > In igc_clean_rx_irq() the result of a call to igc_xdp_run_prog() is assigned
> > to the skb local variable. This may be an ERR_PTR.
> > 
> > A little later the following is executed, which seems to be a
> > possible dereference of an ERR_PTR.
> > 
> > 	total_bytes += skb->len;
> > 
> > Avoid this problem by continuing the loop in which all of the
> > above occurs once the handling of the NULL case completes.
> > 
> > This proposed fix is speculative - I do not have deep knowledge of this
> > driver.  And I am concerned about the effect of skipping the following
> > logic:
> > 
> >   igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
> >   cleaned_count++;
> 
> this will break - you have to recycle the buffer to have it going.

Thanks. As I said I wasn't sure about the fix: it was a strawman.

> > Flagged by Smatch as:
> > 
> >   .../igc_main.c:2467 igc_xdp_run_prog() warn: passing zero to 'ERR_PTR'
> 
> how about PTR_ERR_OR_ZERO() ? this would silence smatch and is not an
> intrusive change. another way is to get rid of ERR_PTR() around skb/xdp
> run result but i think the former would be just fine.

Sorry, there were two warnings. And I accidently trimmed the one
that is more relevant instead of the one that is less relevant.
I do agree the one above does not appear to be a bug.

But I am concerned abut this one:

  .../igc_main.c:2618 igc_clean_rx_irq() error: 'skb' dereferencing possible ERR_PTR()

If skb is an error pointer, e.g. ERR_PTR(-IGC_XDP_PASS), and
it is dereferenced, that would be a problem, right?

Perhaps I'm missing something obvious and this can't occur.
But it does seem possible to me.

> 
> > 
> > Compile tested only.
> > 
> > Fixes: 26575105d6ed ("igc: Add initial XDP support")
> > Signed-off-by: Simon Horman <horms@kernel.org>
> > ---
> >  drivers/net/ethernet/intel/igc/igc_main.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> > index 88145c30c919..b58c8a674bd1 100644
> > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > @@ -2586,6 +2586,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
> >  
> >  			total_packets++;
> >  			total_bytes += size;
> > +			continue;
> >  		} else if (skb)
> >  			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
> >  		else if (ring_uses_build_skb(rx_ring))
> > 
> > 
> 

