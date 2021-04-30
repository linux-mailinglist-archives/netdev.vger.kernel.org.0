Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB8036F9C9
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhD3MJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhD3MJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 08:09:23 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEFCC06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 05:08:35 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lcRwf-0024AN-CI; Fri, 30 Apr 2021 14:08:33 +0200
Message-ID: <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nikolai Zhubr <zhubr.2@gmail.com>,
        Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org,
        nic-devel@qualcomm.com
Date:   Fri, 30 Apr 2021 14:08:32 +0200
In-Reply-To: <608BF122.7050307@gmail.com> (sfid-20210430_135009_123201_5C9D80DA)
References: <608BF122.7050307@gmail.com>
         (sfid-20210430_135009_123201_5C9D80DA)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolai,

Wow - old code. And yet I'm still even using the device. Time to replace
the system that has it ;-)

> Now, after debugging it a little bit more, I've apparently found the 
> root cause. One can see in net/ipv4/ipconfig.c that ic_open_devs() tries 
> to ensure carrier is physically present. But before opening device(s) 
> and starting wait for the carrier, it calls rtnl_lock(). Now in 
> ethernet/atheros/alx/main.c one can see that at opening, it first calls 
> netif_carrier_off() then schedules alx_link_check() to do actual work, 
> so carrier detection is supposed to happen a bit later. Now looking at 
> this alx_link_check() carefully, first thing is does is rtnl_lock(). 
> Bingo! Double-lock. Effectively actual carrier check in alx is therefore 
> delayed just until ic_open_devs() gave up waiting for it and called 
> rtnl_unlock(). Hence this delay and timeout.

Fun. But we can just do it synchronously?

https://p.sipsolutions.net/e4f076ed1b4c8a78.txt

johannes

