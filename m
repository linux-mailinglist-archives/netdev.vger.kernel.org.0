Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312204679C8
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 15:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381558AbhLCO4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 09:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbhLCO4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 09:56:23 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D309C061751;
        Fri,  3 Dec 2021 06:52:58 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8608:6e64:956a:daea:cf2f])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1B3Eqn8e033666
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 15:52:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638543169; bh=0cRGgZgMtLbTFNIr5ua2q8OeGBtFQrzP3yDen7RjQKs=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=VkVnDzMhPxTS8GcsWZjDDBHGV+SMKQtkE1k2EXR6JxOxcxuTDZ+kqpCdXdbe+EMIo
         ahya8xHVq/YiXHlEBYowVmcojQW8TVgUSaoKiZuV8G5TAe6ymQ3vYgxOfVmhopdoU7
         50lCk4OFOxpnTx2TXmxnX3ICSzsYLYA+5xzfyD2g=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mt9vc-001jj7-T7; Fri, 03 Dec 2021 15:52:48 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Organization: m
References: <20211202143437.1411410-1-lee.jones@linaro.org>
Date:   Fri, 03 Dec 2021 15:52:48 +0100
In-Reply-To: <20211202143437.1411410-1-lee.jones@linaro.org> (Lee Jones's
        message of "Thu, 2 Dec 2021 14:34:37 +0000")
Message-ID: <87wnklivun.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:

> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 24753a4da7e60..e303b522efb50 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u=
32 new_tx)
>  		min =3D ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb=
_cdc_ncm_nth32);
>=20=20
>  	max =3D min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.d=
wNtbOutMaxSize));
> +	if (max =3D=3D 0)
> +		max =3D CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
>=20=20
>  	/* some devices set dwNtbOutMaxSize too low for the above default */
>  	min =3D min(min, max);

I believe this is the best possible fix, considering the regressions
anything stricter might cause.

We know of at least one MBIM device where dwNtbOutMaxSize is as low as
2048.

According to the MBIM spec, the minimum and default value for
wMaxSegmentSize is also 2048.  This implies that the calculated "min"
value is at least 2076, which is why we need that odd looking

  min =3D min(min, max);

So let's just fix this specific zero case without breaking the
non-conforming devices.


Reviewed-by: Bj=C3=B8rn Mork <bjorn@mork.no>
