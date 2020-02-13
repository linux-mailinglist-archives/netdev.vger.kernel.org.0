Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFE215B73E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 03:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgBMClE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 21:41:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729471AbgBMClD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 21:41:03 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A69A420675;
        Thu, 13 Feb 2020 02:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581561661;
        bh=dGs9A8uGyG7xB9ZmxsOWUecYy9yVfwQ/+1KnytNLTtI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dL8bc8ipcRlO7NVt/LStb7SpHRCWowdH6aaWLUBkJIoa5a0KrntZE+xTZE9wcWSsy
         LcPX+qTDFha77w1rG3XKalE1tR2uY6AX1EAldm9UibNGvTUQZuvfdWFtPYCGUkkQ4s
         1CKQlUE+b16xK+42I0+ad39OpCfSTX0OgnFzPAgo=
Date:   Wed, 12 Feb 2020 18:41:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        arjunroy@google.com, Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH resend mm,net-next 2/3] mm: Add vm_insert_pages().
Message-Id: <20200212184101.b8551710bd19c8216d62290d@linux-foundation.org>
In-Reply-To: <20200128025958.43490-2-arjunroy.kdev@gmail.com>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
        <20200128025958.43490-2-arjunroy.kdev@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 18:59:57 -0800 Arjun Roy <arjunroy.kdev@gmail.com> wrote:

> Add the ability to insert multiple pages at once to a user VM with
> lower PTE spinlock operations.
> 
> The intention of this patch-set is to reduce atomic ops for
> tcp zerocopy receives, which normally hits the same spinlock multiple
> times consecutively.

Seems sensible, thanks.  Some other vm_insert_page() callers might want
to know about this, but I can't immediately spot any which appear to be
high bandwidth.

Is there much point in keeping the vm_insert_page() implementation
around?  Replace it with

static inline int
vm_insert_page(struct vm_area_struct *vma, unsigned long addr,
	       struct page *page)
{
	return vm_insert_pages(vma, addr, &page, 1);
}

?

Also, vm_insert_page() does

	if (!page_count(page))
		return -EINVAL;

and this was not carried over into vm_insert_pages().  How come?

I don't know what that test does - it was added by Linus in the
original commit a145dd411eb28c83.  It's only been 15 years so I'm sure
he remembers ;)
