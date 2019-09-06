Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F89ABCDF
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405834AbfIFPqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:46:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58036 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394878AbfIFPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:46:49 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.1 #3 (Red Hat Linux))
        id 1i6GRj-0005Pl-BW; Fri, 06 Sep 2019 15:46:47 +0000
Date:   Fri, 6 Sep 2019 16:46:47 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from  current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190906154647.GA19707@ZenIV.linux.org.uk>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906152435.GW1131@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 04:24:35PM +0100, Al Viro wrote:
> > +	tmp = kmalloc(fnamesize, GFP_ATOMIC);
> > +	if (unlikely(!tmp)) {
> > +		__putname(fname);
> > +		ret = -ENOMEM;
> > +		goto clear;
> > +	}
> > +
> > +	tmp->name = (char *)fname;
> > +	fname = tmp;
> > +	len = strlen(pidns_path) + 1;
> > +	memcpy((char *)fname->name, pidns_path, len);
> > +	fname->uptr = NULL;
> > +	fname->aname = NULL;
> > +	fname->refcnt = 1;
> > +
> > +	ret = filename_lookup(AT_FDCWD, fname, 0, &kp, NULL);
> > +	if (ret)
> > +		goto clear;
> 
> Where do I begin?
> 	* getname_kernel() is there for purpose
> 	* so's kern_path(), damnit

Oh, and filename_lookup() *CAN* sleep, obviously.  So that
GFP_ATOMIC above is completely pointless.

> > +
> > +	inode = d_backing_inode(kp.dentry);
> > +	pidns_info->dev = (u32)inode->i_rdev;

Why are plaing with device number, anyway?  And why would it
be anything other than 0?
