Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E285166DD
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 20:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbiEASMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 14:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiEASMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 14:12:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AB74EA38;
        Sun,  1 May 2022 11:09:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D0DB60FA7;
        Sun,  1 May 2022 18:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983C5C385AA;
        Sun,  1 May 2022 18:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651428563;
        bh=OXHsmN3eDLHC/Q7IcKml6KTFfnlMEW7U+UvWLYIVah8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=adPli/1PsOHnIQnaCQVuJxnzHKIIFS1cngkONDi6dB7FFL3A4CWQ5NPxHqj6I6BIY
         yBkh1jO2vN+t69S9QFulNBgoYXd1hUKcYTopA4b9NJ+fXhszDOYec9YA81oVLC2Zxx
         LsJrJ7rqqQGlACMuhyE7pyqtjG3uwuycdjio9pvs=
Date:   Sun, 1 May 2022 20:09:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] usb: cdc-wdm: fix reading stuck on device close
Message-ID: <Ym7MyhaX3SYX9rmm@kroah.com>
References: <20220501175828.8185-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501175828.8185-1-ryazanov.s.a@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 01, 2022 at 08:58:28PM +0300, Sergey Ryazanov wrote:
> cdc-wdm tracks whether a response reading request is in-progress and
> blocks the next request from being sent until the previous request is
> completed. As soon as last user closes the cdc-wdm device file, the
> driver cancels any ongoing requests, resets the pending response
> counter, but leaves the response reading in-progress flag
> (WDM_RESPONDING) untouched.
> 
> So if the user closes the device file during the response receive
> request is being performed, no more data will be obtained from the
> modem. The request will be cancelled, effectively preventing the
> WDM_RESPONDING flag from being reseted. Keeping the flag set will
> prevent a new response receive request from being sent, permanently
> blocking the read path. The read path will staying blocked until the
> module will be reloaded or till the modem will be re-attached.
> 
> This stuck has been observed with a Huawei E3372 modem attached to an
> OpenWrt router and using the comgt utility to set up a network
> connection.
> 
> Fix this issue by clearing the WDM_RESPONDING flag on the device file
> close.
> 
> Without this fix, the device reading stuck can be easily reproduced in a
> few connection establishing attempts. With this fix, a load test for
> modem connection re-establishing worked for several hours without any
> issues.
> 
> Fixes: 922a5eadd5a3 ("usb: cdc-wdm: Fix race between autosuspend and
> reading from the device")

Nit, Fixes: lines should only be one line, I'll fix this up when
applying it.

> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> ---
> 
> Technically, cdc-wdm belongs to the USB subsystem even though it serves
> WWAN devices. I think this fix should be applied (backported) to LTS
> versions too. So I targeted it to the 'net' tree, but send it to both
> lists to get a feedback. Greg, Jakub, what is the best tree for this
> fix?
> 
> ---
>  drivers/usb/class/cdc-wdm.c | 1 +
>  1 file changed, 1 insertion(+)

scripts/get_maintainer.pl is pretty clear this goes through the USB
tree.  I'll queue it up in a few days, thanks,

greg k-h
