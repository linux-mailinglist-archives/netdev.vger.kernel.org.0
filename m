Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048FCC9461
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfJBWdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:33:44 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44345 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJBWdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:33:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id i14so451823pgt.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sx3xlJg7GOZyUod4vSscLgIDT8VPjvBDgm1sgN0BggM=;
        b=vhJB22153Y29sTrpqalUMsod5gjwLr0NfhEWf5zdny9CWCV8XjGdG5ztFUcZMm8N+P
         f5w437+JVM6zr/ivXTTVUUwefLeqoL7SXMmp28NJf5sKguNSQ3aBzfQBkC4gtBFmQWsH
         dC3Dn5jL2Ors4uk3aBR+n01zyf3WHImzuJsftlyxz8dRKKvQlczWm7p682UIXBxLTC2/
         mOsjC/FXwEqQALBgvk4zUdB+ENVt/jXM1o8ldC1U/B7A3NQ/AVVIl6xxL51vWSD+vpdp
         Typ5gCBWUkClE/e9v/maxbHNymcEyAUtihFJoTuAQ1JALS5ousbL+H4xeyQUove7wvDi
         u5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sx3xlJg7GOZyUod4vSscLgIDT8VPjvBDgm1sgN0BggM=;
        b=mJ97jdQ9QY7+RRH3FZZJPnVNWofLZd2BrfcimGUqEv5Qtci1hWM/ZyDDmcIj/+kJ/G
         jMZDBLeRl7bNiHDmR7fkf1EM9xsDnWU0l3HxiGeFRmjhpBlFs1z5JsU1cY6M5hVP8+y4
         5gq8D9c7Z7lU+68LbL+BME0S90De8EXk9Co455e0bFvWeuRtHj03unoUei3dInHUeDJu
         JWaoCpRkoruPYBx//azfTt0AaeH7liS/LHD2PsboUBbJAVeuWb7ZMzdP8B6HsdU/It50
         dwEtjxbuQ5caKVap68MpTZ3dEAAJPktXY28o9EFug9jD1GdBjM5oSZfNdz2hpMmmZnGV
         Kzew==
X-Gm-Message-State: APjAAAX9UStK/ne1QsgnA16J2AQKA1OhGxEHzE2xhTOCsVQpsfrDAIrO
        uSFIuzaATiuc6tjGrvERels=
X-Google-Smtp-Source: APXvYqy+BNaDJ4/08RPAz9wcU/nqZg2SPFOEpRxKuH64R6+WiraVEGsgAbvf7a+vRGk+kLEtuEtTyA==
X-Received: by 2002:a63:9742:: with SMTP id d2mr5988814pgo.356.1570055623199;
        Wed, 02 Oct 2019 15:33:43 -0700 (PDT)
Received: from dahern-DO-MB.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id f62sm471162pfg.74.2019.10.02.15.33.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 15:33:41 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
Date:   Wed, 2 Oct 2019 16:33:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 4:21 PM, Eric Dumazet wrote:
> o syzbot this time, but complete lack of connectivity on some of my test hosts.
> 
> Incoming IPv6 packets go to ip6_forward() (!!!) and are dropped there.

what does 'ip -6 addr sh' show when it is in this state? Any idea of the
order of events?

> 
> There seems to be something missing.
> 
> ifp->state stays at INET6_IFADDR_STATE_PREDAD instead of INET6_IFADDR_STATE_DAD
> 

My original suggestion to Rajendra was this:

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c39..5ec795086432 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4032,6 +4032,12 @@ static void addrconf_dad_work(struct work_struct *w)

        rtnl_lock();

+       /* device was taken down before this delayed work function
+        * could be canceled
+        */
+       if (!(idev->dev->flags & IFF_UP))
+               goto out;
+
        spin_lock_bh(&ifp->lock);
        if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
                action = DAD_BEGIN;


I flipped to IF_READY based on addrconf_ifdown and idev checks seeming
more appropriate.
