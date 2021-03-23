Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2D43455A6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCWCpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhCWCo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:44:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65FAC061574;
        Mon, 22 Mar 2021 19:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=fPPplkVEUIpxYFEwNetuYs1tuZiCZqATASyjPEZ19NM=; b=W2QkquiXXhfP7Ahz8cYpeFrLib
        sJKrU5X8P7BQdUQxHhuMYMg8pxQ6u5ITpU8MJB0LF/KKbbE/jUTFJmVLFVAbBKLAIVAwO9Fh9B9Ky
        CkEAHhxYPzfM/Gcmcm9uU4amgWJbt0Y6jEN54oodxwaclU5y8DBm3wb9aNb40WYpW882RXEm2wStp
        wwZXdbxjaNCnQ9IoXkefBAVxy1g2OuOU8ui0znjiAvvxUDzxwtrYaAdfDJhUKCMn/csOiGXt6HvAT
        RM2yb1pdaX3HqU5qNArWQOQYPiDzCqc4jLt/gYyQ8p865BnSKnnLXhdWh5z5f36KU0DVv3qhL43pi
        SYX1Y9+w==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOX2E-009Qcb-8S; Tue, 23 Mar 2021 02:44:50 +0000
Subject: Re: [PATCH net-next] net: ipa: avoid 64-bit modulus
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210323010505.2149882-1-elder@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7efcf4b8-123f-d121-2556-deb9aec5652c@infradead.org>
Date:   Mon, 22 Mar 2021 19:44:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323010505.2149882-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 6:05 PM, Alex Elder wrote:
> It is possible for a 32 bit x86 build to use a 64 bit DMA address.
> 
> There are two remaining spots where the IPA driver does a modulo
> operation to check alignment of a DMA address, and under certain
> conditions this can lead to a build error on i386 (at least).
> 
> The alignment checks we're doing are for power-of-2 values, and this
> means the lower 32 bits of the DMA address can be used.  This ensures
> both operands to the modulo operator are 32 bits wide.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested


Thanks.

> ---
>  drivers/net/ipa/gsi.c       | 11 +++++++----
>  drivers/net/ipa/ipa_table.c |  9 ++++++---
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 7f3e338ca7a72..b6355827bf900 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1436,15 +1436,18 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
>  /* Initialize a ring, including allocating DMA memory for its entries */
>  static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
>  {
> -	size_t size = count * GSI_RING_ELEMENT_SIZE;
> +	u32 size = count * GSI_RING_ELEMENT_SIZE;
>  	struct device *dev = gsi->dev;
>  	dma_addr_t addr;
>  
> -	/* Hardware requires a 2^n ring size, with alignment equal to size */
> +	/* Hardware requires a 2^n ring size, with alignment equal to size.
> +	 * The size is a power of 2, so we can check alignment using just
> +	 * the bottom 32 bits for a DMA address of any size.
> +	 */
>  	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
> -	if (ring->virt && addr % size) {
> +	if (ring->virt && lower_32_bits(addr) % size) {
>  		dma_free_coherent(dev, size, ring->virt, addr);
> -		dev_err(dev, "unable to alloc 0x%zx-aligned ring buffer\n",
> +		dev_err(dev, "unable to alloc 0x%x-aligned ring buffer\n",
>  			size);
>  		return -EINVAL;	/* Not a good error value, but distinct */
>  	} else if (!ring->virt) {
> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> index 988f2c2886b95..4236a50ff03ae 100644
> --- a/drivers/net/ipa/ipa_table.c
> +++ b/drivers/net/ipa/ipa_table.c
> @@ -658,10 +658,13 @@ int ipa_table_init(struct ipa *ipa)
>  		return -ENOMEM;
>  
>  	/* We put the "zero rule" at the base of our table area.  The IPA
> -	 * hardware requires rules to be aligned on a 128-byte boundary.
> -	 * Make sure the allocation satisfies this constraint.
> +	 * hardware requires route and filter table rules to be aligned
> +	 * on a 128-byte boundary.  As long as the alignment constraint
> +	 * is a power of 2, we can check alignment using just the bottom
> +	 * 32 bits for a DMA address of any size.
>  	 */
> -	if (addr % IPA_TABLE_ALIGN) {
> +	BUILD_BUG_ON(!is_power_of_2(IPA_TABLE_ALIGN));
> +	if (lower_32_bits(addr) % IPA_TABLE_ALIGN) {
>  		dev_err(dev, "table address %pad not %u-byte aligned\n",
>  			&addr, IPA_TABLE_ALIGN);
>  		dma_free_coherent(dev, size, virt, addr);
> 


-- 
~Randy

