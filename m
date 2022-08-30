Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB75A6B10
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiH3RpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiH3Rot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:44:49 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9434CB2760;
        Tue, 30 Aug 2022 10:41:34 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id v26so6295559lfd.10;
        Tue, 30 Aug 2022 10:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=fqPF+MWfeg/k3XnE3nr5+5+Bm3YtEGzavSRsoFVY5bU=;
        b=JGt/Sl5KZiypaJtO/ZevExJngm47fE7Lp/B4DfxkKe2QnPOs5oHE+w7R9CsOAhlYBB
         TfyA3Md/yoShK6WcrVQd/UURiBX9kMI1AFYb0AJ2ua5hQ4JSD6EVoLlrECUv9NgMv5Xo
         8sGwMvQm14FkIry4dvSfLvNeUU/cCw0oEPFnjBFCQWFXZufUD2BGfotKoOAWq1XVe6ih
         e6VG53UH980nqhEDJVsXWknMcFOyWzPpctD1ErQ6/mzg3LaOJRMliMLUA0m44nQmwb3M
         XVWvVNZ9+JQSgV/xbKvoxjpb14rdqGFET6NyMMkkc1BqR7DmefC/4SYx1yOg3SEpMNHJ
         VBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=fqPF+MWfeg/k3XnE3nr5+5+Bm3YtEGzavSRsoFVY5bU=;
        b=5G14WZNY959ir8mPM8ZB0w7/N2FBfWrP/JP2XFp/Bfv91jg+w5g4tw9NQ8fOqP5+IE
         sHq4ynOFkcE1b51s5tvfNsbmDJtUW1x9pfEvYRZPWRQ5Ftsm4H228PXnOlj9n7bLCM/8
         fI7kmL3QO1WY3wOsFzmOa3rLlyVNh4dYfuDgREjfpa/+V8M658G3iDmTvkFvhb2GqYGo
         KxNpFGM9WYDW4RdRAmvk4XwN2llNj5fJcnYCM0WAtGtGRO5BoBhPuHoGVs/hv0uU+g5P
         dYvsQur5/XTaf+Gh4ibL5qT2JewEAeKUhRl+erO3jt04Et5UUVDyYu3hSsS0OSk7B25z
         nG9w==
X-Gm-Message-State: ACgBeo1Ykj4PCW95H3w2IDWMGk1mrL//4rM+liSql7pO432+FnRYVLgK
        4PoJ4umbhsv/SfVonSX184YNcIOfu1NJN1G10+0=
X-Google-Smtp-Source: AA6agR7sHG4w93xAS6KYapqGyUBnhNmV4MRbk0BLnzFoBmM7S5TDHo9WUpNk4qfGndrsF/+tJZcqmc7POhPosTXqoWw=
X-Received: by 2002:a05:6512:2621:b0:47f:d228:bdeb with SMTP id
 bt33-20020a056512262100b0047fd228bdebmr7618563lfb.121.1661881291091; Tue, 30
 Aug 2022 10:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4S-me4hoy0W6GASU3tOFF16+eaotxPbw+kqyc6vuxtxJyDZg@mail.gmail.com>
 <CAO4S-mfTNEKCs8ZQcT09wDzxX8MfidmbTVzaFMD3oG4i7Ytynw@mail.gmail.com> <f53dfd70-f8b3-8401-3f5a-d738b2f242e1@gmail.com>
In-Reply-To: <f53dfd70-f8b3-8401-3f5a-d738b2f242e1@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 30 Aug 2022 10:41:19 -0700
Message-ID: <CABBYNZLZv_Y6E-rFc3kKFk+PqwNkWAzneAw=cUTEY4yW-cTs1Q@mail.gmail.com>
Subject: Re: possible deadlock in rfcomm_sk_state_change
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Cc:     Jiacheng Xu <578001344xu@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Desmond,

On Mon, Aug 29, 2022 at 11:48 PM Desmond Cheong Zhi Xi
<desmondcheongzx@gmail.com> wrote:
>
> +cc Bluetooth and Networking maintainers
>
> Hi Jiacheng,
>
> On 28/8/22 04:03, Jiacheng Xu wrote:
> > Hi,
> >
> > I believe the deadlock is more than possible but actually real.
> > I got a poc that could stably trigger the deadlock.
> >
> > poc: https://drive.google.com/file/d/1PjqvMtHsrrGM1MIRGKl_zJGR-teAMMQy/view?usp=sharing
> >
> > Description/Root cause:
> > In rfcomm_sock_shutdown(), lock_sock() is called when releasing and
> > shutting down socket.
> > However, lock_sock() has to be called once more when the sk_state is
> > changed because the
> > lock is not always held when rfcomm_sk_state_change() is called. One
> > such call stack is:
> >
> >    rfcomm_sock_shutdown():
> >      lock_sock();
> >      __rfcomm_sock_close():
> >        rfcomm_dlc_close():
> >          __rfcomm_dlc_close():
> >            rfcomm_dlc_lock();
> >            rfcomm_sk_state_change():
> >              lock_sock();
> >
> > Besides the recursive deadlock, there is also an
> > issue of a lock hierarchy inversion between rfcomm_dlc_lock() and
> > lock_sock() if the socket is locked in rfcomm_sk_state_change().
>
>
> Thanks for the poc and for following the trail all the way to the root
> cause - this was a known issue and I didn't realize the patch wasn't
> applied.
>
> >  > Reference:
> https://lore.kernel.org/all/20211004180734.434511-1-desmondcheongzx@gmail.com/
> >
>
> Fwiw, I tested the patch again with syzbot. It still applies cleanly to
> the head of bluetooth-next and seems to address the root cause.
>
> Any thoughts from the maintainers on this issue and the proposed fix?

We probably need to introduce a test to rfcomm-tester to reproduce
this sort of problem, I also would like to avoid introducing a work
just to trigger a state change since we don't have such problem on the
likes of L2CAP socket so perhaps we need to rework the code a little
bit to avoid the locking problems.

> Best,
> Desmond



-- 
Luiz Augusto von Dentz
