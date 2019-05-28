Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8732C8D2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfE1OaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:30:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfE1OaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:30:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9B23760A4E; Tue, 28 May 2019 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559053806;
        bh=x73gs11UqeyquhhHifaz+Y5m6QpD+Y2yC03QFMfrKZI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZkwvxI+hhmBeuzoh8EWA5ubIbQ2KPmdcR7iFPdi+DstAkeRPW8P7bXdAx11tqREMV
         FZlTAknEcwAOz8wYvh+LXGgv9ufBKwkbNSqN8mFhALUl2056CNhX4PeOxuzqsrJTFP
         4fIkMJeaY/fbGzPmcwqWUHyu5xA8R6xCnqbMBwJ0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 723BE60769;
        Tue, 28 May 2019 14:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559053803;
        bh=x73gs11UqeyquhhHifaz+Y5m6QpD+Y2yC03QFMfrKZI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DQP6RINU4XD0144grtyT/iVZOuRtbn5Oqo702k+QHJl6VtKdZjABNRmcw+ZnB/LFC
         w7r9NJPwi+CHZ1J6ZcEYk58YdoKYpfmGv5g0UYVX9mk7tzP7L9IkUpV7F2CZmXh4Zb
         +FJ8SnbljklUB0FbcXS3q8ZXDrKv99t21OgdkL9c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 723BE60769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <andreyknvl@google.com>,
        <syzkaller-bugs@googlegroups.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] network: wireless: p54u: Fix race between disconnect and firmware loading
References: <Pine.LNX.4.44L0.1905281014340.1564-100000@iolanthe.rowland.org>
Date:   Tue, 28 May 2019 17:29:59 +0300
In-Reply-To: <Pine.LNX.4.44L0.1905281014340.1564-100000@iolanthe.rowland.org>
        (Alan Stern's message of "Tue, 28 May 2019 10:17:19 -0400 (EDT)")
Message-ID: <875zpu4pp4.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Tue, 28 May 2019, Kalle Valo wrote:
>
>> The correct prefix is "p54:", but I can fix that during commit.
>
> Oh, okay, thanks.
>
>> > Index: usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
>> > ===================================================================
>> > --- usb-devel.orig/drivers/net/wireless/intersil/p54/p54usb.c
>> > +++ usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
>> > @@ -33,6 +33,8 @@ MODULE_ALIAS("prism54usb");
>> >  MODULE_FIRMWARE("isl3886usb");
>> >  MODULE_FIRMWARE("isl3887usb");
>> >  
>> > +static struct usb_driver p54u_driver;
>> 
>> How is it safe to use static variables from a wireless driver? For
>> example, what if there are two p54 usb devices on the host? How do we
>> avoid a race in that case?
>
> There is no race.  This structure is not per-device; it refers only to
> the driver.  In fact, the line above is only a forward declaration --
> the actual definition of p54u_driver was already in the source file.

Ah, I missed that. Thanks!

-- 
Kalle Valo
