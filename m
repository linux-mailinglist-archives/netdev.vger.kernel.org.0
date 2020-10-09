Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A17289177
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbgJISw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:52:56 -0400
Received: from z5.mailgun.us ([104.130.96.5]:30780 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388075AbgJISwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 14:52:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602269574; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=C2ixXtJpszCvMiXVMMBC/Lmu1IAK2pnWzYoTtv0TqiQ=; b=LzsLKldguYco0R5oZxxYAPlw5SRsDcZ4wzUq+6NxHYcKYk6bokMs/Pq6nwL5HP4MzNan6m/f
 SnVsebsN2GtO99l/v4YfftGwmL8WQDoy3lDe3wkimWRS3qcEC/16XMcz3IeTiMM9RW6IDKbn
 fjCqo15PVI2ir3zwi0w1dq3r35M=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f80b184aad2c3cd1c01b3ec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 09 Oct 2020 18:52:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F0ECFC43385; Fri,  9 Oct 2020 18:52:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 475DEC433C9;
        Fri,  9 Oct 2020 18:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 475DEC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/8] staging: wfx: standardize the error when vif does not exist
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
        <20201009171307.864608-4-Jerome.Pouiller@silabs.com>
Date:   Fri, 09 Oct 2020 21:52:47 +0300
In-Reply-To: <20201009171307.864608-4-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Fri, 9 Oct 2020 19:13:02 +0200")
Message-ID: <87zh4vz0xs.fsf@codeaurora.org>
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
>    drivers/staging/wfx/hif_rx.c:177 hif_scan_complete_indication() warn: =
potential NULL parameter dereference 'wvif'
>    drivers/staging/wfx/data_tx.c:576 wfx_flush() warn: potential NULL par=
ameter dereference 'wvif'
>
> Indeed, if the vif id returned by the device does not exist anymore,
> wdev_to_wvif() could return NULL.
>
> In add, the error is not handled uniformly in the code, sometime a
> WARN() is displayed but code continue, sometime a dev_warn() is
> displayed, sometime it is just not tested, ...
>
> This patch standardize that.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/data_tx.c |  5 ++++-
>  drivers/staging/wfx/hif_rx.c  | 34 ++++++++++++++++++++++++----------
>  drivers/staging/wfx/sta.c     |  4 ++++
>  3 files changed, 32 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
> index b4d5dd3d2d23..8db0be08daf8 100644
> --- a/drivers/staging/wfx/data_tx.c
> +++ b/drivers/staging/wfx/data_tx.c
> @@ -431,7 +431,10 @@ static void wfx_skb_dtor(struct wfx_vif *wvif, struc=
t sk_buff *skb)
>  			      sizeof(struct hif_req_tx) +
>  			      req->fc_offset;
>=20=20
> -	WARN_ON(!wvif);
> +	if (!wvif) {
> +		pr_warn("%s: vif associated with the skb does not exist anymore\n", __=
func__);
> +		return;
> +	}

I'm not really a fan of using function names in warning or error
messages as it clutters the log. In debug messages I think they are ok.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
