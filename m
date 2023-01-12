Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D627E667A1C
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjALP64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbjALP6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:58:21 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724B31C916
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:49:02 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-4d19b2686a9so117966317b3.6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EFnBgp8sKNMcozkemqsM7t3At7lZQ3YTRWClWxcrMA=;
        b=XYH97tPQss7abIK8Pz2e3QdpQu4oBtBTFDtRGTHrsSuqDXRDdURoABn3nvpl2do7kL
         QJtrz/4K9sesLDxZVtfV1qzimZTGmnG6ducZ9zxecFXOZO3xbAk0oix8+Keq3quHEmLi
         /TgGDOQxod3vdAbvWO38E55ZFsmWEoEc6QWA0FAjYelIDslozzSJmeMKVt4XRExjfOKS
         kJZbHbzHnjE6+skao78/Lq35fkAF1Vrepc4nFohA2G17pmSP8MronV8rBS9jGwMK5cDR
         MoDRL+AE5+5mCwEm7G80C9UZ8Ri7aRHN591EdxTAAHy7xjYq2O/sEeefIu1402XnWgO8
         gs4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EFnBgp8sKNMcozkemqsM7t3At7lZQ3YTRWClWxcrMA=;
        b=ei7iqP4V+rURvb5pfFiFKAtiG0n44EA2wOn0BXjBkgfpqdx56gkEKKO85uZH8Re5xk
         aIRi7FEzVNM20y736XaRDC3fZAJtn6VDoQqAomC8+4oVR6Cq9wB/npxrP5Uxj3QOiqIo
         Qtiy6RS5bYlnNGE0DJc6q3PVTO5RorS06XctdaI1VNN1UTkEJiUo50thNjRBed/y7jPc
         j+ra0P8Nrvv5kIx9/5IFNrOljFEQMdP2e8eNLqzx2FwvlzZj5KgPvDNEqSoejTs+/O3f
         4WWTpp3c7Cdb2ixlm41gxu6L3IFJhG6xArQJMZZSRP4FCYqvUPnVzqBymzCuht1X8nFg
         0nBA==
X-Gm-Message-State: AFqh2kqM9OdjYeXVwJUvXQA+uSUnAOEazE6INHRahTLH7fyXxFHM3eHO
        B5tJbZIX+uXLfGcK1XCtEW/udXLtBuZM0LbHbwTRvakCtQnHrA==
X-Google-Smtp-Source: AMrXdXviGfsXl0BnVS8e+IPWcvIKG6tGZmQ02O8a444ALe88dS6kBm//X5Hiagbwn9wQpC7Z8vzkQ8f2NzQUc29Scmk=
X-Received: by 2002:a05:690c:fd1:b0:4ac:cd7c:18d2 with SMTP id
 dg17-20020a05690c0fd100b004accd7c18d2mr3631387ywb.427.1673538541604; Thu, 12
 Jan 2023 07:49:01 -0800 (PST)
MIME-Version: 1.0
References: <20230110191725.22675-1-admin@netgeek.ovh>
In-Reply-To: <20230110191725.22675-1-admin@netgeek.ovh>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 12 Jan 2023 10:48:24 -0500
Message-ID: <CA+FuTSema7dvUzqh4rg2yX918svdQPEBY9mRMZKPK_Oi8E_Tmg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/af_packet: fix tx skb protocol on SOCK_PACKET sockets
To:     =?UTF-8?Q?Herv=C3=A9_Boisse?= <admin@netgeek.ovh>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Jan 10, 2023 at 2:38 PM Herv=C3=A9 Boisse <admin@netgeek.ovh> wrote=
:
>
> Commit 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided
> by user") introduces packet_parse_headers() to extract protocol for
> SOCK_RAW sockets.
> But, SOCK_PACKET sockets which provide similar behaviour are not consider=
ed
> so far and packets sent by those sockets will have their protocol unset.
>
> Extract the skb protocol value from the packet for SOCK_PACKET sockets, a=
s
> currently done for SOCK_RAW sockets.
>
> Fixes: 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided=
 by user")
> Signed-off-by: Herv=C3=A9 Boisse <admin@netgeek.ovh>

Reviewed-by: Willem de Bruijn <willlemb@google.com>

packet_sendmsg_spkt (SOCK_PACKET) also prepares raw packets and
validates their link layer header length with dev_validate_header
before calling packet_parse_headers. It should be fine to call
dev_parse_protocol.

Technically this adds a feature to packets of type SOCK_PACKET.  I would
not qualify it as a bug fix. And not sure we care about adding new features=
 to
SOCK_PACKET. New applications should use SOCK_RAW.
