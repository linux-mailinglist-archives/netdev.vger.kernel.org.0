Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB984B8A19
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiBPNbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:31:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbiBPNav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:30:51 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652CC1867E0;
        Wed, 16 Feb 2022 05:30:34 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id g24so1656898qkl.3;
        Wed, 16 Feb 2022 05:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwvR7OO2WFCl0yXCxyqfDg2TPoyrx1rZW4Bqi6QfvMo=;
        b=lP7LACSS/u6XbbHnx/k17PyESQC5bUbK9a27sF8RV7Wk8ozFIfszNXLjZtM348hGAZ
         tb+148zvVF3xqMTjNLZWdyZeWADhoy4yduNXz/v1bzO0q5xj2/Vd1DHLRUKM4nLsW7Fb
         DH71gu+A97+Tf89h8RR3Ilt3Ou4NBvAiCvU828E9Jx0cl/EkuY2GzJGczTwVKeajMqVS
         vtGUkSBkF3qtBD0HaaANRSGtqcV2O0znhOKsNR6lledny9pCs9PZp/sij/rmHSupqKPC
         bzay3KK+7XLRmgXkgqXi6rDK9P7pe4Es0Iuakhd30dv12MH9Hp0ri5SK8Ql03DpT2qLF
         Wayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwvR7OO2WFCl0yXCxyqfDg2TPoyrx1rZW4Bqi6QfvMo=;
        b=CwL/mjbk1dZEPtU1vx7BZdxITpL4f7BG+n1fvBz01Df6/WmDLemNfpZ2vpEoKXOI6+
         mwWO7u9P3Vfnr90h3D84kFCjbRWQfT3mvQ/IUYq1mIeAFJA2qDiHDOfHmPRBr1GBkfqm
         zrpnQRJeeAVlNcIOVv693b336/8UqmydaGjuBeYmpGOufuY9yxxuBxbkbqFo6Wz6PzPh
         uqdWDv1FhxiQerIVp+S3uvWJit8qPrK/rduEulBmEh7widwyT2MVThc2l+XR9VS+GbVa
         fPeBMlm2Ga2QS/ox0wNPMTaeIOzQOqJUdEkyNuQAo9sVmLProzRnmYXq2qjEKFnG4Zdc
         FFRQ==
X-Gm-Message-State: AOAM531VOXPVoDxZgFTEhPthw6UTDXSepPYCLenz5ZvtBOmWDOytGAR9
        SzKP51jFbvREnWegek9qs7r/HIOsirV2iNblMos=
X-Google-Smtp-Source: ABdhPJxrjmimwu0WwbgOQi/xAg0/b551w2Srv1rRx3mX08Q8rRI/us75tmQPZI0Osr0W5HvFtgbdqTce217+bXBUiyM=
X-Received: by 2002:ae9:ef09:0:b0:506:aadb:1f1b with SMTP id
 d9-20020ae9ef09000000b00506aadb1f1bmr1195802qkg.609.1645018233522; Wed, 16
 Feb 2022 05:30:33 -0800 (PST)
MIME-Version: 1.0
References: <20220216081041.70831-1-thomas.liu@ucloud.cn>
In-Reply-To: <20220216081041.70831-1-thomas.liu@ucloud.cn>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 16 Feb 2022 08:29:57 -0500
Message-ID: <CAF=yD-JH3uKC20eRcNGkrYHnz0Csgg_NvnGNw4k-ECz9vLpKbg@mail.gmail.com>
Subject: Re: [PATCH net v2] gso: do not skip outer ip header in case of ipip
 and net_failover
To:     Tao Liu <thomas.liu@ucloud.cn>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 3:23 AM Tao Liu <thomas.liu@ucloud.cn> wrote:
>
> We encounter a tcp drop issue in our cloud environment. Packet GROed in
> host forwards to a VM virtio_net nic with net_failover enabled. VM acts
> as a IPVS LB with ipip encapsulation. The full path like:
> host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
>  -> ipip encap -> net_failover tx -> virtio_net tx
>
> When net_failover transmits a ipip pkt (gso_type = 0x0103), there is no gso
> did because it supports TSO and GSO_IPXIP4. But network_header points to
> inner ip header.
>
> Call Trace:
>  tcp4_gso_segment        ------> return NULL
>  inet_gso_segment        ------> inner iph, network_header points to
>  ipip_gso_segment
>  inet_gso_segment        ------> outer iph
>  skb_mac_gso_segment
>
> Afterwards virtio_net transmits the pkt, only inner ip header is modified.
> And the outer one just keeps unchanged. The pkt will be dropped in remote
> host. So we need to reset network header in this case.
>
> Call Trace:
>  inet_gso_segment        ------> inner iph, outer iph is skipped
>  skb_mac_gso_segment
>  __skb_gso_segment
>  validate_xmit_skb
>  validate_xmit_skb_list
>  sch_direct_xmit
>  __qdisc_run
>  __dev_queue_xmit        ------> virtio_net
>  dev_hard_start_xmit
>  __dev_queue_xmit        ------> net_failover
>  ip_finish_output2
>  ip_output
>  iptunnel_xmit
>  ip_tunnel_xmit
>  ipip_tunnel_xmit        ------> ipip
>  dev_hard_start_xmit
>  __dev_queue_xmit
>  ip_finish_output2
>  ip_output
>  ip_forward
>  ip_rcv
>  __netif_receive_skb_one_core
>  netif_receive_skb_internal
>  napi_gro_receive
>  receive_buf
>  virtnet_poll
>  net_rx_action

I think the message could be rewritten to point out that the issue is
specific with the rare combination of SKB_GSO_DODGY and a tunnel
device that adds an SKB_GSO_ tunnel option.

> This patch also includes ipv6_gso_segment(), considering SIT, etc.
>
> Fixes: cb32f511a70b ("ipip: add GSO/TSO support")
> Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")

This is not a net_failover issue.

I'm not sure whether the issue existed at the time tunnel support was
added, or introduced later. It's reasonable to assume that it was
always there, but it might be worth a quick code inspection.

> Signed-off-by: Tao Liu <thomas.liu@ucloud.cn>
> ---
>  net/ipv4/af_inet.c     | 5 ++++-
>  net/ipv6/ip6_offload.c | 2 ++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 9c465ba..72fde28 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1376,8 +1376,11 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
>         }
>
>         ops = rcu_dereference(inet_offloads[proto]);
> -       if (likely(ops && ops->callbacks.gso_segment))
> +       if (likely(ops && ops->callbacks.gso_segment)) {
>                 segs = ops->callbacks.gso_segment(skb, features);
> +               if (!segs)
> +                       skb->network_header = skb_mac_header(skb) + nhoff - skb->head;
> +       }
>
>         if (IS_ERR_OR_NULL(segs))
>                 goto out;

It's unfortunate that we have to add a branch in the common path. But
I also don't immediately see a cleaner option.
