Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EE66DBF8E
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjDIKwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDIKws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:52:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0694C00
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0D0160BBD
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3727C433EF;
        Sun,  9 Apr 2023 10:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681037566;
        bh=Q4E+2Wx1+FWfY4TbEDjo7XG80263GZ0FOx/U4dwCvRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kD0R4mfPBAHm/qKtU8lmu3/JZzluGMXhgvzLEu/m+bcJScxEgd2Aowef9TEwLHs8k
         MZaRhQGyogRSKcQBZvzjgNTymgX6zaIgWub0b49YiRfxk8oiPSqzP5OeRvwWlgYqnX
         KlLNCFl41uAqgw5+qExxmiSSSwUOKmFGAtC5MJrbPzH0z5x6xXSk1EhjRbIgJ/hyqy
         /mBQ+EGLE3kmj2N1ijgzizY74zywNKTF54srQxtbyX9rJMcgcpgwjNPeaktB3eAa9t
         x5OpbSydn/eYC+RRqSnNSjwVY2dp5Cz7o+62MTN0xfQioHK1DtuHYGRI+vbXpCu6Q7
         Z5xAyLfodTiSA==
Date:   Sun, 9 Apr 2023 13:52:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, shannon.nelson@amd.com, neel.patel@amd.com
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Message-ID: <20230409105242.GR14869@unreal>
References: <20230407233645.35561-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407233645.35561-1-brett.creeley@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:36:45PM -0700, Brett Creeley wrote:
> Commit 116dce0ff047 ("ionic: Use vzalloc for large per-queue related
> buffers") made a change to relieve memory pressure by making use of
> vzalloc() due to the structures not requiring DMA mapping. However,
> it overlooked that these structures are used in the fast path of the
> driver and allocations on the non-local node could cause performance
> degredation. Fix this by first attempting to use vzalloc_node()
> using the device's local node and if that fails try again with
> vzalloc().
> 
> Fixes: 116dce0ff047 ("ionic: Use vzalloc for large per-queue related buffers")
> Signed-off-by: Neel Patel <neel.patel@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 ++++++++++++-------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 957027e546b3..2c4e226b8cf1 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -560,11 +560,15 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
>  	new->q.dev = dev;
>  	new->flags = flags;
>  
> -	new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
> +	new->q.info = vzalloc_node(num_descs * sizeof(*new->q.info),
> +				   dev_to_node(dev));
>  	if (!new->q.info) {
> -		netdev_err(lif->netdev, "Cannot allocate queue info\n");
> -		err = -ENOMEM;
> -		goto err_out_free_qcq;
> +		new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
> +		if (!new->q.info) {
> +			netdev_err(lif->netdev, "Cannot allocate queue info\n");

Kernel memory allocator will try local node first and if memory is
depleted it will go to remote nodes. So basically, you open-coded that
behaviour but with OOM splash when first call to vzalloc_node fails and
with custom error message about memory allocation failure.

Thanks
