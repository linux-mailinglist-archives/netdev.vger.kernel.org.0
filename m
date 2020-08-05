Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096ED23C7A6
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 10:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHEIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 04:20:04 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:14129 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgHEIUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 04:20:03 -0400
Date:   Wed, 05 Aug 2020 08:19:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1596615600; bh=vn0qT44OV5W87KqeK13q9tnzY9qrJwC/theaKs6fUfU=;
        h=Date:To:From:Reply-To:Subject:From;
        b=JIhecMNfnb0WTqLGrrgefuzexneaxYF1ZAQngcJ3eJGt27UBWlohjYlcbCP80iNoh
         ZRJ0aFRFXNocStnY1jtard6P1PLrJ7YDL2G1HKEParJVV4ZJwEpTu9iZgBH1YhGHKD
         CCidC4ynI0vmakm0c6YyL4hu9Hohrt4FNAtVXU3VxP0/VmCNUa3UlsLLN17Ucu7m0o
         mvui61BF54CLAkEPmobycuo2VzFmTMwMj5wBH/w6p426gQR0h7esq7SYZOt0vofkqk
         5Jh5HEXPHZ75onOi1e5oH41Xuu8o5M5w8YI7ZtHGqsfPdG+h/35b/glyOtSr24NPYd
         wAX35Fz7BQGpg==
To:     netdev@vger.kernel.org
From:   Swarm NameRedacted <thesw4rm@pm.me>
Reply-To: Swarm NameRedacted <thesw4rm@pm.me>
Subject: Packet not rerouting via different bridge interface after modifying destination IP in TC ingress hook
Message-ID: <20200805081951.4iznjdgudulitamc@chillin-at-nou.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am trying to build a quick script via TC direct action and eBPF to
modify the destination IP of a packet so that it is routed through a
different bridge interface. Made a quick network diagram below to
demonstrate it.=20

      Packet (dst: 10.10.3.2)
                |
                |
    ingress - (change dst to 10.10.4.1)
                |
                |
               eth0
                |
                |
      br0 - (addr: 10.10.3.1)
__eth0______   ___ens19_______
     |                |
     |                |
     |                |
     |                |
host: 10.10.4.1  host: 10.10.3.2



As shown, I send a packet from a separate client to eth0. eth0 is the
WAN interface of its machine and ens19 is the LAN interface; both are
connecting with bridge br0. Without modification, the packet goes
straight through ens19 to 10.10.3.2.=20

Theoretically, by modifying the destination IP to 10.10.4.1 at ingress,
the packet should be rerouted to go back through eth0. However, in
practice, I find that the packet still goes through ens19 after
modification, and of course after that it never reaches anything.=20

Why is it that ingress catches the packet before the bridging decision,
but the packet isn't rerouted? Is there a better way to do this?


