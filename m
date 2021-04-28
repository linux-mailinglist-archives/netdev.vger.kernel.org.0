Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDF936D996
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhD1O3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhD1O3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 10:29:08 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 4B4A1C061573
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 07:28:23 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id 3F5EE55B235;
        Wed, 28 Apr 2021 14:28:22 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619618465; t=1619620102;
        bh=VCdjVmz5p97uzhJIgNPBAMvTLEF1wAZ6Fhnge8Z/eiY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XVCf4g7AOP2l3ZjQ/boX8dKbD74WH/g3co6u3pJTPm5DMeAw6W8kXLJnhNCzhE4gN
         Z2VOfMfR48jyW6dRiL2pmZNJ9NhktpboV7Wc1hjdiSIN+sLEiDod5NJK8SOJrJOaVg
         N4eRF77E6xUdVNU/nRzQHgtoFNr24OZyfFGnpjuPeHqI0R2RNO7GEoO8NjzJfJ358W
         4kbUwsYf1aiDNWgFYGSYqXXB9xZ3NQexT/eDZX6YVJFvbx/235L3DxTbN3WtBS/f9s
         FDzNjRtVnQaIHrkNE+E+4Htn2fleEPvS/m2GVgnEZkPiZTXdvV3L1XUBcCJsOWzzi5
         HcspAf9vjOItA==
Message-ID: <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
Date:   Wed, 28 Apr 2021 10:28:22 -0400
MIME-Version: 1.0
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Content-Language: en-US
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
 <20210428141319.GA7645@1wt.eu>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <20210428141319.GA7645@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 10:13, Willy Tarreau wrote:
> On Wed, Apr 28, 2021 at 10:09:00AM -0400, Matt Corallo wrote:
> Regardless of retransmits, large RTTs are often an indication of buffer bloat
> on the path, and this can take some fragments apart, even worse when you mix
> this with multi-path routing where some fragments may take a short path and
> others can take a congested one. In this case you'll note that the excessive
> buffer time can become a non-negligible part of the observed RTT, hence the
> indirect relation between the two.

Right, buffer bloat is definitely a concern. Would it make more sense to reduce the default to somewhere closer to 3s?

More generally, I find this a rather interesting case - obviously breaking *deployed* use-cases of Linux is Really Bad, 
but at the same time, the internet has changed around us and suddenly other reasonable use-cases of Linux (ie as a 
router processing real-world consumer flows - in my case a stupid DOCSIS modem dropping 1Mbps from its measly 20Mbps 
limit) have slowly broken instead.

Matt
