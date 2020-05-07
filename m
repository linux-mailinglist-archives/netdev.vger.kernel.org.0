Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1AA1C9840
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgEGRrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:47:20 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:11355 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgEGRrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 13:47:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588873639; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=QzBgMVXJ1sTXxKTX794AyS1imRQfs8NyQneN9n8UKRE=; b=SGQkJHvpoSTmwEi3GIpgZQfIlRxLZC6LuY2M6HWfxzkmKZCNLNvw+Uq+gncE9X6bMCse4qbY
 GIosssqVyIEx+/uyETR67O8MFbReXYT8TfcceOZESe9dkPPA5LNVUZvpz7zgUicY/ATaZV33
 wWnBdtdWWgLJYag6y2i2r/dhb3s=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb449a7.7f730b49ed18-smtp-out-n03;
 Thu, 07 May 2020 17:47:19 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E025AC433BA; Thu,  7 May 2020 17:47:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6DD70C433D2;
        Thu,  7 May 2020 17:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6DD70C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wcn36xx@lists.infradead.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] wcn36xx: Fix error handling path in wcn36xx_probe()
References: <5345c72b-8d18-74ba-a6fa-bdc0f7dfb4c3@web.de>
Date:   Thu, 07 May 2020 20:47:12 +0300
In-Reply-To: <5345c72b-8d18-74ba-a6fa-bdc0f7dfb4c3@web.de> (Markus Elfring's
        message of "Thu, 7 May 2020 19:39:17 +0200")
Message-ID: <874ksr4oyn.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Markus Elfring <Markus.Elfring@web.de> writes:

> =E2=80=A6
>> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> =E2=80=A6
>> @@ -1359,6 +1359,8 @@ static int wcn36xx_probe(struct platform_device *p=
dev)
>>  out_unmap:
>>  	iounmap(wcn->ccu_base);
>>  	iounmap(wcn->dxe_base);
>> +out_channel:
>> +	rpmsg_destroy_ept(wcn->smd_channel);
>>  out_wq:
>>  	ieee80211_free_hw(hw);
>>  out_err:
>
> How do you think about to use the label =E2=80=9Cout_destroy_ept=E2=80=9D?

Yeah, that's better. I'll change it in the pending branch before I
commit.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
