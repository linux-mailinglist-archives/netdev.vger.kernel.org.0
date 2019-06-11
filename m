Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26CE33D3EB
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406125AbfFKRXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:23:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33460 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406105AbfFKRXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 13:23:11 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBA097573D;
        Tue, 11 Jun 2019 17:23:05 +0000 (UTC)
Received: from ovpn-112-53.rdu2.redhat.com (ovpn-112-53.rdu2.redhat.com [10.10.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59CCA5DE86;
        Tue, 11 Jun 2019 17:22:59 +0000 (UTC)
Message-ID: <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Date:   Tue, 11 Jun 2019 12:22:58 -0500
In-Reply-To: <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
         <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 11 Jun 2019 17:23:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-11 at 10:52 -0600, Subash Abhinov Kasiviswanathan
wrote:
> > The general plan (and I believe Daniele Palmas was working on it)
> > was
> > to eventually make qmi_wwan use rmnet rather than its internal
> > sysfs-
> > based implementation. qmi_wwan and ipa are at essentially the same
> > level and both could utilize rmnet on top.
> > 
> > *That's* what I'd like to see. I don't want to see two different
> > ways
> > to get QMAP packets to modem firmware from two different drivers
> > that
> > really could use the same code.
> > 
> > Dan
> 
> qmi_wwan is based on USB and is very different from the IPA
> interconnect
> though. AFAIK, they do not have much in common (apart from sending &
> receiving MAP packets from hardware).

That is correct, they are very different drivers but as you state they
send and receive MAP packets with the other end via some closer-to-
hardware protocol (USB or GSI?) than QMAP.

rmnet should handle muxing the QMAP, QoS, and aggregation and pass the
resulting packet to the lower layer. That lower layer could be IPA or
qmi_wwan, which in turn passes that QMAP packet to USB or GSI or
whatever. This is typically how Linux handles clean abstractions
between different protocol layers in drivers.

Similar to some WiFi drivers (drivers/net/wireless/marvell/libertas for
example) where the same firmware interface can be accessed via PCI,
SDIO, USB, SPI, etc. The bus-specific code is self-contained and does
not creep into the upper more generic parts.

Dan

