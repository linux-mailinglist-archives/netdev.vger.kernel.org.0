Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5890969EDDC
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 05:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjBVERf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 23:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBVERe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 23:17:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD8434F47;
        Tue, 21 Feb 2023 20:17:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id bh1so7411490plb.11;
        Tue, 21 Feb 2023 20:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZgoCObWZS022InyqqYfJkQvKFN3Q/iAbVIPgnUe9F8M=;
        b=Ko9hZjJBOUy+49Xiw1eaQIcZR+enUA9FzzOz9BryCOeRitDG7UosaNwoPHlI9MUhM1
         KicWzzVzdOwUbq2JXmjN0b32lQs5rM/lVUFm32to/pLSaJh4bc9mkoV0Q62QjHuPd32Z
         KKBl1PtWP8mmRDVPW3coVs0t39UF1NJiXZ9SCBkvSbidfnZBtnf32NgaI96AueKApFvO
         SkvcFW/2HQJIHRQhyl2nCbG2Qj0wxiOcD+UCX6a9cuIFMn9PiKjZFPk+LAKwRyCRIMWJ
         snXqp1E7vqQRicIjxewRUyweXlQa/5bk/wQNkdnDLIL4iGY+w6P0rhR+AKK0Qd0upbne
         m54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZgoCObWZS022InyqqYfJkQvKFN3Q/iAbVIPgnUe9F8M=;
        b=ZqOjpHRLL9SZx0NHHRlmWdSlEBIjlK8FJ9VrbduhiXy+Y4ouHz5613Z5ndLY7znABC
         65jvqTv316+WLojrFkugy/ILG9cUQgVgj2/vhmZYdFi8kcMhFvFyzGJdWVOsUcrcQYNj
         VPeJ4sYKumQEej56s5VJ2V5WmrMldpXmZwaWRxvTsY3JSXvejCYm3gDA8dqieEiWUq9S
         4qTX2hVl7jceSt9hPPu6qNwa+F90Mf7VeW/XVzBMJCg0JGZc+3Yc7IbqCYrd55xyT3ed
         a7Pl6e09JMXX4Ax7pn9VqPWEFiU/eIQKyLu8GCDkN2oQrYgYNKDMPRmgGNnm8YI6RflT
         B5lA==
X-Gm-Message-State: AO0yUKVtFJBWib07Kg1Fbtat4xUUp/w3lre3AnsoVGo2Q2cuNXWK+nlQ
        tZ3/ZLiouWdHOBFkTjmXVEPcG1btdG4TpQ/sq7w=
X-Google-Smtp-Source: AK7set9xYViSJw+DpKn2vu5vqVSCAYABpwril8IDZRV8rEToGLPsys5cbTcFoRDzx/COweVS570zzcAPiziij/wmSbg=
X-Received: by 2002:a17:90b:4b0d:b0:237:222e:3c5b with SMTP id
 lx13-20020a17090b4b0d00b00237222e3c5bmr978918pjb.103.1677039452805; Tue, 21
 Feb 2023 20:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20230218075956.1563118-1-zyytlz.wz@163.com> <Y/U+w7aMc+BttZwl@google.com>
In-Reply-To: <Y/U+w7aMc+BttZwl@google.com>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Wed, 22 Feb 2023 12:17:21 +0800
Message-ID: <CAJedcCzmnZCR=XF+zKHiJ+8PNK88sXFDm5n=RnwcTnJfO0ihOw@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: Fix use-after-free bug due to race condition
 between main thread thread and timer thread
To:     Brian Norris <briannorris@chromium.org>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ganapathi017@gmail.com,
        alex000young@gmail.com, amitkarwar@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> =E4=BA=8E2023=E5=B9=B42=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=89 11:31=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Feb 18, 2023 at 03:59:56PM +0800, Zheng Wang wrote:
> > Note that, this bug is found by static analysis, it could be wrong. We
> > could discuss that before writing the fix.
>
> Yeah, please don't accept this patch. It deserves an "RFC" in the title
> at best. Sure, it's an identified race condition, but the cure here
> (deleting all possible recovery from firmware crashes) is worse than the
> disease.
>

Hello Brain,

Thanks for your reply. I do need add "RFC" in the title. Sorry about that.
The invoking chain is as descriped in the original mail.

There is some place which may confuse you. In
mwifiex_exec_next_cmd function, the adapter is got from
cmd_node->priv->adapter. You might think if this is the same adapter
in outer function. In mwifiex_register function, it inits the
priv_arrary with
adapter->priv[i]->adapter =3D adapter,
Then use mwifiex_init_lock_list to init the list. When it fetch adapter lik=
e
calling mwifiex_cfg80211_get_tx_power, it travers the array to find the
target priv. So all the adapter paramter is pointed to the same adapter.
The UAF of it is vulnerable.

In summary, after the firmware is downloaded, it will start the timer funct=
ion,
which is known as mwifiex_cmd_timeout_func. The if_ops.card_reset
function pointer is assigned with mwifiex_sdio_card_reset, which will
schedule_work the card->work. It finally pass the check becauese
card->work_flags has MWIFIEX_IFACE_WORK_CARD_RESET.

Finnaly, in _mwifiex_fw_dp, if init is failed, it will call mwifiex_free_ad=
apter
and free the adapter.


> There's no real attempt at analyzing the race or providing solutions, so
> there's not much to discuss yet.

Yes, I did't figure out a good plan to fix. As I say, it free the adapter i=
n the
error handling path. Could you please provide some advice about the fix?

Best regards,
Zheng
