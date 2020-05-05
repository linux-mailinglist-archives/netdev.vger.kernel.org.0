Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1391C4FD7
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgEEIE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:04:59 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:65368 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgEEIE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588665898; x=1620201898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=tbHmaPqCZ2rJJARJTMpr1HfWh6PkblrvobCFVMdGHiA=;
  b=vVwV1Qr/kd71NHeC74cXkC82Wh8TR+AzKmISRFlVZ5b9rRsCzyUjgLQb
   44AKBLadggO+7geIDv40IPTxqt2Sd5HhmjpHF/I3+rKYvPejDONRJKwdF
   zQEJ9RN3DgH+b4VMVisRI1DwbLhBVhwRK7pgeM9PxBLSNu9uGnp1ucTKw
   E=;
IronPort-SDR: /CWxTVl4jK6AL1c7zLUXB6EOIyiW4v7Rh/LUnxTiV47KjtaF+zj4VwZmnthSJWAYhgLUgR6gcz
 cXSpTKp3r0Dw==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="30083670"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 05 May 2020 08:04:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id E544EA07B3;
        Tue,  5 May 2020 08:04:55 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:04:54 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:04:49 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     SeongJae Park <sjpark@amazon.com>, <davem@davemloft.net>,
        <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH net 1/2] Revert "coallocate socket_wq with socket itself"
Date:   Tue, 5 May 2020 10:04:34 +0200
Message-ID: <20200505080434.5651-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505074511.GA4054974@kroah.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D06UWA002.ant.amazon.com (10.43.160.143) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 09:45:11 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Tue, May 05, 2020 at 09:28:40AM +0200, SeongJae Park wrote:
> > From: SeongJae Park <sjpark@amazon.de>
> > 
> > This reverts commit 333f7909a8573145811c4ab7d8c9092301707721.
> > 
> > The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> > deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> > same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
> > socket_sq with socket itself") made those to have same life cycle.
> > 
> > The changes made the code much more simple, but also made 'socket_alloc'
> > live longer than before.  For the reason, user programs intensively
> > repeating allocations and deallocations of sockets could cause memory
> > pressure on recent kernels.
> > 
> > To avoid the problem, this commit separates the life cycle of
> > 'socket_alloc' and 'sock.wq' again.  The following commit will make the
> > deallocation of 'socket_alloc' to be done synchronously again.
> > ---
> 
> No signed-off-by?
> No "Fixes:"?

Oops, my mistake.  I will post next version right now.


Thanks,
SeongJae Park

> 
> :(
