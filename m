Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BB92CB2AC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgLBCOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727353AbgLBCOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 21:14:01 -0500
Date:   Tue, 1 Dec 2020 18:13:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606875201;
        bh=ie0BsMb3jjIKlAJ/vjltbOgdzImfWHE3oCw8CU6F4ek=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9iWUGmp06RyOi1Vc5GpmICkIoIfk/iTu+38PSABQxzl6iGDOGzmLvEGFpB0vPGNq
         3CYxOoaBGolf+YNwXetNqRYt1243itVPYNA7OKUAlZ3H+aQ89eAqklxrN8QnyHMgoT
         8R2b84K2t7NA0U8/A1Vw3NALSM44Y7/pn3Ijk4j0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: ipa: add support for inline checksum
 offload
Message-ID: <20201201181319.41091a37@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201004143.27569-3-elder@linaro.org>
References: <20201201004143.27569-1-elder@linaro.org>
        <20201201004143.27569-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 18:41:43 -0600 Alex Elder wrote:
> Starting with IPA v4.5, IP payload checksum offload is implemented
> differently.
> 
> Prior to v4.5, the IPA hardware appends an rmnet_map_dl_csum_trailer
> structure to each packet if checksum offload is enabled in the
> download direction (modem->AP).  In the upload direction (AP->modem)
> a rmnet_map_ul_csum_header structure is prepended before each sent
> packet.
> 
> Starting with IPA v4.5, checksum offload is implemented using a
> single new rmnet_map_v5_csum_header structure which sits between
> the QMAP header and the packet data.  The same header structure
> is used in both directions.
> 
> The new header contains a header type (CSUM_OFFLOAD); a checksum
> flag; and a flag indicating whether any other headers follow this
> one.  The checksum flag indicates whether the hardware should
> compute (and insert) the checksum on a sent packet.  On a received
> packet the checksum flag indicates whether the hardware confirms the
> checksum value in the payload is correct.
> 
> To function, the rmnet driver must also add support for this new
> "inline" checksum offload.  The changes implementing this will be
> submitted soon.

We don't usually merge half of a feature. Why not wait until all
support is in place?

Do I understand right that it's rmnet that will push the csum header?
This change seems to only reserve space for it and request the feature
at init..

> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 27f543b6780b1..1a4749f7f03e6 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -434,33 +434,63 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
>  static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
>  {
>  	u32 offset = IPA_REG_ENDP_INIT_CFG_N_OFFSET(endpoint->endpoint_id);
> +	enum ipa_cs_offload_en enabled;
>  	u32 val = 0;
>  
>  	/* FRAG_OFFLOAD_EN is 0 */
>  	if (endpoint->data->checksum) {
> +		enum ipa_version version = endpoint->ipa->version;
> +
>  		if (endpoint->toward_ipa) {
>  			u32 checksum_offset;
>  
> -			val |= u32_encode_bits(IPA_CS_OFFLOAD_UL,
> -					       CS_OFFLOAD_EN_FMASK);
>  			/* Checksum header offset is in 4-byte units */
>  			checksum_offset = sizeof(struct rmnet_map_header);
>  			checksum_offset /= sizeof(u32);
>  			val |= u32_encode_bits(checksum_offset,
>  					       CS_METADATA_HDR_OFFSET_FMASK);
> +
> +			enabled = version < IPA_VERSION_4_5
> +					? IPA_CS_OFFLOAD_UL
> +					: IPA_CS_OFFLOAD_INLINE;
>  		} else {
> -			val |= u32_encode_bits(IPA_CS_OFFLOAD_DL,
> -					       CS_OFFLOAD_EN_FMASK);
> +			enabled = version < IPA_VERSION_4_5
> +					? IPA_CS_OFFLOAD_DL
> +					: IPA_CS_OFFLOAD_INLINE;
>  		}
>  	} else {
> -		val |= u32_encode_bits(IPA_CS_OFFLOAD_NONE,
> -				       CS_OFFLOAD_EN_FMASK);
> +		enabled = IPA_CS_OFFLOAD_NONE;
>  	}
> +	val |= u32_encode_bits(enabled, CS_OFFLOAD_EN_FMASK);
>  	/* CS_GEN_QMB_MASTER_SEL is 0 */
>  
>  	iowrite32(val, endpoint->ipa->reg_virt + offset);
>  }
>  
> +static u32
> +ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
> +{
> +	u32 header_size = sizeof(struct rmnet_map_header);
> +
> +	/* ipa_assert(endpoint->data->qmap); */
> +
> +	/* We might supply a checksum header after the QMAP header */
> +	if (endpoint->data->checksum) {
> +		if (version < IPA_VERSION_4_5) {
> +			size_t size = sizeof(struct rmnet_map_ul_csum_header);
> +
> +			/* Checksum header inserted for AP TX endpoints */
> +			if (endpoint->toward_ipa)
> +				header_size += size;
> +		} else {
> +			/* Checksum header is used in both directions */
> +			header_size += sizeof(struct rmnet_map_v5_csum_header);
> +		}
> +	}
> +
> +	return header_size;
> +}
