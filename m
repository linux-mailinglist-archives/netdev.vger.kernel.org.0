Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35C891BB2D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbfEMQmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:42:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbfEMQmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:42:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 19DB514E25407;
        Mon, 13 May 2019 09:42:19 -0700 (PDT)
Date:   Mon, 13 May 2019 09:42:18 -0700 (PDT)
Message-Id: <20190513.094218.1962516460150696760.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        James.Bottomley@HansenPartnership.com, aarcange@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
        dvhart@infradead.org
Subject: Re: [PATCH net] vhost: don't use kmap() to log dirty pages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557725265-63525-1-git-send-email-jasowang@redhat.com>
References: <1557725265-63525-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:42:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 13 May 2019 01:27:45 -0400

> Vhost log dirty pages directly to a userspace bitmap through GUP and
> kmap_atomic() since kernel doesn't have a set_bit_to_user()
> helper. This will cause issues for the arch that has virtually tagged
> caches. The way to fix is to keep using userspace virtual
> address. Fortunately, futex has arch_futex_atomic_op_inuser() which
> could be used for setting a bit to user.
> 
> Note there're several cases that futex helper can fail e.g a page
> fault or the arch that doesn't have the support. For those cases, a
> simplified get_user()/put_user() pair protected by a global mutex is
> provided as a fallback. The fallback may lead false positive that
> userspace may see more dirty pages.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Darren Hart <dvhart@infradead.org>
> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I want to see a review from Michael for this change before applying.
