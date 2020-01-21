Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBD51441BC
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgAUQKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:10:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37196 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726555AbgAUQKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579623000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UEuuKeMhgB5vy+6HvBEXjxE3sicUJEJgiG6w15sfOoA=;
        b=I02pHP3rvAXhwrfLsgjW9+c44Yp4IY9H0+lhIiC/rQz04rnn2L35WUweVyQTONFjJCJxNj
        NrcL60LINSHaHppNd6AWr+SGyfQcZ5tG6VaO1eyOX1tXfXnMBK5fA2KiiW2mHNoYT48P6Q
        8jV9WPvha0KPEtLoLtixLTONZ3RVXsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-mdUac1_rNe-HnQX9A1cRhQ-1; Tue, 21 Jan 2020 11:09:58 -0500
X-MC-Unique: mdUac1_rNe-HnQX9A1cRhQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10DD518B5FBE;
        Tue, 21 Jan 2020 16:09:57 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC75B5D9E2;
        Tue, 21 Jan 2020 16:09:47 +0000 (UTC)
Date:   Tue, 21 Jan 2020 17:09:45 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     brouer@redhat.com, Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Created benchmarks modules for page_pool
Message-ID: <20200121170945.41e58f32@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ilias and Lorenzo, (Cc others + netdev)

I've created two benchmarks modules for page_pool.

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
[2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c

I think we/you could actually use this as part of your presentation[3]?

The first benchmark[1] illustrate/measure what happen when page_pool
alloc and free/return happens on the same CPU.  Here there are 3 modes
of operations with different performance characteristic.

Fast_path NAPI recycle (XDP_DROP use-case)
 - cost per elem: 15 cycles(tsc) 4.437 ns

Recycle via ptr_ring
 - cost per elem: 48 cycles(tsc) 13.439 ns

Failed recycle, return to page-allocator
 - cost per elem: 256 cycles(tsc) 71.169 ns


The second benchmark[2] measures what happens cross-CPU.  It is
primarily the concurrent return-path that I want to capture. As this
is page_pool's weak spot, that we/I need to improve performance of.
Hint when SKBs use page_pool return this will happen more often.
It is a little more tricky to get proper measurement as we want to
observe the case, where return-path isn't stalling/waiting on pages to
return.

- 1 CPU returning  , cost per elem: 110 cycles(tsc)   30.709 ns
- 2 concurrent CPUs, cost per elem: 989 cycles(tsc)  274.861 ns
- 3 concurrent CPUs, cost per elem: 2089 cycles(tsc) 580.530 ns
- 4 concurrent CPUs, cost per elem: 2339 cycles(tsc) 649.984 ns

[3] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

