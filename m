Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF451EC19A
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgFBSFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgFBSFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 14:05:07 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAE7C05BD1E;
        Tue,  2 Jun 2020 11:05:07 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j8so11769134iog.13;
        Tue, 02 Jun 2020 11:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qi0HjvbuXmvWcbpKL9tqxqxdG7EHQ6ate3lS8JMnsis=;
        b=n6SisKMzEskMMswvWF8T1MVJaEjU+M2p9WlOTCsTOkAMXSX7jjvFckywiWVsDYs2U+
         kODUOFnwU53QHETCwHl6+t0CaXWQPRDgdAsmWdmRsjEtGETkyAlwMz13gBQpP3QZLOIv
         hXMWI1WeQgeZYxAGlNUpnFJ4DHSmfyxhK5GoPELm45lW70eeqtaBUrVhWny4fmNh4gmB
         tP+mUQwKTPdpw38XlJ4LPbq/dtZksPuqnqcZhDwoqt+kRsKZAfxm5jwzcJ6c9xLsw4Vn
         nvQ7d+KwBNHfzTG6fnCfsGF0tKbmfWR17/Jv9AnV0z1cLRTDFgTEL0Tnyh1WpCJ0vlO4
         SkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qi0HjvbuXmvWcbpKL9tqxqxdG7EHQ6ate3lS8JMnsis=;
        b=GuqSAdvOV7DlmbuH+ls6ZGPyDaYtCBgQ8Cdt5KYBkTRGrM1SI4cYsuWrtErytUYwH9
         gXV7PQmSbVx8uvE5wXeohugTA2wyOQma3pFFRGJOz9Xvnl97uxnP/2PTNgRB+gMqi0x6
         yVFbN4PVvrlVDLQOyE/ICTu94kIhfXNtIskPaJ/OQ0f5DpDTOFs4OEP+HvnuEBiLGByJ
         qlPICQw3BPJUd+qqN8qU2lX2LCvMbNk4EDoOuRj3sGy6Ivyyc2S7WdKMqBIsMX1axqmh
         Asy/hxqKY/hZtDzvIPZL6gwGDHTY1Eoa1c0T5T7quw5L/mwpr3iU8PtFMN/68Kd3qxuE
         hxFw==
X-Gm-Message-State: AOAM53061Fdp1HSs+o0GCpA4h9WyfVeSVbTt4evQfL1Q5jZF8id4AbXG
        WsBMs9Jj0GvYEDDF2gkPpv/t1VcabMwr9FIjUbk=
X-Google-Smtp-Source: ABdhPJyonPyd5t+XvdQnqO2DVdloB9jkKGUp6lcECpSjq4TtuP0PsbQTgx66Mb8Kw6pkFBpx+vmXjKtzILYqu6/rG5Y=
X-Received: by 2002:a05:6602:1204:: with SMTP id y4mr525321iot.44.1591121106733;
 Tue, 02 Jun 2020 11:05:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200602064545.50288-1-yuehaibing@huawei.com>
In-Reply-To: <20200602064545.50288-1-yuehaibing@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 2 Jun 2020 11:04:55 -0700
Message-ID: <CAM_iQpXtsvewiN3bmfJqwuURN--aCkaR7N6zfYWf82KmFUZnLQ@mail.gmail.com>
Subject: Re: [PATCH] net: genetlink: Fix memleak in genl_family_rcv_msg_dumpit()
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 11:47 PM YueHaibing <yuehaibing@huawei.com> wrote:
> @@ -630,6 +625,9 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
>                 err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
>         }
>
> +       genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
> +       genl_dumpit_info_free(info);
> +
>         return err;
>  }

I do not think you can just move it after __netlink_dump_start(),
because cb->done() can be called, for example, in netlink_sock_destruct()
too.
