Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3B3E1FF9
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbhHFAY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:24:59 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:40129 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbhHFAYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 20:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628209481; x=1659745481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VkGPMZPJ14lj3/ggB0mM0d2JWA2ypc/y3DPrG1JPpPU=;
  b=vUEp0AEwhe+FLZSGJ452KazRCymTQxYz6l4Uonj9uj+ef7TVH+35PKmX
   NoSM1KPD++QnB3xdi7cPdP9NguKmvzbWQLRn0NR0whyNvHg9x6RzfDMi0
   NOXvqzPRL1hkVeoGnfO4pcCom9roV+7H3cncU5zSoRmZx2z/KMiTd57h0
   8=;
X-IronPort-AV: E=Sophos;i="5.84,299,1620691200"; 
   d="scan'208";a="140240825"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Aug 2021 00:24:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id AF091A1F28;
        Fri,  6 Aug 2021 00:24:37 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 6 Aug 2021 00:24:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 6 Aug 2021 00:24:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <yhs@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/2] selftest/bpf: Implement sample UNIX domain socket iterator program.
Date:   Fri, 6 Aug 2021 09:24:28 +0900
Message-ID: <20210806002428.12154-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <25688602-6151-d8f0-17ef-1661110ed26e@fb.com>
References: <25688602-6151-d8f0-17ef-1661110ed26e@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D47UWC001.ant.amazon.com (10.43.162.39) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yonghong Song <yhs@fb.com>
Date:   Thu, 5 Aug 2021 09:59:40 -0700
> On 8/4/21 12:08 AM, Kuniyuki Iwashima wrote:
> > If there are no abstract sockets, this prog can output the same result
> > compared to /proc/net/unix.
> > 
> >    # cat /sys/fs/bpf/unix | head -n 2
> >    Num       RefCount Protocol Flags    Type St Inode Path
> >    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> > 
> >    # cat /proc/net/unix | head -n 2
> >    Num       RefCount Protocol Flags    Type St Inode Path
> >    ffff9ab7122db000: 00000002 00000000 00010000 0001 01 10623 private/defer
> > 
> > According to the analysis by Yonghong Song (See the link), the BPF verifier
> > cannot load the code in the comment to print the name of the abstract UNIX
> > domain socket due to LLVM optimisation.  It can be uncommented once the
> > LLVM code gen is improved.
> 
> I have pushed the llvm fix to llvm14 trunk 
> (https://reviews.llvm.org/D107483), and filed a request to backport to 
> llvm13 (https://bugs.llvm.org/show_bug.cgi?id=51363), could you in the 
> next revision uncomment the "for" loop code and tested it with latest 
> llvm trunk compiler? Please also add an entry in selftests/bpf/README.rst
> to mention the llvm commit https://reviews.llvm.org/D107483 is needed
> for bpf_iter unix_socket selftest, otherwise, they will see an error
> like ...

Thank you for nice fixing so quickly!

I confirmed that the uncommented code can be loaded properly with the
latest LLVM master tree. :)

---8<---
$ sudo ./test_progs -t iter
...
#7/14 unix:OK
...
$ clang --version
clang version 14.0.0 (https://github.com/llvm/llvm-project.git 8a557d8311593627efd08d03178889971d5ae02b)
...
$ llvm-objdump -S bpf_iter_unix.o
...
; 				 for (i = 1 ; i < len; i++)
     110:	07 09 00 00 01 00 00 00	r9 += 1
     111:	ad 89 09 00 00 00 00 00	if r9 < r8 goto +9 <LBB0_18>
---8<---

In the next revision, I'll uncomment the code and add a note in README.rst
about your fix.
