Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BA569F83E
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjBVPmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjBVPmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:42:06 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FD740F5
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:42:05 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id c18so1391260wmr.3
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 07:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nw8f5byG/F3YoGbalXU1EaTBTMj3y23p7phZ4xgScHY=;
        b=cEInI9spwQdEs3MyGHgBWa58a6MbNbdxHkepCIhKWGKUpYBoKtUgzZLW3bll2qtUdU
         d23Q7LZPpKWFniX/AQ8gCEq/5c6hB++2nZEIEvZbxohDvI3GJ/qgfmGeY0PBd3/HtnXv
         38cVs8HmaeyC0N2SaZotUcjV1TEtyhuH6n3x/5WlcWZ/Hdj2dK9QqgrmusOIOj2Todoj
         xv9TCc+0ii5uqk9se+2jtFV419gwjcrwzGUSDv2CB5XDwQxXltDcyCI9ZrTLkRQvKUEr
         1JQqxz8Rkak+bBGEoC7zc8MJMZLvrBN2lX1rBe2sJCIqeO22JB7vJI78QSye4il9EJ18
         LPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nw8f5byG/F3YoGbalXU1EaTBTMj3y23p7phZ4xgScHY=;
        b=LDcs919/SRzBhsojG/kW6JTBkyY1Iz6J/TGbnoEQ9HJUFwrArKLeXxbVfDowW/Zb4l
         NZydB3eWfUHBGjWptshHGL6TBVJhOzCvshBJ+h3//QDBWhhVq57g3WW1gNNt9xZY2zJB
         IuR92EPEc4Sd4rd9LANNMX5qt4jbyBmxlUWblRWZ4kh0qmd/pu969MjgcFCISxlxMnWZ
         wUR5kphWFHt5R7JCoagHngtt7JNnb2xTXfXnHMvcry8sKhlbtCyB2rAOegmlgAVu45Ak
         AnjrEAHAGALi5ALwDNDPWmgUn83h6q0WLefXY3XH9slmCkRhrPc74k/1sY1OsPRPkY6u
         /3sw==
X-Gm-Message-State: AO0yUKWjiJMTFRS8/erW4MoPw/ap/5r+URMVYw4Tt6fu+CT6Vy/5lQ5t
        acKhcdg98Bpm+OV9ktmFIkGp/xJmUZWKL3JX3GV7Fg==
X-Google-Smtp-Source: AK7set/6GY33gcZOehd3qRAMZkQvnMhOfpkjzHnwTOT4RXEXkWNqVrTnxHUqu8NYnAyrOqqUTO19S2s3O6YGzej9ltU=
X-Received: by 2002:a05:600c:4e44:b0:3df:f862:fe42 with SMTP id
 e4-20020a05600c4e4400b003dff862fe42mr2347395wmq.10.1677080523815; Wed, 22 Feb
 2023 07:42:03 -0800 (PST)
MIME-Version: 1.0
References: <20230222145917.GA12590@debian> <20230222151236.GB12658@debian>
In-Reply-To: <20230222151236.GB12658@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 Feb 2023 16:41:51 +0100
Message-ID: <CANn89iK03mcdu=dn+kj-St27Y2OvSzQ5G=VzqwutR0Khn1cSUg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] gro: optimise redundant parsing of packets
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, alexanderduyck@fb.com, lixiaoyan@google.com,
        steffen.klassert@secunet.com, lucien.xin@gmail.com,
        ye.xingchen@zte.com.cn, iwienand@redhat.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, Feb 22, 2023 at 4:13=E2=80=AFPM Richard Gobert <richardbgobert@gmai=
l.com> wrote:
>
> Currently the IPv6 extension headers are parsed twice: first in
> ipv6_gro_receive, and then again in ipv6_gro_complete.
>
> By using the new ->transport_proto field, and also storing the size of th=
e
> network header, we can avoid parsing extension headers a second time in
> ipv6_gro_complete (which saves multiple memory dereferences and condition=
al
> checks inside ipv6_exthdrs_len for a varying amount of extension headers =
in IPv6
> packets).
>
> The implementation had to handle both inner and outer layers in case of
> encapsulation (as they can't use the same field).
>
> Performance tests for TCP stream over IPv6 with a varying amount of exten=
sion
> headers demonstrate throughput improvement of ~0.7%.
>
> In addition, I fixed a potential existing problem:
>  - The call to skb_set_inner_network_header at the beginning of
>    ipv6_gro_complete calculates inner_network_header based on skb->data b=
y
>    calling skb_set_inner_network_header, and setting it to point to the b=
eginning
>    of the ip header.
>  - If a packet is going to be handled by BIG TCP, the following code bloc=
k is
>    going to shift the packet header, and skb->data is going to be changed=
 as
>    well.
>
> When the two flows are combined, inner_network_header will point to the w=
rong
> place.

net-next is closed.

If you think a fix is needed, please send a stand-alone and minimal
patch so that we can discuss its merit.

Note :

BIG TCP only supports native IPv6, not encapsulated traffic,
so we should not bother with inner_network_header yet.
