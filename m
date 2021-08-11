Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E143E87AF
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 03:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhHKBgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 21:36:41 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:32214 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhHKBgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 21:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628645777; x=1660181777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xg6mpxNaOwD/FoAfn+hfjDtxLHdl0P+5jTSDVy2/cKk=;
  b=RemzwN/bTYLK2IvHRIDPpjy4FUd0Ncr1KMmQE9CWH3uHiDQfNuPO0Jpr
   iTAIYLvwjqNuLrs3215zb5P07vniBqicWjO4Th48/U5loRo5KlD+60FHw
   nBYfx99IMJfqaE29qdV/xDUnYX5mWPB/W32Vyb/pRMtYrbCKqeZrW3nva
   Y=;
X-IronPort-AV: E=Sophos;i="5.84,311,1620691200"; 
   d="scan'208";a="949678527"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 11 Aug 2021 01:36:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id 83329A1AD3;
        Wed, 11 Aug 2021 01:36:13 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 11 Aug 2021 01:36:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.226) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Wed, 11 Aug 2021 01:36:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <yhs@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
Subject: Re: [PATCH v4 bpf-next 3/3] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Wed, 11 Aug 2021 10:35:57 +0900
Message-ID: <20210811013557.63288-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <6ef818ee-ee75-b2f0-5532-7cc3fa4eb68e@fb.com>
References: <6ef818ee-ee75-b2f0-5532-7cc3fa4eb68e@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.226]
X-ClientProxiedBy: EX13D23UWC003.ant.amazon.com (10.43.162.81) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yonghong Song <yhs@fb.com>
Date:   Tue, 10 Aug 2021 16:46:49 -0700
> On 8/10/21 2:28 AM, Kuniyuki Iwashima wrote:
> > The iterator can output the same result compared to /proc/net/unix.
> > 
> >    # cat /sys/fs/bpf/unix
> >    Num       RefCount Protocol Flags    Type St Inode Path
> >    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> 
> There seems a misalignment between header line and data line.
> I know /proc/net/unix having this issue as well. But can we adjust 
> spacing in bpf program to make header/data properly aligned?

I just followed /proc/net/unix not to break old parsers :)
I'll align it cleanly in the next spin.


> 
> >    ffff9fca0023d000: 00000002 00000000 00000000 0001 01 11058 @Hello@World@
> > 
> >    # cat /proc/net/unix
> >    Num       RefCount Protocol Flags    Type St Inode Path
> >    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> >    ffff9fca0023d000: 00000002 00000000 00000000 0001 01 11058 @Hello@World@
> > 
> > Note that this prog requires the patch ([0]) for LLVM code gen.  Thanks to
> > Yonghong Song for analysing and fixing.
> > 
> > [0] https://reviews.llvm.org/D107483
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> 
> LGTM. Thanks!
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Thank you, too!!
