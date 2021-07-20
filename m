Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519903CF7D9
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhGTJr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbhGTJqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:46:46 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC869C061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 03:27:24 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id w13so11982505wmc.3
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 03:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=rX65FkhH+runkAdpmro2t/pfk/k6mjZsrM+ki2qYx3g=;
        b=f1h8c0NQNl2SWH+GpPorq7Fu7mLoeDAvzPvISlbwAfniKdtR3Jhkn7XM1Rf+wbgqfs
         doOlMH1ZF/42lkD/apAdLvSblz6uzukiMS7MSI1CiXeoc+ZXvJdWIsdqLmE34c1OUCCz
         RJVyXPLCfnFJTLv/DkCC/10tmA/56VKn5GYB4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=rX65FkhH+runkAdpmro2t/pfk/k6mjZsrM+ki2qYx3g=;
        b=rB+4eRdCQEx6JHCTu+pNQYoy4nXd6Xu97DSZZmESsScC1jiAxnFejEEcxUZ+kghH0I
         q2M56FTrEitinfo2WoBDFEOfU/44BnvdktToRWBPTCii//58LpWLZHvYKLjZAle0sIE4
         k/1CAWIksdgqoAI9H2eiB/LRoJJlkpVfHQuLUOmQwzcm42Y7jHo9I9gZi9QE5Q0iVc15
         fXbuZcRzQCDg7MrFs+G6QNVy820T9Y82CdwcQM7QQg0QZ/+XAH/ZhT6qrCMF+K6Hmxip
         Tmy8Kg78VxfGm0+nsn64URMpGynOabLMD6awNiOCMb+ZfgYEreedlJChy16AJHGcflOg
         2zqA==
X-Gm-Message-State: AOAM532euhAMRp1qIikgnwogg7/ChOGiMXBxuK/eIzao9RGR0xVNhzYQ
        oN46WAfjHrBhiWLlCLDj8XJyTw==
X-Google-Smtp-Source: ABdhPJwWMHxekz8/dtwQkLgCe5B9Z3ch1mEGtemRgoUpK6NV6EFYQkoeQH7hNbZXRkQIR2d8Yd8ylQ==
X-Received: by 2002:a7b:c4cb:: with SMTP id g11mr21303180wmk.40.1626776843490;
        Tue, 20 Jul 2021 03:27:23 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id u16sm28028569wrw.36.2021.07.20.03.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 03:27:23 -0700 (PDT)
References: <20210719214834.125484-1-john.fastabend@gmail.com>
 <20210719214834.125484-2-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, xiyou.wangcong@gmail.com,
        alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf 1/3] bpf, sockmap: zap ingress queues after stopping
 strparser
In-reply-to: <20210719214834.125484-2-john.fastabend@gmail.com>
Date:   Tue, 20 Jul 2021 12:27:22 +0200
Message-ID: <87v955qnzp.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 11:48 PM CEST, John Fastabend wrote:
> We don't want strparser to run and pass skbs into skmsg handlers when
> the psock is null. We just sk_drop them in this case. When removing
> a live socket from map it means extra drops that we do not need to
> incur. Move the zap below strparser close to avoid this condition.
>
> This way we stop the stream parser first stopping it from processing
> packets and then delete the psock.
>
> Fixes: a136678c0bdbb ("bpf: sk_msg, zap ingress queue on psock down")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

To confirm my understanding - the extra drops can happen because
currently we are racing to clear SK_PSOCK_TX_ENABLED flag in
sk_psock_drop with sk_psock_verdict_apply, which checks the flag before
pushing skb onto psock->ingress_skb queue (or possibly straight into
psock->ingress_msg queue on no redirect).
