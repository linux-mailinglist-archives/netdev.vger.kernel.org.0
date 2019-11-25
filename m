Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3DE108D21
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 12:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbfKYLm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 06:42:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727239AbfKYLm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 06:42:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574682176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrWxZXf+jF27pNmnMTmb8k2tBqD6ioouQVQFvYCmrvU=;
        b=J6T7gO6x/YbmTiMuDenyWzAT9bpiCDCXkWak/vXte+f2w8HkiOOWeIZlcjmdI5FR55ePaB
        PPhvja7oIofqvl9HReV1CjXdGTAq5DQEdTgypNbct1B5CvCygYnvgL67SKrBxHpTHbLZY4
        6uJow4fG1l6huRNlockqDybODykjMk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-24kVgaSQMbGs-bFIROJZNw-1; Mon, 25 Nov 2019 06:42:53 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F4168593A5;
        Mon, 25 Nov 2019 11:42:49 +0000 (UTC)
Received: from ovpn-117-137.ams2.redhat.com (ovpn-117-137.ams2.redhat.com [10.36.117.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45BA319C69;
        Mon, 25 Nov 2019 11:42:45 +0000 (UTC)
Message-ID: <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>
Cc:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Mon, 25 Nov 2019 12:42:44 +0100
In-Reply-To: <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
References: <20191014080033.12407-1-alobakin@dlink.ru>
         <20191015.181649.949805234862708186.davem@davemloft.net>
         <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
         <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
         <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
         <746f768684f266e5a5db1faf8314cd77@dlink.ru>
         <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
         <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
         <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
         (sfid-20191125_115913_640375_B340BE47) <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 24kVgaSQMbGs-bFIROJZNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-11-25 at 12:05 +0100, Johannes Berg wrote:
> On Mon, 2019-11-25 at 13:58 +0300, Alexander Lobakin wrote:
> > Edward Cree wrote 25.11.2019 13:31:
> > > On 25/11/2019 09:09, Nicholas Johnson wrote:
> > > > The default value of /proc/sys/net/core/gro_normal_batch was 8.
> > > > Setting it to 1 allowed it to connect to Wi-Fi network.
> > > >=20
> > > > Setting it back to 8 did not kill the connection.
> > > >=20
> > > > But when I disconnected and tried to reconnect, it did not re-conne=
ct.
> > > >=20
> > > > Hence, it appears that the problem only affects the initial handsha=
ke
> > > > when associating with a network, and not normal packet flow.
> > > That sounds like the GRO batch isn't getting flushed at the endof the
> > >  NAPI =E2=80=94 maybe the driver isn't calling napi_complete_done() a=
t the
> > >  appropriate time?
> >=20
> > Yes, this was the first reason I thought about, but didn't look at
> > iwlwifi yet. I already knew this driver has some tricky parts, but
> > this 'fake NAPI' solution seems rather strange to me.
>=20
> Truth be told, we kinda just fudged it until we got GRO, since that's
> what we really want on wifi (to reduce the costly TCP ACKs if possible).
>=20
> Maybe we should call napi_complete_done() instead? But as Edward noted
> (below), we don't actually really do NAPI polling, we just fake it for
> each interrupt since we will often get a lot of frames in one interrupt
> if there's high throughput (A-MPDUs are basically coming in all at the
> same time). I've never really looked too much at what exactly happens
> here, beyond seeing the difference from GRO.
>=20
>=20
> > > Indeed, from digging through the layers of iwlwifi I eventually get t=
o
> > >  iwl_pcie_rx_handle() which doesn't really have a NAPI poll (the
> > >  napi->poll function is iwl_pcie_dummy_napi_poll() { WARN_ON(1);
> > >  return 0; }) and instead calls napi_gro_flush() at the end of its RX
> > >  handling.  Unfortunately, napi_gro_flush() is no longer enough,
> > >  because it doesn't call gro_normal_list() so the packets on the
> > >  GRO_NORMAL list just sit there indefinitely.
> > >=20
> > > It was seeing drivers calling napi_gro_flush() directly that had me
> > >  worried in the first place about whether listifying napi_gro_receive=
()
> > >  was safe and where the gro_normal_list() should go.
> > > I wondered if other drivers that show up in [1] needed fixing with a
> > >  gro_normal_list() next to their napi_gro_flush() call.  From a curso=
ry
> > >  check:
> > > brocade/bna: has a real poller, calls napi_complete_done() so is OK.
> > > cortina/gemini: calls napi_complete_done() straight after
> > >  napi_gro_flush(), so is OK.
> > > hisilicon/hns3: calls napi_complete(), so is _probably_ OK.
> > > But it's far from clear to me why *any* of those drivers are calling
> > >  napi_gro_flush() themselves...
> >=20
> > Agree. I mean, we _can_ handle this particular problem from networking
> > core side, but from my point of view only rethinking driver's logic is
> > the correct way to solve this and other issues that may potentionally
> > appear in future.
>=20
> Do tell what you think it should be doing :)
>=20
> One additional wrinkle is that we have firmware notifications, command
> completions and actual RX interleaved, so I think we do want to have
> interrupts for the notifications and command completions?

I think it would be nice moving the iwlwifi driver to full/plain NAPI
mode. The interrupt handler could keep processing extra work as it does
now and queue real pkts on some internal queue, and than schedule the
relevant napi, which in turn could process such queue in the napi poll
method. Likely I missed tons of details and/or oversimplified it...

For -net, I *think* something as dumb and hacky as the following could
possibly work:
----
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wir=
eless/intel/iwlwifi/pcie/rx.c
index 4bba6b8a863c..df82fad96cbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1527,7 +1527,7 @@ static void iwl_pcie_rx_handle(struct iwl_trans *tran=
s, int queue)
                iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
=20
        if (rxq->napi.poll)
-               napi_gro_flush(&rxq->napi, false);
+               napi_complete_done(&rxq->napi, 0);
=20
        iwl_pcie_rxq_restock(trans, rxq);
 }
---

Cheers,

Paolo


