Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A461422D87B
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 17:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGYPl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 11:41:56 -0400
Received: from mail.as201155.net ([185.84.6.188]:25196 "EHLO mail.as201155.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgGYPl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 11:41:56 -0400
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:52082 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jzMJ5-00023J-0x; Sat, 25 Jul 2020 17:41:51 +0200
X-CTCH-RefID: str=0001.0A782F1D.5F1C52BF.003A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=y8UpvgAJ1xBMK2OnuBZR1Bmmrw+CwmHHVi+lnnXK/7E=;
        b=q9QZ2bmUjAbR5JFVPpoENTeOUIOTLg+ZSO6ttYzDOTu2BVr5lZ+v+cEo53ybCbepriKNcjJ3LCBzZD7WK7U0x/U+DH0vQHZyX95Q4S09guF5N5SeLowmBIi9qdPgHcQkk1+8Ts9bMktigzpTFRZxxLThidJOszEnZixz5fLktv0=;
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
To:     Hillf Danton <hdanton@sina.com>
Cc:     David Laight <David.Laight@ACULAB.COM>,
        Andrew Lunn <andrew@lunn.ch>,
        Rakesh Pillai <pillair@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Markus Elfring <Markus.Elfring@web.de>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <20200721172514.GT1339445@lunn.ch> <20200725081633.7432-1-hdanton@sina.com>
 <8359a849-2b8a-c842-a501-c6cb6966e345@dd-wrt.com>
 <20200725145728.10556-1-hdanton@sina.com>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <2664182a-1d03-998d-8eff-8478174a310a@dd-wrt.com>
Date:   Sat, 25 Jul 2020 17:41:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <20200725145728.10556-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [2a01:7700:8040:4d00:1098:21a4:6e8a:924b]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jzMJ4-000BMm-U8; Sat, 25 Jul 2020 17:41:50 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> i agree. i just can say that i tested this patch recently due this
>> discussion here. and it can be changed by sysfs. but it doesnt work for
>> wifi drivers which are mainly using dummy netdev devices. for this i
>> made a small patch to get them working using napi_set_threaded manually
>> hardcoded in the drivers. (see patch bellow)
> By CONFIG_THREADED_NAPI, there is no need to consider what you did here
> in the napi core because device drivers know better and are responsible
> for it before calling napi_schedule(n).
yeah. but that approach will not work for some cases. some stupid 
drivers are using locking context in the napi poll function.
in that case the performance will runto shit. i discovered this with the 
mvneta eth driver (marvell) and mt76 tx polling (rx  works)
for mvneta is will cause very high latencies and packet drops. for mt76 
it causes packet stop. doesnt work simply (on all cases no crashes)
so the threading will only work for drivers which are compatible with 
that approach. it cannot be used as drop in replacement from my point of 
view.
its all a question of the driver design
