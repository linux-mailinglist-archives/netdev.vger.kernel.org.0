Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F76A509463
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352727AbiDUAXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiDUAXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:23:35 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD131A386
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:20:47 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id g14so2513228ybj.12
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXocRW4Fcy3ODLwlLZMAvoG6TfyjzPBLt8Rv4un+YTQ=;
        b=nImhtQPJaOzP6XFyaGqECd5mDgHxWmDJRHdRNv+vEPa5JrDA9N7SPydqUH64Gq+hQV
         NtKuBALzWwwJkFIUXcbefjATqKncxCcqE2gX6X1+ZCEZp3/XoRyFVN3C+Ql4w+nDRuew
         q6TLmIqM0Dxfyp8AT8r4nBE3K28zycciwtrU9VM57sjM9jTtjOhzemgs1/LE7uhaTLj2
         NpaCFLd0cB6ZAvRcmI1b3nMSA5ulnNKoCmrGmxz11LR8/9BTE6vVDc9Y6RCpAcN8qZvl
         pAleeywzdXr1/wUhp8ubkefmyj0HuspW7uuqu7SdBu71UNDDY249sR3lJuwbxG1GMs/P
         PlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXocRW4Fcy3ODLwlLZMAvoG6TfyjzPBLt8Rv4un+YTQ=;
        b=JhWkVBIztLozUDa4i676cdPdwYnPxaIrgvtZLS85fSz8UW+QnwvEKMmRlTZUHpIMyF
         YXESi0CaRVDwEx7ObDsgsbC0bqadN090u+c6oZ3ispBY3t2/PiixVXEWRZrgoyH4P+rU
         spjXujpZO7kjfcS3VN6Edf0iZqs9o+l4wwJ2OJa9j7MRUuQ17OX46ieQp03GKIvuHcmS
         6bNsVcBfwQLpCYboNiTPzEc2nOVRhGcfM7MswNs4a3mYAR6Rc0Ff5UHqM1RTmLvzDo9k
         q8v9m5YwWBa0nOb2X+960fkgNYi+Mc7oP5wQ1oV74ZTzRMjJoyATES9FVMxRDCUCHc/w
         GGmA==
X-Gm-Message-State: AOAM530A8c5AUCG9IldgcaZV24O79EayY5UV5M81V/+PCv2HE9OMTo6O
        uuJlodVerkzpMRIRpmxunVBilI0d5BjSplGfiVr8Gg==
X-Google-Smtp-Source: ABdhPJyY7IxMb9HzNn/D6HXins/F226memrjVTU9idaaExMqGEnSVuhTv/NpqoqY7E/6DLIx3N5uyai+7UzTD8B5MxM=
X-Received: by 2002:a05:6902:1109:b0:645:58e:a373 with SMTP id
 o9-20020a056902110900b00645058ea373mr18145423ybu.231.1650500446691; Wed, 20
 Apr 2022 17:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220420235659.830155EC021C@us226.sjc.aristanetworks.com>
In-Reply-To: <20220420235659.830155EC021C@us226.sjc.aristanetworks.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Apr 2022 17:20:35 -0700
Message-ID: <CANn89iJjwV2gAKMc4iydUt_MqtnB-4_EKdVrqQO9q4Dt17Lf9w@mail.gmail.com>
Subject: Re: [PATCH] tcp: md5: incorrect tcp_header_len for incoming connections
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Wed, Apr 20, 2022 at 4:57 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> In tcp_create_openreq_child we adjust tcp_header_len for md5 using the
> remote address in newsk. But that address is still 0 in newsk at this
> point, and it is only set later by the callers (tcp_v[46]_syn_recv_sock).
> Use the address from the request socket instead.
>

Nice catch.

This seems like a day-0 bug, right ?

Do you agree on adding

Fixes: cfb6eeb4c860 ("[TCP]: MD5 Signature Option (RFC2385) support.")

Thanks.

> Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
> ---
>  net/ipv4/tcp_minisocks.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 6366df7aaf2a..6854bb1fb32b 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -531,7 +531,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
>         newtp->tsoffset = treq->ts_off;
>  #ifdef CONFIG_TCP_MD5SIG
>         newtp->md5sig_info = NULL;      /*XXX*/
> -       if (newtp->af_specific->md5_lookup(sk, newsk))
> +       if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
>                 newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
>  #endif
>         if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
> --
> 2.28.0
>
>
