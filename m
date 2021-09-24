Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042EE416EB2
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245161AbhIXJQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:16:31 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:63342 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244422AbhIXJQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:16:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632474889; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=8s7VVl139a3i809ATKepHde+IYqg4+OOS/K41mjPwTY=;
 b=t8elIktd4fNKqFnoiCoRxsO0Cuaj5vaT9RJmf33DRVZQnOk6c5Y4YgZ+rlYui8jUvNxkEZQ+
 BkYD9Hnu3zNmYQs1AdJNk3GhETpRoDeFpVb+l9G37jl8NpCmwGYW2LBFHo3OBFN/9wBnY5Yh
 2/V0JeNHHmd73qDyvFJr2mWjcWg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 614d96c644830700e1b5ee2a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 09:13:42
 GMT
Sender: youghand=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B6A5CC43617; Fri, 24 Sep 2021 09:13:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: youghand)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 248A1C4338F;
        Fri, 24 Sep 2021 09:13:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 24 Sep 2021 14:43:42 +0530
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Abhishek Kumar <kuabhs@chromium.org>, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
In-Reply-To: <5826123db4731bde01594212101ed5dbbea4d54f.camel@sipsolutions.net>
References: <20201215172352.5311-1-youghand@codeaurora.org>
 <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name>
 <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
 <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
 (sfid-20210205_225202_513086_43C9BBC9)
 <d5cfad1543f31b3e0d8e7a911d3741f3d5446c57.camel@sipsolutions.net>
 <66ba0f836dba111b8c7692f78da3f079@codeaurora.org>
 <5826123db4731bde01594212101ed5dbbea4d54f.camel@sipsolutions.net>
Message-ID: <30fa98673ad816ec849f34853c9e1257@codeaurora.org>
X-Sender: youghand@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes

We thought sending the delba would solve the problem as earlier thought 
but the actual problem is with TX PN in a secure mode.
It is not because of delba that the Seq number and TX PN are reset to 
zero.
It’s because of the HW restart, these parameters are reset to zero.
Since FW/HW is the one which decides the TX PN, when it goes through 
SSR, all these parameters are reset.
The other peer say an AP, it does not know anything about the SSR on the 
peer device. It expects the next TX PN to be current PN + 1.
Since TX PN starts from zero after SSR, PN check at AP will fail and it 
will silently drop all the packets.

Regards,
Youghandhar

On 2021-09-24 13:09, Johannes Berg wrote:
> On Fri, 2021-09-24 at 13:07 +0530, Youghandhar Chintala wrote:
>> Hi Johannes and felix,
>> 
>> We have tested with DELBA experiment during post SSR, DUT packet seq
>> number and tx pn is resetting to 0 as expected but AP(Netgear R8000) 
>> is
>> not honoring the tx pn from DUT.
>> Whereas when we tested with DELBA experiment by making Linux android
>> device as SAP and DUT as STA with which we don’t see any issue. Ping 
>> got
>> resumed post SSR without disconnect.
> 
> Hm. That's a lot of data, and not a lot of explanation :)
> 
> I don't understand how DelBA and PN are related?
> 
> johannes

Regards,
Youghandhar
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member
of Code Aurora Forum, hosted by The Linux Foundation
