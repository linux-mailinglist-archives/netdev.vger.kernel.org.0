Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C440E52F973
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240587AbiEUG64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 02:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347014AbiEUG6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 02:58:54 -0400
X-Greylist: delayed 504 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 23:58:52 PDT
Received: from salt.gogi.eu (salt.gogi.eu [IPv6:2001:8d8:8a9:3f10::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C30185421
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 23:58:52 -0700 (PDT)
Received: from [IPV6:2001:4090:a242:8012::7d9] (unknown [IPv6:2001:4090:a242:8012::7d9])
        by salt.gogi.eu (Postfix) with ESMTPSA id 3BBF0EFC13
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 06:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gogi.tv; s=helium;
        t=1653115824; bh=YKq7S9rhD2MKBzTexGGIBl1DV+G0IUT24N/TfhoQR2Q=;
        h=Date:To:From:Subject:From;
        b=b/p7D25HcB8kMXoEo2dHTbu5+/OiQlMXYdJne1pMrNJTkWCXa+ygrxZdMcOboAYpd
         Du+J2Nr5OKOaXyrlTC1LeCNI/hs/qJgleGP/evVrdqU3V5LY264EFgeDMEiZzsJ09G
         qa4F5Hrb3E2uuRSuRzKUEiFi3xPl/LkN7bB92awsS+Foa+d2APcnbVvatbVySfixys
         lH+q14tQSn/OZj1jzr8jcRuHlfkyFo32VFrl0UszPHi8WfIOt6Wm3bSQ6erCCsMD+e
         rLFEwHvN3ZzrCCqcVF7Dt2YV05sJhJ1Y3+J1voiRfFtKasM7bGviC/AXcWbKi4BywD
         RWhXLYpV+h19A==
Message-ID: <aa6e4460-de47-7836-8fea-0170ea28f95f@gogi.tv>
Date:   Sat, 21 May 2022 08:50:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     netdev@vger.kernel.org
From:   Daniel Haid <d.haid@gogi.tv>
Subject: Stateless NAT rule and packets disappearing after postrouting hook
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

on my host, I have an interface eth0 where my ISP is routing packets
with destination 192.0.2.1 to me and the default gateway of the ISP is
198.51.100.1.

For certain reasons I do not wish to add the address 192.0.2.1 to any
interface, but instead add a private address 10.0.0.1 and use
stateless nat rules.

(I can explain the exact use case if you wish, but I think for now it
is not necessary. I deliberately removed all configuration except the
part with the problem.)

The configuration is as follows:

1) ip addr add 10.0.0.1/32 dev eth0
2) ip route add default via 198.51.100.1 onlink dev eth0

table ip filter {
	chain dnat {
		type filter hook prerouting priority -250;
		ip daddr 192.0.2.1 ip daddr set 10.0.0.1 counter;
	}
	chain snat {
		type filter hook postrouting priority 900;
		ip saddr 10.0.0.1 ip saddr set 192.0.2.1 counter;
	}
}

I expect to be able to connect to 192.0.2.1 from outside (for example
via ssh) and reach my host, but it does not work. The host does not
send any response packets. Indeed, the counter in the snat chain goes
up, but tcpdump does not show any corresponding output packets. How
can it happen that a packet passes the postrouting hook, but does not
reach the output interface?

Now the funny thing is: if I do not add any address at all, replace
10.0.0.1 with 127.0.0.1 everywhere, and set
net.ipv4.conf.all.route_localnet=1, then it works.

If I leave 127.0.0.1 in the rules, but still add the address 10.0.0.1
to eth0, then it sometimes works and sometimes not, depending on the
order of the commands 1) and 2).

This looks all very mysterious to me. How can I find out what is going
on?

Tested with kernel 5.16.12. I am not subscribed to the list, so please
Cc me.

D.H.
