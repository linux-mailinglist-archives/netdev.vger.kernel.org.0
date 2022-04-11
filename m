Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C64F4FBB37
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbiDKLtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244255AbiDKLti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:49:38 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42E145AD0;
        Mon, 11 Apr 2022 04:47:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id BA850CC010D;
        Mon, 11 Apr 2022 13:47:21 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 11 Apr 2022 13:47:19 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0186FCC010C;
        Mon, 11 Apr 2022 13:47:18 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id DE08D343156; Mon, 11 Apr 2022 13:47:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id DC44A343155;
        Mon, 11 Apr 2022 13:47:18 +0200 (CEST)
Date:   Mon, 11 Apr 2022 13:47:18 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        "U'ren, Aaron" <Aaron.U'ren@sony.com>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>
Subject: Re: Intermittent performance regression related to ipset between
 5.10 and 5.15
In-Reply-To: <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
Message-ID: <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com> <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info> <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1045859346-1649677638=:2782"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1045859346-1649677638=:2782
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 11 Apr 2022, Thorsten Leemhuis wrote:

> On 16.03.22 10:17, Thorsten Leemhuis wrote:
> > [TLDR: I'm adding the regression report below to regzbot, the Linux
> > kernel regression tracking bot; all text you find below is compiled f=
rom
> > a few templates paragraphs you might have encountered already already
> > from similar mails.]
> >=20
> > On 16.03.22 00:15, McLean, Patrick wrote:
>
> >> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15.16=
)=20
> >> series, we encountered an intermittent performance regression that=20
> >> appears to be related to iptables / ipset. This regression was=20
> >> noticed on Kubernetes hosts that run kube-router and experience a=20
> >> high amount of churn to both iptables and ipsets. Specifically, when=
=20
> >> we run the nftables (iptables-1.8.7 / nftables-1.0.0) iptables=20
> >> wrapper xtables-nft-multi on the 5.15 series kernel, we end up=20
> >> getting extremely laggy response times when iptables attempts to=20
> >> lookup information on the ipsets that are used in the iptables=20
> >> definition. This issue isn=E2=80=99t reproducible on all hosts. Howe=
ver, our=20
> >> experience has been that across a fleet of ~50 hosts we experienced=20
> >> this issue on ~40% of the hosts. When the problem evidences, the tim=
e=20
> >> that it takes to run unrestricted iptables list commands like=20
> >> iptables -L or iptables-save gradually increases over the course of=20
> >> about 1 - 2 hours. Growing from less than a second to run, to takin
>  g sometimes over 2 minutes to run. After that 2 hour mark it seems to=20
>  plateau and not grow any longer. Flushing tables or ipsets doesn=E2=80=
=99t seem=20
>  to have any affect on the issue. However, rebooting the host does rese=
t=20
>  the issue. Occasionally, a machine that was evidencing the problem may=
=20
>  no longer evidence it after being rebooted.
> >>
> >> We did try to debug this to find a root cause, but ultimately ran=20
> >> short on time. We were not able to perform a set of bisects to=20
> >> hopefully narrow down the issue as the problem isn=E2=80=99t consist=
ently=20
> >> reproducible. We were able to get some straces where it appears that=
=20
> >> most of the time is spent on getsockopt() operations. It appears tha=
t=20
> >> during iptables operations, it attempts to do some work to resolve=20
> >> the ipsets that are linked to the iptables definitions (perhaps=20
> >> getting the names of the ipsets themselves?). Slowly that getsockopt=
=20
> >> request takes more and more time on affected hosts. Here is an=20
> >> example strace of the operation in question:

Yes, iptables list/save have to get the names of the referenced sets and=20
that is performed via getsockopt() calls.

I went through all of the ipset related patches between 5.10.6 (copy&past=
e=20
error but just the range is larger) and 5.15.16 and as far as I see none=20
of them can be responsible for the regression. More data is required to=20
locate the source of the slowdown.

Best regards,
Jozsef

> >>
> >> 0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=3DS_IFR=
EG|0644, st_size=3D539, ...}, 0) =3D 0 <0.000017>
> >> 0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOEXEC=
) =3D -1 ENOENT (No such file or directory) <0.000017>
> >> 0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) =3D =
4 <0.000013>
> >> 0.000034 newfstatat(4, "", {st_mode=3DS_IFREG|0644, st_size=3D6108, =
...}, AT_EMPTY_PATH) =3D 0 <0.000009>
> >> 0.000032 lseek(4, 0, SEEK_SET)     =3D 0 <0.000008>
> >> 0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) =3D =
4096 <0.000010>
> >> 0.000036 close(4)                  =3D 0 <0.000008>
> >> 0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) =3D =
4096 <0.000028>
> >> 0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 4 <0.000015>
> >> 0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) =3D 0 <0.000008>
> >> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0"=
, [8]) =3D 0 <0.000024>
> >> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0K=
UBE-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.109384>
> >> 0.109456 close(4)                  =3D 0 <0.000022>
> >>
> >> On a host that is not evidencing the performance regression we=20
> >> normally see that operation take ~ 0.00001 as opposed to=20
> >> 0.109384.Additionally, hosts that were evidencing the problem we als=
o=20
> >> saw high lock times with `klockstat` (unfortunately at the time we=20
> >> did not know about or run echo "0" > /proc/sys/kernel/kptr_restrict=20
> >> to get the callers of the below commands).
> >>
> >> klockstat -i 5 -n 10 (on a host experiencing the problem)
> >> Caller   Avg Hold  Count   Max hold Total hold
> >> b'[unknown]'  118490772     83  179899470 9834734132
> >> b'[unknown]'  118416941     83  179850047 9828606138
> >> # or somewhere later while iptables -vnL was running:
> >> Caller   Avg Hold  Count   Max hold Total hold
> >> b'[unknown]'  496466236     46 17919955720 22837446860
> >> b'[unknown]'  496391064     46 17919893843 22833988950
> >>
> >> klockstat -i 5 -n 10 (on a host not experiencing the problem)
> >> Caller   Avg Hold  Count   Max hold Total hold
> >> b'[unknown]'     120316   1510   85537797  181677885
> >> b'[unknown]'    7119070     24   85527251  170857690
> >=20
> > Hi, this is your Linux kernel regression tracker.
> >=20
> > Thanks for the report.
> >=20
> > CCing the regression mailing list, as it should be in the loop for al=
l
> > regressions, as explained here:
> > https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.h=
tml
> >=20
> > To be sure below issue doesn't fall through the cracks unnoticed, I'm
> > adding it to regzbot, my Linux kernel regression tracking bot:
> >=20
> > #regzbot ^introduced v5.10..v5.15
> > #regzbot title net: netfilter: Intermittent performance regression
> > related to ipset
> > #regzbot ignore-activity
> >=20
> > If it turns out this isn't a regression, free free to remove it from =
the
> > tracking by sending a reply to this thread containing a paragraph lik=
e
> > "#regzbot invalid: reason why this is invalid" (without the quotes).
> >=20
> > Reminder for developers: when fixing the issue, please add a 'Link:'
> > tags pointing to the report (the mail quoted above) using
> > lore.kernel.org/r/, as explained in
> > 'Documentation/process/submitting-patches.rst' and
> > 'Documentation/process/5.Posting.rst'. Regzbot needs them to
> > automatically connect reports with fixes, but they are useful in
> > general, too.
> >=20
> > I'm sending this to everyone that got the initial report, to make
> > everyone aware of the tracking. I also hope that messages like this
> > motivate people to directly get at least the regression mailing list =
and
> > ideally even regzbot involved when dealing with regressions, as messa=
ges
> > like this wouldn't be needed then. And don't worry, if I need to send
> > other mails regarding this regression only relevant for regzbot I'll
> > send them to the regressions lists only (with a tag in the subject so
> > people can filter them away). With a bit of luck no such messages wil=
l
> > be needed anyway.
> >=20
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' h=
at)
> >=20
> > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > reports on my table. I can only look briefly into most of them and la=
ck
> > knowledge about most of the areas they concern. I thus unfortunately
> > will sometimes get things wrong or miss something important. I hope
> > that's not the case here; if you think it is, don't hesitate to tell =
me
> > in a public reply, it's in everyone's interest to set the public reco=
rd
> > straight.
> >=20
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1045859346-1649677638=:2782--
