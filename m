Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4C1D616B
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 15:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgEPNvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 09:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbgEPNvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 09:51:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF98C061A0C;
        Sat, 16 May 2020 06:51:39 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jZxDN-00ECfk-5c; Sat, 16 May 2020 15:50:57 +0200
Message-ID: <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luis Chamberlain <mcgrof@kernel.org>, jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Date:   Sat, 16 May 2020 15:50:55 +0200
In-Reply-To: <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net> (sfid-20200516_152518_154267_1B9A55D6)
References: <20200515212846.1347-1-mcgrof@kernel.org>
         <20200515212846.1347-13-mcgrof@kernel.org>
         (sfid-20200515_233205_994687_1F26BDAB) <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
         (sfid-20200516_152518_154267_1B9A55D6)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-05-16 at 15:24 +0200, Johannes Berg wrote:

> Instead of the kernel taint, IMHO you should provide an annotation in
> sysfs (or somewhere else) for the *struct device* that had its firmware
> crash. Or maybe, if it's too complex to walk the entire hierarchy
> checking for that, have a uevent, or add the ability for the kernel to
> print out elsewhere in debugfs the list of devices that crashed at some

I mean sysfs, oops.


In addition, look what we have in iwl_trans_pcie_removal_wk(). If we
detect that the device is really wedged enough that the only way we can
still try to recover is by completely unbinding the driver from it, then
we give userspace a uevent for that. I don't remember exactly how and
where that gets used (ChromeOS) though, but it'd be nice to have that
sort of thing as part of the infrastructure, in a sort of two-level
notification?

Level 1: firmware crashed, but we're recovering, at least mostly, and
it's more informational

Level 2: device is wedged, going to try to recover by some more forceful
means (perhaps some devices can be power-cycled? etc.) but (more) state
would be lost in these cases?

Still don't think a kernel taint is appropriate for either of these.

johannes

