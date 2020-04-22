Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291291B3739
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 08:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDVGJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 02:09:26 -0400
Received: from verein.lst.de ([213.95.11.211]:50333 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgDVGJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 02:09:26 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 113CA68C4E; Wed, 22 Apr 2020 08:09:23 +0200 (CEST)
Date:   Wed, 22 Apr 2020 08:09:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200422060922.GA22775@lst.de>
References: <20200421171539.288622-1-hch@lst.de> <20200421171539.288622-6-hch@lst.de> <20200421191615.GE23230@ZenIV.linux.org.uk> <20200422024626.GI23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422024626.GI23230@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 03:46:26AM +0100, Al Viro wrote:
> > Better allocate count + 1 bytes here, that way a lot of insanity in the
> > instances can be simply converted to snprintf().  Yes, I know it'll bring
> > the Church Of Avoiding The Abomination Of Sprintf out of the woodwork,
> > but...
> 
> FWIW, consider e.g. net/sunrpc/sysctl.c:
> 
> Nevermind that the read side should be simply
> 		int err = proc_douintvec(table, write, buffer, lenp, ppos);
> 		/* Display the RPC tasks on writing to rpc_debug */
> 		if (!err && strcmp(table->procname, "rpc_debug") == 0)
> 			rpc_show_tasks(&init_net);
> 		return err;
> the write side would become
> 		len = snprintf(buffer, *lenp + 1, "0x%04x\n",
> 				*(unsigned int *)table->data);
> 		if (len > *lenp)
> 			len = *lenp;
> 		*lenp -= len;
> 		*ppos += len;
> 		return 0;
> and I really wonder if lifting the trailing boilerplate into the caller would've
> been better.  Note that e.g. gems like
>                         if (!first)
>                                 err = proc_put_char(&buffer, &left, '\t');
>                         if (err)
>                                 break;
>                         err = proc_put_long(&buffer, &left, lval, neg);
>                         if (err)
>                                 break;
> are due to lack of snprintf-to-user; now, lose the "to user" part and we suddenly
> can be rid of that stuff...

That sounds pretty sensible, but can we do that as an extra step?
That is in merge window N just move to passing kernel pointers, check
for fall out.  In merge window N + 1 start allocatin the extra byte and
switch at least the common helpers for snprintf?
