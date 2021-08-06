Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D273E2FFC
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 21:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbhHFT6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 15:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbhHFT6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 15:58:41 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F25CC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 12:58:24 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:ef0a:7f0c:624e:2eac:9b4])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 176Jw7il027163
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 6 Aug 2021 21:58:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1628279888; bh=8qx186peTxe9yvhB5L0CexBtPg8eIyRV9apIGvE0xjc=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=hPbk/A1GVGYYsHrLG3Tk21ungH5W9hpTfIhHnoFYiqa3Hh8khmxO9XySisjW6xXMx
         Fz4ZQsewd1ivjxMzFN8AlF9OIpzbxEy/lYi3CCSDLRBXHKKb95AhAPqUbBEGMaCr5t
         U0pjU8Yx36+1nSXCDUCY3wcDlvMdpCiQcr04oX2E=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1mC5yk-000DBM-8K; Fri, 06 Aug 2021 21:58:02 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     subashab@codeaurora.org
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
Organization: m
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
        <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org>
        <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
        <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org>
        <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
        <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
Date:   Fri, 06 Aug 2021 21:58:02 +0200
In-Reply-To: <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org>
        (subashab@codeaurora.org's message of "Fri, 06 Aug 2021 12:42:49
        -0600")
Message-ID: <87bl6aqrat.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.2 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subashab@codeaurora.org writes:

> Unfortunately, this seems to be a limitation of qmi_wwan (usbnet)
> where its tying the RX to the TX size through usbnet_change_mtu.
>
> Ideally, we should break this dependency and have a sysfs or some other
> configuration scheme to set the rx_urb_size.
>
> Looks like this discussion has happened a while back and the option to
> use
> a configurable scheme for rx_urb_size was rejected by Bjorn and Greg KH.

Ouch, I never meant to shoot down the proposal.  I had to go back and
read my comments. I see that it might have come out that way...

My main point was that I'd prefer this to work without any userspace
invervention, if possible.  And I'm still not sure we've explored that
alternative to the end?

> The summary of the thread was to set a large rx_urb_size during probe
> itself for qmi_wwan.

Yes, I think it would be good to make the driver DTRT automatically.
Coding driver specific quirks into ModemManager might work, but it feels
wrong to work around a Linux driver bug. We don't have to do that.  We
can fix the driver.

> https://patchwork.kernel.org/project/linux-usb/patch/20200803065105.8997-=
1-yzc666@netease.com/
>
> We could try setting a large value as suggested there and it should
> hopefully
> solve the issue you are seeing.

Why can't we break the rx_urb_size dependency on MTU automatically when
pass_through or qmi_wwan internal muxing is enabled? Preferably with
some fixed default size which would Just Work for everyone.

I'm not rejecting a rx_urb_size knob if it is absolutely necessary. But
I hope someone will write a good explanation on how to tune that value
then. Knobs are only useful if the user can make an intelligent choice.
This should go into the ABI docs.



Bj=C3=B8rn
