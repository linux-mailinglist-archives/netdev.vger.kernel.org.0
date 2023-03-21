Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7996C3951
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjCUSl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCUSl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:41:58 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590FC136D9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:41:57 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id c10so7088094vsh.12
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679424116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwwt5gENAoNCgRuBuq/sm3Iy2cfNMn+vrg8lSHE5VLg=;
        b=noavD+zvF1ufMTfu2dfT1ysFEuiaAxDk1m5xlCUAADQiCuEOMZCZzJwoOTl12XBixq
         CluzqVND1zq+8oeTsP0J3UfE8LYovdLVe3NQbAY1q0UGI2j/bxfukgMbn6dwT/gKJC0N
         sLplATxZ8TLoTJ2VR3d+fkxCip8D6iS/CvM1tG/kVt8lV9TH3OptHJ8+Pfve2GpwmAZ0
         518m34HF7bGQLXMBdkjgq8OCFIsoPOiX8ALC9d5NncBdCJkAskQzMNHbkPLCW2aW1fne
         DK1lwzXI2p9RKhqSvw7Zkd8lsU7uKhBFQfcHM2CyfjVxjOKjk0OOLh1hh36AmS74svwU
         435Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwwt5gENAoNCgRuBuq/sm3Iy2cfNMn+vrg8lSHE5VLg=;
        b=iL4zLCFRL6CBproAC9De5ZFFmaalMgOwnLh5yloU+DzaBFJoNEG4K2UX8NZtup9IPt
         cELgkK4Yb9AzYMrl6+EGubPU8WC798U4ki/eZ8I/hCex6k6iKceqK3TLpcSaNROaFpdd
         /ca0geoDtjRXxm0ZOS8ka0yCFuYTuEMbBqxPb4mVwiuKnHsrgv+mqfGGEEkGA1FcZ2v2
         bl2TiyvLMblxz2BDWW8a+LVH2G5pFr3784OsZuhi6uXTCugMPwvlqXjXbx6dvB89kfXx
         nYZLZKrOz68aVk8AbFpszHToaPqFLTmLGM8YlyvPIXJKZodfLHCPklMd0aK7necplc87
         YsPA==
X-Gm-Message-State: AO0yUKUlnkAiUCk225ZGrvb/0UPxrlWyF7VoQle39oIA1bceCAsYf+xV
        DlZtSERw66eRvTcmjh6AtPqMVr7Fb5ycBDib0pqpCg==
X-Google-Smtp-Source: AKy350YRy3I46Q2W8U4iPHYFkOv+ZUFWLpZrfX2R7sytgDMN6T0efc6E5Y3b0KFMyZSqZyhKWIi8xkEWe981nC6GS7k=
X-Received: by 2002:a67:d581:0:b0:425:dd21:acc8 with SMTP id
 m1-20020a67d581000000b00425dd21acc8mr2272684vsj.7.1679424116291; Tue, 21 Mar
 2023 11:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230321164519.1286357-1-edumazet@google.com> <20230321171333.t4u6z2n5ex76h3ot@skbuf>
In-Reply-To: <20230321171333.t4u6z2n5ex76h3ot@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 11:41:44 -0700
Message-ID: <CANn89iLo158gsAJkTo73V81k9zjgf-YZewXFRW0KQn3QzfnqPA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: remove some skb_mac_header assumptions
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
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

On Tue, Mar 21, 2023 at 10:13=E2=80=AFAM Vladimir Oltean <olteanv@gmail.com=
> wrote:
>
> Hi Eric,
>

> skb_mac_header() shows quite a few hits in net/dsa/ as well, in functions
> that contain "xmit" in the name. Should those be changed as well?

Hi Vladimir.

Yes, any help that you can provide (especially if you can test
patches) will be much welcomed.

Thanks !
