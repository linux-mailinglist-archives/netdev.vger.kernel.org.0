Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CB72DBF8C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgLPLg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:36:27 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:27477 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgLPLg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:36:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608118560; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=hHQtI9K32e1pR5DjxtBhpvWTX4yp5Gz5VV4ep6xNEao=; b=OB1hu2tPt2RcOLDxBRnB7MN/1I8o7f/+kRKERXn8pPqvjWM3Ojz3oJH7pyWKHpAKwbtsuLHO
 vTREp6Vs5tbuucP7voWF9IW1f38zpy3HEH1IUQrCop0g5ZwJpdEJAzs0eyKc0QSfh/CtDx5r
 6vtWSFX56196SQ9tTWi/fdULkLQ=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fd9f105f5e9af65f8c71eec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Dec 2020 11:35:33
 GMT
Sender: pillair=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8D096C433CA; Wed, 16 Dec 2020 11:35:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from Pillair (unknown [137.97.117.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CA757C433CA;
        Wed, 16 Dec 2020 11:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CA757C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Ben Greear'" <greearb@candelatech.com>,
        "'Youghandhar Chintala'" <youghand@codeaurora.org>,
        <johannes@sipsolutions.net>, <ath10k@lists.infradead.org>
Cc:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kuabhs@chromium.org>,
        <dianders@chromium.org>, <briannorris@chromium.org>
References: <20201215172113.5038-1-youghand@codeaurora.org> <18dfa52b-5edd-f737-49c9-f532c1c10ba2@candelatech.com>
In-Reply-To: <18dfa52b-5edd-f737-49c9-f532c1c10ba2@candelatech.com>
Subject: RE: [PATCH 0/3] mac80211: Trigger disconnect for STA during recovery
Date:   Wed, 16 Dec 2020 17:05:22 +0530
Message-ID: <001901d6d39f$8eecc230$acc64690$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLNiuGMY1lcuX+3xoocSa3lALz5vQHQNXuRp/2kY0A=
Content-Language: en-us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Ben Greear <greearb@candelatech.com>
>=20
> On 12/15/20 9:21 AM, Youghandhar Chintala wrote:
> > From: Rakesh Pillai <pillair@codeaurora.org>
> >
> > Currently in case of target hardware restart ,we just reconfig and
> > re-enable the security keys and enable the network queues to start
> > data traffic back from where it was interrupted.
>=20
> Are there any known mac80211 radios/drivers that *can* support =
seamless
> restarts?
>=20
> If not, then just could always enable this feature in mac80211?

I am not aware of any mac80211 target which can restart in a seamless =
manner.
Hence I chose to keep this optional and driver can expose this flag (if =
needed) based on the hardware capability.

Thanks,
Rakesh Pillai.

