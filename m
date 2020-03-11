Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F14818171C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 12:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgCKLvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 07:51:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36114 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgCKLvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 07:51:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id s5so2237359wrg.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 04:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=F9YqyxkpsJZqxm08epCGraQiOdpbKiUajj+F4VREnH0=;
        b=d145IYBz4FxbCwYvbej+jvQ3tfnL1WDas1nB+gt9/SVMpSOdgrcOl/hTRDDwrvyqIb
         jQOW1t9VWK1sDtuKDxT8WY4JPiKYEUnL8/ZW1KVLE0uSeTM7O7wpPhCQf62/VqsAOSji
         1EWleqohld93k0BmJlQbywowIoa/vSssvqVGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=F9YqyxkpsJZqxm08epCGraQiOdpbKiUajj+F4VREnH0=;
        b=OTJ5IhqILZ26UYH8xP7PGJ5Klyxy4adme072/x1QMdRRD2w26Dypart6r5XKbd1/C1
         HM9ufHwkf/QND7k/7Oya6qv2LIE6zL6p2z6ZaAUPNJn+I/rExiPaupBj/nED+crK09QV
         vLvxqJSAj3gaZ0fXyNFzm8oQt3ghWps7oxP2a1UqKqmnVxOZLPIF6W0T3GOwK2IDbuUV
         JExV/tk+opz+n5caZ2ashkaQfpMZ8s2wX+YpA10Iy2oNr6JaUTa7Lls7OpbhmBzZkb61
         5WCnGFCWforTHFbV9PBTCgomr2Cvm1BCJYK40j/Tftrmne+l5XkiPTwS9zUwTYGxJG9A
         46Rw==
X-Gm-Message-State: ANhLgQ0SS8G+exj7hkKNOJUSbmxseOTe7keHz/FkhzhwnqJSdwYTQFG0
        BBNJwdPZV1nK0GkEVndylhV2Bw==
X-Google-Smtp-Source: ADFU+vs5OpDO1A9pI5Vah3xDK5puctyg29o2llanncn4GpklrkFlvpOjILPdWbbYnwgqbo1eShv1Lg==
X-Received: by 2002:adf:ed06:: with SMTP id a6mr4135797wro.346.1583927494211;
        Wed, 11 Mar 2020 04:51:34 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id t193sm8429892wmt.14.2020.03.11.04.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:51:33 -0700 (PDT)
References: <20200206111652.694507-1-jakub@cloudflare.com> <5e3c6c7f8730e_22ad2af2cbd0a5b4a4@john-XPS-13-9370.notmuch> <87zhdun0ay.fsf@cloudflare.com> <5e67c3e83fb25_1e8a2b0e88e0a5bc84@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf 0/3] Fix locking order and synchronization on sockmap/sockhash tear-down
In-reply-to: <5e67c3e83fb25_1e8a2b0e88e0a5bc84@john-XPS-13-9370.notmuch>
Date:   Wed, 11 Mar 2020 12:51:32 +0100
Message-ID: <87zhcnxg6z.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 05:44 PM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Thu, Feb 06, 2020 at 08:43 PM CET, John Fastabend wrote:
>> > Jakub Sitnicki wrote:
>> >> Couple of fixes that came from recent discussion [0] on commit
>> >> 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down").
>> >>
>> >> This series doesn't address the sleeping while holding a spinlock
>> >> problem. We're still trying to decide how to fix that [1].
>> >>
>> >> Until then sockmap users might see the following warnings:
>> >>
>> >> | BUG: sleeping function called from invalid context at net/core/sock.c:2935
>>
>
> [...]
>
>> Hey John,
>
> Patch sent.

Thanks!

>
>>
>> > Untested at the moment, but this should also be fine per your suggestion
>> > (if I read it correctly).  The reason we have stab->lock and bucket->locks
>> > here is to handle checking EEXIST in update/delete cases. We need to
>> > be careful that when an update happens and we check for EEXIST that the
>> > socket is added/removed during this check. So both map_update_common and
>> > sock_map_delete need to guard from being run together potentially deleting
>> > an entry we are checking, etc.
>>
>> Okay, thanks for explanation. IOW, we're serializing map writers.
>>
>> > But by the time we get here we just did a synchronize_rcu() in the
>> > line above so no updates/deletes should be in flight. So it seems safe
>> > to drop these locks because of the condition no updates in flight.
>>
>> This part is not clear to me. I might be missing something.
>>
>> Here's my thinking - for any map writes (update/delete) to start,
>> map->refcnt needs to be > 0, and the ref is not dropped until the write
>> operation has finished.
>>
>> Map FDs hold a ref to map until the FD gets released. And BPF progs hold
>> refs to maps until the prog gets unloaded.
>>
>> This would mean that map_free will get scheduled from __bpf_map_put only
>> when no one is holding a map ref, and could start a write that would be
>> happening concurrently with sock_{map,hash}_free:
>
> Sorry bringing back this old thread I'm not sure I followed the couple
> paragraphs here. Is this with regards to the lock or the rcu? II didn't
> want to just drop this thanks.
>
> We can't have new updates/lookups/deletes happening while we are free'ing
> a map that would cause all sorts of problems, use after free's, etc.

Happy to pick up the discussion back up.

Sorry for the delay in my reply. I wanted to take another hard look at
the code and make sure I'm not getting ahead of myself here.

Let me back up a little and try to organize the access paths to sockmap
we have, and when they happen in relation to sock_map_free.

A) Access via bpf_map_ops

When bpf_map, and its backing object - bpf_stab, is accessed via map ops
(map_update_elem, map_delete_elem, map_lookup_elem), either (i) a
process has an FD for the map, or (ii) a loaded BPF prog holds a map
reference. Also, we always grab a map ref when creating an FD for it.

This means that map->refcnt is > 0 while a call to one of the map_ops is
in progress.

Hence, bpf_map_free_deferred -> sock_map_free won't get called during
these operations. This fact allowed us to get rid of locking the stab in
sock_map_free.

B) Access via bpf_{sk|msg}_redirect_map

Similar to previous case. BPF prog invoking these helpers must hold a
map reference, so we know that map->refcnt is > 0, and sock_map_free
can't be in progress the same time.

C) Access via sk_psock_link

sk_psock_link has a pointer to bpf_map (link->map) and to an entry in
stab->sks (link->link_raw), but doesn't hold a ref to the map.

We need to ensure bpf_stab doesn't go away, while tcp_bpf_remove ->
sk_psock_unlink -> sock_{map|hash}_delete_from_link call chain is in
progress.

That explains why in sock_map_free, after walking the map and destroying
all links, we wait for the RCU grace period to end with a call to
synchronize_rcu before freeing the map:

	/* wait for psock readers accessing its map link */
	synchronize_rcu();

	bpf_map_area_free(stab->sks);
	kfree(stab);


What is tripping me up, however, is that we also have another call to
synchronize_rcu before walking the map:

	/* After the sync no updates or deletes will be in-flight so it
	 * is safe to walk map and remove entries without risking a race
	 * in EEXIST update case.
	 */
	synchronize_rcu(); // <-- Is it needed?
	for (i = 0; i < stab->map.max_entries; i++) {
		// ...
	}

	/* wait for psock readers accessing its map link */
	synchronize_rcu();


I'm not grasping what purpose the 1st synchronize_rcu call serves.

New readers can start accessing the map after the 1st synchronize_rcu,
and this seems fine since the map will not be freed until after the 2nd
synchronize_rcu call.


Okay, so we can have deletes in-flight, which the explanatory comment
for the 1st synchronize_rcu mentions. What about updates in-flight?

I don't think they can happen with (A) being the only case I know of
when we update the map.

Sorry this was a bit long. So the question is what am I missing?
Can updates happen despite no refs to the map being held?

Thanks,
-jkbs

>
>>
>> /* decrement map refcnt and schedule it for freeing via workqueue
>>  * (unrelying map implementation ops->map_free() might sleep)
>>  */
>> static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
>> {
>> 	if (atomic64_dec_and_test(&map->refcnt)) {
>> 		/* bpf_map_free_id() must be called first */
>> 		bpf_map_free_id(map, do_idr_lock);
>> 		btf_put(map->btf);
>> 		INIT_WORK(&map->work, bpf_map_free_deferred);
>> 		schedule_work(&map->work);
>> 	}
>> }
>>
>> > So with patch below we keep the sync rcu but that is fine IMO these
>> > map free's are rare. Take a look and make sure it seems sane to you
>> > as well.
>>
>> I can't vouch for the need to keep synchronize_rcu here because I don't
>> understand that part, but otherwise the change LGTM.
>>
>> -jkbs
>>
>
> [...]
