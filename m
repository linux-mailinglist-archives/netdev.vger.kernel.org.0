Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901C61B3520
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 04:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgDVCqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 22:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgDVCqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 22:46:38 -0400
X-Greylist: delayed 27013 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Apr 2020 19:46:37 PDT
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF37C0610D6;
        Tue, 21 Apr 2020 19:46:37 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR5P8-0081T1-82; Wed, 22 Apr 2020 02:46:26 +0000
Date:   Wed, 22 Apr 2020 03:46:26 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200422024626.GI23230@ZenIV.linux.org.uk>
References: <20200421171539.288622-1-hch@lst.de>
 <20200421171539.288622-6-hch@lst.de>
 <20200421191615.GE23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421191615.GE23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 08:16:15PM +0100, Al Viro wrote:
> On Tue, Apr 21, 2020 at 07:15:39PM +0200, Christoph Hellwig wrote:
> > Instead of having all the sysctl handlers deal with user pointers, which
> > is rather hairy in terms of the BPF interaction, copy the input to and
> > from  userspace in common code.  This also means that the strings are
> > always NUL-terminated by the common code, making the API a little bit
> > safer.
> > 
> > As most handler just pass through the data to one of the common handlers
> > a lot of the changes are mechnical.
> 
> > @@ -564,27 +564,38 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
> >  	if (!table->proc_handler)
> >  		goto out;
> >  
> > -	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, buf, &count,
> > -					   ppos, &new_buf);
> > +	if (write) {
> > +		kbuf = memdup_user_nul(ubuf, count);
> > +		if (IS_ERR(kbuf)) {
> > +			error = PTR_ERR(kbuf);
> > +			goto out;
> > +		}
> > +	} else {
> > +		error = -ENOMEM;
> > +		kbuf = kzalloc(count, GFP_KERNEL);
> 
> Better allocate count + 1 bytes here, that way a lot of insanity in the
> instances can be simply converted to snprintf().  Yes, I know it'll bring
> the Church Of Avoiding The Abomination Of Sprintf out of the woodwork,
> but...

FWIW, consider e.g. net/sunrpc/sysctl.c:

Nevermind that the read side should be simply
		int err = proc_douintvec(table, write, buffer, lenp, ppos);
		/* Display the RPC tasks on writing to rpc_debug */
		if (!err && strcmp(table->procname, "rpc_debug") == 0)
			rpc_show_tasks(&init_net);
		return err;
the write side would become
		len = snprintf(buffer, *lenp + 1, "0x%04x\n",
				*(unsigned int *)table->data);
		if (len > *lenp)
			len = *lenp;
		*lenp -= len;
		*ppos += len;
		return 0;
and I really wonder if lifting the trailing boilerplate into the caller would've
been better.  Note that e.g. gems like
                        if (!first)
                                err = proc_put_char(&buffer, &left, '\t');
                        if (err)
                                break;
                        err = proc_put_long(&buffer, &left, lval, neg);
                        if (err)
                                break;
are due to lack of snprintf-to-user; now, lose the "to user" part and we suddenly
can be rid of that stuff...
