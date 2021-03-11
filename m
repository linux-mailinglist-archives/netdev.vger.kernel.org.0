Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43E2336E75
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 10:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhCKJGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 04:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhCKJGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 04:06:53 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57720C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:06:53 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id r7so2640521ilb.0
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 01:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mokalife.ro; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=H+OgWs0e37F82hnshsXgTKL00VzfqAloP56baI3nZcc=;
        b=C+n8SMLv9dHBw6b14fqG+fEqcgE//n57X1yhs9FdXYb3ldz2h4o21JknHoYYBGR2CN
         uHdUdEZZwdFyTjKuo7ggRu2xOlG1Tm4ek/+xNco5pkdhPmUDY+uJD5dFP7IYTViq/I3V
         U3XxDz50M7BRXS+x/YeCUMpQlqTQDahaWawwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=H+OgWs0e37F82hnshsXgTKL00VzfqAloP56baI3nZcc=;
        b=uDq82PrVllSJeO+0zNJFG8J4JSgiOuiSTq74LbMKd/QVraxru17OvFG6fBsaSUfSw8
         c5nHBrxNoVRYU18aHGVVF1nyem5b9I/QF2AbOD2AF+sbB3dB/gvrBr6PshCtuJbr5BOy
         BhS2uTf67rtll/wy/kXS0b+9VqL8X7+4woK61Z9WvmhI08w71msf8F51Hg61/EC/lXMh
         mi3iV49MiXPNTWFnfO10QyMinngOmVmwexNaBRTvqg7ZKlYGo+xjM90/87WDJJx4HdBB
         uqQSR+jltudAq7NBotJAifImbdnE3+i00F3KGd78E5j97GZGSgacLPcwS7xOrlTgHtgU
         SQ0g==
X-Gm-Message-State: AOAM533IA6nZ09nwSkCoNGhyKvuy35zswI3gaaepq20tp5g6RppL/cp/
        h6KZwbBnw0IzKlQbe73PWkvGX8bkJhrqnlRhqd14bAtYyyqw9g==
X-Google-Smtp-Source: ABdhPJzC9AJUo2ORePlxNxZXyJOYWYt4stEOOPBuwrpUmvPRpt8H9dZO1mtTapT3e1D48M9iUfJQ9uY02/r6jlGbTZE=
X-Received: by 2002:a05:6e02:180d:: with SMTP id a13mr6014518ilv.156.1615453612633;
 Thu, 11 Mar 2021 01:06:52 -0800 (PST)
MIME-Version: 1.0
From:   Mihai <m@mokalife.ro>
Date:   Thu, 11 Mar 2021 11:06:41 +0200
Message-ID: <CANk_n4Y9bDmDCah2Tm66=X2o6uwcTz1amxcod6=AW4ZJE=1NsA@mail.gmail.com>
Subject: Kernel Routing tabel
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have 2 NIC with ips
eth1: 10.100.1.2/30
eth2: 10.200.1.2/30
both of them must reach IP: 172.16.16.1

what i've done so far:
eth1:
ip route add 10.100.1.0/30 dev eth1 src 10.100.1.2 scope link table 100
ip route add default via 10.100.1.1 dev eth1 table 100
ip rule add from 10.100.1.0/30 dev eth1 table 100
ip rule add to 10.100.1.0/30 dev eth1 table 100
ip rule add to 172.16.16.1 lookup 100

eth2:
ip route add 10.200.1.0/30 dev eth1 src 10.200.1.2 scope link table 200
ip route add default via 10.200.1.1 dev eth2 table 200
ip rule add from 10.200.1.0/30 dev eth2 table 200
ip rule add to 10.200.1.0/30 dev eth2 table 200
ip rule add to 172.16.16.1 lookup 200

It kinda works if I ping with source interface, but i have the problem:
 - that the packet goes on the interface with the lowest priority
between eth1 and eth2.

How can I make it work so that when the packet originates from eth1 it
goes through eth1 and so on.?
