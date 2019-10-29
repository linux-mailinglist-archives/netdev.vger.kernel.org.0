Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE425E8400
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbfJ2JPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:15:37 -0400
Received: from webmail.newmedia-net.de ([185.84.6.166]:60834 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbfJ2JPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 05:15:36 -0400
X-Greylist: delayed 1000 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2019 05:15:35 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=Y8t1MVGSZf2vJH8chXj/MnxwF9ThLJ7NJUAyI1oFLrA=;
        b=IXQWsylEkXCHHWj4pOJ5Bnod5BF6GSQTXTZqMJyg6SPHo0iEV0GHVe01YMaGlP9YLGYZwMt5IoJxuuLhaGC2dEidQROq+2WjwZC18o9ANuo3uaFcb3YKoM79O1W8clqDtTPVM8taXr6g52p2OrP8P61SpY/rXvlrCaRLBe9hjW4=;
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to
 aggregation after sender reboot
To:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
 <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
 <30465e05-3465-f496-d57f-5e115551f5cb@ncentric.com>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <b51030e8-7c56-0e24-4454-ff70f83d5ae8@newmedia-net.de>
Date:   Tue, 29 Oct 2019 09:58:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <30465e05-3465-f496-d57f-5e115551f5cb@ncentric.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [212.111.244.1] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1iPNKW-0002Fu-6G; Tue, 29 Oct 2019 09:58:20 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

35 km? for 802.11n with ht40 this is out of the ack timing range the 
chipset supports. so this should be considered at any troubles with 
connections

Am 29.10.2019 um 09:41 schrieb Koen Vandeputte:
>
> On 28.10.19 13:21, Johannes Berg wrote:
>> On Fri, 2019-10-25 at 12:21 +0200, Krzysztof Hałasa wrote:
>>> Fix a bug where the mac80211 RX aggregation code sets a new aggregation
>>> "session" at the remote station's request, but the head_seq_num
>>> (the sequence number the receiver expects to receive) isn't reset.
>>>
>>> Spotted on a pair of AR9580 in IBSS mode.
>>>
>>> Signed-off-by: Krzysztof Halasa <khalasa@piap.pl>
>>>
>>> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
>>> index 4d1c335e06e5..67733bd61297 100644
>>> --- a/net/mac80211/agg-rx.c
>>> +++ b/net/mac80211/agg-rx.c
>>> @@ -354,10 +354,13 @@ void ___ieee80211_start_rx_ba_session(struct 
>>> sta_info *sta,
>>>                */
>>>               rcu_read_lock();
>>>               tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
>>> -            if (tid_rx && tid_rx->timeout == timeout)
>>> +            if (tid_rx && tid_rx->timeout == timeout) {
>>> +                tid_rx->ssn = start_seq_num;
>>> +                tid_rx->head_seq_num = start_seq_num;
>>>                   status = WLAN_STATUS_SUCCESS;
>> This is wrong, this is the case of *updating an existing session*, we
>> must not reset the head SN then.
>>
>> I think you just got very lucky (or unlucky) to have the same dialog
>> token, because we start from 0 - maybe we should initialize it to a
>> random value to flush out such issues.
>>
>> Really what I think probably happened is that one of your stations lost
>> the connection to the other, and didn't tell it about it in any way - so
>> the other kept all the status alive.
>>
>> I suspect to make all this work well we need to not only have the fixes
>> I made recently to actually send and parse deauth frames, but also to
>> even send an auth and reset the state when we receive that, so if we
>> move out of range and even the deauth frame is lost, we can still reset
>> properly.
>>
>> In any case, this is not the right approach - we need to handle the
>> "lost connection" case better I suspect, but since you don't say what
>> really happened I don't really know that that's what you're seeing.
>>
>> johannes
>
> Hi all,
>
> I can confirm the issue as I'm also seeing this sometimes in the field 
> here.
>
> Sometimes when a devices goes out of range and then re-enters,
> the link refuses to "come up", as in rx looks to be "stuck" without 
> any reports in system log or locking issues (lockdep enabled)
>
> I have dozens of devices installed offshore (802.11n based), both on 
> static and moving assets,
> which cover from short (250m) up to very long distances (~35km)
>
> So .. while there is some momentum for this issue,
> I'm more than happy to provide extensive testing should fixes be 
> posted regarding IBSS in general.
>
> Regards,
>
> Koen
>
>
