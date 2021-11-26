Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4045F0A6
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350471AbhKZPa2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Nov 2021 10:30:28 -0500
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:65452 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345647AbhKZP21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 10:28:27 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 10:28:26 EST
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id D6F90459D1;
        Fri, 26 Nov 2021 16:16:51 +0100 (CET)
Date:   Fri, 26 Nov 2021 16:16:41 +0100
From:   Fabian =?iso-8859-1?q?Gr=FCnbichler?= <f.gruenbichler@proxmox.com>
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Starovoitov, Alexei" <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
        <20201110011932.3201430-4-andrii@kernel.org>
        <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com>
        <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
        <CAEf4BzYSN+XnaA4V3jTLEmoUZO=Yxwp7OAwAY+HOvVEKT5kRFA@mail.gmail.com>
        <20201116132409.4a5b8e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116132409.4a5b8e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1637926692.uyvrkty41j.astroid@nora.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On November 16, 2020 10:24 pm, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 12:34:17 -0800 Andrii Nakryiko wrote:
>> > This change, commit 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole
>> > supports it") currently in net-next, linux-next, etc. breaks the use-case of compiling only a specific
>> > kernel module (both in-tree and out-of-tree, e.g. 'make M=drivers/net/ethernet/intel/ice') after
>> > first doing a 'make modules_prepare'.  Previously, that use-case would result in a warning noting
>> > "Symbol info of vmlinux is missing. Unresolved symbol check will be entirely skipped" but now it
>> > errors out after noting "No rule to make target 'vmlinux', needed by '<...>.ko'.  Stop."
>> >
>> > Is that intentional?  
>> 
>> I wasn't aware of such a use pattern, so definitely not intentional.
>> But vmlinux is absolutely necessary to generate the module BTF. So I'm
>> wondering what's the proper fix here? Leave it as is (that error
>> message is actually surprisingly descriptive, btw)? Force vmlinux
>> build? Or skip BTF generation for that module?
> 
> For an external out-of-tree module there is no guarantee that vmlinux
> will even be on the system, no? So only the last option can work in
> that case.

a year late to the party, but it seems to me that this patch 
series/features also missed another, not yet fixed scenario. I have to 
admit I am not very well-versed in BTF/BPF matters though, so please 
take the analysis below with a grain of salt or two ;)

(am subscribed to LKML/netdev, but not the bpf list, so please keep me 
CCed if discussion moves there! apologies if too many people are CCed 
here, feel free to trim down to relevant people/lists)

many distros do their own tracking of kernel <-> module ABI (usually 
these checks use Module.symvers and some combination of lists/symbols/.. 
to skip/ignore[0]).

depending on detected changes, a kernel update can either
- bump ABI, resulting in a new kernel/modules package that is installed 
  next to the current one
- keep ABI, resulting in an updated kernel/modules package that is 
  installed over/instead of the current one

the former case is obviously not an issue, since the modules and vmlinux 
image shipped in that (set of) package(s) match. but in the later case 
of updated, compatible kernel image + modules with unchanged ABI
(which is important, as it allows shipping fixed modules that are 
loadable for a compatible, older, booted kernel image), the following is 
possible:
- install kernel+modules with ABI 1
- boot kernel with ABI 1
- install ABI-compatible upgrade (e.g. a security fix)
- load module
- BTF validation fails, because the base_btf (loaded at boot time) and 
  the offsets in the module's .BTF section (loaded at module load time) 
  aren't matching

of course the validation might also not fail but the parsed BTF info 
might be bogus, or the base_btf might be similar enough that validation 
passes and the parsed BTF data is correct.

in our case the symptoms look like this (exact details vary with kernel 
builds/modules, but likely not relevant):

Nov 24 11:39:11 host kernel: BPF:         type_id=7 bits_offset=0
Nov 24 11:39:11 host kernel: BPF:
Nov 24 11:39:11 host kernel: BPF:Invalid name
Nov 24 11:39:11 host kernel: BPF:
Nov 24 11:39:11 host kernel: failed to validate module [overlay] BTF: -22

where the booted kernel and the (attempted to get) loaded module are not 
from the same build, but the Module.symvers is matching and loading 
should thus work. adding some more debug logging reveals that the root 
cause is the module's BTF start_str_off being, well, off, since it's derived 
from vmlinux' BTF/base_btf. if it is too big, the name/type lookups will 
wrongly look in the base_btf, if it's too small, the name/type lookups 
will be offset within the module or wrongly look inside the module when 
they should look inside base_btf/vmlinux. in any case, random garbage is 
the result, usually tripping up some validation check (e.g. the first 
byte not being 0 when checking a name). but even if it's correct (old 
and new vmlinux image have the same nr_types/hdr.str_len), there is no 
guarantuee that the offsets into base_btf are pointing at the right 
stuff.

example with debug logging patched in, note the garbled names, and 
offset slightly below the (wrong) start_str_off:

----8<----

BPF:magic: 0xeb9f

BPF:version: 1

BPF:flags: 0x0

BPF:hdr_len: 24

BPF:type_off: 0

BPF:type_len: 9264

BPF:str_off: 9264

BPF:str_len: 5511

BPF:btf_total_size: 14799

BPF:[106314] STRUCT rimary_device
BPF:size=56 vlen=14
BPF:

BPF:offset at call: 1915394
BPF:offset too small, choosing base_btf: 1915397

BPF:offset after base_btf: 1915394

BPF:     ce type_id=49 bits_offset=0
BPF:

BPF:offset at call: 1915403
BPF:offset after base_btf: 6

BPF:     nfig type_id=49 bits_offset=64
BPF:

BPF:offset at call: 1915412
BPF:offset after base_btf: 15

BPF:     rdir type_id=49 bits_offset=128
BPF:

BPF:offset at call: 768428
BPF:offset too small, choosing base_btf: 1915397

BPF:offset after base_btf: 768428

BPF:     _dio type_id=56 bits_offset=192
BPF:

BPF:offset at call: 1915420
BPF:offset after base_btf: 23

BPF:     erdir type_id=56 bits_offset=200
BPF:

BPF:offset at call: 1915433
BPF:offset after base_btf: 36

BPF:first char wrong - 0

BPF:      type_id=56 bits_offset=208
BPF:
BPF:Invalid name STRUCT MEMBER (name offset 1915433)
BPF:

failed to validate module [overlay] BTF: -22

---->8----

also note how it's only after a few botched entries that a check 
actually trips up - not sure what the impliciations for crafted BTF info 
are, but might be worthy a closer look by someone more knowledgable as 
well..

it seems to me this can be solved on the distro/user side by tracking 
vmlinux BTF infos as part of the ABI tracking (how stable are those 
compared to the existing interfaces making up the kernel <-> module 
ABI/Module.symvers? does this effectively mean bumping ABI for any 
change anyway?) or by disabling CONFIG_DEBUG_INFO_BTF_MODULES.

on the kernel/libbpf side it could maybe be solved by storing a hash of 
the base_btf data used to generate the split BTF-sections inside the 
modules, and skip BTF loading/validating if another base_btf is 
currently loaded (so BTF is best-effort, if the booted kernel and the 
module are matching it works, if not module loading works but no BTF 
support). this might be a good safe-guard for split-BTF in general?

I'd appreciate input on how to proceed (we were recently hit by this in 
a downstream Debian derivative, and will disable BTF info for modules as 
an interim measure).

thanks!

0: e.g., Debian's: https://salsa.debian.org/kernel-team/linux/-/blob/master/debian/bin/abiupdate.py

