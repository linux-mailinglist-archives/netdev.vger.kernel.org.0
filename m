Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F3C27B6DF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 23:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgI1VNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 17:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1VNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 17:13:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDEE2083B;
        Mon, 28 Sep 2020 21:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327612;
        bh=NdK4ja5cL/3pPL+J/e4v/Bt4G2gbx5hSAWvRpS5EixM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MeC2Iqkj+Ic6c8sekVflIZfzb8PDhbZWMAD8GI2zfqUJTYZn3q0pgs1SuPAq1/k2m
         aIG8HHTVhKNhOYoOS6pLMZHjqUK/HOwBBEyVD2gVxuCxv5eso0xdOUhVdMkO3qqOcT
         2XoxWngFvBl4eT9nnHWlibILmMWXrWneAlkTLF8c=
Date:   Mon, 28 Sep 2020 14:13:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vakul.garg@nxp.com, secdev <secdev@chelsio.com>
Subject: Re: [PATCH net] net/tls: sendfile fails with ktls offload
Message-ID: <20200928141330.54f06deb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <439f7a6f-fdbd-8c6e-129d-c25f803e3e5e@chelsio.com>
References: <20200925165235.5dba5d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b7afc12f-92a5-c2a9-087e-b826eb74194f@chelsio.com>
        <439f7a6f-fdbd-8c6e-129d-c25f803e3e5e@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Sep 2020 00:13:31 +0530 rohit maheshwari wrote:
> >> > Also shouldn't we update this field or destroy the record before   
> >> the break on line 478? If more is set, and payload is lesser than the 
> >> max size, then we need to
> >> hold on to get next sendpage and continue adding frags in the same 
> >> record.
> >> So I don't think we need to do any update or destroy the record. Please
> >> correct me if I am wrong here.  
> >
> > Agreed, if more is set we should continue appending.
> >
> > What I'm saying is that we may exit the loop on line 478 or 525 without
> > updating pending_open_record_frags. So if pending_open_record_frags is
> > set, we'd be in a position where there is no data in the record, yet
> > pending_open_record_frags is set. Won't subsequent cmsg send not cause 
> > a zero length record to be generated?
> > Exit on line 478 can get triggered if sk_page_frag_refill() fails, and 
> > then by  
> Exit on line 478 can get triggered if sk_page_frag_refill() fails,
> and then by exiting, it will hit line 529 and will return 'rc =
> orig_size - size', so I am sure we don't need to do anything else
> there. 

What makes sure pending_open_record_frags is up to date on that exit
path?

> Exit on line 525 will be, due to do_tcp_sendpage(), and I
> think pending_open_record_frags won't be set if this is the last
> record. And if it is not the last record, do_tcp_sendpage will be
> failing for a complete and correct record, that doesn't need to be
> destroyed and at this very moment pending_open_record_frags
> will suggest that there is more data (unrelated to current failing
> record), which actually is correct.

pending_open_record_frags does not mean more was set on previous call. 
It means there is an open record that needs to be closed in case cmsg
needs to be sent.

> I think, there won't be cmsg if pending_open_record_frags is set.

cmsg comes from user space, what do you mean there won't be cmsg?
