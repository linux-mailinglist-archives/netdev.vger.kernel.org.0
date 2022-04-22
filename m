Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF7750C2D0
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiDVW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiDVW60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:58:26 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C124C102;
        Fri, 22 Apr 2022 15:23:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b15so9237824pfm.5;
        Fri, 22 Apr 2022 15:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JHEFbCSzTituLXCXTybtRDjC+y4H0lJbUwGY4K6dh4E=;
        b=JospNFsSTIe/Rnweo7xoBSMAwPsWRhI+HalpospItgXy7W/qZdF3kmQY1hbWUmC3w0
         fq4SvMARuC4IKQw+C1r1t+l5xrKV3UFnYLpdpCMB9XOEYRxOchbAjkh/OMxa+tLWXMh0
         SqApkjtdPHkNun3pqATVhKID/GJuDTkIGRUqyFK3qq3Ok03w07uBcQ82XkkyScmYCctC
         xGZDGvU3IT2WWjd10DQ0Z5fpCHak72FDL6PDx2W5pvLNO4YKduoX34KwWDreLBNgjScS
         0JBnYiCzEPoU+FGoFZzwFre2EVDC8v/VxBYCzPuEYpoHOtDXuT6oNIvQReaV0woyXJZF
         SPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JHEFbCSzTituLXCXTybtRDjC+y4H0lJbUwGY4K6dh4E=;
        b=AXihqnn69CVEpaQ7oeQH9kG1ghe1zOBJDePBkfrr00PgSJMYg1Xcbn29VpyRGN93dU
         TCjHTUkOQO6ACgflrMLYMn9YG36vmbUTlL1SpI3xD1tAI8on52mbb26GsbjeTBTR4SHT
         ajgl6pSjweazDHihbc6uv3M3dTGvWNA5H7DU3ZdlEBCyEgJFr8mbFxjyXxDf2xGpdRyI
         XKqYE8rOH8v+iZk4dREpGhGjAvKV+sqeRUFUGsdycoL8Rdevzn+zS4ly8srfq9PluEIS
         FO0eeg4MYCniKjhVPnXjstEd9MbvfcoUTcWncPqLdu2e2ChagI2+I9cGQtFAau2eLo3X
         INCQ==
X-Gm-Message-State: AOAM533Pzf/4S5hK4QSMlP3PYYY6nlLLhVODZvRYbaRgiiC9gvGMDxw0
        De5m8WbYNr2/we2o0pSxqdJKdeFvr+nySgoRCpU=
X-Google-Smtp-Source: ABdhPJyDQUVX549ZAM/GhSq5TvdRe+3wmbnPKS/TXPeMAAHJlEEBOkpcQqH3k9vfAcdEgLYcT0dXF4t1xGtEgApvjUE=
X-Received: by 2002:a05:6a00:22c8:b0:50a:dbf5:59cf with SMTP id
 f8-20020a056a0022c800b0050adbf559cfmr7056093pfj.74.1650666193435; Fri, 22 Apr
 2022 15:23:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220405212129.2270-1-cf.natali@gmail.com> <YmHwjdfZJJ2DeLTK@zx2c4.com>
In-Reply-To: <YmHwjdfZJJ2DeLTK@zx2c4.com>
From:   =?UTF-8?Q?Charles=2DFran=C3=A7ois_Natali?= <cf.natali@gmail.com>
Date:   Fri, 22 Apr 2022 23:23:01 +0100
Message-ID: <CAH_1eM2ECPKLcHAKQ-RNf4Zj5hrgT-aJ9pjTKfChf9fnZp5Vkw@mail.gmail.com>
Subject: Re: [PATCH] WireGuard: restrict packet handling to non-isolated CPUs.
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 22 Apr 2022 at 01:02, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> netdev@ - Original thread is at
> https://lore.kernel.org/wireguard/20220405212129.2270-1-cf.natali@gmail.c=
om/
>
> Hi Charles-Fran=C3=A7ois,
>
> On Tue, Apr 05, 2022 at 10:21:29PM +0100, Charles-Francois Natali wrote:
> > WireGuard currently uses round-robin to dispatch the handling of
> > packets, handling them on all online CPUs, including isolated ones
> > (isolcpus).
> >
> > This is unfortunate because it causes significant latency on isolated
> > CPUs - see e.g. below over 240 usec:
> >
> > kworker/47:1-2373323 [047] 243644.756405: funcgraph_entry: |
> > process_one_work() { kworker/47:1-2373323 [047] 243644.756406:
> > funcgraph_entry: | wg_packet_decrypt_worker() { [...]
> > kworker/47:1-2373323 [047] 243644.756647: funcgraph_exit: 0.591 us | }
> > kworker/47:1-2373323 [047] 243644.756647: funcgraph_exit: ! 242.655 us
> > | }
> >
> > Instead, restrict to non-isolated CPUs.
>
> Huh, interesting... I haven't seen this feature before. What's the
> intended use case? To never run _anything_ on those cores except
> processes you choose? To run some things but not intensive things? Is it
> sort of a RT-lite?

Yes, the idea is to not run anything on those cores: no user tasks, no unbo=
und
workqueues, etc.
Typically one would also set IRQ affinity etc to avoid those cores, to avoi=
d
(soft)IRQS which cause significant latency as well.

This series by Frederic Weisbecker is a good introduction:
https://www.suse.com/c/cpu-isolation-introduction-part-1/

The idea is to achieve low latency and jitter.
With a reasonably tuned kernel one can reach around 10usec latency - howeve=
r
whenever we start using wireguard, we can see the bound workqueues used for
round-robin dispatch cause up to 1ms stalls, which is just not
acceptable for us.
Currently our only option is to either patch the wireguard code, or
stop using it,
which would be a shame :).

> I took a look in padata/pcrypt and it doesn't look like they're
> examining the housekeeping mask at all. Grepping for
> housekeeping_cpumask doesn't appear to show many results in things like
> workqueues, but rather in core scheduling stuff. So I'm not quite sure
> what to make of this patch.

Thanks, I didn't know about padata, but after skimming through the code it =
does
seem that it would suffer from the same issue.

> I suspect the thing to do might be to patch both wireguard and padata,
> and send a patch series to me, the padata people, and
> netdev@vger.kernel.org, and we can all hash this out together.

Sure, I'll try to have a look at the padata code and write something up.

> Regarding your patch, is there a way to make that a bit more succinct,
> without introducing all of those helper functions? It seems awfully
> verbose for something that seems like a matter of replacing the online
> mask with the housekeeping mask.

Indeed, I wasn't really happy about that.
The reason I've written those helper functions is that the housekeeping mas=
k
includes possible CPUs (cpu_possible_mask), so unfortunately it's not just =
a
matter of e.g. replacing cpu_online_mask with
housekeeping_cpumask(HK_FLAG_DOMAIN), we have to perform an AND
whenever we compute the weight, find the next CPU in the mask etc.

And I'd rather have the operations and mask in a single location instead of
scattered throughout the code, to make it easier to understand and maintain=
.

Happy to change to something more inline though, or open to suggestions.

Cheers,

Charles


>
> Jason
