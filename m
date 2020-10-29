Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45E129E67B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgJ2Ifv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgJ2Ifr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:35:47 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CD7C0613D2;
        Thu, 29 Oct 2020 01:35:46 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l8so1603102wmg.3;
        Thu, 29 Oct 2020 01:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ivBwB6jIx8a7CJdFOF324R+b6Z/WH4ZEOu7vP5tzztQ=;
        b=KW6V5TrlmvP8xBFlILzNLJIzpUYNefybdkLgTZIdP8d7YNRZtetO8UJ7dzSkhXIpgG
         CM7JQAl+iPrrelzndQa8pjcG0GkiJ4zmCytzIIWvdhNIK9LjMWE7UTvg3Hb3w+hhIhXE
         Jgp+v7c+UxsVI3Ef0mdVEyXr4lmDuJ4uVWgCJnBT8zkHUK92oo4AzsFQ7EmHmpuzUo1T
         LWNi1unZvOupQLxVjlLhOxLYZde20Yhn/Aye0oBi14OsmQLY4SeZyENxDzEOOWcRVF72
         sjEZAb7gKxKrvdtzxyQd4VZ/FWPh4b4KeLCGbufRn9t2b+bi/4w5vy+Aarv0qYdUK0Rk
         Ifxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ivBwB6jIx8a7CJdFOF324R+b6Z/WH4ZEOu7vP5tzztQ=;
        b=btlE4JsjsKyWid6rXsGoK1+UBXZHHmv6AzNcSxszdRldNo4+ubxr/ddD9j/ibcNmcz
         83qugLNx4m88xk5s8EI2qtDlFMi7xXc1UYdlZWMTxm6ADK+d1A1aaqUacCkyJkgFtvYH
         Cm7m+eTiOHXauL6luNutnbDkeKnIR6RxlEZQK+lhhwkni+zVHIX6Ax+a58CJ0nZ19VRL
         JMJSV27r/6E14xWBWGibP2fb60J74yzw1xnf8yuxyRdGDsCk6fOAdfCHZ1OZ8TYUvAkx
         25DIxouk/uTKAv8EeJkrJMwQePb5dYJdxKToRF7d5i1k1jwxwkdBvsQvaWtI4L5v3kw1
         VPww==
X-Gm-Message-State: AOAM533rN5wAASkberk4yYXzHXSggf8Zk+fzy1bXcvaypyfcG7dozQKq
        bepcsmsY81df1CF6fhX+85KyUeIJ4gjm+u+sCQI=
X-Google-Smtp-Source: ABdhPJwDZ3AgI/TBlHv0/9LtT5xYG6KFEtL/xmRrTJwshppqq1Qf4XDaEI73HNQ782ddgU9gb6KQZ4a3QU7LpuhN6w4=
X-Received: by 2002:a1c:dd05:: with SMTP id u5mr3240876wmg.56.1603960545585;
 Thu, 29 Oct 2020 01:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <1603801921-2712-1-git-send-email-magnus.karlsson@gmail.com>
In-Reply-To: <1603801921-2712-1-git-send-email-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 29 Oct 2020 09:35:34 +0100
Message-ID: <CAJ+HfNi=NZKsrjM5dJ-4TE1o8WonCqJyien3G+Jh6LsuF0SJXg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix possible memory leak at socket close
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 at 08:32, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a possible memory leak at xsk socket close that is caused by the
> refcounting of the umem object being wrong. The reference count of the
> umem was decremented only after the pool had been freed. Note that if
> the buffer pool is destroyed, it is important that the umem is
> destroyed after the pool, otherwise the umem would disappear while the
> driver is still running. And as the buffer pool needs to be destroyed
> in a work queue, the umem is also (if its refcount reaches zero)
> destroyed after the buffer pool in that same work queue.
>
> What was missing is that the refcount also needs to be decremented
> when the pool is not freed and when the pool has not even been
> created. The first case happens when the refcount of the pool is
> higher than 1, i.e. it is still being used by some other socket using
> the same device and queue id. In this case, it is safe to decrement
> the refcount of the umem outside of the work queue as the umem will
> never be freed because the refcount of the umem is always greater than
> or equal to the refcount of the buffer pool. The second case is if the
> buffer pool has not been created yet, i.e. the socket was closed
> before it was bound but after the umem was created. In this case, it
> is safe to destroy the umem outside of the work queue, since there is
> no pool that can use it by definition.
>
> Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from=
 umem")
> Reported-by: syzbot+eb71df123dc2be2c1456@syzkaller.appspotmail.com
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
