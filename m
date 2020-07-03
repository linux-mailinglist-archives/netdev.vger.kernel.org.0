Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6183B214035
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGCUJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:09:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47375 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726368AbgGCUJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 16:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593806984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y+FWZ5yqiN8FH+sU2SZS0bUemdJq4rNskNBcQ33ENDc=;
        b=diXMLIli6MSwGKNL1+hPF+YF0ZGYmXzku9Mi6L7cRbh3tTP6fljermZ9dabMiYWmXQoZev
        onLoyDBahMDHGtEOgQ0cyDCcHY2CObG0f3cWTQPGTRl7lY972JTacxziZtGcMzQYUPD25Q
        ePDcRiF2XczCo2b41qXP74xez01ZkYE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-OLAkzWNZN4qUSwEPX8Rveg-1; Fri, 03 Jul 2020 16:09:41 -0400
X-MC-Unique: OLAkzWNZN4qUSwEPX8Rveg-1
Received: by mail-pl1-f199.google.com with SMTP id d13so18817031plr.20
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 13:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Y+FWZ5yqiN8FH+sU2SZS0bUemdJq4rNskNBcQ33ENDc=;
        b=QmPOSDZ/hxkDdgExbd4c0HTZnh9Skz5UYh3sXChdyZH3al0xp0EM8qcjabBOnOnYcO
         MtCYdbRPr0yAdAYANcG5DKu9inf3mh2MOzUqiqX5CffevgyK9DQ7NCceFHrZWElO/rpr
         6/ztfgUF2K8C9vV5MLxw360pck14TMwjuwANK1bqsqRtd/Mz7BpCuga7T98c16Py0Ac7
         xeA9Rg67ngXVEuflvd1PZeoFb7edQFycBgfv7p086G/vyN5V/Bx/yS6jgiUaChRzXry3
         qsfRT1patTy8FLVOgUfWOjMGkS4ovenuElTAssqM/A3ShX+OHH8rgKOfCyVwOSn8eIQX
         lLaA==
X-Gm-Message-State: AOAM532whNaRnqICtBeyhFD+Bz5TyIco5bGs0DmpoSm8m6aWGGLdErpg
        8R5FdpRPkyonHIH6FQgkmlwwLaCDWHxFTrAaRAWWvYrxa4kBaJBkCQc1D8raljUsSPJn0kJ1z3G
        tNRd5L+SzRQZtAnmC
X-Received: by 2002:a63:745:: with SMTP id 66mr31446402pgh.316.1593806980398;
        Fri, 03 Jul 2020 13:09:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwLUegMoL/eIhQyxeQ10175pnIsYKZNbM3JXpTa5KqRRhhW5svTW3ecR8gzmcHFdkSZba8Yw==
X-Received: by 2002:a63:745:: with SMTP id 66mr31446372pgh.316.1593806980016;
        Fri, 03 Jul 2020 13:09:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p10sm6765948pgn.6.2020.07.03.13.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 13:09:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 47BA21804A8; Fri,  3 Jul 2020 22:09:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cake List <cake@lists.bufferbloat.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Subject: Re: [PATCH net v2] sched: consistently handle layer3 header accesses in the presence of VLANs
In-Reply-To: <CAM_iQpVbm0DGGjsdtJD0esuyx9Xmjo=3VCg=C5feqDDbFM+6XQ@mail.gmail.com>
References: <20200703152239.471624-1-toke@redhat.com> <CAM_iQpVbm0DGGjsdtJD0esuyx9Xmjo=3VCg=C5feqDDbFM+6XQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 03 Jul 2020 22:09:34 +0200
Message-ID: <87mu4gmkch.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Jul 3, 2020 at 8:22 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
>> index b05e855f1ddd..d0c1cb0d264d 100644
>> --- a/include/linux/if_vlan.h
>> +++ b/include/linux/if_vlan.h
>> @@ -308,6 +308,35 @@ static inline bool eth_type_vlan(__be16 ethertype)
>>         }
>>  }
>>
>> +/* A getter for the SKB protocol field which will handle VLAN tags cons=
istently
>> + * whether VLAN acceleration is enabled or not.
>> + */
>> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_=
vlan)
>> +{
>> +       unsigned int offset =3D skb_mac_offset(skb) + sizeof(struct ethh=
dr);
>> +       __be16 proto =3D skb->protocol;
>> +       struct vlan_hdr vhdr, *vh;
>> +
>> +       if (!skip_vlan)
>> +               /* VLAN acceleration strips the VLAN header from the skb=
 and
>> +                * moves it to skb->vlan_proto
>> +                */
>> +               return skb_vlan_tag_present(skb) ? skb->vlan_proto : pro=
to;
>> +
>> +       while (eth_type_vlan(proto)) {
>> +               vh =3D skb_header_pointer(skb, offset, sizeof(vhdr), &vh=
dr);
>> +               if (!vh)
>> +                       break;
>> +
>> +               proto =3D vh->h_vlan_encapsulated_proto;
>> +               offset +=3D sizeof(vhdr);
>> +       }
>> +
>> +       return proto;
>> +}
>> +
>> +
>> +
>
> Just nit: too many newlines here. Please run checkpatch.pl.

Hmm, I did run checkpatch, but seems it only complains about multiple
newlines when run with --strict. Will fix, thanks! :)

>>  static inline bool vlan_hw_offload_capable(netdev_features_t features,
>>                                            __be16 proto)
>>  {
>> diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
>> index 0f0d1efe06dd..82763ba597f2 100644
>> --- a/include/net/inet_ecn.h
>> +++ b/include/net/inet_ecn.h
>> @@ -4,6 +4,7 @@
>>
>>  #include <linux/ip.h>
>>  #include <linux/skbuff.h>
>> +#include <linux/if_vlan.h>
>>
>>  #include <net/inet_sock.h>
>>  #include <net/dsfield.h>
>> @@ -172,7 +173,7 @@ static inline void ipv6_copy_dscp(unsigned int dscp,=
 struct ipv6hdr *inner)
>>
>>  static inline int INET_ECN_set_ce(struct sk_buff *skb)
>>  {
>> -       switch (skb->protocol) {
>> +       switch (skb_protocol(skb, true)) {
>>         case cpu_to_be16(ETH_P_IP):
>>                 if (skb_network_header(skb) + sizeof(struct iphdr) <=3D
>>                     skb_tail_pointer(skb))
>> @@ -191,7 +192,7 @@ static inline int INET_ECN_set_ce(struct sk_buff *sk=
b)
>>
>>  static inline int INET_ECN_set_ect1(struct sk_buff *skb)
>>  {
>> -       switch (skb->protocol) {
>> +       switch (skb_protocol(skb, true)) {
>>         case cpu_to_be16(ETH_P_IP):
>>                 if (skb_network_header(skb) + sizeof(struct iphdr) <=3D
>>                     skb_tail_pointer(skb))
>
> These two helpers are called by non-net_sched too, are you sure
> your change is correct for them too?
>
> For example, IP6_ECN_decapsulate() uses skb->protocol then calls
> INET_ECN_decapsulate() which calls the above, after your change
> they use skb_protocol(). This looks inconsistent to me.

Good point. I'll change IP{,6}_ECN_decapsulate() to also use
skb_protocol().

-Toke

