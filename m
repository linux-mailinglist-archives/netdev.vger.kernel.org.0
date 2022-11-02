Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878BD616FBD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiKBV2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiKBV17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:27:59 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79422FADE
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:27:55 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-367b8adf788so178597987b3.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 14:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+pZVFaJ0a9yMn0DeC1TZTmd+BvS0kFwaSjb1eq920A=;
        b=GzQwOQasEgu++Sa8R7GBkzKuvcMGYKK1UUBnnyDTlz+24PoGsUeFmITxDx7paYRO99
         IZauKiJl1o06uH7WHWe4tT5qRA5bYIEXFsLxfITW28OHHoBmO4O4CRzv8Nvms7xFGjK+
         ozoGe9KUfI4TiMmJqm8iKnmlo/ScIRapbmP7deISNe+Mh9MKPqZ3URPyG7yoHHqQ9B/J
         Af2DblTlGlL/4TgPJaIttEoQKUffHzJkbadigBwUr8eQbYZDmHlElbEc3x7IULwjH7Lp
         pNFoe7E43FFoMDkjU/xHOXmmUCkkIW7mmamjeCLchbzv1PYGkPy83qNGs+nZjhRm6khi
         jiBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z+pZVFaJ0a9yMn0DeC1TZTmd+BvS0kFwaSjb1eq920A=;
        b=gyKclL0EQxaf163YJj802Z6c4fMAvHYQ/HX7xWWwosAEovipNiYcQtW/929W1OLDQK
         apC3+m1fprHBGne5E9Vvt7IfLVwpVtGxmyTbeubo7wF0X2jakWblY/eIzAnwAP9cwDLR
         A7cMD+tLEpBLGbeqVwDygOwXRUdkQv3g7A1SeIWkpY5XoBRlIgVppjq/fczB0qNCh09B
         qHifXibZlsg6k8unYc654FcwM5zRoOYS68FoPX8msH9+th7yJ8HAKlNDSE5GsN7bRSYj
         obvRwRVZ82xz8/4tzckwiyxMr1ITXZLlkBtSTkyvt+nINC+LvIdqpbTj3EoUUDTN96B7
         hgJw==
X-Gm-Message-State: ACrzQf2CvFWC0+HH4Z1sv4z5KhiRZTHL0IO1qtVuw4tjr87ICpdJ3Auh
        9SkFlDwSEKVb/MSF+SkKaPHyMCEfnPAM3OlinKA4CQ==
X-Google-Smtp-Source: AMsMyM7vy4hPxpGT4s8wrSfsYJ+X0GIWjt4pOIwnx76uvSUjhusOlRJcSZENQZZVkBCQl/L91PWixv/Qf/ngsuvxjRo=
X-Received: by 2002:a81:ad09:0:b0:370:5b7:bef2 with SMTP id
 l9-20020a81ad09000000b0037005b7bef2mr25818029ywh.47.1667424474380; Wed, 02
 Nov 2022 14:27:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221102211350.625011-1-dima@arista.com> <20221102211350.625011-2-dima@arista.com>
In-Reply-To: <20221102211350.625011-2-dima@arista.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Nov 2022 14:27:43 -0700
Message-ID: <CANn89i+7pbdiw1=7DTrvdQ2NrRUb33oBFKCHHG2b6xNwrNEbZw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Nov 2, 2022 at 2:14 PM Dmitry Safonov <dima@arista.com> wrote:
>
> Add a helper to allocate tcp_md5sig_info, that will help later to
> do/allocate things when info allocated, once per socket.
>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---


Reviewed-by: Eric Dumazet <edumazet@google.com>
