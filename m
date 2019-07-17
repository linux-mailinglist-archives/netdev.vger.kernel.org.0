Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2116C20C
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfGQUTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:19:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35104 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfGQUTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:19:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so23392185wmg.0;
        Wed, 17 Jul 2019 13:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=nqaMPv708RCiesrxZDz1cZrIB3dLCSSINVU8+So70w0=;
        b=qln0DjeKwd94XPAiTvY1WJ/CL7tTNBmdoL8p2i+aj2tj2RtVTVZWjR2Rb+16c1e1Kh
         jMlXYQBkLVc7H6+Fc44QHiGsKIibSnZ+IzbOj9/4EFAoPHu/A5Lv8MCPIaGpHW3j7+Xk
         6KHi3NJPjbBkDcZq3qMJkzna6/7asPVRyLLCIO1Xy2/yPL5DKHBaHRmLODzVhx3HZkpJ
         l5IrZn7PXCb5LL+8Fz5Tn7WqQhxHctBNeUIehZqVXkS8pRpuo6Rpql0j8SwmCjeWvPJv
         u3DrSsUnjGFSE7M/ACJGdn9+QoJjNRSI1tVc/mRWiGjT3hci2WzLTK4jYaCQ+FBGS4SP
         Z+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=nqaMPv708RCiesrxZDz1cZrIB3dLCSSINVU8+So70w0=;
        b=ibwmWH81ELSumkwW9w8un5wNhEPVEl/k2IDcK08z/wi0hgDn1fnx+EwNSSIv6oIsto
         l+rpZ2Qq2iBXAqemQUIuJ/FGbXQZVo/gFStjBGvz/Wt5r2louYrWP3ySmVkhdYHUDYiS
         8rTHwtuv5KbWeOKJk61DzSk/qO93JIuOrXzM5HGofDBeEy19FfISwYT/oSiK9DLqNXxb
         rXgnqKOgTv7G4WmW2V0rSdrjQOgLZmTAlHHpoUvkYWsjSsBerAOXvKGOXQdejvMd9oU2
         liq6eXy6YTRPF8Ux1RV0eVSR3xGk6yA58BTtPglUOXWWsUYkXABt1oSqvdgeT3wrfJua
         yyig==
X-Gm-Message-State: APjAAAVI+l2t2wkWvu/cs3ONpayHGqHU28un0rT0tv96NkpMbZCT5efN
        1kBSfiJbjHBFH9XzLXP2s+E=
X-Google-Smtp-Source: APXvYqwK1dsG8qqPpVwTplC7CW84CZEZ0F4XKUlx8chgxaOXxW7ZmkQrifWn4fhsWl8GynTuyQJ6EA==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr37260276wmf.124.1563394768433;
        Wed, 17 Jul 2019 13:19:28 -0700 (PDT)
Received: from debian ([78.40.148.180])
        by smtp.gmail.com with ESMTPSA id y1sm20423638wma.32.2019.07.17.13.19.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jul 2019 13:19:27 -0700 (PDT)
Date:   Wed, 17 Jul 2019 21:19:25 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     peterz@infradead.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: regression with napi/softirq ?
Message-ID: <20190717201925.fur57qfs2x3ha6aq@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I am using v4.14.55 on an Intel Atom based board and I am seeing network
packet drops frequently on wireshark logs. After lots of debugging it
seems that when this happens softirq is taking huge time to start after
it has been raised. This is a small snippet from ftrace:

           <...>-2110  [001] dNH1   466.634916: irq_handler_entry: irq=126 name=eth0-TxRx-0
           <...>-2110  [001] dNH1   466.634917: softirq_raise: vec=3 [action=NET_RX]
           <...>-2110  [001] dNH1   466.634918: irq_handler_exit: irq=126 ret=handled
     ksoftirqd/1-15    [001] ..s.   466.635826: softirq_entry: vec=3 [action=NET_RX]
     ksoftirqd/1-15    [001] ..s.   466.635852: softirq_exit: vec=3 [action=NET_RX]
     ksoftirqd/1-15    [001] d.H.   466.635856: irq_handler_entry: irq=126 name=eth0-TxRx-0
     ksoftirqd/1-15    [001] d.H.   466.635857: softirq_raise: vec=3 [action=NET_RX]
     ksoftirqd/1-15    [001] d.H.   466.635858: irq_handler_exit: irq=126 ret=handled
     ksoftirqd/1-15    [001] ..s.   466.635860: softirq_entry: vec=3 [action=NET_RX]
     ksoftirqd/1-15    [001] ..s.   466.635863: softirq_exit: vec=3 [action=NET_RX]

So, softirq was raised at 466.634917 but it started at 466.635826 almost
909 usec after it was raised.

If I move back to v4.4 kernel I still see similar behaviour but the maximum
delay I get is in the range of 500usec. But if I move back to v3.8 kernel I
can see there is no packet loss and the maximum delay between softirq_raise
and irq_handler_entry is 103usec.

Is this a known issue?
Will really appreciate your help in this problem.


--
Regards
Sudip

