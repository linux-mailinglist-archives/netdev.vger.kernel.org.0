Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5914026940
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfEVRkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:40:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfEVRkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:40:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39F1515002414;
        Wed, 22 May 2019 10:40:20 -0700 (PDT)
Date:   Wed, 22 May 2019 10:40:19 -0700 (PDT)
Message-Id: <20190522.104019.40493905027242516.davem@davemloft.net>
To:     rick.p.edgecombe@intel.com
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        linux-mm@kvack.org, mroos@linux.ee, mingo@redhat.com,
        namit@vmware.com, luto@kernel.org, bp@alien8.de,
        netdev@vger.kernel.org, dave.hansen@intel.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2] vmalloc: Fix issues with flush flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <339ef85d984f329aa66f29fa80781624e6e4aecc.camel@intel.com>
References: <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
        <20190520.184336.743103388474716249.davem@davemloft.net>
        <339ef85d984f329aa66f29fa80781624e6e4aecc.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 10:40:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Date: Tue, 21 May 2019 01:59:54 +0000

> On Mon, 2019-05-20 at 18:43 -0700, David Miller wrote:
>> From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
>> Date: Tue, 21 May 2019 01:20:33 +0000
>> 
>> > Should it handle executing an unmapped page gracefully? Because
>> > this
>> > change is causing that to happen much earlier. If something was
>> > relying
>> > on a cached translation to execute something it could find the
>> > mapping
>> > disappear.
>> 
>> Does this work by not mapping any kernel mappings at the beginning,
>> and then filling in the BPF mappings in response to faults?
> No, nothing too fancy. It just flushes the vm mapping immediatly in
> vfree for execute (and RO) mappings. The only thing that happens around
> allocation time is setting of a new flag to tell vmalloc to do the
> flush.
> 
> The problem before was that the pages would be freed before the execute
> mapping was flushed. So then when the pages got recycled, random,
> sometimes coming from userspace, data would be mapped as executable in
> the kernel by the un-flushed tlb entries.

If I am to understand things correctly, there was a case where 'end'
could be smaller than 'start' when doing a range flush.  That would
definitely kill some of the sparc64 TLB flush routines.
