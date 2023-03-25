Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F896C8F41
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 16:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjCYP5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 11:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjCYP5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 11:57:11 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460EF1041E
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 08:57:07 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h7so2431992ila.5
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 08:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679759826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IDz7yIG9Izbiq1h274zfmiMuoeRbSnme+oAuz3O2pM=;
        b=cAvgoTA51G1covSTXw8lExHt0SHLmjcVrcocTO89CB0Zq+6Q+nZuIqQeYhvYhobnGN
         p+4XhQAGHrBcJYE7dm1GSTl71bFrTRYcl8M4x26Tw58oIbhN1Zup1QPTfIfzLGBEmCA2
         3SpSd9LGG9Kuy/i//nhp3DK7ro8MBNJTRywL1gxDwKfD2fKfgpV1SATOZCFdol/kqOsV
         QCxPsygQZitVtPkvBX6BbH5EBpFqM6kugW5X1qOraeDThWridvOkJi9N/hf9fYWHxC0k
         1L2cuWuR3Ahx3vVN5gQLF3XJGwOP7Y+tKqbor0MtcgW2LgUzLovvbuMFYfm1DNCDVJzT
         uNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679759826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4IDz7yIG9Izbiq1h274zfmiMuoeRbSnme+oAuz3O2pM=;
        b=CLrTFjp3CndZqiaMvpBuJCoHv7+JYqCHilahVKLlbJgf0SlvRipflZK3sCq0ftScVF
         rAIbPyQ8II4gtdMLTvv4ZkOg6K3oNGl/GUf9un4oIbjU/3cBXIMQOCTyPLd1ArSHBU7I
         w5vEbVJToqQ9x+lc/teKu5QHomMvRUGQiRjp4CwOsoBuqI5omwQjF7/0lohPvbpiMRQu
         Mwf+AKus3F5xeZTARUIWqaZGa2ND87FtMkIs7Xz5P7t6+ZMp+jAUDxTyAXohMxsXN+tw
         Iv0inFCdw1FA/DWVtZ9ndTOEAn9MNKAvcJ/jkJ/VuzcPHRRr26Ph3b4kgf5mIn1f2G5G
         3Naw==
X-Gm-Message-State: AAQBX9eY32dUpnSdElTVDjAvDlDVfZSZ9usuFuvvXcj9M8XPUS4pW/GC
        82LPRqWl/J9jTfoPA7cgCi/e6Au82FK36Mu4/5hMPA==
X-Google-Smtp-Source: AKy350aLScWKCHx9GTcovR4WF4Wf9WzvdnhVzZ7fZTxiYlX2XjlALeIRulT4Fb7ZbKc9iO0/9av5Qvm3szjwmoo9q34=
X-Received: by 2002:a92:7c07:0:b0:310:fc49:1d9 with SMTP id
 x7-20020a927c07000000b00310fc4901d9mr3377780ilc.6.1679759826290; Sat, 25 Mar
 2023 08:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230325152417.5403-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230325152417.5403-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 25 Mar 2023 08:56:54 -0700
Message-ID: <CANn89iJaVrObJNDC9TrnSUC3XQeo-zfmUXLVrNVcsbRDPuSNtA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix raising a softirq on the current cpu with
 rps enabled
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 8:26=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.c=
om> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> Since we decide to put the skb into a backlog queue of another
> cpu, we should not raise the softirq for the current cpu. When
> to raise a softirq is based on whether we have more data left to
> process later. As to the current cpu, there is no indication of
> more data enqueued, so we do not need this action. After enqueuing
> to another cpu, net_rx_action() function will call ipi and then
> another cpu will raise the softirq as expected.
>
> Also, raising more softirqs which set the corresponding bit field
> can make the IRQ mechanism think we probably need to start ksoftirqd
> on the current cpu. Actually it shouldn't happen.
>
> Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/core/dev.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1518a366783b..bfaaa652f50c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_data *s=
d)
>         if (sd !=3D mysd) {
>                 sd->rps_ipi_next =3D mysd->rps_ipi_list;
>                 mysd->rps_ipi_list =3D sd;
> -
> -               __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>                 return 1;
>         }
>  #endif /* CONFIG_RPS */
> --
> 2.37.3
>

This is not going to work in some cases. Please take a deeper look.

I have to run, if you (or others) do not find the reason, I will give
more details when I am done traveling.
