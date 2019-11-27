Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F080210B347
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfK0Qb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:31:29 -0500
Received: from mail.dlink.ru ([178.170.168.18]:43016 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0Qb3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 11:31:29 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 906C71B21254; Wed, 27 Nov 2019 19:31:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 906C71B21254
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574872285; bh=D0U/yoZIFmLHwjF+Ayn7vsDRMvJ2hdz+rD6jAk4olMc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=is2hCZ6d7g97DxekjT754vqL7o2BoJRRA51ExITKCw3Ec8ZS42WJPee6O/x7R9hme
         H648HBJxdeER+b85BgYjiQJKA+CK2c2hJ5tbAeQ9oSTWfsjow2umhlnavKaU4+cSfX
         4HeTICyus0f/DPKpKllbwup9OUPRvTyr/Vsv6X7c=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id BB8D91B2029D;
        Wed, 27 Nov 2019 19:31:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru BB8D91B2029D
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 3F34A1B20AE9;
        Wed, 27 Nov 2019 19:31:08 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 19:31:08 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 27 Nov 2019 19:31:08 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Edward Cree <ecree@solarflare.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        "Kenneth R. Crudup" <kenny@panix.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
In-Reply-To: <20a018a6-827a-de47-a0e4-45ff8c02087b@solarflare.com>
References: <20191127094123.18161-1-alobakin@dlink.ru>
 <20a018a6-827a-de47-a0e4-45ff8c02087b@solarflare.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <c9dfc89a893ef412d4fcf9c79d28766a@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote 27.11.2019 19:05:
> On 27/11/2019 09:41, Alexander Lobakin wrote:
>> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
>> napi_gro_receive()") has applied batched GRO_NORMAL packets processing
>> to all napi_gro_receive() users, including mac80211-based drivers.
>> 
>> However, this change has led to a regression in iwlwifi driver [1][2] 
>> as
>> it is required for NAPI users to call napi_complete_done() or
>> napi_complete() and the end of every polling iteration, whilst iwlwifi
>> doesn't use NAPI scheduling at all and just calls napi_gro_flush().
>> In that particular case, packets which have not been already flushed
>> from napi->rx_list stall in it until at least next Rx cycle.
>> 
>> Fix this by adding a manual flushing of the list to iwlwifi driver 
>> right
>> before napi_gro_flush() call to mimic napi_complete() logics.
>> 
>> I prefer to open-code gro_normal_list() rather than exporting it for 2
>> reasons:
>> * to prevent from using it and napi_gro_flush() in any new drivers,
>>   as it is the *really* bad way to use NAPI that should be avoided;
>> * to keep gro_normal_list() static and don't lose any CC 
>> optimizations.
>> 
>> I also don't add the "Fixes:" tag as the mentioned commit was only a
>> trigger that only exposed an improper usage of NAPI in this particular
>> driver.
>> 
>> [1] 
>> https://lore.kernel.org/netdev/PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
>> [2] https://bugzilla.kernel.org/show_bug.cgi?id=205647
>> 
>> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> Reviewed-by: Edward Cree <ecree@solarflare.com>

Thanks! And you were the first who's found the root of the issue.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
