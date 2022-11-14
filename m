Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0C5628719
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiKNRbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbiKNRbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:31:51 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE749A476
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:31:50 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3691e040abaso113073567b3.9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eWU2AWq8Eq3gqU4BhZFYarDK0bOR9ZheOlzcH4UPHes=;
        b=ngsM0y8DuJGgF6yy8pkYeuleOgOYsTtSUCNcLqT1ekUQUW6OmtLiaeNsys8QDH+ULi
         zDkbmATi0P9/UGnfA+2IHWgiCKLQwq/05CAUEP1esz1giJb3nMlqNWuqhbJVsd4Yopsp
         BeoYCmnqFsBh2ZzgldWB8crdVBMmZpywZk6rvYgR8lxTje9VR5rJDyeuxXeWXZOevMO3
         BUAYX+Kvx+Rbznu9Te3Sw+m0PD1lKxC08GAmEXmjgQsvx45SpLLVcV9pLMKG4stGJnat
         CzQneiTrPCk+tLNBxb0QsNinY+OqLUyF7PFlmwSNiepf+rrsYuKZXipZ0gkrmf4oFJ+3
         b0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eWU2AWq8Eq3gqU4BhZFYarDK0bOR9ZheOlzcH4UPHes=;
        b=mJx9DfjDynACTyIFNdhb3FNIezQxpOwgjYB0b8iQl/vTjWRItE81D5qzTiJqjFOD1u
         LcPll0e5w9ISp7NSyqO05IelVETMKi41I18mbSqlwQqiEyxSBM5R5HkbtONxiMVoq8fF
         LKfBIt6vCh33sEgk2TqdFi//3cP5UCz0kYkvB8Bmi2FmkoptRCpDH1FSrc6ClhKUCog0
         Z9k6f0AwdMZGNV7vmeJXZsaGnP3gseMiTRxr/F44m62g2H9tyECFqW2YZYx8ynz7NwTk
         tA87qT64tgh4Wopna5YZ64zfRnaM9H5sS7RPyzw+XEu4nJKrltN4ngF4g9P0hBvL4/dM
         Iqsg==
X-Gm-Message-State: ANoB5plM0O6a5DQnIkqHG0bGjJrxuwZR3SbiZ/krqapFKMdIrP25jxj2
        b5nxXAQ20K0yc+5gRFK1o5KVuhDnXly2aJREIJJ44g==
X-Google-Smtp-Source: AA0mqf6vu9kuePeMS9l3b991+R2zG6hmWT5m11Wgk0SuA+Vd3yJC/GJQIOJLNpd2zjgtMumhHjn2hxZ5Cq+MesR6OZY=
X-Received: by 2002:a81:1a16:0:b0:370:7a9a:564 with SMTP id
 a22-20020a811a16000000b003707a9a0564mr13696670ywa.278.1668447109741; Mon, 14
 Nov 2022 09:31:49 -0800 (PST)
MIME-Version: 1.0
References: <4fedab7ce54a389aeadbdc639f6b4f4988e9d2d7.1668386107.git.jamie.bainbridge@gmail.com>
In-Reply-To: <4fedab7ce54a389aeadbdc639f6b4f4988e9d2d7.1668386107.git.jamie.bainbridge@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 14 Nov 2022 09:31:38 -0800
Message-ID: <CANn89iK-X6hz0F3g1+J52cxVvm7LNizNa5fmnhpyCMJeYZBbaw@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: Add listening address to SYN flood message
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 5:00 PM Jamie Bainbridge
<jamie.bainbridge@gmail.com> wrote:
>
> The SYN flood message prints the listening port number, but with many
> processes bound to the same port on different IPs, it's impossible to
> tell which socket is the problem.
>
> Add the listen IP address to the SYN flood message.
>
> For IPv6 use "[IP]:port" as per RFC-5952 and to provide ease of
> copy-paste to "ss" filters. For IPv4 use "IP:port" to match.
>
> Each protcol's "any" address and a host address now look like:
>
>  Possible SYN flooding on port 0.0.0.0:9001.
>  Possible SYN flooding on port 127.0.0.1:9001.
>  Possible SYN flooding on port [::]:9001.
>  Possible SYN flooding on port [fc00::1]:9001.
>
> Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
