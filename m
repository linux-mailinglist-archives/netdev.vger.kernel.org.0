Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22308346271
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhCWPKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232718AbhCWPJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 11:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0858619BA;
        Tue, 23 Mar 2021 15:09:52 +0000 (UTC)
Subject: [PATCH 0/2] SUNRPC consumer for the bulk page allocator
From:   Chuck Lever <chuck.lever@oracle.com>
To:     mgorman@techsingularity.net
Cc:     brouer@redhat.com, vbabka@suse.cz, akpm@linux-foundation.org,
        hch@infradead.org, alexander.duyck@gmail.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org
Date:   Tue, 23 Mar 2021 11:09:51 -0400
Message-ID: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
User-Agent: StGit/1.0-5-g755c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set and the measurements below are based on yesterday's
bulk allocator series:

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9

The patches change SUNRPC to invoke the array-based bulk allocator
instead of alloc_page().

The micro-benchmark results are promising. I ran a mixture of 256KB
reads and writes over NFSv3. The server's kernel is built with KASAN
enabled, so the comparison is exaggerated but I believe it is still
valid.

I instrumented svc_recv() to measure the latency of each call to
svc_alloc_arg() and report it via a trace point. The following
results are averages across the trace events.

Single page: 25.007 us per call over 532,571 calls
Bulk list:    6.258 us per call over 517,034 calls
Bulk array:   4.590 us per call over 517,442 calls

For SUNRPC, the simplicity and better performance of the array-based
API makes it superior to the list-based API.

---

Chuck Lever (2):
      SUNRPC: Set rq_page_end differently
      SUNRPC: Refresh rq_pages using a bulk page allocator


 net/sunrpc/svc_xprt.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--
Chuck Lever

