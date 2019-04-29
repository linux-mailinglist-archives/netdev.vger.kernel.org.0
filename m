Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABF1E0B8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfD2Kns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:43:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39986 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727774AbfD2Kns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 06:43:48 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 32DD0B40056;
        Mon, 29 Apr 2019 10:43:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 03:43:42 -0700
Subject: Re: 32-bit zext time complexity (Was Re: [PATCH bpf-next]
 selftests/bpf: two scale tests)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Jiong Wang <jiong.wang@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
References: <20190412214132.2726285-1-ast@kernel.org>
 <lyimv3hujp.fsf@netronome.com>
 <20190425043347.pxrz5ln4m7khebt6@ast-mbp.dhcp.thefacebook.com>
 <lylfzyeebr.fsf@netronome.com>
 <20190425221021.ov2jj4piann7wmid@ast-mbp.dhcp.thefacebook.com>
 <lyk1fgrk4m.fsf@netronome.com>
 <6757534d-4d0d-6698-7536-118fed7be977@solarflare.com>
 <20190427031122.dgnt4y4v6rnbawq2@ast-mbp>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <2a6aba4c-e5df-20ec-8742-dffe0c645201@solarflare.com>
Date:   Mon, 29 Apr 2019 11:43:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190427031122.dgnt4y4v6rnbawq2@ast-mbp>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-5.072300-4.000000-10
X-TMASE-MatchedRID: twkXAvRFVBlJJDuM6qazTm9m40jFd8wv7yWPaQc4INSCsBeCv8CM/crE
        t0HAZpVUrgMlijRLL39OpyDH40bTVO/1b0g+BX56de4BwMgBa9M0AKed0u9fB2HZ+cd7VyKXMrS
        9FFYHpDXstNXLbn6uraPXlikKpo5mhi8uFzr7cfuRfvUfL+585lt06oMfzUpKuu0N7j6PSiP+yk
        IGQmXQki9rdJU8q29pJeTU/VzQAYJFsw2Lp+kSuINoF/xJo8tUfrTt+hmA5bIhvFjBsLEZNLCx9
        OEvXmLWdgpFqmK1AE9ftuJwrFEhTY2j49Ftap9Eymsk/wUE4hoocMW4yq6ZUBlfGgeYTxmsv+vp
        FF3B9SZ+iEe5Vz8gG84HmKiqQEgtwL6SxPpr1/I=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.072300-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556534627-R8SZ_r2k7aKU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2019 04:11, Alexei Starovoitov wrote:
> instead of converting all insns into lists of 1 before all patching
> it can be done on demand:
> convert from insn to list only when patching is needed.
Makes sense.
> Patched insn becomes a pointer to a block of new insns.
> We have reserved opcodes to recognize such situation.
It's not clear to me where you can fit everything though.  The pointer
 is 64 bits, which is the same as struct bpf_insn.  Are you suggesting
 relying on kernel pointers always starting 0xff?
> The question is how to linearise it once at the end?
Walk the old prog once to calculate out_insn_idx for each in_insn
 (since we will only ever be jumping to the first insn of a list (or
 to a non-list insn), that's all we need), as well as out_len.
Allocate enough pages for out_len (let's not try to do any of this
 in-place, that would be painful), then walk the old prog to copy it
 insn-by-insn into the new one, recalculating any jump offsets by
 looking up the dest insn's out_insn_idx and subtracting our own
 out_insn_idx (plus an offset if we're not the first insn in the list
 of course).  While we're at it we can also fix up e.g.
 linfo[].insn_off: if in_insn_idx matches linfo[li_idx].insn_off,
 then set linfo[li_idx++].insn_off = out_insn_idx.  If we still need
 aux_data at this point we can copy that across too.
Runtime O(out_len), and gets rid of all the adjusts on
 patch_insn_single — branches, linfo, subprog_starts, aux_data.
Have I missed anything?  If I have time I'll put together an RFC
 patch in the next few days.

-Ed
