Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEBD14EF20
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgAaPGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:06:08 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:5997 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbgAaPGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580483168; x=1612019168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=ibAJSA6wdOg0PnzV2uto1TBRG7DetiN8T++aLxGU9cM=;
  b=nlqgcNlb5Ri46aWcvd1OGI4bxJSL6PfmnOM2IZci9fnFgCJcPRH043PU
   DACNs3J6jBKuXSSOD2LY4cgMXmJaZ7ubveq4fLk6yuNYdI8Usa4+1ZFUg
   4U5HAM7lKh/PYzvub5SkKoLzDtE29sakr7wNdR8hK22fX7EzKNDX6/GIX
   w=;
IronPort-SDR: 5DEVMlG4yhcSitO+uhmJ3dq/t8jDoHkMcFNBoOp4aidvraLR/o9Qp1wt/QuiT57DapOb7aYI0K
 TVq76vvfQNxg==
X-IronPort-AV: E=Sophos;i="5.70,386,1574121600"; 
   d="scan'208";a="15641307"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 Jan 2020 15:06:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 7AF83A07D8;
        Fri, 31 Jan 2020 15:06:04 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 15:06:03 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.249) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 15:05:58 +0000
From:   <sjpark@amazon.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     "'sjpark@amazon.com'" <sjpark@amazon.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sj38.park@gmail.com" <sj38.park@gmail.com>,
        "aams@amazon.com" <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: RE: [PATCH 0/3] Fix reconnection latency caused by FIN/ACK handling race
Date:   Fri, 31 Jan 2020 16:05:44 +0100
Message-ID: <20200131150544.26333-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <dc37fb0dad3c4a5f9fd88eea89d81908@AcuMS.aculab.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.249]
X-ClientProxiedBy: EX13D01UWA002.ant.amazon.com (10.43.160.74) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 14:00:27 +0000 David Laight <David.Laight@ACULAB.COM> wrote:

> From: sjpark@amazon.com
> > Sent: 31 January 2020 12:24
> ...
> > The acks in lines 6 and 8 are the acks.  If the line 8 packet is
> > processed before the line 6 packet, it will be just ignored as it is not
> > a expected packet, and the later process of the line 6 packet will
> > change the status of Process A to FIN_WAIT_2, but as it has already
> > handled line 8 packet, it will not go to TIME_WAIT and thus will not
> > send the line 10 packet to Process B.  Thus, Process B will left in
> > CLOSE_WAIT status, as below.
> > 
> > 	 00 (Process A)				(Process B)
> > 	 01 ESTABLISHED				ESTABLISHED
> > 	 02 close()
> > 	 03 FIN_WAIT_1
> > 	 04 		---FIN-->
> > 	 05 					CLOSE_WAIT
> > 	 06 				(<--ACK---)
> > 	 07	  			(<--FIN/ACK---)
> > 	 08 				(fired in right order)
> > 	 09 		<--FIN/ACK---
> > 	 10 		<--ACK---
> > 	 11 		(processed in reverse order)
> > 	 12 FIN_WAIT_2
> 
> Why doesn't A treat the FIN/ACK (09) as valid (as if
> the ACK had got lost) and then ignore the ACK (10) because
> it refers to a closed socket?

Because the TCP protocol (RFC 793) doesn't have such speculation.  TCP is
stateful protocol.  Thus, packets arrived in unexpected state are not required
to be respected, AFAIU.

> 
> I presume that B sends two ACKs (06 and 07) because it can
> sit in an intermediate state and the first ACK stops the FIN
> being resent?

I think there is no such presume in the protocol, either.

> 
> I've implemented lots of protocols in my time, but not TCP.

If you find anything I'm misunderstanding, please don't hesitate to yell at me.
Hope the previous discussion[1] regarding this issue to be helpful.


Thanks,
SeongJae Park

[1] https://lore.kernel.org/bpf/20200129171403.3926-1-sjpark@amazon.com/

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
