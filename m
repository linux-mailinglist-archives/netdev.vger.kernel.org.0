Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0114818C2
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhL3Cme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbhL3Cme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:42:34 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAD6C061574;
        Wed, 29 Dec 2021 18:42:33 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i6so11235521pla.0;
        Wed, 29 Dec 2021 18:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=CkdisBqkP9QY6O7Qm1g7pZN4sah5N8XlOzMRgORCtHs=;
        b=DbePz3/YgWOuiEOsju2kgkSDgaQl1GHn5vZeb6v8971Fvc5xFnVIF4nBBHZ85I0x2j
         a8ckQuFXHcyx9OJitWCzCycUnqTeP/vrr0gVixHrWvrLgI2apyxMz1ZT1+LiB0Ut6dfA
         mu0Zjk7TEV5OGniOHqGiBix4ZtkamaQmk0/AtSc7OSxp+ojtyj1iCLFx1xNrSYO7uWjm
         56GnOZBwJ//oT/XDlGLQGcLD/qLMkUuq6vz3AXEY5LYgVyQswHbMX4I0z40kC6Mn/ipy
         Nj49Lyncvp1WX0JBS0EHhEXtP4kZCdd67m8//Grr4q78cFP/10lczX5U/ISdFeoPJj7Q
         G0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=CkdisBqkP9QY6O7Qm1g7pZN4sah5N8XlOzMRgORCtHs=;
        b=x93LP9JtdNqnePYNMQsZEE4GAKu8GsRfSzVgDl5Eh2Oo6Ool/CrbMi5YWuOauRMBKs
         ucNMrJH8fqSGy21mYGG/tsj4zBhdX7z+QbMCDf57aFF+Mf5MiZ67ibpChCvEwOTm8Tqb
         e5CAkUepLjBfVdF4MqxNXW6zJTHZrDKl1mQzF6CHNHAPc1OrAja9PhH/GWoKQh+Q/kcv
         ef7j4zvhmXqy2WvCx5iESGS5chLnhhD4nvOpuAQhL3qp7Jd0ZEGpsCet7/rcrSPIn4O0
         aGToKJcsB060IoPyDfMn0gi9girqBdvBJ+eJR6cgrgoBgTQngKvtcuenP8NqrCMtiHda
         DjRQ==
X-Gm-Message-State: AOAM530GNcl/G0l1DXdKo344zITyZJ6j69lcYCWccI/j2taB4Og3C8Cr
        MyRTlSNFe7nzKsni3WlhZ2Xt3M94NiSvOwxv
X-Google-Smtp-Source: ABdhPJzMi8uqiy41c9i26WynsPiKdkTLCnnat0lx1z0+RE3WG7/p4H1KJqOsnA3zykg7OaD5fXHHRA==
X-Received: by 2002:a17:902:dac8:b0:149:2d42:2f81 with SMTP id q8-20020a170902dac800b001492d422f81mr29481094plx.78.1640832153416;
        Wed, 29 Dec 2021 18:42:33 -0800 (PST)
Received: from [30.135.82.251] ([23.98.35.75])
        by smtp.gmail.com with ESMTPSA id ds24sm26049552pjb.36.2021.12.29.18.42.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Dec 2021 18:42:33 -0800 (PST)
User-Agent: Microsoft-MacOutlook/16.56.21121100
Date:   Thu, 30 Dec 2021 10:42:28 +0800
Subject: Re: Lock problems in linux/tools/perf/util/dso.c
From:   Ryan Cai <ycaibb@gmail.com>
To:     Namhyung Kim <namhyung@kernel.org>
CC:     Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <64E36F38-E037-4561-8E0C-B288674A5BD9@gmail.com>
Thread-Topic: Lock problems in linux/tools/perf/util/dso.c
References: <4C0186FE-729D-4F77-947D-11933BA38818@gmail.com>
 <CAM9d7ciroZswudPXAAs9Zo3_veFMugJJZ4XZWhGSKHdFPcDOjQ@mail.gmail.com>
In-Reply-To: <CAM9d7ciroZswudPXAAs9Zo3_veFMugJJZ4XZWhGSKHdFPcDOjQ@mail.gmail.com>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Namhyung,

1. Indeed, I got wrong here.
2. Yes, the branch should be if (pthread_mutex_lock(&dso__data_open_lock))=20
instead of if (pthread_mutex_lock(&dso__data_open_lock) < 0).

Could I send a patch?

Best,
Ryan

=EF=BB=BFOn 30/12/2021, 3:08 AM, "Namhyung Kim" <namhyung@kernel.org> wrote:

    Hello,

    On Wed, Dec 22, 2021 at 3:33 AM Ryan Cai <ycaibb@gmail.com> wrote:
    >
    > Hi, I found a potential lock problem in dso_data_get_fd. Because the =
inconsistent branch conditions of pthread_mutex_lock(&dso__data_open_lock) a=
nd pthread_mutex_unlock(&dso__data_open_lock), it is possible that the lock =
dso__data_open_lock is not released in the dso_data_get_fd. Also, I have a q=
uestion on why the branch condition of pthread_mutex_lock(&dso__data_open_lo=
ck) is <0. I think that the branch condition should be !=3D0, because pthread_=
mutex_lock would return 0 when succeeding. Looking forward to further discus=
sion. One this bug is confirmed, I can send a patch.

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
    > https://github.com/torvalds/linux/blob/e851dfae4371d3c751f1e18e8eb5eb=
a993de1467/tools/perf/util/dso.c#L708-L722
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


