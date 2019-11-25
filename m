Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46AA7108C61
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKYK7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:59:03 -0500
Received: from fd.dlink.ru ([178.170.168.18]:44662 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfKYK7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 05:59:03 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id C60AF1B20400; Mon, 25 Nov 2019 13:58:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru C60AF1B20400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574679538; bh=tXl0CZ8ZQKwituwUIeWFFggmc8Ny9GguiEH02Chb+Rs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=a45o3o3P//4ZWdb4IdfAoRDjCZD7XkSMbb0yFQA7iUnkl6hKnDUU5DOo97J2eTtHm
         /59+08z/EO6Orx7arCGu/s3sUvTBY/OKOpoHy4u2hcMyyBu5AMUFu4LCnD3ppPxKO8
         SI/TyWLseslni3DjGWecwwGYBa89b4nBXpROKk9s=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 3433D1B204A3;
        Mon, 25 Nov 2019 13:58:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 3433D1B204A3
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id CD5151B210B7;
        Mon, 25 Nov 2019 13:58:38 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 25 Nov 2019 13:58:38 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 25 Nov 2019 13:58:38 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, pabeni@redhat.com,
        petrm@mellanox.com, sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
In-Reply-To: <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
 <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote 25.11.2019 13:31:
> On 25/11/2019 09:09, Nicholas Johnson wrote:
>> The default value of /proc/sys/net/core/gro_normal_batch was 8.
>> Setting it to 1 allowed it to connect to Wi-Fi network.
>> 
>> Setting it back to 8 did not kill the connection.
>> 
>> But when I disconnected and tried to reconnect, it did not re-connect.
>> 
>> Hence, it appears that the problem only affects the initial handshake
>> when associating with a network, and not normal packet flow.
> That sounds like the GRO batch isn't getting flushed at the endof the
>  NAPI — maybe the driver isn't calling napi_complete_done() at the
>  appropriate time?

Yes, this was the first reason I thought about, but didn't look at
iwlwifi yet. I already knew this driver has some tricky parts, but
this 'fake NAPI' solution seems rather strange to me.

> Indeed, from digging through the layers of iwlwifi I eventually get to
>  iwl_pcie_rx_handle() which doesn't really have a NAPI poll (the
>  napi->poll function is iwl_pcie_dummy_napi_poll() { WARN_ON(1);
>  return 0; }) and instead calls napi_gro_flush() at the end of its RX
>  handling.  Unfortunately, napi_gro_flush() is no longer enough,
>  because it doesn't call gro_normal_list() so the packets on the
>  GRO_NORMAL list just sit there indefinitely.
> 
> It was seeing drivers calling napi_gro_flush() directly that had me
>  worried in the first place about whether listifying napi_gro_receive()
>  was safe and where the gro_normal_list() should go.
> I wondered if other drivers that show up in [1] needed fixing with a
>  gro_normal_list() next to their napi_gro_flush() call.  From a cursory
>  check:
> brocade/bna: has a real poller, calls napi_complete_done() so is OK.
> cortina/gemini: calls napi_complete_done() straight after
>  napi_gro_flush(), so is OK.
> hisilicon/hns3: calls napi_complete(), so is _probably_ OK.
> But it's far from clear to me why *any* of those drivers are calling
>  napi_gro_flush() themselves...

Agree. I mean, we _can_ handle this particular problem from networking
core side, but from my point of view only rethinking driver's logic is
the correct way to solve this and other issues that may potentionally
appear in future.

> -Ed
> 
> [1]: https://elixir.bootlin.com/linux/latest/ident/napi_gro_flush

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
