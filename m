Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A853D105AF4
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfKUUPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:15:54 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32785 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfKUUPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:15:54 -0500
Received: by mail-lj1-f195.google.com with SMTP id t5so4729882ljk.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 12:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBpxNEsW80NMBZq67P4NBKZ3FJiVVLjktDlpoy0+cp8=;
        b=eO1NIlVq+l8WGWgrWwiAydh1RPruP8x16K5vJmK7nCBgkcX6t7zoIDEArJCI/U5EJn
         9mNBAsGab2tIWnCsfIPsGkAr8ZdaEiSr8miBFIRredaByIrA/H0RnMagZVuam8XN1dSc
         3AM3UnAjheYgowe/PJGynXP6bR3jg55zvlwXQXMBtBo83WDPa9RpOpFznCRCqt22YEwB
         O/aFikOvDYR13Tfc+J1aziHU5OEqTgJf6hEz6haIt3w/4ZXLWVX79jUkW8LaYMdGQwap
         +cbraKmRxl8dTxrniGwoFw4hGGYAOgLfokLLabqWDrLI+JLiVXd7JZLLFPz8M0pyeRpq
         TMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBpxNEsW80NMBZq67P4NBKZ3FJiVVLjktDlpoy0+cp8=;
        b=noaKiXRyObtWJlQxu0UebG/RR9/8H6MXarU6shUtFraEE6F2vuijjaLPg5RyfzB0g0
         kcpSU/i5yaml8VR8YQEmyOYWU4oYHNPl+I+tUwSoK4uyPfC6gFAt+NerrlDn1OK17w8T
         729ZYOq47XyvkqedJNlUHkmov3g13Kbkancq+FSBpSTOvfxX/xhKZpAdKkRq34c3mauj
         MkDnyYNd1t5/FlByTjNzZGpgjXiJ695q9jHpq/R1GqbT7HuWflNJHsEm4O3cY6Lt3kUK
         76hRMT6YsGX6U8YRMFKI5jJGwZw8Ha4Qn5Q58eI09R9bPZQbWyOTmXnWbQPPWE72a0Ip
         SLwg==
X-Gm-Message-State: APjAAAXlU+/0qdCC12/XT24KVM0yZN4m2bK6w0eWVocfrl4zDImUQl7A
        EwvmanzwbURuDauDZW6VXqoJaNXmKBeteACsSuQ=
X-Google-Smtp-Source: APXvYqytH+TuJLnZCPB4tqh91CujBjvcS+YSokiZ1cILEifmLpYS8uZjn2nBUg76Ejxo+UzJuP13dZTevW2vDx+021g=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr9049994ljn.188.1574367352158;
 Thu, 21 Nov 2019 12:15:52 -0800 (PST)
MIME-Version: 1.0
References: <157435350971.16582.7099707189039358561.stgit@john-Precision-5820-Tower>
In-Reply-To: <157435350971.16582.7099707189039358561.stgit@john-Precision-5820-Tower>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 12:15:40 -0800
Message-ID: <CAADnVQLX3U4uSASVeha54oZsgi6DhNuYSXyW6=uKuf=ijC5vdQ@mail.gmail.com>
Subject: Re: [net PATCH] bpf: skmsg, fix potential psock NULL pointer dereference
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 8:28 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Report from Dan Carpenter,
>
>  net/core/skmsg.c:792 sk_psock_write_space()
>  error: we previously assumed 'psock' could be null (see line 790)
>
>  net/core/skmsg.c
>    789 psock = sk_psock(sk);
>    790 if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
>  Check for NULL
>    791 schedule_work(&psock->work);
>    792 write_space = psock->saved_write_space;
>                      ^^^^^^^^^^^^^^^^^^^^^^^^
>    793          rcu_read_unlock();
>    794          write_space(sk);
>
> Ensure psock dereference on line 792 only occurs if psock is not null.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

lgtm.
John, do you feel strongly about it going to net tree asap?
Can it go to net-next ? The merge window is right around the corner.
