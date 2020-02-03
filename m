Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587A3150EBC
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgBCRiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:38:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48902 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgBCRiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 12:38:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+svzYeMjDifvnay5XBCjENPcDei37krIAEbCjdfWWhU=; b=Uh9wVVKd7GmAMVO4QoLCs33RIH
        tlUkrd456X1MQBI2ZcjKd8tWTxYKw/bt1d55Ecyox2OJeX/KE3bKnXvCj0vdsvzOSRJOd/UDIAj2w
        l69ejkcK5CyzMwzk0S4RHBdXLS04dd6+vaW8jfpHz5B4mBd/ZuzHl/qmllj4Q34oHizwWkUodym02
        ZUMRhjFtl2ELh+OM+6mA5n82D1di9RosZqr2hOYtHgD5aGIXdOFNC+Vi54iDCsFS1U75qnFbhSdWd
        6KQP4QlIfHfPrkzxQ8aWaj0dUQkgDa2J9kucmHTDPGk2LSzjnDt+zoORFqfTTcsUgOBgWXXrrmdLU
        rT5JVVNg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iyffn-00015V-Ss; Mon, 03 Feb 2020 17:38:11 +0000
Date:   Mon, 3 Feb 2020 09:38:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christopher Lameter <cl@linux.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, David Windsor <dave@nullcore.net>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Laura Abbott <labbott@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rik van Riel <riel@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [kernel-hardening] [PATCH 09/38] usercopy: Mark kmalloc caches
 as usercopy caches
Message-ID: <20200203173811.GB30011@infradead.org>
References: <201911141327.4DE6510@keescook>
 <bfca96db-bbd0-d958-7732-76e36c667c68@suse.cz>
 <202001271519.AA6ADEACF0@keescook>
 <5861936c-1fe1-4c44-d012-26efa0c8b6e7@de.ibm.com>
 <202001281457.FA11CC313A@keescook>
 <alpine.DEB.2.21.2001291640350.1546@www.lameter.com>
 <6844ea47-8e0e-4fb7-d86f-68046995a749@de.ibm.com>
 <20200129170939.GA4277@infradead.org>
 <771c5511-c5ab-3dd1-d938-5dbc40396daa@de.ibm.com>
 <202001300945.7D465B5F5@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202001300945.7D465B5F5@keescook>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 11:23:38AM -0800, Kees Cook wrote:
> Hm, looks like it's allocated from the low 16MB. Seems like poor naming!
> :) There seems to be a LOT of stuff using GFP_DMA, and it seems unlikely
> those are all expecting low addresses?

Most of that is either completely or partially bogus.  Besides the
weird S/390 stuff pretty much everything should be using the dma
allocators.  A couple really messed up drivers even pass GFP_DMA*
to the dma allocator, but my patches to fix that up seem to be stuck.
