Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665C5406D1E
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhIJNvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbhIJNu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 09:50:58 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F821C061574
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 06:49:47 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id g11so1276329qvd.2
        for <netdev@vger.kernel.org>; Fri, 10 Sep 2021 06:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=srvhdErf9BCzLqPOdxLKwCiaQPB3Aoe9oKjUP5b5pTI=;
        b=PwrkqqiW0CnFk98aZJnynzvkUyU+B+vxcsNEiC2dArME8SG8YjCeaufLs7JpBoxqnh
         d7hMqRlfYqpJW2gJvlqTuqCcegTPdGIFnmKVKsBvPgyas34pj20M6E/4ntvttwS8+n0z
         cOHyxuvhlVH8uFwMmBXXQhiaSFDcbTF5r0qtl2dURvEhxgnLWc+vYmcDwPXA5Wq9zsnl
         CJgmDVMJ/1XRKy3a0kMTv13N29UiodEgcUxIbugbuSiUA2auIaHUm4CPA/KkhTV/av2d
         ANcLo/W/52YQfyXvWjcDdiYBjhrlkGTxAc3UaFvDOUTD4J95gb3bN1u8I0b3tKHqO6Xd
         quYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=srvhdErf9BCzLqPOdxLKwCiaQPB3Aoe9oKjUP5b5pTI=;
        b=U9L+d09bwH+X21E5t16KYcKtpzF3oqSSvc/fL4/tofONVlCUWiE2CDlZwyWTB/FLCb
         ciGqL65Qdg8XTrIkrOmotRlatusd4HggnAPJ8XRXQtcg3wJNtSFezi9/O2NC/IkhWf8A
         UEd9/isso7sT7sb3lWfg5EzownuoVa+UX7t1+huFqSu6LydOFhUS2ttnCOIWZWh6IB3p
         hIDB893lYpzCVRy2qLHKRlQ7lW9cgNY1TR1JJYMjHrRWFyo12uEtuNcJTS84iXrhx1BW
         omgvCGYWB78aVyYqfqP/lzbGSLfQYsrJX+sNO7IkdJGuZUp08kNjK2I42321ruBRq2cN
         Ev8w==
X-Gm-Message-State: AOAM531mt0w7mDH4NY9N2gj5MkH681cMzPVX4Ff9dhjfjHih7sBaH+3T
        KKyH6MHsgEAdE7yOs2sL5Je97R0rG2bxid1qf2L5Hw==
X-Google-Smtp-Source: ABdhPJycjvxPx2UEQuGIiBCRkWhnd2msBob8k+tNJmLfClM9pUoeFp9q2k/5FecLrZg0wxG9mPFd4qz0dtifDQ3xvAI=
X-Received: by 2002:a0c:8e05:: with SMTP id v5mr8435326qvb.25.1631281785497;
 Fri, 10 Sep 2021 06:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <1630248743-13361-1-git-send-email-zhenggy@chinatelecom.cn>
In-Reply-To: <1630248743-13361-1-git-send-email-zhenggy@chinatelecom.cn>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 10 Sep 2021 09:49:29 -0400
Message-ID: <CADVnQykB6SPrY8Ov+A6Uu0YqaaX2wS5_kHWkWGqKyX6cUGfC9g@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix tp->undo_retrans accounting in tcp_sacktag_one()
To:     zhenggy <zhenggy@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ycheng@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 10:40 PM zhenggy <zhenggy@chinatelecom.cn> wrote:
>
> Commit a71d77e6be1e ("tcp: fix segment accounting when DSACK range covers
> multiple segments") fix some DSACK accounting for multiple segments.
> In tcp_sacktag_one(), we should also use the actual DSACK rang(pcount)

nit: typo; I'd suggest: "range (pcount)"

> for tp->undo_retrans accounting.
>
> Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
>
> Before that commit, the assumption underlying the tp->undo_retrans--
> seems correct, AFAICT.
>
> Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>

Please take a look at the standard formatting in the "git log"
history. The Fixes: tag should be in the footers section, typically
the first footer, preceding fields like Reported-by: and Cc: and
Signed-off-by:.

Please consider something like:

----
Since 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
this logic can no longer assume that a retransmitted packet is a single segment.

Fixes: 10d3be569243 ("tcp-tso: do not split TSO packets at retransmit time")
Signed-off-by: zhenggy <zhenggy@chinatelecom.cn>
---

thanks,
neal
