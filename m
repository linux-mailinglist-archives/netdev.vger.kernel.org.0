Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69452D3F7F
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 14:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfJKM2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 08:28:04 -0400
Received: from mail.dlink.ru ([178.170.168.18]:54952 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727198AbfJKM2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 08:28:04 -0400
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 8A16B1B219E5; Fri, 11 Oct 2019 15:28:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 8A16B1B219E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1570796881; bh=C72IoI+BPnfi1LdSqWHYP8NbyrbiSAN93sPPntD75AA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=M31qq+4h5nmHb3yQvmi56+rqyM+LVTgbcw0YdFSOOLmx9QJ9U/FdpQ20AIn0HIfoQ
         t7qtnlosP42Jq7CTYTA9lQC5tNdNUOja5H0PhVvF1UJZwpF+NBbdi2Btm3bC4FcmeN
         BKQrbj0+HcWTSWsvYb5bom3bpDzmsy704GJ8Eraw=
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 8A5271B2195C;
        Fri, 11 Oct 2019 15:27:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 8A5271B2195C
Received: by mail.rzn.dlink.ru (Postfix, from userid 5000)
        id 655071B21923; Fri, 11 Oct 2019 15:27:57 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA id 068671B2120F;
        Fri, 11 Oct 2019 15:27:50 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 11 Oct 2019 15:27:50 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
In-Reply-To: <20191011122329.GA8373@apalos.home>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191011122329.GA8373@apalos.home>
Message-ID: <88b9c6742b1169d520376366b683df6c@dlink.ru>
X-Sender: alobakin@dlink.ru
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias,

Ilias Apalodimas wrote 11.10.2019 15:23:
> Hi Alexander,
> 
> On Thu, Oct 10, 2019 at 05:42:24PM +0300, Alexander Lobakin wrote:
>> Hi Dave,
>> 
>> This series was written as a continuation to commit 323ebb61e32b
>> ("net: use listified RX for handling GRO_NORMAL skbs"), and also takes
>> an advantage of listified Rx for GRO. This time, however, we're
>> targeting at a way more common and used function, napi_gro_receive().
>> 
>> There are about ~100 call sites of this function, including gro_cells
>> and mac80211, so even wireless systems will benefit from it.
>> The only driver that cares about the return value is
>> ethernet/socionext/netsec, and only for updating statistics. I don't
>> believe that this change can break its functionality, but anyway,
>> we have plenty of time till next merge window to pay this change
>> a proper attention.
> 
> I don't think this will break anything on the netsec driver. Dropped 
> packets
> will still be properly accounted for
> 

Thank you for clarification. Do I need to mention you under separate 
Acked-by in v2?

>> 
>> Besides having this functionality implemented for napi_gro_frags()
>> users, the main reason is the solid performance boost that has been
>> shown during tests on 1-core MIPS board (with not yet mainlined
>> driver):
>> 
>> * no batching (5.4-rc2): ~450/450 Mbit/s
>> * with gro_normal_batch == 8: ~480/480 Mbit/s
>> * with gro_normal_batch == 16: ~500/500 Mbit/s
>> 
>> Applies on top of net-next.
>> Thanks.
>> 
>> Alexander Lobakin (2):
>>   net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
>>   net: core: increase the default size of GRO_NORMAL skb lists to 
>> flush
>> 
>>  net/core/dev.c | 51 
>> +++++++++++++++++++++++++-------------------------
>>  1 file changed, 26 insertions(+), 25 deletions(-)
>> 
>> --
>> 2.23.0
>> 
> 
> Thanks
> /Ilias

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
