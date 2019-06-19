Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F224AF8C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 03:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfFSBkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 21:40:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfFSBkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 21:40:02 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06CDB14CC87B4;
        Tue, 18 Jun 2019 18:39:56 -0700 (PDT)
Date:   Tue, 18 Jun 2019 21:39:50 -0400 (EDT)
Message-Id: <20190618.213950.1762225363890866525.davem@davemloft.net>
To:     fklassen@appneta.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        willemb@google.com
Subject: Re: [PATCH net v4] net/udp_gso: Allow TX timestamp with UDP GSO
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617190507.12730-1-fklassen@appneta.com>
References: <20190617190507.12730-1-fklassen@appneta.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 18:40:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fred Klassen <fklassen@appneta.com>
Date: Mon, 17 Jun 2019 12:05:07 -0700

> Fixes an issue where TX Timestamps are not arriving on the error queue
> when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
> This can be illustrated with an updated updgso_bench_tx program which
> includes the '-T' option to test for this condition. It also introduces
> the '-P' option which will call poll() before reading the error queue.
 ...
> The "poll timeout" message above indicates that TX timestamp never
> arrived.
> 
> This patch preserves tx_flags for the first UDP GSO segment. Only the
> first segment is timestamped, even though in some cases there may be
> benefital in timestamping both the first and last segment.
> 
> Factors in deciding on first segment timestamp only:
> 
> - Timestamping both first and last segmented is not feasible. Hardware
> can only have one outstanding TS request at a time.
> 
> - Timestamping last segment may under report network latency of the
> previous segments. Even though the doorbell is suppressed, the ring
> producer counter has been incremented.
> 
> - Timestamping the first segment has the upside in that it reports
> timestamps from the application's view, e.g. RTT.
> 
> - Timestamping the first segment has the downside that it may
> underreport tx host network latency. It appears that we have to pick
> one or the other. And possibly follow-up with a config flag to choose
> behavior.
 ...
> Fixes: ee80d1ebe5ba ("udp: add udp gso")
> Signed-off-by: Fred Klassen <fklassen@appneta.com>

Applied and queued up for -stable, thanks.
