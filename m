Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517CE26CC2E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgIPUkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:40:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgIPRFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600275952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gyutKQ7iDiDszh0jv8Q/Pe+omXRolnMPIqJhMtRQapY=;
        b=A0kllOkYnUlYXIUO9TEQoe7BrC3heU7iE4j2wPnifbVce3TtG13Cp2VLTOgoZHDjwuw8w8
        J3xKdCIW8lHaHl7vOJBjp9/ph4bsmXv9URQxoNfAZT/UVw1wT4wgYu219csWnumoVEDBhx
        fhkxdOOWlwj/GT2H71ev+hSZhLbJYmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-isAKG4fLMS2R26-5FIglVw-1; Wed, 16 Sep 2020 08:39:49 -0400
X-MC-Unique: isAKG4fLMS2R26-5FIglVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1A19800C78;
        Wed, 16 Sep 2020 12:39:45 +0000 (UTC)
Received: from astarta.redhat.com (ovpn-114-67.ams2.redhat.com [10.36.114.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D7A475137;
        Wed, 16 Sep 2020 12:39:39 +0000 (UTC)
From:   Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
        ardb@kernel.org, naresh.kamboju@linaro.org,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: bpf: Fix branch offset in JIT
References: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
        <20200915131102.GA26439@willie-the-truck>
        <20200915135344.GA113966@apalos.home>
        <20200915141707.GB26439@willie-the-truck>
        <20200915192311.GA124360@apalos.home>
Date:   Wed, 16 Sep 2020 15:39:37 +0300
In-Reply-To: <20200915192311.GA124360@apalos.home> (Ilias Apalodimas's message
        of "Tue, 15 Sep 2020 22:23:11 +0300")
Message-ID: <xunyo8m5hp4m.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Ilias!

>>>>> On Tue, 15 Sep 2020 22:23:11 +0300, Ilias Apalodimas  wrote:

 > Hi Will, 
 > On Tue, Sep 15, 2020 at 03:17:08PM +0100, Will Deacon wrote:
 >> On Tue, Sep 15, 2020 at 04:53:44PM +0300, Ilias Apalodimas wrote:
 >> > On Tue, Sep 15, 2020 at 02:11:03PM +0100, Will Deacon wrote:
 >> > > Hi Ilias,
 >> > > 
 >> > > On Mon, Sep 14, 2020 at 07:03:55PM +0300, Ilias Apalodimas wrote:
 >> > > > Running the eBPF test_verifier leads to random errors looking like this:
 >> > > > 
 >> > > > [ 6525.735488] Unexpected kernel BRK exception at EL1
 >> > > > [ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
 >> > > 
 >> > > Does this happen because we poison the BPF memory with BRK instructions?
 >> > > Maybe we should look at using a special immediate so we can detect this,
 >> > > rather than end up in the ptrace handler.
 >> > 
 >> > As discussed offline this is what aarch64_insn_gen_branch_imm() will return for
 >> > offsets > 128M and yes replacing the handler with a more suitable message would 
 >> > be good.
 >> 
 >> Can you give the diff below a shot, please? Hopefully printing a more useful
 >> message will mean these things get triaged/debugged better in future.

 > [...]

 > The error print is going to be helpful imho. At least it will help
 > people notice something is wrong a lot faster than the previous one.


If you start to amend extables, could you consider a change like

05a68e892e89 ("s390/kernel: expand exception table logic to allow new handling options")

and implementation of BPF_PROBE_MEM then?

 > [ 575.273203] BPF JIT generated an invalid instruction at
 > bpf_prog_64e6f4ba80861823_F+0x2e4/0x9a4!
 > [  575.281996] Unexpected kernel BRK exception at EL1
 > [  575.286786] Internal error: BRK handler: f2000100 [#5] PREEMPT SMP
 > [ 575.292965] Modules linked in: crct10dif_ce drm ip_tables x_tables
 > ipv6 btrfs blake2b_generic libcrc32c xor xor_neon zstd_compress
 > raid6_pq nvme nvme_core realtek
 > [ 575.307516] CPU: 21 PID: 11760 Comm: test_verifier Tainted: G D W
 > 5.9.0-rc3-01410-ged6d9b022813-dirty #1
 > [ 575.318125] Hardware name: Socionext SynQuacer E-series
 > DeveloperBox, BIOS build #1 Jun 6 2020
 > [  575.326825] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
 > [  575.332396] pc : bpf_prog_64e6f4ba80861823_F+0x2e4/0x9a4
 > [  575.337705] lr : bpf_prog_d3e125b76c96daac+0x40/0xdec
 > [  575.342752] sp : ffff8000144e3ba0
 > [  575.346061] x29: ffff8000144e3bd0 x28: 0000000000000000
 > [  575.351371] x27: 00000085f19dc08d x26: 0000000000000000
 > [  575.356681] x25: ffff8000144e3ba0 x24: ffff800011fdf038
 > [  575.361991] x23: ffff8000144e3d20 x22: 0000000000000001
 > [  575.367301] x21: ffff800011fdf000 x20: ffff0009609d4740
 > [  575.372611] x19: 0000000000000000 x18: 0000000000000000
 > [  575.377921] x17: 0000000000000000 x16: 0000000000000000
 > [  575.383231] x15: 0000000000000000 x14: 0000000000000000
 > [  575.388540] x13: 0000000000000000 x12: 0000000000000000
 > [  575.393850] x11: 0000000000000000 x10: ffff8000000bc65c
 > [  575.399160] x9 : 0000000000000000 x8 : ffff8000144e3c58
 > [  575.404469] x7 : 0000000000000000 x6 : 0000000dd7ae967a
 > [  575.409779] x5 : 00ffffffffffffff x4 : 0007fabd6992cf96
 > [  575.415088] x3 : 0000000000000018 x2 : ffff8000000ba214
 > [  575.420398] x1 : 000000000000000a x0 : 0000000000000009
 > [  575.425708] Call trace:
 > [  575.428152]  bpf_prog_64e6f4ba80861823_F+0x2e4/0x9a4
 > [  575.433114]  bpf_prog_d3e125b76c96daac+0x40/0xdec
 > [  575.437822]  bpf_dispatcher_xdp_func+0x10/0x1c
 > [  575.442265]  bpf_test_run+0x80/0x240
 > [  575.445838]  bpf_prog_test_run_xdp+0xe8/0x190
 > [  575.450196]  __do_sys_bpf+0x8e8/0x1b00
 > [  575.453943]  __arm64_sys_bpf+0x24/0x510
 > [  575.457780]  el0_svc_common.constprop.0+0x6c/0x170
 > [  575.462570]  do_el0_svc+0x24/0x90
 > [  575.465883]  el0_sync_handler+0x90/0x19c
 > [  575.469802]  el0_sync+0x158/0x180
 > [  575.473118] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
 > [  575.479211] ---[ end trace 8cd54c7d5c0ffda4 ]---

 > Cheers
 > /Ilias


-- 
WBR,
Yauheni Kaliuta

