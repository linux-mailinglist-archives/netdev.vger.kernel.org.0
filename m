Return-Path: <netdev+bounces-11694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B7B733EF7
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F84028191C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD1F63AF;
	Sat, 17 Jun 2023 07:01:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C502E0EA
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F45AC433C8;
	Sat, 17 Jun 2023 07:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686985263;
	bh=xLQM5BSWaNI7GNteWQDpok0GWn+tDUkJWQErOrHWrgw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ubF/4vY3PdrmPR1SUAoW4IuCjHUbrbljvu1YN+PQU76Vuktf/LtHKOdtIk5P7qtW/
	 EYcu5oky/TeTkHN3Q/wD5l9O7ptdfyBi3pn2kmtHuXMbz9M9JrJptoTIIcmw8IyMKd
	 ikHzeQyc6GmT0sSOfSx8KPEzEEceLDSWpY5OpFSurXODjUCqsWUttstmAOAmMjjFSP
	 IYCdZ/aVgSci1xbNa/s8FNYAQJ3UrFTi4Z6tzAtnzxOjadh3npSL0j4rZ7oNIi5qWw
	 oipV9CnpOqZDmHP2I3L85P9Y4EA7wWBdSqjCVL+phAdjq3x4epTlAHsr5kO8lG1CZL
	 7UT3UVWcIYn3Q==
Date: Sat, 17 Jun 2023 00:01:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Alan Brady <alan.brady@intel.com>,
 pavan.kumar.linga@intel.com, emil.s.tantilov@intel.com,
 jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
 shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com,
 decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com,
 simon.horman@corigine.com, shannon.nelson@amd.com,
 stephen@networkplumber.org, Joshua Hay <joshua.a.hay@intel.com>, Madhu
 Chittim <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>
Subject: Re: [PATCH net-next v2 12/15] idpf: add RX splitq napi poll support
Message-ID: <20230617000101.191ea52c@kernel.org>
In-Reply-To: <20230614171428.1504179-13-anthony.l.nguyen@intel.com>
References: <20230614171428.1504179-1-anthony.l.nguyen@intel.com>
	<20230614171428.1504179-13-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:14:25 -0700 Tony Nguyen wrote:
> +static bool idpf_rx_can_reuse_page(struct idpf_rx_buf *rx_buf)
> +{
> +	unsigned int last_offset = PAGE_SIZE - rx_buf->buf_size;
> +	struct idpf_page_info *pinfo;
> +	unsigned int pagecnt_bias;
> +	struct page *page;
> +
> +	pinfo = &rx_buf->page_info[rx_buf->page_indx];
> +	pagecnt_bias = pinfo->pagecnt_bias;
> +	page = pinfo->page;
> +
> +	if (unlikely(!dev_page_is_reusable(page)))
> +		return false;
> +
> +	if (PAGE_SIZE < 8192) {
> +		/* For 2K buffers, we can reuse the page if we are the
> +		 * owner. For 4K buffers, we can reuse the page if there are
> +		 * no other others.
> +		 */
> +		if (unlikely((page_count(page) - pagecnt_bias) >
> +			     pinfo->reuse_bias))
> +			return false;
> +	} else if (pinfo->page_offset > last_offset) {
> +		return false;
> +	}
> +
> +	/* If we have drained the page fragment pool we need to update
> +	 * the pagecnt_bias and page count so that we fully restock the
> +	 * number of references the driver holds.
> +	 */
> +	if (unlikely(pagecnt_bias == 1)) {
> +		page_ref_add(page, USHRT_MAX - 1);
> +		pinfo->pagecnt_bias = USHRT_MAX;
> +	}
> +
> +	return true;
> +}

If you want to do local recycling you must use the page pool first,
and then share the analysis of how much and why the recycling helps.

