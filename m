Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678C427F69C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731920AbgJAAXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbgJAAXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:23:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC98207C3;
        Thu,  1 Oct 2020 00:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601511799;
        bh=9X+sefQzFiSlAEN0zzWdHv+avSLNE0rhxGEoXFNvSbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bnSWxJsGl5qF9+/9GpIEcr1YXoLwnqZMb/K3yUOMw/ZYkJAn58awxhfgw7gW+Zezh
         0dyqkojQXJZZPLRAt+IFSvv9MCgaUpO8oLiOA4yQKMMVP2ihSPk6bepg1szXOxQ1m9
         VJhgf4O8T01gDfrzCjlpGMB18IuKBGkNeMi6VYbE=
Date:   Wed, 30 Sep 2020 17:23:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Michal Kubecek <mkubecek@suse.cz>, dsahern@kernel.org,
        pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930172317.48f85a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930233817.GA3996795@lunn.ch>
References: <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
        <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
        <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
        <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
        <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
        <20200930134734.27bba000@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200930233817.GA3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 01:38:17 +0200 Andrew Lunn wrote:
> > > > +static void genl_op_from_full(const struct genl_family *family,
> > > > +			      unsigned int i, struct genl_ops *op)
> > > > +{
> > > > +	memcpy(op, &family->ops[i], sizeof(*op));    
> > > 
> > > What's wrong with struct assignment? :)
> > > 
> > > 	*op = family->ops[i];  
> > 
> > Code size :)
> > 
> >    text	   data	    bss	    dec	    hex
> >   22657	   3590	     64	  26311	   66c7	memcpy
> >   23103	   3590	     64	  26757	   6885	struct  
> 
> You might want to show that to the compiler people. Did you look at
> the assembly?

Somewhere along the line I lost the ability to decipher compiler code :(

Two snippets follow (both with -Os to prevent inlining)

Assignment:

static void genl_op_from_full(const struct genl_family *family,
                              unsigned int i, struct genl_ops *op)
{
       0:       e8 00 00 00 00          callq  5 <genl_op_from_full+0x5>
       5:       41 54                   push   %r12
       7:       49 89 d4                mov    %rdx,%r12
       a:       55                      push   %rbp
       b:       89 f5                   mov    %esi,%ebp
       d:       53                      push   %rbx
       e:       48 89 fb                mov    %rdi,%rbx
        *op = family->ops[i];
      11:       48 6b ed 30             imul   $0x30,%rbp,%rbp
      15:       48 83 c7 40             add    $0x40,%rdi
      19:       e8 00 00 00 00          callq  1e <genl_op_from_full+0x1e>
      1e:       48 03 6b 40             add    0x40(%rbx),%rbp
      22:       be 30 00 00 00          mov    $0x30,%esi
      27:       4c 89 e7                mov    %r12,%rdi
      2a:       e8 00 00 00 00          callq  2f <genl_op_from_full+0x2f>
      2f:       be 30 00 00 00          mov    $0x30,%esi
      34:       48 89 ef                mov    %rbp,%rdi
      37:       e8 00 00 00 00          callq  3c <genl_op_from_full+0x3c>
      3c:       b9 0c 00 00 00          mov    $0xc,%ecx
      41:       4c 89 e7                mov    %r12,%rdi
      44:       48 89 ee                mov    %rbp,%rsi
      47:       f3 a5                   rep movsl %ds:(%rsi),%es:(%rdi)

        if (!op->maxattr)
      49:       49 8d 7c 24 28          lea    0x28(%r12),%rdi
      4e:       e8 00 00 00 00          callq  53 <genl_op_from_full+0x53>
      53:       41 83 7c 24 28 00       cmpl   $0x0,0x28(%r12)
      59:       75 11                   jne    6c <genl_op_from_full+0x6c>
                op->maxattr = family->maxattr;
      5b:       48 8d 7b 1c             lea    0x1c(%rbx),%rdi
      5f:       e8 00 00 00 00          callq  64 <genl_op_from_full+0x64>
      64:       8b 43 1c                mov    0x1c(%rbx),%eax
      67:       41 89 44 24 28          mov    %eax,0x28(%r12)


Memcpy:

00000000000001a2 <genl_op_from_full>:
{
     1a2:       e8 00 00 00 00          callq  1a7 <genl_op_from_full+0x5>
     1a7:       41 54                   push   %r12
     1a9:       49 89 fc                mov    %rdi,%r12
        memcpy(op, &family->ops[i], sizeof(*op));
     1ac:       48 83 c7 40             add    $0x40,%rdi
{
     1b0:       55                      push   %rbp
     1b1:       89 f5                   mov    %esi,%ebp
     1b3:       53                      push   %rbx
     1b4:       48 89 d3                mov    %rdx,%rbx
        memcpy(op, &family->ops[i], sizeof(*op));
     1b7:       e8 00 00 00 00          callq  1bc <genl_op_from_full+0x1a>
     1bc:       89 ee                   mov    %ebp,%esi
                if (q_size < size)
                        __read_overflow2();
        }
        if (p_size < size || q_size < size)
                fortify_panic(__func__);
        return __underlying_memcpy(p, q, size);
     1be:       ba 30 00 00 00          mov    $0x30,%edx
     1c3:       48 89 df                mov    %rbx,%rdi
     1c6:       48 6b f6 30             imul   $0x30,%rsi,%rsi
     1ca:       49 03 74 24 40          add    0x40(%r12),%rsi
     1cf:       e8 00 00 00 00          callq  1d4 <genl_op_from_full+0x32>
        if (!op->maxattr)
     1d4:       48 8d 7b 28             lea    0x28(%rbx),%rdi
     1d8:       e8 00 00 00 00          callq  1dd <genl_op_from_full+0x3b>
     1dd:       83 7b 28 00             cmpl   $0x0,0x28(%rbx)
     1e1:       75 12                   jne    1f5 <genl_op_from_full+0x53>
