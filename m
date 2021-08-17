Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23303EF02D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhHQQbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229739AbhHQQaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4B8761029;
        Tue, 17 Aug 2021 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629217687;
        bh=dGpS5njND7yROyvBrT3f246BeO+pDM1JwuML6ZYX06Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JSZny/ippjRGtvilvidsApBuYJmtBDquYL4MrunJZE3OQxmvmxIP+td3O9fR/hN/Q
         M0F8KryN9BD8A5HKO/Cg3cWPY1oh2jTVaj3fOsUM1RrqcT5VwgyqqsOj9gZsir+RQ1
         oXcadQ+e25rQaWSYMG+UM4qrKQOf0hStg+toq6v8=
Date:   Tue, 17 Aug 2021 18:28:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
Cc:     isdn@linux-pingi.de, jirislaby@kernel.org, dsterba@suse.com,
        jcmvbkbc@gmail.com, johannes@sipsolutions.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrianov@ispras.ru
Subject: Re: [question] potential race between capinc_tty_init & capi_release
Message-ID: <YRvjlf4V1UOse5ld@kroah.com>
References: <af56f61a-6343-85fd-3efc-b3a2890246ac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af56f61a-6343-85fd-3efc-b3a2890246ac@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 02:43:22PM +0530, Saubhik Mukherjee wrote:
> In drivers/isdn/capi/capi.c, based on the output of a static analysis tool,
> we found the possibility of the following race condition:

Do you know of any isdn capi devices out there in the world right now?

> 
> In capi_init, register_chrdev registers file operations callbacks,
> capi_fops. Then capinc_tty_init is executed.
> 
> Simultaneously the following chain of calls can occur (after a successful
> capi_open call).
> 
> capi_release -> capincci_free -> capincci_free_minor -> capiminor_free ->
> tty_unregister_device
> 
> tty_unregister_device reads capinc_tty_driver, which might not have been
> initialized at this point. So, we have a race between capi_release and
> capinc_tty_init.
> 
> If this is a possible race scenario, maybe moving register_chrdev after
> capinc_tty_init could fix it. But I am not sure if this will break something
> else. Please let me know if this is a potential race and can be fixed as
> mentioned.

Would you be racing now if someone opened/closed the tty device node
before the char device node was created?

Anyway, this is really old and obsolete code, odds are it can just be
removed entirely.

thanks,

greg k-h
