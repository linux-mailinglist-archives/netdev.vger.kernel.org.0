Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF3C2D451F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 16:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgLIPJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 10:09:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728661AbgLIPJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 10:09:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607526497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlCuNhyg8UPyeR0OIa80s3EAeM8QXW2ZJz4Mla5QY7w=;
        b=Mbrv9Jlm/ACvDfgr50R2IEP6PFz01bvtcKPNBq+PRVaqOln5ti1lJrNAjQtxAkdny4aCeK
        gVQ/1FywKBf2WYQHGFr2nawk+p8SpwrNGeHvFsY+VWxu1VyTpkoH357uutsPe/T4uETrBe
        qjrfVqy8KB/65s7KLzr7nCxWfEjsg04=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-dPnbvhCPPq69xOi71MU2Iw-1; Wed, 09 Dec 2020 10:08:16 -0500
X-MC-Unique: dPnbvhCPPq69xOi71MU2Iw-1
Received: by mail-oo1-f72.google.com with SMTP id o65so915727ooo.8
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 07:08:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xlCuNhyg8UPyeR0OIa80s3EAeM8QXW2ZJz4Mla5QY7w=;
        b=pSmfjMHV8dHcbYRewhvrZfg5RBEX5NZX7nC1IaW9Adp+52k0c/R4xzUQl/n/CSaSf/
         ZZlxVLrDNWdF6iAnKqu7F4ItK10JhtVLGkV1AqLdKAllTe577ew08ReTftGkYYfJ5ZFp
         5Mnj0Qu1Yy7euhmbpBPDEMXSkHrJazcLV0nng43cwkwImV6xNpTs0xKaVW8hRtd8s0eJ
         KpGwYX4IpN8R1SLvoqeMVsPpenn2Q+wySz5oCje9fMQMZnVfI99/of28zb3GrpUdMLfz
         tf4E5giM7qlxq5Z582O+bx4S3ibPrb0QGlfwSIQT6KNVnXUQGtBHPlqGdVA8lrZjo1DZ
         UMog==
X-Gm-Message-State: AOAM530YkNVUaW8omq4KsdNEqP+pRbZakPzTTyhl7u51ajpN87TROvd8
        sJ5KbXYRS38SFSRE9Jmnct0gdcbnsRWTc47tDWYjkQYtq8Ua8ZnWDPEB93/25F6MBqf74AC5YHn
        CJJhSiq35IP9XrJFSxCcu5UVCfzn9EDhR
X-Received: by 2002:a9d:6642:: with SMTP id q2mr2099025otm.172.1607526494563;
        Wed, 09 Dec 2020 07:08:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxEf/UEjzXAFpYgMIza30IQJ6ydfWBGKkP+VB9KkIFoD89iMMwB8+euqGo84lFPEoO4zS3AadAdoDeKFmo26g=
X-Received: by 2002:a9d:6642:: with SMTP id q2mr2099001otm.172.1607526494280;
 Wed, 09 Dec 2020 07:08:14 -0800 (PST)
MIME-Version: 1.0
References: <20201205234354.1710-1-jarod@redhat.com> <20201208113820.179ed5ca@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208113820.179ed5ca@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 9 Dec 2020 10:08:05 -0500
Message-ID: <CAKfmpSe1o9_eFu70PPHT9MF5tMYjZqgajCfpDHCnsHQBUdcW0Q@mail.gmail.com>
Subject: Re: [PATCH net] bonding: reduce rtnl lock contention in mii monitor thread
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 2:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat,  5 Dec 2020 18:43:54 -0500 Jarod Wilson wrote:
> > I'm seeing a system get stuck unable to bring a downed interface back up
> > when it's got an updelay value set, behavior which ceased when logging
> > spew was removed from bond_miimon_inspect(). I'm monitoring logs on this
> > system over another network connection, and it seems that the act of
> > spewing logs at all there increases rtnl lock contention, because
> > instrumented code showed bond_mii_monitor() never able to succeed in it's
> > attempts to call rtnl_trylock() to actually commit link state changes,
> > leaving the downed link stuck in BOND_LINK_DOWN. The system in question
> > appears to be fine with the log spew being moved to
> > bond_commit_link_state(), which is called after the successful
> > rtnl_trylock().
>
> But it's not called under rtnl_lock AFAICT. So something else is also
> spewing messages?
>
> While bond_commit_link_state() _is_ called under the lock. So you're
> increasing the retry rate, by putting the slow operation under the
> lock, is that right?

Partially, yes. I probably should have tagged this with RFC instead of
PATCH, tbh. My theory was that the log spew, being sent out *other*
network interfaces when monitoring the system or remote syslog or ssh
was potentially causing some rtnl_lock() calls, so not spewing until
after actually being able to grab the lock would lessen the problem
w/actually acquiring the lock, but I ... don't know offhand how to
verify that theory.


> Also isn't bond_commit_link_state() called from many more places?
> So we're adding new prints, effectively?

Ah. Crap. Yes. bond_set_slave_link_state() is called quite a few
places, and that in turn calls bond_commit_link_state().


> > I'm actually wondering if perhaps we ultimately need/want
> > some bond-specific lock here to prevent racing with bond_close() instead
> > of using rtnl, but this shift of the output appears to work. I believe
> > this started happening when de77ecd4ef02 ("bonding: improve link-status
> > update in mii-monitoring") went in, but I'm not 100% on that.
> >
> > The addition of a case BOND_LINK_BACK in bond_miimon_inspect() is somewhat
> > separate from the fix for the actual hang, but it eliminates a constant
> > "invalid new link 3 on slave" message seen related to this issue, and it's
> > not actually an invalid state here, so we shouldn't be reporting it as an
> > error.
>
> Let's make it a separate patch, then.

Sounds like Jay is confident that bit is valid, and I shouldn't be
ending up in that state, unless something else is going wrong.

-- 
Jarod Wilson
jarod@redhat.com

