Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334D8452B86
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhKPH1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:27:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhKPH1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 02:27:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637047467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i6znEgLYKXbODUstiMvYpW5sQGMh+IInfSfVWduPSHQ=;
        b=b5NEeOLM2XYmRLUcProFGnBsdWNE2TAIRjhkLpHqGjwfuRMue9JrBuoGJ76NUmRqOEdDe2
        KxTp0PQaxZc3uA0G2ilBSaF4ts6PhDFyFhfSm6NQ4E7CuYTdmXyIoLwwYu5U8GGsA/l+o0
        7hgQcNSShRSZOwBg8AoOAAhBtLMZv8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-q3liniVBPQ6BCx9nPWeA8w-1; Tue, 16 Nov 2021 02:24:26 -0500
X-MC-Unique: q3liniVBPQ6BCx9nPWeA8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93922804141;
        Tue, 16 Nov 2021 07:24:24 +0000 (UTC)
Received: from p1 (unknown [10.40.192.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E53ED1017CE4;
        Tue, 16 Nov 2021 07:24:22 +0000 (UTC)
Date:   Tue, 16 Nov 2021 08:24:21 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, Tony Brelinski <tony.brelinski@intel.com>
Subject: Re: [PATCH net 06/10] iavf: prevent accidental free of filter
 structure
Message-ID: <20211116072421.jar25sc7plvql7gw@p1>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
 <20211115235934.880882-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115235934.880882-7-anthony.l.nguyen@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-15 15:59, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> In iavf_config_clsflower, the filter structure could be accidentally
> released at the end, if iavf_parse_cls_flower or iavf_handle_tclass ever
> return a non-zero but positive value.
> 
> In this case, the function continues through to the end, and will call
> kfree() on the filter structure even though it has been added to the
> linked list.
> 
> This can actually happen because iavf_parse_cls_flower will return
> a positive IAVF_ERR_CONFIG value instead of the traditional negative
> error codes.

Hi Jacob,

where exactly does this happen?
Looking at iavf_parse_cls_flower() I see all returns of IAVF_ERR_CONFIG
as "return IAVF_ERR_CONFIG;" while IAVF_ERR_CONFIG is defined as
        IAVF_ERR_CONFIG                         = -4,

I'm not opposed to this change, just wondering what's going on.

  Stefan

> Fix this by ensuring that the kfree() check and error checks are
> similar. Use the more idiomatic "if (err)" to catch all non-zero error
> codes.
> 
> Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Tony Brelinski <tony.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 76c4ca0f055e..9c68c8628512 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -3108,11 +3108,11 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
>  	/* start out with flow type and eth type IPv4 to begin with */
>  	filter->f.flow_type = VIRTCHNL_TCP_V4_FLOW;
>  	err = iavf_parse_cls_flower(adapter, cls_flower, filter);
> -	if (err < 0)
> +	if (err)
>  		goto err;
>  
>  	err = iavf_handle_tclass(adapter, tc, filter);
> -	if (err < 0)
> +	if (err)
>  		goto err;
>  
>  	/* add filter to the list */
> -- 
> 2.31.1
> 

