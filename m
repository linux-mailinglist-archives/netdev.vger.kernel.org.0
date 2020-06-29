Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC5620E261
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390265AbgF2VEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731110AbgF2TMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:44 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08FFC0A893D
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:42:26 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y13so8503005lfe.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 00:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=dehoAPWG1C4zFRAsM2Hgz51wnypP3bkZmHH0inC/SE4=;
        b=HfRHaYe1bLPiZrP3enkwPCpjwaVwCHWeRiz6TUInU4PWdR2CQVF7DKY4T13zP/B4K4
         0EaxCRhvHXARTsFJKg9BnUm3QshCsc8n2IqVG/rX6v/vgukiSK8MnTL+wENyeG88SaLn
         PqCaBwQ0rgrxjbUKT+S/rYT2c3iQoxOIOO3Wk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=dehoAPWG1C4zFRAsM2Hgz51wnypP3bkZmHH0inC/SE4=;
        b=aI4pJbcyxG+E2XtCUuguGdd6fmMUdnf3B5cSmi+rjoKVQVoP6qS7h00j3Qew31QzYR
         9p5s9jCGrWL0OUb5LMBGRNUD8X9DSLlsBnXSSdj37BGa4KJ0op10PyFv98kBC6lI8B4h
         Tk5hD/8nQSE9hg/3GBhhYOdzaekHdbKIe0nvAA5gG2P+USkz1jP1Y3eqFdCqpeUKfVrf
         cbK8yIYp2mLiKNoFLk/jfNaQW8/gVKU3dbjRY3YuL/CMrROcju5FU64/5GetagdQSPPw
         anlAoXHxnII0n8YAKC1MlpzBtVhWPQaIFw+spLylLvEKcwuSDQlEMpxcVk5LgcZq6R5n
         y6Yg==
X-Gm-Message-State: AOAM531fRLnhBoGfv2CnO/DAddn5lHhUR1huVczDglMkoYM4OYvvdARV
        CXpP4LGrp5xAprf4O4gs1GDB+Q==
X-Google-Smtp-Source: ABdhPJwrtWoK6TAjkCMcGUSuVkzv9DxW/3FrqZvLStmAWpY/6EKvwNcFbQyy9OA4Sq7EnCigTcNxqA==
X-Received: by 2002:a05:6512:3398:: with SMTP id h24mr8399914lfg.135.1593416545225;
        Mon, 29 Jun 2020 00:42:25 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e29sm7826437lfc.51.2020.06.29.00.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 00:42:24 -0700 (PDT)
References: <159312606846.18340.6821004346409614051.stgit@john-XPS-13-9370> <159312679888.18340.15248924071966273998.stgit@john-XPS-13-9370>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     kafai@fb.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 2/3] bpf, sockmap: RCU dereferenced psock may be used outside RCU block
In-reply-to: <159312679888.18340.15248924071966273998.stgit@john-XPS-13-9370>
Date:   Mon, 29 Jun 2020 09:42:23 +0200
Message-ID: <87d05imi74.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 01:13 AM CEST, John Fastabend wrote:
> If an ingress verdict program specifies message sizes greater than
> skb->len and there is an ENOMEM error due to memory pressure we
> may call the rcv_msg handler outside the strp_data_ready() caller
> context. This is because on an ENOMEM error the strparser will
> retry from a workqueue. The caller currently protects the use of
> psock by calling the strp_data_ready() inside a rcu_read_lock/unlock
> block.
>
> But, in above workqueue error case the psock is accessed outside
> the read_lock/unlock block of the caller. So instead of using
> psock directly we must do a look up against the sk again to
> ensure the psock is available.
>
> There is an an ugly piece here where we must handle
> the case where we paused the strp and removed the psock. On
> psock removal we first pause the strparser and then remove
> the psock. If the strparser is paused while an skb is
> scheduled on the workqueue the skb will be dropped on the
> flow and kfree_skb() is called. If the workqueue manages
> to get called before we pause the strparser but runs the rcvmsg
> callback after the psock is removed we will hit the unlikely
> case where we run the sockmap rcvmsg handler but do not have
> a psock. For now we will follow strparser logic and drop the
> skb on the floor with skb_kfree(). This is ugly because the
> data is dropped. To date this has not caused problems in practice
> because either the application controlling the sockmap is
> coordinating with the datapath so that skbs are "flushed"
> before removal or we simply wait for the sock to be closed before
> removing it.
>
> This patch fixes the describe RCU bug and dropping the skb doesn't
> make things worse. Future patches will improve this by allowing
> the normal case where skbs are not merged to skip the strparser
> altogether. In practice many (most?) use cases have no need to
> merge skbs so its both a code complexity hit as seen above and
> a performance issue. For example, in the Cilium case we always
> set the strparser up to return sbks 1:1 without any merging and
> have avoided above issues.
>
> Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

LGTM. Sorry for the delay, needed to make sure I understand this.
