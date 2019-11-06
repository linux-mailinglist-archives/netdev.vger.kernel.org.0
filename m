Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1959F1BE0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbfKFQ7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:59:49 -0500
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:56885 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfKFQ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 11:59:49 -0500
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id xA6Gwo9C007338
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 17:58:50 +0100
Received: from ns3096276.ip-94-23-54.eu (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id xA6Gwk4g089756
        (version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO);
        Wed, 6 Nov 2019 17:58:46 +0100
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To:     KP Singh <kpsingh@chromium.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
 <20191106101558.GA19467@chromium.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <026b6f3f-d17a-d50e-4793-a76e6719cc1f@digikod.net>
Date:   Wed, 6 Nov 2019 17:58:46 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <20191106101558.GA19467@chromium.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/11/2019 11:15, KP Singh wrote:
> On 05-Nov 19:01, Mickaël Salaün wrote:
>> On 05/11/2019 18:18, Alexei Starovoitov wrote:

[...]

>>>
>>> I think the only way bpf-based LSM can land is both landlock and KRSI
>>> developers work together on a design that solves all use cases.
>>
>> As I said in a previous cover letter [1], that would be great. I think
>> that the current Landlock bases (almost everything from this series
>> except the seccomp interface) should meet both needs, but I would like
>> to have the point of view of the KRSI developers.
> 
> As I mentioned we are willing to collaborate but the current landlock
> patches does not meet the needs for KRSI:
> 
> * One program type per use-case (eg. LANDLOCK_PROG_PTRACE) as opposed to
>   a single program type. This is something that KRSI proposed in it's
>   initial design [1] and the new common "eBPF + LSM" based approach
>   [2] would maintain as well.

As ask in my previous email [1], I don't see how KRSI would efficiently
deal with other LSM hooks with a unique program (attach) type.

[1]
https://lore.kernel.org/lkml/813cedde-8ed7-2d3b-883d-909efa978d41@digikod.net/

> 
> * Landlock chooses to have multiple LSM hooks per landlock hook which is
>   more restrictive. It's not easy to write precise MAC and Audit
>   policies for a privileged LSM based on this and this ends up bloating
>   the context that needs to be maintained and requires avoidable
>   boilerplate work in the kernel.

Why do you think it is more restrictive or it adds boilerplate work? How
does KRSI will deal with more complex hooks than execve-like with
multiple kernel objects?


> 
> [1] https://lore.kernel.org/patchwork/project/lkml/list/?series=410101
> [2] https://lore.kernel.org/bpf/20191106100655.GA18815@chromium.org/T/#u
> 
> - KP Singh
