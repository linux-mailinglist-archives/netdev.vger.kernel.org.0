Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B94F638BC1
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 15:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKYOCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 09:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiKYOCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 09:02:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5F31AF19
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 06:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669384932; x=1700920932;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LnSqyOX6qgUrQdvaDd4smkt0x5aHzgdQa+beKNvdM0E=;
  b=Rpan6kPFrvIz7pf5xJ2bWeh4/MvArADpljK0Vt+g+HDi1Z3ibSEbM6l7
   xOa9MtAnj4+crU8Ie2ykbk4AvOrCiiJcjqFGvYXTAOP/KIZ5gXkrsFre0
   8QM1SiKmD0KlF2QjQPU9Mabql9xKDKzQDK1Cg+Mimva2iVQfoHt6lmC9m
   +MxTfQey9HIwUJQjOFGxQYBeerQ4vDoWik9HMNqhi3iyu2o6RUNvDxP5f
   R3DXMUKIa/i+QZJztCT2uvOAqZ+K69ONT4V48jQShJb8OfddR8hfsdRXk
   rn4ZHzZEXmVlweelN+Y/eNDAFdaw5n7oLoox2pWWpq8WX2r6q+/z8qGfF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="315644911"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="315644911"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 06:02:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="620349099"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="620349099"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 25 Nov 2022 06:02:08 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2APE27gm014976;
        Fri, 25 Nov 2022 14:02:07 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next v2] nfp: ethtool: support reporting link modes
Date:   Fri, 25 Nov 2022 15:01:50 +0100
Message-Id: <20221125140150.79646-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125113030.141642-1-simon.horman@corigine.com>
References: <20221125113030.141642-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@corigine.com>
Date: Fri, 25 Nov 2022 12:30:30 +0100

> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for reporting link modes,
> including `Supported link modes` and `Advertised link modes`,
> via ethtool $DEV.
> 
> A new command `SPCODE_READ_MEDIA` is added to read info from
> management firmware. Also, the mapping table `nfp_eth_media_table`
> associates the link modes between NFP and kernel. Both of them
> help to support this ability.
> 
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

[...]

> @@ -1100,4 +1101,20 @@ int nfp_nsp_read_module_eeprom(struct nfp_nsp *state, int eth_index,
>  	kfree(buf);
>  
>  	return ret;
> +};
> +
> +int nfp_nsp_read_media(struct nfp_nsp *state, void *buf, unsigned int size)
> +{
> +	struct nfp_nsp_command_buf_arg media = {
> +		{
> +			.code		= SPCODE_READ_MEDIA,
> +			.option		= size,
> +		},

One minor here: the initializers below are designated, but the one
above is anonymous, there should be

		.arg = {
			.code		= ...
			.option		= ...
		},

ideally.
Up to you whether to send a new rev or leave it as it is, from me:

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

(please pick it up manually if you send a new rev)

> +		.in_buf		= buf,
> +		.in_size	= size,
> +		.out_buf	= buf,
> +		.out_size	= size,
> +	};
> +
> +	return nfp_nsp_command_buf(state, &media);
>  }

[...]

> -- 
> 2.30.2

Thanks,
Olek
