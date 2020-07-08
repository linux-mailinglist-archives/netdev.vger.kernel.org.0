Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE89218FBF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgGHSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgGHSfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 14:35:06 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1530CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 11:35:06 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q74so24535683iod.1
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 11:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6Jt/db0nRRu8labGsXgQ2Rtc9LooPXYAEH5jQ/E3hw=;
        b=AoxH+C2gf5LZzQLmam1hr27ydbFxZNdJkT4rHXUtBWoggECbnp2rc/06Lz92vKT/3c
         2abQobO1SxYDB65ZFhSSSRH7x95fl5TO73hsad5ou4ELLrjbk8HtSPy+P/jS/KGSa7Wl
         fOGRyZVrfj1Rg/hDCr2kk313TOAb5JEtkNRKbLeAML+Uouf7avEj3QY5PXuhxcfjtQXI
         9cmqRLxw9iT9RgvQuB1lbNddUIeeK9rgiEfiSr67he2AxwqQL/kweSrylddJlaRLRVPK
         vKgEiSIXQeYUNiAKgl6DK16nl379SXuIsv1nkib+0+HkNs25VpCsFPzuW6ph4J+kIwsJ
         /RTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6Jt/db0nRRu8labGsXgQ2Rtc9LooPXYAEH5jQ/E3hw=;
        b=HiBQhlE1aj4JP4JcdDouWnWkbg37w8ZnKn02SAVklmsic5xwwuGmDwdbPe/dcQcMHe
         K0DB/A1mk8xqSwybGBqZHIOLDqJuflIrVUOEs/bWsJ9aoF6GPI31tiqgrsAcXszJnYdr
         QsmobjnsQW80MV9yiuoDrGqR/HVidR9FhvkmHXqrHtQ6LmBjoyn+3M3pJOqsou7IzjUV
         t1H5qUIsG4Q0m/yU0YwYXj6CYxT9af5JXUU2FULKmbEQpqUY6DICRW92GAVc8WqyVcGQ
         2IYn/orNhT4jUJFV19ipJW+kAmSFq3Bk2QzczlCNt3KmceVmn/Vmy9lwWYOBBO1fTMri
         +XNQ==
X-Gm-Message-State: AOAM5307A92Jttl2jeZN0aikFHzsx/t9UWsWIxmDsjFydmNrrYFE2yHa
        ayMeGQcm+lmqwNa8vLIMV5BXF9sY8cFQB2WXhZ0=
X-Google-Smtp-Source: ABdhPJzSvbJjg91ZwH9vEM6RJN8d48a9T3rCarsrL2IfOirJQ/xPB1q+PP/VVVqvCH8Z27VDUnK2AuDQXL2pK+2W4Qo=
X-Received: by 2002:a02:c785:: with SMTP id n5mr68889628jao.75.1594233305407;
 Wed, 08 Jul 2020 11:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com> <20200708153327.GA193647@roeck-us.net>
In-Reply-To: <20200708153327.GA193647@roeck-us.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Jul 2020 11:34:54 -0700
Message-ID: <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Jul 8, 2020 at 8:33 AM Guenter Roeck <linux@roeck-us.net> wrote:
> This patch causes all my s390 boot tests to crash. Reverting it fixes
> the problem. Please see bisect results and and crash log below.
>
...
> Crash log:

Interesting. I don't see how unix socket is any special here, it creates
a peer sock with sk_alloc(), but this is not any different from two separated
sockets.

What is your kernel config? Do you enable CONFIG_CGROUP_NET_PRIO
or CONFIG_CGROUP_NET_CLASSID? I can see there might be a problem
if you don't enable either of them but enable CONFIG_CGROUP_BPF.

And if you have the full kernel log, it would be helpful too.

Thanks.
