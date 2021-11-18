Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38A4553B9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242908AbhKREVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:21:46 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:39856 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242890AbhKREVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:21:41 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637209120; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9KaZdUGuQot18Jkcjti0iEYdEE3ufjOGhrHqZODW42Y=; b=WQE2w6jFVDJY3E/ohhSXno2I4kty4Hni1kyvPTv/BxCRYwX55lyFsKObKoAqSN6W/3GHjUBc
 PDmj/rXl1OHJ3UqXlBl2bJteayL0O5n1VVhe/zrXgVXB497mxdVgZmg91kPS95vMF7I7FRsS
 c8mu4tryJQl4Qi9swAsn8HEOyhU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6195d420665450d43ae90982 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Nov 2021 04:18:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 840A9C43616; Thu, 18 Nov 2021 04:18:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37FA3C4338F;
        Thu, 18 Nov 2021 04:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 37FA3C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Peter Seiderer <ps.report@gmx.net>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1] ath9k: fix intr_txqs setting
References: <20211116220720.30145-1-ps.report@gmx.net>
        <163713885373.10263.4223864617658431026.kvalo@codeaurora.org>
        <20211117200701.02e5ea74@gmx.net>
Date:   Thu, 18 Nov 2021 06:18:34 +0200
In-Reply-To: <20211117200701.02e5ea74@gmx.net> (Peter Seiderer's message of
        "Wed, 17 Nov 2021 20:07:01 +0100")
Message-ID: <87k0h6w0yt.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Seiderer <ps.report@gmx.net> writes:

> On Wed, 17 Nov 2021 08:47:40 +0000 (UTC), Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Peter Seiderer <ps.report@gmx.net> wrote:
>>
>> > The struct ath_hw member intr_txqs is never reset/assigned outside
>> > of ath9k_hw_init_queues() and with the used bitwise-or in the interrupt
>> > handling ar9002_hw_get_isr() accumulates all ever set interrupt flags.
>> >
>> > Fix this by using a pure assign instead of bitwise-or for the
>> > first line (note: intr_txqs is only evaluated in case ATH9K_INT_TX bit
>> > is set).
>> >
>> > Signed-off-by: Peter Seiderer <ps.report@gmx.net>
>> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> How did you test this? I'm getting way too many ath9k patches which have not
>> been tested on a real device.
>>
>
> Did test it with an Compex WLE200NX 7A card (AR9280) running IBSS mode
> against one older (madwifi) and one newer (ath10k) Atheros card using
> ping and iperf traffic (investigating some performance degradation
> compared to two older cards...., but getting better with the latest
> rc80211_minstrel/rc80211_minstrel_ht changes), checked via printk
> debugging intr_txqs is not cleared when entering ar9002_hw_get_isr(),
> and checked wifi is still working after the change...., can provide more
> info and/or debug traces if needed...

Perfect, thanks!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
