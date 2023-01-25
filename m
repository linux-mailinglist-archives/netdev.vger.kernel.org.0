Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AEA67B9DC
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbjAYStU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjAYStT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:49:19 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A985C0C9
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674672513; x=1706208513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DET3pARmIV3rVzDHxHvuWUhaq6bg47aPC0wu3p6AX6Q=;
  b=BuPYy5km29a6i6sYO78k1JVWauVRAntnLyvw9aq5kDVWW7Hozkil8ORC
   rnrL+zQiMh42ZnIxQBL9aQKcp0IJXgCj+Y2XrH4nFn7BvdywOQxiYlEoB
   SplNskFicA8VqCPYSz+HNNifAmX4JeZAMJGZ9ERmk7PJhxigbcZLN5bJF
   4=;
X-IronPort-AV: E=Sophos;i="5.97,246,1669075200"; 
   d="scan'208";a="292204366"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 18:47:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id D2A9181B37;
        Wed, 25 Jan 2023 18:47:27 +0000 (UTC)
Received: from EX19D030UWB003.ant.amazon.com (10.13.139.142) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 25 Jan 2023 18:47:26 +0000
Received: from bcd0741e4041.ant.amazon.com (10.43.161.198) by
 EX19D030UWB003.ant.amazon.com (10.13.139.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Wed, 25 Jan 2023 18:47:26 +0000
From:   Apoorv Kothari <apoorvko@amazon.com>
To:     <sd@queasysnail.net>
CC:     <borisp@nvidia.com>, <dueno@redhat.com>, <fkrenzel@redhat.com>,
        <gal@nvidia.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <simo@redhat.com>, <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Date:   Wed, 25 Jan 2023 10:47:20 -0800
Message-ID: <20230125184720.56498-1-apoorvko@amazon.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <Y8//pypyM3HAu+cf@hog>
References: <Y8//pypyM3HAu+cf@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D40UWA003.ant.amazon.com (10.43.160.29) To
 EX19D030UWB003.ant.amazon.com (10.13.139.142)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 2023-01-23, 10:13:58 +0000, Boris Pismenny wrote:
> > On 19/01/2023 10:27, Gal Pressman wrote:
> > > On 19/01/2023 4:55, Jakub Kicinski wrote:
> > >> On Wed, 18 Jan 2023 11:06:25 +0100 Sabrina Dubroca wrote:
> > >>> 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
> > >>>> On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:  
> > >>>>> This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> > >>>>> [1]). A sender transmits a KeyUpdate message and then changes its TX
> > >>>>> key. The receiver should react by updating its RX key before
> > >>>>> processing the next message.
> > >>>>>
> > >>>>> This patchset implements key updates by:
> > >>>>>  1. pausing decryption when a KeyUpdate message is received, to avoid
> > >>>>>     attempting to use the old key to decrypt a record encrypted with
> > >>>>>     the new key
> > >>>>>  2. returning -EKEYEXPIRED to syscalls that cannot receive the
> > >>>>>     KeyUpdate message, until the rekey has been performed by userspace  
> > >>>>
> > >>>> Why? We return to user space after hitting a cmsg, don't we?
> > >>>> If the user space wants to keep reading with the old key - 🤷️  
> > >>>
> > >>> But they won't be able to read anything. Either we don't pause
> > >>> decryption, and the socket is just broken when we look at the next
> > >>> record, or we pause, and there's nothing to read until the rekey is
> > >>> done. I think that -EKEYEXPIRED is better than breaking the socket
> > >>> just because a read snuck in between getting the cmsg and setting the
> > >>> new key.
> > >>
> > >> IDK, we don't interpret any other content types/cmsgs, and for well
> > >> behaved user space there should be no problem (right?).
> > >> I'm weakly against, if nobody agrees with me you can keep as is.
> > >>
> > >>>>>  3. passing the KeyUpdate message to userspace as a control message
> > >>>>>  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
> > >>>>>     setsockopts
> > >>>>>
> > >>>>> This API has been tested with gnutls to make sure that it allows
> > >>>>> userspace libraries to implement key updates [2]. Thanks to Frantisek
> > >>>>> Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> > >>>>> gnutls and testing the kernel patches.  
> > >>>>
> > >>>> Please explain why - the kernel TLS is not faster than user space, 
> > >>>> the point of it is primarily to enable offload. And you don't add
> > >>>> offload support here.  
> > >>>
> > >>> Well, TLS1.3 support was added 4 years ago, and yet the offload still
> > >>> doesn't support 1.3 at all.
> > >>
> > >> I'm pretty sure some devices support it. None of the vendors could 
> > >> be bothered to plumb in the kernel support, yet, tho.
> > > 
> > > Our device supports TLS 1.3, it's in our plans to add driver/kernel support.
> > > 
> > >> I don't know of anyone supporting rekeying.
> > > 
> > > Boris, Tariq, do you know?
> > 
> > Rekeying is not trivial to get right with offload. There are at least
> > two problems to solve:
> > 1. On transmit, we need to handle both the new and the old key for new
> > and old (retransmitted) data, respectively. Our device will be able to
> > hold both keys in parallel and to choose the right one at the cost of an
> > if statement in the data-path. Alternatively, we can just fallback to
> > software for the old key and focus on the new key.
> 
> We'll need to keep the old key around until we know all the records
> using it have been fully received, right?  And that could be multiple
> old keys, in case of a quick series of key updates.

Why does the hardware implementation need to store old keys? Does the need
for retransmitted data assume we are operating in TLS_HW_RECORD mode and
the hardware is also implementing the TCP stack?

The TLS RFC assumes that the underlying transport layer provides reliable
and in-order deliver so storing previous keys and encrypting 'old' data
would be quite divergent from normal TLS behavior. Is the TLS_HW_RECORD mode
processing TLS records out of order? If the hardware offload is handling
the TCP networking stack then I feel it should also handle the
retransmission of lost data.

   https://www.rfc-editor.org/rfc/rfc8446#section-1
   the only requirement from the underlying
   transport is a reliable, in-order data stream.

> > 2. On Rx, packets with the new key may arrive before the key is
> > installed unless we design a mechanism for preemptively setting the next
> > key in HW. As a result, we may get a resync on every rekey.
> > 
> > Have you considered an API to preemptively set the next key in the
> > kernel such that there is never a need to stop the datapath? I think
> > that the change in SSL libraries is minor and it can really help KTLS.
> 
> I don't like the idea of having some unused key stored in the kernel
> for long durations too much.
> 
> You can't be sure that there will be only one rekey in the next short
> interval, so you'll need to be able to handle those resyncs anyway, in
> case userspace is too slow providing the 3rd key (for the 2nd
> rekey). For example, the RFC mentions:
> 
>    If implementations independently send their own KeyUpdates with
>    request_update set to "update_requested" and they cross in flight,
>    then each side will also send a response, with the result that each
>    side increments by two generations.
> 
>    https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3
> 
> So I think what you're suggesting can only be an optimization,
> not a full solution.
> 
> I hope I'm not getting too confused by all this.

-- 
Apoorv
