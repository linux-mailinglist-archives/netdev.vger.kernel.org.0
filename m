Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2392D64E8AB
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLPJeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiLPJeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:34:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6D61FFAA;
        Fri, 16 Dec 2022 01:34:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8953B81D40;
        Fri, 16 Dec 2022 09:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B22C433EF;
        Fri, 16 Dec 2022 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671183246;
        bh=+99HYBSarN+ns6L+rlqjITdaIBrRoBh318L0BdlqU1k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XR0sjBDBF1cJ6R+766Xf8nag2VCVN6ulZ+BLer3MxW83Dv7a9c4BdYYVO9M9OLWjQ
         YBbpj80Re1oa5aFfumL/ibv1PzEwDe2oQJol3Mof8qRkgwZYheXF7KRc/P8/UpZ+sJ
         vxWZODvsvN/aCF9vqgJ9+aJ7lJnquQcjLChPctJUxmD4Ka5FniQo94c568nuchReBr
         bcfITfS7BEYWklgrRCvQ0/rVpJTOWWwopeq4CyT/ld9CvxU8jSRXY9xZYkMaF07mu1
         pmhgmYdAC6oMYnUBZurC2Lr7cljcHBIHINbUZVVn/whMF7JZVZUGB3Rxj1hpOmluEK
         R1MUeiAsWpZUA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Lina Wang <lina.wang@mediatek.com>,
        Coleman Dietsch <dietschc@csp.edu>, bpf@vger.kernel.org,
        Maciej enczykowski <maze@google.com>,
        =?utf-8?B?Qmo=?= =?utf-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn@rivosinc.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCHv2 net-next] selftests/net: mv bpf/nat6to4.c to net folder
In-Reply-To: <20221216084109.1565213-1-liuhangbin@gmail.com>
References: <20221216084109.1565213-1-liuhangbin@gmail.com>
Date:   Fri, 16 Dec 2022 10:34:04 +0100
Message-ID: <871qozn14j.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> writes:

> There are some issues with the bpf/nat6to4.c building.
>
> 1. It use TEST_CUSTOM_PROGS, which will add the nat6to4.o to
>    kselftest-list file and run by common run_tests.
> 2. When building the test via `make -C tools/testing/selftests/
>    TARGETS=3D"net"`, the nat6to4.o will be build in selftests/net/bpf/
>    folder. But in test udpgro_frglist.sh it refers to ../bpf/nat6to4.o.
>    The correct path should be ./bpf/nat6to4.o.
> 3. If building the test via `make -C tools/testing/selftests/ TARGETS=3D"=
net"
>    install`. The nat6to4.o will be installed to kselftest_install/net/
>    folder. Then the udpgro_frglist.sh should refer to ./nat6to4.o.
>
> To fix the confusing test path, let's just move the nat6to4.c to net fold=
er
> and build it as TEST_GEN_FILES.
>
> v2: Update the Makefile rules rely on commit 837a3d66d698 ("selftests:
> net: Add cross-compilation support for BPF programs").
>
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-test=
s")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

FWIW, tested cross-compilation on riscv (and minor nit below):

Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>

> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
> index 3007e98a6d64..ed9a315187c1 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -75,14 +75,60 @@ TEST_GEN_PROGS +=3D so_incoming_cpu
>  TEST_PROGS +=3D sctp_vrf.sh
>  TEST_GEN_FILES +=3D sctp_hello
>  TEST_GEN_FILES +=3D csum
> +TEST_GEN_FILES +=3D nat6to4.o
>=20=20
>  TEST_FILES :=3D settings
>=20=20
>  include ../lib.mk
>=20=20
> -include bpf/Makefile
> -
>  $(OUTPUT)/reuseport_bpf_numa: LDLIBS +=3D -lnuma
>  $(OUTPUT)/tcp_mmap: LDLIBS +=3D -lpthread
>  $(OUTPUT)/tcp_inq: LDLIBS +=3D -lpthread
>  $(OUTPUT)/bind_bhash: LDLIBS +=3D -lpthread
> +
> +# Rules to generate bpf obj nat6to4.o
> +CLANG ?=3D clang
> +SCRATCH_DIR :=3D $(OUTPUT)/tools
> +BUILD_DIR :=3D $(SCRATCH_DIR)/build
> +BPFDIR :=3D $(abspath ../../../lib/bpf)
> +APIDIR :=3D $(abspath ../../../include/uapi)
> +
> +CCINCLUDE +=3D -I../bpf
> +CCINCLUDE +=3D -I../../../../usr/include/
> +CCINCLUDE +=3D -I$(SCRATCH_DIR)/include
> +
> +BPFOBJ :=3D $(BUILD_DIR)/libbpf/libbpf.a
> +
> +MAKE_DIRS :=3D $(BUILD_DIR)/libbpf $(OUTPUT)/bpf
                                    ^^^^^^^^^^^^^
                                    Can be removed after the BPF-prog
                                    moved out from /bpf

Bj=C3=B6rn
