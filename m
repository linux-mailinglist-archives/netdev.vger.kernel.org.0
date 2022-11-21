Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CDF631B79
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiKUIdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiKUIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:33:04 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E28FDEE1;
        Mon, 21 Nov 2022 00:33:03 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ox2Eb-0006QE-5Z; Mon, 21 Nov 2022 09:32:57 +0100
Message-ID: <fa0d345a-c3e5-fbf2-4fab-e43235e779b6@leemhuis.info>
Date:   Mon, 21 Nov 2022 09:32:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: [Regression] Bug 216711 - null SSID reported by systemd-networkd when
 connected to a WPA3 network
Cc:     Zoddo <kernel+bugzilla@zoddo.fr>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1669019583;410672d7;
X-HE-SMSGID: 1ox2Eb-0006QE-5Z
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216711 :

>  Zoddo 2022-11-19 15:36:02 UTC
> 
> Created attachment 303236 [details]
> Bisect log
> 
> Starting with linux 5.19.2, systemd-networkd reports a "(null)" SSID when connected to WPA3 network.
> 
> Steps to reproduce:
> 1. Get a system with systemd-networkd (maybe this issue can be exhibited with other methods, but using systemd-netword is the only one I know; I haven't found how to get this data directly from the kernel)
> 2. Connect to a wireless network using WPA3.
> 3. Run "networkctl status <wlan interface>", and observe that "WiFi access point" shows "(null)" instead of the network's SSID.
> 4. If you try again with a WPA2 network, the SSID is shown as expected. WPA3 network also behaves as expected on kernel <=5.19.1
> 
> This bug also affects linux 6.0 (tested on 6.0.8).
> 
> 
> Bisection identified the following commit as the culprit:
> (full bisect log attached)
> 
> 7a53ad13c09150076b7ddde96c2dfc5622c90b45 is the first bad commit
> commit 7a53ad13c09150076b7ddde96c2dfc5622c90b45
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Thu Apr 14 16:50:57 2022 +0200
> 
>     wifi: cfg80211: do some rework towards MLO link APIs
>     
>     [ Upstream commit 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1 ]
>     
>     In order to support multi-link operation with multiple links,
>     start adding some APIs. The notable addition here is to have
>     the link ID in a new nl80211 attribute, that will be used to
>     differentiate the links in many nl80211 operations.


See the ticket for more details.

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: 7b0a0e3c3a882
https://bugzilla.kernel.org/show_bug.cgi?id=216711
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
