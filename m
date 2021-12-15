Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1FB475701
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbhLOK5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:57:25 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50840 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbhLOK5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:57:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A86A2212BD;
        Wed, 15 Dec 2021 10:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639565843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71KLsGFyTfHQmtWPtJva/8POSdqz59E3zDHvaoF0bPs=;
        b=s8379Nmjjoz5PcoEikeXUuWJGPh2bkhTRK5B3RBLYyazCCjPqTd49BJKTooAF3UDIZIQAF
        2TIQP+P0+YL9og5NXAKSglGy53fGfEpiSb7mrLkwY4g2TkLrVAWd8NIHLfrLCmX/eLtIRP
        gy+wUXGeCXri1shkoWX8v7bcc0m8fp0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639565843;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=71KLsGFyTfHQmtWPtJva/8POSdqz59E3zDHvaoF0bPs=;
        b=5RgxaosdupGJrj/duuEL79qM0V97LnqnfjHwVa5MKkfs3pakxxk9IOFrMDn/xPyJfz8PB7
        cJOH6XeV0szWqIBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 857F813B1C;
        Wed, 15 Dec 2021 10:57:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R2HWHxPKuWEDAgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 15 Dec 2021 10:57:23 +0000
Message-ID: <45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz>
Date:   Wed, 15 Dec 2021 11:57:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jiri Slaby <jirislaby@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com>
 <a6b342b3-8ce1-70c8-8398-fceaee0b51ff@gmail.com>
 <CANn89iLCaPLhrGi5FyDppfzqdtsow2i6c5+E7pjtd47hwgvpGA@mail.gmail.com>
 <CANn89iLzZaVObgj-OSG7bT2V8q2AdqUekc2aoiwG7QeRyemNLw@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CANn89iLzZaVObgj-OSG7bT2V8q2AdqUekc2aoiwG7QeRyemNLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/15/21 11:41, Eric Dumazet wrote:
> On Wed, Dec 15, 2021 at 2:38 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Wed, Dec 15, 2021 at 2:18 AM Jiri Slaby <jirislaby@gmail.com> wrote:
>> >
>> > On 05. 12. 21, 5:21, Eric Dumazet wrote:
>> > > From: Eric Dumazet <edumazet@google.com>
>> > >
>> > > It can be hard to track where references are taken and released.
>> > >
>> > > In networking, we have annoying issues at device or netns dismantles,
>> > > and we had various proposals to ease root causing them.
>> > ...
>> > > --- a/lib/Kconfig
>> > > +++ b/lib/Kconfig
>> > > @@ -680,6 +680,11 @@ config STACK_HASH_ORDER
>> > >        Select the hash size as a power of 2 for the stackdepot hash table.
>> > >        Choose a lower value to reduce the memory impact.
>> > >
>> > > +config REF_TRACKER
>> > > +     bool
>> > > +     depends on STACKTRACE_SUPPORT
>> > > +     select STACKDEPOT
>> >
>> > Hi,
>> >
>> > I have to:
>> > +       select STACKDEPOT_ALWAYS_INIT
>> > here. Otherwise I see this during boot:
>> >
>>
>> Thanks, I am adding Vlastimil Babka to the CC
>>
>> This stuff has been added in
>> commit e88cc9f5e2e7a5d28a1adf12615840fab4cbebfd
>> Author: Vlastimil Babka <vbabka@suse.cz>
>> Date:   Tue Dec 14 21:50:42 2021 +0000
>>
>>     lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()
>>
>>
> 
> (This is a problem because this patch is not yet in net-next, so I really do
> not know how this issue should be handled)

Looks like multiple new users of stackdepot start appearing as soon as I
touch it :)

The way we solved this with a new DRM user was Andrew adding a fixup to my
patch referenced above, in his "after-next" section of mm tree.
Should work here as well.

----8<----
From 0fa1f25925c05f8c5c4f776913d84904fb4c03a1 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 15 Dec 2021 11:52:10 +0100
Subject: [PATCH] lib/stackdepot: allow optional init and stack_table
 allocation by kvmalloc() - fixup4

Due to 4e66934eaadc ("lib: add reference counting tracking infrastructure")
landing recently to net-next adding a new stack depot user in lib/ref_tracker.c
we need to add an appropriate call to stack_depot_init() there as well.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/ref_tracker.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index c11c9db5825c..60f3453be23e 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -4,6 +4,7 @@
 #include <linux/refcount.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/stackdepot.h>
 
 struct ref_tracker;
 
@@ -26,6 +27,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	spin_lock_init(&dir->lock);
 	dir->quarantine_avail = quarantine_count;
 	refcount_set(&dir->untracked, 1);
+	stack_depot_init();
 }
 
 void ref_tracker_dir_exit(struct ref_tracker_dir *dir);
-- 
2.34.1

