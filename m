Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B91213FD2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 21:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgGCTTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 15:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgGCTTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 15:19:51 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A6C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 12:19:50 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so28498219iof.12
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 12:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2pwLCKZCNv25/ycwjdAenhsrMK+b58nPM8d8dSR+7SE=;
        b=DtdrgqErUK3c5YjV64C8OWLvykRDZ389aTxOkt4cPA5HWPnnaXriMqwZm+6fSYW3EZ
         tMfobZWhFCjhG9sOKz+XBDT3zo4tUWF3fFpB4KhvmGen6ePaVOWj6ROSf7tVGCeHRFMt
         LMb2X69plIZImrQ3rJV6/0JYoPhYjhygfdt5THmirUmilFkTjs7483srvU6033PA+TBS
         s5nw0IIncBmz/oEv2M6EizhWJV3qcybzlZknoL+8TsJzO3cvnDSod4KY5/zONSXBgqk5
         vBzdv0q1yDpcCM78Kob3gAB4kZq/lhc+SklertUTjo8j/yGsgUPhqyXGD09/O7zxPOBK
         18aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2pwLCKZCNv25/ycwjdAenhsrMK+b58nPM8d8dSR+7SE=;
        b=rG8pThTp6bRycdEluBBEsTfm9/XLRWh06PBNBABTPJ3PGpVj9maoUk1sr3Cemg/pVM
         SmltnoNLwVFeE759pBuAQyYaKnn984CwcmEyfDx83uBSUzF9Z+PjWpvqUe0NgalG2gSn
         L5ipfejMHmBhKo5rPYQaTnXYglVgp+ZSwvXigEo6LsF4r6DT9Kuzbsb7yFbva8A8mp3R
         Gv4v4dgoAAWwkaSYVu38c3T9gTjR0V/lg3AeFJgJv2PuHBVQGRbojvfLWIcVO2BMLnDS
         8Q+VT5yQzNpSIiM8Yo8/aqY/cQOyDbZPndl6evPgdfN4TLkgEdav0iEeZmMa3RBQog9J
         GgZg==
X-Gm-Message-State: AOAM532tnknwDG8ckDbtQUM7GbLNNJYFYmJwMmpQH946WYM14QTn8f3s
        G3PpvcCG5cqBT5sFDo4CRocOkk/MOQuFvr6QsgS8snmNaCk=
X-Google-Smtp-Source: ABdhPJyFDPIYWvawKCXN60JR2HLAbtjgphufK6rP/A31cYE1M/JyM3hpW6jQFAUhpk18/xzki6rcZ7MULLMjbs5hYw0=
X-Received: by 2002:a02:1a08:: with SMTP id 8mr39596917jai.124.1593803990094;
 Fri, 03 Jul 2020 12:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200703152239.471624-1-toke@redhat.com>
In-Reply-To: <20200703152239.471624-1-toke@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 3 Jul 2020 12:19:38 -0700
Message-ID: <CAM_iQpVbm0DGGjsdtJD0esuyx9Xmjo=3VCg=C5feqDDbFM+6XQ@mail.gmail.com>
Subject: Re: [PATCH net v2] sched: consistently handle layer3 header accesses
 in the presence of VLANs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cake List <cake@lists.bufferbloat.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 8:22 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
> index b05e855f1ddd..d0c1cb0d264d 100644
> --- a/include/linux/if_vlan.h
> +++ b/include/linux/if_vlan.h
> @@ -308,6 +308,35 @@ static inline bool eth_type_vlan(__be16 ethertype)
>         }
>  }
>
> +/* A getter for the SKB protocol field which will handle VLAN tags consi=
stently
> + * whether VLAN acceleration is enabled or not.
> + */
> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_v=
lan)
> +{
> +       unsigned int offset =3D skb_mac_offset(skb) + sizeof(struct ethhd=
r);
> +       __be16 proto =3D skb->protocol;
> +       struct vlan_hdr vhdr, *vh;
> +
> +       if (!skip_vlan)
> +               /* VLAN acceleration strips the VLAN header from the skb =
and
> +                * moves it to skb->vlan_proto
> +                */
> +               return skb_vlan_tag_present(skb) ? skb->vlan_proto : prot=
o;
> +
> +       while (eth_type_vlan(proto)) {
> +               vh =3D skb_header_pointer(skb, offset, sizeof(vhdr), &vhd=
r);
> +               if (!vh)
> +                       break;
> +
> +               proto =3D vh->h_vlan_encapsulated_proto;
> +               offset +=3D sizeof(vhdr);
> +       }
> +
> +       return proto;
> +}
> +
> +
> +

Just nit: too many newlines here. Please run checkpatch.pl.


>  static inline bool vlan_hw_offload_capable(netdev_features_t features,
>                                            __be16 proto)
>  {
> diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
> index 0f0d1efe06dd..82763ba597f2 100644
> --- a/include/net/inet_ecn.h
> +++ b/include/net/inet_ecn.h
> @@ -4,6 +4,7 @@
>
>  #include <linux/ip.h>
>  #include <linux/skbuff.h>
> +#include <linux/if_vlan.h>
>
>  #include <net/inet_sock.h>
>  #include <net/dsfield.h>
> @@ -172,7 +173,7 @@ static inline void ipv6_copy_dscp(unsigned int dscp, =
struct ipv6hdr *inner)
>
>  static inline int INET_ECN_set_ce(struct sk_buff *skb)
>  {
> -       switch (skb->protocol) {
> +       switch (skb_protocol(skb, true)) {
>         case cpu_to_be16(ETH_P_IP):
>                 if (skb_network_header(skb) + sizeof(struct iphdr) <=3D
>                     skb_tail_pointer(skb))
> @@ -191,7 +192,7 @@ static inline int INET_ECN_set_ce(struct sk_buff *skb=
)
>
>  static inline int INET_ECN_set_ect1(struct sk_buff *skb)
>  {
> -       switch (skb->protocol) {
> +       switch (skb_protocol(skb, true)) {
>         case cpu_to_be16(ETH_P_IP):
>                 if (skb_network_header(skb) + sizeof(struct iphdr) <=3D
>                     skb_tail_pointer(skb))

These two helpers are called by non-net_sched too, are you sure
your change is correct for them too?

For example, IP6_ECN_decapsulate() uses skb->protocol then calls
INET_ECN_decapsulate() which calls the above, after your change
they use skb_protocol(). This looks inconsistent to me.

Thanks.
