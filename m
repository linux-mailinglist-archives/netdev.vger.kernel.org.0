Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE140107CDA
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 05:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKWEvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 23:51:54 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55126 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfKWEvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 23:51:54 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iYNOh-0007i3-L4; Sat, 23 Nov 2019 04:51:52 +0000
Date:   Sat, 23 Nov 2019 04:51:51 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191123045151.GH26530@ZenIV.linux.org.uk>
References: <cover.1574162990.git.ethercflow@gmail.com>
 <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
 <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 07:18:28PM -0800, Alexei Starovoitov wrote:
> > +	f = fget_raw(fd);
> > +	if (!f)
> > +		goto error;
> > +
> > +	/* For unmountable pseudo filesystem, it seems to have no meaning
> > +	 * to get their fake paths as they don't have path, and to be no
> > +	 * way to validate this function pointer can be always safe to call
> > +	 * in the current context.
> > +	 */
> > +	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname)
> > +		return -EINVAL;

An obvious leak here, BTW.

Anyway, what could that be used for?  I mean, if you want to check
something about syscall arguments, that's an unfixably racy way to go.
Descriptor table can be a shared data structure, and two consequent
fdget() on the same number can bloody well yield completely unrelated
struct file references.

IOW, anything that does descriptor -> struct file * translation more than
once is an instant TOCTOU suspect.  In this particular case, the function
will produce a pathname of something that was once reachable via descriptor
with this number; quite possibly never before that function had been called
_and_ not once after it has returned.
