Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C413D9552
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhG1Sdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:33:39 -0400
Received: from tulum.helixd.com ([162.252.81.98]:48916 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhG1Sdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 14:33:38 -0400
Received: from [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242] (unknown [IPv6:2600:8801:8800:12e8:2884:1d04:ad3c:7242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 1B2B9203D4;
        Wed, 28 Jul 2021 11:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627497216;
        bh=IF1umYfV85xxHSGm0hQEWgxZ6haZxm2upbkHJz9FdQ0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ly5juGA77n7WqOFVYbqCegRb8nr9FePhGTVj13jUGdZHhdzpBTNhg67QG5xlLhUjp
         I0IWUbXHmX/wVSU4denz7DHcBAOWg2C3dMYBJUgXatbpfWZCVFrsQixNjNL7Lep1VZ
         D9I1qML3W/zUbpZ3+2oZIGUNLOVt+nQk+wePQYzo=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <YPrHJe+zJGJ7oezW@lunn.ch>
 <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com> <YPsJnLCKVzEUV5cb@lunn.ch>
 <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
 <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
 <527bcc43-d99c-f86e-29b0-2b4773226e38@helixd.com>
 <fb7ced72-384c-9908-0a35-5f425ec52748@helixd.com> <YQGgvj2e7dqrHDCc@lunn.ch>
From:   Dario Alcocer <dalcocer@helixd.com>
Message-ID: <59790fef-bf4a-17e5-4927-5f8d8a1645f7@helixd.com>
Date:   Wed, 28 Jul 2021 11:33:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQGgvj2e7dqrHDCc@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 11:23 AM, Andrew Lunn wrote:
> On Wed, Jul 28, 2021 at 11:07:37AM -0700, Dario Alcocer wrote:
>> It appears the port link-state issue is caused by the mv88e6xxx switch
>> driver. The function mv88e6xxx_mac_config identifies the PHY as internal and
>> skips the call to mv88e6xxx_port_setup_mac.
>>
>> It does not make sense to me why internal PHY configuration should be
>> skipped.
> 
> The switch should do the configuration itself for internal PHYs. At
> least that works for other switches. What value does CMODE have for
> the port? 0xf?
> 
>      Andrew
> 

Is CMODE available via the DSA debugfs? Here are the registers for 
port0, which should be lan1:

root@dali:~# ls /sys/kernel/debug/dsa/switch0/
port0/        port1/        port2/        port3/        port4/ 
port5/        port6/        tag_protocol  tree
root@dali:~# ls /sys/kernel/debug/dsa/switch0/port0/
fdb    mdb    regs   stats  vlan
root@dali:~# cat /sys/kernel/debug/dsa/switch0/port0/regs
  0: 100f
  1: 0003
  2: 0000
  3: 1761
  4: 0433
  5: 0000
  6: 0010
  7: 0000
  8: 2080
  9: 0001
10: 0000
11: 0001
12: 0000
13: 0000
14: 0000
15: 9100
16: 0000
17: 0000
18: 0000
19: 0000
20: 0000
21: 0000
22: 0033
23: 0000
24: 3210
25: 7654
26: 0000
27: 8000
28: 0000
29: 0000
30: 0000
31: 0000
root@dali:~#
