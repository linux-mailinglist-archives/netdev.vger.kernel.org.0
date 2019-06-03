Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D5332AC
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfFCOuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:50:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfFCOui (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:50:38 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0328830917AB;
        Mon,  3 Jun 2019 14:50:32 +0000 (UTC)
Received: from ovpn-112-59.rdu2.redhat.com (ovpn-112-59.rdu2.redhat.com [10.10.112.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCFC72E053;
        Mon,  3 Jun 2019 14:50:25 +0000 (UTC)
Message-ID: <99b9a24b229975689fb4686915190200606e8afc.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, abhishek.esse@gmail.com,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Date:   Mon, 03 Jun 2019 09:50:24 -0500
In-Reply-To: <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org>
References: <20190531035348.7194-1-elder@linaro.org>
         <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
         <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
         <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
         <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
         <20190531233306.GB25597@minitux>
         <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 03 Jun 2019 14:50:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 17:59 -0600, Subash Abhinov Kasiviswanathan
wrote:
> On 2019-05-31 17:33, Bjorn Andersson wrote:
> > On Fri 31 May 13:47 PDT 2019, Alex Elder wrote:
> > 
> > > On 5/31/19 2:19 PM, Arnd Bergmann wrote:
> > > > On Fri, May 31, 2019 at 6:36 PM Alex Elder <elder@linaro.org>
> > > > wrote:
> > > > > On 5/31/19 9:58 AM, Dan Williams wrote:
> > > > > > On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
> > > > > > 
> > > > > > My question from the Nov 2018 IPA rmnet driver still
> > > > > > stands; how does
> > > > > > this relate to net/ethernet/qualcomm/rmnet/ if at all? And
> > > > > > if this is
> > > > > > really just a netdev talking to the IPA itself and
> > > > > > unrelated to
> > > > > > net/ethernet/qualcomm/rmnet, let's call it "ipa%d" and stop
> > > > > > cargo-
> > > > > > culting rmnet around just because it happens to be a net
> > > > > > driver for a
> > > > > > QC SoC.
> > > > > 
> > > > > First, the relationship between the IPA driver and the rmnet
> > > > > driver
> > > > > is that the IPA driver is assumed to sit between the rmnet
> > > > > driver
> > > > > and the hardware.
> > > > 
> > > > Does this mean that IPA can only be used to back rmnet, and
> > > > rmnet
> > > > can only be used on top of IPA, or can or both of them be
> > > > combined
> > > > with another driver to talk to instead?
> > > 
> > > No it does not mean that.
> > > 
> > > As I understand it, one reason for the rmnet layer was to
> > > abstract
> > > the back end, which would allow using a modem, or using something
> > > else (a LAN?), without exposing certain details of the hardware.
> > > (Perhaps to support multiplexing, etc. without duplicating that
> > > logic in two "back-end" drivers?)
> > > 
> > > To be perfectly honest, at first I thought having IPA use rmnet
> > > was a cargo cult thing like Dan suggested, because I didn't see
> > > the benefit.  I now see why one would use that pass-through layer
> > > to handle the QMAP features.
> > > 
> > > But back to your question.  The other thing is that I see no
> > > reason the IPA couldn't present a "normal" (non QMAP) interface
> > > for a modem.  It's something I'd really like to be able to do,
> > > but I can't do it without having the modem firmware change its
> > > configuration for these endpoints.  My access to the people who
> > > implement the modem firmware has been very limited (something
> > > I hope to improve), and unless and until I can get corresponding
> > > changes on the modem side to implement connections that don't
> > > use QMAP, I can't implement such a thing.
> > > 
> > 
> > But any such changes would either be years into the future or for
> > specific devices and as such not applicable to any/most of devices
> > on
> > the market now or in the coming years.
> > 
> > 
> > But as Arnd points out, if the software split between IPA and rmnet
> > is
> > suboptimal your are encouraged to fix that.
> > 
> > Regards,
> > Bjorn
> 
> The split rmnet design was chosen because we could place rmnet
> over any transport - IPA, PCIe (https://lkml.org/lkml/2018/4/26/1159)
> or USB.

Yeah, that's what I was looking for clarification on :) Clearly since
rmnet can have many transports it should be able to be used by
different HW drivers, be that qmi_wwan, IPA, and maybe even
rmnet_smd.c?

> rmnet registers a rx handler, so the rmnet packet processing itself
> happens in the same softirq when packets are queued to network stack
> by IPA.

This directly relates to the discussion about a WWAN subsystem that
Johannes Berg started a couple weeks ago. IPA appears to create a
netdev of its own. Is that netdev usable immediately, or does one need
to create an rmnet device on top to access the default PDN?

Thanks,
Dan

