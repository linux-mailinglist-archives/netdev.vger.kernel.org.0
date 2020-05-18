Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F71D7F58
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgERQ46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:56:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33799 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgERQ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:56:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so5239894pfa.1;
        Mon, 18 May 2020 09:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fadZDuoe+7AVNrQLbu4k5XSzeRSuXHu/qP/CkwjvY9U=;
        b=ltleHC7sDLueZH7UCGKE7a6xITuEBDiKNv5xn/BDzDet979eC0epmkq16zdN1zcTEY
         oqkN8E8a5ENgUShuZAerj7JuU3n46eX4FdOAwTa4AhlSoqOdKYJtBidZ6aeV68vHaZ/6
         0kCzdRFWECTzov1ztDFUcbz8vOe8x5ujwu100SQCtwZeZYDfzNxoEpr8b7HjrYXNFagr
         /32WwKoJsuA98TGbPiHFDuPkxabC6ho8FohzdCgveqjfsCxXQrXP9XP+kI0V0fM4ZgWZ
         Mf9t4+/QBsNV2cVe2EzhTgMwag9JrgmAHiNor6el/6kmYSMUgMrw9kEOIViQLpxzk5hH
         soeg==
X-Gm-Message-State: AOAM531GSW2dg2RMk/2b/GKcw77LV601geONNxtlnrGsuuAjnYTx/D5o
        eyuHLAyD/AvkG73vsYhSfxU=
X-Google-Smtp-Source: ABdhPJy1SvMSYcbQtF+WbvyuU0bth54j13rmWQ4x/1qKYO9fVM8DA3PZp2Z8WiQfvW2V1CXjHF+MFw==
X-Received: by 2002:a63:444a:: with SMTP id t10mr2296637pgk.149.1589821017135;
        Mon, 18 May 2020 09:56:57 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y5sm3561281pff.150.2020.05.18.09.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 09:56:56 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 5D7F7404B0; Mon, 18 May 2020 16:56:55 +0000 (UTC)
Date:   Mon, 18 May 2020 16:56:55 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518165655.GI11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 03:50:55PM +0200, Johannes Berg wrote:
> On Sat, 2020-05-16 at 15:24 +0200, Johannes Berg wrote:
> 
> > Instead of the kernel taint, IMHO you should provide an annotation in
> > sysfs (or somewhere else) for the *struct device* that had its firmware
> > crash. Or maybe, if it's too complex to walk the entire hierarchy
> > checking for that, have a uevent, or add the ability for the kernel to
> > print out elsewhere in debugfs the list of devices that crashed at some
> 
> I mean sysfs, oops.
> 
> 
> In addition, look what we have in iwl_trans_pcie_removal_wk(). If we
> detect that the device is really wedged enough that the only way we can
> still try to recover is by completely unbinding the driver from it, then
> we give userspace a uevent for that.

Nice! Indeed a uevent is in order for these sorts of things, and I'd
argue that it begs the question if we should even uevent for any taint
as well. Today these are silent. If the kernel crashes, today we only
give userspace a log.

> I don't remember exactly how and
> where that gets used (ChromeOS) though, but it'd be nice to have that
> sort of thing as part of the infrastructure, in a sort of two-level
> notification?
> 
> Level 1: firmware crashed, but we're recovering, at least mostly, and
> it's more informational
> 
> Level 2: device is wedged, going to try to recover by some more forceful
> means (perhaps some devices can be power-cycled? etc.) but (more) state
> would be lost in these cases?

I agree that *all* this would be ideal. I don't see this as mutually
exclusive with a taint on the kernel and module for the device.

> Still don't think a kernel taint is appropriate for either of these.

From a support perspective, I do think it is vital quick information.

  Luis
