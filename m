Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169086B7C3A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCMPmD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Mar 2023 11:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjCMPmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:42:01 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248CA37F0D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:41:58 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-cZ6hFkaTPp2gw_6VnXUfeA-1; Mon, 13 Mar 2023 11:41:41 -0400
X-MC-Unique: cZ6hFkaTPp2gw_6VnXUfeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 455781C08789;
        Mon, 13 Mar 2023 15:41:40 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 41CD6406AA66;
        Mon, 13 Mar 2023 15:41:38 +0000 (UTC)
Date:   Mon, 13 Mar 2023 16:41:36 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <ZA9EMJgoNsxfOhwV@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
 <20230214210811.448b5ec4@kernel.org>
 <Y+0Wjrc9shLkH+Gg@hog>
 <20230215111020.0c843384@kernel.org>
 <Y+1pX/vL8t2nU00c@hog>
 <20230215195748.23a6da87@kernel.org>
 <Y+5Yd/8tjCQNOF31@hog>
 <20230221191944.4d162ec7@kernel.org>
 <Y/eT/M+b6jUtTdng@hog>
 <20230223092945.435b10ea@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230223092945.435b10ea@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-23, 09:29:45 -0800, Jakub Kicinski wrote:
> On Thu, 23 Feb 2023 17:27:40 +0100 Sabrina Dubroca wrote:
> > Installing the key in HW and re-enabling the offload will need to
> > happen via the icsk_clean_acked callback. We'll need a workqueue so
> > that we don't actually talk to the driver from softirq.
> 
> Installing from icsk_clean_acked won't win us anything, right?
> We'll only need the key once the next sendmsg() comes, what's
> pushed to TCP with swenc is already out of our hands.

Avoiding an unpredictable slowdown on the sendmsg() call? We can deal
with that later if it turns out to be an issue. I simply didn't think
of deferring to the next sendmsg().

> > Then, we have to handle a failure to install the key. Since we're not
> > installing it in HW immediately during setsockopt, notifying userspace
> > of a rekey failure is more complicated. Maybe we can do a
> > rekey_prepare during the setsocktopt, and then the actual rekey is an
> > operation that cannot fail?
> 
> TLS offload silently falls back to SW on any errors. So that's fine.
> Just bump a counter. User/infra must be tracking error counters in 
> our current design already.

True. User might be a bit surprised by "well it was offloaded and now
it's not", but ok.

> > > Important consideration is making the non-rekey path as fast as
> > > possible (given rekeying is extremely rare). Looking at skb->decrypted
> > > should be very fast but we can possibly fit some other indication of
> > > "are we rekeying" into another already referenced cache line.
> > > We definitely don't want to have to look up the record to know what
> > > state we're in.
> > > 
> > > The fallback can't use AES-NI (it's in sirq context) so it's slower 
> > > than SW encrypt before queuing to TCP. Hence my first thought is using
> > > SW crypto for new key and let the traffic we already queued with old
> > > key drain leveraging HW crypto. But as I said the impact on performance
> > > when not rekeying is more important, and so is driver simplicity.  
> > 
> > Right, sorry, full tls_sw path and not the existing fallback.
> > 
> > Changing the socket ops back and forth between the HW and SW variants
> > worries me, because we only lock the socket once we have entered
> > tls_{device,sw}_sendmsg. So I think we have to stay on the _device ops
> > even during the SW crypto phase of the rekey, and let that call into
> > the SW variant after locking the socket and making sure we're in a
> > rekey.
> 
> Fair point :S
> 
> > > > Don't we have that already? If there's a retransmit while we're
> > > > setting the TX key in HW, data that was queued on the socket before
> > > > (and shouldn't be encrypted at all) would also be encrypted
> > > > otherwise. Or is it different with rekey?  
> > > 
> > > We have a "start marker" record which is supposed to indicate that
> > > anything before it has already been encrypted. The driver is programmed
> > > with the start seq no, when it sees a packet from before this seq no
> > > it checks if a record exists, finds its before the start marker and
> > > sends the data as is.  
> > 
> > Yes, I was looking into that earlier this week. I think we could reuse
> > a similar mechanism for rekeying. tls_dev_add takes tcp_sk->write_seq,
> > we could have a tls_dev_rekey op passing the new key and new write_seq
> > to the driver. I think we can also reuse the ->eor trick from
> > tls_set_device_offload, and we wouldn't have to look at
> > skb->decrypted. Close and push the current SW record, mark ->eor, pass
> > write_seq to the driver along with the key. Also pretty close to what
> > tls_device_resync_tx does.
> 
> That sounds like you'd expose the rekeying logic to the drivers?
> New op, having to track seq#...

Well, we have to call into the drivers to install the key, whether
that's a new rekey op, or adding an update argument to ->tls_dev_add,
or letting the driver guess that it's a rekey (or ignore that and just
install the key if rekey vs initial key isn't a meaningful
distinction).

We already feed drivers the seq# with ->tls_dev_add, so passing it for
rekeys as well is not a big change.

Does that seem problematic? Adding a rekey op seemed more natural to
me than simply using the existing _del + _add ops, but maybe we can
get away with just using those two ops.

-- 
Sabrina

