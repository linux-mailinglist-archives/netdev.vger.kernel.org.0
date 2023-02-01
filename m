Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40039685DB9
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 04:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbjBADLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 22:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjBADK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 22:10:59 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE6367C7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:10:58 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id r8so10274059pls.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNwmbpoUgpK9RVRkp7WNwRkV3sDOdGK+t1bOk0Us3Hk=;
        b=uG73jEp1pU2t8G6JHpz8OVvf+yA+gdH9PWjp2kRgjfrsq8czTp9COZCbTrUx//NYbM
         daMPid1pjogAgV30y1s4yxAiTlW+nRiftfnOeA1RF2tRhMFjA/hawNexXC7jquDXmYSU
         DvtJzueJqGTs75yE5BaAxl8SHthb5ZcI/Ajyf0UO4t4kBfDHfMKd/KlQF9w1aGFur1g6
         2HBO5F9vUH/rcu+ybeOVyP91fK1t1XZ7QzGf9yYEjybGgRpx6ziGy3QyWZTt7LhKbKGj
         ybSEIuhqSPxmjLKxFkqzN4YLTmjll9JKHv57g+ZOkRM2wglcO8at+9mCl/RO7bCsG0cp
         sdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNwmbpoUgpK9RVRkp7WNwRkV3sDOdGK+t1bOk0Us3Hk=;
        b=e8PVTHW6UnDAxsmLSxsSGkgtW0keeJo1vrvifiMyHnOQP3lxwMd5+suFH+zCHKjBf5
         WEMJOkclbWWsNCJ1UjiHpCTn1uUza6bFdZLuTqtFNwW+j9SjsizzjiMlsHEuR2mGr9c1
         rPdnjyIug0WFuX7kC2squYd4ozzPmOFxv4/MBrDFuWBdtsoZlMG+PIszLt5j7EgQ10ug
         BGUm2eVO7zjvzZiNn3ze+lLJB5eqFnb0F8m9QY/g9mCxBpAql4LpJc9FW2fZZ7KPcLmo
         JkGPlIyk6kjhMpCZgrGGb0oIT9252Y7BRuiWauImsgLaiwTbp5P9Xb0DY0HJvlrSQ9w5
         IV8g==
X-Gm-Message-State: AO0yUKU50dFlbgVKjnd4hYiPqteuu4Hl6e0/O72r8QPWXxCXZAAhktaI
        vHvDhgzdghXUdTZbNnop3pboLg==
X-Google-Smtp-Source: AK7set9DGBNGEDhGrSL+h9Vf4nUXZLRGNhzNmVbfvX3VyTGxttxQ7Wg3L8E5XC0X+7fM+r9ZhpFOSQ==
X-Received: by 2002:a17:902:e1d2:b0:194:9de0:bed1 with SMTP id t18-20020a170902e1d200b001949de0bed1mr964856pla.32.1675221057642;
        Tue, 31 Jan 2023 19:10:57 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id g17-20020a170902869100b00189c62eac37sm10518521plo.32.2023.01.31.19.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 19:10:57 -0800 (PST)
Date:   Tue, 31 Jan 2023 19:10:55 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Pietro Borrello <borrello@diag.uniroma1.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] tun: tun_chr_open(): correctly initialize
 socket uid
Message-ID: <20230131191055.45bb4ab7@hermes.local>
In-Reply-To: <20230131-tuntap-sk-uid-v1-1-af4f9f40979d@diag.uniroma1.it>
References: <20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it>
        <20230131-tuntap-sk-uid-v1-1-af4f9f40979d@diag.uniroma1.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 01 Feb 2023 00:35:45 +0000
Pietro Borrello <borrello@diag.uniroma1.it> wrote:

> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index a7d17c680f4a..6713fffb1488 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3450,6 +3450,11 @@ static int tun_chr_open(struct inode *inode, struct file * file)
>  
>  	sock_init_data(&tfile->socket, &tfile->sk);
>  
> +	// sock_init_data initializes sk.sk_uid assuming tfile->socket is embedded
> +	// in a struct socket_alloc and reading its corresponding inode. Since we
> +	// pass a socket contained in a struct tun_file we have to fix this manually
> +	tfile->sk.sk_uid = inode->i_uid;
> +

Do not use C++ style comments in the kernel.

Rule #1 of code maintenance. Bug fixes should not stand out.
