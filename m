Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4E625842B
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 00:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgHaWnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 18:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgHaWnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 18:43:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E611B2083E;
        Mon, 31 Aug 2020 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598913801;
        bh=VxxiRYXm+BENu1Z1XNO+sHkQKJeMPfKFsWemYOVo92I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SEyqQGr/GAa+EiQiKi267EyEAQ3ZYaZww0hwaZCB4cKiSZUhZ/0R6HZfakIJ2qn6n
         7gHgfC4BGreos32hmlsuJwnqDV/iZQ3vIuTt8KcSHPNDYBbNArGXqDvrLlxls7ol9o
         akLRj6wTZmZvmPu3SeiUH6vhBOZCXOLzuUP2gDDE=
Date:   Mon, 31 Aug 2020 15:43:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, yhs@fb.com,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf] bpf: refer to struct xdp_md in user space comments
Message-ID: <20200831154319.71a83484@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ec62c928-429d-8bea-13ec-5c7744ebf121@iogearbox.net>
References: <20200819192723.838228-1-kuba@kernel.org>
        <ec62c928-429d-8bea-13ec-5c7744ebf121@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 16:16:47 +0200 Daniel Borkmann wrote:
> On 8/19/20 9:27 PM, Jakub Kicinski wrote:
> > uAPI uses xdp_md, not xdp_buff. Fix comments.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >   include/uapi/linux/bpf.h | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 0480f893facd..cc3553a102d0 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1554,7 +1554,7 @@ union bpf_attr {  
> 
> Needs also tooling header copy, but once that is done, it needs fixup for libbpf:
> 
> [root@pc-9 bpf]# make
>    GEN      bpf_helper_defs.h
> Unrecognized type 'struct xdp_md', please add it to known types!
> make[1]: *** [Makefile:186: bpf_helper_defs.h] Error 1
> make[1]: *** Deleting file 'bpf_helper_defs.h'
> make: *** [Makefile:160: all] Error 2
> [root@pc-9 bpf]#
> 
> Pls fix up and send v2, thanks.

FWIW upon closer inspection it appears that this is intentional
(even if confusing) and bpf_helpers_doc.py swaps the types to 
__sk_buff and xdp_md when generating man pages and the header.
