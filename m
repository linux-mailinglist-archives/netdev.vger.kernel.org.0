Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F0264DF9D
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiLOR3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiLOR3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:29:08 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F431DEA
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:29:07 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so3352298pjj.4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MPLRsjeRSz+SAV4vFiHpuviNIxm/q2sDdmtIIiYB+WU=;
        b=jHDftcRinNujxN4ryuypr2bTCZ2Lu1NN4a06fYdnM25dcw13rrPYsV5mx8II7Oym/B
         b6euF4ArbPxGxfL1PLjD76++F5yuooDJmXCPap3B/8QHWsPlvzlcSyZsN2Q4hkAcu+t/
         iAo0vnQf2OfojBDCm5469EceadpmRnNdZ2A2w+8+X1NHQfoBMldc7xBtNJwO+nvw1koF
         d9yfq2HQYByRca4NaMJWIabzVVx+PE3C4R91ypgp8OFMw7RJ0TXL3K/rtrYEwpd6tU8m
         aktgZeYcS+mQjZgokL1TDI4n4eTuQqiUgHfDJGHyC/KUA6bCL/ixzfw8UNK58buHbCW2
         lcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MPLRsjeRSz+SAV4vFiHpuviNIxm/q2sDdmtIIiYB+WU=;
        b=Wl2JC0EzLCMfi3CgVFFfCm7LyHYlZe6vCGMJpaIrvAa8ePfhPg0/cI4fBRKmwmk2UQ
         LKIVMtUL7w5KCh3XIkbFTK2F17PW0GyQiU4iGK0MG9pyCJJQpwbx3aFN+cpkidcvX3Iz
         DBByh8WPw6Pr3XYvC9Y9CAp/FDLwmOwkAJgNd81Qz5eKvLNIOwIIziDSH+eIL7wd/6D/
         9JCAM4fhz+D5AWGyaI74pDjy6oMx7ui4dE01wIsFwNeeRiZ6HDK0thDtrCEMbwdTfw9i
         AyDZVGKxF0T3JjXFoL2gHPTADsOyF+K5QP2R8qM6WxvhYz6NNOajc8kPzx1lQ8+1Kpkb
         iYkw==
X-Gm-Message-State: ANoB5plfiRFwHX4Cjw/n5EXT6eqdueNokw2LnQNtJTWdtpEL6/eXknZ+
        iqB+IWn1sitDzBUH98RqwEY=
X-Google-Smtp-Source: AA0mqf4IcIniH2Sh1O/tGtVxzQUK1DMk6d57rvTBxIpjDHkBfVqGx8bPOyTkxN5j04MDcai/g8CMAg==
X-Received: by 2002:a17:90a:6fa5:b0:219:f7e5:cb56 with SMTP id e34-20020a17090a6fa500b00219f7e5cb56mr30088712pjk.20.1671125346727;
        Thu, 15 Dec 2022 09:29:06 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id oj4-20020a17090b4d8400b001fde655225fsm7424109pjb.2.2022.12.15.09.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 09:29:06 -0800 (PST)
Message-ID: <619cf3a6c70e68104c10843da900c37d582b7523.camel@gmail.com>
Subject: Re: [PATCH net v2] skbuff: Account for tail adjustment during pull
 operations
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shmulik@metanetworks.com, willemb@google.com,
        alexanderduyck@fb.com, netdev@vger.kernel.org, daniel@iogearbox.net
Cc:     Sean Tranchetti <quic_stranche@quicinc.com>
Date:   Thu, 15 Dec 2022 09:29:05 -0800
In-Reply-To: <1671084718-24796-1-git-send-email-quic_subashab@quicinc.com>
References: <1671084718-24796-1-git-send-email-quic_subashab@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 23:11 -0700, Subash Abhinov Kasiviswanathan
wrote:
> Extending the tail can have some unexpected side effects if a program use=
s
> a helper like BPF_FUNC_skb_pull_data to read partial content beyond the
> head skb headlen when all the skbs in the gso frag_list are linear with n=
o
> head_frag -
>=20
>   kernel BUG at net/core/skbuff.c:4219!
>   pc : skb_segment+0xcf4/0xd2c
>   lr : skb_segment+0x63c/0xd2c
>   Call trace:
>    skb_segment+0xcf4/0xd2c
>    __udp_gso_segment+0xa4/0x544
>    udp4_ufo_fragment+0x184/0x1c0
>    inet_gso_segment+0x16c/0x3a4
>    skb_mac_gso_segment+0xd4/0x1b0
>    __skb_gso_segment+0xcc/0x12c
>    udp_rcv_segment+0x54/0x16c
>    udp_queue_rcv_skb+0x78/0x144
>    udp_unicast_rcv_skb+0x8c/0xa4
>    __udp4_lib_rcv+0x490/0x68c
>    udp_rcv+0x20/0x30
>    ip_protocol_deliver_rcu+0x1b0/0x33c
>    ip_local_deliver+0xd8/0x1f0
>    ip_rcv+0x98/0x1a4
>    deliver_ptype_list_skb+0x98/0x1ec
>    __netif_receive_skb_core+0x978/0xc60
>=20
> Fix this by marking these skbs as GSO_DODGY so segmentation can handle
> the tail updates accordingly.
>=20
> Fixes: 3dcbdb134f32 ("net: gso: Fix skb_segment splat when splitting gso_=
size mangled skb having linear-headed frag_list")
> Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
> Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
> ---
> v2: Fix the issue in __pskb_pull_tail() instead of __bpf_try_make_writabl=
e()
> as the issue is generic as mentioned by Daniel. Update the commit text
> and Fixes tag accordingly.
>=20
>  net/core/skbuff.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 88fa405..759bede 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -2416,6 +2416,9 @@ void *__pskb_pull_tail(struct sk_buff *skb, int del=
ta)
>  				insp =3D list;
>  			} else {
>  				/* Eaten partially. */
> +				if (skb_is_gso(skb) && !list->head_frag &&
> +				    skb_headlen(list))
> +					skb_shinfo(skb)->gso_type |=3D SKB_GSO_DODGY;
> =20
>  				if (skb_shared(list)) {
>  					/* Sucks! We need to fork list. :-( */

So essentially the effect here is that we are disabling scatter-gather
when we segment this since we will have to allocate new buffers to
realign the linear sections.

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
