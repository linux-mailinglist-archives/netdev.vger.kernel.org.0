Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA167ABD28
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393118AbfIFQAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:00:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58304 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIFQAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:00:22 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.1 #3 (Red Hat Linux))
        id 1i6Geq-0005iN-3P; Fri, 06 Sep 2019 16:00:20 +0000
Date:   Fri, 6 Sep 2019 17:00:20 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from  current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190906160020.GX1131@ZenIV.linux.org.uk>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906154647.GA19707@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 04:46:47PM +0100, Al Viro wrote:

> > Where do I begin?
> > 	* getname_kernel() is there for purpose
> > 	* so's kern_path(), damnit
> 
> Oh, and filename_lookup() *CAN* sleep, obviously.  So that
> GFP_ATOMIC above is completely pointless.
> 
> > > +
> > > +	inode = d_backing_inode(kp.dentry);
> > > +	pidns_info->dev = (u32)inode->i_rdev;

In the original variant of patchset it used to be ->i_sb->s_dev,
which is also bloody strange - you are not asking filename_lookup()
to follow symlinks, so you'd get that of whatever filesystem
/proc/self/ns resides on.

->i_rdev use makes no sense whatsoever - it's a symlink and
neither it nor its target are device nodes; ->i_rdev will be
left zero for both.

What data are you really trying to get there?
