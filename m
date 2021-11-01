Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8F4441B70
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhKANDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:03:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:19180 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbhKANDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 09:03:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635771646; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=vhffXgl6XrT5R0iOl/U73G4M8Vp4ByFiaGaz/tHmkzQ=; b=FJIm1e+UynKd/qY5Xb733zvJxrg6pzM9AOMKC5fkBBxP5spShqWK0PNKfD6H9rTXWU+jdIP2
 eQPQu9uCZ/0p/SqhxakDmsjwR4HXkerg+YIrMT8SdB4PqUqbIfidJ+C3+vm3rlRVilJ5m8Ro
 iH3ApcizVnclA0GX1Vq4Z+Ryns0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 617fe4f4648aeeca5cde3a55 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Nov 2021 13:00:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D1F9DC4360D; Mon,  1 Nov 2021 13:00:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D89DCC4338F;
        Mon,  1 Nov 2021 13:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D89DCC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Benjamin Li <benl@squareup.com>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] wcn36xx: fix RX BD rate mapping for 5GHz legacy rates
References: <20211028223131.897548-1-benl@squareup.com>
        <20211028223131.897548-2-benl@squareup.com>
        <b3473977-5bb6-06df-55c3-85f08a29a964@linaro.org>
        <631a3ab4-56d9-5c1d-be53-c885747e3f7b@squareup.com>
Date:   Mon, 01 Nov 2021 15:00:30 +0200
In-Reply-To: <631a3ab4-56d9-5c1d-be53-c885747e3f7b@squareup.com> (Benjamin
        Li's message of "Thu, 28 Oct 2021 17:39:58 -0700")
Message-ID: <8735og2fpt.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> writes:

> On 10/28/21 5:30 PM, Bryan O'Donoghue wrote:
>> On 28/10/2021 23:31, Benjamin Li wrote:
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sta=
tus.rate_idx >=3D sband->n_bitrates) {
>> This fix was applied because we were getting a negative index
>>=20
>> If you want to remove that, you'll need to do something about this
>>=20
>> status.rate_idx -=3D 4;
>
> Hmm... so you're saying there's a FW bug where sometimes we get
> bd->rate_id =3D 0-7 (leading to status.rate_idx =3D 0-3) on a 5GHz
> channel?
>
> static const struct wcn36xx_rate wcn36xx_rate_table[] =3D {
>     /* 11b rates */
>     {  10, 0, RX_ENC_LEGACY, 0, RATE_INFO_BW_20 },
>     {  20, 1, RX_ENC_LEGACY, 0, RATE_INFO_BW_20 },
>     {  55, 2, RX_ENC_LEGACY, 0, RATE_INFO_BW_20 },
>     { 110, 3, RX_ENC_LEGACY, 0, RATE_INFO_BW_20 },
>
>     /* 11b SP (short preamble) */
>     {  10, 0, RX_ENC_LEGACY, RX_ENC_FLAG_SHORTPRE, RATE_INFO_BW_20 },
>     {  20, 1, RX_ENC_LEGACY, RX_ENC_FLAG_SHORTPRE, RATE_INFO_BW_20 },
>     {  55, 2, RX_ENC_LEGACY, RX_ENC_FLAG_SHORTPRE, RATE_INFO_BW_20 },
>     { 110, 3, RX_ENC_LEGACY, RX_ENC_FLAG_SHORTPRE, RATE_INFO_BW_20 },
>
> It sounds like we should WARN and drop the frame in that case. If
> you agree I'll send a v2.

BTW, please avoid using WARN() family of functions in the data path as
that can cause host crashes due to too much spamming in the logs. A some
kind of ratelimited version of an error message is much safer. For
example ath11k_warn() is ratelimited, maybe wcn36xx_warn() should be as
well?

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
