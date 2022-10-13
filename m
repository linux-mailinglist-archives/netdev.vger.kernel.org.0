Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7D5FD711
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJMJ2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJMJ2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63C99AC34
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665653286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3J1ZGiG1ZwJxbkF5vhxlhq9myLBYQkjprCwe2WQcCXI=;
        b=ON2InYZShYDzFlhPMyFKSUJAA6q/n7MVty/+/FmxZShOhnAi0jBzy1eghJ5IcVTQ9kNyoI
        VEmfQeqrFXWEPSLNaTCXydT8f7bWeAF+pGVbxS4C4RDZIe3VTJ566lFcjiza5DyLDUWI+M
        FZqQ4WYCYkcDROpXM0UlQVhYAXxIrgw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-PJ09dCbzMgCjhLNduvD0WA-1; Thu, 13 Oct 2022 05:28:05 -0400
X-MC-Unique: PJ09dCbzMgCjhLNduvD0WA-1
Received: by mail-wr1-f72.google.com with SMTP id p7-20020adfba87000000b0022cc6f805b1so318728wrg.21
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3J1ZGiG1ZwJxbkF5vhxlhq9myLBYQkjprCwe2WQcCXI=;
        b=HH/B4KGRgr2D0+MdNkx4IB+QYZuN4OSrmmKpe/sefbCmIzNINKwvcGzrU+K03DM6nU
         dHbXNxh0RgcZpw+r0EvXjlls6pw9z/FmhU4RFBAjtnwmfFZbKDxBxi8z2fwboaXrwCy5
         TUK9Ik/r60xWjH8HxDK2pkj/wdZmmiko+AmELZHs+azpgZeknkA+fukPiEYIypwTf3wf
         X9K7svOH6ZI+nxtrVaI2WjlVyfWC+1lGtVDSy2S8YQVhvjOcmn6kATTg/f1U/uD4wDPb
         XiWmwzWI1aNpGeF0rjnGQHjowu9u9Gbh8fA2Jaqw1lwN2MSU9pdLvu++IAUij/IH1yk5
         26sg==
X-Gm-Message-State: ACrzQf1mb3f5aBMfKpgnHxWBUGUb6LGoZ7Gci1ZqQYSsJYuPi5CwyDlU
        6LUSMqyhN5UcIn/O0hWmP+1FKNozNKsRrCiWrIU0KZWTQDgwcjcaAoyIn8RFFJMoPDGKsl21A6F
        DIae4F48RoFcfBms0
X-Received: by 2002:a05:6000:1817:b0:22e:397a:75ff with SMTP id m23-20020a056000181700b0022e397a75ffmr20663046wrh.567.1665653284213;
        Thu, 13 Oct 2022 02:28:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6aFVf9RwCcRYh7vobfOOJRyBe4Qb0gNEFSureGVKKjAdpmvBxrEFZO9W18Yvi2kv+dkqHMsg==
X-Received: by 2002:a05:6000:1817:b0:22e:397a:75ff with SMTP id m23-20020a056000181700b0022e397a75ffmr20663026wrh.567.1665653283872;
        Thu, 13 Oct 2022 02:28:03 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id bg38-20020a05600c3ca600b003c6c182bef9sm5165725wmb.36.2022.10.13.02.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 02:28:03 -0700 (PDT)
Message-ID: <4610af6c1fbd27e7fb8f19f64514dd34de4fa437.camel@redhat.com>
Subject: Re: [PATCH net v4 2/2] selftests: add selftest for chaining of tc
 ingress handling to egress
From:   Paolo Abeni <pabeni@redhat.com>
To:     Paul Blakey <paulb@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 13 Oct 2022 11:28:02 +0200
In-Reply-To: <1665563053-29263-3-git-send-email-paulb@nvidia.com>
References: <1665563053-29263-1-git-send-email-paulb@nvidia.com>
         <1665563053-29263-3-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-10-12 at 11:24 +0300, Paul Blakey wrote:
> This test runs a simple ingress tc setup between two veth pairs,
> then adds a egress->ingress rule to test the chaining of tc ingress
> pipeline to tc egress piepline.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

this patch does not apply cleanly to -net, could you please rebase it?

> ---
>  tools/testing/selftests/net/Makefile          |  1 +
>  .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
>  2 files changed, 82 insertions(+)
>  create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index c0ee2955fe54..f4774717c5b6 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -63,6 +63,7 @@ TEST_GEN_FILES += cmsg_sender
>  TEST_GEN_FILES += stress_reuseport_listen
>  TEST_PROGS += test_vxlan_vnifiltering.sh
>  TEST_GEN_FILES += io_uring_zerocopy_tx
> +TEST_PROGS += test_ingress_egress_chaining.sh
>  
>  TEST_FILES := settings
>  
> diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
> new file mode 100644
> index 000000000000..193d92078ae0
> --- /dev/null
> +++ b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
> @@ -0,0 +1,81 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# This test runs a simple ingress tc setup between two veth pairs,
> +# and chains a single egress rule to test ingress chaining to egress.
> +#
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +if [ "$(id -u)" -ne 0 ];then
> +	echo "SKIP: Need root privileges"
> +	exit $ksft_skip
> +fi
> +
> +needed_mods="act_mirred cls_flower sch_ingress"
> +for mod in $needed_mods; do
> +	modinfo $mod &>/dev/null || { echo "SKIP: Need act_mirred module"; exit $ksft_skip; }
> +done
> +
> +ns="ns$((RANDOM%899+100))"
> +veth1="veth1$((RANDOM%899+100))"
> +veth2="veth2$((RANDOM%899+100))"
> +peer1="peer1$((RANDOM%899+100))"
> +peer2="peer2$((RANDOM%899+100))"
> +ip_peer1=198.51.100.5
> +ip_peer2=198.51.100.6
> +
> +function fail() {
> +	echo "FAIL: $@" >> /dev/stderr
> +	exit 1
> +}
> +
> +function cleanup() {
> +	killall -q -9 udpgso_bench_rx
> +	ip link del $veth1 &> /dev/null
> +	ip link del $veth2 &> /dev/null
> +	ip netns del $ns &> /dev/null
> +}
> +trap cleanup EXIT
> +
> +function config() {
> +	echo "Setup veth pairs [$veth1, $peer1], and veth pair [$veth2, $peer2]"
> +	ip link add $veth1 type veth peer name $peer1
> +	ip link add $veth2 type veth peer name $peer2
> +	ip addr add $ip_peer1/24 dev $peer1
> +	ip link set $peer1 up
> +	ip netns add $ns
> +	ip link set dev $peer2 netns $ns
> +	ip netns exec $ns ip addr add $ip_peer2/24 dev $peer2
> +	ip netns exec $ns ip link set $peer2 up
> +	ip link set $veth1 up
> +	ip link set $veth2 up
> +
> +	echo "Add tc filter ingress->egress forwarding $veth1 <-> $veth2"
> +	tc qdisc add dev $veth2 ingress
> +	tc qdisc add dev $veth1 ingress
> +	tc filter add dev $veth2 ingress prio 1 proto all flower \
> +		action mirred egress redirect dev $veth1
> +	tc filter add dev $veth1 ingress prio 1 proto all flower \
> +		action mirred egress redirect dev $veth2
> +
> +	echo "Add tc filter egress->ingress forwarding $peer1 -> $veth1, bypassing the veth pipe"
> +	tc qdisc add dev $peer1 clsact
> +	tc filter add dev $peer1 egress prio 20 proto ip flower \
> +		action mirred ingress redirect dev $veth1
> +}
> +
> +function test_run() {
> +	echo "Run tcp traffic"
> +	./udpgso_bench_rx -t &
> +	sleep 1
> +	ip netns exec $ns timeout -k 2 10 ./udpgso_bench_tx -t -l 2 -4 -D $ip_peer1 || fail "traffic failed"
> +	echo "Test passed"
> +}
> +
> +config
> +test_run
> +trap - EXIT
> +cleanup
> +
> +

Additionally, please remote the trailing blank line,

Thanks!

Paolo

