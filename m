Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC842D83B1
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 02:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391487AbgLLBBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 20:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbgLLBBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 20:01:34 -0500
Message-ID: <59bc3e140cfb859bb8451a1e87da5125b956d778.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607734854;
        bh=O6TebZFVGpQRVFLJnDJkUBRP0nsS7Y5J3PD/1BnV+XU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mCEeiG6FxBm5AnpHHOHYOEkzVDC750so/ztTcO9n9lG8FtDgi2EeuMBe2cOTg1nYI
         cJKwOo8/Pmd2Qa4sLiI/e6M5MyqOoIkhsZo7Ik9JGLI9hiG4gwNIHEI6OlIgb9cBG+
         xjt/ngtJVWQCGPEyP67n9F/tdMbV6Ofb6PGzjVZadvCc/hawYQEmM/vQB8a4WeE9eI
         WR/G/SWjNnx33Bghd8XwHIPLH7x7/EIIDC1WpQ9mpYPy1qZFRyVujDY12nwBpGQeJW
         AxYPFmLrNeYoEEffeFCsSkohfkLnetCng7uMXFF4DaXTXJtCC/00VuCLiGQDZONYLG
         i8rwuQHxo65MA==
Subject: Re: [PATCH v2 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
From:   Saeed Mahameed <saeed@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com
Date:   Fri, 11 Dec 2020 17:00:52 -0800
In-Reply-To: <afc242ec96097ae8318a1ba2819aa2daa5e56a51.1607714335.git.lorenzo@kernel.org>
References: <cover.1607714335.git.lorenzo@kernel.org>
         <afc242ec96097ae8318a1ba2819aa2daa5e56a51.1607714335.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-11 at 20:28 +0100, Lorenzo Bianconi wrote:
> Introduce xdp_prepare_buff utility routine to initialize per-
> descriptor
> xdp_buff fields (e.g. xdp_buff pointers). Rely on xdp_prepare_buff()
> in
> all XDP capable drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
...
> +static inline void
> +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> +		 int headroom, int data_len)
> +{
> +	xdp->data_hard_start = hard_start;
> +	xdp->data = hard_start + headroom;
> +	xdp->data_end = xdp->data + data_len;
> +	xdp->data_meta = xdp->data;

You might want to compute data = hard_start + headroom; on a local var,
and hopefully gcc will put it into a register, then reuse it three
times instead of the 2 xdp->data de-references you got at the end of
the function.

unsigned char *data = hard_start + headroom;

xdp->data_hard_start = hard_start;
xdp->data = data;
xdp->data_end = data + data_len;
xdp->data_meta = data;


