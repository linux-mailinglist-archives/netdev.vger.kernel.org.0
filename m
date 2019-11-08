Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26928F5002
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKHPlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:41:12 -0500
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:36977 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfKHPlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 10:41:11 -0500
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id xA8Fe0wD187815
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Nov 2019 16:40:00 +0100
Received: from ns3096276.ip-94-23-54.eu (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id xA8FduEU195949
        (version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO);
        Fri, 8 Nov 2019 16:39:56 +0100
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     KP Singh <kpsingh@chromium.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Drysdale <drysdale@google.com>,
        Florent Revest <revest@chromium.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>, bpf@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
 <20191105193446.s4pswwwhrmgk6hcx@ast-mbp.dhcp.thefacebook.com>
 <20191106100655.GA18815@chromium.org>
 <813cedde-8ed7-2d3b-883d-909efa978d41@digikod.net>
 <20191106214526.GA22244@chromium.org>
 <3e208632-e7ab-3405-5196-ab1d770e20c3@digikod.net>
 <5d0f1dc5-5a99-bd6a-4acc-0cdcd062a0c9@iogearbox.net>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <78b75ea3-3a7c-103c-ee00-a9c6c41bcd9c@digikod.net>
Date:   Fri, 8 Nov 2019 16:39:55 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <5d0f1dc5-5a99-bd6a-4acc-0cdcd062a0c9@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/11/2019 15:34, Daniel Borkmann wrote:
> On 11/8/19 3:08 PM, Mickaël Salaün wrote:
>> On 06/11/2019 22:45, KP Singh wrote:
>>> On 06-Nov 17:55, Mickaël Salaün wrote:
>>>> On 06/11/2019 11:06, KP Singh wrote:
>>>>> On 05-Nov 11:34, Alexei Starovoitov wrote:
>>>>>> On Tue, Nov 05, 2019 at 07:01:41PM +0100, Mickaël Salaün wrote:
>>>>>>> On 05/11/2019 18:18, Alexei Starovoitov wrote:
> [...]
>>> * Use a single BPF program type; this is necessary for a key requirement
>>>    of KRSI, i.e. runtime instrumentation. The upcoming prototype should
>>>    illustrate how this works for KRSI - note that it’s possible to vary
>>>    the context types exposed by different hooks.
>>
>> Why a single BPF program type? Do you mean *attach* types? Landlock only
>> use one program type, but will use multiple attach types.
>>
>> Why do you think it is necessary for KRSI or for runtime instrumentation?
>>
>> If it is justified, it could be a dedicated program attach type (e.g.
>> BPF_LANDLOCK_INTROSPECTION).
>>
>> What is the advantage to have the possibility to vary the context types
>> over dedicated *typed* contexts? I don't see any advantages, but at
>> least one main drawback: to require runtime checks (when helpers use
>> this generic context) instead of load time checks (thanks to static type
>> checking of the context).
> 
> Lets take security_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
> as one specific example here: the running kernel has its own internal
> btf_vmlinux and therefore a complete description of itself. From verifier
> side we can retrieve & introspect the security_sock_rcv_skb signatue

OK, this is indeed the signature defined by the kernel API. What happen
if this API change (e.g. if struct sock is replaced with a struct
sock_meta)?


> and
> thus know that the given BPF attachment point has struct sock and struct
> sk_buff as input arguments

How does the verifier know a given BPF attachment point for a program
without relying on its type or attach type? How and where is registered
this mapping?

To say it another way, if there is no way to differentiate two program
targeting different hook, I don't understand how the verifier could
check if a given program can legitimately call a helper which could read
the tracer and tracee fields (legitimate for a ptrace hook), whereas
this program may be attached to a sock_rcv_skb hook (and there is no way
to know that).


> which can then be accessed generically by the
> prog in order to allow sk_filter_trim_cap() to pass or to drop the skb.
> The same generic approach can be done for many of the other lsm hooks, so
> single program type would be enough there and context is derived
> automatically,
> no dedicated extra context per attach type would be needed and no runtime
> checks as you mentioned above since its still all asserted at verification
> time.

I mentioned runtime check because I though a helper should handle the
case when it doesn't make sense for a program attached to a specific
point/hook (e.g. ptrace) to use an input argument (e.g. sk) defined for
another point/hook (e.g. sock_rcv_skb).


> 
> Thanks,
> Daniel
> 

Thanks for this explanation Daniel.
