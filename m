Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3552F61EB4F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKGHDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiKGHDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68C065C3
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:03:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61BB4B80D15
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8F0C433D6;
        Mon,  7 Nov 2022 07:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667804591;
        bh=NeucI/3zqp+akpMtsKu8R5lV8B05UIL+na/Byd+Rj9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMvWpZHfpUKMMWUVUlKvnZB87GZ1jI+LOXMNEJvAZbHo6nun/AOioT4iEc4OKutbD
         wXkSt40Wq/l+BrusYHPbp2TRdql1hLANQMlnU3prqbCJdAr+H9yinixOjX0jycFIBd
         4EISOmaemvn+xCNBazGkpR34HJ1tJUahVWK4AMRNmXPJP+K8osrJI3IEc5rWTCAaBa
         F+paCNr9MRyjXOArxcC0zgjMXl4BJU1W9+uLi9/iBMrqW5gOkgM3ajzHos8XgtmfKC
         kN+a7tScDKHRIbBHw50P23O/HmWXwT040oKGrMxMKeH6qKPwWl2Gh8+H8Qd4wv9My/
         wW83dKy3Qv2Mg==
Date:   Mon, 7 Nov 2022 09:03:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Kees Cook <keescook@chromium.org>,
        netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 5/6] igb: Do not free q_vector unless new one
 was allocated
Message-ID: <Y2itqqGQm6uZ/2Wf@unreal>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
 <20221104205414.2354973-6-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104205414.2354973-6-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 01:54:13PM -0700, Tony Nguyen wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> Avoid potential use-after-free condition under memory pressure. If the
> kzalloc() fails, q_vector will be freed but left in the original
> adapter->q_vector[v_idx] array position.
> 
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)

You should use first and last names here.

> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index d6c1c2e66f26..c2bb658198bf 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -1202,8 +1202,12 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
>  	if (!q_vector) {
>  		q_vector = kzalloc(size, GFP_KERNEL);
>  	} else if (size > ksize(q_vector)) {
> -		kfree_rcu(q_vector, rcu);
> -		q_vector = kzalloc(size, GFP_KERNEL);
> +		struct igb_q_vector *new_q_vector;
> +
> +		new_q_vector = kzalloc(size, GFP_KERNEL);
> +		if (new_q_vector)
> +			kfree_rcu(q_vector, rcu);
> +		q_vector = new_q_vector;

I wonder if this is correct.
1. if new_q_vector is NULL, you will overwrite q_vector without releasing it.
2. kfree_rcu() doesn't immediately release memory, but after grace
period, but here you are overwriting the pointer which is not release
yet.


>  	} else {
>  		memset(q_vector, 0, size);
>  	}
> -- 
> 2.35.1
> 
