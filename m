Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8A99576
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfHVNvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:51:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40352 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730788AbfHVNvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 09:51:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id e8so7703358qtp.7;
        Thu, 22 Aug 2019 06:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eKFs2QgT5CD3dy1iA3ijvvJPybcZyHo0PiJ8pz3oNpk=;
        b=rggXNW7h+fGIr31YDRNO073ERJFYNGq6sOAvRV7e+1F/YD8eNfzgC3edszJfEplwEI
         nM3AtKMWAcfvi8eOYPaddnljH0RvkMms7tffvgqwmnWQZBOYPXaaFxQvuoIBrNL//hd2
         GyOcVVb4qYaTgSNH1DZFA+HXX+Mp3i8QAHV5VkEOkLghzgDZ58grgRpy1kCQ/N1i4l/w
         W9u5rXiBp7RUaWPnb8s2KqdethQG4Wfdn83Qswcwc3FVVvC4H3ld4u8zQF5/2KwzeXwl
         M7N1/sEP9raPjqI03ZdFTy1+vUatu5numfQz5zlSI+cstIWw4NSHeFsfiBOFLM72VlaD
         bHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eKFs2QgT5CD3dy1iA3ijvvJPybcZyHo0PiJ8pz3oNpk=;
        b=aaHFv64I8bWdweGumkTIaEGPIByLqyD0jJDjr7FF3SNx0U6y6hCX2ZmZ7MniVoTdVY
         ewFF4uaXO05TnHtxUr7D8WnYCxgYWPqFcnsaRWOuZkO3At3e62Yglvv1/7V6XekKY9cU
         VaODdKd1UEBN3z2ukJwZEMMt0cEv6o58luQF8uL6W6QZdzMUuM/fbA4JYVx43zEFIgvJ
         Gt3Qur2MZMAG50hC3oPO9LwFMGq4nsgzUVAlTdqnra4mM2nUd8dBTHdscPeB9BtNfqc2
         ZAgqQ9EosH1qOgvcN/7J7Gq7buqzZ2QYbnB//APkp6dj8tdTOt7dQ3zYNw3c6B5E59jB
         MeRg==
X-Gm-Message-State: APjAAAWvWRjaAgb8cF81SvaGPLvzrlTFdX4vzUe1O2BHX492ffZiwAZV
        MwoFDVdWrsxA5FiMLHmC9IitA7MhwzssLA3Dmr8=
X-Google-Smtp-Source: APXvYqwMZss1KxiA/nSuBZpQ1bj4WT/UPhzt0bgewuTjv3yAQk5Deo3NcNsQvcRv1hDrE7tbIZ+IkgEG+mTzD0LgR4c=
X-Received: by 2002:a0c:f643:: with SMTP id s3mr21496414qvm.79.1566481877282;
 Thu, 22 Aug 2019 06:51:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190822091306.20581-1-bjorn.topel@gmail.com> <20190822091306.20581-2-bjorn.topel@gmail.com>
 <5d5e980f.1c69fb81.f8d9b.71f2SMTPIN_ADDED_MISSING@mx.google.com>
In-Reply-To: <5d5e980f.1c69fb81.f8d9b.71f2SMTPIN_ADDED_MISSING@mx.google.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 22 Aug 2019 15:51:05 +0200
Message-ID: <CAJ+HfNiYtnyfcGvAw0X+gNPhpqV8EpCT0Mo=tGX9Oj6XN7NOQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] xsk: avoid store-tearing when assigning queues
To:     Hillf Danton <hdanton@sina.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "syzbot+c82697e3043781e08802@syzkaller.appspotmail.com" 
        <syzbot+c82697e3043781e08802@syzkaller.appspotmail.com>,
        "i.maximets@samsung.com" <i.maximets@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 at 15:26, Hillf Danton <hdanton@sina.com> wrote:
>
> >
>
> >    /* Make sure queue is ready before it can be seen by others */
>
> >    smp_wmb();
>
>
>
> Hehe, who put mb here and for what?
>

That was from an earlier commit, and it's a barrier paired with the
lock-less reading of queues in xsk_mmap. Uhm... not sure I answered
your question?


Bj=C3=B6rn




>
>
> >-   *queue =3D q;
>
> >+  WRITE_ONCE(*queue, q);
>
> >    return 0;
>
>
