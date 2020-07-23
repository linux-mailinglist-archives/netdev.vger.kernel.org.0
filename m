Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E1F22A782
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgGWGKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:10:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20763 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgGWGJz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 02:09:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595484595; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=VAXvWnCgke+eKG8vJGJNAGB2T9TdQIXZ3SC3sX6v7dA=;
 b=nyhJJGFIY3QNJ04C63wYIjJDXaKBMPO2toLYmlZcVlTtyInnHgKUDK5quKva4DarlnlK8xbJ
 cVtnA0DHNkQXzKBQSV146xczLQkGAC2816OFrHgRTENs2PK4qxl6sCyqXt1/R1du449sZHCl
 eNqOS/Rxfk2lztlMsyymjMCvvcg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f1929afed710aec621f7a85 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 23 Jul 2020 06:09:51
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 28D39C433B1; Thu, 23 Jul 2020 06:09:50 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D63BAC433CB;
        Thu, 23 Jul 2020 06:09:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 22 Jul 2020 23:09:49 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Rakesh Pillai <pillair@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, dianders@chromium.org,
        evgreen@chromium.org, kuba@kernel.org, davem@davemloft.net,
        kvalo@codeaurora.org
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
In-Reply-To: <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
 <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
 <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net>
 <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name>
Message-ID: <cd705bfc39721d5738fe1ee3d806a131@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-22 06:00, Felix Fietkau wrote:
> On 2020-07-22 14:55, Johannes Berg wrote:
>> On Wed, 2020-07-22 at 14:27 +0200, Felix Fietkau wrote:
>> 
>>> I'm considering testing a different approach (with mt76 initially):
>>> - Add a mac80211 rx function that puts processed skbs into a list
>>> instead of handing them to the network stack directly.
>> 
>> Would this be *after* all the mac80211 processing, i.e. in place of 
>> the
>> rx-up-to-stack?
> Yes, it would run all the rx handlers normally and then put the
> resulting skbs into a list instead of calling netif_receive_skb or
> napi_gro_frags.
> 
Felix,

This seems like split & batch processing. In past (ath9k), we observed 
some
behavioral differences between netif_rx and netif_receive_skb. The 
intermediate
queue in netif_rx changed not just performance but also time sensitive 
application
data. Agree that wireless stack processing might be heavier than 
ethernet packet
processing. If the hardware supports rx decap offload, NAPI processing 
shouldn't be
an issue. right?

-Rajkumar
