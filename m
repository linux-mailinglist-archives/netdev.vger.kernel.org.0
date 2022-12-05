Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BB864276A
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiLELXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiLELWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:22:53 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C56B8E46;
        Mon,  5 Dec 2022 03:22:48 -0800 (PST)
Received: from localhost.localdomain (unknown [10.81.81.211])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gw.red-soft.ru (Postfix) with ESMTPSA id 65B053E606E;
        Mon,  5 Dec 2022 14:22:45 +0300 (MSK)
Date:   Mon, 5 Dec 2022 14:22:44 +0300
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Vishnu Dasa <vdasa@vmware.com>, Bryan Tan <bryantan@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] net: vmw_vsock: vmci: Check memcpy_from_msg()
Message-ID: <Y43UhNq/WQEuTD8V@localhost.localdomain>
References: <702BBCBE-6E80-4B12-A996-4A2CB7C66D70@vmware.com>
 <20221203083312.923029-1-artem.chernyshev@red-soft.ru>
 <20221205094736.k3yuwk7emijpitvw@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205094736.k3yuwk7emijpitvw@sgarzare-redhat>
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173924 [Dec 05 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;red-soft.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/05 07:18:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/05 09:01:00 #20651080
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On Mon, Dec 05, 2022 at 10:47:36AM +0100, Stefano Garzarella wrote:
> On Sat, Dec 03, 2022 at 11:33:12AM +0300, Artem Chernyshev wrote:
> > vmci_transport_dgram_enqueue() does not check the return value
> > of memcpy_from_msg(). Return with an error if the memcpy fails.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 0f7db23a07af ("vmci_transport: switch ->enqeue_dgram, ->enqueue_stream and ->dequeue_stream to msghdr")
> > Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> > ---
> > V1->V2 Fix memory leaking and updates for description
> > 
> > net/vmw_vsock/vmci_transport.c | 5 ++++-
> > 1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
> > index 842c94286d31..c94c3deaa09d 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -1711,7 +1711,10 @@ static int vmci_transport_dgram_enqueue(
> > 	if (!dg)
> > 		return -ENOMEM;
> > 
> > -	memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len);
> > +	if (memcpy_from_msg(VMCI_DG_PAYLOAD(dg), msg, len)) {
> > +		kfree(dg);
> > +		return -EFAULT;
> 
> Since memcpy_from_msg() is a wrapper of copy_from_iter_full() that simply
> returns -EFAULT in case of an error, perhaps it would be better here to
> return the value of memcpy_from_msg() instead of wiring the error.
> 
> However in the end the behavior is the same, so even if you don't want to
> change it I'll leave my R-b:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Thanks,
> Stefano

Thank you for review. Sure, I will change that in V3

Artem
