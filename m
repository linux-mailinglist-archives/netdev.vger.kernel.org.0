Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7446672EA4
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 03:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjASCLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 21:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjASCLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 21:11:04 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7929C67948
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674094262; x=1705630262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CCwIB6GFIbFP8BInOQQTgOrTgqIhgR8Bw0fpiZiVFlQ=;
  b=N6CfmZTP8smSgNlPWIlenKZpo/J2x4nR0GLrp+o34D5XQLiuY2R33nDa
   xgDprdSD40zNFEmQSpMl2Wo9XZmsxSMxdUZQuRKUOqkpuyYi7hCfYW+gN
   LWOtqxM+FlzTSoS5vZlIBm3hADJ0A5OouxMFZ3JIVLyjAOFWuo16lVi6D
   w=;
X-IronPort-AV: E=Sophos;i="5.97,226,1669075200"; 
   d="scan'208";a="284226675"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 02:11:01 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id AD8B780422;
        Thu, 19 Jan 2023 02:11:00 +0000 (UTC)
Received: from EX19D030UWB003.ant.amazon.com (10.13.139.142) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 19 Jan 2023 02:11:00 +0000
Received: from bcd0741e4041.ant.amazon.com (10.43.161.198) by
 EX19D030UWB003.ant.amazon.com (10.13.139.142) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Thu, 19 Jan 2023 02:10:59 +0000
From:   Apoorv Kothari <apoorvko@amazon.com>
To:     <sd@queasysnail.net>
CC:     <fkrenzel@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Date:   Wed, 18 Jan 2023 18:10:53 -0800
Message-ID: <20230119021053.39853-1-apoorvko@amazon.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <c2f6961dd1d90d8fed0eb55fe3a1b9d98814ce60.1673952268.git.sd@queasysnail.net>
References: <c2f6961dd1d90d8fed0eb55fe3a1b9d98814ce60.1673952268.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D44UWC004.ant.amazon.com (10.43.162.209) To
 EX19D030UWB003.ant.amazon.com (10.13.139.142)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
> > Please CC all the maintainers.
> 
> Sorry.
> 
> > On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote:
> > > This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> > > [1]). A sender transmits a KeyUpdate message and then changes its TX
> > > key. The receiver should react by updating its RX key before
> > > processing the next message.
> > > 
> > > This patchset implements key updates by:
> > >  1. pausing decryption when a KeyUpdate message is received, to avoid
> > >     attempting to use the old key to decrypt a record encrypted with
> > >     the new key
> > >  2. returning -EKEYEXPIRED to syscalls that cannot receive the
> > >     KeyUpdate message, until the rekey has been performed by userspace
> > 
> > Why? We return to user space after hitting a cmsg, don't we?
> > If the user space wants to keep reading with the old key - 🤷️
> 
> But they won't be able to read anything. Either we don't pause
> decryption, and the socket is just broken when we look at the next
> record, or we pause, and there's nothing to read until the rekey is
> done. I think that -EKEYEXPIRED is better than breaking the socket
> just because a read snuck in between getting the cmsg and setting the
> new key.

Pausing also better aligns with the RFC also since all subsequent messages
should be encrypted with the new key.

From the RFC https://www.rfc-editor.org/rfc/rfc8446#section-4.6.3
   After sending a KeyUpdate message, the sender SHALL send all
   its traffic using the next generation of keys, computed as described
   in Section 7.2.  Upon receiving a KeyUpdate, the receiver MUST update
   its receiving keys.

> 
> > >  3. passing the KeyUpdate message to userspace as a control message
> > >  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
> > >     setsockopts
> > > 
> > > This API has been tested with gnutls to make sure that it allows
> > > userspace libraries to implement key updates [2]. Thanks to Frantisek
> > > Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> > > gnutls and testing the kernel patches.
> > 
> > Please explain why - the kernel TLS is not faster than user space, 
> > the point of it is primarily to enable offload. And you don't add
> > offload support here.
> 
> Well, TLS1.3 support was added 4 years ago, and yet the offload still
> doesn't support 1.3 at all.
> 
> IIRC support for KeyUpdates is mandatory in TLS1.3, so currently the
> kernel can't claim to support 1.3, independent of offloading.
> 
> Some folks did tests with and without kTLS using nbdcopy and found a
> small but noticeable performance improvement (around 8-10%).
> 
> > > Note: in a future series, I'll clean up tls_set_sw_offload and
> > > eliminate the per-cipher copy-paste using tls_cipher_size_desc.
> > 
> > Yeah, I think it's on Vadim's TODO list as well.
> 
> I've already done most of the work as I was working on this, I'll
> submit it later.
> 
> -- 
> Sabrina

--
Apoorv
