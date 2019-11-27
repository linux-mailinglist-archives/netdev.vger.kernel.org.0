Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6191310B6BC
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfK0T3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:29:13 -0500
Received: from mail.dlink.ru ([178.170.168.18]:34872 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfK0T3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 14:29:12 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 00DDC1B214D2; Wed, 27 Nov 2019 22:29:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 00DDC1B214D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1574882949; bh=0Z3bAxM5sdGwK79DgqtcaPlxNZ3CH9/ldaQOwqZTrdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=JrpwsB9kB8X1X8RIWGCXDQtZZ/sPwQwhYdxDWWWFsG9dKQ13EJPqk7MaFSLZu+QXG
         /0erLwnXv5md+DXpp2AWtUIDhId+VBVg4qMahrt9Xl/HjXd6qHBDSURHu7vjrAdTmL
         yD2kwqm4FlQJ/g3E7iOMadKxNyL9Qsc4R4UmbV3o=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 3547F1B201CA;
        Wed, 27 Nov 2019 22:28:58 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 3547F1B201CA
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id CB4021B217D8;
        Wed, 27 Nov 2019 22:28:57 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Wed, 27 Nov 2019 22:28:57 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 27 Nov 2019 22:28:57 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     David Miller <davem@davemloft.net>
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org,
        nicholas.johnson-opensource@outlook.com.au, kenny@panix.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
In-Reply-To: <20191127.112310.1018809619618803508.davem@davemloft.net>
References: <20191127094123.18161-1-alobakin@dlink.ru>
 <20191127.112310.1018809619618803508.davem@davemloft.net>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <717aa19f01da2bc36fd22343bbbc39f7@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote 27.11.2019 22:23:
> From: Alexander Lobakin <alobakin@dlink.ru>
> Date: Wed, 27 Nov 2019 12:41:23 +0300
> 
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
> 
> Applied, thanks for the quick turnaround.

Thank you all folks!

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
