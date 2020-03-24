Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1BB190BF0
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 12:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgCXLG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 07:06:27 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:38323 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgCXLG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 07:06:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1585047986; x=1616583986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=E+zQfHBz59AbvxgoRYp4xPVzY+cNqfT+h/Ffjs0QNC8=;
  b=enDCG/hL7mry7adV2P24nq1yE982bNQUpseMNVdh5l34U4sO00vXNnkH
   qi+2d+k4VanK8Z2/137xCqXPOGPFmcE15FYQRo3krTr+o0w0dh+BQ7oZU
   zPK8otV9qxbjbHKBV9NovhzFuggxYoVXJ1QXFraUGTGqaAIz3qwIPuwOS
   g=;
IronPort-SDR: eoOIaraAjEabSOGlCU6rrg5qWsoWSDrzHVsi7Cw0FpepWtru4kQ4dzcqaz9NJISHqMyKZzz9BC
 pClZO3qC1WZQ==
X-IronPort-AV: E=Sophos;i="5.72,300,1580774400"; 
   d="scan'208";a="33105604"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Mar 2020 11:06:24 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 1F4F1A27E8;
        Tue, 24 Mar 2020 11:06:20 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 24 Mar 2020 11:06:20 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.51) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 24 Mar 2020 11:06:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <dccp@vger.kernel.org>,
        <gerrit@erg.abdn.ac.uk>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 2/2] tcp/dccp: Remove unnecessary initialization
Date:   Tue, 24 Mar 2020 20:06:05 +0900
Message-ID: <20200324110605.10050-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iLfqRCgsng=ZVxjU_WxL6kiymmicQ7Jn=K8pU0D9HNwEg@mail.gmail.com>
References: <CANn89iLfqRCgsng=ZVxjU_WxL6kiymmicQ7Jn=K8pU0D9HNwEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.51]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Mar 2020 11:47:17 -0700
> On Mon, Mar 23, 2020 at 11:22 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > When we get a TCP_NEW_SYN_RECV/DCCP_NEW_SYN_RECV socket by
> > __inet_lookup_skb(), refcounted is already set true, so it is not
> > necessary to do it again.
> 
> This changelog is absolutely not accurate.
> 
> sk is a listener here.
> (because sk was set to req->rsk_listener;)
> 
> Please do not add confusion by mixing different things.
> 
> I prefer not relying on the old value of 'refcounted', since we
> switched sk value.
> 
> Note that we call reqsk_put(req); regardless of 'refcounted'

Certainly, the refcounted has diffrent meaning in the context, sorry. 


> I would rather not change this code and make future backports more complicated.
> 
> Thanks.

I did not think about backports, thank you!
