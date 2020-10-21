Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6690A294610
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 02:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410979AbgJUAhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 20:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393635AbgJUAhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 20:37:34 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813F8C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:37:34 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k6so889237ior.2
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 17:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Xcu3fvux0WV8tRhV0Rr1n4eCBvn0t9r2Un3hKFR37w=;
        b=GC5zJRQBFeiTRle8NWkpEHtykfsG81EA8hqzVa8Vwx8HfsVE8hYJyiocfDXAy2tQkR
         0kx6ftE/hp2iQQ1vJRkLWMpqTD4D+yqHfTLsKuoq9FRJEZszQx0vnKCQXCYWaXUCfYKM
         O5unJejMm2K/D1hCx5fXL1xeZhyN1CxpT1tQZeXa+Xv9iLieY92U+fjU4nHHcUTkAUg6
         p/rB5V/uWbOqk9Xa9kZdmP6vVx95B2KZytkcJcZlug6ZnhSKtCRjofNXcRu4GskXzD9n
         zZ5y8I1nsmqsXq31/pp7Byw1wy6AK+uaGVTNv+S0MMK9LmsMlR6EVBftIt9sewWr8lzv
         0lQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Xcu3fvux0WV8tRhV0Rr1n4eCBvn0t9r2Un3hKFR37w=;
        b=VAw2u9XEgnY9WKFWnUh90r8lb7f9Ag+psqrGPPFa+Is3YRhNiHHLee7FLX40HS5feE
         n2SbwgMgf/1rmbebIGkZ4iceNfVZfX4j4BIL3N7Dz1lWV9/p8hFi/ruoe/4GPjOziid/
         8Mcx9RoRSoK9swubX2Osl9Aq5f9xpHArAZp0Tb/u6eeIaQXlPOYgvdaRzRsbzrzNNcBb
         6C3S5Gm4KgADPRYjGKDk01+O3eEbMly+lGNh/D8UzaZlWo9aOmedP9RSjkdnVV8Qy50o
         ZuJ0PyNfOQX+YSpD04DEqJdPrZNPanYj/eTUOf+EineNaCQIB8okX3d99b37fGByJXs4
         RtYA==
X-Gm-Message-State: AOAM530ECTyzF9RzbQfb61AGUd0MxzY6ihoXjeSC57FLdVjZJ1yvO2ob
        4qft3Izyxj5+uwopU8M9r/T4z3d5NbtlnU3czxU=
X-Google-Smtp-Source: ABdhPJxXAA5j+AVg+t6GlYT4hxKLBuwGQInPz1tvsb7l0WS/2vQQi0tbHVtCTW5e3pZJTG3afKnlNBqBRgfK2V3hPIU=
X-Received: by 2002:a05:6638:12cc:: with SMTP id v12mr739969jas.75.1603240653445;
 Tue, 20 Oct 2020 17:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <12f60e385584c52c22863701c0185e40ab08a7a7.1603207948.git.gnault@redhat.com>
In-Reply-To: <12f60e385584c52c22863701c0185e40ab08a7a7.1603207948.git.gnault@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 20 Oct 2020 17:37:22 -0700
Message-ID: <CAM_iQpXEPshoMYc5hkePa85T-H5uP3EGfHFRSDDqYrLuuB-bbg@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_gate: Unlock ->tcfa_lock in tc_setup_flow_action()
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Po Liu <Po.Liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 8:34 AM Guillaume Nault <gnault@redhat.com> wrote:
>
> We need to jump to the "err_out_locked" label when
> tcf_gate_get_entries() fails. Otherwise, tc_setup_flow_action() exits
> with ->tcfa_lock still held.
>
> Fixes: d29bdd69ecdd ("net: schedule: add action gate offloading")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Looks like the err_out label can be just removed after this patch?
If any compiler complains, you have to fix it in v2, otherwise can be in a
separate patch.

Other than this,

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks!
