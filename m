Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC46C1006CA
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 14:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfKRNup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 08:50:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:35012 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfKRNup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 08:50:45 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWhQR-00022r-8J; Mon, 18 Nov 2019 14:50:43 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iWhQQ-000Udz-VQ; Mon, 18 Nov 2019 14:50:42 +0100
Subject: Re: [PATCH v6 bpf-next 0/5] Add support for memory-mapping BPF array
 maps
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191117172806.2195367-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <04403b43-3a08-e63e-729e-5f9e66ca0dc2@iogearbox.net>
Date:   Mon, 18 Nov 2019 14:50:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191117172806.2195367-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25637/Mon Nov 18 10:53:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/19 6:28 PM, Andrii Nakryiko wrote:
> This patch set adds ability to memory-map BPF array maps (single- and
> multi-element). The primary use case is memory-mapping BPF array maps, created
> to back global data variables, created by libbpf implicitly. This allows for
> much better usability, along with avoiding syscalls to read or update data
> completely.
> 
> Due to memory-mapping requirements, BPF array map that is supposed to be
> memory-mapped, has to be created with special BPF_F_MMAPABLE attribute, which
> triggers slightly different memory allocation strategy internally. See
> patch 1 for details.
> 
> Libbpf is extended to detect kernel support for this flag, and if supported,
> will specify it for all global data maps automatically.
> 
> Patch #1 refactors bpf_map_inc() and converts bpf_map's refcnt to atomic64_t
> to make refcounting never fail. Patch #2 does similar refactoring for
> bpf_prog_add()/bpf_prog_inc().
> 
> v5->v6:
> - add back uref counting (Daniel);
> 
> v4->v5:
> - change bpf_prog's refcnt to atomic64_t (Daniel);
> 
> v3->v4:
> - add mmap's open() callback to fix refcounting (Johannes);
> - switch to remap_vmalloc_pages() instead of custom fault handler (Johannes);
> - converted bpf_map's refcnt/usercnt into atomic64_t;
> - provide default bpf_map_default_vmops handling open/close properly;
> 
> v2->v3:
> - change allocation strategy to avoid extra pointer dereference (Jakub);
> 
> v1->v2:
> - fix map lookup code generation for BPF_F_MMAPABLE case;
> - prevent BPF_F_MMAPABLE flag for all but plain array map type;
> - centralize ref-counting in generic bpf_map_mmap();
> - don't use uref counting (Alexei);
> - use vfree() directly;
> - print flags with %x (Song);
> - extend tests to verify bpf_map_{lookup,update}_elem() logic as well.
> 
> Andrii Nakryiko (5):
>    bpf: switch bpf_map ref counter to atomic64_t so bpf_map_inc() never
>      fails
>    bpf: convert bpf_prog refcnt to atomic64_t
>    bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
>    libbpf: make global data internal arrays mmap()-able, if possible
>    selftests/bpf: add BPF_TYPE_MAP_ARRAY mmap() tests
> 

Applied, thanks!
