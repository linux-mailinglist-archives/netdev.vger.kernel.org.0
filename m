Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44D16E9AA6
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDTRZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjDTRZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:25:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347DB4EC7
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682011447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THiSF9/cQ+9P0jAFh1XrgO39jM++pc1oXx0FF5X3CLI=;
        b=HXBCnQELkhOp5IhCkdYLWIuM2MM0UpRqGnteMyPJgEShr3rZqMpbuR/GbhAG0hrzWf26cw
        GbCSQGgEy48L+PRcMTzHEZo9OtGiXdEGloP1vh+6t1jUhe1+FtJSjRWF4hkutjqcCXU3gO
        sO1M+s/Mm9mXkHP4pvsUgq/AcJCqfrU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-uk2-zpubPDyyHKNr545b9g-1; Thu, 20 Apr 2023 13:24:06 -0400
X-MC-Unique: uk2-zpubPDyyHKNr545b9g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f182c058c8so1902375e9.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011445; x=1684603445;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=THiSF9/cQ+9P0jAFh1XrgO39jM++pc1oXx0FF5X3CLI=;
        b=goKpIIPzPXKGn1qE47JfWqx85igHGSkpPJAy2KSo/QgjiEdliUJsDRAAAdXn/wGxFJ
         X0AdrBMzsf8wZgKfF8G0MuEbGuFIgapEqP7ru0FAA6XbZKyQtzJchCDqURdw8zIPAo1r
         fzfU5PcUAt9TqZ7WCmx9jvh14BT6aXgZzpddSidQj1AkSaTY2ZbJ6UpztUV9lW3/dG1P
         dXg5wksERukxXo62wFnQRD1QMTJnccm7h7H3GnQvU5pcJRlqQnS6xKfvM4D/IzMUTU3W
         gysIDQonxfpwANEYTuATdbZHfEV1ys1qkKJF+kFmXFiuLsZA7AoUDduSB80ps0E/jQWO
         HlPw==
X-Gm-Message-State: AAQBX9fjTQsiQd3ODhfoluLDkeTQDuinpwyziaxK+l5Q4ZJRlWuq1D5h
        jcx1JLSnllO7xEkk+CovoliNGl7vfjBSgwJq6/CIP9WWLlznfzVV576ZeQAJBNWMHnkWarkQsKR
        4wFvYWgF4OK4frF1P
X-Received: by 2002:adf:fc0b:0:b0:302:1af8:3cc8 with SMTP id i11-20020adffc0b000000b003021af83cc8mr1491599wrr.0.1682011444801;
        Thu, 20 Apr 2023 10:24:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350YP3NWx6sNH3gg4ANitVJj16Mr6SDRP08iIYDyBVWJhyjhq9t9YIOEFVRvEQdiBCyXgbeD2Lg==
X-Received: by 2002:adf:fc0b:0:b0:302:1af8:3cc8 with SMTP id i11-20020adffc0b000000b003021af83cc8mr1491579wrr.0.1682011444377;
        Thu, 20 Apr 2023 10:24:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-230-117.dyn.eolo.it. [146.241.230.117])
        by smtp.gmail.com with ESMTPSA id z17-20020adfdf91000000b002d97529b3bbsm2415725wrl.96.2023.04.20.10.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:24:03 -0700 (PDT)
Message-ID: <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
Subject: Re: [PATCH 0/3] softirq: uncontroversial change
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        tglx@linutronix.de
Cc:     jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 20 Apr 2023 19:24:02 +0200
In-Reply-To: <20221222221244.1290833-1-kuba@kernel.org>
References: <20221222221244.1290833-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
On Thu, 2022-12-22 at 14:12 -0800, Jakub Kicinski wrote:
> Catching up on LWN I run across the article about softirq
> changes, and then I noticed fresh patches in Peter's tree.
> So probably wise for me to throw these out there.
>=20
> My (can I say Meta's?) problem is the opposite to what the RT
> sensitive people complain about. In the current scheme once
> ksoftirqd is woken no network processing happens until it runs.
>=20
> When networking gets overloaded - that's probably fair, the problem
> is that we confuse latency tweaks with overload protection. We have
> a needs_resched() in the loop condition (which is a latency tweak)
> Most often we defer to ksoftirqd because we're trying to be nice
> and let user space respond quickly, not because there is an
> overload. But the user space may not be nice, and sit on the CPU
> for 10ms+. Also the sirq's "work allowance" is 2ms, which is
> uncomfortably close to the timer tick, but that's another story.
>=20
> We have a sirq latency tracker in our prod kernel which catches
> 8ms+ stalls of net Tx (packets queued to the NIC but there is
> no NAPI cleanup within 8ms) and with these patches applied
> on 5.19 fully loaded web machine sees a drop in stalls from
> 1.8 stalls/sec to 0.16/sec. I also see a 50% drop in outgoing
> TCP retransmissions and ~10% drop in non-TLP incoming ones.
> This is not a network-heavy workload so most of the rtx are
> due to scheduling artifacts.
>=20
> The network latency in a datacenter is somewhere around neat
> 1000x lower than scheduling granularity (around 10us).
>=20
> These patches (patch 2 is "the meat") change what we recognize
> as overload. Instead of just checking if "ksoftirqd is woken"
> it also caps how long we consider ourselves to be in overload,
> a time limit which is different based on whether we yield due
> to real resource exhaustion vs just hitting that needs_resched().
>=20
> I hope the core concept is not entirely idiotic. It'd be great
> if we could get this in or fold an equivalent concept into ongoing
> work from others, because due to various "scheduler improvements"
> every time we upgrade the production kernel this problem is getting
> worse :(

Please allow me to revive this old thread.

My understanding is that we want to avoid adding more heuristics here,
preferring a consistent refactor.

I would like to propose a revert of:

4cd13c21b207 softirq: Let ksoftirqd do its job

the its follow-ups:

3c53776e29f8 Mark HI and TASKLET softirq synchronous
0f50524789fc softirq: Don't skip softirq execution when softirq thread is p=
arking

The problem originally addressed by 4cd13c21b207 can now be tackled
with the threaded napi, available since:

29863d41bb6e net: implement threaded-able napi poll loop support

Reverting the mentioned commit should address the latency issues
mentioned by Jakub - I verified it solves a somewhat related problem in
my setup - and reduces the layering of heuristics in this area.

A refactor introducing uniform overload detection and proper resource
control will be better, but I admit it's beyond me and anyway it could
still land afterwards.

Any opinion more then welcome!

Thanks,

Paolo

