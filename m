Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A7A14E932
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 08:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgAaHlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 02:41:44 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:15475 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbgAaHln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 02:41:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580456503; x=1611992503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=hXqcxoeUTXv6Sl/D/o2xVhucn86dLhacZQT1P/cIuzM=;
  b=VsXqKMr7mO312v5ohuH8XjkUnzIt36KoDYQhKwgEHa6yIdpnjWHqB85X
   TNTn0Kk7o/x7ABgvPCoRDa9K3C+gJGtGJRRpyFACsWdoiH4PwE0GSwKgC
   KDaglHlrsojI/XxhHFBFRSLIKT8Xl/aj7S1yX+sUtX9QXKVFiso9fbq9/
   0=;
IronPort-SDR: TDVLF5psLVoz4B8kmnPSKaCBxvX8j+VejGNDcH7bgeJuy0/p1gPPyG1+1SwQ0HFCFa+vcpb7p8
 3JUDRyKLDbEg==
X-IronPort-AV: E=Sophos;i="5.70,385,1574121600"; 
   d="scan'208";a="14975291"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 31 Jan 2020 07:41:41 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id CC8DEC08EB;
        Fri, 31 Jan 2020 07:41:37 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 07:41:37 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.29) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 07:41:30 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <sjpark@amazon.com>, David Miller <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        <andriin@fb.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <aams@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <dola@amazon.com>
Subject: Re: Re: Re: Latency spikes occurs from frequent socket connections
Date:   Fri, 31 Jan 2020 08:41:16 +0100
Message-ID: <20200131074116.8684-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iKDn2XhrnLo2rLf7HGXanEuokprqJ_mb0iPqXEnARc9tw@mail.gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.29]
X-ClientProxiedBy: EX13D13UWA002.ant.amazon.com (10.43.160.172) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 09:02:08 -0800 Eric Dumazet <edumazet@google.com> wrote:

> On Thu, Jan 30, 2020 at 4:41 AM <sjpark@amazon.com> wrote:
> >
> > On Wed, 29 Jan 2020 09:52:43 -0800 Eric Dumazet <edumazet@google.com> wrote:
> >
> > > On Wed, Jan 29, 2020 at 9:14 AM <sjpark@amazon.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > >
> > > > We found races in the kernel code that incur latency spikes.  We thus would
> > > > like to share our investigations and hear your opinions.
> > > >
[...]
> > >
> > > I would rather try to fix the issue more generically, without adding
> > > extra lookups as you did, since they might appear
> > > to reduce the race, but not completely fix it.
> > >
> > > For example, the fact that the client side ignores the RST and
> > > retransmits a SYN after one second might be something that should be
> > > fixed.
> >
> > I also agree with this direction.  It seems detecting this situation and
> > adjusting the return value of tcp_timeout_init() to a value much lower than the
> > one second would be a straightforward solution.  For a test, I modified the
> > function to return 1 (4ms for CONFIG_HZ=250) and confirmed the reproducer be
> > silent.  My following question is, how we can detect this situation in kernel?
> > However, I'm unsure how we can distinguish this specific case from other cases,
> > as everything is working as normal according to the TCP protocol.
> >
> > Also, it seems the value is made to be adjustable from the user space using the
> > bpf callback, BPF_SOCK_OPS_TIMEOUT_INIT:
> >
> >     BPF_SOCK_OPS_TIMEOUT_INIT,  /* Should return SYN-RTO value to use or
> >                                  * -1 if default value should be used
> >                                  */
> >
> > Thus, it sounds like you are suggesting to do the detection and adjustment from
> > user space.  Am I understanding your point?  If not, please let me know.
> >
> 
> No, I was suggesting to implement a mitigation in the kernel :
> 
> When in SYN_SENT state, receiving an suspicious ACK should not
> simply trigger a RST.
> 
> There are multiple ways maybe to address the issue.
> 
> 1) Abort the SYN_SENT state and let user space receive an error to its
> connect() immediately.
> 
> 2) Instead of a RST, allow the first SYN retransmit to happen immediately
> (This is kind of a challenge SYN. Kernel already implements challenge acks)
> 
> 3) After RST is sent (to hopefully clear the state of the remote),
> schedule a SYN rtx in a few ms,
> instead of ~ one second.

Thank you for this kind comment, Eric!  I would prefer the second and third
idea rather than first one.  Anyway, I will send a patch soon.  Will add a
kselftest for this case, too.


Thanks,
SeongJae Park

[...]
