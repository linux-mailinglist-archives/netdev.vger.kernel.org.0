Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3353328B09
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbhCAS13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 13:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbhCASZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 13:25:04 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0439DC061793;
        Mon,  1 Mar 2021 10:24:24 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id r5so12051944pfh.13;
        Mon, 01 Mar 2021 10:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=shpmX4JNEjgs4w3tnqp6tN85OJMJTBzrncvlDCPAXuQ=;
        b=dJYEnomGd+M1qxZI3k5HkMPyn8Tfycb0tw2vDKCTITRKCZqYwT2aNSmOcN2lF8/DZ4
         K4l5H1QUoCiNn4qVUvjyUomgqE5BbCwW5ns9uImgK2bpLki/5NBn1dsNQFRpCaX94sIu
         EhxG/kNHM/2vfZWfrjecwkCXeCpVt805iMmrwPnS+Yweix9i8bM45GrB4McvAgt0ZcrM
         o6kmeyPs+uRCmAEyqJn7NtRxK8gZOetPVmTmBjg6UCbiPi1WsNEkPoQ17rpRO7/E7m2a
         9if3b6qBzt9I41ucdHPhRdfVMFg7OrFPs0XVgnfW6weMce+BERemMDm25EWcxBUaLvMY
         egwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=shpmX4JNEjgs4w3tnqp6tN85OJMJTBzrncvlDCPAXuQ=;
        b=fEX7o9YjtqmY2ggqyCFh9aC6Wtca8eXGEE7p3jnsDr4kzfdPSKu2A5woEA7lXdO4xe
         PcwrnI94sHb5unPOi8z+yi9ZBX5lZVWLosT1qZ/mZdmTDqqd1V1PtW3Zfy50aoa260Eu
         X9v3EHp14FISVJXGerZP617fCfeoIMxI9xG/PWKXcHSV/rAI6+O816PbdR+CbtQyMCza
         Ynoglh4Kyx49BYbSxorXTAAxLSL/sPePaUShwqML3tvF83Sh9ZFmSpfY97kTSx/Wy07j
         UTYhLvy1TfFbk6y4wrP1ysCgDYasXuQIl1kTS/HvLCEAuPNEjdBtGZoDVRNlwtfUez0d
         qGdg==
X-Gm-Message-State: AOAM533mu0dFpIvABYTbny5tIpqMWt8oUHSv9vcmzLGLSY7XwlDSccdl
        oKWDmxbFQ2fN1bV+06hprByQQ9eBfAB52kw9CvU=
X-Google-Smtp-Source: ABdhPJy+Ru8qvv/mboqWa6py3j4A2EHM6toLYVIJDzx1OlqiHWWWo4TKttM1C4ZAbhXYWaqFLa69+M2E6Wy7jZsz4EM=
X-Received: by 2002:a63:e109:: with SMTP id z9mr14803837pgh.5.1614623063477;
 Mon, 01 Mar 2021 10:24:23 -0800 (PST)
MIME-Version: 1.0
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
 <20210223184934.6054-5-xiyou.wangcong@gmail.com> <CACAyw9-L9b+muEm2uFkBi-yRNY1enFGN7zLVvF7kOH2bjSb5+g@mail.gmail.com>
In-Reply-To: <CACAyw9-L9b+muEm2uFkBi-yRNY1enFGN7zLVvF7kOH2bjSb5+g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Mar 2021 10:24:12 -0800
Message-ID: <CAM_iQpUCsoXLJ_8BFywJQXmEAXA-Kmes0x7vCN2hnxtoiVaDoQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 4/9] skmsg: move sk_redir from TCP_SKB_CB to skb
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 7:24 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 23 Feb 2021 at 18:49, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > does not work for any other non-TCP protocols. We can move them to
> > skb ext, but it introduces a memory allocation on fast path.
> >
> > Fortunately, we only need to a word-size to store all the information,
> > because the flags actually only contains 1 bit so can be just packed
> > into the lowest bit of the "pointer", which is stored as unsigned
> > long.
> >
> > Inside struct sk_buff, '_skb_refdst' can be reused because skb dst is
> > no longer needed after ->sk_data_ready() so we can just drop it.
>
> Hi Cong Wang,
>
> I saw this on patchwork:
>
> include/linux/skbuff.h:932: warning: Function parameter or member
> '_sk_redir' not described in 'sk_buff'
> New warnings added
> 0a1
> > include/linux/skbuff.h:932: warning: Function parameter or member '_sk_redir' not described in 'sk_buff'
> Per-file breakdown

Ah, I didn't know the function doc is mandatory now.

>
> Source: https://patchwork.kernel.org/project/netdevbpf/patch/20210223184934.6054-5-xiyou.wangcong@gmail.com/
>
> Maybe something to follow up on, I'm not sure what the conventions are here.

It is already merged, so we definitely need a one-line followup fix.

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bd84f799c952..0503c917d773 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -656,6 +656,7 @@ typedef unsigned char *sk_buff_data_t;
  *     @protocol: Packet protocol from driver
  *     @destructor: Destruct function
  *     @tcp_tsorted_anchor: list structure for TCP (tp->tsorted_sent_queue)
+ *     @_sk_redir: socket redirection information for skmsg
  *     @_nfct: Associated connection, if any (with nfctinfo bits)
  *     @nf_bridge: Saved data about a bridged frame - see br_netfilter.c
  *     @skb_iif: ifindex of device we arrived on

Thanks.
