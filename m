Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94028351DF
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFDV3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfFDV3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 17:29:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC5872F8BEA;
        Tue,  4 Jun 2019 21:29:32 +0000 (UTC)
Received: from ovpn-112-67.rdu2.redhat.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5271C5C207;
        Tue,  4 Jun 2019 21:29:27 +0000 (UTC)
Message-ID: <0264d7f9a35430201a89c068bb13c84c622af11a.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alex Elder <elder@linaro.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
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
Date:   Tue, 04 Jun 2019 16:29:26 -0500
In-Reply-To: <CAK8P3a3pQpSpH4q=CL6gr_YzjYgoyD6-eyiLrvnZsqqjpcRxtQ@mail.gmail.com>
References: <20190531035348.7194-1-elder@linaro.org>
         <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
         <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
         <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
         <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
         <20190531233306.GB25597@minitux>
         <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org>
         <CAK8P3a0brT0zyZGNWiS2R0RMHHFF2JG=_ixQyvjhj3Ky39o0UA@mail.gmail.com>
         <040ce9cc-7173-d10a-a82c-5186d2fcd737@linaro.org>
         <CAK8P3a2U=RzfpVaAgRP1QwPhRpZiBNsG5qdWjzwG=tCKZefYHA@mail.gmail.com>
         <b26cf34c0d3fa1a7a700cee935244d7a2a7e1388.camel@redhat.com>
         <CAK8P3a3pQpSpH4q=CL6gr_YzjYgoyD6-eyiLrvnZsqqjpcRxtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 04 Jun 2019 21:29:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-04 at 22:04 +0200, Arnd Bergmann wrote:
> On Tue, Jun 4, 2019 at 5:18 PM Dan Williams <dcbw@redhat.com> wrote:
> > On Tue, 2019-06-04 at 10:13 +0200, Arnd Bergmann wrote:
> > > Can you describe what kind of multiplexing is actually going on?
> > > I'm still unclear about what we actually use multiple logical
> > > interfaces for here, and how they relate to one another.
> > 
> > Each logical interface represents a different "connection" (PDP/EPS
> > context) to the provider network with a distinct IP address and
> > QoS.
> > VLANs may be a suitable analogy but here they are L3+QoS.
> > 
> > In realistic example the main interface (say rmnet0) would be used
> > for
> > web browsing and have best-effort QoS. A second interface (say
> > rmnet1)
> > would be used for VOIP and have certain QoS guarantees from both
> > the
> > modem and the network itself.
> > 
> > QMAP can also aggregate frames for a given channel
> > (connection/EPS/PDP
> > context/rmnet interface/etc) to better support LTE speeds.
> 
> Thanks, that's a very helpful explanation!
> 
> Is it correct to say then that the concept of having those separate
> connections would be required for any proper LTE modem
> implementation,
> but the QMAP protocol (and based on that, the rmnet implementation)
> is Qualcomm specific and shared only among several generations of
> modems from that one vendor?

Exactly correct.  This is what Johannes is discussing in his "cellular
modem APIs - take 2" thread about how this should all be organized at
the driver level and I think we should figure that out before we commit
to IPA-with-a-useless-netdev that requires rmnets to be created on top.
That may end up being the solution but let's have that discussion.

> > You mentioned the need to have a common user space interface
> for configuration, and if the above is true, I agree that we should
> try
> to achieve that, either by ensuring rmnet is generic enough to
> cover other vendors (and non-QMAP clients), or by creating a
> new user level interface that IPA/rmnet can be adapted to.

I would not suggest making rmnet generic; it's pretty QMAP specific
(but QMAP is spoken by many many modems both SoC, USB stick, and PCIe
minicard).

Instead, I think what Johannes is discussing is a better approach. A
kernel WWAN framework with consistent user API that
rmnet/IPA/qmi_wwan/MBIM/QMI/serial/Sierra can all implement.

That wouldn't affect the core packet processing of IPA/rmnet but
instead:

1) when/how an rmnet device actually gets created on top of the IPA (or
qmi_wwan) device

AND (one of these two)

a) whether IPA creates a netdev on probe

OR

b) whether there is some "WWAN device" kernel object which userspace
interacts with create rmnet channels on top of IPA

Dan

