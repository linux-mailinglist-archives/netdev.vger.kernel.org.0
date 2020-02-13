Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A51415CD99
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBMVyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:54:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgBMVyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JyU0rTzWIOZXHdzuOIC0sk/P2lDRoKyKc+orwy6Pvkg=; b=JUCjWosCsF/uyIQ2RLsHAFG25b
        s2FTef0lyOTfEC+hsrv/zJSdk4Vny0OXoK0L6x567feg0/GfTiWRBy1xn/W8e+qze28TacDYEakwL
        GcKFqwiUwSsgKayol82ei+4d5vCmbI/oO3onkccNg2y45hQ7oBJrcppIlrmgmADtOrPRWsYiJHIZO
        jkKsf4gsCb8aJXWJvyM8xkP1PUFUDNPmn+3S1fJCJ9vRHKaPkzWYENbtY7uI3Un1Qw0ScYq33l7T2
        NmQ8dr9fvKFZzg90rDcGFKYlXNIZ5hOCjH2TCeFxumE+DfsF34cJIYM/VF4fLy3TmdDNg/6mLGY+T
        jvt+7oPg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j2MQx-0006jb-Dh; Thu, 13 Feb 2020 21:54:07 +0000
Date:   Thu, 13 Feb 2020 13:54:07 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org, arjunroy@google.com,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH resend mm,net-next 2/3] mm: Add vm_insert_pages().
Message-ID: <20200213215407.GT7778@bombadil.infradead.org>
References: <20200128025958.43490-1-arjunroy.kdev@gmail.com>
 <20200128025958.43490-2-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128025958.43490-2-arjunroy.kdev@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 06:59:57PM -0800, Arjun Roy wrote:
>  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
> +int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> +			struct page **pages, unsigned long *num);
>  int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);

Sorry I didn't notice these patches earlier.  I'm not thrilled about
the addition of a new vm_insert_* operation; we're moving towards a
vmf_insert_* API.  There are almost no users left of vm_insert_page
(10, at a quick count).  Once they're all gone, we can switch the
underlying primitives over to a vm_fault_t return type and get rid of the
errno-to-vm-fault translation step that currently goes on.

So ... is this called in the fault path?  Do you have a struct vm_fault
around?  Can you handle a vm_fault_t return value instead of an errno?
