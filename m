Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D892645E4E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfFNNey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:34:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21676 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbfFNNey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:34:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54C3F3092652;
        Fri, 14 Jun 2019 13:34:54 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 121261948B;
        Fri, 14 Jun 2019 13:34:52 +0000 (UTC)
Date:   Fri, 14 Jun 2019 08:34:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 7/9] x86/unwind/orc: Fall back to using frame pointers
 for generated code
Message-ID: <20190614133004.gopjz64vbqmbbzqn@treble>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <4f536ec4facda97406273a22a4c2677f7cb22148.1560431531.git.jpoimboe@redhat.com>
 <20190613220054.tmonrgfdeie2kl74@ast-mbp.dhcp.thefacebook.com>
 <20190614013051.6gnwduy4dsygbamj@treble>
 <20190614014244.st7fbr6areazmyrb@ast-mbp.dhcp.thefacebook.com>
 <20190614015848.todgfogryjn573nd@treble>
 <20190614022848.ly4vlgsz6fa4bcbl@treble>
 <20190614045037.zinbi2sivthcfrtg@treble>
 <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614060006.na6nfl6shawsyj3i@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 14 Jun 2019 13:34:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 11:00:09PM -0700, Alexei Starovoitov wrote:
> > +	if (src_reg == BPF_REG_FP) {
> > +		/*
> > +		 * If the value was copied from RBP (real frame pointer),
> > +		 * adjust it to the BPF program's frame pointer value.
> > +		 *
> > +		 * add dst, -40
> > +		 */
> > +		EMIT4(add_1mod(0x48, dst_reg), 0x83, add_1reg(0xC0, dst_reg),
> > +		      0xD8);
> > +	}
> > +
> 
> That won't work. Any register can point to a stack.

Right, but if the stack pointer comes from BPF_REG_FP then won't the
above correct it?  Then if the pointer gets passed around to other
registers it will have the correct value.  Or did I miss your point?

> The register can point to a stack of a different JITed function as well.

Do you mean tail calls?  Or something else?  For tail calls the stack is
shared and the stack layout is the same.

-- 
Josh
