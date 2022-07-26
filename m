Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB79581941
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiGZR5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiGZR5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:57:46 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1F01CD
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:57:44 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id o2so3854717iof.8
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BxPmGsYcLx2/6eTUHaaduVm5PdbSGh3hRQ9eKp4lTZ0=;
        b=nQyW9SXQDh5cI5T8RgIUY+TXqTp5lEEJA/xcytOx3wdv+P8tvn1613pb8/YoWubMhI
         FwGMx/VXRr5cHBoyGiBpP3+5fLv0XU8Ya0jriCuI3eJ9bBdzwBeA/2sf+RKe1ormBry2
         1PG0Rgafk+eCiGMFlqJChMpj4bjdINPqfhfcicr2NJNuslNUS9sf+6J4OfFfyQN2v3i7
         CNG0O0yrRlWTAISkMjqrSOADkupNTc1scEfgEmpNtVJYS7H1wYiinSlNyq8hBC3bpoDS
         iNDa6V1ro1OCkTmasfygp1unMMalE/mOT+zaJvRDIlMJq1QvffjecsSOBDxQU7u/pNnc
         8wvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BxPmGsYcLx2/6eTUHaaduVm5PdbSGh3hRQ9eKp4lTZ0=;
        b=2AQAE/zNFhLBdrBX2yQ15wuHIqm5Fj4F9XhWmlxq7Sfi6hsI8iH91kJ3TvOInKhlGe
         trMdwYdXkz4EdsT0JyxJa1XtvVXRSXaivvLC3cetKx3H6X23pblib01SKhX0QPfCjiie
         ksQpBIcYRvn0v1HH8xG6cgAfsZBRg9E4s5pQWNIlIEOMo8zr8N8gpOG6G3TBwe0DhWWW
         SdaCsDx/Ldv+gCtUDkv5tK/RyqzTravkCMFJ+AmGc3Penh79x5kTXW+GXvlQH+FWLnZM
         opKqxj9VauPLabwpoFtwyha39X9x7lDcoYKNCmlktq3FVLe9474B8tXR0d6jsZquZFBv
         u9SA==
X-Gm-Message-State: AJIora/Cp4tC/GHaUfbaHA4SAV2GbreIUPa8HbAH9B7jK7T2zqtyA1Ow
        RxgrwMoWZ7tuwM48f0pvdjPG85sSekrTnQv23G8Quw==
X-Google-Smtp-Source: AGRyM1ue0SIPB6AUpeDbWnJ3zedAr0i4kVukfdZ5JCC3kdEu43ZfFz0F3Hn9QX/XMjb9JOybi/S7w5wMaXJofjLU+o0=
X-Received: by 2002:a05:6638:2614:b0:33f:5bc2:b385 with SMTP id
 m20-20020a056638261400b0033f5bc2b385mr7318351jat.246.1658858263838; Tue, 26
 Jul 2022 10:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220726115743.2759832-1-edumazet@google.com> <7c1b68b2-a00d-88a0-45a7-a276fdf4539c@kernel.org>
In-Reply-To: <7c1b68b2-a00d-88a0-45a7-a276fdf4539c@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 19:57:32 +0200
Message-ID: <CANn89iKojuwLNCm0ZGeH+E-HjPmobLHt66_O9EhTtm00hXcwSQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: fix IPv4-mapped support
To:     David Ahern <dsahern@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Dmitry Safonov <dima@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>
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

On Tue, Jul 26, 2022 at 5:06 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 7/26/22 5:57 AM, Eric Dumazet wrote:
> > After the blamed commit, IPv4 SYN packets handled
> > by a dual stack IPv6 socket are dropped, even if
> > perfectly valid.
> >
> > $ nstat | grep MD5
> > TcpExtTCPMD5Failure             5                  0.0
> >
> > For a dual stack listener, an incoming IPv4 SYN packet
> > would call tcp_inbound_md5_hash() with @family == AF_INET,
> > while tp->af_specific is pointing to tcp_sock_ipv6_specific.
> >
> > Only later when an IPv4-mapped child is created, tp->af_specific
> > is changed to tcp_sock_ipv6_mapped_specific.
> >
> > Fixes: 7bbb765b7349 ("net/tcp: Merge TCP-MD5 inbound callbacks")
> > Reported-by: Brian Vazquez <brianvv@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Dmitry Safonov <dima@arista.com>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Leonard Crestez <cdleonard@gmail.com>
> > ---
> >  net/ipv4/tcp.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 002a4a04efbe076ba603d7d42eb85e60d9bf4fb8..766881775abb795c884d048d51c361e805b91989 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4459,9 +4459,18 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
> >               return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
> >       }
> >
> > -     /* check the signature */
> > -     genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
> > -                                              NULL, skb);
> > +     /* Check the signature.
> > +      * To support dual stack listeners, we need to handle
> > +      * IPv4-mapped case.
> > +      */
> > +     if (family == AF_INET)
> > +             genhash = tcp_v4_md5_hash_skb(newhash,
> > +                                           hash_expected,
> > +                                           NULL, skb);
> > +     else
> > +             genhash = tp->af_specific->calc_md5_hash(newhash,
> > +                                                      hash_expected,
> > +                                                      NULL, skb);
> >
> >       if (genhash || memcmp(hash_location, newhash, 16) != 0) {
> >               NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
>
> We should get v4-mapped cases added to the fcnal-test.sh permutations.
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Although fcnal-test.sh uses ~45 minutes currently :/
Maybe we should make it multi netns and multi threaded to speed up things.

And/or replace various "sleep 1" with more appropriate sync to make
this faster and not flaky in case of system load.
