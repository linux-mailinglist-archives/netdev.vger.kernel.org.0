Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE4244DAD0
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhKKQ4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhKKQ4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:56:40 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267C1C061766;
        Thu, 11 Nov 2021 08:53:51 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c4so10834830wrd.9;
        Thu, 11 Nov 2021 08:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/jrnoVf+n7YqwtxXnwP3VKh9fJI/Dke/6law9LGVWwU=;
        b=OERyfw8zJ+LWGdkqDxo3O2Fghfv7CjJ1eDoMNUYGfhG61LdixHD/muosa3dexgCQ80
         KdutXfIGKCnH5rmkU1dfJhRXTEWZgIOJZFNIoSLFzo4/C7dbdAgidsfXlqsAkXysjNPB
         02Q3zCd9m4/M9NPsuUo21ROwHxVh1JKvmuWcOQTj3DRm7JRZI3Fc6SPf7BEtSm5YY2+7
         74neldIqCBqJIXAJrTP24aXfnDC57vwUyS0KsLcOqKGxslPUjwaBJiv2cmtpL3gm7Uur
         W77JEep/dSzE/wiAaQ9e+fUXYC8XPt3xu4XC6L5ZdX3YMM4uikCvD0NFT51t4lkaXfhv
         sOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/jrnoVf+n7YqwtxXnwP3VKh9fJI/Dke/6law9LGVWwU=;
        b=wismYqNxrZqqD5sJ720Tz+19qzxh+BIOP2jW1mhbDqKvhKa518qt+DMleGG2LM1h+2
         yuLMtMy+P1wb8lNyKoVnNL0vJwermZ6/YJv8yLK9Q+Val9Bu9mKU9o8EMh9V83HXuSjO
         NSUdbW/FnpifNK4AfBigaUnkpz2ei3RMTAYl4LLB7QU7tCMvMqtqF3GZ1t5Jh+H1QkJT
         ffJrnDB0lXuuQVjBfuSwGoTTKz0+PtnbziDTGdNPWXC+9OsfFHIy1Awx7KHml6lJ3rcn
         NEUkdK2ROdMJIiUFm3x8lgBOBfXMoGd/rb6i9c5AZEIfg60Mj7A+/h7s+Xb1UAyBJ/CT
         fpVA==
X-Gm-Message-State: AOAM530nTE4ya98khxMEGkqiSQXhDwnfIf1OhveV1fQBk6+EvAj2VOHA
        KriA+sj5RW9bG9+HmDTsY+HimQkGzBjo/iVx/AE=
X-Google-Smtp-Source: ABdhPJxzJBafNVhaTumUIXJSTqjdtXpwb8dSAszYOloMr9pBIq9rL/EjRYPgL2F9UkvIbaUwSKmpECTl25hUOa2HZD4=
X-Received: by 2002:a5d:648e:: with SMTP id o14mr10335737wri.141.1636649629731;
 Thu, 11 Nov 2021 08:53:49 -0800 (PST)
MIME-Version: 1.0
References: <20211111075707.21922-1-magnus.karlsson@gmail.com>
In-Reply-To: <20211111075707.21922-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 11 Nov 2021 17:53:37 +0100
Message-ID: <CAJ+HfNju+_PC7nYKqJk6TqK6vSxRXAOd7Mb7a2wkhaqpbfkOAA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix crash on double free in buffer pool
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 at 08:57, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a crash in the buffer pool allocator when a buffer is double
> freed. It is possible to trigger this behavior not only from a faulty
> driver, but also from user space like this: Create a zero-copy AF_XDP
> socket. Load an XDP program that will issue XDP_DROP for all
> packets. Put the same umem buffer into the fill ring multiple times,
> then bind the socket and send some traffic. This will crash the kernel
> as the XDP_DROP action triggers one call to xsk_buff_free()/xp_free()
> for every packet dropped. Each call will add the corresponding buffer
> entry to the free_list and increase the free_list_cnt. Some entries
> will have been added multiple times due to the same buffer being
> freed. The buffer allocation code will then traverse this broken list
> and since the same buffer is in the list multiple times, it will try
> to delete the same buffer twice from the list leading to a crash.
>
> The fix for this is just to test that the buffer has not been added
> before in xp_free(). If it has been, just return from the function and
> do not put it in the free_list a second time.
>
> Note that this bug was not present in the code before the commit
> referenced in the Fixes tag. That code used one list entry per
> allocated buffer, so multiple frees did not have any side effects. But
> the commit below optimized the usage of the pool and only uses a
> single entry per buffer in the umem, meaning that multiple
> allocations/frees of the same buffer will also only use one entry,
> thus leading to the problem.
>
> Fixes: 47e4075df300 ("xsk: Batched buffer allocation for the pool")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
