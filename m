Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C8C2B53C2
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgKPVYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgKPVYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 16:24:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B8220A8B;
        Mon, 16 Nov 2020 21:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605561857;
        bh=3VnnvbQxkgfASwo/IG6GbeA05RjPoW7wuXX55oj4FDU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gag1Zu/ORHuCHgWwv+NvGvtK9SMbAuDQuCCkYwWURW/O5fvAraeWSGljpFBivRDFq
         m4oZBpreeRID81fgbwaJBLu2ijOpHjy58kcBNol1jlmGu3H4+SzSuomMr3bB/PJFNO
         1oGbBVN9LWBk0HKekCNMlBufYcH54yO6hh5RgBz4=
Date:   Mon, 16 Nov 2020 13:24:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Starovoitov, Alexei" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
Message-ID: <20201116132409.4a5b8e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEf4BzYSN+XnaA4V3jTLEmoUZO=Yxwp7OAwAY+HOvVEKT5kRFA@mail.gmail.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
        <20201110011932.3201430-4-andrii@kernel.org>
        <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com>
        <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
        <CAEf4BzYSN+XnaA4V3jTLEmoUZO=Yxwp7OAwAY+HOvVEKT5kRFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 12:34:17 -0800 Andrii Nakryiko wrote:
> > This change, commit 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole
> > supports it") currently in net-next, linux-next, etc. breaks the use-case of compiling only a specific
> > kernel module (both in-tree and out-of-tree, e.g. 'make M=drivers/net/ethernet/intel/ice') after
> > first doing a 'make modules_prepare'.  Previously, that use-case would result in a warning noting
> > "Symbol info of vmlinux is missing. Unresolved symbol check will be entirely skipped" but now it
> > errors out after noting "No rule to make target 'vmlinux', needed by '<...>.ko'.  Stop."
> >
> > Is that intentional?  
> 
> I wasn't aware of such a use pattern, so definitely not intentional.
> But vmlinux is absolutely necessary to generate the module BTF. So I'm
> wondering what's the proper fix here? Leave it as is (that error
> message is actually surprisingly descriptive, btw)? Force vmlinux
> build? Or skip BTF generation for that module?

For an external out-of-tree module there is no guarantee that vmlinux
will even be on the system, no? So only the last option can work in
that case.
