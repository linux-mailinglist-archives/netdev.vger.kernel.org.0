Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA564C36A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfFSWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:04:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43488 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSWEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:04:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so380749pfg.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=61AE3NKk3O/0cC9boRaWBE7LK+dRUE1NfUk/JYgURCA=;
        b=eQtj7Bi0YOXADstFCrU5VnWwrCnxbcTFfM0k5/C6OIkNtvXWn3Fy6Vz7VkEef07jZS
         UdI8TGbRBrAhvkRnfqxg7BIogX8XAP+P/dblxW/bfkplC5gjtYQerkww1y6BBXed6qCN
         Yjqr0lCn+bKsa6CXGuux3tO3mCccn+J+Ibo3XjvrV7sjpNsgDaQkH+nHV3BWT244pz27
         KWkth2HbDGHBhizB3bNND6nNq4RI/c77uwggwnK6SNo8kfGujJF43W3ng2Y14CFAV6nu
         4GPfQwhmBdHKKK41uLzjk4RkTYBoSAJ4oJXmU51qQDe0YAwMIt+UTNfQTfkZPurcwYO6
         CHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=61AE3NKk3O/0cC9boRaWBE7LK+dRUE1NfUk/JYgURCA=;
        b=DSm1sCBvIXnU9XO60On9ra4dWXu23o//MJcheBu+nJUj0ZjQEsHQ7tgkZwgriaEueF
         xFkx9LRO7goiMh9ECs6lYyPqO1FgzRo+z2IdETOLpk8iyf2shbwd6zyz5tP7/NTeCG01
         leymxZ2tXleyapGRCYgGry28XrbsK07ISIf0AC5XaEo7QgOXAnMe3UGgn6VTVx8MEaXW
         snURbZc9N8yk1/zY+f1dITc3H1Bbdv14bFnuzJaztZQ9agNTAv7iHyVCAv6mztXT3vvn
         p3UMOADuoY6UiMYQdCJ1d3qHHdylIMBPtupxil1b5l3rFWTZmMBGedWjQmZKr4JvRRIl
         YBIQ==
X-Gm-Message-State: APjAAAVwSWKIabJ7JdwJkjenQ9z6x6QwYScDMm47CwWl9Ms2/ZPGMGbF
        9Ji6/rzomAUGbfBnnRDrvPonStPReXb32zaJFsM=
X-Google-Smtp-Source: APXvYqwwJAn4OJ69yLLsFL8e6CY2Y2TBzWA6xr1U+UxwybqpGvze3bSkLjFFfs1AjS3rtbQeFnT26HE04DDxh/N/5N8=
X-Received: by 2002:a63:d748:: with SMTP id w8mr9511169pgi.157.1560981864437;
 Wed, 19 Jun 2019 15:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
In-Reply-To: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 19 Jun 2019 15:04:12 -0700
Message-ID: <CAM_iQpUVJ9sG9ETE0zZ_azbDgWp_oi320nWy_g-uh2YJWYDOXw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lucas Bates <lucasb@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 2:10 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> on some CPUs (e.g. i686), tcf_walker.cookie has the same size as the IDR.
> In this situation, the following script:
>
>  # tc filter add dev eth0 ingress handle 0xffffffff flower action ok
>  # tc filter show dev eth0 ingress
>
> results in an infinite loop. It happened also on other CPUs (e.g x86_64),
> before commit 061775583e35 ("net: sched: flower: introduce reference
> counting for filters"), because 'handle' + 1 made the u32 overflow before
> it was assigned to 'cookie'; but that commit replaced the assignment with
> a self-increment of 'cookie', so the problem was indirectly fixed.

Interesting... Is this really specific to cls_flower? To me it looks like
a bug of idr_*_ul() API's, especially for idr_for_each_entry_ul().

Can you test if the following command has the same problem on i386?

tc actions add action ok index 4294967295

It is hard for me to find a 32bit CPU.


Thanks.
