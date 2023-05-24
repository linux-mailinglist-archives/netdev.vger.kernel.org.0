Return-Path: <netdev+bounces-4854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAA3670EC2B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 967531C20AF4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2DDD15BB;
	Wed, 24 May 2023 03:53:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7E315B8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD908C433D2;
	Wed, 24 May 2023 03:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684900437;
	bh=4f1gt/BCfbLHog09/Xsin0iYouAloZtBkhPaw5h+3Uk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VTjRau/bNOfmdJ33zPP9fzppLzalj2n66xWeUM8et/U2kDIXenWJlws9ke/J63cua
	 7h8nbEpBrHk+3kbBwK4hYrTG0TJuuA4Y8nyVrZV34Feh/wVZUCXe9pHkiL5GrZpTPb
	 1pUq0WoLiV4z1hh/q8nIAUP6Q7nvRsPe6zxlxMbem5vTDjKC2IBSsISEX6TycDAT+K
	 E11xrcZaYzPDD+AvVcAUfQueTdIeTLMtPcPMx7rpOceZRwETWUuo1o7AcoLQuOypBm
	 fbpREO7W2cFcnLHLSfIPlJAIvbGWiK22cduJxuIMSKGEpMfWr2jO0/7hSlREuEGrtM
	 7Bq4VihlXfeWA==
Date: Tue, 23 May 2023 20:53:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>, Christoph Hellwig
 <hch@infradead.org>, Tony Nguyen <anthony.l.nguyen@intel.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, James Smart <james.smart@broadcom.com>, Keith
 Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg
 <sagi@grimberg.me>, HighPoint Linux Team <linux@highpoint-tech.com>, "James
 E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S
 <shivasharan.srikanteshwara@broadcom.com>, Don Brace
 <don.brace@microchip.com>, "Darrick J. Wong" <djwong@kernel.org>, Dave
 Chinner <dchinner@redhat.com>, Guo Xuenan <guoxuenan@huawei.com>,
 Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>, Nick Desaulniers
 <ndesaulniers@google.com>, Daniel Latypov <dlatypov@google.com>, kernel
 test robot <lkp@intel.com>, intel-wired-lan@lists.osuosl.org,
 netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
 storagedev@microchip.com, linux-xfs@vger.kernel.org,
 linux-hardening@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Tales
 Aparecida <tales.aparecida@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] overflow: Add struct_size_t() helper
Message-ID: <20230523205354.06b147c6@kernel.org>
In-Reply-To: <20230522211810.never.421-kees@kernel.org>
References: <20230522211810.never.421-kees@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 14:18:13 -0700 Kees Cook wrote:
> diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.h b/drivers/net/ethernet/intel/ice/ice_ddp.h
> index 37eadb3d27a8..41acfe26df1c 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ddp.h
> +++ b/drivers/net/ethernet/intel/ice/ice_ddp.h
> @@ -185,7 +185,7 @@ struct ice_buf_hdr {
>  
>  #define ICE_MAX_ENTRIES_IN_BUF(hd_sz, ent_sz)                                 \
>  	((ICE_PKG_BUF_SIZE -                                                  \
> -	  struct_size((struct ice_buf_hdr *)0, section_entry, 1) - (hd_sz)) / \
> +	  struct_size_t(struct ice_buf_hdr,  section_entry, 1) - (hd_sz)) / \
>  	 (ent_sz))
>  
>  /* ice package section IDs */
> @@ -297,7 +297,7 @@ struct ice_label_section {
>  };
>  
>  #define ICE_MAX_LABELS_IN_BUF                                             \
> -	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_label_section *)0, \
> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_label_section,  \
>  					   label, 1) -                    \
>  				       sizeof(struct ice_label),          \
>  			       sizeof(struct ice_label))
> @@ -352,7 +352,7 @@ struct ice_boost_tcam_section {
>  };
>  
>  #define ICE_MAX_BST_TCAMS_IN_BUF                                               \
> -	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_boost_tcam_section *)0, \
> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_boost_tcam_section,  \
>  					   tcam, 1) -                          \
>  				       sizeof(struct ice_boost_tcam_entry),    \
>  			       sizeof(struct ice_boost_tcam_entry))
> @@ -372,8 +372,7 @@ struct ice_marker_ptype_tcam_section {
>  };
>  
>  #define ICE_MAX_MARKER_PTYPE_TCAMS_IN_BUF                                    \
> -	ICE_MAX_ENTRIES_IN_BUF(                                              \
> -		struct_size((struct ice_marker_ptype_tcam_section *)0, tcam, \
> +	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_marker_ptype_tcam_section,  tcam, \
>  			    1) -                                             \
>  			sizeof(struct ice_marker_ptype_tcam_entry),          \
>  		sizeof(struct ice_marker_ptype_tcam_entry))

Acked-by: Jakub Kicinski <kuba@kernel.org>

but Intel ICE folks please speak up if this has a high chance of
conflicts, I think I've seen some ICE DDP patches flying around :(

