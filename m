Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABA26DC0C8
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjDIRHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 13:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDIRHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 13:07:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7A82D42
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D0B60B36
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 17:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF8C433D2;
        Sun,  9 Apr 2023 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681060052;
        bh=4oreaS771LdfKpiS/15ZaxhcZeQvKXOoAjsLLQ/0SHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OTQAGcNKeWsyRmBWOKATY/YIzcWc4VrrsrJaEk7qWsPipe69/o0u6B8wvEn6X4R0J
         jphn7QQzlSDGfbPaxP29AxEap1kpEqaLIum/2stJ8QqR7Qx2BTskPu0iSjqVlAiSz0
         ExrDJVYB3KQAVPhov4n0Ti9UMaeK0dZfJQRntC+IonIa4Ys6T6O+eAYYXwETbcWLBH
         1rjkcoYXdx0UgfT73tT4ditB9ciE45PVTnfStMpn4xpzTaUeSsPbJKqpTosC9DiD+2
         X6WLreHNdgtlauHZktMKh+8ssDMETPtG1bgN+8RUr57e7MJK38kOM5C1JTK8tbJLj7
         SaFaSaooB1ttg==
Date:   Sun, 9 Apr 2023 20:07:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 12/14] pds_core: add the aux client API
Message-ID: <20230409170727.GG182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-13-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-13-shannon.nelson@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:41PM -0700, Shannon Nelson wrote:
> Add the client API operations for running adminq commands.
> The core registers the client with the FW, then the client
> has a context for requesting adminq services.  We expect
> to add additional operations for other clients, including
> requesting additional private adminqs and IRQs, but don't have
> the need yet.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/auxbus.c | 135 ++++++++++++++++++++-
>  include/linux/pds/pds_auxbus.h             |  28 +++++
>  2 files changed, 160 insertions(+), 3 deletions(-)

<...>

> +static struct pds_core_ops pds_core_ops = {
> +	.adminq_cmd = pds_client_adminq_cmd,
> +};
> +

<...>

> diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
> index aa0192af4a29..f98efd578e1c 100644
> --- a/include/linux/pds/pds_auxbus.h
> +++ b/include/linux/pds/pds_auxbus.h
> @@ -10,7 +10,35 @@ struct pds_auxiliary_dev {
>  	struct auxiliary_device aux_dev;
>  	struct pci_dev *vf_pdev;
>  	struct pci_dev *pf_pdev;
> +	struct pds_core_ops *ops;

I honestly don't understand why pds_core functionality is espoused
through ops callbacks on auxdevice. IMHO, they shouldn't be callbacks
and that functionality shouldn't operate on auxdevice.

Thanks

>  	u16 client_id;
>  	void *priv;
>  };
> +
> +/*
> + *   ptrs to functions to be used by the client for core services
> + */
> +struct pds_core_ops {
> +	/* .adminq_cmd() - process an adminq request for the client
> +	 * padev:  ptr to the client device
> +	 * req:     ptr to buffer with request
> +	 * req_len: length of actual struct used for request
> +	 * resp:    ptr to buffer where answer is to be copied
> +	 * flags:   optional flags defined by enum pds_core_adminq_flags
> +	 *	    and used for more flexible adminq behvior
> +	 *
> +	 * returns 0 on success, or
> +	 *         negative for error
> +	 * Client sends pointers to request and response buffers
> +	 * Core copies request data into pds_core_client_request_cmd
> +	 * Core sets other fields as needed
> +	 * Core posts to AdminQ
> +	 * Core copies completion data into response buffer
> +	 */
> +	int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
> +			  union pds_core_adminq_cmd *req,
> +			  size_t req_len,
> +			  union pds_core_adminq_comp *resp,
> +			  u64 flags);
> +};
>  #endif /* _PDSC_AUXBUS_H_ */
> -- 
> 2.17.1
> 
