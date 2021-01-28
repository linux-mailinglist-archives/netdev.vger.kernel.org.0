Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859E43070C1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 09:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhA1IKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 03:10:42 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:37989 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhA1IJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 03:09:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611821358; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/o88EhhP0c4dq6yUyZ8eKopV10aGp5VPu/c4f/R2ei8=;
 b=u3kUXs89sUKHRIlOC+6exM+7LSRGEKO8SVtx9nHS7pSHIjfhKlbq/0eig3M2selVNC8jtfpd
 RDTpNFJMh0ag+gNePU0yf2sayDpoJ55SoptCnrCWSjLs7MfY3Jzr2gy4EwdSjJtutWR8IhFR
 O0Y4pVkTj7Xwokn8CIXUAUeD+qs=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6012710fe32560064279c7a4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Jan 2021 08:08:47
 GMT
Sender: youghand=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C921BC43462; Thu, 28 Jan 2021 08:08:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: youghand)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1F1EBC433CA;
        Thu, 28 Jan 2021 08:08:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 28 Jan 2021 13:38:46 +0530
From:   youghand@codeaurora.org
To:     Felix Fietkau <nbd@nbd.name>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
In-Reply-To: <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
References: <20201215172352.5311-1-youghand@codeaurora.org>
 <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
Message-ID: <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
X-Sender: youghand@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-15 23:10, Felix Fietkau wrote:
> On 2020-12-15 18:23, Youghandhar Chintala wrote:
>> Currently in case of target hardware restart, we just reconfig and
>> re-enable the security keys and enable the network queues to start
>> data traffic back from where it was interrupted.
>> 
>> Many ath10k wifi chipsets have sequence numbers for the data
>> packets assigned by firmware and the mac sequence number will
>> restart from zero after target hardware restart leading to mismatch
>> in the sequence number expected by the remote peer vs the sequence
>> number of the frame sent by the target firmware.
>> 
>> This mismatch in sequence number will cause out-of-order packets
>> on the remote peer and all the frames sent by the device are dropped
>> until we reach the sequence number which was sent before we restarted
>> the target hardware
>> 
>> In order to fix this, we trigger a sta disconnect, for the targets
>> which expose this corresponding wiphy flag, in case of target hw
>> restart. After this there will be a fresh connection and thereby
>> avoiding the dropping of frames by remote peer.
>> 
>> The right fix would be to pull the entire data path into the host
>> which is not feasible or would need lots of complex changes and
>> will still be inefficient.
> How about simply tracking which tids have aggregation enabled and send
> DELBA frames for those after the restart?
> It would mean less disruption for affected stations and less ugly hacks
> in the stack for unreliable hardware.
> 
> - Felix

Hi Felix,

We did try to send an ADDBA frame to the AP once the SSR happened. The 
AP ack’ed the frame and the new BA session with renewed sequence number 
was established. But still, the AP did not respond to the ping requests 
with the new sequence number. It did not respond until one of the two 
happened.
1.	The sequence number was more than the sequence number that DUT had 
used before SSR happened
2.	DUT disconnected and then reconnected.
The other option is to send a DELBA frame to the AP and make the AP also 
force to establish the BA session from its side. This we feel can have 
some interoperability issues as some of the AP’s may not honour the 
DELBA frame and will continue to use the earlier BA session that it had 
established. Given that re-negotiating the BA session is prone to IOT 
issues, we feel that it would be good to go with the 
Disconnect/Reconnect solution which is foolproof and will work in all 
scenarios.

Regards,
Youghandhar
