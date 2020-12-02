Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6802CC863
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387512AbgLBUz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:55:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727189AbgLBUz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606942471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p1bLnFlEWYKbw16R1IXidsvYoms+4PACYnhP+qrBmh0=;
        b=iW8Sy0TGfjAGisjdLeP7AmwsT8q1lmBOgESTc85OJw3PAVsuARxwzpTSUgHGvuU0v9K1pk
        mJL5gdfCkk6udwwCAbw8B5EP3UbXdZiL0DUuZiSS3dnhYTAJkt1PqTJwl13M17Qheauaib
        PWoMxWFeOe6gUL6lnmDC/QCWX8zTKos=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-NwBNNauLOym67vlOuHTkkQ-1; Wed, 02 Dec 2020 15:54:28 -0500
X-MC-Unique: NwBNNauLOym67vlOuHTkkQ-1
Received: by mail-oi1-f197.google.com with SMTP id l185so1553703oig.17
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:54:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p1bLnFlEWYKbw16R1IXidsvYoms+4PACYnhP+qrBmh0=;
        b=JAZMzAJad6vyebNp7mZomiqWctokmkK/WON5RVC8t3+cfb4U/TbK/uWtVAbNR6+avb
         +Gf+hCGlfZrGNZkSRRqw+6JsAl/r3HxKxpiUzuhf31rqrckurMuzuRVtM4aNLy8A/1TU
         aGQZltxulku984GtA+IjQLMkZOuBxDE5mAg+bvUXl37fukgsoZJXRITQmpB9YEZirOmL
         JUWhLBKJgJ3nhQI61BAr7QoPR5IOi/Isb0FHhShhURm7dbnpcPpGgoZ9lHSccxg/hN5a
         4q6j/TAJNk9gE3S0al/T2rQcK9DIROoTJY2l8h0lIftDv1cngdmegrIECHQI9IJ+yQIk
         6z/g==
X-Gm-Message-State: AOAM530GVecm6WgFqzdDv3Pn/7J9WeLcguCkFLo+U1bk2pZKYru6hu+Y
        vWFdcrWJSq0ROxg8ZO9LnytBONutt1nIwAynF9qTyJilNBfCgEcQtXovcZBrJOT++T+0tHP8AG6
        cUcQ4rtDBMWpxPf+5TqJR98KVuQBCB4G7
X-Received: by 2002:a4a:9cc7:: with SMTP id d7mr3116949ook.8.1606942467391;
        Wed, 02 Dec 2020 12:54:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwemcDixdv6gA+fb37ftXb6Dv3KTCWt/M/qExs75JZtNtb/GbFzEvTM+N3Ztast3lK9ic+UUcRiKYWi9Nxzaa8=
X-Received: by 2002:a4a:9cc7:: with SMTP id d7mr3116937ook.8.1606942467217;
 Wed, 02 Dec 2020 12:54:27 -0800 (PST)
MIME-Version: 1.0
References: <20201123031716.6179-1-jarod@redhat.com> <20201202173053.13800-1-jarod@redhat.com>
 <14711.1606931728@famine> <CAKfmpSez1UYLG5nGYbMsRALGpEyXnwJcoFJV_7vALgpG3Xotcw@mail.gmail.com>
 <21153.1606940246@famine>
In-Reply-To: <21153.1606940246@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 2 Dec 2020 15:54:16 -0500
Message-ID: <CAKfmpScW_Ar91f1dd5QAeVmQa-G9c0qnJph+cBOJ_CoEGBoFpg@mail.gmail.com>
Subject: Re: [PATCH net v2] bonding: fix feature flag setting at init time
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 3:17 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >On Wed, Dec 2, 2020 at 12:55 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >>
> >> Jarod Wilson <jarod@redhat.com> wrote:
> >>
> >> >Don't try to adjust XFRM support flags if the bond device isn't yet
> >> >registered. Bad things can currently happen when netdev_change_features()
> >> >is called without having wanted_features fully filled in yet. Basically,
> >> >this code was racing against register_netdevice() filling in
> >> >wanted_features, and when it got there first, the empty wanted_features
> >> >led to features also getting emptied out, which was definitely not the
> >> >intended behavior, so prevent that from happening.
> >>
> >>         Is this an actual race?  Reading Ivan's prior message, it sounds
> >> like it's an ordering problem (in that bond_newlink calls
> >> register_netdevice after bond_changelink).
> >
> >Sorry, yeah, this is not actually a race condition, just an ordering
> >issue, bond_check_params() gets called at init time, which leads to
> >bond_option_mode_set() being called, and does so prior to
> >bond_create() running, which is where we actually call
> >register_netdevice().
>
>         So this only happens if there's a "mode" module parameter?  That
> doesn't sound like the call path that Ivan described (coming in via
> bond_newlink).

Ah. I think there's actually two different pathways that can trigger
this. The first is for bonds created at module load time, which I was
describing, the second is for a new bond created via bond_newlink()
after the bonding module is already loaded, as described by Ivan. Both
have the problem of bond_option_mode_set() running prior to
register_netdevice(). Of course, that would suggest every bond
currently comes up with unintentionally neutered flags, which I
neglected to catch in earlier testing and development.

-- 
Jarod Wilson
jarod@redhat.com

