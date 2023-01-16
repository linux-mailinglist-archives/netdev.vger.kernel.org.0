Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94B766C6E4
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjAPQ0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbjAPQZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:25:23 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12252B630
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:14:14 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4d59d518505so218128347b3.1
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 08:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UwmTNyuj4yHwo83fYQ+pdmfn9/U27lDmkbxPGaMI4Rs=;
        b=sZ5xCg8ZinDV3UFvQgzRmSXBxsymLiAt7ZubDLY6hScZobkywrs0R9WCTiLPXg0fcH
         CzU3JV/Z95IrKGI6twSF4vY39cv045FbcUFTpT1qaEI3HwPsXSUgfsjhvEjaNORy0prk
         zPayiHIykmQ7/PVfWcLNe1+N621fmV7Q6h76IKJ3hp1EpV9LaG0wdPtxDXvcKK0ktHCe
         jfy7NjgHMocMaF962P6efirWOhYgIUYjunLqdnRZ3w0yOEWqyOT2KuuQL2esKjm7OYfm
         WEt0ZE5bvA16zsIf7GfW1/kdub5e4VEr/eb6kxHG/6bXJyIcRSoUzd8p3XouKQ4rWK1w
         uHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UwmTNyuj4yHwo83fYQ+pdmfn9/U27lDmkbxPGaMI4Rs=;
        b=Wur2oTl9/fRcuZdfKHtox1xhnpEe5VrGVRFTi/XTEBrxvUzzAZFxHWvbGmvSqUDtIN
         kmt2zTi9D8+TXR/lO/3OO/Cwg2UCpqLFBdqtVFKBg3rdatHeH3ZZo3bL94jWDvXCQRIy
         vVruZP7xi8VjZKFQ6FGa2RXMDRBo85pgutMY2RHN4z3l+U9ZnsjSNlNTnsfbeZVNGZq9
         Cci7tFxWVEHCtOb6JrnGL9Gb+SnW08MlZbM2zACsw0UHg04Nib+HWoL613mDudhKhrae
         +TorIul6H5OBKHY5M1QWEfNFVHpghPUA02ku49oLoMC2yFLPsEsfvzk+Xb2l60Y6rFKM
         gQWg==
X-Gm-Message-State: AFqh2kppp5aF0BD/KcZ8Yk7AmGsRZMHNAbIicB6hQJiVzCw+KhlAwtUo
        DnPReBNzY0ghTbdIXzUxQ4WfG1z1QF9U++0flsLpUQ==
X-Google-Smtp-Source: AMrXdXs7jXfmcaCNvvpXxEqGdAKbIDPDdmqjFitTjT/gRAGj25faeG4GwtkadE4RNaTZbjDfWW///oF4sl9W1lKVX+U=
X-Received: by 2002:a05:690c:313:b0:37e:6806:a5f9 with SMTP id
 bg19-20020a05690c031300b0037e6806a5f9mr4886054ywb.47.1673885653534; Mon, 16
 Jan 2023 08:14:13 -0800 (PST)
MIME-Version: 1.0
References: <20230116145500.44699-1-007047221b@gmail.com>
In-Reply-To: <20230116145500.44699-1-007047221b@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 17:14:02 +0100
Message-ID: <CANn89i+QqO6PoYi=S7PPzxUgL=r-RP1=gCXsxXOBfJriU2avuw@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Remove extra counter pull before gc
To:     Tanmay Bhushan <007047221b@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 3:55 PM Tanmay Bhushan <007047221b@gmail.com> wrote:
>
> Per cpu entries are no longer used in consideration
> for doing gc or not. Remove the extra per cpu entries
> pull to directly check for time and perform gc.
>
> Signed-off-by: Tanmay Bhushan <007047221b@gmail.com>
> ---
>  net/ipv6/route.c | 4 ----
>  1 file changed, 4 deletions(-)
>

OK, please next time specify which tree your patch is targeting (this
is for net-next tree here)

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
