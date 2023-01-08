Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B696615B5
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 15:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbjAHOFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 09:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjAHOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 09:05:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459DCDED3
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 06:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673186695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXflzFi1IY8CvdFuCK9K1db17KIG9ke2lGlsL5eBMpE=;
        b=SvP8ekAIqcOgi1IwFNYhYd6TdupD/4X2ptAF0OQVZ2E1UrXxA+XANQCvSu/zbwLcEWMngx
        h7JvKJsXNi4fTve6/UOMRZGNlRdimz/pSHsMuIFK4doJj8s1QbA6/SrqG3unA3EzKmZUsy
        xCE1ncG8mp0EwsJj5gxq0pcMxRiam7k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-ijK2vEHDMo25WJO7uVOOWw-1; Sun, 08 Jan 2023 09:04:54 -0500
X-MC-Unique: ijK2vEHDMo25WJO7uVOOWw-1
Received: by mail-qv1-f70.google.com with SMTP id p11-20020ad451cb000000b005319296a239so3842586qvq.18
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 06:04:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bXflzFi1IY8CvdFuCK9K1db17KIG9ke2lGlsL5eBMpE=;
        b=dntf9lj6ihmnyQLBz9tgeIleynLggJY27XhNEUtY0xllT92lSTiUQrhBZqHMDWSXlf
         kmMkYuxgIAjxnFL1fsIjwOionRPb/rtg330rCe5xHONEhlDICqnLeISLT57f4ngYtqUw
         t08X18+tlpoaDtiAbhVITMpFZCQW8SkIQa2G0OZr6qaG3vwJXGBcuHznivDVNlxp4ZIc
         zQ/QFh8NjNcZsQxYJBoSVPS+Anlwis9hYfFxT5iU8DTRLOeTkGZdCKxI6nRK4A1gdDdQ
         R5uBv5PUZ/u86e7dJZ+V0YRGuUAfLU89MeRmAO87OI5Z1X1y8Ad0WTgmHQXmnKPdm8+x
         9zNQ==
X-Gm-Message-State: AFqh2kok4SSd2xch+JzJ6WqCptqCK8DyNnSwQWRRk/cO/aB9iYO7WN7A
        FPPLb+M+RGXmkZUofc31dCTZ7i6Vs2MHnzgBatbHTcCsXvvOzLaZoVeO3YyCwUJM0KG2t8PVRBd
        W1vxzt9oelwlAje8r
X-Received: by 2002:ac8:44d7:0:b0:3a5:4fa8:141c with SMTP id b23-20020ac844d7000000b003a54fa8141cmr95767664qto.23.1673186693557;
        Sun, 08 Jan 2023 06:04:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtID8TsAZQOvN8rRZIxWPf6fGBYCJ6FbN75okARmRvpDMZM4heK3p03Na4clHPhQKpXQ2oNJw==
X-Received: by 2002:ac8:44d7:0:b0:3a5:4fa8:141c with SMTP id b23-20020ac844d7000000b003a54fa8141cmr95767646qto.23.1673186693303;
        Sun, 08 Jan 2023 06:04:53 -0800 (PST)
Received: from debian (2a01cb058918ce0098fed9113971adae.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:98fe:d911:3971:adae])
        by smtp.gmail.com with ESMTPSA id jr49-20020a05622a803100b003ad373d04b6sm232494qtb.59.2023.01.08.06.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 06:04:52 -0800 (PST)
Date:   Sun, 8 Jan 2023 15:04:48 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias May <matthias.may@westermo.com>
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs
 when selftest restarted
Message-ID: <Y7rNgPj9WIroPcQ/@debian>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian>
 <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian>
 <81fdf2bc-4842-96d8-b124-43d0bd5ec124@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81fdf2bc-4842-96d8-b124-43d0bd5ec124@alu.unizg.hr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 08, 2023 at 10:11:25AM +0100, Mirsad Goran Todorovac wrote:
> [root@pc-mtodorov marvin]# tcpdump --immediate-mode -p -v -i veth0 -n
> dropped privs to tcpdump
> tcpdump: listening on veth0, link-type EN10MB (Ethernet), capture size 262144 bytes
> 08:30:22.835825 IP (tos 0x0, ttl 64, id 2490, offset 0, flags [none], proto UDP (17), length 78)
>     198.18.0.1.35195 > 198.18.0.2.vxlan: VXLAN, flags [I] (0x08), vni 100
> ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 198.19.0.2 tell 198.19.0.1, length 28
> 08:30:22.835926 IP (tos 0x0, ttl 64, id 1388, offset 0, flags [none], proto UDP (17), length 78)
>     198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
> ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
> 08:30:22.835976 IP (tos 0xc0, ttl 64, id 29533, offset 0, flags [none], proto ICMP (1), length 106)
>     198.18.0.1 > 198.18.0.2: ICMP host 198.18.0.1 unreachable - admin prohibited filter, length 86
>         IP (tos 0x0, ttl 64, id 1388, offset 0, flags [none], proto UDP (17), length 78)
>     198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
> ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28

For some reasons, your host doesn't accept the VXLAN packets received
over veth0. I guess there are some firewalling rules incompatible with
this tests script.

> > -------- >8 --------
> > 
> > Isolate testing environment and ensure everything is cleaned up on
> > exit.
> > 
> > diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh

> Wow, Guillaueme, this patch actually made things unstuck :)

Great! The patch isolates the testing environment, making it less
dependent from the host that runs it. So the routing and firewalling
configurations don't interfere anymore.

> The entire tools/tests/selftests/net section now had a PASS w "OK", save for a couple of tests here:
> 
> not ok 1 selftests: nci: nci_dev # exit=1
> not ok 12 selftests: net: nat6to4.o
> not ok 13 selftests: net: run_netsocktests # exit=1
> not ok 29 selftests: net: udpgro_bench.sh # exit=255
> not ok 30 selftests: net: udpgro.sh # exit=255
> not ok 37 selftests: net: fcnal-test.sh # TIMEOUT 1500 seconds
> not ok 38 selftests: net: l2tp.sh # exit=2
> not ok 46 selftests: net: icmp_redirect.sh # exit=1
> not ok 55 selftests: net: vrf_route_leaking.sh # exit=1
> not ok 59 selftests: net: udpgro_fwd.sh # exit=1
> not ok 60 selftests: net: udpgro_frglist.sh # exit=255
> not ok 61 selftests: net: veth.sh # exit=1
> not ok 68 selftests: net: srv6_end_dt46_l3vpn_test.sh # exit=1
> not ok 69 selftests: net: srv6_end_dt4_l3vpn_test.sh # exit=1
> not ok 75 selftests: net: arp_ndisc_evict_nocarrier.sh # exit=255
> not ok 83 selftests: net: test_ingress_egress_chaining.sh # exit=1
> not ok 1 selftests: net/hsr: hsr_ping.sh # TIMEOUT 45 seconds
> not ok 3 selftests: net/mptcp: mptcp_join.sh # exit=1
> 
> If you are interested in additional diagnostics, this is a very interesting part of the
> Linux kernel testing ...
> 
> There was apparent hang in selftest/net/fcnal-test.sh as well.
> I can help you with the diagnostics if you wish? Thanks.
> 
> If I could make them all work both on Ubuntu 22.10 kinetic kudu and AlmaLinux 8.7
> stone smilodon (CentOS fork), this would be a milestone for me :)

I'm surprised you have so many failures. Feel free to report them
individually. Don't forget to Cc the authors of the scripts. Just
pay attention not to overwhelm people.

I can probably help with the l2tp.sh failure and maybe with the
fcnal-test.sh hang. Please report them in their own mail thread.

> Have a nice day!
> 
> Regards,
> Mirsad
> 
> -- 
> Mirsad Goran Todorovac
> Sistem inženjer
> Grafički fakultet | Akademija likovnih umjetnosti
> Sveučilište u Zagrebu
>  
> System engineer
> Faculty of Graphic Arts | Academy of Fine Arts
> University of Zagreb, Republic of Croatia
> The European Union
> 
> 

