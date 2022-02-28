Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E9D4C6DFE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbiB1NWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiB1NWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:22:31 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716CB74856;
        Mon, 28 Feb 2022 05:21:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v21so15417811wrv.5;
        Mon, 28 Feb 2022 05:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s0NsuICxJeQm5lZHkm/Wtp5kkx249MNu2vdtKTTuGUk=;
        b=YqPbzzlXLtxkL17lnGL4fy26gUBE9tSEaX0hlfyDI3J+mrfCTb/MY7fsk8K72tV0K2
         tankkm9cVwdhPdsTeM/ktTlBcaemkBX6AySPNpZzLssKWQxLk3XuQiIY/6HB6P7WMLON
         mNOaV65Iw//SQB5NFfy2TfxhXDKlFErusN9jkACgHdi9vqwU6EEaqbT2uxK4Hu0n3lp3
         tBG5MVyrnNhJjMzWTxQ/oo45YRsJHT1aSSCwjkF0yjfpiY/34cTlRVQgkQiCJvBmBMaO
         kiuEPpeO97d0Ic41TI7xb5/2NbLwAHfz5BTRFr0Jqmt9axcTHjsRfmipo1+N3nD2PI8I
         iiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s0NsuICxJeQm5lZHkm/Wtp5kkx249MNu2vdtKTTuGUk=;
        b=1DkI2vDE6G1nFI/2XlvAQ3MD6jJks+7OI2x9Zd6fA8Ub4iJe4oMtDO+aWu5dOZ7BuF
         v8u69AuOVz9JOgpvG+0LF5QOAIgynh4T3agaAjs0e5LOAa0u6HoUnC2YHKOmy18E+kK1
         qQwq2OKvuuwuMbW9Sy9cbfYzDus4bPLkgfNGEZPt8V2E6uVs6uVxHgN7uhdrETJ4HnIi
         SUalX5DWlVGX13OO+uffpS/y3jStAQNmb2TZoFPpHrwMxhtrn4cbTps//ikniPzm6lSC
         RGv9B1rrLie8Ez3dap6ghAaf8nRYHUFrBwoY1UpZxF8YYCvITVKqH7yCb8IRIp3PRI2p
         9fWQ==
X-Gm-Message-State: AOAM533oD6SwzlB1Nz7OpRF8ZEplocJXwSmNQfJL4bOKdrYRJHXDUMW+
        Wn2/YHHvHmGTJ6Ymzg+qc97zaoUWxQUNn9fzLqPPsB6KJKppg52yKfk=
X-Google-Smtp-Source: ABdhPJxDY5qYxFQLCoccs4Ge87le5cs+NQMPqimmygustN6/86J25yFXpRcgRjIypVqKzD0s79mslmyaW/uco4//Vp4=
X-Received: by 2002:a5d:694b:0:b0:1ed:9d4d:671e with SMTP id
 r11-20020a5d694b000000b001ed9d4d671emr15541690wrw.557.1646054510955; Mon, 28
 Feb 2022 05:21:50 -0800 (PST)
MIME-Version: 1.0
References: <20220228094552.10134-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220228094552.10134-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 28 Feb 2022 14:21:39 +0100
Message-ID: <CAJ+HfNiMQOgnKfa2EtnazK8MuQx5zUtF8GzQjdo-kUAoDv+Z1A@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: fix race at socket teardown
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Elza Mathew <elza.mathew@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 at 10:46, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> From: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Fix a race in the xsk socket teardown code that can lead to a null
> pointer dereference splat. The current xsk unbind code in
> xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
> xs->dev to NULL and then waits for any NAPI processing to terminate
> using synchronize_net(). After that, the release code starts to tear
> down the socket state and free allocated memory.
>
[...]
>
> v1 -> v2:
> * Naming xsk_zc_xmit() -> xsk_wakeup() [Maciej]
>

Magnus,

You forgot to include my ACK! So, again:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>


Cheers,
Bj=C3=B6rn
