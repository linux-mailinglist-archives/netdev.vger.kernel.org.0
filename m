Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3F0665D3D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjAKOCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjAKOCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:02:44 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337175FE3;
        Wed, 11 Jan 2023 06:02:43 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jo4so37078481ejb.7;
        Wed, 11 Jan 2023 06:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MxuU7wUaOVNWzw0OY3oc6kPjSUCRmmaSLecbjdN/GQ8=;
        b=ggKPFUJBBcNKZth019Xt7c982oDgJ5nmFKL5yMDKnFaSJ2ViEjyI4embplmlXR9lHO
         rkzEM5vxOGah9hsP7DiaVxpsUS/n/KIIT7FPScjzRiDi9vSWnq02Awb2aZwXH9iRm9FQ
         PfD1Ao0oG7jsmp08+HINm+X4uT8+716n8OMy/Cn0H2vKeZztMvfUP7LN4kzvZokdf8By
         g8Wfa3pEwQvEzKHxd3lFBlgKhOkexzcso8azKE/2/bML9u4p9TmHAGjw0d7Sqg9Wq2cm
         TYwZ7YONoRbsTOonp4tTCp+V+06sdxP2q4ZjB2vTrjfrUkkjSYpQ6SJ059V6x91+aIA6
         o4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MxuU7wUaOVNWzw0OY3oc6kPjSUCRmmaSLecbjdN/GQ8=;
        b=AN6c4N0mEx9B9Tn+j0wLTXfLxq+4cDkTaED/1PYk66Ee7DZrnz9J6I04U0ziOSQME0
         L2nK+6nMBdVGB6KioQ1SOUIde+RIMjkT2krKf5cBSU9D6ijpq51ROgWIYbpm4HLUg/Uj
         xrKD6+QVAyafb2BbCCEqgHKYD/3ODooQbmsmFyegpE8W9N/d6VgYKRsO1XsPVoiJgQqK
         tJf5S+lklET6sfC/0ki+Ziu1T5W8yHnVtNoMZ1pQyUJEcVkNvfWo9hytapk8iKjfyAi6
         r8r9pt35rjjyVXUUH6/aEr0KGrwYB6cbPTql1jsbuJfPqdMx50ayOFLp4YqLDvE7fcaO
         1fRg==
X-Gm-Message-State: AFqh2ko0w+u+Qw4KtNjSbRylKpfSzmNFiGtQGM0Y8aOAp0Likzq93UzX
        HuYkt+O78v6HG1ONROWlEXe7t29psVnqM4um4Ko=
X-Google-Smtp-Source: AMrXdXum1ycLaxVr3PZ7hmR/hV1SAdUF4+18LsTH7h3WtCqo8MXPCjlJBbjl/p4wlAmBFUu+K0bUgPR7/1eiJfQoz+I=
X-Received: by 2002:a17:907:c709:b0:84d:3629:1664 with SMTP id
 ty9-20020a170907c70900b0084d36291664mr1978436ejc.388.1673445761593; Wed, 11
 Jan 2023 06:02:41 -0800 (PST)
MIME-Version: 1.0
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell> <20221220185903.1105011-1-sbohrer@cloudflare.com>
 <e6b0414dbc7e97857fee5936ed04efca81b1d472.camel@redhat.com>
In-Reply-To: <e6b0414dbc7e97857fee5936ed04efca81b1d472.camel@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 11 Jan 2023 15:02:29 +0100
Message-ID: <CAJ8uoz2ZL54EbZw+jTCQowjmC=MBzdpVzn=uQNcM7K+sCH7K5Q@mail.gmail.com>
Subject: Re: [PATCH] veth: Fix race with AF_XDP exposing old or uninitialized descriptors
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Shawn Bohrer <sbohrer@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 11:18 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2022-12-20 at 12:59 -0600, Shawn Bohrer wrote:
> > When AF_XDP is used on on a veth interface the RX ring is updated in two
> > steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
> > fills them and places them in the RX ring updating the cached_prod
> > pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with the
> > cached_prod pointer allowing user-space to see the recently filled in
> > descriptors.  The rings are intended to be SPSC, however the existing
> > order in veth_poll allows the xdp_do_flush() to run concurrently with
> > another CPU creating a race condition that allows user-space to see old
> > or uninitialized descriptors in the RX ring.  This bug has been observed
> > in production systems.
> >
> > To summarize, we are expecting this ordering:
> >
> > CPU 0 __xsk_rcv_zc()
> > CPU 0 __xsk_map_flush()
> > CPU 2 __xsk_rcv_zc()
> > CPU 2 __xsk_map_flush()
> >
> > But we are seeing this order:
> >
> > CPU 0 __xsk_rcv_zc()
> > CPU 2 __xsk_rcv_zc()
> > CPU 0 __xsk_map_flush()
> > CPU 2 __xsk_map_flush()
> >
> > This occurs because we rely on NAPI to ensure that only one napi_poll
> > handler is running at a time for the given veth receive queue.
> > napi_schedule_prep() will prevent multiple instances from getting
> > scheduled. However calling napi_complete_done() signals that this
> > napi_poll is complete and allows subsequent calls to
> > napi_schedule_prep() and __napi_schedule() to succeed in scheduling a
> > concurrent napi_poll before the xdp_do_flush() has been called.  For the
> > veth driver a concurrent call to napi_schedule_prep() and
> > __napi_schedule() can occur on a different CPU because the veth xmit
> > path can additionally schedule a napi_poll creating the race.
>
> The above looks like a generic problem that other drivers could hit.
> Perhaps it could be worthy updating the xdp_do_flush() doc text to
> explicitly mention it must be called before napi_complete_done().

Good observation. I took a quick peek at this and it seems there are
at least 5 more drivers that can call napi_complete_done() before
xdp_do_flush():

drivers/net/ethernet/qlogic/qede/
drivers/net/ethernet/freescale/dpaa2
drivers/net/ethernet/freescale/dpaa
drivers/net/ethernet/microchip/lan966x
drivers/net/virtio_net.c

The question is then if this race can occur on these five drivers.
Dpaa2 has AF_XDP zero-copy support implemented, so it can suffer from
this race as the Tx zero-copy path is basically just a napi_schedule()
and it can be called/invoked from multiple processes at the same time.
In regards to the others, I do not know.

Would it be prudent to just switch the order of xdp_do_flush() and
napi_complete_done() in all these drivers, or would that be too
defensive?

> (in a separate, net-next patch)
>
> Thanks!
>
> Paolo
>
> >
> > The fix as suggested by Magnus Karlsson, is to simply move the
> > xdp_do_flush() call before napi_complete_done().  This syncs the
> > producer ring pointers before another instance of napi_poll can be
> > scheduled on another CPU.  It will also slightly improve performance by
> > moving the flush closer to when the descriptors were placed in the
> > RX ring.
> >
> > Fixes: d1396004dd86 ("veth: Add XDP TX and REDIRECT")
> > Suggested-by: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>
> > ---
> >  drivers/net/veth.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index ac7c0653695f..dfc7d87fad59 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -974,6 +974,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
> >       xdp_set_return_frame_no_direct();
> >       done = veth_xdp_rcv(rq, budget, &bq, &stats);
> >
> > +     if (stats.xdp_redirect > 0)
> > +             xdp_do_flush();
> > +
> >       if (done < budget && napi_complete_done(napi, done)) {
> >               /* Write rx_notify_masked before reading ptr_ring */
> >               smp_store_mb(rq->rx_notify_masked, false);
> > @@ -987,8 +990,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
> >
> >       if (stats.xdp_tx > 0)
> >               veth_xdp_flush(rq, &bq);
> > -     if (stats.xdp_redirect > 0)
> > -             xdp_do_flush();
> >       xdp_clear_return_frame_no_direct();
> >
> >       return done;
>
