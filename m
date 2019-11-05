Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06384F03A7
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389333AbfKERBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:01:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42395 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388488AbfKERBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572973280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6auKLSnTst2UYSqgznztKmzcBOsXckTtoirIp6cMbA=;
        b=bW1KLzOYLrQ54AQapMm5NshBkE9uajf3J+UbMr6s3e3POC/ZD/h3es+umjJsUjIPuqhG8t
        rywQ+tgAlqhPg8sy5Ioma83nH+fXuO2zx/1U7IhHkbEpo0+Ba7e7SxviUNsod/6r1gKv8k
        aYi+IlpKlYUiosuYd6+ak3ashEd+jAs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-MpqCkHYWOiaeGc5b2LG0fg-1; Tue, 05 Nov 2019 12:01:18 -0500
Received: by mail-qt1-f197.google.com with SMTP id h39so23100727qth.13
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 09:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N8ZGORD8ldjsnWlDlDmcPb2UvcVhzcTJ9Ve9/1xgmkA=;
        b=HQy7viV7ll5shZcw/XNHLEwmE0HL9Kp+ObS6UNQIvtUkVktENU9KmUTQ25/KjvPkuZ
         J9SklGhAur1OlylJxtnTOKj6cXEq1Hjd5P/6uegeDwK9OsSp2surFDWaaB3KG22FTDPo
         +lkOa7XQipvwohbgwEPHQTxbGnNog3s4xOu/HOlglHlnf74emAnXs5gL9736NfQUuBd2
         HHiOOIsJN4/00+2pNqocP+lEvOYQuwJKLEQIZ1PpQmfpPLH8yGz9lDj+MTT8rPVJMTUb
         H36mJYz8FloZ9Rra5/Hvu2aGfYGuhBWyxGzowbI4Dw+yU3xs1uo/mTs7KI4Yp2pla7C1
         wqQA==
X-Gm-Message-State: APjAAAWcI6ehf9lkodwgOK0gDZ9YxX2eBmieOXhAt/ZxAqB8LQvAewy9
        +K8gbNdXQ6pm33Dztu8f/3VE8b7MR43bFCZ31uMAhgglGyie64Tg0l2aNe30tspENldm7ZcTxon
        BqWX5tk/Ckg+3gwfx
X-Received: by 2002:a0c:e60b:: with SMTP id z11mr10196151qvm.216.1572973277925;
        Tue, 05 Nov 2019 09:01:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqzANNLZ9TF5B+jdPAI4fWU6NWlvz5ZY0R3d97SIpzoqfBBgRnZiC8nkGpnSAl5wdHORUQIGcw==
X-Received: by 2002:a0c:e60b:: with SMTP id z11mr10196085qvm.216.1572973277403;
        Tue, 05 Nov 2019 09:01:17 -0800 (PST)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id a28sm10252581qkn.126.2019.11.05.09.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:01:16 -0800 (PST)
Subject: Re: Double free of struct sk_buff reported by SLAB_CONSISTENCY_CHECKS
 with init_on_free
To:     Vlastimil Babka <vbabka@suse.cz>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, clipos@ssi.gouv.fr
References: <20191104170303.GA50361@gandi.net>
 <23c73a23-8fd9-c462-902b-eec2a0c04d36@suse.cz>
 <20191105143253.GB1006@gandi.net>
 <4fae11bc-9822-ea10-36e0-68a6fc3995bc@suse.cz>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <af8174be-848e-5f00-d6eb-caa956e8fd71@redhat.com>
Date:   Tue, 5 Nov 2019 12:01:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <4fae11bc-9822-ea10-36e0-68a6fc3995bc@suse.cz>
Content-Language: en-US
X-MC-Unique: MpqCkHYWOiaeGc5b2LG0fg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/19 10:02 AM, Vlastimil Babka wrote:
> On 11/5/19 3:32 PM, Thibaut Sautereau wrote:
>> On Tue, Nov 05, 2019 at 10:00:39AM +0100, Vlastimil Babka wrote:
>>> On 11/4/19 6:03 PM, Thibaut Sautereau wrote:
>>>> The BUG only happens when using `slub_debug=3DF` on the command-line (=
to
>>>> enable SLAB_CONSISTENCY_CHECKS), otherwise the double free is not
>>>> reported and the system keeps running.
>>>
>>> You could change slub_debug parameter to:
>>> slub_debug=3DFU,skbuff_head_cache
>>>
>>> That will also print out who previously allocated and freed the double
>>> freed object. And limit all the tracking just to the affected cache.
>>
>> Thanks, I did not know about that.
>>
>> However, as kind of expected, I get a BUG due to a NULL pointer
>> dereference in print_track():
>=20
> Ah, I didn't read properly your initial mail, that there's a null
> pointer deference during the consistency check.
>=20
> ...
>=20
>>>>
>>>> Bisection points to the following commit: 1b7e816fc80e ("mm: slub: Fix
>>>> slab walking for init_on_free"), and indeed the BUG is not triggered
>>>> when init_on_free is disabled.
>>>
>>> That could be either buggy SLUB code, or the commit somehow exposed a
>>> real bug in skbuff users.
>>
>> Right. At first I thought about some incompatibility between
>> init_on_free and SLAB_CONSISTENCY_CHECKS, but in that case why would it
>> only happen with skbuff_head_cache?
>=20
> That's curious, yeah.
>=20
>> On the other hand, if it's a bug in
>> skbuff users, why is the on_freelist() check in free_consistency_check()
>> not detecting anything when init_on_free is disabled?
>=20
> I vaguely suspect the code in the commit 1b7e816fc80e you bisected,
> where in slab_free_freelist_hook() in the first iteration, we have void
> *p =3D NULL; and set_freepointer(s, object, p); will thus write NULL into
> the freelist. Is is the NULL we are crashing on? The code seems to
> assume that the freelist is rewritten later in the function, but that
> part is only active with some CONFIG_ option(s), none of which might be
> enabled in your case?
> But I don't really understand what exactly this function is supposed to
> do. Laura, does my theory make sense?
>=20
> Thanks,
> Vlastimil
>=20

The note about getting re-written is referring to the fact that the trick
with the bulk free is that we build the detached freelist and then when
we do the cmpxchg it's getting (correctly) updated there.

But looking at this again, I realize this function still has a more
fundamental problem: walking the freelist like this means we actually
end up reversing the list so head and tail are no longer pointing
to the correct blocks. I was able to reproduce the issue by writing a
simple kmem_cache_bulk_alloc/kmem_cache_bulk_free function. I'm
guessing that the test of ping with an unusual size was enough to
regularly trigger a non-trivial bulk alloc/free.

The fix I gave before fixed part of the problem but not all of it.
At this point we're basically duplicating the work of the loop
below so I think we can just combine it. Was there a reason this
wasn't just combined in the first place?

diff --git a/mm/slub.c b/mm/slub.c
index dac41cf0b94a..1510b86b2e7e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1431,13 +1431,17 @@ static inline bool slab_free_freelist_hook(struct k=
mem_cache *s,
  =09void *next =3D *head;
  =09void *old_tail =3D *tail ? *tail : *head;
  =09int rsize;
+=09next =3D *head;
 =20
-=09if (slab_want_init_on_free(s)) {
-=09=09void *p =3D NULL;
+=09/* Head and tail of the reconstructed freelist */
+=09*head =3D NULL;
+=09*tail =3D NULL;
 =20
-=09=09do {
-=09=09=09object =3D next;
-=09=09=09next =3D get_freepointer(s, object);
+=09do {
+=09=09object =3D next;
+=09=09next =3D get_freepointer(s, object);
+
+=09=09if (slab_want_init_on_free(s)) {
  =09=09=09/*
  =09=09=09 * Clear the object and the metadata, but don't touch
  =09=09=09 * the redzone.
@@ -1447,29 +1451,8 @@ static inline bool slab_free_freelist_hook(struct km=
em_cache *s,
  =09=09=09=09=09=09=09   : 0;
  =09=09=09memset((char *)object + s->inuse, 0,
  =09=09=09       s->size - s->inuse - rsize);
-=09=09=09set_freepointer(s, object, p);
-=09=09=09p =3D object;
-=09=09} while (object !=3D old_tail);
-=09}
-
-/*
- * Compiler cannot detect this function can be removed if slab_free_hook()
- * evaluates to nothing.  Thus, catch all relevant config debug options he=
re.
- */
-#if defined(CONFIG_LOCKDEP)=09||=09=09\
-=09defined(CONFIG_DEBUG_KMEMLEAK) ||=09\
-=09defined(CONFIG_DEBUG_OBJECTS_FREE) ||=09\
-=09defined(CONFIG_KASAN)
 =20
-=09next =3D *head;
-
-=09/* Head and tail of the reconstructed freelist */
-=09*head =3D NULL;
-=09*tail =3D NULL;
-
-=09do {
-=09=09object =3D next;
-=09=09next =3D get_freepointer(s, object);
+=09=09}
  =09=09/* If object's reuse doesn't have to be delayed */
  =09=09if (!slab_free_hook(s, object)) {
  =09=09=09/* Move object to the new freelist */
@@ -1484,9 +1467,6 @@ static inline bool slab_free_freelist_hook(struct kme=
m_cache *s,
  =09=09*tail =3D NULL;
 =20
  =09return *head !=3D NULL;
-#else
-=09return true;
-#endif
  }
 =20
  static void *setup_object(struct kmem_cache *s, struct page *page,

