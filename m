Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6C36D93C9
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbjDFKQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbjDFKQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:16:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEA02727
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 03:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680776172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0eGkNUlORusCv1Qu3cliDTo8Vfiruc103YFFcMaS5H8=;
        b=CZQwh1PMFwt1MeYmfvWsp2sgHONPUUyc5a9jpgM52q7v3o+WDa7jSUBFhKEGv2Ymz8nK1h
        RqyYb3yRQAPgsum9RGiu3FnVcpboQgN6cM9LM+WR6PDBT9pbKziByfMQ9td7fCVd0k3K+i
        WCYmLmUe5Hju3LHrC3JYszRsc/gdCBg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-bbADnZDpNCqynx6mP5uiGg-1; Thu, 06 Apr 2023 06:16:10 -0400
X-MC-Unique: bbADnZDpNCqynx6mP5uiGg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3e1a1257fcfso2497061cf.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 03:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680776170; x=1683368170;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0eGkNUlORusCv1Qu3cliDTo8Vfiruc103YFFcMaS5H8=;
        b=pwqFacODEoPhlUgtOWnDr+9QV4xxNXyczHlTo8VJT9W26/Kzi98Cgeq/6dx0HM+/eK
         /1kDS9AFolQTBOOU5Cei2bD3g9RNlRVX2NbSDANaVMQ+qsC5i7OHEwn1phCkeSbDYUMz
         9I77VeV3py7TfhJneY/QLW5u9I+Hp0b4XR+1or8jD3XoXVnBSde57iq4WmF903kP0IJO
         VMFAXwGQxuXShw+8PhejyQC7oO7CW59ThIY1yKIvj9UzyW70jZKCJmTCQt1mF0EPj43R
         lhETLgzWXl+GnVMa1MH5RQKkMNeW6GGZXbVYTy8NZNLxcJHXHbgRYKQ9YRI41NkbE25J
         mzow==
X-Gm-Message-State: AAQBX9dcsPQ8WKVlssUTY6bPRgZHQjsF/IDeCgvUDmDP+QV5oEfQ1p5X
        mwmXxSJKqaLqaHytUKyJmBf6+td7r4Fha8DZzzdQSJUAU6CegofCP5MwnpSQASKa0tlAUm5M8BG
        f2W9gRISNqwjLHZdE
X-Received: by 2002:a05:622a:1816:b0:3bf:a3d0:9023 with SMTP id t22-20020a05622a181600b003bfa3d09023mr9187114qtc.5.1680776170291;
        Thu, 06 Apr 2023 03:16:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350aL+20cjMWVCWAvDl9nMBjliVH77UEYwfb2LAFMZ8TJCek4kMBt210yrGBo14GU20YWcfAt/Q==
X-Received: by 2002:a05:622a:1816:b0:3bf:a3d0:9023 with SMTP id t22-20020a05622a181600b003bfa3d09023mr9187068qtc.5.1680776169852;
        Thu, 06 Apr 2023 03:16:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id p9-20020a05620a22e900b007456b51ee13sm369988qki.16.2023.04.06.03.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 03:16:09 -0700 (PDT)
Message-ID: <75bd0a9fdcd1f48533e0cff7b2d3e95e362880a4.camel@redhat.com>
Subject: Re: [PATCH net-next v6] vxlan: try to send a packet normally if
 local bypass fails
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
        eyal.birger@gmail.com, jtoppins@redhat.com
Date:   Thu, 06 Apr 2023 12:16:06 +0200
In-Reply-To: <20230405050102.15612-1-vladimir@nikishkin.pw>
References: <20230405050102.15612-1-vladimir@nikishkin.pw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-05 at 13:01 +0800, Vladimir Nikishkin wrote:
> In vxlan_core, if an fdb entry is pointing to a local
> address with some port, the system tries to get the packet to
> deliver the packet to the vxlan directly, bypassing the network

The above sentence sounds confusing to me. Possibly:

... the system tries to deliver the packet to ...

?

> stack.
>=20
> This patch makes it still try canonical delivery, if there is no
> linux kernel vxlan listening on this port. This will be useful
> for the cases when there is some userspace daemon expecting
> vxlan packets for post-processing, or some other implementation
> of vxlan.
>=20
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
>  drivers/net/vxlan/vxlan_core.c                |  29 +++--
>  include/net/vxlan.h                           |   4 +-
>  include/uapi/linux/if_link.h                  |   1 +
>  tools/include/uapi/linux/if_link.h            |   2 +
>  tools/testing/selftests/net/Makefile          |   1 +
>  tools/testing/selftests/net/rtnetlink.sh      |   3 +
>  .../selftests/net/test_vxlan_nolocalbypass.sh | 102 ++++++++++++++++++
>  7 files changed, 135 insertions(+), 7 deletions(-)
>  create mode 100755 tools/testing/selftests/net/test_vxlan_nolocalbypass.=
sh
>=20
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_cor=
e.c
> index 561fe1b314f5..f9dfb179af58 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -2341,7 +2341,7 @@ static int encap_bypass_if_local(struct sk_buff *sk=
b, struct net_device *dev,
>  				 union vxlan_addr *daddr,
>  				 __be16 dst_port, int dst_ifindex, __be32 vni,
>  				 struct dst_entry *dst,
> -				 u32 rt_flags)
> +				 u32 rt_flags, bool localbypass)

No need to add an additional argument, you can use vxlan->cfg.flags
instead

>  {
>  #if IS_ENABLED(CONFIG_IPV6)
>  	/* IPv6 rt-flags are checked against RTF_LOCAL, but the value of
> @@ -2355,11 +2355,13 @@ static int encap_bypass_if_local(struct sk_buff *=
skb, struct net_device *dev,
>  	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
>  		struct vxlan_dev *dst_vxlan;
> =20
> -		dst_release(dst);
>  		dst_vxlan =3D vxlan_find_vni(vxlan->net, dst_ifindex, vni,
>  					   daddr->sa.sa_family, dst_port,
>  					   vxlan->cfg.flags);
>  		if (!dst_vxlan) {
> +			if (!localbypass)
> +				return 0;

A space here would make the code more clear

> +			dst_release(dst);
>  			dev->stats.tx_errors++;
>  			vxlan_vnifilter_count(vxlan, vni, NULL,
>  					      VXLAN_VNI_STATS_TX_ERRORS, 0);
> @@ -2367,6 +2369,7 @@ static int encap_bypass_if_local(struct sk_buff *sk=
b, struct net_device *dev,
> =20
>  			return -ENOENT;
>  		}
> +		dst_release(dst);
>  		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
>  		return 1;
>  	}
> @@ -2494,9 +2497,11 @@ void vxlan_xmit_one(struct sk_buff *skb, struct ne=
t_device *dev,
> =20
>  		if (!info) {
>  			/* Bypass encapsulation if the destination is local */
> +			bool localbypass =3D flags & VXLAN_F_LOCALBYPASS;

The new variable is not needed (see above). Anyway you need to add an
empty line between variable declarations and code - btw strange that
checkpatch did not complain.

>  			err =3D encap_bypass_if_local(skb, dev, vxlan, dst,
>  						    dst_port, ifindex, vni,
> -						    &rt->dst, rt->rt_flags);
> +						    &rt->dst, rt->rt_flags,
> +						    localbypass);
>  			if (err)
>  				goto out_unlock;
> =20
> @@ -2568,10 +2573,10 @@ void vxlan_xmit_one(struct sk_buff *skb, struct n=
et_device *dev,
> =20
>  		if (!info) {
>  			u32 rt6i_flags =3D ((struct rt6_info *)ndst)->rt6i_flags;
> -
> +			bool localbypass =3D flags & VXLAN_F_LOCALBYPASS;
>  			err =3D encap_bypass_if_local(skb, dev, vxlan, dst,
>  						    dst_port, ifindex, vni,
> -						    ndst, rt6i_flags);
> +						    ndst, rt6i_flags, localbypass);
>  			if (err)
>  				goto out_unlock;
>  		}
> @@ -3202,6 +3207,7 @@ static const struct nla_policy vxlan_policy[IFLA_VX=
LAN_MAX + 1] =3D {
>  	[IFLA_VXLAN_TTL_INHERIT]	=3D { .type =3D NLA_FLAG },
>  	[IFLA_VXLAN_DF]		=3D { .type =3D NLA_U8 },
>  	[IFLA_VXLAN_VNIFILTER]	=3D { .type =3D NLA_U8 },
> +	[IFLA_VXLAN_LOCALBYPASS]	=3D { .type =3D NLA_U8 },
>  };
> =20
>  static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
> @@ -4011,6 +4017,14 @@ static int vxlan_nl2conf(struct nlattr *tb[], stru=
ct nlattr *data[],
>  			conf->flags |=3D VXLAN_F_UDP_ZERO_CSUM_TX;
>  	}
> =20
> +	if (data[IFLA_VXLAN_LOCALBYPASS]) {
> +		err =3D vxlan_nl2flag(conf, data, IFLA_VXLAN_LOCALBYPASS,
> +				    VXLAN_F_LOCALBYPASS, changelink,
> +				    false, extack);
> +		if (err)
> +			return err;
> +	}
> +
>  	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
>  		err =3D vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
>  				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
> @@ -4232,6 +4246,7 @@ static size_t vxlan_get_size(const struct net_devic=
e *dev)
>  		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
>  		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
>  		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
> +		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
>  		0;
>  }
> =20
> @@ -4308,7 +4323,9 @@ static int vxlan_fill_info(struct sk_buff *skb, con=
st struct net_device *dev)
>  	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_TX,
>  		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_TX)) ||
>  	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_RX,
> -		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)))
> +		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)) ||
> +	    nla_put_u8(skb, IFLA_VXLAN_LOCALBYPASS,
> +		       !!(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS)))
>  		goto nla_put_failure;
> =20
>  	if (nla_put(skb, IFLA_VXLAN_PORT_RANGE, sizeof(ports), &ports))
> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> index 20bd7d893e10..0be91ca78d3a 100644
> --- a/include/net/vxlan.h
> +++ b/include/net/vxlan.h
> @@ -328,6 +328,7 @@ struct vxlan_dev {
>  #define VXLAN_F_TTL_INHERIT		0x10000
>  #define VXLAN_F_VNIFILTER               0x20000
>  #define VXLAN_F_MDB			0x40000
> +#define VXLAN_F_LOCALBYPASS		0x80000
> =20
>  /* Flags that are used in the receive path. These flags must match in
>   * order for a socket to be shareable
> @@ -348,7 +349,8 @@ struct vxlan_dev {
>  					 VXLAN_F_UDP_ZERO_CSUM6_TX |	\
>  					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
>  					 VXLAN_F_COLLECT_METADATA  |	\
> -					 VXLAN_F_VNIFILTER)
> +					 VXLAN_F_VNIFILTER         |    \
> +					 VXLAN_F_LOCALBYPASS)
> =20
>  struct net_device *vxlan_dev_create(struct net *net, const char *name,
>  				    u8 name_assign_type, struct vxlan_config *conf);
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 8d679688efe0..0fc56be5e19f 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -827,6 +827,7 @@ enum {
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
>  	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
> +	IFLA_VXLAN_LOCALBYPASS,
>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linu=
x/if_link.h
> index 39e659c83cfd..1253bd0aa90e 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -748,6 +748,8 @@ enum {
>  	IFLA_VXLAN_GPE,
>  	IFLA_VXLAN_TTL_INHERIT,
>  	IFLA_VXLAN_DF,
> +	IFLA_VXLAN_VNIFILTER,
> +	IFLA_VXLAN_LOCALBYPASS,
>  	__IFLA_VXLAN_MAX
>  };
>  #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
> index 1de34ec99290..7a9cfd0c92db 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -83,6 +83,7 @@ TEST_GEN_FILES +=3D nat6to4.o
>  TEST_GEN_FILES +=3D ip_local_port_range
>  TEST_GEN_FILES +=3D bind_wildcard
>  TEST_PROGS +=3D test_vxlan_mdb.sh
> +TEST_PROGS +=3D test_vxlan_nolocalbypass.sh
> =20
>  TEST_FILES :=3D settings
> =20
> diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/sel=
ftests/net/rtnetlink.sh
> index 383ac6fc037d..09a5ef4bd42b 100755
> --- a/tools/testing/selftests/net/rtnetlink.sh
> +++ b/tools/testing/selftests/net/rtnetlink.sh
> @@ -505,6 +505,9 @@ kci_test_encap_vxlan()
>  	ip -netns "$testns" link set dev "$vxlan" type vxlan udpcsum 2>/dev/nul=
l
>  	check_fail $?
> =20
> +	ip -netns "$testns" link set dev "$vxlan" type vxlan nolocalbypass 2>/d=
ev/null
> +	check_fail $?

This will fail until a new version of 'ip' is deployed, right? I would
wait before adding this test case (or will move it in the
test_vxlan_nolocalbypass.sh, after the relevant check)

> +
>  	ip -netns "$testns" link set dev "$vxlan" type vxlan udp6zerocsumtx 2>/=
dev/null
>  	check_fail $?
> =20
> diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/to=
ols/testing/selftests/net/test_vxlan_nolocalbypass.sh
> new file mode 100755
> index 000000000000..efa37af2da7b
> --- /dev/null
> +++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
> @@ -0,0 +1,102 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# This file is testing that the [no]localbypass option for a vxlan devic=
e is
> +# working. With the nolocalbypass option, packets to a local destination=
, which
> +# have no corresponding vxlan in the kernel, will be delivered to usersp=
ace, for
> +# any userspace process to process. In this test tcpdump plays the role =
of such a
> +# process. This is what the test 1 is checking.
> +# The test 2 checks that without the nolocalbypass (which is equivalent =
to the
> +# localbypass option), the packets do not reach userspace.
> +
> +EXIT_FAIL=3D1
> +ksft_skip=3D4
> +EXIT_SUCCESS=3D0
> +
> +if [ "$(id -u)" -ne 0 ];then
> +        echo "SKIP: Need root privileges"
> +        exit $ksft_skip;
> +fi
> +
> +if [ ! -x "$(command -v ip)" ]; then
> +        echo "SKIP: Could not run test without ip tool"
> +        exit $ksft_skip
> +fi
> +
> +if [ ! -x "$(command -v bridge)" ]; then
> +        echo "SKIP: Could not run test without bridge tool"
> +        exit $ksft_skip
> +fi

No need to check for the above tool presence. You can assume they are
present, as most net self-tests unconditionally relay on them.

> +
> +if [ ! -x "$(command -v tcpdump)" ]; then
> +        echo "SKIP: Could not run test without tcpdump tool"
> +        exit $ksft_skip
> +fi

I personally would opt for adding nft rules and checking the counters,
but no strong opinion on that.

> +
> +if [ ! -x "$(command -v grep)" ]; then
> +        echo "SKIP: Could not run test without grep tool"
> +        exit $ksft_skip
> +fi

Some self-tests check for 'grep' presence but most simply assume such
command is available. I would opt for the latter.

> +
> +ip link help vxlan 2>&1 | grep -q "localbypass"
> +if [ $? -ne 0 ]; then
> +   echo "SKIP: iproute2 bridge too old, missing VXLAN nolocalbypass supp=
ort"
> +   exit $ksft_skip
> +fi
> +
> +

Additional empty line not needed

> +packetfile=3D/tmp/packets-"$(uuidgen)"
> +
> +# test 1: packets going to userspace
> +rm "$packetfile"
> +ip link del dev testvxlan0
> +ip link add testvxlan0 type vxlan  \
> +  id 100 \
> +  dstport 4789 \
> +  srcport 4789 4790 \
> +  nolearning noproxy \
> +  nolocalbypass
> +ip link set up dev testvxlan0
> +bridge fdb add 00:00:00:00:00:00 dev testvxlan0 dst 127.0.0.1 port 4792
> +ip address add 172.16.100.1/24 dev testvxlan0
> +tcpdump -i lo 'udp and port 4792' > "$packetfile" &
> +tcpdump_pid=3D$!
> +timeout 5 ping -c 5 172.16.100.2
> +kill "$tcpdump_pid"
> +ip link del dev testvxlan0
> +
> +if grep -q "VXLAN" "$packetfile" ; then
> +  echo 'Positive test passed'
> +else
> +  echo 'Positive test failed'
> +  exit $EXIT_FAIL
> +fi
> +rm "$packetfile"

It's better if you additionally remove the generate file(s) in a
cleanup function set as trap for exit:

cleanup()
{
	rm -f ${packetfile}
}

trap cleanup EXIT


Cheers,

Paolo

