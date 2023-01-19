Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380CF6743BA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 21:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjASUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 15:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjASUwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 15:52:12 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3526637F07
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 12:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674161499; x=1705697499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zqsWlGx3ksBvyyfWfF+adPl/wffhYusrFX+C88BpY3w=;
  b=MrTDlfe/OglE/KXr86uXaN/+hy9VmuFsw4sIkFdIpVUOLk+U20O4MCsH
   8aZNxK6yGS/ISd8FMauj6Zq2JV2NdtVgsiI7RrFB40kD5ELjrTP9l6vRu
   JDIZx2qLk1VlR3YHotf1WcJJYpmXIdAKtSdSuio8/dYrj8zNR5ReB7dHr
   s=;
X-IronPort-AV: E=Sophos;i="5.97,230,1669075200"; 
   d="scan'208";a="290202103"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 20:51:38 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id 648B7E2EAF;
        Thu, 19 Jan 2023 20:51:37 +0000 (UTC)
Received: from EX19D030UWB003.ant.amazon.com (10.13.139.142) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 19 Jan 2023 20:51:35 +0000
Received: from bcd0741e4041.ant.amazon.com (10.43.161.198) by
 EX19D030UWB003.ant.amazon.com (10.13.139.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Thu, 19 Jan 2023 20:51:35 +0000
From:   Apoorv Kothari <apoorvko@amazon.com>
To:     <sd@queasysnail.net>
CC:     <apoorvko@amazon.com>, <fkrenzel@redhat.com>, <gal@nvidia.com>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Date:   Thu, 19 Jan 2023 12:51:29 -0800
Message-ID: <20230119205129.60194-1-apoorvko@amazon.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <Y8lkd2Im7y8BXtDe@hog>
References: <Y8lkd2Im7y8BXtDe@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D30UWC003.ant.amazon.com (10.43.162.122) To
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

> 2023-01-18, 18:55:22 -0800, Jakub Kicinski wrote:
> > On Wed, 18 Jan 2023 11:06:25 +0100 Sabrina Dubroca wrote:
> > > 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
> > > > On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:  
> > > > > This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> > > > > [1]). A sender transmits a KeyUpdate message and then changes its TX
> > > > > key. The receiver should react by updating its RX key before
> > > > > processing the next message.
> > > > > 
> > > > > This patchset implements key updates by:
> > > > >  1. pausing decryption when a KeyUpdate message is received, to avoid
> > > > >     attempting to use the old key to decrypt a record encrypted with
> > > > >     the new key
> > > > >  2. returning -EKEYEXPIRED to syscalls that cannot receive the
> > > > >     KeyUpdate message, until the rekey has been performed by userspace  
> > > > 
> > > > Why? We return to user space after hitting a cmsg, don't we?
> > > > If the user space wants to keep reading with the old key - 🤷️  
> > > 
> > > But they won't be able to read anything. Either we don't pause
> > > decryption, and the socket is just broken when we look at the next
> > > record, or we pause, and there's nothing to read until the rekey is
> > > done. I think that -EKEYEXPIRED is better than breaking the socket
> > > just because a read snuck in between getting the cmsg and setting the
> > > new key.
> > 
> > IDK, we don't interpret any other content types/cmsgs, and for well
> > behaved user space there should be no problem (right?).
> > I'm weakly against, if nobody agrees with me you can keep as is.
> 
> I was concerned (I don't know if it's realistic) about a userspace
> application with two threads:
> 
> 
>   Thread A            Thread B
>   --------            --------
> 
>   read cmsg
> 
>                       read some data (still on the old key)
> 
>   sets the new key
> 
> 
> I guess one could claim that's a userspace bug.
> 
> František's implementation in gnutls doesn't seem to rely on this.
> 
> Apoorv, since you were also looking into key updates, do you have an
> opinion on pausing decryption/reads until userspace has provides the
> new key?
> 

There are a few reason I can think of why we would want the pausing behavior.

0) If possible, we should enforce correctness and prevent the userspace from
doing something bad.

1) Pausing better aligns with the RFC since all subsequent messages
should be encrypted with the new key.

From the RFC https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3
   After sending a KeyUpdate message, the sender SHALL send all
   its traffic using the next generation of keys, computed as described
   in Section 7.2.  Upon receiving a KeyUpdate, the receiver MUST update
   its receiving keys.

2) Its possible to receive multiple KeyUpdate messages. If we allow the
userspace to read more records, they would read multiple KeyUpdate messages.
However since we currently track `bool key_update_pending;` using a bool,
we would only require a single rekey and end up in a bad state. Its possible
to fix this by not using bool but then the logic get more complicate and not
worth it IMO.

> > > > >  3. passing the KeyUpdate message to userspace as a control message
> > > > >  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
> > > > >     setsockopts
> > > > > 
> > > > > This API has been tested with gnutls to make sure that it allows
> > > > > userspace libraries to implement key updates [2]. Thanks to Frantisek
> > > > > Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> > > > > gnutls and testing the kernel patches.  
> > > > 
> > > > Please explain why - the kernel TLS is not faster than user space, 
> > > > the point of it is primarily to enable offload. And you don't add
> > > > offload support here.  
> > > 
> > > Well, TLS1.3 support was added 4 years ago, and yet the offload still
> > > doesn't support 1.3 at all.
> > 
> > I'm pretty sure some devices support it. None of the vendors could 
> > be bothered to plumb in the kernel support, yet, tho.
> > I don't know of anyone supporting rekeying.
> >
> > > IIRC support for KeyUpdates is mandatory in TLS1.3, so currently the
> > > kernel can't claim to support 1.3, independent of offloading.
> > 
> > The problem is that we will not be able to rekey offloaded connections.
> > For Tx it's a non-trivial problem given the current architecture.
> > The offload is supposed to be transparent, we can't fail the rekey just
> > because the TLS gotten offloaded.
> 
> What's their plan when the peer sends a KeyUpdate request then? Let
> the connection break?
> 
> -- 
> Sabrina
