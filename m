Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2739D601367
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 18:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiJQQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 12:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJQQ2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 12:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB166D573;
        Mon, 17 Oct 2022 09:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9831B80D42;
        Mon, 17 Oct 2022 16:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B485C433D7;
        Mon, 17 Oct 2022 16:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666024091;
        bh=CbZnE0u9ATeiuOE1DtOlQZTkBT2ZvEbQsEy/sFiaP8I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PmbytVwqjS/HoDmVlm4aewXtWI4fMne0PlPHLJ+VUp8oNH3xVAIGceiDstco2ZEvs
         d86Fg9asui7T9dZ8vyxb/0FVNBF8FGoTzrfCOFaro3yeiA7/X1HfUC3vkzKoxwUsfW
         sQEDBIoYXNGn89sscsDUqXZmklbigUaJIVXGYW/ue0YZ/6QSfysVQfXsBKRTateBNa
         bA4jjAJOeZb6rt5UOwW0KGm3Yw9dZybgfv7t4H4DQXU1sjxqeL13ArdPTiBgJDL4O6
         sRgnP6ga4kvoV9E8DZAi5Uw6Rh8913+hGWtTtHTl6szsSXwELDhzdVXRgeVViZR5XC
         mApUoQP2rNyTg==
Received: by mail-ej1-f45.google.com with SMTP id a26so26168154ejc.4;
        Mon, 17 Oct 2022 09:28:11 -0700 (PDT)
X-Gm-Message-State: ACrzQf3YJCARaEIdbFqo59Er9b6L5hiuEmdcFFk4wGXFIn9BiQnex1qM
        JKu/HdlVQ/9lQBTtMRbjGbrf56jLPip3j0Nd054=
X-Google-Smtp-Source: AMsMyM5KlA0HskMNTRbk6KourpP7WQf88SdTf4672QdT+yCba33em7qn9tSQiVplKnQAr6JggqrK1+eO9GMzcII1taU=
X-Received: by 2002:a17:906:794b:b0:790:2dc7:3115 with SMTP id
 l11-20020a170906794b00b007902dc73115mr8508855ejo.3.1666024089726; Mon, 17 Oct
 2022 09:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <20221013200922.17167-1-gerhard@engleder-embedded.com>
In-Reply-To: <20221013200922.17167-1-gerhard@engleder-embedded.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 17 Oct 2022 09:27:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4hYuUMms1Jv9gfz0QV06y6Qvna1xdjL5fFdgTQz_e9iw@mail.gmail.com>
Message-ID: <CAPhsuW4hYuUMms1Jv9gfz0QV06y6Qvna1xdjL5fFdgTQz_e9iw@mail.gmail.com>
Subject: Re: [PATCH net-next] samples/bpf: Fix map interation in xdp1_user
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 2:01 PM Gerhard Engleder
<gerhard@engleder-embedded.com> wrote:
>
> BPF map iteration in xdp1_user results in endless loop without any
> output, because the return value of bpf_map_get_next_key() is checked
> against the wrong value.
>
> Other call locations of bpf_map_get_next_key() check for equal 0 for
> continuing the iteration. xdp1_user checks against unequal -1. This is
> wrong for a function which can return arbitrary negative errno values,
> because a return value of e.g. -2 results in an endless loop.
>
> With this fix xdp1_user is printing statistics again:
> proto 0:          1 pkt/s
> proto 0:          1 pkt/s
> proto 17:     107383 pkt/s
> proto 17:     881655 pkt/s
> proto 17:     882083 pkt/s
> proto 17:     881758 pkt/s
>
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Song Liu <song@kernel.org>

> ---
>  samples/bpf/xdp1_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
> index ac370e638fa3..281dc964de8d 100644
> --- a/samples/bpf/xdp1_user.c
> +++ b/samples/bpf/xdp1_user.c
> @@ -51,7 +51,7 @@ static void poll_stats(int map_fd, int interval)
>
>                 sleep(interval);
>
> -               while (bpf_map_get_next_key(map_fd, &key, &key) != -1) {
> +               while (bpf_map_get_next_key(map_fd, &key, &key) == 0) {
>                         __u64 sum = 0;
>
>                         assert(bpf_map_lookup_elem(map_fd, &key, values) == 0);
> --
> 2.30.2
>
