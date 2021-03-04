Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA632DBD8
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbhCDVd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbhCDVdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 16:33:46 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C9C061760
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 13:33:06 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id d13so31892342edp.4
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 13:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0qROWWTNz36x2w3xcMbLyxyZ1xmwI8HYrEV2dBDfDzY=;
        b=0CwLBLNiLo1fwP/msdddCOm2cYa8rCYq+oioL39s+Ms2gEcWumQYr6RHjPmlol2qeP
         2nFi9aY60gAzKw6DdGMiElgkFSUlJImhpqX2AWYL9Gu+0NUz3ausXJ+EH0VeU4/UcIFr
         t4V3y3rstumz/CmV6XfGE6pD7hYZeirlPf5f3tJaoKB/2q0xA7fFheimMomFlcGVteQK
         pKXkVWWHVW+/Irc5dzzHPgLeYvW+Dwe6v69wHNXQ5L87aPBEodOgrB6cd8wTaAKNlYN2
         o4YQq92KLZ3GNRLO3FL3Bebp2WLws+zAWXQ3oQDqAswonyuJgx5FsxMMoY45jSWBsclo
         7zbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0qROWWTNz36x2w3xcMbLyxyZ1xmwI8HYrEV2dBDfDzY=;
        b=Ly7QcY1gHR6ms3t+qv0FVFQ5rTSFAomPrZeuwpSWURpCHiBmVRHdDv7p8zYzq3a0xG
         9DRsf7DcxR2sNk12zXBcBNiQNkoOzTRPHFXbx1AedqnzraUlasH/e0iPJOaX9yRhA/ZU
         rs+BcOJN8TCoxuwSPiJbtG1KdkOXUZId6G6NDOKg1nOg5Fazf5Md6w+Tmk6o+02TT7TS
         GyspJmPd0jVX+s8hJ/hqOL58mYgPJaurnDeTXjWEoJ4dGBS/cJvEf0CvdUZ0zr3o3JcJ
         hM11Cce9vIp4PW1gejtIwEenCNXk6TbMTJRO3nwG/plXrzcnKhcZL2cgpUQ9nLjjBfPa
         T/Bw==
X-Gm-Message-State: AOAM5311fmh09DfBw3AI6EOU0ribGR83QQW18dz45a1j/Ld96pjceVBD
        ftX0H8XJ1+u83pR9Dt+wkqb++NCLkeaLWM8SrKEebcrmW2FH
X-Google-Smtp-Source: ABdhPJzy4UbgOeVcYyn5pg7jcVZivwdX/+HaoAbCbn+pN9b29g6mYvb4yXwZjhuGJ7rLq53LL8NlW7vQ6Lj3YqLwJKU=
X-Received: by 2002:a05:6402:3c7:: with SMTP id t7mr6651176edw.196.1614893584307;
 Thu, 04 Mar 2021 13:33:04 -0800 (PST)
MIME-Version: 1.0
References: <161489339182.63157.2775083878484465675.stgit@olly>
In-Reply-To: <161489339182.63157.2775083878484465675.stgit@olly>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 4 Mar 2021 16:32:53 -0500
Message-ID: <CAHC9VhQuNf-PjxdHj2CkfVCZwFfucR_+5Xvr=OahkfXNPKgTmQ@mail.gmail.com>
Subject: Re: [PATCH] cipso,calipso: resolve a number of problems with the DOI refcounts
To:     netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 4:29 PM Paul Moore <paul@paul-moore.com> wrote:
>
> The current CIPSO and CALIPSO refcounting scheme for the DOI
> definitions is a bit flawed in that we:
>
> 1. Don't correctly match gets/puts in netlbl_cipsov4_list().
> 2. Decrement the refcount on each attempt to remove the DOI from the
>    DOI list, only removing it from the list once the refcount drops
>    to zero.
>
> This patch fixes these problems by adding the missing "puts" to
> netlbl_cipsov4_list() and introduces a more conventional, i.e.
> not-buggy, refcounting mechanism to the DOI definitions.  Upon the
> addition of a DOI to the DOI list, it is initialized with a refcount
> of one, removing a DOI from the list removes it from the list and
> drops the refcount by one; "gets" and "puts" behave as expected with
> respect to refcounts, increasing and decreasing the DOI's refcount by
> one.
>
> Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking with refrerence counts")
> Fixes: d7cce01504a0 ("netlabel: Add support for removing a CALIPSO DOI.")
> Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  net/ipv4/cipso_ipv4.c            |   11 +----------
>  net/ipv6/calipso.c               |   14 +++++---------
>  net/netlabel/netlabel_cipso_v4.c |    3 +++
>  3 files changed, 9 insertions(+), 19 deletions(-)

As a FYI, this patch has been tested by looping through a number of
NetLabel/CALIPSO/CIPSO tests overnight, a reproducer from one of the
syzbot reports (multiple times), and the selinux-testsuite tests;
everything looked good at the end of the testing.

Thanks to syzbot and Dmitry for finding and reporting the bug.

-- 
paul moore
www.paul-moore.com
