Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D09C538C43
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244625AbiEaHuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiEaHuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:50:40 -0400
X-Greylist: delayed 538 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 00:50:37 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015355642E;
        Tue, 31 May 2022 00:50:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id AD911CC00F6;
        Tue, 31 May 2022 09:41:37 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 31 May 2022 09:41:35 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0190FCC00F5;
        Tue, 31 May 2022 09:41:33 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id DE4BF3431DE; Tue, 31 May 2022 09:41:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id DCC09343155;
        Tue, 31 May 2022 09:41:33 +0200 (CEST)
Date:   Tue, 31 May 2022 09:41:33 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
cc:     "U'ren, Aaron" <Aaron.U'ren@sony.com>,
        "McLean, Patrick" <Patrick.Mclean@sony.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Brown, Russell" <Russell.Brown@sony.com>,
        "Rueger, Manuel" <manuel.rueger@sony.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Intermittent performance regression related to ipset between
 5.10 and 5.15
In-Reply-To: <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
Message-ID: <6f6070ff-b50-1488-7e9-322be08f35b9@netfilter.org>
References: <BY5PR13MB3604D24C813A042A114B639DEE109@BY5PR13MB3604.namprd13.prod.outlook.com> <5e56c644-2311-c094-e099-cfe0d574703b@leemhuis.info> <c28ed507-168e-e725-dddd-b81fadaf6aa5@leemhuis.info> <b1bfbc2f-2a91-9d20-434d-395491994de@netfilter.org>
 <96e12c14-eb6d-ae07-916b-7785f9558c67@leemhuis.info> <DM6PR13MB3098E6B746264B4F96D9F743C8C39@DM6PR13MB3098.namprd13.prod.outlook.com> <2d9479bd-93bd-0cf1-9bc9-591ab3b2bdec@leemhuis.info>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-1838441230-1653982893=:3224"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-1838441230-1653982893=:3224
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Aaron, Thorsten,

On Mon, 30 May 2022, Thorsten Leemhuis wrote:

> On 04.05.22 21:37, U'ren, Aaron wrote:
> >  It=E2=80=99s good to have the confirmation about why iptables list/s=
ave=20
> > perform so many getsockopt() calls.

Every set lookups behind "iptables" needs two getsockopt() calls: you can=
=20
see them in the strace logs. The first one check the internal protocol=20
number of ipset and the second one verifies/gets the processed set (it's=20
an extension to iptables and therefore there's no internal state to save=20
the protocol version number).

> >  In terms of providing more information to locate the source of the=20
> > slowdown, do you have any recommendations on what information would b=
e=20
> > helpful?
> >  The only thing that I was able to think of was doing a git bisect on=
=20
> > it, but that=E2=80=99s a pretty large range, and the problem isn=E2=80=
=99t always 100%=20
> > reproducible. It seems like something about the state of the system=20
> > needs to trigger the issue. So that approach seemed non-optimal.
> >  I=E2=80=99m reasonably certain that if we took enough of our machine=
s back to=20
> > 5.15.16 we could get some of them to evidence the problem again. If w=
e=20
> > reproduced the problem, what types of diagnostics or debug could we=20
> > give you to help further track down this issue?

In your strace log

0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0\0", [8]=
) =3D 0 <0.000024>
0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0\0KUBE-D=
ST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.1$
0.109456 close(4)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0 <0.000022>

the only things which happen in the second sockopt function are to lock=20
the NFNL_SUBSYS_IPSET mutex, walk the array of the sets, compare the=20
setname, save the result in the case of a match and unlock the mutex.=20
Nothing complicated, no deep, multi-level function calls. Just a few line=
=20
of codes which haven't changed.

The only thing which can slow down the processing is the mutex handling.=20
Don't you have accidentally wait/wound mutex debugging enabled in the=20
kernel? If not, then bisecting the mutex related patches might help.

You wrote that flushing tables or ipsets didn't seem to help. That=20
literally meant flushing i.e. the sets were emptied but not destroyed? Di=
d=20
you try both destroying or flushing?

> Jozsef, I still have this issue on my list of tracked regressions and i=
t
> looks like nothing happens since above mail (or did I miss it?). Could
> you maybe provide some guidance to Aaron to get us all closer to the
> root of the problem?

I really hope it's an accidentally enabled debugging option in the kernel=
.=20
Otherwise bisecting could help to uncover the issue.

Best regards,
Jozsef

> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.
>=20
>=20
> > From: Thorsten Leemhuis <regressions@leemhuis.info>
> > Date: Wednesday, May 4, 2022 at 8:15 AM
> > To: McLean, Patrick <Patrick.Mclean@sony.com>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.ker=
nel.org <netfilter-devel@vger.kernel.org>, U'ren, Aaron <Aaron.U'ren@sony=
.com>, Brown, Russell <Russell.Brown@sony.com>, Rueger, Manuel <manuel.ru=
eger@sony.com>, linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.or=
g>, regressions@lists.linux.dev <regressions@lists.linux.dev>, Florian We=
stphal <fw@strlen.de>, netdev@vger.kernel.org <netdev@vger.kernel.org>, J=
ozsef Kadlecsik <kadlec@netfilter.org>
> > Subject: Re: Intermittent performance regression related to ipset bet=
ween 5.10 and 5.15
> > Hi, this is your Linux kernel regression tracker. Top-posting for onc=
e,
> > to make this easily accessible to everyone.
> >=20
> > Patrick, did you see the comment from Jozsef? Are you having trouble
> > providing additional data or what's the status here from your side? O=
r
> > is that something we can forget?
> >=20
> > Ciao, Thorsten
> >=20
> > #regzbot poke
> >=20
> > On 11.04.22 13:47, Jozsef Kadlecsik wrote:
> >> Hi,
> >>
> >> On Mon, 11 Apr 2022, Thorsten Leemhuis wrote:
> >>
> >>> On 16.03.22 10:17, Thorsten Leemhuis wrote:
> >>>> [TLDR: I'm adding the regression report below to regzbot, the Linu=
x
> >>>> kernel regression tracking bot; all text you find below is compile=
d from
> >>>> a few templates paragraphs you might have encountered already alre=
ady
> >>>> from similar mails.]
> >>>>
> >>>> On 16.03.22 00:15, McLean, Patrick wrote:
> >>>
> >>>>> When we upgraded from the 5.10 (5.10.61) series to the 5.15 (5.15=
.16)=20
> >>>>> series, we encountered an intermittent performance regression tha=
t=20
> >>>>> appears to be related to iptables / ipset. This regression was=20
> >>>>> noticed on Kubernetes hosts that run kube-router and experience a=
=20
> >>>>> high amount of churn to both iptables and ipsets. Specifically, w=
hen=20
> >>>>> we run the nftables (iptables-1.8.7 / nftables-1.0.0) iptables=20
> >>>>> wrapper xtables-nft-multi on the 5.15 series kernel, we end up=20
> >>>>> getting extremely laggy response times when iptables attempts to=20
> >>>>> lookup information on the ipsets that are used in the iptables=20
> >>>>> definition. This issue isn=E2=80=99t reproducible on all hosts. H=
owever, our=20
> >>>>> experience has been that across a fleet of ~50 hosts we experienc=
ed=20
> >>>>> this issue on ~40% of the hosts. When the problem evidences, the =
time=20
> >>>>> that it takes to run unrestricted iptables list commands like=20
> >>>>> iptables -L or iptables-save gradually increases over the course =
of=20
> >>>>> about 1 - 2 hours. Growing from less than a second to run, to tak=
in
> >>> =C2=A0 g sometimes over 2 minutes to run. After that 2 hour mark it=
 seems to=20
> >>> =C2=A0 plateau and not grow any longer. Flushing tables or ipsets d=
oesn=E2=80=99t seem=20
> >>> =C2=A0 to have any affect on the issue. However, rebooting the host=
 does reset=20
> >>> =C2=A0 the issue. Occasionally, a machine that was evidencing the p=
roblem may=20
> >>> =C2=A0 no longer evidence it after being rebooted.
> >>>>>
> >>>>> We did try to debug this to find a root cause, but ultimately ran=
=20
> >>>>> short on time. We were not able to perform a set of bisects to=20
> >>>>> hopefully narrow down the issue as the problem isn=E2=80=99t cons=
istently=20
> >>>>> reproducible. We were able to get some straces where it appears t=
hat=20
> >>>>> most of the time is spent on getsockopt() operations. It appears =
that=20
> >>>>> during iptables operations, it attempts to do some work to resolv=
e=20
> >>>>> the ipsets that are linked to the iptables definitions (perhaps=20
> >>>>> getting the names of the ipsets themselves?). Slowly that getsock=
opt=20
> >>>>> request takes more and more time on affected hosts. Here is an=20
> >>>>> example strace of the operation in question:
> >>
> >> Yes, iptables list/save have to get the names of the referenced sets=
 and=20
> >> that is performed via getsockopt() calls.
> >>
> >> I went through all of the ipset related patches between 5.10.6 (copy=
&paste=20
> >> error but just the range is larger) and 5.15.16 and as far as I see =
none=20
> >> of them can be responsible for the regression. More data is required=
 to=20
> >> locate the source of the slowdown.
> >>
> >> Best regards,
> >> Jozsef
> >>
> >>>>>
> >>>>> 0.000074 newfstatat(AT_FDCWD, "/etc/nsswitch.conf", {st_mode=3DS_=
IFREG|0644, st_size=3D539, ...}, 0) =3D 0 <0.000017>
> >>>>> 0.000064 openat(AT_FDCWD, "/var/db/protocols.db", O_RDONLY|O_CLOE=
XEC) =3D -1 ENOENT (No such file or directory) <0.000017>
> >>>>> 0.000057 openat(AT_FDCWD, "/etc/protocols", O_RDONLY|O_CLOEXEC) =3D=
 4 <0.000013>
> >>>>> 0.000034 newfstatat(4, "", {st_mode=3DS_IFREG|0644, st_size=3D610=
8, ...}, AT_EMPTY_PATH) =3D 0 <0.000009>
> >>>>> 0.000032 lseek(4, 0, SEEK_SET)=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0 <0.0=
00008>
> >>>>> 0.000025 read(4, "# /etc/protocols\n#\n# Internet (I"..., 4096) =3D=
 4096 <0.000010>
> >>>>> 0.000036 close(4)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0 <0.000008>
> >>>>> 0.000028 write(1, "ANGME7BF25 - [0:0]\n:KUBE-POD-FW-"..., 4096) =3D=
 4096 <0.000028>
> >>>>> 0.000049 socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 4 <0.000015>
> >>>>> 0.000032 fcntl(4, F_SETFD, FD_CLOEXEC) =3D 0 <0.000008>
> >>>>> 0.000024 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\0\1\0\0\7\0\0=
\0", [8]) =3D 0 <0.000024>
> >>>>> 0.000046 getsockopt(4, SOL_IP, 0x53 /* IP_??? */, "\7\0\0\0\7\0\0=
\0KUBE-DST-VBH27M7NWLDOZIE"..., [40]) =3D 0 <0.109384>
> >>>>> 0.109456 close(4)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0 <0.000022>
> >>>>>
> >>>>> On a host that is not evidencing the performance regression we=20
> >>>>> normally see that operation take ~ 0.00001 as opposed to=20
> >>>>> 0.109384.Additionally, hosts that were evidencing the problem we =
also=20
> >>>>> saw high lock times with `klockstat` (unfortunately at the time w=
e=20
> >>>>> did not know about or run echo "0" > /proc/sys/kernel/kptr_restri=
ct=20
> >>>>> to get the callers of the below commands).
> >>>>>
> >>>>> klockstat -i 5 -n 10 (on a host experiencing the problem)
> >>>>> Caller=C2=A0=C2=A0 Avg Hold=C2=A0 Count=C2=A0=C2=A0 Max hold Tota=
l hold
> >>>>> b'[unknown]'=C2=A0 118490772=C2=A0=C2=A0=C2=A0=C2=A0 83=C2=A0 179=
899470 9834734132
> >>>>> b'[unknown]'=C2=A0 118416941=C2=A0=C2=A0=C2=A0=C2=A0 83=C2=A0 179=
850047 9828606138
> >>>>> # or somewhere later while iptables -vnL was running:
> >>>>> Caller=C2=A0=C2=A0 Avg Hold=C2=A0 Count=C2=A0=C2=A0 Max hold Tota=
l hold
> >>>>> b'[unknown]'=C2=A0 496466236=C2=A0=C2=A0=C2=A0=C2=A0 46 179199557=
20 22837446860
> >>>>> b'[unknown]'=C2=A0 496391064=C2=A0=C2=A0=C2=A0=C2=A0 46 179198938=
43 22833988950
> >>>>>
> >>>>> klockstat -i 5 -n 10 (on a host not experiencing the problem)
> >>>>> Caller=C2=A0=C2=A0 Avg Hold=C2=A0 Count=C2=A0=C2=A0 Max hold Tota=
l hold
> >>>>> b'[unknown]'=C2=A0=C2=A0=C2=A0=C2=A0 120316=C2=A0=C2=A0 1510=C2=A0=
=C2=A0 85537797=C2=A0 181677885
> >>>>> b'[unknown]'=C2=A0=C2=A0=C2=A0 7119070=C2=A0=C2=A0=C2=A0=C2=A0 24=
=C2=A0=C2=A0 85527251=C2=A0 170857690
> >>>>
> >>>> Hi, this is your Linux kernel regression tracker.
> >>>>
> >>>> Thanks for the report.
> >>>>
> >>>> CCing the regression mailing list, as it should be in the loop for=
 all
> >>>> regressions, as explained here:
> >>>> https://urldefense.com/v3/__https:/www.kernel.org/doc/html/latest/=
admin-guide/reporting-issues.html__;!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2Z=
sxlSeY6NoNdYH6BxvEi_JHC4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpZdwVIY=
5$=20
> >>>>
> >>>> To be sure below issue doesn't fall through the cracks unnoticed, =
I'm
> >>>> adding it to regzbot, my Linux kernel regression tracking bot:
> >>>>
> >>>> #regzbot ^introduced v5.10..v5.15
> >>>> #regzbot title net: netfilter: Intermittent performance regression
> >>>> related to ipset
> >>>> #regzbot ignore-activity
> >>>>
> >>>> If it turns out this isn't a regression, free free to remove it fr=
om the
> >>>> tracking by sending a reply to this thread containing a paragraph =
like
> >>>> "#regzbot invalid: reason why this is invalid" (without the quotes=
).
> >>>>
> >>>> Reminder for developers: when fixing the issue, please add a 'Link=
:'
> >>>> tags pointing to the report (the mail quoted above) using
> >>>> lore.kernel.org/r/, as explained in
> >>>> 'Documentation/process/submitting-patches.rst' and
> >>>> 'Documentation/process/5.Posting.rst'. Regzbot needs them to
> >>>> automatically connect reports with fixes, but they are useful in
> >>>> general, too.
> >>>>
> >>>> I'm sending this to everyone that got the initial report, to make
> >>>> everyone aware of the tracking. I also hope that messages like thi=
s
> >>>> motivate people to directly get at least the regression mailing li=
st and
> >>>> ideally even regzbot involved when dealing with regressions, as me=
ssages
> >>>> like this wouldn't be needed then. And don't worry, if I need to s=
end
> >>>> other mails regarding this regression only relevant for regzbot I'=
ll
> >>>> send them to the regressions lists only (with a tag in the subject=
 so
> >>>> people can filter them away). With a bit of luck no such messages =
will
> >>>> be needed anyway.
> >>>>
> >>>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker=
' hat)
> >>>>
> >>>> P.S.: As the Linux kernel's regression tracker I'm getting a lot o=
f
> >>>> reports on my table. I can only look briefly into most of them and=
 lack
> >>>> knowledge about most of the areas they concern. I thus unfortunate=
ly
> >>>> will sometimes get things wrong or miss something important. I hop=
e
> >>>> that's not the case here; if you think it is, don't hesitate to te=
ll me
> >>>> in a public reply, it's in everyone's interest to set the public r=
ecord
> >>>> straight.
> >>>>
> >>>
> >>
> >> -
> >> E-mail=C2=A0 : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
> >> PGP key : https://urldefense.com/v3/__https:/wigner.hu/*kadlec/pgp_p=
ublic_key.txt__;fg!!JmoZiZGBv3RvKRSx!9uRzPn01pFuoHMQj2ZsxlSeY6NoNdYH6BxvE=
i_JHC4sZoqDTp8X2ZYrIRtIOhN7RM0PtxYLq4NIe9g0hJqZVpRHTvk29$=20
> >> Address : Wigner Research Centre for Physics
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 H-1525 =
Budapest 114, POB. 49, Hungary
> >=20
> >=20
>=20

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-1838441230-1653982893=:3224--
