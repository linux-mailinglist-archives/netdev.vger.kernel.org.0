Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73111B2024
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 09:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgDUHmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 03:42:50 -0400
Received: from verein.lst.de ([213.95.11.211]:45118 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgDUHms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 03:42:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1C8B568CEC; Tue, 21 Apr 2020 09:42:42 +0200 (CEST)
Date:   Tue, 21 Apr 2020 09:42:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 6/6] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200421074241.GB15772@lst.de>
References: <20200417064146.1086644-1-hch@lst.de> <20200417064146.1086644-7-hch@lst.de> <20200417181718.GN5820@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417181718.GN5820@bombadil.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 11:17:18AM -0700, Matthew Wilcox wrote:
> >  	if (error)
> > -		goto out;
> > +		goto out_free_buf;
> >  
> >  	/* careful: calling conventions are nasty here */
> 
> I think this comment can go now ;-)

It actually long predates the set_fs that was only added for BPF,
and goes back to:

330d57fb98a91 ("[PATCH] Fix sysctl unregistration oops (CVE-2005-2709)")
in the history.git tree.

> > -	} else {
> > -		error = table->proc_handler(table, write, buf, &count, ppos);
> > -	}
> > +	error = table->proc_handler(table, write, kbuf, &count, ppos);
> > +	if (error)
> > +		goto out_free_buf;
> > +
> > +	error = -EFAULT;
> > +	if (copy_to_user(ubuf, kbuf, count))
> > +		goto out_free_buf;
> 
> Can we skip this if !write?  Indeed, don't we have to in case the user has
> passed a pointer to a read-only memory page?

Indeed.
