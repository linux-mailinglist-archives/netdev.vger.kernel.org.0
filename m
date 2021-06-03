Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EAC399E30
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 11:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFCJzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 05:55:46 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26015 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhFCJzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 05:55:45 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622714041; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=bxgawjv87QE59ZmPqEifJGZL7D4lbNfMfA4fiLSYN44=; b=ak7L0pQRv9VxeJn4cpWZVXYfypJdvmGZSgSv9mfjkyALVuy4/eMx70ZF516P2NzL+7ZHxRu7
 M33X51zoAE8aEVEWCkuqMPrwSeUvVk5h1Wfqs+QS0aHKL/5YiLH8SxfdOP0zY0geB0DSLVFB
 2gnS+AFxwGF6+Mf1IjFugyvJm38=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 60b8a6b0f726fa4188bded5b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Jun 2021 09:53:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39F67C433F1; Thu,  3 Jun 2021 09:53:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 464BFC433D3;
        Thu,  3 Jun 2021 09:53:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 464BFC433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: avoid parsing short RX packet
References: <20210511071926.8951-1-ihuguet@redhat.com>
        <CACT4oufLD3Fa5J=y5dz1LjdCVa2pZ=N1SB141DOcebeMYj8-Yw@mail.gmail.com>
Date:   Thu, 03 Jun 2021 12:53:48 +0300
In-Reply-To: <CACT4oufLD3Fa5J=y5dz1LjdCVa2pZ=N1SB141DOcebeMYj8-Yw@mail.gmail.com>
        (=?utf-8?B?IsONw7FpZ28=?= Huguet"'s message of "Tue, 1 Jun 2021 10:57:41
 +0200")
Message-ID: <874kef1dg3.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C3=8D=C3=B1igo Huguet <ihuguet@redhat.com> writes:

> On Tue, May 11, 2021 at 9:19 AM =C3=8D=C3=B1igo Huguet <ihuguet@redhat.co=
m> wrote:
>>
>> One USB data buffer can contain multiple received network
>> packets. If that's the case, they're processed this way:
>> 1. Original buffer is cloned
>> 2. Original buffer is trimmed to contain only the first
>>    network packet
>> 3. This first network packet is passed to network stack
>> 4. Cloned buffer is trimmed to eliminate the first network
>>    packet
>> 5. Repeat with the cloned buffer until there are no more
>>    network packets inside
>>
>> However, if the space remaining in original buffer after
>> the first network packet is not enough to contain at least
>> another network packet descriptor, it is not cloned.
>>
>> The loop parsing this packets ended if remaining space =3D=3D 0.
>> But if the remaining space was > 0 but < packet descriptor
>> size, another iteration of the loop was done, processing again
>> the previous packet because cloning didn't happen. Moreover,
>> the ownership of this packet had been passed to network
>> stack in the previous iteration.
>>
>> This patch ensures that no extra iteration is done if the
>> remaining size is not enough for one packet, and also avoid
>> the first iteration for the same reason.
>>
>> Probably this doesn't happen in practice, but can happen
>> theoretically.
>>
>> Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
>
> About 3 weeks ago I sent this patch, but received no response. Any
> feedback would be appreciated.

Maintainers are sometimes so busy that review takes extra long, but you
can always check the state in patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#checking_state_of_patches_from_patchwork

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
