Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F810453574
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbhKPPQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhKPPQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 10:16:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DEE761A09;
        Tue, 16 Nov 2021 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637075638;
        bh=sCRg+YijOR+Er2GVfz1HNXQ37gOOQOAsgSeLP69+EDQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wdtzbmqpmc8SgD6FHndv+hrtby+jhtCp1/ITiH2PYb0vzdUDymB0+CG8BGzR6LMkJ
         kWn6UapDp2SAmAyi6ZbKtUO96OTcez+6Zc/fg2IYmwkRybuvslq7442gacoi2d3zTz
         ucj/NGeggj51B1EE6SSRB0LN6LwdOlH2h+IGn6IC1RfQkhMESU5VELsizkdn8KgnF8
         6H1Sd8Rp8cvnEJi0E4tsmpMULABeVWi5evD+sa/Ak1aP6jH80+eUkLiaeOGAo/Cwyn
         RwYlKG4rywZqCCYUOJ8toGhq0zSQ2fGgMjIyy+sFQKJn1h81DLjRfRI54PMf3CkOUl
         LDZahupLZGz1A==
Date:   Tue, 16 Nov 2021 07:13:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v18 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <20211116071357.36c18edf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ce5ad30af8f9b4d2b8128e7488818449a5c0d833.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
        <ce5ad30af8f9b4d2b8128e7488818449a5c0d833.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 23:33:14 +0100 Lorenzo Bianconi wrote:
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	u32 headsize = xdp->data_end - xdp->data;
> +	u32 count = 0, frame_offset = headsize;
> +	int i;
> +
> +	if (offset < headsize) {
> +		int size = min_t(int, headsize - offset, len);
> +		void *src = flush ? buf : xdp->data + offset;
> +		void *dst = flush ? xdp->data + offset : buf;
> +
> +		memcpy(dst, src, size);
> +		count = size;
> +		offset = 0;
> +	}

is this missing
	else
		offset -= headsize;
?

I'm struggling to understand this. Say
	headsize = 400
	frag[0].size = 200

	offset = 500
	len = 50

we enter the loop having missed the previous if...

> +	for (i = 0; i < sinfo->nr_frags; i++) {
> +		skb_frag_t *frag = &sinfo->frags[i];
> +		u32 frag_size = skb_frag_size(frag);
> +
> +		if (count >= len)
> +			break;
> +
> +		if (offset < frame_offset + frag_size) {

		500 < 400 + 200 => true

> +			int size = min_t(int, frag_size - offset, len - count);

			size = min(200 - 500, 50 - 0)
			size = -300 ??

> +			void *addr = skb_frag_address(frag);
> +			void *src = flush ? buf + count : addr + offset;
> +			void *dst = flush ? addr + offset : buf + count;
> +
> +			memcpy(dst, src, size);
> +			count += size;
> +			offset = 0;
> +		}
> +		frame_offset += frag_size;
