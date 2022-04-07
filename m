Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170354F8933
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 00:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiDGUfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiDGUfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:35:22 -0400
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4455F32CF0D
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 13:20:42 -0700 (PDT)
X-KPN-MessageId: c6c2344c-b6aa-11ec-8ee3-005056992ed3
Received: from smtp.kpnmail.nl (unknown [10.31.155.5])
        by ewsoutbound.so.kpn.org (Halon) with ESMTPS
        id c6c2344c-b6aa-11ec-8ee3-005056992ed3;
        Thu, 07 Apr 2022 21:41:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kpnmail.nl; s=kpnmail01;
        h=content-type:mime-version:message-id:subject:to:from:date;
        bh=hjvZqgXeDwKH8P5VxOyKeWRKImo/q4afjRuG5zh77gM=;
        b=kAX2VwSPWDMVA29hLsIpXvwixEBmio+QvIsGRtWfuhvNJ0QJowhVyh8DObUiiVW25cf4jFi3juvdT
         ACfp6YJlONKiMr31v1s4QjYuqmmlUWaMUD03HMSaoB3hEe5kk3OrpMBtdfLNGkouiFZ2cpfmHoK36X
         zs2L+eXKJm43xsAA=
X-KPN-VerifiedSender: No
X-CMASSUN: 33|ZScZ/H0icfjKlzt/z43LxTY8nKNH3TtpaLdIR18vJaLiVjWLZ0vxtW7R5iT6plt
 2bZcElZrfL0uOEGH5glwq3Q==
X-Originating-IP: 80.100.101.20
Received: from keetweej.vanheusden.com (keetweej.vanheusden.com [80.100.101.20])
        by smtp.xs4all.nl (Halon) with ESMTPSA
        id e2394daa-b6aa-11ec-bbb9-00505699b758;
        Thu, 07 Apr 2022 21:42:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by keetweej.vanheusden.com (Postfix) with ESMTP id B45BF15F991
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 21:42:39 +0200 (CEST)
Received: from keetweej.vanheusden.com ([127.0.0.1])
        by localhost (mauer.intranet.vanheusden.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YT6COsUwo1Vn for <netdev@vger.kernel.org>;
        Thu,  7 Apr 2022 21:42:38 +0200 (CEST)
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com [192.168.64.100])
        by keetweej.vanheusden.com (Postfix) with ESMTP id 71CC315F75F
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 21:42:38 +0200 (CEST)
Received: by belle.intranet.vanheusden.com (Postfix, from userid 1000)
        id 6293A160202; Thu,  7 Apr 2022 21:42:38 +0200 (CEST)
Date:   Thu, 7 Apr 2022 21:42:38 +0200
From:   folkert <folkert@vanheusden.com>
To:     netdev@vger.kernel.org
Subject: bug while receiving SNMP replies (UDP)?
Message-ID: <20220407194238.GB3334152@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Reply-By: Fri 08 Apr 2022 01:56:37 PM CEST
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URI_TRY_3LD
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm developing my own IP-stack (for fun, nothing serious). It also
features an snmp-agent.

Now something strange is happening when doing an snmpwalk. This does not
happen everywhere (e.g. not all friends with Linux I asked to try it so
could confirm the problem) and not always but quite often. I see it
happening with at least kernel 5.16.0-6-amd64 and
linux-image-4.19.0-17-amd64. Also intel or raspberry pi no difference.

What is happening:

21:02:18 57d/1z root@mauer:~ 47s 148 # snmpwalk -c public -v 1 myip.vanheusden.com iso
iso.3.6.1.2.1.1.1.0 = STRING: "MyIP - an IP-stack implemented in C++ running in userspace"
iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.2.1.4.57850.1
iso.3.6.1.2.1.1.3.0 = Timeticks: (938172) 2:36:21.72
Timeout: No Response from myip.vanheusden.com

So you see that it times-out after 3 snmp 'getnext's.

The strange thing here now is though: if I do tcpdump, I see the replies
come in. If I then strace snmpwalk I see the UDP packets not come in
there (pselect times out). dmesg shows no errors or warnings.

21:02:21.935486 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(21)  .0.1
21:02:21.943187 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(92)  .1.3.6.1.2.1.1.1.0="MyIP - an IP-stack implemented in C++ running in userspace"
21:02:21.943523 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.1.0
21:02:21.949822 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(44)  .1.3.6.1.2.1.1.2.0=.1.3.6.1.2.1.4.57850.1
21:02:21.950183 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.2.0
21:02:21.957688 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(38)  .1.3.6.1.2.1.1.3.0=938172
21:02:21.957956 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.3.0
21:02:21.965300 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(75)  .1.3.6.1.2.1.1.4.0="Folkert van Heusden <mail@vanheusden.com>"
21:02:22.958318 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.3.0
21:02:22.966724 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(75)  .1.3.6.1.2.1.1.4.0="Folkert van Heusden <mail@vanheusden.com>"
21:02:23.959428 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.3.0
21:02:23.967058 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(75)  .1.3.6.1.2.1.1.4.0="Folkert van Heusden <mail@vanheusden.com>"
21:02:24.960165 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.3.0
21:02:24.969778 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(75)  .1.3.6.1.2.1.1.4.0="Folkert van Heusden <mail@vanheusden.com>"
21:02:25.961346 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.3.0
21:02:25.967545 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(75)  .1.3.6.1.2.1.1.4.0="Folkert van Heusden <mail@vanheusden.com>"
21:02:26.962047 IP 192.168.178.2.55233 > 185.243.112.68.161: GetNextRequest(28)  .1.3.6.1.2.1.1.3.0
21:02:26.969202 IP 185.243.112.68.161 > 192.168.178.2.55233: GetResponse(75)  .1.3.6.1.2.1.1.4.0="Folkert van Heusden <mail@vanheusden.com>"

I thought of a firewall-issue, but I would expect to then either get ALL data
or NONE at all, not a bit. But to be sure I added:

iptables -A INPUT -i $EXTERNAL_I -p udp --dport 161 -j ACCEPT
iptables -A INPUT -i $EXTERNAL_I -p udp --sport 161 -j ACCEPT

iptables -A FORWARD -i $EXTERNAL_I -p udp --dport 161 -j ACCEPT
iptables -A FORWARD -i $EXTERNAL_I -p udp --sport 161 -j ACCEPT
iptables -A FORWARD -o $EXTERNAL_I -p udp --dport 161 -j ACCEPT
iptables -A FORWARD -o $EXTERNAL_I -p udp --sport 161 -j ACCEPT

Things like portnumbers and snmp sequence numbers are correct.

Sometimes it works (I get ~73 lines) but then on a laptop behind this
firewall-system I again get only 3 lines after which it stops again
(that laptop has only policy-accept firewall rules and default debian
kvm/virt-manager rules).

When I trace dropped packets, it looks like they're dropped in
nf_hook_slow+0x8f/0xb0. Maybe NF_DROP or NF_QUEUE returning an error?

Could this be a kernel-issue? And/or any hints to track this further
down?


regards
