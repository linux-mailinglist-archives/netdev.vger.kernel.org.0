Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53ED96AC92
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfGPQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:17:06 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:37548 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGPQRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:17:06 -0400
Received: by mail-pl1-f176.google.com with SMTP id b3so10366049plr.4;
        Tue, 16 Jul 2019 09:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=471pmIh3LX9u0h9TelKOd0JUS/NmfxeCjVSYlSHX1vA=;
        b=BHX96+CtyC/9UyJM8geZzQCl7YMjdyWxXBFUNJ3ogMqlbkTBDOFiTBPxve9ANcOPjM
         RTj3pZiOzdzp9Fk8e6EyKYcalLqfw6d2XY2JIzRhxCc4zLLewI8JiDvCCdBGTyiWSVoo
         PTv+EI518GZW01V4SNUikUs6E6rLPuB3m9VEOsXOJW4U+5GwJmW7fZlMC3mTs/5Xq4Xo
         kwS+McI9N1Md40nhqGAJPoXGrDMXbDqT6j08NBZycgDC399ih7+PxhI7cH3lGDsoy3tV
         HJiiR+uEdzFpFQLQMKKLAz541QIqrfP0lCjPXmdXTzSV5h2Qv4/j/jqhCL4iQaUJV8od
         mN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=471pmIh3LX9u0h9TelKOd0JUS/NmfxeCjVSYlSHX1vA=;
        b=VB7db/eINkCQFBhPpyyzLEE/8TP6srpnUGCnyhv3IgqfaTzZId/aeIP9ND7xcSf+Zn
         I1JuHwnwsbjEcD1V7dCGTg+HDJqRN5FiIxZmW/8ZbVMgIhKVUPUxW5MDarBGjT83JzjR
         Y1lPWG/QzbF7s7f3dacSfVozGeZxaY0SOvsGvg/XiL0D+yGI4SHVNovx5IKce1o34Jvl
         mujUjr0Q0b2dTAx1wcuBpV1Nm/IO6ABEWwtPtfp6zQNiWhAxCqiickgCVhEqqYSi+x5K
         /1VyvHqRZr41VbMIbyaXgoLXMgndx4/uWAvCd3dk4Hwjl6ecZwExODXGOJmxBCPlR/OV
         QSkg==
X-Gm-Message-State: APjAAAUg1t3g0gwmb3DKi10vh8UFIqnoIZHiVpz9C+oKfnmShm4VGZdG
        rTu/7iu/vyqNkN33BoLu3AU=
X-Google-Smtp-Source: APXvYqwN+pc0Y9LsKyVNpNsE27R6cpG/jC7EJi86D4SSuxhw4CiTszbvDUbJ5/XWBhFv7A+TqT17gQ==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr34374635pll.298.1563293825493;
        Tue, 16 Jul 2019 09:17:05 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::c7d4])
        by smtp.gmail.com with ESMTPSA id j12sm10852106pff.4.2019.07.16.09.17.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 09:17:04 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:17:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Edward Cree <ecree@solarflare.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Yonghong Song <yhs@fb.com>
Subject: Re: [RFC bpf-next 0/8] bpf: accelerate insn patching speed
Message-ID: <20190716161701.mk5ye47aj2slkdjp@ast-mbp.dhcp.thefacebook.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
 <CAEf4BzavePpW-C+zORN1kwSUJAWuJ3LxZ6QGxqaE9msxCq8ZLA@mail.gmail.com>
 <87r26w24v4.fsf@netronome.com>
 <CAEf4BzaPFbYKUQzu7VoRd7idrqPDMEFF=UEmT2pGf+Lxz06+sA@mail.gmail.com>
 <87k1cj3b69.fsf@netronome.com>
 <CAEf4BzYDAVUgajz4=dRTu5xQDddp5pi2s=T1BdFmRLZjOwGypQ@mail.gmail.com>
 <87wogitlbi.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wogitlbi.fsf@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 09:50:25AM +0100, Jiong Wang wrote:
> 
> Let me digest a little bit and do some coding, then I will come back. Some
> issues can only shown up during in-depth coding. I kind of feel handling
> aux reference in verifier layer is the part that will still introduce some
> un-clean code.

I'm still internalizing this discussion. Only want to point out
that I think it's better to have simpler algorithm that consumes more
memory and slower than more complex algorithm that is more cpu/memory efficient.
Here we're aiming at 10x improvement anyway, so extra cpu and memory
here and there are good trade-off to make.

> >> If there is no dead insn elimination opt, then we could just adjust
> >> offsets. When there is insn deleting, I feel the logic becomes more
> >> complex. One subprog could be completely deleted or partially deleted, so
> >> I feel just recalculate the whole subprog info as a side-product is
> >> much simpler.
> >
> > What's the situation where entirety of subprog can be deleted?
> 
> Suppose you have conditional jmp_imm, true path calls one subprog, false
> path calls the other. If insn walker later found it is also true, then the
> subprog at false path won't be marked as "seen", so it is entirely deleted.
> 
> I actually thought it is in theory one subprog could be deleted entirely,
> so if we support insn deletion inside verifier, then range info like
> line_info/subprog_info needs to consider one range is deleted.

I don't think dead code elim can remove subprogs.
cfg check rejects code with dead progs.
I don't think we have a test for such 'dead prog only due to verifier walk'
situation. I wonder what happens :)

