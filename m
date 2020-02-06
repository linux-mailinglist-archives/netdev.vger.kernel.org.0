Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9ED154B91
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 20:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBFTFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 14:05:02 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50727 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFTFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 14:05:02 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so381813pjb.0;
        Thu, 06 Feb 2020 11:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2IF55K0MdXVT6wCeEa6XYnSGtU97xSdA18o6yFV37Bk=;
        b=r46OuX5wwAzImpE6BTphBNaxBwxzgxcdNz4UANjCKVqAJBmEHRROorkvs/PwvfF2Aj
         0lvNGTuIAZXmLpwkqfuyOn1U9qW5y/gs7Dz6tb57eek5VstTvaOJN1sMpKirFKqSOxmB
         PdiZ7Vn9CTdYLPJ6HL0mi+Vi51qavhi/Pgz1suj3tfFdl3Mm4uN4gSk3aThuqB6er7V5
         HHClyMCU5PvdS18PkyUXlsVDiiln85HKRR3BEI6CkOoUHFGL/Trc5NiIEl/Jv3QKDvP2
         Te9rYBKVBc6/QQ/RhOL3KdlIREnrrrbThgvmuXLYScls43eiSG1CQaGjAmQogdNUNO+Y
         j0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2IF55K0MdXVT6wCeEa6XYnSGtU97xSdA18o6yFV37Bk=;
        b=l1SXd87+oP147UtEcV5i4PXl0qmza8pBOByJ0En/KddEWs+0F1JCsKTSDW/AyvjL0m
         rGHhaGdgbGAciuUhK8p/8WVJr6iZuQK3UidWmW7kGu6/LFEr0lnN0jdMpdRXvk2rf6IK
         HM93DM/OE85fm3E03vKb40SxDJ8eRdGbvrNebw8lvbCnPe/ouHqnlfI25mOZ4PvuLv0G
         EAxhaK30vnLBYEVfQ7fz/hQenYyV3Y+eRIWwl3DS3DkIl1K5CeIOZirAIPw+vik3wtif
         /l7kiPBfKk6iEwAf3P8i4EYfI4HMRjiHVM+xXgPxNsF/WoSHnZA2Xvrkv3Cot3jfe3Gq
         pQbg==
X-Gm-Message-State: APjAAAUb+ZsP+ze+IlXS3hyeRWrDwsvG4XYePnPjCuMz3DAoygw6dmoE
        UD6UqV4bw3FCXqFjm8IHR2U=
X-Google-Smtp-Source: APXvYqxf6n4YDiUZsFh+8+9do8BFetTVtgNadp3boFKs/BrkVcnNgn6nLbmnx42QLo4T6Xaffx9CmA==
X-Received: by 2002:a17:90b:87:: with SMTP id bb7mr6344947pjb.49.1581015901337;
        Thu, 06 Feb 2020 11:05:01 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s6sm176918pgq.29.2020.02.06.11.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:05:00 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:04:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org, jonathan.lemon@gmail.com
Message-ID: <5e3c6355ab84c_22ad2af2cbd0a5b478@john-XPS-13-9370.notmuch>
In-Reply-To: <871rr7oqa1.fsf@cloudflare.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
 <20200111061206.8028-3-john.fastabend@gmail.com>
 <8736boor55.fsf@cloudflare.com>
 <5e3ba96ca7889_6b512aafe4b145b812@john-XPS-13-9370.notmuch>
 <871rr7oqa1.fsf@cloudflare.com>
Subject: Re: [bpf PATCH v2 2/8] bpf: sockmap, ensure sock lock held during
 tear down
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, Feb 06, 2020 at 06:51 AM CET, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> On Sat, Jan 11, 2020 at 07:12 AM CET, John Fastabend wrote:
> >> > The sock_map_free() and sock_hash_free() paths used to delete sockmap
> >> > and sockhash maps walk the maps and destroy psock and bpf state associated
> >> > with the socks in the map. When done the socks no longer have BPF programs
> >> > attached and will function normally. This can happen while the socks in
> >> > the map are still "live" meaning data may be sent/received during the walk.

[...]

> >>
> >> John, I've noticed this is triggering warnings that we might sleep in
> >> lock_sock while (1) in RCU read-side section, and (2) holding a spin
> >> lock:
> 
> [...]
> 
> >>
> >> Here's an idea how to change the locking. I'm still wrapping my head
> >> around what protects what in sock_map_free, so please bear with me:
> >>
> >> 1. synchronize_rcu before we iterate over the array is not needed,
> >>    AFAICT. We are not free'ing the map just yet, hence any readers
> >>    accessing the map via the psock are not in danger of use-after-free.
> >
> > Agreed. When we added 2bb90e5cc90e ("bpf: sockmap, synchronize_rcu before
> > free'ing map") we could have done this.
> >
> >>
> >> 2. rcu_read_lock is needed to protect access to psock inside
> >>    sock_map_unref, but we can't sleep while in RCU read-side.  So push
> >>    it down, after we grab the sock lock.
> >
> > yes this looks better.
> >
> >>
> >> 3. Grabbing stab->lock seems not needed, either. We get called from
> >>    bpf_map_free_deferred, after map refcnt dropped to 0, so we're not
> >>    racing with any other map user to modify its contents.
> >
> > This I'll need to think on a bit. We have the link-lock there so
> > probably should be safe to drop. But will need to trace this through
> > git history to be sure.
> >
> 
> [...]
> 
> >> WDYT?
> >
> > Can you push the fix to bpf but leave the stab->lock for now. I think
> > we can do a slightly better cleanup on stab->lock in bpf-next.
> 
> Here it is:
> 
> https://lore.kernel.org/bpf/20200206111652.694507-1-jakub@cloudflare.com/T/#t
> 
> I left the "extra" synchronize_rcu before walking the map. On second
> thought, this isn't a bug. Just adds extra wait. bpf-next material?

Agree.

> 
> >
> >>
> >> Reproducer follows.
> >
> > push reproducer into selftests?
> 
> Included the reproducer with the fixes. If it gets dropped from the
> series, I'll resubmit it once bpf-next reopens.

Yeah, I don't have a strong preference where it lands I have a set of
tests for bpf-next once it opens as well.
