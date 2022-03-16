Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B123D4DB915
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347815AbiCPT4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 15:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbiCPT4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 15:56:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011FA1A399;
        Wed, 16 Mar 2022 12:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EAA960EC9;
        Wed, 16 Mar 2022 19:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FEDC340E9;
        Wed, 16 Mar 2022 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647460490;
        bh=Fw8W40y+2aqHKB1pyux+uQpHG/HN4ychezAwB8iNFcE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D6GQVlZssr5Ri9o3lcceM2oIIWtJfO5sAyq4rjM5+XOKg+dH6g0/GuYSW6d6aMQ/8
         ZY17irumnTYfgiRiRxwJYfNVXEzCzHtKgBr6Ds6c0zFoD0Tt1+SP4iPcJPj9hQTnPj
         OPShvP6ufvAVv+pXzXW2/Si07sOiBfWO27vqaedVer832fUJ9ZDL8si0HL+PNc/zGK
         mzHJlOvxTve6cmUwip97rqDhg+d8Fbf/5ue0MRUlgcQdAiB0Q+HIoseFKMTqkhj4BN
         LA/alQ6xLtjyuRFmHPx29k1OBVSZLJS+qIC+jUeO95pp18fYjevkJT60/dh0BLX6Wl
         BL2w665NHrQ0A==
Date:   Wed, 16 Mar 2022 12:54:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "McLean, Patrick" <Patrick.Mclean@sony.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "U'ren, Aaron" <Aaron.U'ren@sony.com>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: Intermittent performance regression related to ipset between
 5.10 and 5.15
Message-ID: <20220316125447.22881d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC netfilter

On Tue, 15 Mar 2022 23:15:08 +0000 McLean, Patrick wrote:
> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.16) ser=
ies, we encountered an intermittent performance regression that appears to =
be related to iptables / ipset. This regression was noticed on Kubernetes h=
osts that run kube-router and experience a high amount of churn to both ipt=
ables and ipsets. Specifically, when we run the nftables (iptables-1.8.7 / =
nftables-1.0.0) iptables wrapper xtables-nft-multi on the 5.15 series kerne=
l, we end up getting extremely laggy response times when iptables attempts =
to lookup information on the ipsets that are used in the iptables definitio=
n. This issue isn=E2=80=99t reproducible on all hosts. However, our experie=
nce has been that across a fleet of ~50 hosts we experienced this issue on =
~40% of the hosts. When the problem evidences, the time that it takes to ru=
n unrestricted iptables list commands like iptables -L or iptables-save gra=
dually increases over the course of about 1 - 2 hours. Growing from less th=
an a second to run, to taking sometimes over 2 minutes to run. After that 2=
 hour mark it seems to plateau and not grow any longer. Flushing tables or =
ipsets doesn=E2=80=99t seem to have any affect on the issue. However, reboo=
ting the host does reset the issue. Occasionally, a machine that was eviden=
cing the problem may no longer evidence it after being rebooted.
>=20
> We did try to debug this to find a root cause, but ultimately ran short o=
n time. We were not able to perform a set of bisects to hopefully narrow do=
wn the issue as the problem isn=E2=80=99t consistently reproducible. We wer=
e able to get some straces where it appears that most of the time is spent =
on getsockopt() operations. It appears that during iptables operations, it =
attempts to do some work to resolve the ipsets that are linked to the iptab=
les definitions (perhaps getting the names of the ipsets themselves?). Slow=
ly that getsockopt request takes more and more time on affected hosts. Here=
 is an example strace of the operation in question:
>=20
> 0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=3DS_IFREG|06=
44, st_size=3D539, ...}, 0) =3D 0 <0.000017>
> 0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOEXEC) =3D=
 -1 ENOENT (No such file or directory) <0.000017>
> 0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) =3D 4 <0.=
000013>
> 0.000034 newfstatat(4, "", {st_mode=3DS_IFREG|0644, st_size=3D6108, ...},=
 AT_EMPTY_PATH) =3D 0 <0.000009>
> 0.000032 lseek(4, 0, SEEK_SET)     =3D 0 <0.000008>
> 0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) =3D 4096 =
<0.000010>
> 0.000036 close(4)                  =3D 0 <0.000008>
> 0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) =3D 4096 =
<0.000028>
> 0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 4 <0.000015>
> 0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) =3D 0 <0.000008>
> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [8]=
) =3D 0 <0.000024>
> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE-D=
ST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.109384>
> 0.109456 close(4)                  =3D 0 <0.000022>
>=20
> On a host that is not evidencing the performance regression we normally s=
ee that operation take ~ 0.00001 as opposed to 0.109384.Additionally, hosts=
 that were evidencing the problem we also saw high lock times with `klockst=
at` (unfortunately at the time we did not know about or run echo "0" > /pro=
c/sys/kernel/kptr_restrict to get the callers of the below commands).
>=20
> klockstat -i 5 -n 10 (on a host experiencing the problem)
> Caller   Avg Hold  Count   Max hold Total hold
> b'[unknown]'  118490772     83  179899470 9834734132
> b'[unknown]'  118416941     83  179850047 9828606138
> # or somewhere later while iptables -vnL was running:
> Caller   Avg Hold  Count   Max hold Total hold
> b'[unknown]'  496466236     46 17919955720 22837446860
> b'[unknown]'  496391064     46 17919893843 22833988950
>=20
> klockstat -i 5 -n 10 (on a host not experiencing the problem)
> Caller   Avg Hold  Count   Max hold Total hold
> b'[unknown]'     120316   1510   85537797  181677885
> b'[unknown]'    7119070     24   85527251  170857690
