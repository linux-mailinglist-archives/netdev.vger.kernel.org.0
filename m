Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD60A3AC897
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbhFRKQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:16:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:31667 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhFRKP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624011224;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=TTr19vPZLviTwengBDXkAe6yBwL2HQTHr/uHIs4p14E=;
    b=QLFXy2wdw1WOFvbKuBMoRdy8FTbEtqmvQMfqPGqjaN7xnO13u6RXJHMA5NFOZdOEee
    26YIWqXEUd1yx+mgWWhslsxehJ3npRJ8VsF/cpuN/55Bi3sYYmxubYVxtZX18pwhfD7k
    ZA78Lid+aHiMHI9w9/AFSrD9257wOgVblMbr/C6dkEeooTHppTdFwBI7Wbh5n14RUNIM
    MbTqMpJBcukKctZE0pEg/6r+LxJvsex6mqfzUFfDbA0GEdr5Znpn6rrix4XuwmnJe8PP
    WlMgNJHEPljljWVM5WtkT2gFuwsxK22yabnK6eqnPWFRQd6H0sV7BgNCoQYKXXA1Gd2m
    S7EQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8nxIcap"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.27.3 DYNA|AUTH)
    with ESMTPSA id 000885x5IADh4yw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 18 Jun 2021 12:13:43 +0200 (CEST)
Date:   Fri, 18 Jun 2021 12:13:37 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        linuxwwan@intel.com, Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        phone-devel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [PATCH net-next v2 2/3] net: wwan: Add RPMSG WWAN CTRL driver
Message-ID: <YMxx0XimZAEHmeUx@gerhold.net>
References: <20210618075243.42046-1-stephan@gerhold.net>
 <20210618075243.42046-3-stephan@gerhold.net>
 <CAAP7ucKHXv_Wu7dpSmPpy1utMZV5iXGOjGg87AbcR4j+Xcz=WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAP7ucKHXv_Wu7dpSmPpy1utMZV5iXGOjGg87AbcR4j+Xcz=WA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aleksander!

On Fri, Jun 18, 2021 at 10:21:18AM +0200, Aleksander Morgado wrote:
> > +static const struct rpmsg_device_id rpmsg_wwan_ctrl_id_table[] = {
> > +       /* RPMSG channels for Qualcomm SoCs with integrated modem */
> > +       { .name = "DATA5_CNTL", .driver_data = WWAN_PORT_QMI },
> > +       { .name = "DATA4", .driver_data = WWAN_PORT_AT },
> > +       {},
> > +};
> 
> If I understand this properly, now these rpmsg backed control ports
> would be automatically exposed without the need of a userspace CLI
> tool to do that (rpmsgexport).
> 

Yep, that's the main advantage compared to the current approach.

> And if I recall correctly, DATA5_CNTL and DATA4 were the only channels
> actively exported with udev actions using rpmsgexport in postmarketos,
> but that didn't mean someone could add additional rules to export
> other channels (i.e. as per the ModemManager port type hint rules,
> DATA[0-9]*_CNTL as QMI and DATA[0-9]* as AT, except for DATA40_CNTL
> and DATA_40 which are the USB tethering related ones).
> 

Yep.

> So, does this mean we're limiting the amount of channels exported to
> only one QMI control port and one AT control port?

Yep, but I think:
  - It's easy to extend this with additional ports later
    if someone has a real use case for that.
  - It's still possible to export via rpmsgexport.

> Not saying that's wrong, but maybe it makes sense to add a comment
> somewhere specifying that explicitly.

Given that these channels were only found through reverse engineering,
saying that DATA*_CNTL/DATA* are fully equivalent QMI/AT ports is just
a theory, I have no proof for this. Generally these channels had some
fixed use case on the original Android system, for example DATA1 (AT)
seems to have been often used for Bluetooth Dial-Up Networking (DUN)
while DATA4 was often more general purpose.

Perhaps DATA* are all fully equivalent, independent AT channels at the
end, or perhaps DATA1/DATA4 behave slightly differently because there
were some special requirements for Bluetooth DUN. I have no way to tell.
And it can vary from device to device since we're stuck with
device-specific (and usually signed) firmware.

Another example: I have seen DATA11 on some devices, but it does not
seem to work as AT port for some reason, there is no reply at all
from the modem on that channel. Perhaps it needs to be activated
somehow, perhaps it's not an AT channel at all, I have no way to tell.

My point is: Here I'm only enabling what is proven to work on all
devices (used in postmarketOS for more than a year). I have insufficient
data to vouch for the reliability of any other channel. I cannot say if
the channels are really independent, or influence each other somehow.

As far as I understand, we currently do not have any use case for having
multiple QMI/AT ports exposed for ModemManager, right? And if someone
does have a use case, perhaps exposing them through the WWAN subsystem
is not even what they want, perhaps they want to forward them through
USB or something.

> Also, would it make sense to have some way to trigger the export of
> additional channels somehow via userspace? e.g. something like
> rpmsgexport but using the wwan subsystem. I'm not sure if that's a
> true need anywhere or just over-engineering the solution, truth be
> told.

So personally I think we should keep this simple and limited to existing
use cases. If someone shows up with different requirements we can
investigate this further.

If I send a v3 I will check if I can clarify this in the commit
message somewhat. I actually had something related in there but removed
it shortly before submitting the patch because I thought it's mostly
just speculation and the message was already quite long. Oh well :)

Stephan
