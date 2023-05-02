Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B916F40DA
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 12:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbjEBKPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 06:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233769AbjEBKPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 06:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D14558B
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 03:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683022459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/eyem5wqQi2Y4xvRCBkRhjqs6JPxWfrgrFUYgDwDuk=;
        b=ZmmcpW+YPRidve+h2KEYCtFn9EKLNiIr2CjEhvvDFaoCgv20bWYpeGF0nkWzKVD/JkdnFF
        YbxgdnN3W959Y4EB0pAtkEDMlcLKxMgJi+7/rssez6kQ2a4tXoJI0EpB+J17hP64UCiY5M
        zxQ2eCkn/jHaFfKD3A44yYIz4ztpInA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-inrDMbUlPPW-2aPgkpnVSw-1; Tue, 02 May 2023 06:14:18 -0400
X-MC-Unique: inrDMbUlPPW-2aPgkpnVSw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f55d641ef9so563600f8f.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 03:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683022457; x=1685614457;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A/eyem5wqQi2Y4xvRCBkRhjqs6JPxWfrgrFUYgDwDuk=;
        b=jbqhjxxVq1z7xd8t0J1z4GGbJggYL4vf1mKT953oXFflyntv0qkF3WGxu3+Y9EeK+X
         9KKF7eTgvyRpY8/tyw5PgSOoR+sM2HYGXaLQQC5U+GbKrWRHE2QI34aenLJuwDkFn8Ap
         KRD7ZeahYhQxL+nrSt5ClIBPtEcgpL2Knv43PJyXqSOk6GTQgwm+KpY12Psx4GoxqTWX
         2o9eSuvYNPLPtcuArZac/lEEGYmGNsqw0O/I8PhbxP7qvjnvYWR9dKmLoVXFixvaplVO
         opJzN+fnunQcy8Ahz4wC4e/UbrCYMFwsF7FcM9LRP+R6WsY3RCh/m7esYA+IluC/Hs76
         wylg==
X-Gm-Message-State: AC+VfDwar9/ew06uIv0rkxWQkcf4rkGo7XnnciAcfZdWLqv3Ronwstbq
        so0DZneC7EA4RKewPsa/ceIbi0HdFTHYhdrkf+l+Tvn6uBLgwYC1k0Us2pGlFKcmnsPSBoP/K2n
        F49Vd/IIWj1M3n6rE
X-Received: by 2002:a05:600c:4a93:b0:3f1:78bd:c38b with SMTP id b19-20020a05600c4a9300b003f178bdc38bmr1561061wmp.4.1683022457017;
        Tue, 02 May 2023 03:14:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4px8CSTzQsHfapsduu+b33p8uTaLWpKauxkgtrfrxbHlZ2SB3EWiBLZSKqVAVTtUD4VHFZDw==
X-Received: by 2002:a05:600c:4a93:b0:3f1:78bd:c38b with SMTP id b19-20020a05600c4a9300b003f178bdc38bmr1561044wmp.4.1683022456720;
        Tue, 02 May 2023 03:14:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-253-104.dyn.eolo.it. [146.241.253.104])
        by smtp.gmail.com with ESMTPSA id l2-20020a05600c4f0200b003ee74c25f12sm38902239wmq.35.2023.05.02.03.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 03:14:16 -0700 (PDT)
Message-ID: <2d198b1f309a5c7b44cfae80647148eb922050e7.camel@redhat.com>
Subject: Re: [PATCH net-next v7 2/2] Add tests for vxlan nolocalbypass
 option.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
        razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
        eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Date:   Tue, 02 May 2023 12:14:14 +0200
In-Reply-To: <20230501162530.26414-2-vladimir@nikishkin.pw>
References: <20230501162530.26414-1-vladimir@nikishkin.pw>
         <20230501162530.26414-2-vladimir@nikishkin.pw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-05-02 at 00:25 +0800, Vladimir Nikishkin wrote:
> Add test to make sure that the localbypass option is on by default.
>=20
> Add test to change vxlan localbypass to nolocalbypass and check
> that packets are delivered to userspace.
>=20
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
>  tools/testing/selftests/net/Makefile          |   1 +
>  .../selftests/net/test_vxlan_nolocalbypass.sh | 234 ++++++++++++++++++
>  2 files changed, 235 insertions(+)
>  create mode 100755 tools/testing/selftests/net/test_vxlan_nolocalbypass.=
sh
>=20
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
> index c12df57d5539..7f3ab2a93ed6 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -84,6 +84,7 @@ TEST_GEN_FILES +=3D ip_local_port_range
>  TEST_GEN_FILES +=3D bind_wildcard
>  TEST_PROGS +=3D test_vxlan_mdb.sh
>  TEST_PROGS +=3D test_bridge_neigh_suppress.sh
> +TEST_PROGS +=3D test_vxlan_nolocalbypass.sh
> =20
>  TEST_FILES :=3D settings
> =20
> diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/to=
ols/testing/selftests/net/test_vxlan_nolocalbypass.sh
> new file mode 100755
> index 000000000000..d8e48ab1e7e0
> --- /dev/null
> +++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
> @@ -0,0 +1,234 @@
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
> +EXIT_SUCCESS=3D0
> +EXIT_FAIL=3D1
> +ksft_skip=3D4
> +nsuccess=3D0
> +nfail=3D0
> +
> +ret=3D0
> +
> +TESTS=3D"
> +changelink_nolocalbypass_simple
> +"
> +VERBOSE=3D0
> +PAUSE_ON_FAIL=3Dno
> +PAUSE=3Dno
> +
> +
> +NETNS_NAME=3Dvxlan_nolocalbypass_test
> +
> +########################################################################=
########
> +# Utilities
> +
> +log_test()
> +{
> +	local rc=3D$1
> +	local expected=3D$2
> +	local msg=3D"$3"
> +
> +	if [ ${rc} -eq ${expected} ]; then
> +		printf "TEST: %-60s  [ OK ]\n" "${msg}"
> +		nsuccess=3D$((nsuccess+1))
> +	else
> +		ret=3D1
> +		nfail=3D$((nfail+1))
> +		printf "TEST: %-60s  [FAIL]\n" "${msg}"
> +		if [ "$VERBOSE" =3D "1" ]; then
> +			echo "    rc=3D$rc, expected $expected"
> +		fi
> +
> +		if [ "${PAUSE_ON_FAIL}" =3D "yes" ]; then
> +		echo
> +			echo "hit enter to continue, 'q' to quit"
> +			read a
> +			[ "$a" =3D "q" ] && exit 1
> +		fi
> +	fi
> +
> +	if [ "${PAUSE}" =3D "yes" ]; then
> +		echo
> +		echo "hit enter to continue, 'q' to quit"
> +		read a
> +		[ "$a" =3D "q" ] && exit 1
> +	fi
> +
> +	[ "$VERBOSE" =3D "1" ] && echo
> +}
> +
> +run_cmd()
> +{
> +	local cmd=3D"$1"
> +	local out
> +	local stderr=3D"2>/dev/null"
> +
> +	if [ "$VERBOSE" =3D "1" ]; then
> +		printf "COMMAND: $cmd\n"
> +		stderr=3D
> +	fi
> +
> +	out=3D$(eval $cmd $stderr)
> +	rc=3D$?
> +	if [ "$VERBOSE" =3D "1" -a -n "$out" ]; then
> +		echo "    $out"
> +	fi
> +
> +	return $rc
> +}
> +
> +socat_check_packets()
> +{
> +  echo TODO
> +  exit 1

Minor nit: please use a consistent number of spaces to indent e.g. 4

Note that net-next is currently close, you should submit the next
revision when net-next reopens after May 8th.

Cheers,

Paolo

