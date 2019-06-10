Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 447E93BD11
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 21:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389269AbfFJTq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 15:46:29 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37157 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388901AbfFJTq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 15:46:29 -0400
Received: by mail-qk1-f194.google.com with SMTP id d15so6197293qkl.4;
        Mon, 10 Jun 2019 12:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q6FJgYJZH5Fw8octjl9prEaDtOkXxZ/TH6CJsMI4oLA=;
        b=Wi6BTnNLSs132AE1rb41JulCjO93FXVZwTbIUwzkMlTmiFFfk9W8vewl42PtGGGjQ/
         yDzRuyvCz9k5M6K8dpbxiVSEmBiM+peWbjI78FhZaeNlkpihe2/ldTs/rWfBbZAiS5gk
         2KU+BjPlxgmDp7rWjngSG5h13+mY2G6+pwB657aM+JtovrcVBupvy2dMv3+jE/AcSGuF
         LY817fumUBN3D1Mi9mo/j/qYGNuIProVHiBXOqB7bLIEAIazDj0y1ZgzeX/Vdj0ls/3s
         zDDM4enyhJhFx56xR0QtiR/5+cA7odTSkI2+U9zvFKZcV7cqLUTkfy+XSfvaAkoBMB1/
         PZng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q6FJgYJZH5Fw8octjl9prEaDtOkXxZ/TH6CJsMI4oLA=;
        b=g/IcVkOYzbKQQ0cNqPjjCrX2ve3KNvgffS2OcpeKpHloY03oon+96jbA6HHzDub0mE
         TEbcMS96eindZaWLTtMB+8NmTJKgtJ2boXBomS8HRypVQPKpmcahtUib8DBV3wvLMO5F
         t1p6PIYfbwmK5MocKNyo75jICTkEkdtJsQwJzHBPWzBEVkPkwgAbBssyX2NmMNbshAe6
         aH37gxrV0C7E/bBUD1/yZui3AUPqfUiS8REQf6p/d/z/kjxutC5qA0XljSvFuvWGoGBA
         ZwmanDCri91tquNtCnmI80HWV2IynzMZAZePanPwOKHXcAWQx4sR2XMiCTdJN9werQYM
         n7ow==
X-Gm-Message-State: APjAAAVDIIYsPKM79biY/0dUgvRiOIjPc/iBrbN8mMGzl3/sffMPKhhk
        dBRvyzoGXkNJlZZMRiSVbeJBxQBqotKnNbSqcvE=
X-Google-Smtp-Source: APXvYqyTFFThBaVqA3Nhdu601dNPy3EvhqMbRFgOD8thmuuAun88LGEACXlbuhhAEv64kDFY/KbaUtcenvjg9fq/fik=
X-Received: by 2002:a05:620a:5b0:: with SMTP id q16mr55641369qkq.212.1560195987928;
 Mon, 10 Jun 2019 12:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
 <20190610161546.30569-1-i.maximets@samsung.com>
In-Reply-To: <20190610161546.30569-1-i.maximets@samsung.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 10 Jun 2019 12:45:50 -0700
Message-ID: <CALDO+SYhxw-Y7+i5Su9xz5PPYzgZm4qna+tEmBnXeG=GD7YSpg@mail.gmail.com>
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound to
 xdp socket
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:39 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> Device that bound to XDP socket will not have zero refcount until the
> userspace application will not close it. This leads to hang inside
> 'netdev_wait_allrefs()' if device unregistering requested:
>
>   # ip link del p1
>   < hang on recvmsg on netlink socket >
>
>   # ps -x | grep ip
>   5126  pts/0    D+   0:00 ip link del p1
>
>   # journalctl -b
>
>   Jun 05 07:19:16 kernel:
>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>
>   Jun 05 07:19:27 kernel:
>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>   ...

Thanks. I hit the same issue quite often when using veth driver to
test AF_XDP.

>
> Fix that by implementing NETDEV_UNREGISTER event notification handler
> to properly clean up all the resources and unref device.
>
> This should also allow socket killing via ss(8) utility.
>
> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> ---
Tested-by: William Tu <u9012063@gmail.com>
