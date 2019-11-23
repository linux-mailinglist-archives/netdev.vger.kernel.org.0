Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A42107CD2
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 05:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKWEn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 23:43:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55052 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfKWEn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 23:43:56 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iYNH0-0007WV-5M; Sat, 23 Nov 2019 04:43:54 +0000
Date:   Sat, 23 Nov 2019 04:43:54 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191123044354.GG26530@ZenIV.linux.org.uk>
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
> > +	/* After filter unmountable pseudo filesytem, d_path won't call
> > +	 * dentry->d_op->d_name(), the normally path doesn't have any
> > +	 * sleepable code, and despite it uses the current macro to get
> > +	 * fs_struct (current->fs), we've already ensured we're in user
> > +	 * context, so it's ok to be here.
> > +	 */
> > +	p = d_path(&f->f_path, dst, size);
> > +	if (IS_ERR(p)) {
> > +		ret = PTR_ERR(p);
> > +		fput(f);
> > +		goto error;
> > +	}
> > +
> > +	ret = strlen(p);
> > +	memmove(dst, p, ret);
> > +	dst[ret++] = '\0';
> > +	fput(f);
> > +	return ret;
> > +
> > +error:
> > +	memset(dst, '0', size);
> > +	return ret;
> > +}
> 
> Al,
> 
> could you please review about code whether it's doing enough checks to be
> called safely from preempt_disabled region?

Depends.  Which context is it running in?  In particular, which
locks might be already held?
