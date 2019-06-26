Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7535715A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfFZTKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:10:23 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39806 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZTKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:10:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so1645682pgc.6
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 12:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9QvUwGfKb8OtcEpn5hvV3pA3mUaZfbQ/L43RhgmAVAc=;
        b=qeS4Tqr4Z/CGi1sixvNeBFJLqJjX+1u7OVmO3MM66SdYdFbBvsMxn+pnLYPS79kosD
         c3iMInV12ZD/vpeDYHMNsD0lmatKyNA6QbSggKWFTcFYXF7fYTwtVUnezlWvx57QEZZA
         QWvRKTCkRWb3I+yPEpWQTGmgyrIJs0ic5gd9aXyv5IA32c0bh0UnhZX9rDxOskBkEI/P
         gslQ/LqwuW7A6uyGKbBXThfclgJThM5xyBKVUn/uxLi2bY8zBrY5Zpww2/UYZZaUu8+B
         mm9aRhPnBSZvaKb44qvhukAHyitT0mf51VvUSQw8V9Mv24pvxxmQp2Tk0c5iNA7V9tTc
         PecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9QvUwGfKb8OtcEpn5hvV3pA3mUaZfbQ/L43RhgmAVAc=;
        b=i3mbHUNjqMFUf5Sp+AQRA8jZZ+j3RY4LPDhuonI3qkjYz2DRPQ0WCXixEtjSzJFanF
         3j/goz9rbQtFbdgNqLwVaPuggGvPfhLtv6gPAa222GncKhC0Hckh+TyyT/jEUxyFOO+9
         Kh+BBUH+cdPsgqcTtMAy8UHSBtneoEFAxCm/Ob0pyM2Y6ASWOZA+gyysggz5LzIlting
         oABQKSdTWhZkusO+X38X0Ys8chE7PjFkfP+cw4mGLaFgo2nnnAwW/BVBUnQO/t6m4ZJo
         UaFP8VzaQhO5wz7PIg/g3/Fp22kOz7E1JN23Mu4fk4c5zqnfO2WCtfJLE/tdl+qK7i+B
         /s8A==
X-Gm-Message-State: APjAAAX2eE1GLWlW/JNUdHDof/Y3JHNG2iBjPEyDUekNoHoDpYabOC+/
        0HytSXIPJJJP/BJXhnWeTu5SnQ==
X-Google-Smtp-Source: APXvYqwYOZwUiifbBowIvAj2cfD9jMkj1QD2CzR/+lqedhhFRIDPKwi0r4u5jBTCXc2GD1aZKIyWqQ==
X-Received: by 2002:a65:5888:: with SMTP id d8mr4399857pgu.124.1561576222792;
        Wed, 26 Jun 2019 12:10:22 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id o2sm15402469pgp.74.2019.06.26.12.10.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 12:10:22 -0700 (PDT)
Date:   Wed, 26 Jun 2019 12:10:21 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v8 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190626191021.GB4866@mini-arch>
References: <20190624162429.16367-1-sdf@google.com>
 <20190624162429.16367-2-sdf@google.com>
 <20190626185420.wzsb7v6rawn4wtzd@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185420.wzsb7v6rawn4wtzd@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/26, Alexei Starovoitov wrote:
> On Mon, Jun 24, 2019 at 09:24:21AM -0700, Stanislav Fomichev wrote:
> > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > 
> > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> 
> getsockopt side looks good to me.
> I tried to convince myself that readonly setsockopt is fine for now,
> but it feels we need to make it writeable from the start.
> I agree with your reasoning that doing copy_to_user is no good,
> but we can do certainly do set_fs(KERNEL_DS) game.
> The same way as kernel_setsockopt() is doing.
> It seems quite useful to modify 'optval' before passing it to kernel.
> Then bpf prog would be able to specify sane values for SO_SNDBUF
> instead of rejecting them.
> The alternative would be to allow bpf prog to call setsockopt
> from inside, but sock is locked when prog is running,
> so unlocking within helper is not going to be clean.
> wdyt?
Sure, I can take a look if you think that it would be useful in general.
Looks like set_fs should do the trick.

(I was thinking about exporting something like the existing bpf_setsockopt
to a setsockopt hooks, but I agree, it comes with its own bag
of problems).
