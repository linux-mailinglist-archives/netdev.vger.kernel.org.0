Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1391823378B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgG3RTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:19:24 -0400
Received: from mail.as201155.net ([185.84.6.188]:29779 "EHLO mail.as201155.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgG3RTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 13:19:23 -0400
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:54500 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1k1CD9-0005kR-1c; Thu, 30 Jul 2020 19:19:19 +0200
X-CTCH-RefID: str=0001.0A782F1D.5F230117.0050,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=47FfpEUngNOrDbK0FxoTLivet0N62PUjorlzAZ+Y5uo=;
        b=KRlvxZ+9ru/rNaY174fWpXAR8caDVljwb9Xb/RxeXiAlZZEQ4r3jF1cY9iUCaVMtq/MeS72cyrrvXx0eofQDKspDtyIlzNSz7dX2G3e84VcayLYduY7KxVyfuDY7ww0ySjKKraoJ5lJYkNXTtcHN1kZl4pzPcAhq3T6D3Abk3KE=;
Subject: Re: [PATCH] net: add support for threaded NAPI polling
To:     David Laight <David.Laight@ACULAB.COM>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200729165058.83984-1-nbd@nbd.name>
 <866c7d83-868d-120e-f535-926c4cc9e615@gmail.com>
 <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
 <1743bcaa2dfb4b6393b4d228cf079fe3@AcuMS.aculab.com>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <0de774d0-7e9e-8a44-0f0c-584a9cb9ee96@dd-wrt.com>
Date:   Thu, 30 Jul 2020 19:19:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <1743bcaa2dfb4b6393b4d228cf079fe3@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2a01:7700:8040:300:315c:d267:8dd:d539]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1k1CD8-00061U-VD; Thu, 30 Jul 2020 19:19:18 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 30.07.2020 um 17:42 schrieb David Laight:
> From: Sebastian Gottschall
>> Sent: 30 July 2020 15:30
> ...
>>> Quite frankly, I do believe this STATE_THREADED status should be a generic NAPI attribute
>>> that can be changed dynamically, at admin request, instead of having to change/recompile
>>> a driver.
>> thats not that easy. wifi devices do use dummy netdev devices. they are
>> not visible to sysfs and other administrative options.
>> so changing it would just be possible if a special mac80211 based
>> control would be implemented for these drivers.
>> for standard netdev devices it isnt a big thing to implement a
>> administrative control by sysfs (if you are talking about such a feature)
> ISTM that a global flag that made all NAPI callbacks be made
> from a worker thread rather than softint would be more approriate.
> Or even something that made the softint callbacks themselves
> only run an a specific high(ish) priority kernel thread.
>
> While it might slow down setups that need very low ethernet
> latency it will help those that don't want application RT threads
> to be 'stolen' by the softint code while they hold application
> mutex or are waiting to be woken by a cv.
this will not work either. i already identified drivers which are 
incompatible with that approach. (marvell mvneta for instance)
so threading should be a feature which should be enabled or disabled on 
known working chipsets. but it cannot be used as
set and forget feature for everything unless the specific driver are fixed.
>
> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
