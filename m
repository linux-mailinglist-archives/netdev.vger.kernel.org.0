Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5E1DE488
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 12:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgEVKe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 06:34:26 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:14546 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728362AbgEVKe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 06:34:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590143665; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=re0ym4TtgaTt3T7R6eYWSsdnKHzfzFMDeaeUuE8IlSA=; b=dXQ/NUoYDdEwFxKoFpNXVnEOt0R1+TocpFVyoRJdh67GIGu/MQwz/0kEbJYWIE6Hcg8E79Tv
 zC7Tu81XncvJmWI59IKgk3q98lxusXEn1AZmE6rX8L6/cJ/M9z7qEhwK9gGClU6cGbvZdm1z
 K3s6YJLbtzkr4R1KSU4/9wSue0k=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec7aab1.7faa326c2e30-smtp-out-n02;
 Fri, 22 May 2020 10:34:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 56121C43387; Fri, 22 May 2020 10:34:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D6CDC433C8;
        Fri, 22 May 2020 10:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D6CDC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "\<netdev\@vger.kernel.org\>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath9k: release allocated buffer if timed out
References: <20190906185931.19288-1-navid.emamdoost@gmail.com>
        <CA+ASDXMnp-GTkrT7B5O+dtopJUmGBay=Tn=-nf1LW1MtaVOr+w@mail.gmail.com>
        <878shwtiw3.fsf@kamboji.qca.qualcomm.com>
        <CA+ASDXOgechejxzN4-xPcuTW-Ra7z9Z6EeiQ4wMrEowZc-p+uA@mail.gmail.com>
        <CA+ASDXM6w-t85hZWcbTqTBA8aye0oka3Nw5YYZH2LqixO-PJzg@mail.gmail.com>
Date:   Fri, 22 May 2020 13:34:18 +0300
In-Reply-To: <CA+ASDXM6w-t85hZWcbTqTBA8aye0oka3Nw5YYZH2LqixO-PJzg@mail.gmail.com>
        (Brian Norris's message of "Wed, 20 May 2020 13:59:20 -0700")
Message-ID: <87sgfs9s2d.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Wed, May 13, 2020 at 12:02 PM Brian Norris <briannorris@chromium.org> wrote:
>>
>> On Wed, May 13, 2020 at 12:05 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>> > Actually it's already reverted in -next, nobody just realised that it's
>> > a regression from commit 728c1e2a05e4:
>> >
>> > ced21a4c726b ath9k: Fix use-after-free Read in htc_connect_service
>>
>> Nice.
>>
>> > v5.8-rc1 should be the first release having the fix.
>>
>> So I guess we have to wait until 5.8-rc1 (when this lands in mainline)
>> to send this manually to stable@vger.kernel.org?

Yeah, following Option 2:

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

> For the record, there are more reports of this, if I'm reading them right:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=207797

Thanks for the followup, this case is a good example why small cleanup
patches are not always that simple and easy as some people claim :)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
