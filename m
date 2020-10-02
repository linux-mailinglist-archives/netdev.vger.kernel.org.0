Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD9281698
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbgJBP3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387984AbgJBP3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:29:05 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFABC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 08:29:05 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id h15so505621uab.3
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQDT3b8p4hRtwZcJ569A8zwY5WqTq2A+qNs3Lj1qD0E=;
        b=MYEhJuEIJfR8ol8p1IffE81euTsrHL7DeW6fgy9eBG5jI6asIT5TG8OcPT8P1UuOUx
         zLNJFA9Mejd0nKdaKTqx47ra+1XPfgZS0VFpzzYtW25+1G5lBi72k6bC4vJc9FznWc/Z
         AiTz7T9QK1lwR46FnW9Z097CAa01t9mITj1W0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQDT3b8p4hRtwZcJ569A8zwY5WqTq2A+qNs3Lj1qD0E=;
        b=dfMwqE/jbKpvvXCtSlZaZ8JXEwV/ofwzYx3MGc0XpxVhhdrR7C28TyGc7FMbot3Id7
         +EVeXwljNy+psoqTryDi7QlfAVZuaqvm1x2yVodN9TTqTjUMcMx21Nl1H0KrRouwvcED
         wknDFQZzp5GWbnTxlb8MnIaDQ7cCPzn8s8slljMLoJuJcNOYPqQmxJa7xHSzixT5bApC
         DueOvSk+uok7nxe6lmxk3Csk8rry2sbRd+iGBRUqAOm/clM3aTtU0UZamXy05cJ+YXjI
         QTkKzr3hCV+WJkcglynAEtQ+ufMCv5wlLRnP+8a+Ibw1byWp51MlA+k4cWEywFTcz+VQ
         7P4w==
X-Gm-Message-State: AOAM531vC8kyiAeF4Hxw4rpqTd1YFyEK4lhtKjxF5U2KmrAIfhDUSPUc
        fbxJzi/acnPRIhhziCcrt1fUyGpephbfJA==
X-Google-Smtp-Source: ABdhPJwvKftZzcy73eSJNR97gxoVllIWmadIUrIioGoClf88GRy5suQcIWm1rpymw/aLLGsWheAvsw==
X-Received: by 2002:ab0:384a:: with SMTP id h10mr1482927uaw.77.1601652544611;
        Fri, 02 Oct 2020 08:29:04 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id r22sm292416vke.5.2020.10.02.08.29.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:29:03 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id 7so816188vsp.6
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:29:03 -0700 (PDT)
X-Received: by 2002:a67:87c4:: with SMTP id j187mr1640749vsd.34.1601652543334;
 Fri, 02 Oct 2020 08:29:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201002141531.7081-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20201002141531.7081-1-manivannan.sadhasivam@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Fri, 2 Oct 2020 08:28:51 -0700
X-Gmail-Original-Message-ID: <CAD=FV=V3WHgE5hqgRtPayGB1PTcdJge-32wJOgs84=4h3owtsA@mail.gmail.com>
Message-ID: <CAD=FV=V3WHgE5hqgRtPayGB1PTcdJge-32wJOgs84=4h3owtsA@mail.gmail.com>
Subject: Re: [PATCH] net: qrtr: ns: Fix the incorrect usage of rcu_read_lock()
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Elder <elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Oct 2, 2020 at 7:15 AM Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> The rcu_read_lock() is not supposed to lock the kernel_sendmsg() API
> since it has the lock_sock() in qrtr_sendmsg() which will sleep. Hence,
> fix it by excluding the locking for kernel_sendmsg().
>
> Fixes: a7809ff90ce6 ("net: qrtr: ns: Protect radix_tree_deref_slot() using rcu read locks")
> Reported-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  net/qrtr/ns.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 934999b56d60..0515433de922 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -203,15 +203,17 @@ static int announce_servers(struct sockaddr_qrtr *sq)
>         /* Announce the list of servers registered in this node */
>         radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
>                 srv = radix_tree_deref_slot(slot);
> +               rcu_read_unlock();

My RCU-fu is mediocre at best and my radix-tree knowledge is
non-existent.  However:

=> Reading through radix_tree_deref_slot() it says that if you are
only holding the read lock that you need to be calling
radix_tree_deref_retry().  Why don't I see that here?

=> Without any real knowledge, it seems super sketchy to drop the lock
while iterating over the tree.  Somehow that feels unsafe.  Hrm, there
seems to be a function radix_tree_iter_resume() that might be exactly
what you want, but I'm not totally sure.  The only user I can see
in-tree (other than radix tree regression testing) is btrfs-tests.c
but it's using it together with radix_tree_deref_slot_protected().

In any case, my totally untested and totally knowedge-free proposal
would look something like this:

  rcu_read_lock();
  /* Announce the list of servers registered in this node */
  radix_tree_for_each_slot(slot, &node->servers, &iter, 0) {
    srv = radix_tree_deref_slot(slot);
    if (!srv)
      continue;
    if (radix_tree_deref_retry(srv)) {
      slot = radix_tree_iter_retry(&iter);
      continue;
    }
    slot = radix_tree_iter_resume(slot, &iter);
    rcu_read_unlock();

    ret = service_announce_new(sq, srv);
    if (ret < 0) {
      pr_err("failed to announce new service\n");
      return ret;
    }

    rcu_read_lock();
  }

  rcu_read_unlock();

What a beast!  Given that this doesn't seem to be what anyone else in
the kernel is doing exactly, it makes me suspect that there's a more
fundamental design issue here, though...

-Doug
