Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926C34C4EF
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbfFTBZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:25:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfFTBZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 21:25:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2744307D925;
        Thu, 20 Jun 2019 01:25:15 +0000 (UTC)
Received: from ovpn-112-53.rdu2.redhat.com (ovpn-112-53.rdu2.redhat.com [10.10.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B4E81001DD2;
        Thu, 20 Jun 2019 01:25:12 +0000 (UTC)
Message-ID: <7c0e8909cee17623565ef88445b0497d5504fe1c.camel@redhat.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Dan Williams <dcbw@redhat.com>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
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
Date:   Wed, 19 Jun 2019 20:25:11 -0500
In-Reply-To: <2926e45fd7ff62fd7c4af9b338bf0caa@codeaurora.org>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
         <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
         <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
         <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com>
         <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
         <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com>
         <6c70950d0c78bc02a3d016918ec3929e@codeaurora.org>
         <CAK8P3a3e+U85yHTeE4dHa4okLVHgBd8Kke9=FytzvMwz+wB0sQ@mail.gmail.com>
         <2926e45fd7ff62fd7c4af9b338bf0caa@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 20 Jun 2019 01:25:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-19 at 12:47 -0600, Subash Abhinov Kasiviswanathan
wrote:
> > > There is a n:1 relationship between rmnet and IPA.
> > > rmnet does the de-muxing to multiple netdevs based on the mux id
> > > in the MAP header for RX packets and vice versa.
> > 
> > Oh, so you mean that even though IPA supports multiple channels
> > and multiple netdev instances for a physical device, all the
> > rmnet devices end up being thrown into a single channel in IPA?
> > 
> > What are the other channels for in IPA? I understand that there
> > is one channel for commands that is separate, while the others
> > are for network devices, but that seems to make no sense if
> > we only use a single channel for rmnet data.
> > 
> 
> AFAIK, the other channels are for use cases like tethering.
> There is only a single channel which is used for RX
> data which is then de-muxed using rmnet.

That seems odd, since tethering is no different than any other data
channel in QMI, just that it may have a different APN and QoS
guarantees.

Dan

