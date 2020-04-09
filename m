Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A071A35B2
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgDIOQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 10:16:56 -0400
Received: from forward104o.mail.yandex.net ([37.140.190.179]:42967 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbgDIOQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 10:16:55 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2020 10:16:54 EDT
Received: from mxback8j.mail.yandex.net (mxback8j.mail.yandex.net [IPv6:2a02:6b8:0:1619::111])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id B30FC940216
        for <netdev@vger.kernel.org>; Thu,  9 Apr 2020 17:09:26 +0300 (MSK)
Received: from myt5-aad1beefab42.qloud-c.yandex.net (myt5-aad1beefab42.qloud-c.yandex.net [2a02:6b8:c12:128:0:640:aad1:beef])
        by mxback8j.mail.yandex.net (mxback/Yandex) with ESMTP id 19iKenMs1s-9QgOpKVT;
        Thu, 09 Apr 2020 17:09:26 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586441366;
        bh=ju9OklVeZVc/dFMqH1Br0uaEFnQkCl2mdMe1niK0OqQ=;
        h=Subject:From:To:Date:Message-ID;
        b=ky2aO2zW2XY8jOL1pvSQ5KFNN/rK8jfsAvr6Bb/WEoEaP569lELQNjsDq6Wud6ayI
         8p7++dwWNKLF3WBK3v6AmQTdIXf7YsGR8ITASlQdLfCTsNLbixKf1NBPsHWNUuGBFS
         hzlLXyDim/5MJUwl82p0M7yZ3hRlgOc6KPtls3Vc=
Authentication-Results: mxback8j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-aad1beefab42.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id QO1kx9vMAr-9QXCwLJf;
        Thu, 09 Apr 2020 17:09:26 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     netdev@vger.kernel.org
From:   Konstantin Kharlamov <hi-angel@yandex.ru>
Subject: On 5.6.2, SCTP is 10 000 times slower than TCP
Message-ID: <09cc102b-31d1-b0e8-3ea1-3b07b9a6df74@yandex.ru>
Date:   Thu, 9 Apr 2020 17:09:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB-large
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was considering, whether SCTP could be faster than TCP, and made some
measurements. Results are astonishing: 4.74 GB/sec for TCP vs 590, KB/sec for
SCTP. Let me rephrase: that is 4.74 GB/sec vs 0.00059 GB/sec! Wow. This looks
sooo wrong, that this is probably a bug, so I'm reporting it here.

Tests are done on kernel 5.6.2 with qperf 0.4.11 as follows:

1. Run `qperf` in one terminal
2. Run `qperf -v localhost tcp_bw tcp_lat sctp_bw sctp_lat` in the other terminal

Below are 4 results for my Dell Inspiron 5767 laptop.

Test number | TCP bandwidth | TCP latency, μs | SCTP bandwidth | SCTP latency, μs
1           | 4.74 GB/sec   | 6.81            | 590, KB/sec    | 11.8
2           | 5 GB/sec      | 6.79            | 721, KB/sec    | 10.5
3           | 4.73 GB/sec   | 6.76            | 8.39, MB/sec   | 10.9
4           | 5.7 GB/sec    | 6.1             | 53.4, MB/sec   | 9.33

FWIW, I also made some measurements on a server hw with older kernel 4.19. The
difference there is not that big, yet even there SCTP is twice as slower compared
to TCP.

P.S.: please add me to CC when replying as I'm not subscribed to the list.
