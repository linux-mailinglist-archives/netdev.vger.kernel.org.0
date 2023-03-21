Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC916C36E8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCUQ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjCUQ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:27:15 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C6A4D41C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:26:58 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id x33so10638088uaf.12
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679416017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfcVdPF6O/e0M8lwnELdW326dFuq7YJBBa8nV3qV7aY=;
        b=YN9sR16tCc6mAleq7+44m2v6XJajevl8qnfmqgbYbdGETN2Rcs5hlhUN0ET7NvAsTs
         U4QNFYBat70niiKMC9MmrneuUrs/39gPBdxCCssVDKZZCEJLlQ/OfEt+27wS+cz6hdzk
         4zSOAGmsNymESLe+WEXkJ3KJlSRwhNKALCRrFqu/DqnAiZHyTUZJ2wOJ9PVo8dYJHpr7
         81/ofV/YkZ4IX2unSHT54m1vNYdiGD/8VJhZorPI5eKtDDLnnj+se5Lw79zaGKKinJGD
         SMCXuceWKfULMaxaXX/PRORmQRC8kHMC+EeSfgBNjJomuRwMZXMD44uDVA0ydFrpfg1z
         f+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679416017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfcVdPF6O/e0M8lwnELdW326dFuq7YJBBa8nV3qV7aY=;
        b=Namw7Z8f8PGQg+qaDfDRxvJeK24hoGilzeyHkSFtx0XM+1zVUaOmXupLcJVcS2yZye
         aYh8qI053r+kwexFiDcYVJhrRyavuJd8RQeuH5SFfOnVu+ShtkfuQRqLUxXyYV8nzE0b
         /AkedLaXYlvdDkd4gK96lVLfQoIoKP1Ya5ngA4YRRXVlizYYQ4fXNL4rSqW6DP3rwOJy
         LPeHTPDRWwhQ1M1Jk5YHthLjAwFKJJza7LeMgyt+bwYFYIL8gNAV5oJVumtY8DI1/vqt
         UuEdyhN57aAuvcE9naQ2XspK+yjJycWKZLWn7MTVYGPoo58N+9+bubpoWxIPQ7aVeXit
         fUhg==
X-Gm-Message-State: AAQBX9ceY9YwuI3mHXId5/++Ral9vDtoh2/bkR29laSLQEgp3JVji3Dl
        g9OTaMiR+kDV7oELjhqiWJUz10l2wUIYhzZYN6q4qQ==
X-Google-Smtp-Source: AK7set/BNkQg8X6LEh1EtVxr79lbh+3l9XU830vQaRFX7utWhUPEVbtDdvffbGN2T+cAb7a2B+tJbRL07j+wx8BNbBw=
X-Received: by 2002:a05:6130:c84:b0:68b:b624:7b86 with SMTP id
 ch4-20020a0561300c8400b0068bb6247b86mr491516uab.2.1679416017391; Tue, 21 Mar
 2023 09:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230320163427.8096-1-edumazet@google.com> <ZBlUXFdZybQ8BJ/k@corigine.com>
In-Reply-To: <ZBlUXFdZybQ8BJ/k@corigine.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 09:26:45 -0700
Message-ID: <CANn89iJzniaHGYDWL4o8BWp+FBMH_RMaZuCzt+uh5gHicJQ+Pw@mail.gmail.com>
Subject: Re: [PATCH net] erspan: do not use skb_mac_header() in ndo_start_xmit()
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 11:53=E2=80=AFPM Simon Horman <simon.horman@corigin=
e.com> wrote:
>

> Hi Eric,
>
> A quick grep seems to indicate there may be similar problems elsewhere.
> I didn't check them in any detail and I'm wondering if you might have.

I have a patch series of three, but for net-next.

My plan is to remove skb_reset_mac_header() from __dev_queue_xmit :)

>
> In any case, this looks good.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
