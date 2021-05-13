Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31383800C8
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhEMXY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:24:27 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:10341 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhEMXYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1620948194; x=1652484194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5SJBpI8xr+qMRBkIHhCmRmUBPGxcsbJp1rEQpocKtJY=;
  b=fcmdxZjfrXz8IdpKayKpGW/PtQLITvpGegd+A/svQKbPAhcK/aw6I4TV
   +RplO83QQi4fcEwZoWq1EW9ZF7zcH1v+rKgKNRKAdmc4FjN/liI0wb9sA
   ZVCv+lkcGGI5ZPJ1nyLRlV10FeAaKO7M2QneYhMdxvymBXMp66O+7JoYz
   c=;
X-IronPort-AV: E=Sophos;i="5.82,296,1613433600"; 
   d="scan'208";a="113546482"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 13 May 2021 23:23:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id B225EA2291;
        Thu, 13 May 2021 23:23:09 +0000 (UTC)
Received: from EX13D04ANB001.ant.amazon.com (10.43.156.100) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 13 May 2021 23:23:09 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.137) by
 EX13D04ANB001.ant.amazon.com (10.43.156.100) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 13 May 2021 23:23:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii.nakryiko@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 00/11] Socket migration for SO_REUSEPORT.
Date:   Fri, 14 May 2021 08:23:00 +0900
Message-ID: <20210513232300.30772-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAEf4BzYumt7BO1BgN8kLXZmbYXuJweH0bWiT-CiDRQfvaRg0kQ@mail.gmail.com>
References: <CAEf4BzYumt7BO1BgN8kLXZmbYXuJweH0bWiT-CiDRQfvaRg0kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D06UWC002.ant.amazon.com (10.43.162.205) To
 EX13D04ANB001.ant.amazon.com (10.43.156.100)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 May 2021 14:27:13 -0700
> On Sun, May 9, 2021 at 8:45 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > The SO_REUSEPORT option allows sockets to listen on the same port and to
> > accept connections evenly. However, there is a defect in the current
> > implementation [1]. When a SYN packet is received, the connection is tied
> > to a listening socket. Accordingly, when the listener is closed, in-flight
> > requests during the three-way handshake and child sockets in the accept
> > queue are dropped even if other listeners on the same port could accept
> > such connections.
[...]
> 
> One test is failing in CI ([0]), please take a look.
> 
>   [0] https://travis-ci.com/github/kernel-patches/bpf/builds/225784969

Thank you for checking.

The test needs to drop SYN+ACK and currently it is done by iptables or
ip6tables. But it seems that I should not use them. Should this be done
by XDP?

---8<---
iptables v1.8.5 (legacy): can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.
ip6tables v1.8.5 (legacy): can't initialize ip6tables table `filter': Table does not exist (do you need to insmod?)
Perhaps ip6tables or your kernel needs to be upgraded.
---8<---

