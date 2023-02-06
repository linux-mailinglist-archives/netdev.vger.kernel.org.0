Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7812668B75C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 09:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjBFIaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 03:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBFIaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 03:30:05 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76F41A94B
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 00:30:03 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id az37so5721743vkb.2
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 00:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3YQOnjyIZ+V6xLKJZ1YLEXo53MRC6JV/Xmhkcv/e+TM=;
        b=MQN+c25kEyBeXrZHH+tSGiKhRiSbUCpHHk1eJKegt5dyLkp6KcQLyurDcBrultH4pA
         0RJSWwmESVLHgtRWJ65hZ5QZD6i6TI/uqOrbdMG0dzxbU82jo9wFGVOogVWpZnpLqfPX
         edgZLRoQyRj2XE35PtvyK/LjBEGYJktHX+1lb58vTOxFLWXmbtnurrJ+KaUnrS9OF+F/
         +75cUFACE3Lxf9cDSFXUmh31hvOOKhsr5Iwr22hRpKT+FG7LNUsY05VeGisn2OQIyYw+
         vTY7Tx4BeCJIupHmCp2R1R1p6UDOknAgFuGivK8ITIpGuddXJIyBydHGLoJoGL/MRf7j
         g05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3YQOnjyIZ+V6xLKJZ1YLEXo53MRC6JV/Xmhkcv/e+TM=;
        b=XgyQ05ip93IJV5U6AqTK7WjXrSn3Mn5LyPNbHQ0kEqbGtslezvS5AlpQ9mBUmfeJFh
         CR5Qn++O5eLFOK3YNTVzQfRfCHc+qgmQ+M733S1qyytJlsmCsLnzo4PDGCBzLkk0pU0I
         jOeYd9NazdC9PW8lOOlJ33ZTUtYYgnEHi4RUxFWY2j5UTYss5E3zwqvL9etsrhe/S41x
         kkcrRSrlwPY4B/IMiJaj0IDiASCkvy3D4SQzTt9fIf2Fv/0FRxUOXTqL6coW2WJsYVX/
         bbV1e3cCbFOQvu4CAULI8AsK5s81h0z+wWJ9OK8xQ0iyounHdzpt8JNZ4WpUzf20Bym3
         hJiw==
X-Gm-Message-State: AO0yUKWMrY8i6NmqHr0QEcxvRhmhUgUV6xwVPj2xppa4b9l+H/LvV7+M
        uiNHFlKfdQEjDJMmqOWx9Bi++uy79OT13cTevYKh+g==
X-Google-Smtp-Source: AK7set9T8AjfIySkEm30Vz2m+oaHw7+ERgX1tbl/naKvtfQPvCTQA3eEbNYLakoC4Tfsi1sMNOM8pIT6zPu7biAnK38=
X-Received: by 2002:a05:6122:2ba:b0:3dd:f386:1bca with SMTP id
 26-20020a05612202ba00b003ddf3861bcamr2887716vkq.33.1675672202754; Mon, 06 Feb
 2023 00:30:02 -0800 (PST)
MIME-Version: 1.0
References: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it> <20230131-tuntap-sk-uid-v3-2-81188b909685@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v3-2-81188b909685@diag.uniroma1.it>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Feb 2023 09:29:51 +0100
Message-ID: <CANn89iLqDA_O3kFNdcJXcPQK+2jWXcN2CexVJYuexPGiuriq0g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] tun: tun_chr_open(): correctly initialize
 socket uid
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Sat, Feb 4, 2023 at 6:39 PM Pietro Borrello
<borrello@diag.uniroma1.it> wrote:
>
> sock_init_data() assumes that the `struct socket` passed in input is
> contained in a `struct socket_alloc` allocated with sock_alloc().
> However, tun_chr_open() passes a `struct socket` embedded in a `struct
> tun_file` allocated with sk_alloc().
> This causes a type confusion when issuing a container_of() with
> SOCK_INODE() in sock_init_data() which results in assigning a wrong
> sk_uid to the `struct sock` in input.
> On default configuration, the type confused field overlaps with the
> high 4 bytes of `struct tun_struct __rcu *tun` of `struct tun_file`,
> NULL at the time of call, which makes the uid of all tun sockets 0,
> i.e., the root one.
> Fix the assignment by using sock_init_data_uid().
>
> Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
Thanks.
