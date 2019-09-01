Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB8A4B00
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbfIARzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 13:55:40 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40516 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728830AbfIARzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 13:55:40 -0400
Received: by mail-lj1-f194.google.com with SMTP id 7so1290588ljw.7
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 10:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xUOs0bu69ISoyset+GMUnnn7xy5cHW/QBV9UIBw4od0=;
        b=BpwDgUJGCE40hLqTfL0UwI4bkEjl6k9zg6hSaRGqDcs64lNaYUS1cuZgHDH506ROEE
         wj7Qn1ljTb4NRNlND9jAE3SSudiLmrIw3JP+YeFzGl0fS2xE5i/IaudS7Q8dBraM/5bl
         G6ee4pnwbB7u2MKJZPxCFW4tap/USyDOJcEKKhjBq7PfcCOY2IoPibk5DtBE7U04iW5e
         9NV6JKqbxudbpl9+Hi62ihyIyAFjXZSGdGPDPR4bT7W9i30IVNIjdmb2SeVJzjhzKTpJ
         UVN+6zBYoa6T24TDuWibfMJYqZBSmbhsh0xgkPgYJR/JIFeisxulwyimEIE5gELPcAFn
         35UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xUOs0bu69ISoyset+GMUnnn7xy5cHW/QBV9UIBw4od0=;
        b=OAU1IkQ/Z1VBXFZ3ixNKPZzEw6LahS4cEy1j5hcLyRD0d3GMEvCQFXA0IIpqCAXgeB
         7fHFxbcB7ZnTUMflUnetG+i6yavevGEExffk53XrS4leuopP4OwXXY9uMkzOyvLEPW7b
         t7aONeXP30ki4ngfTgWbzJigaAwVZZQNICfWuNhRe/yDqWpf8gTxb1wmlwS13ZNWGiKt
         2odnTb9v2rfYauTOFtSV1rVKi+lnnCBNIS/u0JOcVhR7q4r25FsoyJS4qDP0x5uv5ycg
         fWiNMSLQ6KPYDJ23ovuNqzzV2eoPSzSvIFUB+rBuQ4/+DRt4h0RrfnlMKIucnmTaOd7a
         z8zQ==
X-Gm-Message-State: APjAAAUTM+K+OutKWzFCO8/NeknDmRhrEjsLv95JcnWsznGEH/lsyMri
        5G9HV4zA7Sg0U7rJiflOwEb7CRCjNe/q+zuxoMs=
X-Google-Smtp-Source: APXvYqwh8SckkS2oW4TC/ovudZxcW+4BS5qXxw0pCgzTs8IjhvSTNJiH7cJLapsClQ/rptEwzvN6am2dn83HPouU7gs=
X-Received: by 2002:a2e:9f0f:: with SMTP id u15mr14071964ljk.54.1567360538439;
 Sun, 01 Sep 2019 10:55:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190901174759.257032-1-zenczykowski@gmail.com>
In-Reply-To: <20190901174759.257032-1-zenczykowski@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sun, 1 Sep 2019 19:55:27 +0200
Message-ID: <CAHo-Ooy_g-7eZvBSbKR2eaQW3_Bk+fik5YaYAgN60GjmAU=ADA@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some background:

This was found due to bad interactions with one of the few remaining
Android common kernel networking patches.
(The one that makes it possible for RA's to create routes in interface
specific tables)

The cleanup portion of it scours all tables and deletes all relevant
ADDRCONF routes, which in 5.2-rc1+ now includes ::1/128 and thus
terribly breaks things (in the Android Kernel Networking tests).

However, it *is* a userspace visible change in behaviour (since it's
visible via the above /proc file),
so one could argue for the above patch (or something similar).

The Android patch *could* also probably be adjusted to handle this
case (and thus prevent the breakage).

It's not immediately clear to me what is the better approach as I'm
not immediately certain what RTF_ADDRCONF truly means.
However the in kernel header file comment does explicitly mention this
being used to flag routes derived from RA's, and very clearly ::1/128
is not RA generated, so I *think* the correct fix is to return to the
old way the kernel used to do things and not flag with ADDRCONF...

Opinions?
