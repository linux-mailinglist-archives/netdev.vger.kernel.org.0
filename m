Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2F61D3D4D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgENTSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgENTSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 15:18:52 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CC13206F1;
        Thu, 14 May 2020 19:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589483931;
        bh=oVPC6nEvLFlTp15302HS05FQs6BjfouRTDsTW35v6tc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1gSf6AzBCuDsIoWrUi5ahr5F/7KfMrcjw8bxllxhe/7Ov/WITB4ZMNuBbdRXS79U/
         BFVlClNq+xaaU9xRkiVoQhoMY9LS3tdDhcCOEtS1okKncX6d1IAhzdLAT7CpqyBfHA
         ZLjET0AL0AA6JeE32jzTiKLZ4kxTAK9AA1wqOvIo=
Date:   Thu, 14 May 2020 12:18:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andriin@fb.com>, linux-arch@vger.kernel.org
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and
 verifier support for it
Message-ID: <20200514121848.052966b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200513192532.4058934-2-andriin@fb.com>
References: <20200513192532.4058934-1-andriin@fb.com>
        <20200513192532.4058934-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 12:25:27 -0700 Andrii Nakryiko wrote:
> One interesting implementation bit, that significantly simplifies (and thus
> speeds up as well) implementation of both producers and consumers is how data
> area is mapped twice contiguously back-to-back in the virtual memory. This
> allows to not take any special measures for samples that have to wrap around
> at the end of the circular buffer data area, because the next page after the
> last data page would be first data page again, and thus the sample will still
> appear completely contiguous in virtual memory. See comment and a simple ASCII
> diagram showing this visually in bpf_ringbuf_area_alloc().

Out of curiosity - is this 100% okay to do in the kernel and user space
these days? Is this bit part of the uAPI in case we need to back out of
it? 

In the olden days virtually mapped/tagged caches could get confused
seeing the same physical memory have two active virtual mappings, or 
at least that's what I've been told in school :)

Checking with Paul - he says that could have been the case for Itanium
and PA-RISC CPUs.
