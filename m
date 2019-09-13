Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C074B26FE
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbfIMVCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:02:47 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39749 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfIMVCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:02:47 -0400
Received: by mail-oi1-f195.google.com with SMTP id w144so3810835oia.6
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 14:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v1t66hxJY8pPYIzeoPCQZAh2sgw8WMJTzlyMAy5GOkc=;
        b=n8cDOMUfnji919xq2eP6Vo0DPGz4mGarD/VwGihXmvC7lDOs3vUXDwLczoA+/1qzmh
         zR2HtunEfSRxxlFztK7cekGczhX+wiRUEjHmJKQsv5ITgT/IHRiR61508/sqOvNT5XeB
         6GkYTUY5MhTSONP5w4GTkwitf8Xk3OzbRMbj9/xYj0Jg2z2mHFSnCCZ/KEoz0ut1NPSC
         3DmBlqvuOoKmhAxawKD3YfPP6zF7/VogNubeh4oTcv2NbXXuJ6dDNiCqubgLDCeqy/16
         KkZNyl5lzfm7mG4fqLmC815kbDO9jrW5MQvztZ8RXWlURsPLsM7JVJvkuMGQ7y00fGKP
         LQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v1t66hxJY8pPYIzeoPCQZAh2sgw8WMJTzlyMAy5GOkc=;
        b=g6NiW9LTyhebPMkAINo3elMxzRcb85+y+rZl6TJhOQgiLt6p9qCbyEUX4n/u6owGem
         fdKY1KJm5k9/9LGULHBieLQ49/vwFfl5iSDP1RoqVPTdEaUmLJVb801z8VS5Kkkuc9V7
         Y7JtKmd9b8/8PwAKgDA5zYoA6/dCte8LJ9xv9i2tEtGSRN+xLX5qY6kE1ICBQEsc+hnS
         IDvev7Pe5c3Ud8FW3RISKH5Nn2d44Y6Dn4OgrV9R6OHRdGlegH8QVAxz6SU9yNY64ZkF
         fbk6Ax3b3RRHOaFQ9G4IBacJqBLrykSnij8yBEm15gTa6SR6LTrtVYI2MVQs6kbbTUQG
         ZqxQ==
X-Gm-Message-State: APjAAAXshcnqCcyVUMkMutAH+kBSIMvuTJzQyFbFqexHXCWqLNhb5MFd
        Fc0v0BdXZTB7IozsxAtKvDpbMAxMNntWhO1JiSBhnA==
X-Google-Smtp-Source: APXvYqyzOv6rvuLuspoHKmBf30bZPC6clnvP8+nrOmu6eCDACD+hCJkDUW2Hkcj7SyjmcGoGFCHGZawmtShMVuRdhnI=
X-Received: by 2002:a54:478d:: with SMTP id o13mr3818665oic.95.1568408564683;
 Fri, 13 Sep 2019 14:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190913193629.55201-1-tph@fb.com> <20190913193629.55201-2-tph@fb.com>
In-Reply-To: <20190913193629.55201-2-tph@fb.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 13 Sep 2019 17:02:28 -0400
Message-ID: <CADVnQymKS6-jztAbLu_QYWiPYMqoTf5ODzSg3UPJxH+vBt=bmw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Thomas Higdon <tph@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 3:36 PM Thomas Higdon <tph@fb.com> wrote:
>
> Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
> performance problems --
> > (1) Usually when we're diagnosing TCP performance problems, we do so
> > from the sender, since the sender makes most of the
> > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > From the sender-side the thing that would be most useful is to see
> > tp->snd_wnd, the receive window that the receiver has advertised to
> > the sender.
>
> This serves the purpose of adding an additional __u32 to avoid the
> would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---
> changes from v3:
>  - changed from rcv_wnd to snd_wnd
>
>  include/uapi/linux/tcp.h | 1 +
>  net/ipv4/tcp.c           | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 20237987ccc8..240654f22d98 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -272,6 +272,7 @@ struct tcp_info {
>         __u32   tcpi_reord_seen;     /* reordering events seen */
>
>         __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */
> +       __u32   tcpi_snd_wnd;        /* Remote peer's advertised recv window size */
>  };

Thanks for adding this!

My run of ./scripts/checkpatch.pl is showing a warning on this line:

WARNING: line over 80 characters
#19: FILE: include/uapi/linux/tcp.h:273:
+       __u32   tcpi_snd_wnd;        /* Remote peer's advertised recv
window size */

What if the comment is shortened up to fit in 80 columns and the units
(bytes) are added, something like:

        __u32   tcpi_snd_wnd;        /* peer's advertised recv window (bytes) */

neal
