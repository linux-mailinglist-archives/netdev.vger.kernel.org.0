Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235936A0EB9
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 18:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbjBWR3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 12:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjBWR3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 12:29:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A7A2C669;
        Thu, 23 Feb 2023 09:29:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 160FBB80DD0;
        Thu, 23 Feb 2023 17:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EAAC433EF;
        Thu, 23 Feb 2023 17:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677173387;
        bh=VAinlNYqBmi2wED3IdtuGRtOZa+X8lmWcIhQ0ms8vdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NzDFLcBBJFRZqf9X+YQcoho9iq2ivXCMTiwa1gmrpPXMvxKwJbT5F2H9X8ii5z1C+
         BOZ80GDl6MGOiDHhEK5lA7uD7eRQsonunKYxZxvBQxgDj/m7l3inlE9FiHCakUJmSS
         0sNT/5yCoIezqNhz4AfPJqO/NkxJfQs6zLkAiue5korX4P8VqMUJs71eqV78aoyax4
         TeFs/iJeafP04JuoGXz5IkYjVXYrsYXRjPl7v7GIdC7BMP3uhnnVPdLHetVzEWsz1P
         tT/O4gwH7ltAIS4nDoUTZqTjSoSPPjrvAOXQxdN1cMeeP1+xPpf0uS5PEnJ3PtLv6D
         vzHPL6G5HgOig==
Date:   Thu, 23 Feb 2023 09:29:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
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
Message-ID: <20230223092945.435b10ea@kernel.org>
In-Reply-To: <Y/eT/M+b6jUtTdng@hog>
References: <cover.1676052788.git.sd@queasysnail.net>
        <20230214210811.448b5ec4@kernel.org>
        <Y+0Wjrc9shLkH+Gg@hog>
        <20230215111020.0c843384@kernel.org>
        <Y+1pX/vL8t2nU00c@hog>
        <20230215195748.23a6da87@kernel.org>
        <Y+5Yd/8tjCQNOF31@hog>
        <20230221191944.4d162ec7@kernel.org>
        <Y/eT/M+b6jUtTdng@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 17:27:40 +0100 Sabrina Dubroca wrote:
> 2023-02-21, 19:19:44 -0800, Jakub Kicinski wrote:
> > > "all data using the old key" needs to be one list of record per old
> > > key, since we can have multiple rekeys.  
> > 
> > No fully parsing this bit.  
> 
> We can have multiple rekeys in the time it takes to get an ACK for the
> first KeyUpdate message to be ACK'ed. I'm not sure why I talked about
> a "list of records".
> 
> But we could have this sequence of records:
> 
>   recN(k1,hwenc)
>   KeyUpdate(k1,hwenc)
>   // switch to k2 and sw crypto
> 
>   rec0(k2,swenc)
>   rec1(k2,swenc)
>   KeyUpdate(k2,swenc)
>   rec0(k3,swenc)
>   // receive ACK for KU1, don't enable HW offload for k2 or k3 because we've already switched off k2
> 
>   rec1(k3,swenc)
>   // receive ACK for KU2, now enable HW offload for k3
> 
>   rec2(k3,hwenc)
> 
> So we'll need to record the most recent TX rekey, and wait until the
> corresponding KU record is ACK'ed, before we resume offload using the
> most recent key (and skip possible intermediate keys).
> 
> Installing the key in HW and re-enabling the offload will need to
> happen via the icsk_clean_acked callback. We'll need a workqueue so
> that we don't actually talk to the driver from softirq.

Installing from icsk_clean_acked won't win us anything, right?
We'll only need the key once the next sendmsg() comes, what's
pushed to TCP with swenc is already out of our hands.

> Then, we have to handle a failure to install the key. Since we're not
> installing it in HW immediately during setsockopt, notifying userspace
> of a rekey failure is more complicated. Maybe we can do a
> rekey_prepare during the setsocktopt, and then the actual rekey is an
> operation that cannot fail?

TLS offload silently falls back to SW on any errors. So that's fine.
Just bump a counter. User/infra must be tracking error counters in 
our current design already.

> > Important consideration is making the non-rekey path as fast as
> > possible (given rekeying is extremely rare). Looking at skb->decrypted
> > should be very fast but we can possibly fit some other indication of
> > "are we rekeying" into another already referenced cache line.
> > We definitely don't want to have to look up the record to know what
> > state we're in.
> > 
> > The fallback can't use AES-NI (it's in sirq context) so it's slower 
> > than SW encrypt before queuing to TCP. Hence my first thought is using
> > SW crypto for new key and let the traffic we already queued with old
> > key drain leveraging HW crypto. But as I said the impact on performance
> > when not rekeying is more important, and so is driver simplicity.  
> 
> Right, sorry, full tls_sw path and not the existing fallback.
> 
> Changing the socket ops back and forth between the HW and SW variants
> worries me, because we only lock the socket once we have entered
> tls_{device,sw}_sendmsg. So I think we have to stay on the _device ops
> even during the SW crypto phase of the rekey, and let that call into
> the SW variant after locking the socket and making sure we're in a
> rekey.

Fair point :S

> > > Don't we have that already? If there's a retransmit while we're
> > > setting the TX key in HW, data that was queued on the socket before
> > > (and shouldn't be encrypted at all) would also be encrypted
> > > otherwise. Or is it different with rekey?  
> > 
> > We have a "start marker" record which is supposed to indicate that
> > anything before it has already been encrypted. The driver is programmed
> > with the start seq no, when it sees a packet from before this seq no
> > it checks if a record exists, finds its before the start marker and
> > sends the data as is.  
> 
> Yes, I was looking into that earlier this week. I think we could reuse
> a similar mechanism for rekeying. tls_dev_add takes tcp_sk->write_seq,
> we could have a tls_dev_rekey op passing the new key and new write_seq
> to the driver. I think we can also reuse the ->eor trick from
> tls_set_device_offload, and we wouldn't have to look at
> skb->decrypted. Close and push the current SW record, mark ->eor, pass
> write_seq to the driver along with the key. Also pretty close to what
> tls_device_resync_tx does.

That sounds like you'd expose the rekeying logic to the drivers?
New op, having to track seq#...

