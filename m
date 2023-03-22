Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411986C503E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCVQKz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Mar 2023 12:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCVQKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:10:53 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB30423A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:10:50 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-FYxpBSrTMNKzVMjk9xlfLQ-1; Wed, 22 Mar 2023 12:10:30 -0400
X-MC-Unique: FYxpBSrTMNKzVMjk9xlfLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 854F7101A552;
        Wed, 22 Mar 2023 16:10:28 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EA29202701E;
        Wed, 22 Mar 2023 16:10:26 +0000 (UTC)
Date:   Wed, 22 Mar 2023 17:10:25 +0100
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
Message-ID: <ZBsocdkUBlEuAU+I@hog>
References: <Y+0Wjrc9shLkH+Gg@hog>
 <20230215111020.0c843384@kernel.org>
 <Y+1pX/vL8t2nU00c@hog>
 <20230215195748.23a6da87@kernel.org>
 <Y+5Yd/8tjCQNOF31@hog>
 <20230221191944.4d162ec7@kernel.org>
 <Y/eT/M+b6jUtTdng@hog>
 <20230223092945.435b10ea@kernel.org>
 <ZA9EMJgoNsxfOhwV@hog>
 <20230313113510.02c107b3@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230313113510.02c107b3@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=1.9 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-13, 11:35:10 -0700, Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 16:41:36 +0100 Sabrina Dubroca wrote:
> > > > Yes, I was looking into that earlier this week. I think we could reuse
> > > > a similar mechanism for rekeying. tls_dev_add takes tcp_sk->write_seq,
> > > > we could have a tls_dev_rekey op passing the new key and new write_seq
> > > > to the driver. I think we can also reuse the ->eor trick from
> > > > tls_set_device_offload, and we wouldn't have to look at
> > > > skb->decrypted. Close and push the current SW record, mark ->eor, pass
> > > > write_seq to the driver along with the key. Also pretty close to what
> > > > tls_device_resync_tx does.  
> > > 
> > > That sounds like you'd expose the rekeying logic to the drivers?
> > > New op, having to track seq#...  
> > 
> > Well, we have to call into the drivers to install the key, whether
> > that's a new rekey op, or adding an update argument to ->tls_dev_add,
> > or letting the driver guess that it's a rekey (or ignore that and just
> > install the key if rekey vs initial key isn't a meaningful
> > distinction).
> > 
> > We already feed drivers the seq# with ->tls_dev_add, so passing it for
> > rekeys as well is not a big change.
> > 
> > Does that seem problematic? Adding a rekey op seemed more natural to
> > me than simply using the existing _del + _add ops, but maybe we can
> > get away with just using those two ops.
> 
> Theoretically a rekey op is nicer and cleaner. Practically the quality
> of the driver implementations will vary wildly*, and it's a significant
> time investment to review all of them. So for non-technical reasons my
> intuition is that we'd deliver a better overall user experience if we
> handled the rekey entirely in the core.
> 
> Wait for old key to no longer be needed, _del + _add, start using the
> offload again.
> 
> * One vendor submitted a driver claiming support for TLS 1.3, when 
>   TLS 1.3 offload was rejected by the core. So this is the level of
>   testing and diligence we're working with :(

:(

Ok, _del + _add then.


I went over the thread to summarize what we've come up with so far:

RX
 - The existing SW path will handle all records between the KeyUpdate
   message signaling the change of key and the new key becoming known
   to the kernel -- those will be queued encrypted, and decrypted in
   SW as they are read by userspace (once the key is provided, ie same
   as this patchset)
 - Call ->tls_dev_del + ->tls_dev_add immediately during
   setsockopt(TLS_RX)

TX
 - After setsockopt(TLS_TX), switch to the existing SW path (not the
   current device_fallback) until we're able to re-enable HW offload
   - tls_device_{sendmsg,sendpage} will call into
     tls_sw_{sendmsg,sendpage} under lock_sock to avoid changing
     socket ops during the rekey while another thread might be waiting
     on the lock
 - We only re-enable HW offload (call ->tls_dev_add to install the new
   key in HW) once all records sent with the old key have been
   ACKed. At this point, all unacked records are SW-encrypted with the
   new key, and the old key is unused by both HW and retransmissions.
   - If there are no unacked records when userspace does
     setsockopt(TLS_TX), we can (try to) install the new key in HW
     immediately.
   - If yet another key has been provided via setsockopt(TLS_TX), we
     don't install intermediate keys, only the latest.
   - TCP notifies ktls of ACKs via the icsk_clean_acked callback. In
     case of a rekey, tls_icsk_clean_acked will record when all data
     sent with the most recent past key has been sent. The next call
     to sendmsg/sendpage will install the new key in HW.
   - We close and push the current SW record before reenabling
     offload.

If ->tls_dev_add fails to install the new key in HW, we stay in SW
mode. We can add a counter to keep track of this.


In addition:

Because we can't change socket ops during a rekey, we'll also have to
modify do_tls_setsockopt_conf to check ctx->tx_conf and only call
either tls_set_device_offload or tls_set_sw_offload. RX already uses
the same ops for both TLS_HW and TLS_SW, so we could switch between HW
and SW mode on rekey.

An alternative would be to have a common sendmsg/sendpage which locks
the socket and then calls the correct implementation. We'll need that
anyway for the offload under rekey case, so that would only add a test
to the SW path's ops (compared to the current code). That should allow
us to make build_protos a lot simpler.

-- 
Sabrina

