Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843CB481625
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhL2TI2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Dec 2021 14:08:28 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:37466 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhL2TI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:08:27 -0500
Received: by mail-lf1-f47.google.com with SMTP id h7so5299785lfu.4;
        Wed, 29 Dec 2021 11:08:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=P/Kf43UjqUP/N5HQm/X7M4mBr0x9sX9Oqu3K1SkYXqo=;
        b=z2KB5qvBMZ6du03HdjB4UEcnhIUcvQJi9PcySjfr88ChvdOSbUJhEh3qpGcc6h2Ui2
         Nv9uqxgv2pqLCUC+bte1OCgJxOpiz3biHIaKZR4V4majtganA5EtjM5MoMkOSmm0Lgao
         O4+fZ+CgX/ygcE9D2x+c4NJwZWytqU2yXBuFIpfA2NslnD5WBolnm5xUZsl1HzRqLoqn
         O+rEAlYSz2Fsh65aF398iOKPqx2EZTfZ8HCCM3gyPHK40bGiZruHvDpSzE/OWsDjPHuB
         C/dAOwQ+qRkJyHH7A8+67ZiidB/zJz2KBhoLrT0kJFOlNPdkovWiRIUxBUa8tScbOtlf
         xSHw==
X-Gm-Message-State: AOAM5316npTZAxH1PKtEoc6IlrrkleCfsg8KEMwoOkJKLGeA3w14v/cd
        6asWTw+/qAWQ6aAg6aEYrVb4atqDce3OfV1kPuk=
X-Google-Smtp-Source: ABdhPJwXaymitpdke/dqffchjdtq4qMJI4MSalF50WjbX6Ae08W7V2AW5SLEMQIQbv3p+7TbyERdj1EqdFfFGTngBrI=
X-Received: by 2002:a05:6512:3d21:: with SMTP id d33mr25055113lfv.481.1640804905781;
 Wed, 29 Dec 2021 11:08:25 -0800 (PST)
MIME-Version: 1.0
References: <4C0186FE-729D-4F77-947D-11933BA38818@gmail.com>
In-Reply-To: <4C0186FE-729D-4F77-947D-11933BA38818@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Wed, 29 Dec 2021 11:08:14 -0800
Message-ID: <CAM9d7ciroZswudPXAAs9Zo3_veFMugJJZ4XZWhGSKHdFPcDOjQ@mail.gmail.com>
Subject: Re: Lock problems in linux/tools/perf/util/dso.c
To:     Ryan Cai <ycaibb@gmail.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Dec 22, 2021 at 3:33 AM Ryan Cai <ycaibb@gmail.com> wrote:
>
> Hi, I found a potential lock problem in dso_data_get_fd. Because the inconsistent branch conditions of pthread_mutex_lock(&dso__data_open_lock) and pthread_mutex_unlock(&dso__data_open_lock), it is possible that the lock dso__data_open_lock is not released in the dso_data_get_fd. Also, I have a question on why the branch condition of pthread_mutex_lock(&dso__data_open_lock) is <0. I think that the branch condition should be !=0, because pthread_mutex_lock would return 0 when succeeding. Looking forward to further discussion. One this bug is confirmed, I can send a patch.

Please fix your mail client to wrap around 80 characters.

1. dso__data_get_fd() should be paired with dso__data_put_fd()
   when it returns non-negative.  It'd unlock the mutex.

2. I've checked the man page and it seems you're right.
   It just says that it'd return an error number or zero.

   https://linux.die.net/man/3/pthread_mutex_lock

Thanks,
Namhyung


>
>
>
> https://github.com/torvalds/linux/blob/e851dfae4371d3c751f1e18e8eb5eba993de1467/tools/perf/util/dso.c#L708-L722
>
>
>
> Best,
>
> Ryan
>
>
>
>
