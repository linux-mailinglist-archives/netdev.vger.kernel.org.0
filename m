Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B2304775
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbhAZRCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:02:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732178AbhAZGhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 01:37:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611642982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k76i8vrv9RuAoEc374B3SPZZTnGfzS077Ys8gO8keCo=;
        b=W9eQuTShgM+bOkVEZRZm1Vg7BVDaYAqSXaiUBlu2Gk0yfAcQPai4Ae+BASXyweZdaJ1jk1
        jmxvrkcSxngTXPM79eAMZm/1UaztlDAEz+1aubrTY2y8Ik4G4m8oB3rZNOTEALv+Pd6GwM
        x9V25hSWLOstkE4bx/Y72jTdv1ygjak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-j4hSNdxFNVm4WkkXynHrIQ-1; Tue, 26 Jan 2021 01:36:17 -0500
X-MC-Unique: j4hSNdxFNVm4WkkXynHrIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 493B3190A7A0;
        Tue, 26 Jan 2021 06:36:15 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DC9019934;
        Tue, 26 Jan 2021 06:36:13 +0000 (UTC)
Date:   Tue, 26 Jan 2021 07:36:12 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH net] team: protect features update by RCU to avoid
 deadlock
Message-ID: <20210126073612.05e8c302@ceranb>
In-Reply-To: <CAM_iQpX85wZn0ihG_XxPq=inM5P8dKvf4BE6kNwG2na=NAnGzw@mail.gmail.com>
References: <20210125074416.4056484-1-ivecera@redhat.com>
        <CAM_iQpX85wZn0ihG_XxPq=inM5P8dKvf4BE6kNwG2na=NAnGzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 12:53:22 -0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On Sun, Jan 24, 2021 at 11:44 PM Ivan Vecera <ivecera@redhat.com> wrote:
> >
> > Function __team_compute_features() is protected by team->lock
> > mutex when it is called from team_compute_features() used when
> > features of an underlying device is changed. This causes
> > a deadlock when NETDEV_FEAT_CHANGE notifier for underlying device
> > is fired due to change propagated from team driver (e.g. MTU
> > change). It's because callbacks like team_change_mtu() or
> > team_vlan_rx_{add,del}_vid() protect their port list traversal
> > by team->lock mutex.
> >
> > Example (r8169 case where this driver disables TSO for certain MTU
> > values):
> > ...
> > [ 6391.348202]  __mutex_lock.isra.6+0x2d0/0x4a0
> > [ 6391.358602]  team_device_event+0x9d/0x160 [team]
> > [ 6391.363756]  notifier_call_chain+0x47/0x70
> > [ 6391.368329]  netdev_update_features+0x56/0x60
> > [ 6391.373207]  rtl8169_change_mtu+0x14/0x50 [r8169]
> > [ 6391.378457]  dev_set_mtu_ext+0xe1/0x1d0
> > [ 6391.387022]  dev_set_mtu+0x52/0x90
> > [ 6391.390820]  team_change_mtu+0x64/0xf0 [team]
> > [ 6391.395683]  dev_set_mtu_ext+0xe1/0x1d0
> > [ 6391.399963]  do_setlink+0x231/0xf50
> > ...
> >
> > In fact team_compute_features() called from team_device_event()
> > does not need to be protected by team->lock mutex and rcu_read_lock()
> > is sufficient there for port list traversal.  
> 
> Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
> 
> In the future, please version your patch so that we can easily
> find out which is the latest.

OK, got it... I haven't added a version due to different subjects...

Thanks,
Ivan

