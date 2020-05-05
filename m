Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764091C5C60
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgEEPr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:47:27 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:63427 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729406AbgEEPr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588693647; x=1620229647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=qgL+UrIHPggA/cbMIcuZ6L6wlHkLvvYMOzgo5iwxhgg=;
  b=G+Q7z7KLHWVXnfTXL6vCm+I433aihc4qv6kJ4WtoMTKroRNfPk1h2ODX
   OF6z/eK/BT306TyXHZLwicMXlh1LxUV8H66LNNDTsbf9ehFMfjnYhlQjE
   jI8MAGvELZ+s45fCv7TLThd3hP0hjX2NmaUVQsLs2nttVoml0/fnqvhKa
   U=;
IronPort-SDR: O166hFl/kUUCS2stThOFXVSw6unJMOC3/77W9R3kUjp/BSPJ10ib3NA17O1H6Lb1AtOuv/GJ+Y
 1lR6gvyLhizA==
X-IronPort-AV: E=Sophos;i="5.73,355,1583193600"; 
   d="scan'208";a="33074496"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 05 May 2020 15:47:24 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id DA09DA225F;
        Tue,  5 May 2020 15:47:20 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 15:47:20 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.38) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 15:47:12 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Tue, 5 May 2020 17:46:44 +0200
Message-ID: <20200505154644.18997-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <a8510327-d4f0-1207-1342-d688e9d5b8c3@gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D18UWC003.ant.amazon.com (10.43.162.237) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> 
> 
> On 5/5/20 8:07 AM, SeongJae Park wrote:
> > On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > 
> 
> >> Why do we have 10,000,000 objects around ? Could this be because of
> >> some RCU problem ?
> > 
> > Mainly because of a long RCU grace period, as you guess.  I have no idea how
> > the grace period became so long in this case.
> > 
> > As my test machine was a virtual machine instance, I guess RCU readers
> > preemption[1] like problem might affected this.
> > 
> > [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
> > 
> >>
> >> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
> > 
> > Yes, both the old kernel that prior to Al's patches and the recent kernel
> > reverting the Al's patches didn't reproduce the problem.
> >
> 
> I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
> 
> TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
> object that was allocated in sock_alloc_inode() before Al patches.
> 
> These objects should be visible in kmalloc-64 kmem cache.

Not exactly the 10,000,000, as it is only the possible highest number, but I
was able to observe clear exponential increase of the number of the objects
using slabtop.  Before the start of the problematic workload, the number of
objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
to 1,136,576.

	  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
before:	  5760   5088  88%    0.06K     90       64       360K kmalloc-64
after:	1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64


Thanks,
SeongJae Park

