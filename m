Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616FE2B011C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgKLISW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLISV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:18:21 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCBAC0613D1;
        Thu, 12 Nov 2020 00:18:21 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kd7no-006CQP-KM; Thu, 12 Nov 2020 09:17:56 +0100
Message-ID: <2f8fa91f2490eec82893fea837ec52356cda55f6.camel@sipsolutions.net>
Subject: Re: [PATCH] rfkill: Fix use-after-free in rfkill_resume()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Claire Chang <tientzu@chromium.org>
Cc:     davem@davemloft.net, kuba@kernel.org, hdegoede@redhat.com,
        marcel@holtmann.org,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date:   Thu, 12 Nov 2020 09:17:40 +0100
In-Reply-To: <CALiNf29ku1aBiaBEg9ZTe7USSZZiOwnZWW3NKZgSGZ6M+GAX7w@mail.gmail.com> (sfid-20201111_042332_725984_06312727)
References: <20201110084908.219088-1-tientzu@chromium.org>
         <3b851462d9bfd914aeb9f5b432e4c076f6c330f3.camel@sipsolutions.net>
         <CALiNf29ku1aBiaBEg9ZTe7USSZZiOwnZWW3NKZgSGZ6M+GAX7w@mail.gmail.com>
         (sfid-20201111_042332_725984_06312727)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-11 at 11:23 +0800, Claire Chang wrote:
> On Wed, Nov 11, 2020 at 1:35 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2020-11-10 at 16:49 +0800, Claire Chang wrote:
> > > If a device is getting removed or reprobed during resume, use-after-free
> > > might happen. For example, h5_btrtl_resume()[drivers/bluetooth/hci_h5.c]
> > > schedules a work queue for device reprobing. During the reprobing, if
> > > rfkill_set_block() in rfkill_resume() is called after the corresponding
> > > *_unregister() and kfree() are called, there will be an use-after-free
> > > in hci_rfkill_set_block()[net/bluetooth/hci_core.c].
> > 
> > Not sure I understand. So you're saying
> > 
> >  * something (h5_btrtl_resume) schedules a worker
> >  * said worker run, when it runs, calls rfkill_unregister()
> >  * somehow rfkill_resume() still gets called after this
> > 
> > But that can't really be right, device_del() removes it from the PM
> > lists?
> 
> If device_del() is called right before the device_lock() in device_resume()[1],
> it's possible the rfkill device is unregistered, but rfkill_resume is
> still called.

OK, I see, thanks for the clarification!

I'll try to add that to the commit message.

Thanks,
johannes

