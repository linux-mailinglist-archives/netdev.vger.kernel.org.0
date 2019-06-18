Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B244AAFA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 21:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfFRTWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 15:22:31 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46278 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfFRTWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 15:22:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdJgO-0005LX-Ie; Tue, 18 Jun 2019 21:22:16 +0200
Message-ID: <b90977f94df020986c6bb490e7fd0262603726b0.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Date:   Tue, 18 Jun 2019 21:22:14 +0200
In-Reply-To: <31c2c94c-c6d3-595b-c138-faa54d0bfc00@linaro.org> (sfid-20190618_160100_881541_6AD64A3C)
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <583907409fad854bd3c18be688ec2724ad7a60e9.camel@sipsolutions.net>
         <31c2c94c-c6d3-595b-c138-faa54d0bfc00@linaro.org>
         (sfid-20190618_160100_881541_6AD64A3C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 09:00 -0500, Alex Elder wrote:

> Deaggregation is a connection property, not a channel property.

That'd make sense, yes.

> And it looks like that's exactly how it's used in the rmnet
> driver.  

Yeah, I think you're right. I got confused by the whole use of "port"
there, but it seems like "port" actually refers to the underlying
netdev.

Which is really strange too, btw, because you configure the "port" to
agg/non-agg when you add a new channel to it ... So it seems like it's
part of the channel configuration, when it's not!

Anyway, I think for now we could probably live with not having this
configurable for the IPA driver, and if it *does* need to be
configurable, it seems like it should be a driver configuration, not a
channel configuration - so something like a debugfs hook if you really
just need to play with it for performance testing, or a module
parameter, or something else?

Or even, in the WWAN framework, a knob that we provide there for the
WWAN device, rather than for the (newly created) channel.

> The hardware is capable of aggregating QMAP packets
> arriving on a connection into a single buffer, so this provides
> a way of requesting it do that.
> 
> > > #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
> > 
> > Similar here? If you have flow control you probably want to use it?
> 
> I agree with that, though perhaps there are cases where it
> is pointless, or can't be supported, so one might want to
> simply *not* implement/advertise the feature.  I don't know.

Sure, but then that's likely something the driver would need to know,
not necessarily userspace?

johannes

