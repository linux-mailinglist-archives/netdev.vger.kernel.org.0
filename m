Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF0713B174
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 18:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgANR4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 12:56:41 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42492 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgANR4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 12:56:41 -0500
Received: by mail-lf1-f67.google.com with SMTP id y19so10519780lfl.9;
        Tue, 14 Jan 2020 09:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPWJdi3h+k3ll4VHkUcyylibSdYlZmPp+gTxjxeUpPM=;
        b=GDNtU9XP9k3jXbZE3lwbBShQ6dc1dl9RkKML0QiXyauyADihQDV4xPpmsltnZu2W8A
         swTyO3Obl3xkyuBv17kfsicJHIz+bL3SsgEOm5wQHvSf6IoiP37LjoUZY0dyUBc4OMoE
         xLLOUHThstFUxPPX8mkGh9oaXggBfACfmdNIqRQvW2Ox7bVKKRVqCt63tsjqwyhkJ0GK
         Azo5mbXqulV4zvCxj3dN9f0sP9D+Q5mSYv84go4s1XcciJZy/ur4mCw02NwozR+ZGn24
         3CJvYouFLWh048dTXa7K5yU133LmlV2os3QFeOFjUdLX7NUnEh7AWmfE/rHYxOZgr85f
         P54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPWJdi3h+k3ll4VHkUcyylibSdYlZmPp+gTxjxeUpPM=;
        b=YJz2s81sFjO4g20xhtqQtOiDDh8Q3a2FH0VPHD0bSI4vU2CvBTDk8yC9t9S+KuGQbb
         duajv+YdzOXirGXffKr1cQGKtFTAnkWBkprXYfWhqCC8jJxJrwnQxv6ag6a7s7kA0lGc
         bNrf8J1UsFKUKRx25AbunZ2g7uty4iQPaAFPaIF1ollvRvD3gLJFpf55qIMrtUtJxFJc
         396+HxWhjk+0FSN9ULUQzd9Yb6W61ky4SyXs36FR5QnaiRM3noOUzZhTDL3nWHI7VKUt
         9k9FbTMchN0GrrsstXDvBkMInNmVl9pnlD1aGqRVlyp/uHjkFgEx5hTQgTpgciC357XY
         r7+A==
X-Gm-Message-State: APjAAAW43uIh4qmLvmqijh66D2ThihAFB8VRKCc/pUj9U4xcnky9+PJG
        2jRxYCuJRq0PH4C9I+zvFWVfuac2cPa81Dng+HE=
X-Google-Smtp-Source: APXvYqxnTbxqgzZjOX56lQqZR0Lie4BpfYSvVfU/j1vo4N+7qK0y2vKDigNBoOyKuRDR3uI8tXA8MPC6U6jXLira420=
X-Received: by 2002:a19:2389:: with SMTP id j131mr2292989lfj.86.1579024598914;
 Tue, 14 Jan 2020 09:56:38 -0800 (PST)
MIME-Version: 1.0
References: <20200114072647.3188298-1-kafai@fb.com>
In-Reply-To: <20200114072647.3188298-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jan 2020 09:56:27 -0800
Message-ID: <CAADnVQKVFAHdXw+6qXtKSjyD9RN++_12+YXkcudjOeRCq=JMhA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix seq_show for BPF_MAP_TYPE_STRUCT_OPS
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 11:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> Instead of using bpf_struct_ops_map_lookup_elem() which is
> not implemented, bpf_struct_ops_map_seq_show_elem() should
> also use bpf_struct_ops_map_sys_lookup_elem() which does
> an inplace update to the value.  The change allocates
> a value to pass to bpf_struct_ops_map_sys_lookup_elem().
>
> [root@arch-fb-vm1 bpf]# cat /sys/fs/bpf/dctcp
> {{{1}},BPF_STRUCT_OPS_STATE_INUSE,{{00000000df93eebc,00000000df93eebc},0,2, ...
>
> Fixes: 85d33df357b6 ("bpf: Introduce BPF_MAP_TYPE_STRUCT_OPS")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
