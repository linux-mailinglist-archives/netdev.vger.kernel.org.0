Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F93A2A3EC1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKCITF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKCITC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:19:02 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6B5C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 00:19:02 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id y20so17657334iod.5
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 00:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D0e0oWRSS4N0pd/RIPROhF99Eoy0cg827Zo0PyrKmrQ=;
        b=b2qdQ3djXE88wg8higFem2bqEMYVMYCXz6n1KerjFGMnaF9znm33X/1WYvKlcxlZTr
         19a0ybBfPk7yrWcq6cM79teB0x3QOGBAzNat4pKUwzdaxBJPNrlwn/jcqluZNHI624rl
         eW+VTubr7Idv/ninuYCfXs406M1prEFk3XVX7Eyyvo7upsQ4mxvgQtKfAqDAc1/h4u+P
         oNwhh9Ebc/exzvO31juTsS7qpkTthiGSAdBgtIfGz2fBHJ3hzeZk8OrYgmAn+TwhkZKz
         GntRNdbYZul21YJsJlMh7UdCU3A1WvsCGD4sUnA69AWUeEbpJXm/2pz7BsrOPFBdSQm5
         BIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D0e0oWRSS4N0pd/RIPROhF99Eoy0cg827Zo0PyrKmrQ=;
        b=dP6IZoVA71qwyFiLvZ9ChdP/G2nhdcKbWlgxQAhU+xgN4+1zQ3qgfVPIMu8aYbvAdb
         v//e8uUgj+2bFW7B8zIGxTfvZ09AF2Azw9Z2F/IuqQ6eRMiP4v411Ro+3SWI0+IO/Z61
         nXvKyn3BrhhkjIjoSxTWS0zN0rl5FAkol6xR+tiUynNVvVtzbiGnzEvkI2lhp8PEUs8z
         k8/Oi2s14bOcRSe2LSaLM3pTwicwCk+HNjf/FlPGoTzsFBPbG/ndUp7VB5Iy5zgsS8vz
         CvpyKcD5enkeU23Yt3/h1Hu8U1EjXU5psPyLcziWDCFFVHZand+a/j09e8Rxn5yzsSRP
         v18Q==
X-Gm-Message-State: AOAM5331Y3HKH1EQxyashm+Yf+k8oUUkOHLljU/kzhgLwCWgq0x9ANbL
        PdzTQXJuZdxVyU6+C8/h37OBQcHmDnjdnIkcKfqTbg==
X-Google-Smtp-Source: ABdhPJwxEByue6+NjKyrUPYw12JJAowAlXB0ypnXxDVIiNdaY4Sr19gqszyjn0WSvGaRPtUSlYxdKwpeMB/Erd9UaSo=
X-Received: by 2002:a6b:bbc6:: with SMTP id l189mr13447210iof.145.1604391541575;
 Tue, 03 Nov 2020 00:19:01 -0800 (PST)
MIME-Version: 1.0
References: <20201103070947.577831-1-allen.lkml@gmail.com> <20201103070947.577831-7-allen.lkml@gmail.com>
In-Reply-To: <20201103070947.577831-7-allen.lkml@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Nov 2020 09:18:50 +0100
Message-ID: <CANn89iJ4Z=Z+iSHoQQhTS+QGyfU_TOeWNC3Sjszc=DeZ3-bJUw@mail.gmail.com>
Subject: Re: [net-next V3 6/8] net: sched: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Aring <alex.aring@gmail.com>,
        stefan@datenfreihafen.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 8:10 AM Allen Pais <allen.lkml@gmail.com> wrote:
>
> From: Allen Pais <apais@linux.microsoft.com>
>
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
>
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>  net/sched/sch_atm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
> index 1c281cc81f57..390d972bb2f0 100644
> --- a/net/sched/sch_atm.c
> +++ b/net/sched/sch_atm.c
> @@ -466,10 +466,10 @@ drop: __maybe_unused
>   * non-ATM interfaces.
>   */
>
> -static void sch_atm_dequeue(unsigned long data)
> +static void sch_atm_dequeue(struct tasklet_struct *t)
>  {
> -       struct Qdisc *sch = (struct Qdisc *)data;
> -       struct atm_qdisc_data *p = qdisc_priv(sch);
> +       struct atm_qdisc_data *p = from_tasklet(p, t, task);
> +       struct Qdisc *sch = (struct Qdisc *)((char *)p - sizeof(struct Qdisc));

Hmm... I think I prefer not burying implementation details in
net/sched/sch_atm.c and instead
define a helper in include/net/pkt_sched.h

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 4ed32e6b020145afb015c3c07d2ec3a613f1311d..15b1b30f454e4837cd1fc07bb3ff6b4f178b1d39
100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -24,6 +24,11 @@ static inline void *qdisc_priv(struct Qdisc *q)
        return &q->privdata;
 }

+static inline struct Qdisc *qdisc_from_priv(void *priv)
+{
+       return container_of(priv, struct Qdisc, privdata);
+}
+
 /*
    Timer resolution MUST BE < 10% of min_schedulable_packet_size/bandwidth
