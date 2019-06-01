Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26DA3190D
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfFACey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:34:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37734 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfFACey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:34:54 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hWtr7-0004kh-Af; Sat, 01 Jun 2019 02:34:49 +0000
Date:   Sat, 1 Jun 2019 03:34:49 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        omosnace@redhat.com, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3] selinux: lsm: fix a missing-check bug in
 selinux_sb_eat_lsm_opts()
Message-ID: <20190601023449.GS17978@ZenIV.linux.org.uk>
References: <20190601021526.GA8264@zhanggen-UX430UQ>
 <20190601022527.GR17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601022527.GR17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 03:25:27AM +0100, Al Viro wrote:
> On Sat, Jun 01, 2019 at 10:15:26AM +0800, Gen Zhang wrote:
> > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > returns NULL when fails. So 'arg' should be checked. And 'mnt_opts' 
> > should be freed when error.
> 
> What's the latter one for?  On failure we'll get to put_fs_context()
> pretty soon, so
>         security_free_mnt_opts(&fc->security);
> will be called just fine.  Leaving it allocated on failure is fine...

Actually, right now in mainline it is not (btrfs_mount_root() has
an odd call of security_sb_eat_lsm_opts()); eventually we will be
down to just the callers in ->parse_monolithic() instances, at which
point the above will become correct.  At the moment it is not, so
consider the objection withdrawn (and I really need to get some sleep,
seeing how long did it take me to recall the context... ;-/)
