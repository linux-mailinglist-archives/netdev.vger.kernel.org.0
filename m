Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C06414D6
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiLCH4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiLCH4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:56:23 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B7879897B;
        Fri,  2 Dec 2022 23:56:21 -0800 (PST)
Received: from localhost.localdomain (unknown [10.81.81.211])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gw.red-soft.ru (Postfix) with ESMTPSA id 1CAB53E23AB;
        Sat,  3 Dec 2022 10:56:18 +0300 (MSK)
Date:   Sat, 3 Dec 2022 10:56:16 +0300
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Vishnu Dasa <vdasa@vmware.com>
Cc:     Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: vmw_vsock: vmci: Check memcpy_from_msg()
Message-ID: <Y4sBIPSJpnqW5suU@localhost.localdomain>
References: <20221202225818.3934909-1-artem.chernyshev@red-soft.ru>
 <702BBCBE-6E80-4B12-A996-4A2CB7C66D70@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <702BBCBE-6E80-4B12-A996-4A2CB7C66D70@vmware.com>
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173907 [Dec 02 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, red-soft.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/03 05:47:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/03 05:27:00 #20641058
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Sat, Dec 03, 2022 at 01:17:33AM +0000, Vishnu Dasa wrote:
> 
> 
> > On Dec 2, 2022, at 2:58 PM, Artem Chernyshev <artem.chernyshev@red-soft.ru> wrote:
> > 
> > We returns from vmci_transport_dgram_enqueue() with error
> > if memcpy goes wrong
> 
> Thanks for the patch.
> 
> Nit: could you please update the description?  Maybe something like -
> vmci_transport_dgram_enqueue() does not check the return value
> of memcpy_from_msg(). Return with an error if the memcpy fails.
> 
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
> > Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> > ---
> > net/vmw_vsock/vmci_transport.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index 842c94286d31..7994090e0314 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -1711,7 +1711,8 @@ static int vmci_transport_dgram_enqueue(
> > 	if (!dg)
> > 		return -ENOMEM;
> > 
> > -	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
> > +	if (memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len))
> 
> Need to free dg using kfree() before returning.
> 
> > +		return -EFAULT;
> > 
> > 	dg->dst = vmci_make_handle(remote_addr->svm_cid,
> > 				   remote_addr->svm_port);
> > -- 
> > 2.30.3
> > 
> 

Thanks for review. I'll fix flaws in a patch ASAP

Artem
