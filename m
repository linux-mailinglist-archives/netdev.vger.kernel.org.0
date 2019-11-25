Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAAED108C93
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 12:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfKYLF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 06:05:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:43936 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfKYLF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 06:05:57 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iZCBJ-008CJd-Oj; Mon, 25 Nov 2019 12:05:25 +0100
Message-ID: <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>
Cc:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, pabeni@redhat.com,
        petrm@mellanox.com, sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Mon, 25 Nov 2019 12:05:22 +0100
In-Reply-To: <3147bff57d58fce651fe2d3ca53983be@dlink.ru> (sfid-20191125_115913_640375_B340BE47)
References: <20191014080033.12407-1-alobakin@dlink.ru>
         <20191015.181649.949805234862708186.davem@davemloft.net>
         <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
         <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
         <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
         <746f768684f266e5a5db1faf8314cd77@dlink.ru>
         <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
         <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
         <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
         (sfid-20191125_115913_640375_B340BE47)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-11-25 at 13:58 +0300, Alexander Lobakin wrote:
> Edward Cree wrote 25.11.2019 13:31:
> > On 25/11/2019 09:09, Nicholas Johnson wrote:
> > > The default value of /proc/sys/net/core/gro_normal_batch was 8.
> > > Setting it to 1 allowed it to connect to Wi-Fi network.
> > > 
> > > Setting it back to 8 did not kill the connection.
> > > 
> > > But when I disconnected and tried to reconnect, it did not re-connect.
> > > 
> > > Hence, it appears that the problem only affects the initial handshake
> > > when associating with a network, and not normal packet flow.
> > That sounds like the GRO batch isn't getting flushed at the endof the
> >  NAPI — maybe the driver isn't calling napi_complete_done() at the
> >  appropriate time?
> 
> Yes, this was the first reason I thought about, but didn't look at
> iwlwifi yet. I already knew this driver has some tricky parts, but
> this 'fake NAPI' solution seems rather strange to me.

Truth be told, we kinda just fudged it until we got GRO, since that's
what we really want on wifi (to reduce the costly TCP ACKs if possible).

Maybe we should call napi_complete_done() instead? But as Edward noted
(below), we don't actually really do NAPI polling, we just fake it for
each interrupt since we will often get a lot of frames in one interrupt
if there's high throughput (A-MPDUs are basically coming in all at the
same time). I've never really looked too much at what exactly happens
here, beyond seeing the difference from GRO.


> > Indeed, from digging through the layers of iwlwifi I eventually get to
> >  iwl_pcie_rx_handle() which doesn't really have a NAPI poll (the
> >  napi->poll function is iwl_pcie_dummy_napi_poll() { WARN_ON(1);
> >  return 0; }) and instead calls napi_gro_flush() at the end of its RX
> >  handling.  Unfortunately, napi_gro_flush() is no longer enough,
> >  because it doesn't call gro_normal_list() so the packets on the
> >  GRO_NORMAL list just sit there indefinitely.
> > 
> > It was seeing drivers calling napi_gro_flush() directly that had me
> >  worried in the first place about whether listifying napi_gro_receive()
> >  was safe and where the gro_normal_list() should go.
> > I wondered if other drivers that show up in [1] needed fixing with a
> >  gro_normal_list() next to their napi_gro_flush() call.  From a cursory
> >  check:
> > brocade/bna: has a real poller, calls napi_complete_done() so is OK.
> > cortina/gemini: calls napi_complete_done() straight after
> >  napi_gro_flush(), so is OK.
> > hisilicon/hns3: calls napi_complete(), so is _probably_ OK.
> > But it's far from clear to me why *any* of those drivers are calling
> >  napi_gro_flush() themselves...
> 
> Agree. I mean, we _can_ handle this particular problem from networking
> core side, but from my point of view only rethinking driver's logic is
> the correct way to solve this and other issues that may potentionally
> appear in future.

Do tell what you think it should be doing :)

One additional wrinkle is that we have firmware notifications, command
completions and actual RX interleaved, so I think we do want to have
interrupts for the notifications and command completions?

johannes

