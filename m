Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7660C550364
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 09:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiFRHg3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Jun 2022 03:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiFRHg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 03:36:26 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B9E2BB0A;
        Sat, 18 Jun 2022 00:36:23 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id AE30F40002;
        Sat, 18 Jun 2022 07:36:18 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 18 Jun 2022 09:36:16 +0200
Message-Id: <CKT35VBLVILO.1RPVCE81R8RJJ@enhorning>
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     <davem@davemloft.net>, <cmllamas@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: Re: NEEDS FIXING - Was: Re: [PATCH v2] ipv4: ping: fix bind address
 validity check
X-Mailer: aerc 0.9.0
References: <20220617085435.193319-1-pbl@bestov.io>
 <165546541315.12170.9716012665055247467.git-patchwork-notify@kernel.org>
 <CKSU5Q2M1IE3.39AS0HDHTZPN@enhorning> <20220617195816.53a2f2cf@kernel.org>
In-Reply-To: <20220617195816.53a2f2cf@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Jun 18, 2022 at 4:58 AM CEST, Jakub Kicinski wrote:
> On Sat, 18 Jun 2022 02:32:55 +0200 Riccardo Paolo Bestetti wrote:
> >  [...]
> > 2) My patch is faulty. I had a complete and tested patch, including code
> > fixing the regression. Instead of sending it, however, I decided to
> > adapt it to preserve Carlos Llamas' version of ping.c, since they posted
> > their patch first. In doing so I used a work branch which contained a
> > faulty version (wrong flags) of the regression tests. The resulting
> > faulty patch is, unfortunately, currently in the tree.
> > 
> > At this point, due to the unfortunate combination of (1) and (2), it
> > might be worth reverting the patch altogether and just applying the v1
> > (i.e. without the regression tests) to the tree and to the relevant LTS
> > versions.
>
> IIUC only the test is faulty / unreliable, correct?

Correct, I don't see anything wrong with the fix itself. When manually
tested it shows the intended behaviour (sorry for the long lines):

$ pwd
$KERNEL_TREE/net/tools/testing/selftests/net

$ uname -a
Linux enhorning 5.19.0-rc2kbr-00103-gb4a028c4d031 #1 SMP PREEMPT_DYNAMIC Fri Jun 17 13:51:24 CEST 2022 x86_64 GNU/Linux

$ ./nettest -s -D -P icmp -l 224.0.0.1 -b
09:19:50 server: error binding socket: 99: Cannot assign requested address

$ ./nettest -s -D -P icmp -l 255.255.255.255 -b
09:21:20 server: error binding socket: 99: Cannot assign requested address

(and fcnal-test.sh shows nothing noteworthy.)


Riccardo P. Bestetti

>
> We have until Thursday before this patch hits Linus's tree so should 
> be plenty of time to figure the problem out and apply an incremental
> fix. I see you posted an RFC already, thanks!
>
> > After that, a more proper discussion can be had about (1), and the
> > regression tests can be fixed. I'm sending a demonstrative patch for
> > that as a response to this message.

