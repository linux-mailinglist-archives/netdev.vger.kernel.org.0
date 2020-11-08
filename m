Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89DA2AAAA9
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 12:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgKHLVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 06:21:55 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:15806 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKHLVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Nov 2020 06:21:55 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604834514; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=+a2nw8TOnWhGkjW2VdGmo04dSuvzksPHyNngfg5RaIM=; b=JBroZhUh/jHG/QNRITWzFahR3OxBqT6g5aK/mNYX5afjIXm4JBdUxxaKPbQRPx480e1cjFUO
 IbiH3qIzBFKAIDKo7H6LM6iX/V2b/9JaxAQhkZQ78Og+illqo26gHz0lKzKQdq4CpvpcN+Sp
 TxkOUzKSxXuAbUFSUozfRr9gaeQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fa7d4be9d6b206d94f27085 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 08 Nov 2020 11:21:34
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BCCD7C43385; Sun,  8 Nov 2020 11:21:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44852C433C8;
        Sun,  8 Nov 2020 11:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 44852C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 00/28] ndo_ioctl rework
References: <20201106221743.3271965-1-arnd@kernel.org>
        <20201107160612.2909063a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Sun, 08 Nov 2020 13:21:24 +0200
In-Reply-To: <20201107160612.2909063a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Sat, 7 Nov 2020 16:06:12 -0800")
Message-ID: <87tuu05c23.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

>> For the wireless drivers, removing the old drivers
>> instead of just the dead code might be an alternative, depending
>> on whether anyone thinks there might still be users.
>
> Dunno if you want to dig into removal with a series like this, 
> anything using ioctls will be pretty old (with the exception 
> of what you separated into ndo_eth_ioctl). You may get bogged 
> down.

I would very much like to get rid of unused ancient wireless drivers but
the problem is that it's next to impossible to know if someone still
uses a driver, or if the driver is even working. For example, few months
back I suggested removing one driver which I thought to be completely
unused (forgot already the name of the driver) and to my big surprise
there was still a user, and he reported it working with a recent kernel
release.

So I don't know what to do. Should we try adding a warning like below? :)

  "This ancient driver will be removed from the kernel in 2022, but if
   it still works send report to <...@...> to avoid the removal."

How do other subsystems handle ancient drivers?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
