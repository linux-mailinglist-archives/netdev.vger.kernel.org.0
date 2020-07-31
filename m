Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BC3234C15
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGaUTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgGaUS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 16:18:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 390A7208E4;
        Fri, 31 Jul 2020 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596226739;
        bh=XkBtbALKKrVNXU2T8XMtfr5y3a31WmhOC+6LIXG7Jis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GM99/8E6TU+0C7JyU1crOeGmIVCiXxWV/oR+lNleDrk12a+WDOjSQxNC9sIlmVBum
         HZlzL7rTyjQZg137VmRnYWirZgllalefABGZS0WrHVIPAyup0slk/FkTnewe3u2osy
         YASBIT0mbSqV873l6wBn1pR01HtYMvd2VMBKhAcM=
Date:   Fri, 31 Jul 2020 13:18:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 03/11] sfc_ef100: read Design Parameters at
 probe time
Message-ID: <20200731131857.41b0f32a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <48b1fedf-0863-8fab-7f7a-e2df6946b764@solarflare.com>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
        <48b1fedf-0863-8fab-7f7a-e2df6946b764@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 13:58:35 +0100 Edward Cree wrote:
> +	default:
> +		/* Host interface says "Drivers should ignore design parameters
> +		 * that they do not recognise."
> +		 */
> +		netif_info(efx, probe, efx->net_dev,
> +			   "Ignoring unrecognised design parameter %u\n",
> +			   reader->type);

Is this really important enough to spam the logs with?

> +		return 0;
> +	}
> +}
> +
> +static int ef100_check_design_params(struct efx_nic *efx)
> +{
> +	struct ef100_tlv_state reader = {};
> +	u32 total_len, offset = 0;
> +	efx_dword_t reg;
> +	int rc = 0, i;
> +	u32 data;
> +
> +	efx_readd(efx, &reg, ER_GZ_PARAMS_TLV_LEN);
> +	total_len = EFX_DWORD_FIELD(reg, EFX_DWORD_0);
> +	netif_dbg(efx, probe, efx->net_dev, "%u bytes of design parameters\n",
> +		  total_len);
> +	while (offset < total_len) {
> +		efx_readd(efx, &reg, ER_GZ_PARAMS_TLV + offset);
> +		data = EFX_DWORD_FIELD(reg, EFX_DWORD_0);
> +		for (i = 0; i < sizeof(data); i++) {
> +			rc = ef100_tlv_feed(&reader, data);
> +			/* Got a complete value? */
> +			if (!rc && reader.state == EF100_TLV_TYPE)
> +				rc = ef100_process_design_param(efx, &reader);
> +			if (rc)
> +				goto out;
> +			data >>= 8;
> +			offset++;
> +		}
> +	}

Should you warn if the TLV stream ends half-way through an entry?

> +out:
> +	return rc;
> +}
