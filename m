Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2888DDA1AD
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393080AbfJPWmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:42:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44363 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJPWmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:42:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id e10so84156pgd.11
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3x6UXXXpwzToVvx7uQAGu3Aq2wq21ADOv7FnwHWj45o=;
        b=M4l9nCxNYdhYEEt9KNEsJnp7ih/tQgB41w3c0a2XkUwrJhAIGBrs30/HemSt5U7lvF
         IG29A+nR+YDCoTdAqBz6xT93vJwpGkjo77dCG5vm23x6KoO96XfwzeAE1eevOIxjEB/T
         z3GpvuNFr6CHItG1mZ5StxUXVSN7NDhhe7lfLsTJDjngaO04EfmZAXm9vOZtc6rKE939
         xxAbWAb+OrZ8pfssgwMV0mV81jMyeXPf5zmTNQLrhfsn8MiJKtsh1Q6bmNDFGPLKowD6
         J3JTI9asZ9kmgJwrvu+sFCQne1RWtWBepinanvZaiPvH/3PdovSClAydgHX9k+1Qe1Bb
         cGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3x6UXXXpwzToVvx7uQAGu3Aq2wq21ADOv7FnwHWj45o=;
        b=bK7fBRK3VGpbY/nCs1SrhKryge33Sp3rNpp+sMeqWjLfg2yrqL+vULMlKYuiGcc3XS
         znTJXCsHSkCxHq97wAkoUq86yL1b+68Fg5ZvMt9lOm6uIGYjip9NAolBgZ5aNvvjF3OA
         X4m11OALGQnWmI+exTbktePqBygKRRLxD8eSefgWnF8ukKxxkxnlLWCLc+IkoQVxwfJ+
         mTl4338VLywYpDHsT8qzvTaIZdWGMbNzLIFtPmo9DIctaX7XSjs2GRpOGetJUAsbFTz0
         WxvfhvVUtw5buQa5NIZt0okgGdiacvg1tbB+mK2haxpvtVl1NX6R2cf+/cfH9gPk8a/m
         M0DA==
X-Gm-Message-State: APjAAAWoMa7wtq4WoEZONhSpD72v31eF8YkfvRzFhD8OtdgsrVCDiE+n
        H1canhNyhvkh093J6QrFaf2jl3BWjBTyWuZqsPQ=
X-Google-Smtp-Source: APXvYqwCKLwGTlv9aqtdldD290j8m4TmlHZUd8ZvEk7uzb/mT3c/aOZhR9WPV9oeFrjk8gr25wHf142vEwPcEkR0IrM=
X-Received: by 2002:a65:614e:: with SMTP id o14mr546074pgv.237.1571265759435;
 Wed, 16 Oct 2019 15:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191016160050.27703-1-jakub.kicinski@netronome.com>
In-Reply-To: <20191016160050.27703-1-jakub.kicinski@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 16 Oct 2019 15:42:28 -0700
Message-ID: <CAM_iQpXw7xBTGctD2oLdWGZHc+mpeUAMq5Z4AYvKSiw68e=5EQ@mail.gmail.com>
Subject: Re: [PATCH net] net: netem: fix error path for corrupted GSO frames
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 3:23 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> To corrupt a GSO frame we first perform segmentation.  We then
> proceed using the first segment instead of the full GSO skb and
> requeue the rest of the segments as separate packets.
>
> If there are any issues with processing the first segment we
> still want to process the rest, therefore we jump to the
> finish_segs label.
>
> Commit 177b8007463c ("net: netem: fix backlog accounting for
> corrupted GSO frames") started using the pointer to the first
> segment in the "rest of segments processing", but as mentioned
> above the first segment may had already been freed at this point.
>
> Backlog corrections for parent qdiscs have to be adjusted.
> Note that if segmentation ever produced a single-skb list
> the backlog calculation will not take place (segs == NULL)
> but that should hopefully never happen..
>
> Fixes: 177b8007463c ("net: netem: fix backlog accounting for corrupted GSO frames")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> ---
>  net/sched/sch_netem.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index 0e44039e729c..31a6afd035b2 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -509,6 +509,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>                 if (skb->ip_summed == CHECKSUM_PARTIAL &&
>                     skb_checksum_help(skb)) {
>                         qdisc_drop(skb, sch, to_free);
> +                       skb = NULL;
>                         goto finish_segs;
>                 }
>
> @@ -595,7 +596,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>                 unsigned int len, last_len;
>                 int nb = 0;
>
> -               len = skb->len;
> +               len = skb ? skb->len : 0;
>
>                 while (segs) {
>                         skb2 = segs->next;
> @@ -612,7 +613,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>                         }
>                         segs = skb2;
>                 }
> -               qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
> +               qdisc_tree_reduce_backlog(sch, !skb - nb, prev_len - len);

Am I the only one has trouble to understand the expression
"!skb - nb"?
