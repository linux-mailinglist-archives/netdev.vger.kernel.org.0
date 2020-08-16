Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791C02456A7
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 10:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgHPIMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 04:12:02 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52991 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725986AbgHPIMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 04:12:02 -0400
Received: from keetweej.vanheusden.com ([82.161.210.122])
        by smtp-cloud8.xs4all.net with ESMTP
        id 7DlnkUi0fzsLP7DlokPd9X; Sun, 16 Aug 2020 10:12:00 +0200
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 0EA5516256D
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 10:11:59 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d9cv14yc1JJ0 for <netdev@vger.kernel.org>;
        Sun, 16 Aug 2020 10:11:58 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 33CF71624D3
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 10:11:58 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id 27626160307; Sun, 16 Aug 2020 10:11:58 +0200 (CEST)
Date:   Sun, 16 Aug 2020 10:10:13 +0200
From:   folkert <folkert@vanheusden.com>
To:     netdev@vger.kernel.org
Subject: ping not working
Message-ID: <20200816081013.GC16027@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.vanheusden.com
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL:  http://www.vanheusden.com/
X-PGP-KeyID: 1F077C42
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key:  http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F077C42
Reply-By: ma 10 aug 2020  0:06:00 CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-CMAE-Envelope: MS4wfO8xOpVni2M5ln+YIlD7sYSOQzJY1fCWE1IRiuHF7EzlmqcWEzSrbt90iyv1yIqsCiF78CELqdUd+YIXFT6fF5RZcWXwuY+tB3gIOdf/ag6GhnDr4C2j
 lmKqRiSkjC69OJL+1UOpQKhCRGb/PSsBRFEoNtsFPfjV3WlyzveM3WKRutoTuABs5uoKLKDI5oBKQw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This might be slightly off-topic altough it involves Linux, tap-device
and ping.

For fun I'm implementing an IP-stack. To do so I open a tap-device and
use read/write to obtain/send packets. I configured the interface with
IFF_NO_PI to not to get flags/protocol header.

At this point it can answer to ARP requests. If I use arping I see that
it replies to requests. Also by verifying in wireshark of course.

Now the problem is though, that ICMP doesn't work. When pinging, I see
packets coming in and replies going out but for some reasons ping
"doesn't see them". In wireshark everything looks fine:
https://vps001.vanheusden.com/~folkert/myip2.pcap (and
https://vps001.vanheusden.com/~folkert/myip.pcap ).
but if I run ping with strace I see something peculiar:

sendto(3, "\10\0&\354\0\0\0\1\303\3508_\0\0\0\0\10\370\r\0\0\0\0\0\20\21\22\23\24\25\26\27"..., 64, 0, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("192.168.3.2")}, 16) = 64
recvmsg(3, {msg_namelen=128}, 0)        = -1 EAGAIN (Resource temporarily unavailable)

As you see, the recvmsg (always!) fails with an EAGAIN.

My question now is: how can I debug this? Or is this a common bug (in 
implementations of ip stacks)?


Folkert van Heusden
