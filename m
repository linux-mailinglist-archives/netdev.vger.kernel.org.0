Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2A727952A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIYXwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIYXwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:52:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5103B2086A;
        Fri, 25 Sep 2020 23:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601077957;
        bh=SDaHKPEaoOPbZdNx7obJYhdLykIb7flYAjyLRHg2vA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L+Lb9NHfaMJb7DXhUnzcClZUZJ8bPWeHm98xEVJ4BBLXMXmD+GnP6GZV7Z1BU9J54
         OSeZcUIPsU1qKIQCjH+ruRnJ76PqDZSlhUO0sEUF2MK+RsBQiT/gB1nO0M636SA+D7
         COUT3LGATj+Ao0f93mzQqZc0YNhQw35ydlhiyT9M=
Date:   Fri, 25 Sep 2020 16:52:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vakul.garg@nxp.com, secdev <secdev@chelsio.com>
Subject: Re: [PATCH net] net/tls: sendfile fails with ktls offload
Message-ID: <20200925165235.5dba5d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d0ff72b0-6d1f-d71e-5fe6-3b145fefacc5@chelsio.com>
References: <20200924075025.11626-1-rohitm@chelsio.com>
        <20200924145714.761f7c6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB40041504C9BB0C49546C9CE6EE360@BY5PR12MB4004.namprd12.prod.outlook.com>
        <d0ff72b0-6d1f-d71e-5fe6-3b145fefacc5@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 19:32:23 +0530 rohit maheshwari wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, September 25, 2020 3:27 AM
> > To: Rohit Maheshwari <rohitm@chelsio.com>
> > Cc: netdev@vger.kernel.org; davem@davemloft.net; vakul.garg@nxp.com; secdev <secdev@chelsio.com>
> > Subject: Re: [PATCH net] net/tls: sendfile fails with ktls offload
> >
> > On Thu, 24 Sep 2020 13:20:25 +0530 Rohit Maheshwari wrote:  
> >> At first when sendpage gets called, if there is more data, 'more' in
> >> tls_push_data() gets set which later sets pending_open_record_frags,
> >> but when there is no more data in file left, and last time
> >> tls_push_data() gets called, pending_open_record_frags doesn't get
> >> reset. And later when
> >> 2 bytes of encrypted alert comes as sendmsg, it first checks for
> >> pending_open_record_frags, and since this is set, it creates a record
> >> with
> >> 0 data bytes to encrypt, meaning record length is prepend_size +
> >> tag_size only, which causes problem.  
> > Agreed, looks like the value in pending_open_record_frags may be stale.
> >  
> >>   We should set/reset pending_open_record_frags based on more bit.  
> > I think you implementation happens to work because there is always left over data when more is set, but I don't think that has to be the case.  
> Yes, with small file size, more bit won't be set, and so the existing code
> works there. If more is not set, which means this should be the overall
> record and so, we can continue putting header and TAG to make it a
> complete record.

Okay.

> > Also shouldn't we update this field or destroy the record before the break on line 478?  
> If more is set, and payload is lesser than the max size, then we need to
> hold on to get next sendpage and continue adding frags in the same record.
> So I don't think we need to do any update or destroy the record. Please
> correct me if I am wrong here.

Agreed, if more is set we should continue appending.

What I'm saying is that we may exit the loop on line 478 or 525 without
updating pending_open_record_frags. So if pending_open_record_frags is
set, we'd be in a position where there is no data in the record, yet
pending_open_record_frags is set. Won't subsequent cmsg send not cause 
a zero length record to be generated?

> >> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> >> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> >> ---
> >>   net/tls/tls_device.c | 8 ++++----
> >>   1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c index
> >> b74e2741f74f..a02aadefd86e 100644
> >> --- a/net/tls/tls_device.c
> >> +++ b/net/tls/tls_device.c
> >> @@ -492,11 +492,11 @@ static int tls_push_data(struct sock *sk,
> >>   		if (!size) {
> >>   last_record:
> >>   			tls_push_record_flags = flags;
> >> -			if (more) {
> >> -				tls_ctx->pending_open_record_frags =
> >> -						!!record->num_frags;
> >> +			/* set/clear pending_open_record_frags based on more */
> >> +			tls_ctx->pending_open_record_frags = !!more;
> >> +
> >> +			if (more)
> >>   				break;
> >> -			}
> >>   
> >>   			done = true;
> >>   		}  

