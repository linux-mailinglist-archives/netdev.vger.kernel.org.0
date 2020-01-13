Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64AD138E1A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgAMJqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:46:31 -0500
Received: from fd.dlink.ru ([178.170.168.18]:54344 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgAMJqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 04:46:31 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 5A4A41B2130C; Mon, 13 Jan 2020 12:46:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 5A4A41B2130C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1578908788; bh=mHvumthM4kqA6nZVMBkNipV495noJBzqsUxcFANvR+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=bRqKzJCwoYMAV12rYK3E7eu7St01aA1F7/0z3636veVJnbqnefcePy7g0zkw4mPMk
         ybo9ivig7DazPIlAJslLHu4GABVqm+9IpUB1fq22T6nfPjFNIpXLGGkz3trsHejYJT
         wQHirYb2NWM2tt/p0FT+FjQNPnwQe7lle63GxDE4=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 466E51B201E9;
        Mon, 13 Jan 2020 12:46:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 466E51B201E9
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id D30BE1B20320;
        Mon, 13 Jan 2020 12:46:13 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Mon, 13 Jan 2020 12:46:13 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 13 Jan 2020 12:46:13 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH RFC net-next 05/19] net: dsa: tag_ar9331: add GRO
 callbacks
In-Reply-To: <CA+h21hoSoZT+ieaOu8N=MCSqkzey0L6HeoXSyLtHjZztT0S9ug@mail.gmail.com>
References: <20191230143028.27313-1-alobakin@dlink.ru>
 <20191230143028.27313-6-alobakin@dlink.ru>
 <ee6f83fd-edf4-5a98-9868-4cbe9e226b9b@gmail.com>
 <ed0ad0246c95a9ee87352d8ddbf0d4a1@dlink.ru>
 <CA+h21hoSoZT+ieaOu8N=MCSqkzey0L6HeoXSyLtHjZztT0S9ug@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <0002a7388dfd5fb70db4b43a6c521c52@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean wrote 13.01.2020 12:42:
> Hi Alexander,
> 
> On Mon, 13 Jan 2020 at 11:22, Alexander Lobakin <alobakin@dlink.ru> 
> wrote:
>> 
>> CPU ports can't be bridged anyway
>> 
>> Regards,
>> ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
> 
> The fact that CPU ports can't be bridged is already not ideal.
> One can have a DSA switch with cascaded switches on each port, so it
> acts like N DSA masters (not as DSA links, since the taggers are
> incompatible), with each switch forming its own tree. It is desirable
> that the ports of the DSA switch on top are bridged, so that
> forwarding between cascaded switches does not pass through the CPU.

Oh, I see. But currently DSA infra forbids the adding DSA masters to
bridges IIRC. Can't name it good or bad decision, but was introduced
to prevent accidental packet flow breaking on DSA setups.

> -Vladimir

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
