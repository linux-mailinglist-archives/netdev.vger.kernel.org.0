Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A066108D7C
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfKYMCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:02:42 -0500
Received: from mail.dlink.ru ([178.170.168.18]:54766 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfKYMCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 07:02:41 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 30F321B20A35; Mon, 25 Nov 2019 15:02:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 30F321B20A35
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574683357; bh=uOhBuma2uQnNNRxUMn0+HUFU8ipwP8HFLTk2ZlKhkyo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=HZGbst88e+QZyjpvkqJ/dydK9+JXp+8gfJAtKeroEaD4NzpGoS4BRJPlz1JgL8/QM
         zXTuoNkWAhbTOsgZOOLDIJ2S9HiVgNpbgUfvQAP3jFt+MBf9z5SqMKht4Sje7aLisp
         0AomsLHUVgKcVBLxQb/WmB2P/Yr2tmkbgVEzcttU=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id E3BF21B20303;
        Mon, 25 Nov 2019 15:02:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E3BF21B20303
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 63CB31B20AE9;
        Mon, 25 Nov 2019 15:02:24 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 25 Nov 2019 15:02:24 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 25 Nov 2019 15:02:24 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree@solarflare.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
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
 <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
 <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <d535d5142e42b8c550f0220200e3779d@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni wrote 25.11.2019 14:42:
> On Mon, 2019-11-25 at 12:05 +0100, Johannes Berg wrote:
>> On Mon, 2019-11-25 at 13:58 +0300, Alexander Lobakin wrote:
>> > Edward Cree wrote 25.11.2019 13:31:
>> > > On 25/11/2019 09:09, Nicholas Johnson wrote:
>> > > > The default value of /proc/sys/net/core/gro_normal_batch was 8.
>> > > > Setting it to 1 allowed it to connect to Wi-Fi network.
>> > > >
>> > > > Setting it back to 8 did not kill the connection.
>> > > >
>> > > > But when I disconnected and tried to reconnect, it did not re-connect.
>> > > >
>> > > > Hence, it appears that the problem only affects the initial handshake
>> > > > when associating with a network, and not normal packet flow.
>> > > That sounds like the GRO batch isn't getting flushed at the endof the
>> > >  NAPI — maybe the driver isn't calling napi_complete_done() at the
>> > >  appropriate time?
>> >
>> > Yes, this was the first reason I thought about, but didn't look at
>> > iwlwifi yet. I already knew this driver has some tricky parts, but
>> > this 'fake NAPI' solution seems rather strange to me.
>> 
>> Truth be told, we kinda just fudged it until we got GRO, since that's
>> what we really want on wifi (to reduce the costly TCP ACKs if 
>> possible).
>> 
>> Maybe we should call napi_complete_done() instead? But as Edward noted
>> (below), we don't actually really do NAPI polling, we just fake it for
>> each interrupt since we will often get a lot of frames in one 
>> interrupt
>> if there's high throughput (A-MPDUs are basically coming in all at the
>> same time). I've never really looked too much at what exactly happens
>> here, beyond seeing the difference from GRO.
>> 
>> 
>> > > Indeed, from digging through the layers of iwlwifi I eventually get to
>> > >  iwl_pcie_rx_handle() which doesn't really have a NAPI poll (the
>> > >  napi->poll function is iwl_pcie_dummy_napi_poll() { WARN_ON(1);
>> > >  return 0; }) and instead calls napi_gro_flush() at the end of its RX
>> > >  handling.  Unfortunately, napi_gro_flush() is no longer enough,
>> > >  because it doesn't call gro_normal_list() so the packets on the
>> > >  GRO_NORMAL list just sit there indefinitely.
>> > >
>> > > It was seeing drivers calling napi_gro_flush() directly that had me
>> > >  worried in the first place about whether listifying napi_gro_receive()
>> > >  was safe and where the gro_normal_list() should go.
>> > > I wondered if other drivers that show up in [1] needed fixing with a
>> > >  gro_normal_list() next to their napi_gro_flush() call.  From a cursory
>> > >  check:
>> > > brocade/bna: has a real poller, calls napi_complete_done() so is OK.
>> > > cortina/gemini: calls napi_complete_done() straight after
>> > >  napi_gro_flush(), so is OK.
>> > > hisilicon/hns3: calls napi_complete(), so is _probably_ OK.
>> > > But it's far from clear to me why *any* of those drivers are calling
>> > >  napi_gro_flush() themselves...
>> >
>> > Agree. I mean, we _can_ handle this particular problem from networking
>> > core side, but from my point of view only rethinking driver's logic is
>> > the correct way to solve this and other issues that may potentionally
>> > appear in future.
>> 
>> Do tell what you think it should be doing :)
>> 
>> One additional wrinkle is that we have firmware notifications, command
>> completions and actual RX interleaved, so I think we do want to have
>> interrupts for the notifications and command completions?
> 
> I think it would be nice moving the iwlwifi driver to full/plain NAPI
> mode. The interrupt handler could keep processing extra work as it does
> now and queue real pkts on some internal queue, and than schedule the
> relevant napi, which in turn could process such queue in the napi poll
> method. Likely I missed tons of details and/or oversimplified it...

Yep, full NAPI is the best variant, but I may miss a lot too.

> For -net, I *think* something as dumb and hacky as the following could
> possibly work:
> ----
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> index 4bba6b8a863c..df82fad96cbb 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> @@ -1527,7 +1527,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans
> *trans, int queue)
>                 iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
> 
>         if (rxq->napi.poll)
> -               napi_gro_flush(&rxq->napi, false);
> +               napi_complete_done(&rxq->napi, 0);
> 
>         iwl_pcie_rxq_restock(trans, rxq);
>  }
> ---

napi_complete_done(napi, 0) has an equivalent static inline
napi_complete(napi). I'm not sure it will work without any issues
as iwlwifi doesn't _really_ turn NAPI into scheduling state.

I'm not very familiar with iwlwifi, but as a work around manual
napi_gro_flush() you can also manually flush napi->rx_list to
prevent packets from stalling:

diff -Naur a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c 
b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c	2019-11-25 
14:55:03.610355230 +0300
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c	2019-11-25 
14:57:29.399556868 +0300
@@ -1526,8 +1526,16 @@
  	if (unlikely(emergency && count))
  		iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);

-	if (rxq->napi.poll)
+	if (rxq->napi.poll) {
+		if (rxq->napi.rx_count) {
+			netif_receive_skb_list(&rxq->napi.rx_list);
+
+			INIT_LIST_HEAD(&rxq->napi.rx_list);
+			rxq->napi.rx_count = 0;
+		}
+
  		napi_gro_flush(&rxq->napi, false);
+	}

  	iwl_pcie_rxq_restock(trans, rxq);
  }

> Cheers,
> 
> Paolo

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
