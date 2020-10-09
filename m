Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F64F289170
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbgJISvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:51:36 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:22472 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387872AbgJISve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 14:51:34 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602269494; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=eFkoSUOe1ldRGerTaytVJV+acS/JyrUEN1mPJ4njhYQ=; b=ffHBKXwRBlcl1x1qr1wa9iDGAXNDE3QxI1LG3J8T4r3xq+AypV67lQ7UuzdDlZnNrlUaaGRw
 NwnIGMk5cgOjrguhvQ1KxPWSOz25PaebjKdQkkHvjll1XgVdXxnREnZjHE5BM7fzVoEcVTrt
 NrLmuwZelW6KkGov9diD6NN6AVw=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5f80b11bef891f1ee2fe67e9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 09 Oct 2020 18:51:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5EEE9C43382; Fri,  9 Oct 2020 18:51:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B93F0C433C9;
        Fri,  9 Oct 2020 18:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B93F0C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/8] staging: wfx: check memory allocation
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
        <20201009171307.864608-3-Jerome.Pouiller@silabs.com>
Date:   Fri, 09 Oct 2020 21:51:01 +0300
In-Reply-To: <20201009171307.864608-3-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Fri, 9 Oct 2020 19:13:01 +0200")
Message-ID: <874kn31be2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Smatch complains:
>
>    main.c:228 wfx_send_pdata_pds() warn: potential NULL parameter derefer=
ence 'tmp_buf'
>    227          tmp_buf =3D kmemdup(pds->data, pds->size, GFP_KERNEL);
>    228          ret =3D wfx_send_pds(wdev, tmp_buf, pds->size);
>                                          ^^^^^^^
>    229          kfree(tmp_buf);
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
> index df11c091e094..a8dc2c033410 100644
> --- a/drivers/staging/wfx/main.c
> +++ b/drivers/staging/wfx/main.c
> @@ -222,12 +222,18 @@ static int wfx_send_pdata_pds(struct wfx_dev *wdev)
>  	if (ret) {
>  		dev_err(wdev->dev, "can't load PDS file %s\n",
>  			wdev->pdata.file_pds);
> -		return ret;
> +		goto err1;
>  	}
>  	tmp_buf =3D kmemdup(pds->data, pds->size, GFP_KERNEL);
> +	if (!tmp_buf) {
> +		ret =3D -ENOMEM;
> +		goto err2;
> +	}
>  	ret =3D wfx_send_pds(wdev, tmp_buf, pds->size);
>  	kfree(tmp_buf);
> +err2:
>  	release_firmware(pds);
> +err1:
>  	return ret;
>  }

A minor style issue but using more descriptive error labels make the
code more readable and maintainable, especially in a bigger function.
For example, err2 could be called err_release_firmware.

And actually err1 could be removed and the goto replaced with just
"return ret;". Then err2 could be renamed to a simple err.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
