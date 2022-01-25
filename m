Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F0649BDF1
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 22:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiAYVmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 16:42:11 -0500
Received: from www62.your-server.de ([213.133.104.62]:51034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiAYVmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 16:42:11 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nCTZo-000GVx-Fb; Tue, 25 Jan 2022 22:42:08 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nCTZo-0007XE-91; Tue, 25 Jan 2022 22:42:08 +0100
Subject: Re: Bpftool mirror now available
To:     Dave Thaler <dthaler@microsoft.com>,
        Quentin Monnet <quentin@isovalent.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
 <CH2PR21MB14640448106792E7197A042CA35A9@CH2PR21MB1464.namprd21.prod.outlook.com>
 <127cb5f6-a969-82df-3dff-a5ac288d7043@isovalent.com>
 <CH2PR21MB1464B0B4A9BFF34D1386DF0EA35F9@CH2PR21MB1464.namprd21.prod.outlook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1e45d3ed-7fcf-81d2-ae68-5b93467a3d32@iogearbox.net>
Date:   Tue, 25 Jan 2022 22:42:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CH2PR21MB1464B0B4A9BFF34D1386DF0EA35F9@CH2PR21MB1464.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26433/Tue Jan 25 10:33:19 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 4:39 AM, Dave Thaler wrote:
> Quentin Monnet <quentin@isovalent.com> writes:
>> Another thing to consider is that keeping bpftool next to the kernel sources
>> has been useful to help keeping the tool in sync, for example for adding new
>> type names to bpftool's lists when the kernel get new program/map types.
>> We have recently introduced some CI checks that could be adjusted to work
>> with an external repo and mitigate this issue, but still, it is harder to tell people
>> to submit changes to a second repository when what they want is just to update
>> the kernel. I fear this would result in a bit more maintenance on bpftool's side
>> (but then bpftool's requirements in terms of maintenance are not that big
>> when compared to bigger tools, and maybe some of it could be automated).
>>
>> Then the other solution, as you mentioned, would be to take Windows-related
>> patches for bpftool in the Linux repo. For what it's worth, I don't have any
>> personal objection to it, but it raises the problems of testing and ownership
>> (who fixes bugs) for these patches.
> 
> Personally I would recommend a third approach.   That is, bpftool today
> combines both platform-agnostic code and platform-specific code without
> clean factoring between them.  Instead I would want to see it factored such
> that there is a clean API between them, where the platform-agnostic code
> can be out-of-tree, and the platform-specific code can be in-tree.   This would
> allow Windows platform-specific code to similarly be in-tree for the ebpf-for-windows project.  Both the Linux kernel and ebpf-for-windows (and any other
> future platforms) can then depend on the out-of-tree code along with their
> own platform-specific code needed to build and run on their own platform.
> That's roughly the approach that I've taken for some other projects where it
> has worked well.

I wouldn't mind if tools/bpf/bpftool/ would see some refactoring effort to
make it more platform-agnostic, similar as kernel split out arch/ bits vs
generic code. Needed bits should however still be somewhere under bpftool
dir in the tree, at least for Linux, so that patch series touching kernel +
libbpf + bpftool can be run by the existing CI w/o extra detour to first
patch or requiring feature branch on some external out-of-tree dependency.
Perhaps it would be possible to have platform-specific code pluggable via
lib as one of the build options for bpftool..

Thanks,
Daniel
