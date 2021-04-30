Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849BF3700EF
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 21:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhD3TDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 15:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3TDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 15:03:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C077C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 12:02:44 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lcYPR-002E0u-Rj; Fri, 30 Apr 2021 21:02:41 +0200
Message-ID: <acd09ebe17b438fad20d4863dfece84144b5e027.camel@sipsolutions.net>
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 30 Apr 2021 21:02:41 +0200
In-Reply-To: <608C3B2C.8040005@gmail.com> (sfid-20210430_190603_013225_96A76113)
References: <608BF122.7050307@gmail.com>
                 (sfid-20210430_135009_123201_5C9D80DA) <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>
         <608C3B2C.8040005@gmail.com> (sfid-20210430_190603_013225_96A76113)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-30 at 20:15 +0300, Nikolai Zhubr wrote:
> Hi Johannes,
> 
> 30.04.2021 15:08, Johannes Berg:
> > > rtnl_unlock(). Hence this delay and timeout.
> > 
> > Fun. But we can just do it synchronously?
> > 
> > https://p.sipsolutions.net/e4f076ed1b4c8a78.txt
> 
> Wow, that was quick! Thanks! However, unfortunately this patch still 
> does not quite fix the problem. Although alx_check_link() now gets 
> called synchronously at open, it somehow does not pass below the "if 
> (old_speed == hw->link_speed) return" line here. I'd guess it is because 
> the chip is not yet able to report meaningfull values immediately after 
> initialization. The result is still the same: 120 seconds timeout 
> happens, then the "eth0: NIC Up: 1 Gbps Full" message appears 
> immediately and all is fine after that.

Yeah so ... I guess we could poll it, but that's really quite ugly?

I wonder if we can detect this case somehow?

The more reasonable thing is probably to just rework the locking here,
but that's a touchy subject I guess.

How about this?

https://p.sipsolutions.net/5adbe659fb061f06.txt

johannes

