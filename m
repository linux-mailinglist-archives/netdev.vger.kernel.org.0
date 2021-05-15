Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359A23815A5
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 06:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhEOECd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 00:02:33 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:49413 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhEOECb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 00:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621051279; x=1652587279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M2rFgp0eLDIkrU5hO0egAxRWPM6hKufJOnPNNrgq0Gw=;
  b=o9+DnL8weeST470qgfdrUSG5aLAmmqiI6xcIK8eJdiIJPElsyFripG+O
   OaUVLsYT4PC7L0QrFhtw2mA4GJ0AyhAwz4FnTGsiVtSgLXTok1txaavAK
   VJBG1NuQh5ueb+2OTutIN/iPSDKYE8BGtnhfSVawH3e3qWwW41cnulmEn
   4=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="113785155"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 15 May 2021 04:01:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 9BC84A204B;
        Sat, 15 May 2021 04:01:15 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:01:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.93) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:01:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 01/11] net: Introduce net.ipv4.tcp_migrate_req.
Date:   Sat, 15 May 2021 13:01:04 +0900
Message-ID: <20210515040104.79837-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210515004720.avji2fdh75y2yqhy@kafai-mbp>
References: <20210515004720.avji2fdh75y2yqhy@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D25UWB002.ant.amazon.com (10.43.161.44) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 14 May 2021 17:47:20 -0700
> On Mon, May 10, 2021 at 12:44:23PM +0900, Kuniyuki Iwashima wrote:
> > This commit adds a new sysctl option: net.ipv4.tcp_migrate_req. If this
> > option is enabled or eBPF program is attached, we will be able to migrate
> > child sockets from a listener to another in the same reuseport group after
> > close() or shutdown() syscalls.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > ---
> >  Documentation/networking/ip-sysctl.rst | 20 ++++++++++++++++++++
> >  include/net/netns/ipv4.h               |  1 +
> >  net/ipv4/sysctl_net_ipv4.c             |  9 +++++++++
> >  3 files changed, 30 insertions(+)
> > 
> > diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> > index c2ecc9894fd0..8e92f9b28aad 100644
> > --- a/Documentation/networking/ip-sysctl.rst
> > +++ b/Documentation/networking/ip-sysctl.rst
> > @@ -732,6 +732,26 @@ tcp_syncookies - INTEGER
> >  	network connections you can set this knob to 2 to enable
> >  	unconditionally generation of syncookies.
> >  
> > +tcp_migrate_req - INTEGER
> > +	The incoming connection is tied to a specific listening socket when
> > +	the initial SYN packet is received during the three-way handshake.
> > +	When a listener is closed, in-flight request sockets during the
> > +	handshake and established sockets in the accept queue are aborted.
> > +
> > +	If the listener has SO_REUSEPORT enabled, other listeners on the
> > +	same port should have been able to accept such connections. This
> > +	option makes it possible to migrate such child sockets to another
> > +	listener after close() or shutdown().
> > +
> > +	Default: 0
> > +
> > +	Note that the source and destination listeners MUST have the same
> > +	settings at the socket API level. If different applications listen
> It is a bit confusing on what "source and destination listeners" and
> "same settings at the socket API level" mean.
> 
> Does it mean to say a bpf prog should usually be used to define the policy
> to pick an alive listener.  If bpf prog is absence, the kernel will
> randomly pick an alive listener only if this sysctl is enabled?

Yes.

If there are two listeners having different setsockopt() settings and no
ebpf prog is attached, randam pick may crash applications.

Let's say, the migration happens from listener A to B, and only B has
TCP_SAVE_SYN enabled. Then B cannot read SYN from some requests migrated
from A.

I've written this in commit log in v2, but somehow dropped in v3...
https://lore.kernel.org/netdev/20201207132456.65472-7-kuniyu@amazon.co.jp/

I will change the description more specific.


> 
> Others lgtm.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thank you!


> 
> > +	on the same port, disable this option or attach the
> > +	BPF_SK_REUSEPORT_SELECT_OR_MIGRATE type of eBPF program to select
> > +	the correct socket by bpf_sk_select_reuseport() or to cancel
> > +	migration by returning SK_DROP.
> > +
