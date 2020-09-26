Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F758279BEE
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 20:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgIZSnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 14:43:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:30433 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgIZSnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 14:43:42 -0400
Received: from [10.193.177.145] (ashwini.asicdesigners.com [10.193.177.145] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 08QIhWCq000338;
        Sat, 26 Sep 2020 11:43:33 -0700
Subject: Re: Re: [PATCH net] net/tls: sendfile fails with ktls offload
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200925165235.5dba5d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b7afc12f-92a5-c2a9-087e-b826eb74194f@chelsio.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Cc:     vakul.garg@nxp.com, secdev <secdev@chelsio.com>
Message-ID: <439f7a6f-fdbd-8c6e-129d-c25f803e3e5e@chelsio.com>
Date:   Sun, 27 Sep 2020 00:13:31 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <b7afc12f-92a5-c2a9-087e-b826eb74194f@chelsio.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> > -----Original Message-----
>> > From: Jakub Kicinski <kuba@kernel.org>
>> > Sent: Friday, September 25, 2020 3:27 AM
>> > To: Rohit Maheshwari <rohitm@chelsio.com>
>> > Cc: netdev@vger.kernel.org; davem@davemloft.net; 
>> vakul.garg@nxp.com; secdev <secdev@chelsio.com>
>> > Subject: Re: [PATCH net] net/tls: sendfile fails with ktls offload
>> >
>
>> > Also shouldn't we update this field or destroy the record before 
>> the break on line 478? If more is set, and payload is lesser than the 
>> max size, then we need to
>> hold on to get next sendpage and continue adding frags in the same 
>> record.
>> So I don't think we need to do any update or destroy the record. Please
>> correct me if I am wrong here.
>
> Agreed, if more is set we should continue appending.
>
> What I'm saying is that we may exit the loop on line 478 or 525 without
> updating pending_open_record_frags. So if pending_open_record_frags is
> set, we'd be in a position where there is no data in the record, yet
> pending_open_record_frags is set. Won't subsequent cmsg send not cause 
> a zero length record to be generated?
> Exit on line 478 can get triggered if sk_page_frag_refill() fails, and 
> then by
Exit on line 478 can get triggered if sk_page_frag_refill() fails,
and then by exiting, it will hit line 529 and will return 'rc =
orig_size - size', so I am sure we don't need to do anything else
there. Exit on line 525 will be, due to do_tcp_sendpage(), and I
think pending_open_record_frags won't be set if this is the last
record. And if it is not the last record, do_tcp_sendpage will be
failing for a complete and correct record, that doesn't need to be
destroyed and at this very moment pending_open_record_frags
will suggest that there is more data (unrelated to current failing
record), which actually is correct. I think, there won't be cmsg if
pending_open_record_frags is set.
