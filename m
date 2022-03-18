Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C645C4DDAD1
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiCRNsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbiCRNsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:48:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91DB716F07E
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 06:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647611238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v1FVL+8C/kZhCYO8NyEQ4P/du1gXNOLyvZqS2HEkBKM=;
        b=hN22oC0clazFxuISOUGigXazls2B12ewmjmbVxe9E8jPe3Ii8cFbqAX6fq9y7LO8udnw7w
        L9o7b3qrbxmwW2Od+dnJiS/VdQI9zn2nJn2nnt00rHlaxkyhi5dV78RZckNcsySID9ybKV
        CwvOMLbzGvs+kiAG830wNtScCQE5ml8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-8G653H8NOZev9jn0KfKchA-1; Fri, 18 Mar 2022 09:47:17 -0400
X-MC-Unique: 8G653H8NOZev9jn0KfKchA-1
Received: by mail-ed1-f71.google.com with SMTP id b9-20020aa7d489000000b0041669cd2cbfso4917928edr.16
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 06:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v1FVL+8C/kZhCYO8NyEQ4P/du1gXNOLyvZqS2HEkBKM=;
        b=wmxRJNronUN+km6yVg7DkXb9WuKqk0BuwH5KxfKGrTV+83EDN/OslfDMjECZplswFp
         w+HZPYU7y39RZnaTEBSb944vms6wHIcbVeahxmjUBW+B4aU7lYWAqf3JLX5r1fyHWt/K
         BIoOy446VDoSCit1aqqL0Tb65bvJh0arO2smzbmuHhRjPY7yzLBoxw8hdpV4PHuoBlU1
         j64SsmGWFZ0tSVeIqh/3WCLSL8Mcb2DeUTQW396AglXKqInPJOVbGViJtxxar3wJzn1g
         NaTd4z7Oy/ol4Gzte9hb4LeWLpS3Y3P1JRRqPWl9iJrOhKTkEv0Ch3IvIcIz+elkTNYT
         YfZg==
X-Gm-Message-State: AOAM5308NhxGuATJ1ZKjlkfJPW81JwTNVEVYRqgnqsxi9RTF5vUKy/aP
        AFMnDzmQKWcPsJtYgZ/NNJOOd0dMreqHN37IZWo/4a488PMnYtkHDhn068r/YCClNFOE3scjrAI
        e1Mb6DLTVHnjwaZuI
X-Received: by 2002:a17:907:6d0d:b0:6db:f0f8:654d with SMTP id sa13-20020a1709076d0d00b006dbf0f8654dmr9099199ejc.304.1647611236260;
        Fri, 18 Mar 2022 06:47:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6adKbLNo2uWsLyWrAdFMZNjbMv1XFOqgEurEvhon+0gu7sFnF+HMU4f57GFHtY4dn4a/uig==
X-Received: by 2002:a17:907:6d0d:b0:6db:f0f8:654d with SMTP id sa13-20020a1709076d0d00b006dbf0f8654dmr9099186ejc.304.1647611235932;
        Fri, 18 Mar 2022 06:47:15 -0700 (PDT)
Received: from [10.39.192.245] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id bx5-20020a0564020b4500b00418fca53406sm2210192edb.27.2022.03.18.06.47.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Mar 2022 06:47:15 -0700 (PDT)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        Ilya Maximets <i.maximets@ovn.org>,
        Dumitru Ceara <dceara@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>
Subject: Re: [PATCH net v2] openvswitch: always update flow key after nat
Date:   Fri, 18 Mar 2022 14:47:14 +0100
X-Mailer: MailMate (1.14r5878)
Message-ID: <B01967A4-F2EB-40C4-AB6E-66A5DC9B842A@redhat.com>
In-Reply-To: <20220318124319.3056455-1-aconole@redhat.com>
References: <20220318124319.3056455-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18 Mar 2022, at 13:43, Aaron Conole wrote:

> During NAT, a tuple collision may occur.  When this happens, openvswitc=
h
> will make a second pass through NAT which will perform additional packe=
t
> modification.  This will update the skb data, but not the flow key that=

> OVS uses.  This means that future flow lookups, and packet matches will=

> have incorrect data.  This has been supported since
> 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack").
>
> That commit failed to properly update the sw_flow_key attributes, since=

> it only called the ovs_ct_nat_update_key once, rather than each time
> ovs_ct_nat_execute was called.  As these two operations are linked, the=

> ovs_ct_nat_execute() function should always make sure that the
> sw_flow_key is updated after a successful call through NAT infrastructu=
re.
>
> Fixes: 5d50aa83e2c8 ("openvswitch: support asymmetric conntrack")
> Cc: Dumitru Ceara <dceara@redhat.com>
> Cc: Numan Siddique <nusiddiq@redhat.com>
> Signed-off-by: Aaron Conole <aconole@redhat.com>

You were right about the diff, it really looks messy and I had to apply i=
t to review it :)

The patch looks fine to me!!

Acked-by: Eelco Chaudron <echaudro@redhat.com>

> ---
> v1->v2: removed forward decl., moved the ovs_nat_update_key function
>         made sure it compiles with NF_NAT disabled and enabled
>
>  net/openvswitch/conntrack.c | 118 ++++++++++++++++++------------------=

>  1 file changed, 59 insertions(+), 59 deletions(-)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index c07afff57dd3..4a947c13c813 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -734,6 +734,57 @@ static bool skb_nfct_cached(struct net *net,
>  }
>
>  #if IS_ENABLED(CONFIG_NF_NAT)
> +static void ovs_nat_update_key(struct sw_flow_key *key,
> +			       const struct sk_buff *skb,
> +			       enum nf_nat_manip_type maniptype)
> +{
> +	if (maniptype =3D=3D NF_NAT_MANIP_SRC) {
> +		__be16 src;
> +
> +		key->ct_state |=3D OVS_CS_F_SRC_NAT;
> +		if (key->eth.type =3D=3D htons(ETH_P_IP))
> +			key->ipv4.addr.src =3D ip_hdr(skb)->saddr;
> +		else if (key->eth.type =3D=3D htons(ETH_P_IPV6))
> +			memcpy(&key->ipv6.addr.src, &ipv6_hdr(skb)->saddr,
> +			       sizeof(key->ipv6.addr.src));
> +		else
> +			return;
> +
> +		if (key->ip.proto =3D=3D IPPROTO_UDP)
> +			src =3D udp_hdr(skb)->source;
> +		else if (key->ip.proto =3D=3D IPPROTO_TCP)
> +			src =3D tcp_hdr(skb)->source;
> +		else if (key->ip.proto =3D=3D IPPROTO_SCTP)
> +			src =3D sctp_hdr(skb)->source;
> +		else
> +			return;
> +
> +		key->tp.src =3D src;
> +	} else {
> +		__be16 dst;
> +
> +		key->ct_state |=3D OVS_CS_F_DST_NAT;
> +		if (key->eth.type =3D=3D htons(ETH_P_IP))
> +			key->ipv4.addr.dst =3D ip_hdr(skb)->daddr;
> +		else if (key->eth.type =3D=3D htons(ETH_P_IPV6))
> +			memcpy(&key->ipv6.addr.dst, &ipv6_hdr(skb)->daddr,
> +			       sizeof(key->ipv6.addr.dst));
> +		else
> +			return;
> +
> +		if (key->ip.proto =3D=3D IPPROTO_UDP)
> +			dst =3D udp_hdr(skb)->dest;
> +		else if (key->ip.proto =3D=3D IPPROTO_TCP)
> +			dst =3D tcp_hdr(skb)->dest;
> +		else if (key->ip.proto =3D=3D IPPROTO_SCTP)
> +			dst =3D sctp_hdr(skb)->dest;
> +		else
> +			return;
> +
> +		key->tp.dst =3D dst;
> +	}
> +}
> +
>  /* Modelled after nf_nat_ipv[46]_fn().
>   * range is only used for new, uninitialized NAT state.
>   * Returns either NF_ACCEPT or NF_DROP.
> @@ -741,7 +792,7 @@ static bool skb_nfct_cached(struct net *net,
>  static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,=

>  			      enum ip_conntrack_info ctinfo,
>  			      const struct nf_nat_range2 *range,
> -			      enum nf_nat_manip_type maniptype)
> +			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
>  {
>  	int hooknum, nh_off, err =3D NF_ACCEPT;
>
> @@ -813,58 +864,11 @@ static int ovs_ct_nat_execute(struct sk_buff *skb=
, struct nf_conn *ct,
>  push:
>  	skb_push_rcsum(skb, nh_off);
>
> -	return err;
> -}
> -
> -static void ovs_nat_update_key(struct sw_flow_key *key,
> -			       const struct sk_buff *skb,
> -			       enum nf_nat_manip_type maniptype)
> -{
> -	if (maniptype =3D=3D NF_NAT_MANIP_SRC) {
> -		__be16 src;
> -
> -		key->ct_state |=3D OVS_CS_F_SRC_NAT;
> -		if (key->eth.type =3D=3D htons(ETH_P_IP))
> -			key->ipv4.addr.src =3D ip_hdr(skb)->saddr;
> -		else if (key->eth.type =3D=3D htons(ETH_P_IPV6))
> -			memcpy(&key->ipv6.addr.src, &ipv6_hdr(skb)->saddr,
> -			       sizeof(key->ipv6.addr.src));
> -		else
> -			return;
> -
> -		if (key->ip.proto =3D=3D IPPROTO_UDP)
> -			src =3D udp_hdr(skb)->source;
> -		else if (key->ip.proto =3D=3D IPPROTO_TCP)
> -			src =3D tcp_hdr(skb)->source;
> -		else if (key->ip.proto =3D=3D IPPROTO_SCTP)
> -			src =3D sctp_hdr(skb)->source;
> -		else
> -			return;
> -
> -		key->tp.src =3D src;
> -	} else {
> -		__be16 dst;
> -
> -		key->ct_state |=3D OVS_CS_F_DST_NAT;
> -		if (key->eth.type =3D=3D htons(ETH_P_IP))
> -			key->ipv4.addr.dst =3D ip_hdr(skb)->daddr;
> -		else if (key->eth.type =3D=3D htons(ETH_P_IPV6))
> -			memcpy(&key->ipv6.addr.dst, &ipv6_hdr(skb)->daddr,
> -			       sizeof(key->ipv6.addr.dst));
> -		else
> -			return;
> -
> -		if (key->ip.proto =3D=3D IPPROTO_UDP)
> -			dst =3D udp_hdr(skb)->dest;
> -		else if (key->ip.proto =3D=3D IPPROTO_TCP)
> -			dst =3D tcp_hdr(skb)->dest;
> -		else if (key->ip.proto =3D=3D IPPROTO_SCTP)
> -			dst =3D sctp_hdr(skb)->dest;
> -		else
> -			return;
> +	/* Update the flow key if NAT successful. */
> +	if (err =3D=3D NF_ACCEPT)
> +		ovs_nat_update_key(key, skb, maniptype);
>
> -		key->tp.dst =3D dst;
> -	}
> +	return err;
>  }
>
>  /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwis=
e. */
> @@ -906,7 +910,7 @@ static int ovs_ct_nat(struct net *net, struct sw_fl=
ow_key *key,
>  	} else {
>  		return NF_ACCEPT; /* Connection is not NATed. */
>  	}
> -	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype);=

> +	err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, =
key);
>
>  	if (err =3D=3D NF_ACCEPT && ct->status & IPS_DST_NAT) {
>  		if (ct->status & IPS_SRC_NAT) {
> @@ -916,17 +920,13 @@ static int ovs_ct_nat(struct net *net, struct sw_=
flow_key *key,
>  				maniptype =3D NF_NAT_MANIP_SRC;
>
>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
> -						 maniptype);
> +						 maniptype, key);
>  		} else if (CTINFO2DIR(ctinfo) =3D=3D IP_CT_DIR_ORIGINAL) {
>  			err =3D ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
> -						 NF_NAT_MANIP_SRC);
> +						 NF_NAT_MANIP_SRC, key);
>  		}
>  	}
>
> -	/* Mark NAT done if successful and update the flow key. */
> -	if (err =3D=3D NF_ACCEPT)
> -		ovs_nat_update_key(key, skb, maniptype);
> -
>  	return err;
>  }
>  #else /* !CONFIG_NF_NAT */
> -- =

> 2.31.1

