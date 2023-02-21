Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3278469E0B8
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbjBUMrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbjBUMq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:46:59 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9062A982
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:46:49 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p26so3149006wmc.4
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ybKrLZSCk44MHga59kU0RPq8IbA+A4aFe7bhNo7YAzQ=;
        b=iKDAMZcgDb+2QkFkc1NzWhF0nVpMsi5qKvRZoinCRkvtxyEpuOGyVCPcXg/6tYYwN4
         C/qWLI/CZw96kY96p9b6bbgCIMraTvx/6kPVDCp9a6Rcu5IaXttkaJOJMPhuHgdMrfRA
         biyf1XPFnmrKqthlcVlFFSf/k975EBPMPa67BL3C63QAom+PuhR7toy6WesIVEWxK4Og
         gUOqcD0dKdAA9GcGhm4F6Xs6UWKZOkvTnQthSdfxT1OFJSiRVlG4+WV0+lwfxLhSPtXU
         B3dvZ2nLL/fD38JKoNBJ0s5aseYmWjP98kFLh77bh10ed5LhfaT9bpbXGX/6oTXvLdqP
         TU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ybKrLZSCk44MHga59kU0RPq8IbA+A4aFe7bhNo7YAzQ=;
        b=owpK8r2/CXNS6V/rCrNsFzDd8oxmdGrb3D7nAgZN3+bbweG0pry+a85Bpj4ty8Lfwe
         4UFdewYDtGnivSo3jXovcAdz00A2+4hWa4AleTplA4Zjps3OB6k+inocSNq/BfyVYST3
         liS+9uSfEV5ka1RCVzmVSMTjcsl5oaulHJRMzRiRHVEKUwQayQeyPG+oiYGnCP8KZOvz
         dSzJC8VesV5hXLAI/DJhKzdJhzBmOEPEeBYIf0KBHWExMq/f7RHlFFEf7CugRstiQDjW
         mKKhQDBrg9YIzVvE7tGPfFBhPJjJ5PA/o4ZQU9ehKZpG9rTTg6I/V9w7/awgDqomFLTK
         k7Cg==
X-Gm-Message-State: AO0yUKVRogN+tObK9TjXykiqz5xDEt0scINBLYhFcB7radaRXbAtZiRC
        lVHB1hRbVBb3H3xE60FVnW3ss32jUx7H85WfyNPM6w==
X-Google-Smtp-Source: AK7set8rjazCUusnnN8KKIrmciOXTQqpp+fRA2IW8qCUcn2aoxJdfoyqsHpCwXEbL+w/1GOdqmDWaDBiTPOGbqb53Yo=
X-Received: by 2002:a05:600c:4e44:b0:3df:f862:fe42 with SMTP id
 e4-20020a05600c4e4400b003dff862fe42mr1877312wmq.10.1676983607682; Tue, 21 Feb
 2023 04:46:47 -0800 (PST)
MIME-Version: 1.0
References: <20230221092206.39741-1-hbh25y@gmail.com>
In-Reply-To: <20230221092206.39741-1-hbh25y@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Feb 2023 13:46:36 +0100
Message-ID: <CANn89iJmYoewECcRTDW-F5c=jJZRxwFGMMrOGYe6XBLOgohc6w@mail.gmail.com>
Subject: Re: [PATCH] net: dccp: delete redundant ackvec record in dccp_insert_options()
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ian.mcdonald@jandi.co.nz, gerrit@erg.abdn.ac.uk,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
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

On Tue, Feb 21, 2023 at 10:22 AM Hangyu Hua <hbh25y@gmail.com> wrote:
>
> A useless record can be insert into av_records when dccp_insert_options()
> fails after dccp_insert_option_ackvec(). Repeated triggering may cause
> av_records to have a lot of useless record with the same avr_ack_seqno.
>
> Fixes: 8b7b6c75c638 ("dccp: Integrate feature-negotiation insertion code")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/dccp/options.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/net/dccp/options.c b/net/dccp/options.c
> index d24cad05001e..8aa4abeb15ea 100644
> --- a/net/dccp/options.c
> +++ b/net/dccp/options.c
> @@ -549,6 +549,8 @@ static void dccp_insert_option_padding(struct sk_buff *skb)
>  int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
>  {
>         struct dccp_sock *dp = dccp_sk(sk);
> +       struct dccp_ackvec *av = dp->dccps_hc_rx_ackvec;
> +       struct dccp_ackvec_record *avr;
>
>         DCCP_SKB_CB(skb)->dccpd_opt_len = 0;
>
> @@ -577,16 +579,22 @@ int dccp_insert_options(struct sock *sk, struct sk_buff *skb)
>
>         if (dp->dccps_hc_rx_insert_options) {
>                 if (ccid_hc_rx_insert_options(dp->dccps_hc_rx_ccid, sk, skb))
> -                       return -1;
> +                       goto delete_ackvec;
>                 dp->dccps_hc_rx_insert_options = 0;
>         }
>
>         if (dp->dccps_timestamp_echo != 0 &&
>             dccp_insert_option_timestamp_echo(dp, NULL, skb))
> -               return -1;
> +               goto delete_ackvec;
>
>         dccp_insert_option_padding(skb);
>         return 0;
> +
> +delete_ackvec:
> +       avr = dccp_ackvec_lookup(&av->av_records, DCCP_SKB_CB(skb)->dccpd_seq);

Why avr would be not NULL ?

> +       list_del(&avr->avr_node);
> +       kmem_cache_free(dccp_ackvec_record_slab, avr);
> +       return -1;
>  }

Are you really using DCCP and/or how have you tested this patch ?

net/dccp/ackvec.c:15:static struct kmem_cache *dccp_ackvec_record_slab;

I doubt this patch has been compiled.

I would rather mark DCCP deprecated and stop trying to fix it.
