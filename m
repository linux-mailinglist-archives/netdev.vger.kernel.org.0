Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44839F1BD0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 17:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732354AbfKFQ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 11:56:57 -0500
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:60827 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732331AbfKFQ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 11:56:56 -0500
Received: from smtp6.infomaniak.ch (smtp6.infomaniak.ch [83.166.132.19])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id xA6GtXFZ252609
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 17:55:33 +0100
Received: from ns3096276.ip-94-23-54.eu (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp6.infomaniak.ch (8.14.5/8.14.5) with ESMTP id xA6GtBYV034762
        (version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO);
        Wed, 6 Nov 2019 17:55:28 +0100
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To:     KP Singh <kpsingh@chromium.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
 <20191105193446.s4pswwwhrmgk6hcx@ast-mbp.dhcp.thefacebook.com>
 <20191106100655.GA18815@chromium.org>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <813cedde-8ed7-2d3b-883d-909efa978d41@digikod.net>
Date:   Wed, 6 Nov 2019 17:55:11 +0100
User-Agent: 
MIME-Version: 1.0
In-Reply-To: <20191106100655.GA18815@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/11/2019 11:06, KP Singh wrote:
> On 05-Nov 11:34, Alexei Starovoitov wrote:
>> On Tue, Nov 05, 2019 at 07:01:41PM +0100, Mickaël Salaün wrote:
>>> On 05/11/2019 18:18, Alexei Starovoitov wrote:

[...]

>>>> I think the only way bpf-based LSM can land is both landlock and KRSI
>>>> developers work together on a design that solves all use cases.
>>>
>>> As I said in a previous cover letter [1], that would be great. I think
>>> that the current Landlock bases (almost everything from this series
>>> except the seccomp interface) should meet both needs, but I would like
>>> to have the point of view of the KRSI developers.
>>>
>>> [1] https://lore.kernel.org/lkml/20191029171505.6650-1-mic@digikod.net/
>>>
>>>> BPF is capable
>>>> to be a superset of all existing LSMs whereas landlock and KRSI propsals today
>>>> are custom solutions to specific security concerns. BPF subsystem was extended
>>>> with custom things in the past. In networking we have lwt, skb, tc, xdp, sk
>>>> program types with a lot of overlapping functionality. We couldn't figure out
>>>> how to generalize them into single 'networking' program. Now we can and we
>>>> should. Accepting two partially overlapping bpf-based LSMs would be repeating
>>>> the same mistake again.
>>>
>>> I'll let the LSM maintainers comment on whether BPF could be a superset
>>> of all LSM, but given the complexity of an access-control system, I have
>>> some doubts though. Anyway, we need to start somewhere and then iterate.
>>> This patch series is a first step.
>>
>> I would like KRSI folks to speak up. So far I don't see any sharing happening
>> between landlock and KRSI. You're claiming this set is a first step. They're
>> claiming the same about their patches. I'd like to set a patchset that was
>> jointly developed.
> 
> We are willing to collaborate with the Landlock developers and come up
> with a common approach that would work for Landlock and KRSI. I want
> to mention that this collaboration and the current Landlock approach
> of using an eBPF based LSM for unprivileged sandboxing only makes sense
> if unprivileged usage of eBPF is going to be ever allowed.

The ability to *potentially* do unprivileged sandboxing is definitely
not tied nor a blocker to the unprivileged usage of eBPF. As explained
in the documentation [1] (cf. Guiding principles / Unprivileged use),
Landlock is designed to be as safe as possible (from a security point of
view). The impact is more complex and important than just using
unprivileged eBPF, which may not be required. Unprivileged use of eBPF
would be nice, but I think the current direction is to extend the Linux
capabilities with one or multiple dedicated to eBPF [2] (e.g. CAP_BPF +
something else), which may be even better (and a huge difference with
CAP_SYS_ADMIN, a.k.a. privileged mode or root). Landlock is designed to
deal with unprivileged (i.e. non-root) use cases, but of course, if the
Landlock architecture may enable to do unprivileged stuff, it definitely
can do privileged stuff too. However, having an architecture designed
with safe unprivileged use in mind can't be achieve afterwards.

[1] https://lore.kernel.org/lkml/20191104172146.30797-8-mic@digikod.net/
[2] https://lore.kernel.org/bpf/20190827205213.456318-1-ast@kernel.org/


> 
> Purely from a technical standpoint, both the current designs for
> Landlock and KRSI target separate use cases and it would not be
> possible to build "one on top of the other". We've tried to identify
> the lowest denominator ("eBPF+LSM") requirements for both Landlock
> (unprivileged sandboxing / Discretionary Access Control) and KRSI
> (flexibility and unification of privileged MAC and Audit) and
> prototyped an implementation based on the newly added / upcoming
> features in BPF.

This is not as binary as that. Sandboxing can be seen as DAC but also as
MAC, depending on the subject which apply the security policy and the
subjects which are enforced by this policy. If the sandboxing is applied
system-wide, it is what we usually call MAC. DAC, in the Linux world,
enables any user to restrict access to their files to other users.

With Landlock it is not the same because a process can restrict itself
but also enforce these restrictions on all its future children (which
may be malicious, whatever their UID/GID). The threat and the definition
of the attacker are not the same in both cases. With the Linux DAC the
potentially malicious subjects are the other users, whereas with
Landlock the potentially malicious subjects are (for now) the current
process and all its children. Another way to explain it, and how
Landlock is designed, is that a specific enforcement (i.e. a set of BPF
programs) is tied to a domain, in which a set of subject are. From this
perspective, this approach (subjects/tasks in a domain) is orthogonal to
the DAC system (subjects/users). This design may apply to a system-wide
MAC system by putting all the system tasks in one domain, and managing
restrictions (by subject) with other means (e.g. task's UID,
command-line strings, environment variables). In short, Landlock (in
this patch series) is closer to a (potentially scoped) MAC system. But
thanks to eBPF, Landlock is firstly a programmatic access-control, which
means that the one who write the programs and tie them to a set of
tasks, can implement their own access-control system (e.g. RBAC,
time-based…), or something else (e.g. an audit system).

The audit part can simply be achieve with dedicated helpers and programs
that always allow accesses.

Landlock evolved over multiple iterations and is now designed to be very
flexible. The current way to enforce a security policy is to go through
the seccomp syscall (which makes sense for multiple reasons explained
and accepted before). But Landlock is designed to enable similar
enforcements (or audit) with other ways to define a domain (e.g. cgroups
[3], or system-wide securityfs as done in KRSI). Indeed, the only part
tied to this scoped enforcement is in the domain_syscall.c file. A new
file domain_fs.c could be added to implement a securityfs for a
system-wide enforcement (and have other features as KRSI does).

[3] https://lore.kernel.org/lkml/20160914072415.26021-17-mic@digikod.net/

One possible important difference between Landlock and KRSI right now is
the BPF program management. Both manage a list of programs per hook.
However KRSI needs to be able to replace a program in these lists. This
is not implemented in this Landlock patch series, first because it is
not the main use-case and it is safer to have an append-only way to add
restrictions (cf. seccomp-bpf model), and second because it is simpler
to deal with immutable lists. However, it is worth considering extending
the Landlock domain management with the ability to update the program
lists. One challenge may be to identify which program should be replaced
(which KRSI does with the program name). I think it would be wiser to
implement this in a second step though, maybe not for the syscall
interface (thanks to a new seccomp operation), but first with the
securityfs one.


> 
> We've been successfully able to prototype the use cases for KRSI
> (privileged MAC and Audit) using this "eBPF+LSM" and shared our
> approach at the Linux Security Summit [1]:
> 
> * Use the new in-kernel BTF (CO-RE eBPF programs) [2] and the ability
>   of the BPF verifier to use the BTF information for access validation
>   to provide a more generic way to attach to the various LSM hooks.
>   This potentially saves a lot of redundant work:
> 
>    - Creation of new program types.
>    - Multiple types of contexts (or a single context with Unions).
>    - Changes to the verifier and creation of new BPF argument types 
>      (eg. PTR_TO_TASK)

As I understood from the LSS talk, KRSI's approach is to use the same
hooks as LSM (cf. the securityfs). As said Alexei [4] "It must not make
LSM hooks into stable ABI".  Moveover, the LSM hooks may change
according to internal kernel evolution, and their semantic may not make
sense from a user space point of view. This is one reason for which
Lanlock abstract those hooks into something that is simpler and designed
to fit well with eBPF (program contexts and their attached types, as
explained in the documentation).

[4]
https://lore.kernel.org/lkml/20191105215453.szhdkrvuekwfz6le@ast-mbp.dhcp.thefacebook.com/

How does KRSI plan to deal with one LSM hook being split in two hooks in
a next version of the kernel (cf. [5])?

[5] https://lore.kernel.org/lkml/20190910115527.5235-6-kpsingh@chromium.org/


Another reason to have multiple different attach types/contexts (cf.
landlock_domain->programs[]) is to limit useless BPF program
interpretation (in addition to the non-system-wide scoped of programs).
 It also enables to handle and verify strict context use (which is also
explain in the Guiding principles). It would be a huge wast of time to
run every BPF programs for all LSM hooks. KRSI does the same but instead
of relying on the program type it rely on the list tied to the
securityfs file.

BTF is great, but as far as I know, it's goal is to easily deal with the
moving kernel ABI (e.g. task_struct layout, config/constant variables),
and it is definitely useful to programs using bpf_probe_read() and
similar accessors. However, I don't see how KRSI would avoid BPF types
thanks to BTF.

There is only one program type for Landlock (i.e.
BPF_PROG_TYPE_LANDLOCK_HOOK), and I don't see why adding new program
*attach* types (e.g. BPF_LANDLOCK_PTRACE) may be an issue. The kernel
will still need to be modified to implement new hooks and the new BPF
helpers anyway, BTF will not change that, except maybe if the internal
LSM API is exposed in a way or another to BPF (thanks to BTF), which
does not seem acceptable. Am I missing something?


The current KRSI approach is to allow a common set of helpers to be
called by all programs (because there is no way to differentiate them
with their type).
How KRSI would deal with kernel objects other than the current task
(e.g. a ptrace hook with a tracer and a tracee, a file open/read) with
the struct krsi_ctx unions [6]?

[6] https://lore.kernel.org/lkml/20190910115527.5235-7-kpsingh@chromium.org/


How does KRSI plan to deal with security blobs?


> 
> * These new BPF features also alleviate the original concerns that we
>   raised when initially proposing KRSI and designing for precise BPF
>   helpers. We have some patches coming up which incorporate these new
>   changes and will be sharing something on the mailing list after some
>   cleanup.
> 
> We can use the common "eBPF+LSM" for both privileged MAC and Audit and
> unprivileged sandboxing i.e. Discretionary Access Control.
> Here's what it could look like:
> 
> * Common infrastructure allows attachment to all hooks which works well
>   for privileged MAC and Audit. This could be extended to provide
>   another attachment type for unprivileged DAC, which can restrict the
>   hooks that can be attached to, and also the information that is
>   exposed to the eBPF programs which is something that Landlock could
>   build.

I agree that the "privileged-only" hooks should be a superset of the
"security-safe-and-potentially-unprivileged" hooks. :)
However, as said previously, I'm convinced it is a requirement to have
abstract hooks (and associated program attach types) as defined by Landlock.

I'm not sure what you mean by "the information that is exposed to the
eBPF program". Is it the current Landlock implementation of specific
contexts and attach types?

> 
> * This attachment could use the proposed landlock domains and attach to
>   the task_struct providing the discretionary access control semantics.

Not task_struct but creds, yes. This is a characteristic of sandboxing,
which may not be useful for the KRSI use case. It makes sense for KRSI
to attach program sets (or Landlock domains) to the whole system, then
using the creds does not make sense here. This difference is small and a
previous version of Landlock already validated this use case with
cgroups [3] (which is postponed to simplify the patch series).

[3] https://lore.kernel.org/lkml/20160914072415.26021-17-mic@digikod.net/


> 
> [1] https://static.sched.com/hosted_files/lsseu2019/a2/Kernel%20Runtime%20Security%20Instrumentation.pdf
> [2] http://vger.kernel.org/bpfconf2019_talks/bpf-core.pdf
> 
> - KP Singh

I think it should be OK to first land something close to this Landlock
patch series and then we could extend the domain management features and
add the securityfs support that KRSI needs. The main concern seems to be
about hook definitions.

Another approach would be to land Landlock and KRSI as distinct LSM
while trying as much as possible to mutualize code/helpers.
