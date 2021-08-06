Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6871F3E206B
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 03:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243121AbhHFBFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 21:05:34 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:63784 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhHFBFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 21:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628211920; x=1659747920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxD2UTVFtAc/EPdQmxH6UekSPlv9TUiMW7MBnfT/zL4=;
  b=gvR8xKZNRgwemFVAqpt/D9QXDcor54m7ZdCvTWsCTux4PVu3khDrC57B
   oLSNZHrEANJQEylzi917G87CVmtRgW+RjP0iKmN5nAmB7C6vc66WUy6gr
   EimlHL7uobgsxlfISHPdwgHf2pSSzgNkwwT+FTNxeamXjHuG6JREmPa/3
   0=;
X-IronPort-AV: E=Sophos;i="5.84,299,1620691200"; 
   d="scan'208";a="17404497"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 06 Aug 2021 01:05:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id D3C01A1DFB;
        Fri,  6 Aug 2021 01:05:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 6 Aug 2021 01:05:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 6 Aug 2021 01:05:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: af_unix: Implement BPF iterator for UNIX domain socket.
Date:   Fri, 6 Aug 2021 10:05:08 +0900
Message-ID: <20210806010508.16709-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210806004114.pf77j5a6eb4223wn@kafai-mbp>
References: <20210806004114.pf77j5a6eb4223wn@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D03UWC003.ant.amazon.com (10.43.162.79) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 5 Aug 2021 17:41:14 -0700
> On Wed, Aug 04, 2021 at 04:08:50PM +0900, Kuniyuki Iwashima wrote:
> > Currently, the batch optimization introduced for the TCP iterator in the
> > commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> > applied.  It will require replacing the big lock for the hash table with
> may be s/applied/used/.  I thought it meant the commit is not landed.

Ah sorry, I meant the same optimisation logic is not used for now.
I'll change the word.


> > small locks for each hash list not to block other processes.
> Right, I don't think it can be directly reused.  Not necessary
> related to the big lock though.  Actually, a big lock will still
> work for batching but just less ideal.

Yes, batching can be done with a big lock.


> Batching is needed for supporting bpf_setsockopt.  It can be added later
> together with the bpf_setsockopt support.

I'm trying to replace the big lock, so I'll submit another set for batching
and bpf_setsockopt support.

Thank you!
