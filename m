Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2246A0E04
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 17:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbjBWQ2n convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Feb 2023 11:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBWQ2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 11:28:42 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC1F12042
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 08:28:02 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-V-k9s7lBO7WH4bLt11rOrg-1; Thu, 23 Feb 2023 11:27:44 -0500
X-MC-Unique: V-k9s7lBO7WH4bLt11rOrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9993C3806739;
        Thu, 23 Feb 2023 16:27:43 +0000 (UTC)
Received: from hog (unknown [10.39.192.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A05CD404BEC0;
        Thu, 23 Feb 2023 16:27:41 +0000 (UTC)
Date:   Thu, 23 Feb 2023 17:27:40 +0100
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
Message-ID: <Y/eT/M+b6jUtTdng@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
 <20230214210811.448b5ec4@kernel.org>
 <Y+0Wjrc9shLkH+Gg@hog>
 <20230215111020.0c843384@kernel.org>
 <Y+1pX/vL8t2nU00c@hog>
 <20230215195748.23a6da87@kernel.org>
 <Y+5Yd/8tjCQNOF31@hog>
 <20230221191944.4d162ec7@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230221191944.4d162ec7@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-02-21, 19:19:44 -0800, Jakub Kicinski wrote:
> Sorry for the delay, long weekend + merge window.

No worries, I wasn't expecting much activity on this from you during
the merge window.

> On Thu, 16 Feb 2023 17:23:19 +0100 Sabrina Dubroca wrote:
> > 2023-02-15, 19:57:48 -0800, Jakub Kicinski wrote:
> > > I think we could try to switch to SW crypto on Tx until all data using
> > > old key is ACK'ed, drivers can look at skb->decrypted to skip touching
> > > the transitional skbs. Then remove old key, install new one, resume
> > > offload.  
> > 
> > "all data using the old key" needs to be one list of record per old
> > key, since we can have multiple rekeys.
> 
> No fully parsing this bit.

We can have multiple rekeys in the time it takes to get an ACK for the
first KeyUpdate message to be ACK'ed. I'm not sure why I talked about
a "list of records".

But we could have this sequence of records:

  recN(k1,hwenc)
  KeyUpdate(k1,hwenc)
  // switch to k2 and sw crypto

  rec0(k2,swenc)
  rec1(k2,swenc)
  KeyUpdate(k2,swenc)
  rec0(k3,swenc)
  // receive ACK for KU1, don't enable HW offload for k2 or k3 because we've already switched off k2

  rec1(k3,swenc)
  // receive ACK for KU2, now enable HW offload for k3

  rec2(k3,hwenc)

So we'll need to record the most recent TX rekey, and wait until the
corresponding KU record is ACK'ed, before we resume offload using the
most recent key (and skip possible intermediate keys).

Installing the key in HW and re-enabling the offload will need to
happen via the icsk_clean_acked callback. We'll need a workqueue so
that we don't actually talk to the driver from softirq.

Then, we have to handle a failure to install the key. Since we're not
installing it in HW immediately during setsockopt, notifying userspace
of a rekey failure is more complicated. Maybe we can do a
rekey_prepare during the setsocktopt, and then the actual rekey is an
operation that cannot fail?

> > Could we install the new key in HW a bit earlier? Keep the old key as
> > SW fallback for rtx, but the driver installs the new key when the
> > corresponding KeyUpdate record has gone through and tells the stack to
> > stop doing SW crypto? I'm not sure that'd be a significant improvement
> > in the standard case, though.
> 
> Important consideration is making the non-rekey path as fast as
> possible (given rekeying is extremely rare). Looking at skb->decrypted
> should be very fast but we can possibly fit some other indication of
> "are we rekeying" into another already referenced cache line.
> We definitely don't want to have to look up the record to know what
> state we're in.
> 
> The fallback can't use AES-NI (it's in sirq context) so it's slower 
> than SW encrypt before queuing to TCP. Hence my first thought is using
> SW crypto for new key and let the traffic we already queued with old
> key drain leveraging HW crypto. But as I said the impact on performance
> when not rekeying is more important, and so is driver simplicity.

Right, sorry, full tls_sw path and not the existing fallback.

Changing the socket ops back and forth between the HW and SW variants
worries me, because we only lock the socket once we have entered
tls_{device,sw}_sendmsg. So I think we have to stay on the _device ops
even during the SW crypto phase of the rekey, and let that call into
the SW variant after locking the socket and making sure we're in a
rekey.

> > > We may need special care to make sure we don't try to encrypt the same
> > > packet with both keys. In case a rtx gets stuck somewhere and comes to
> > > the NIC after it's already acked (happens surprisingly often).  
> > 
> > Don't we have that already? If there's a retransmit while we're
> > setting the TX key in HW, data that was queued on the socket before
> > (and shouldn't be encrypted at all) would also be encrypted
> > otherwise. Or is it different with rekey?
> 
> We have a "start marker" record which is supposed to indicate that
> anything before it has already been encrypted. The driver is programmed
> with the start seq no, when it sees a packet from before this seq no
> it checks if a record exists, finds its before the start marker and
> sends the data as is.

Yes, I was looking into that earlier this week. I think we could reuse
a similar mechanism for rekeying. tls_dev_add takes tcp_sk->write_seq,
we could have a tls_dev_rekey op passing the new key and new write_seq
to the driver. I think we can also reuse the ->eor trick from
tls_set_device_offload, and we wouldn't have to look at
skb->decrypted. Close and push the current SW record, mark ->eor, pass
write_seq to the driver along with the key. Also pretty close to what
tls_device_resync_tx does.

[...]
> > This makes me wonder again if we should have fake offloads on veth
> > (still calling the kernel's crypto library to simulate a device doing
> > the encryption and/or decryption), to make it easy to play with the
> > software bits, without requiring actual hardware that can offload
> > TLS/IPsec/MACsec. But maybe it's too complex to be useful and we'd
> > just waste our time fixing bugs in the fake offload rather than
> > improving the stack.
> 
> It should be quite useful. I also usually just hack up veth, but 
> I reckon adding support to netdevsim would be a better fit.
> We just need a way to tell two netdevsim ports to "connect to each
> other".

Oh, nice idea. I'll add that to my todo list.

-- 
Sabrina

