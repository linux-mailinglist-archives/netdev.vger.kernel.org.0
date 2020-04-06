Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A33C19F5FE
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgDFMo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:44:56 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:22238 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbgDFMoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:44:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586177095; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=ZW/Dpmb6IvXDVJ1O0supB1w+AoBm5NlO1AUtVw5L2pE=; b=pQlVg50l1fTm5A9nfHolE+iV8X8yt+s5Ap3rImbPzK4wE7e1wu7jUjnAB7/NLSWfqhhmDkEH
 J/BlSGrDxzJbUDtPWxVP/t99OPLtOyeGgOu9ehHMXadEMtd83Lzdx4eOIFDP2S+wPdLn6cYp
 HDrwMM9dJtFDJEn59ihO1FFLXk4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e8b2446.7f5dc860cb90-smtp-out-n01;
 Mon, 06 Apr 2020 12:44:54 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 990AEC44788; Mon,  6 Apr 2020 12:44:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 61ACBC433F2;
        Mon,  6 Apr 2020 12:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 61ACBC433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.schoepfer@ithinx.io,
        Philipp.Berg@liebherr.com, Michael.Weitner@liebherr.com,
        daniel.thompson@linaro.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
Date:   Mon, 06 Apr 2020 15:44:47 +0300
In-Reply-To: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org> (Sumit
        Garg's message of "Mon, 6 Apr 2020 17:51:17 +0530")
Message-ID: <87ftdgokao.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sumit Garg <sumit.garg@linaro.org> writes:

> A race condition leading to a kernel crash is observed during invocation
> of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
> driver built as a loadable module along with a wifi manager in user-space
> waiting for a wifi device (wlanX) to be active.
>
> Sequence diagram for a particular kernel crash scenario:
>
>     user-space  ieee80211_register_hw()  RX IRQ
>     +++++++++++++++++++++++++++++++++++++++++++++
>        |                    |             |
>        |<---wlan0---wiphy_register()      |
>        |----start wlan0---->|             |
>        |                    |<---IRQ---(RX packet)
>        |              Kernel crash        |
>        |              due to unallocated  |
>        |              workqueue.          |
>        |                    |             |
>        |       alloc_ordered_workqueue()  |
>        |                    |             |
>        |              Misc wiphy init.    |
>        |                    |             |
>        |            ieee80211_if_add()    |
>        |                    |             |
>
> As evident from above sequence diagram, this race condition isn't specific
> to a particular wifi driver but rather the initialization sequence in
> ieee80211_register_hw() needs to be fixed. So re-order the initialization
> sequence and the updated sequence diagram would look like:
>
>     user-space  ieee80211_register_hw()  RX IRQ
>     +++++++++++++++++++++++++++++++++++++++++++++
>        |                    |             |
>        |       alloc_ordered_workqueue()  |
>        |                    |             |
>        |              Misc wiphy init.    |
>        |                    |             |
>        |<---wlan0---wiphy_register()      |
>        |----start wlan0---->|             |
>        |                    |<---IRQ---(RX packet)
>        |                    |             |
>        |            ieee80211_if_add()    |
>        |                    |             |
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>

I have understood that no frames should be received until mac80211 calls
struct ieee80211_ops::start:

 * @start: Called before the first netdevice attached to the hardware
 *         is enabled. This should turn on the hardware and must turn on
 *         frame reception (for possibly enabled monitor interfaces.)
   
So I would claim that this is a bug in wcn36xx.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
