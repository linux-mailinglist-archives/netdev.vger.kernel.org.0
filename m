Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60361FAF9
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiKGRP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiKGRP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:15:57 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466D220BC6;
        Mon,  7 Nov 2022 09:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667841356; x=1699377356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N1bnCz4fk3zMX9lzTCpsSxKGgJYz7Wz+oYj3aAcVq6I=;
  b=M8zJiIevJBoIWRdXlqL7+Wnc43deBHi+Jayqwj1mAK2JCamHVdHYE7nd
   6snzMMI84L3rtQ7Kyq4fJ4e6hm1fzvjNeSYuoAjrUaL70SbPKfVyyWRm7
   gUC014I9UGyiSKrnsyfPhBB1FApMUgKrXQ4k9ZoiHynYzxg/JSsnkb8FL
   HFn9NDrjnZLwFfFUoHqoTbzNRFAeBU0sg8RCPof0/Bx3NqKsIvM/HRgIa
   r1seZozBwNZu7vgXA97/xRkDnnORNTeBfvFEjsXcLL4y6qlNvq/lQzZzg
   pCDT2SKI6o6uGfulDIdo3KSlqgrOcuaUIoxqjkwhvWHN5tlODUD+3bC7i
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="337190057"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="337190057"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 09:14:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="761167231"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="761167231"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 07 Nov 2022 09:14:45 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2A7HEhNj031969;
        Mon, 7 Nov 2022 17:14:43 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [RFC bpf-next v2 10/14] ice: Support rx timestamp metadata for xdp
Date:   Mon,  7 Nov 2022 18:11:30 +0100
Message-Id: <20221107171130.559191-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <CAKH8qBuaJ1usZEirN9=ReugusS8t_=Mn0LoFdy93iOYpHs2+Yg@mail.gmail.com>
References: <20221104032532.1615099-1-sdf@google.com> <20221104032532.1615099-11-sdf@google.com> <20221104143547.3575615-1-alexandr.lobakin@intel.com> <CAKH8qBuaJ1usZEirN9=ReugusS8t_=Mn0LoFdy93iOYpHs2+Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>
Date: Fri, 4 Nov 2022 11:21:47 -0700

> On Fri, Nov 4, 2022 at 7:38 AM Alexander Lobakin
> <alexandr.lobakin@intel.com> wrote:
> >
> > From: Stanislav Fomichev <sdf@google.com>
> > Date: Thu,3 Nov 2022 20:25:28 -0700

[...]

> > Hey,
> >
> > FYI, our team wants to write a follow-up patch with ice support
> > added, not like a draft, more of a mature code. I'm thinking of
> > calling ice C function which would process Rx descriptors from
> > that BPF code from the unrolling callback -- otherwise,
> > implementing a couple hundred C code lines from ice_txrx_lib.c
> > would be a bit too much :D
> 
> Sounds good! I would gladly drop all/most of the driver changes for
> the non-rfc posting :-)
> I'll probably have a mlx4 one because there is a chance I might find
> HW, but the rest I'll drop most likely.
> (they are here to show how the driver changes might look like, hence
> compile-tested only)
> 
> Btw, does it make sense to have some small xsk selftest binary that
> can be used to test the metadata with the real device?
> The one I'm having right now depends on veth/namespaces; having a
> similar one for the real hardware to qualify it sounds useful?
> Something simple that sets up af_xdp for all queues, divers some
> traffic, and exposes to the userspace consumer all the info about
> frame metadata...
> Or maybe there is something I can reuse already?

There's XSk selftest already and recently Maciej added support for
executing it on a physical device (via `-i <iface>` cmdline arg)[0].
I guess the most optimal solution is to expand it to cover metadata
cases as it has some sort of useful helper functions / infra? In the
set I posted in June, I simply expanded xdp_meta selftest, but there
weren't any XSk bits, so I don't think it's a way to go.

> 
> 
> > > +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > +             /* return true; */
> > > +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
> > > +     } else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> >
> > [...]
> >
> > > --
> > > 2.38.1.431.g37b22c650d-goog
> >
> > Thanks,
> > Olek

[0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=a693ff3ed5610a07b1b0dd831d10f516e13cf6c6

Thank,
Olek
