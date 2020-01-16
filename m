Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB0C13DE32
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgAPO62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:58:28 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39877 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgAPO62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:58:28 -0500
Received: by mail-lj1-f195.google.com with SMTP id l2so22982184lja.6
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 06:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZlWmpgDyDdsULP1jSOM2LgtaNUde+0xpVc28/QeN14M=;
        b=qKQapphL2smdPRHFEYTDMipXEH8S5PWvHdfCJxJBciE7QqU9heoLJQqzXAhlOuFABj
         1RE6y9yM+MbXdk5yFLNkRKXf8e8HkRPfac4G63OlpXv9Y02Xg02FqoU3uQt9fFrVA1YS
         Evt2fL5WLE6DqJyALOILGGRNgHKTR4Dr/9d7ePxZW2ZuBB2z0KyNKeSE9LnE/TMoiNVq
         gSqvTB0a31FWG9HiY3I1uNOEc9nTsQzqXb65uj9H5vgx8pqkiFRjLcVtRvi8O4syoAAm
         3EuzXXW3aZ2/adhB/LwoUYTETn8NZJXGYD0QkFFf26I3eTm+F4PO2KHN6u+F8jSJqgRs
         s+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZlWmpgDyDdsULP1jSOM2LgtaNUde+0xpVc28/QeN14M=;
        b=XNjeTWHGfPhsr6/LMu2IC+psfYsiHGU3qIVCcwqlUHlRUKW2rDY/swYBPPh27ci0PF
         vR3wF0Tn3aLSl4v0C7uk8Z+aBqmvNIuTR8NgPNcB49lQNwTDgV6e7taCMLS9p++k4Mu6
         bdwAbMh/gMIat9AMDtZmUP2/zhzNGQyTKM2dRwATTvfUfbVJzrRrd3khLfz95IJhobad
         b17MziaU81MKDTmoQWR0zFHfRE42ntB/9uySMBdYshfGgkl2uQwilIEEYUojN5qrXcCF
         mIsPXaScIDSiO67UOztVpf6mhUWt1PdpPE6arIRDaz5ry8GcrOJWQ7Zyjc/oCXn0bgh5
         vYXQ==
X-Gm-Message-State: APjAAAW7uZlJOgcccf03K5oxDhMI9bWRUbjoDKmu58djM0lCh6Abtaaz
        FeK7C/ZG4LBToKKuWdPybhQbSPZ5b+U6ZccJU9Y/hIsH
X-Google-Smtp-Source: APXvYqyqKiFbqkR2bMcQXax2DsEGgcx154Hew2PTocGf9xY5REuUhPXGdurBJV0VaEQS2mpyCMuhhSTPZ/pPOApAjS8=
X-Received: by 2002:a2e:9d90:: with SMTP id c16mr2348812ljj.264.1579186706060;
 Thu, 16 Jan 2020 06:58:26 -0800 (PST)
MIME-Version: 1.0
References: <20200115210238.4107-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20200115210238.4107-1-xiyou.wangcong@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 16 Jan 2020 23:58:14 +0900
Message-ID: <CAMArcTUF0SmMOU+4cdgkrj8taqHwf_QS21bK0-S-V=4pMeyjJg@mail.gmail.com>
Subject: Re: [Patch net] net: avoid updating qdisc_xmit_lock_key in netdev_update_lockdep_key()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 at 06:02, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> syzbot reported some bogus lockdep warnings, for example bad unlock
> balance in sch_direct_xmit(). They are due to a race condition between
> slow path and fast path, that is qdisc_xmit_lock_key gets re-registered
> in netdev_update_lockdep_key() on slow path, while we could still
> acquire the queue->_xmit_lock on fast path in this small window:
>
> CPU A                                           CPU B
>                                                 __netif_tx_lock();
> lockdep_unregister_key(qdisc_xmit_lock_key);
>                                                 __netif_tx_unlock();
> lockdep_register_key(qdisc_xmit_lock_key);
>
> In fact, unlike the addr_list_lock which has to be reordered when
> the master/slave device relationship changes, queue->_xmit_lock is
> only acquired on fast path and only when NETIF_F_LLTX is not set,
> so there is likely no nested locking for it.
>
> Therefore, we can just get rid of re-registration of
> qdisc_xmit_lock_key.
>
> Reported-by: syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com
> Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")

Thank you for fixing this bug!

Acked-by: Taehee Yoo <ap420073@gmail.com>
