Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A6ED3CAB
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfJKJqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:46:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34731 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfJKJqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:46:23 -0400
Received: from v22018046084765073.goodsrv.de ([185.183.158.195] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIrV2-0004ZL-2S; Fri, 11 Oct 2019 09:46:16 +0000
Date:   Fri, 11 Oct 2019 11:46:14 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     luto@amacapital.net, jannh@google.com, wad@chromium.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v2 1/3] seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE
Message-ID: <20191011094613.rs45knchjbe7edv4@wittgenstein>
References: <20190920083007.11475-1-christian.brauner@ubuntu.com>
 <20190920083007.11475-2-christian.brauner@ubuntu.com>
 <201910101440.17A13952@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201910101440.17A13952@keescook>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 02:45:38PM -0700, Kees Cook wrote:
> On Fri, Sep 20, 2019 at 10:30:05AM +0200, Christian Brauner wrote:
> > + * Similar precautions should be applied when stacking SECCOMP_RET_USER_NOTIF.
> > + * For SECCOMP_RET_USER_NOTIF filters acting on the same syscall the uppermost
> > + * filter takes precedence. This means that the uppermost
> > + * SECCOMP_RET_USER_NOTIF filter can override any SECCOMP_IOCTL_NOTIF_SEND from
> > + * lower filters essentially allowing all syscalls to pass by using
> > + * SECCOMP_USER_NOTIF_FLAG_CONTINUE. Note that SECCOMP_RET_USER_NOTIF can
>                                                           ^^^^^^^^^^^^^^
> This is meant to read RET_TRACE, yes?

Yes. :)

> 
> > + * equally be overriden by SECCOMP_USER_NOTIF_FLAG_CONTINUE.
> 
> I rewrote this paragraph with that corrected and swapping some
> "upper/lower" to "most recently added" etc:
> 
> + * Similar precautions should be applied when stacking SECCOMP_RET_USER_NOTIF
> + * or SECCOMP_RET_TRACE. For SECCOMP_RET_USER_NOTIF filters acting on the
> + * same syscall, the most recently added filter takes precedence. This means
> + * that the new SECCOMP_RET_USER_NOTIF filter can override any
> + * SECCOMP_IOCTL_NOTIF_SEND from earlier filters, essentially allowing all
> + * such filtered syscalls to be executed by sending the response
> + * SECCOMP_USER_NOTIF_FLAG_CONTINUE. Note that SECCOMP_RET_TRACE can equally
> + * be overriden by SECCOMP_USER_NOTIF_FLAG_CONTINUE.
> 
> 
> Ultimately, I think this caveat is fine. RET_USER_NOTIF and RET_TRACE are
> both used from the "process manager" use-case. The benefits of "continue"
> semantics here outweighs the RET_USER_NOTIF and RET_TRACE "bypass". If
> we end up in a situation where we need to deal with some kind of
> nesting where this is a problem in practice, we can revisit this.
> 
> Applied to my for-next/seccomp. Thanks!

Thanks!
Christian
