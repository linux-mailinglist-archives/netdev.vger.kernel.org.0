Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFDE336CA8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhCKHAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:00:55 -0500
Received: from z11.mailgun.us ([104.130.96.11]:10088 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231473AbhCKHAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:00:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615446044; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=3+uYjBQK4ORw94HoS3mEIbHBXvqWMu6fhtYX/73Hjuc=; b=oCO1GMaPzOLZE4XRCz5vqesuPt6sXYabDpIUqu/wpBdqXu1fm6smrsMQ8FThbrRCPFIMP6av
 A4wZd7yd7XRSC1p12WQhs8Wcna/s15f6gVqp3nBF9+uofxCCURcoprhzhd1Ni+zVIAup6wa/
 c5wj7kMoawgSrmS8c5kGnMQgStY=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6049bff9b86af9bf23f5b444 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Mar 2021 07:00:09
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 907F9C433CA; Thu, 11 Mar 2021 07:00:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66F14C433CA;
        Thu, 11 Mar 2021 07:00:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66F14C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for Clang
References: <20210305094850.GA141221@embeddedor>
        <871rct67n2.fsf@codeaurora.org> <202103101107.BE8B6AF2@keescook>
Date:   Thu, 11 Mar 2021 09:00:03 +0200
In-Reply-To: <202103101107.BE8B6AF2@keescook> (Kees Cook's message of "Wed, 10
        Mar 2021 11:14:56 -0800")
Message-ID: <878s6uyy30.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Fri, Mar 05, 2021 at 03:40:33PM +0200, Kalle Valo wrote:
>> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>> 
>> > In preparation to enable -Wimplicit-fallthrough for Clang, fix
>> > multiple warnings by replacing /* fall through */ comments with
>> > the new pseudo-keyword macro fallthrough; instead of letting the
>> > code fall through to the next case.
>> >
>> > Notice that Clang doesn't recognize /* fall through */ comments as
>> > implicit fall-through markings.
>> >
>> > Link: https://github.com/KSPP/linux/issues/115
>> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> 
>> It's not cool that you ignore the comments you got in [1], then after a
>> while mark the patch as "RESEND" and not even include a changelog why it
>> was resent.
>> 
>> [1] https://patchwork.kernel.org/project/linux-wireless/patch/d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org/
>
> Hm, this conversation looks like a miscommunication, mainly? I see
> Gustavo, as requested by many others[1], replacing the fallthrough
> comments with the "fallthrough" statement. (This is more than just a
> "Clang doesn't parse comments" issue.)

v1 was clearly rejected by Jes, so sending a new version without any
changelog or comments is not the way to go. The changelog shoud at least
have had "v1 was rejected but I'm resending this again because <insert
reason here>" or something like that to make it clear what's happening.

> This could be a tree-wide patch and not bother you, but Greg KH has
> generally advised us to send these changes broken out. Anyway, this
> change still needs to land, so what would be the preferred path? I think
> Gustavo could just carry it for Linus to merge without bothering you if
> that'd be preferred?

I agree with Greg. Please don't do cleanups like this via another tree
as that just creates more work due to conflicts between the trees, which
is a lot more annoying to deal with than applying few patches. But when
submitting patches please follow the rules, don't cut corners.

Jes, I don't like 'fallthrough' either and prefer the original comment,
but the ship has sailed on this one. Maybe we should just take it?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
