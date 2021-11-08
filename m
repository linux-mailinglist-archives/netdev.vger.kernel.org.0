Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334E54498B1
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhKHPsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbhKHPsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:48:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE13C061570;
        Mon,  8 Nov 2021 07:45:19 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso187644pjb.0;
        Mon, 08 Nov 2021 07:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=47NOo4wKKqjtmAdvJNWlYtKk9khtXB3NAG7aQmF+Mqk=;
        b=hawOeSsCxIoVcKyRuv1+I454mJBwAmPSIlhvo+eB0ZOvyZ6Qnn3Ts27AYcQdlzWUik
         RxFCoZTb0gMf/v8vVt8bcOho0YgDr6OuzQfAHs63m9O6H7TBY7v1uDCC3eKz17hcWoxT
         rLmQfeBps00V1bipHV4eLToHyp1jWjj5wGjcwun1pCPgOPdbb7U11FvuHgh7UrpB3xDz
         6jvlF2w4d5DDOGnlABKd9P3LbMutUA+fe6RmQ6YFq+kiPEg2oKYuGGXDjrNUN1frfx08
         ZC8QfaYlbHlQOy9yvPIGWdBmj/FYz5Twm4hSkStR9IVpPwx0EAT33pAlxNVmeRSUeQh1
         rFtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=47NOo4wKKqjtmAdvJNWlYtKk9khtXB3NAG7aQmF+Mqk=;
        b=KvaUNimHh2YmnVXecbEg0ndpZ7otF8hY3E+QLZUqntx7j1WfoMhvrO+bqMc+VthoRB
         t+lmuJNXl/94C6VdOf10JicXujZuQvDDtooa6mSkBUN88ET7s2LHDvq0crZzlo+JBkQc
         59MbxwLVROAQPU1MamVzUkfgXWLUSRd125uPsraXmn3bhUjWox6ObY5EjAlXSAH7D816
         7eC9yGy0RbOR/hcAeRfy3E6MS+5kHPNr6emnqyKrmwRwNSc7LQVX3j5SrrJ6q2ttuLbK
         uGDrFNpnvn26+KvPTPJJyGI5dmNfpkSlTVfqJVaOFfaPMhw1AbIKJXHMzT8HAJA2tNwB
         bp2w==
X-Gm-Message-State: AOAM5333tcMTvhDLLHRFiPNxmWhGlw92081io+xVxbyQR0gD7dqUMcak
        L5w1AylUjM0PBxilaFIoemYo69UlnqCCCA==
X-Google-Smtp-Source: ABdhPJzG/N7eva+wJpQXudV0HA32aZoNw1VhacJD2w5DrE7i+8FhfO+Rjwhs/wlnr+1LW9i+StDJGQ==
X-Received: by 2002:a17:90b:1b03:: with SMTP id nu3mr45321100pjb.240.1636386318750;
        Mon, 08 Nov 2021 07:45:18 -0800 (PST)
Received: from smtpclient.apple (pdf876064.tokynt01.ap.so-net.ne.jp. [223.135.96.100])
        by smtp.gmail.com with ESMTPSA id n14sm12785227pgd.68.2021.11.08.07.44.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:44:45 -0800 (PST)
From:   kaz1020 <kaz1020@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH] udp: fix integer overflow while computing available space
 in sk_rcvbuf
Message-Id: <D4E91882-A53B-44CC-9741-14B19B863C9F@gmail.com>
Date:   Tue, 9 Nov 2021 00:44:14 +0900
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
To:     Antonio Messina <amessina@google.com>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Antonio Messina at Google,
Linux Kernel maintainers,

I read the following fraud Google Blog.
=
https://cloud.google.com/blog/topics/inside-google-cloud/google-cloud-supp=
ort-engineer-solves-a-tough-dns-case

I require Antonio Messina the fulfillment of obligations.
Antonio Messina accepted the following requests on June 27, 2020.

I requested Antonio Messina to correct his mistakes.
- Rewrite the article on fraud Google Blog
- Send the new patch I proposed

Past, I explained the following result to Antonio Messina and Google.

Abstract:
The =E2=80=9Csize" variable of the following line will be removed.
Line: https://github.com/torvalds/linux/blob/v5.4/net/ipv4/udp.c#L1478

Because comparing "to be allocated buffer size" and "Max buffer size" + =
"size."
Antonio Messina's mistake: if (rmem > (unsigned int)(size + =
sk->sk_rcvbuf))
The fix I propose: if (rmem > sk->sk_rcvbuf)
=20
Details:
In the function __udp_enqueue_schedule_skb.
- rmem: Same as sk->sk_rmem_alloc.
  -- It means allocated or to be allocated buffer size.
- sk->sk_rcvbuf: Max buffer size(purpose to limit the buffer size).
- size: Same as skb->truesize.
  -- It means a packet size.

The original problem is committed by:=20
=
https://github.com/torvalds/linux/commit/363dc73acacbbcdae98acf5612303e977=
0e04b1d
In addition, the condition sentence has been corrupted before this =
commit.

Antonio Messina sent a poor patch:=20
https://lkml.org/lkml/2019/12/19/482

--=20
Fix it,
kaz1020

