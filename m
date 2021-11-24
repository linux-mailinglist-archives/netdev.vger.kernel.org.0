Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2272745BCB6
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244075AbhKXMb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:31:56 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:45239 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243237AbhKXMZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 07:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=rnnh51cxcefUFgbd3NlMnfTWFCiiqqU0gNz9ZYEeKqQ=; b=k9QxUcqK8au7iZnh/L72mYkvW3
        Umrk4sMzWXXqElSYQp0PP8qp73Lo/NDHFRZkjUZbhjROBv05c4lEuDUYXnzDZRZGobJ1olY7Wrd55
        YDCYGiZTP3kHbgk8wa5VMHrhDGkGWNsnlMlaHcfBItEJW6cw4+VeQJ0fnz+QxO+hrsIb1hKm/6T82
        3a0unJy5zwzBxYspiwxrmVXSIYTSG0yGB4yEkjOrDkgdWGRVhUiguoXCB8P5S6xiBx5hkOdRydva5
        1npxH+9f4v5KTkGpG8KsayEK60NlBX7whaN6NPepLEjFK99kimaHkaH4ZoeXPEJh2eppR42NW8mSV
        ofjiN3zt8eoPAz+EAB3fpmU6w6D9DONDtwQ2sPDxpDZm6ER4dPevwrcjFk61Ew3taVmkN3gRjsFZV
        m3BmriXMBRTLzY0Y91AV+0U6wMBmm+6SK/Db6cBxfemEJk4ZjW4kb67NoAq1MPdwymTSG8NGgzJYM
        zpH5U6Ifs1SxXCOXqGAw/kES1D6POfYS+7rByII2hNsN3dPSMijVqkTo5hORKLa/UqJ4v7q60IJGZ
        jQCnXjjBWS7G/rjmvgyNvP0YkgtFE0VwTW5JbOKwYDO+IM1dmej20ZI3TG+tO7YS9RicPkTACebBI
        4AzDxFn2zIMJhvL1V/OaJ4d0jeaNBdo6aLThRwv4w=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Date:   Wed, 24 Nov 2021 13:22:20 +0100
Message-ID: <2311686.9pNgMZ9BYA@silver>
In-Reply-To: <YZwbJiFcLgwITsUe@codewreck.org>
References: <YZl+eD6r0iIGzS43@codewreck.org> <1797352.eH9cFvQebf@silver> <YZwbJiFcLgwITsUe@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 22. November 2021 23:35:18 CET Dominique Martinet wrote:
> Christian Schoenebeck wrote on Mon, Nov 22, 2021 at 02:32:23PM +0100:
> > I "think" this could be used for all 9p message types except for the
> > listed
> > former three, but I'll review the 9p specs more carefully before v4. For
> > Tread and Twrite we already received the requested size, which just
> > leaves Treaddir, which is however indeed tricky, because I don't think we
> > have any info how many directory entries we could expect.
> 
> count in Treaddir is a number of bytes, not a number of entries -- so
> it's perfect for this as well :)

Yes it is in bytes, but it's currently always simply msize - P9_READDIRHDRSZ:
https://github.com/torvalds/linux/blob/5d9f4cf36721aba199975a9be7863a3ff5cd4b59/fs/9p/vfs_dir.c#L159

As my planned milestone for this series is max. 4 MB msize, it might be okay
for now, but it is something to keep in mind and should be checked whether it
will slow down things.

On the long term, when msize >4MB is supported, this definitely must be
addressed.

> > A simple compile time constant (e.g. one macro) could be used instead of
> > this function. If you prefer a constant instead, I could go for it in v4
> > of course. For this 9p client I would recommend a function though, simply
> > because this code has already seen some authors come and go over the
> > years, so it might be worth the redundant code for future safety. But
> > I'll adapt to what others think.
> 
> In this case a fallback constant seems simpler than a big switch like
> you've done, but honestly I'm not fussy at this point -- if you work on
> this you have the right to decide this kind of things in my opinion.
> 
> My worry with the snippet you listed is that you need to enumerate all
> calls again, so if someday the protocol is extended it'll be a place to
> forget adding new calls (although compiler warnings help with that),
> whereas a fallback constant will always work as long as it's small
> messages.
> 
> But really, as long as it's not horrible I'll take it :)

Maybe I can find a compromise. :)

Best regards,
Christian Schoenebeck


