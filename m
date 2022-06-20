Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E118551653
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbiFTKzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239937AbiFTKzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:55:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5493212A9D;
        Mon, 20 Jun 2022 03:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655722541; x=1687258541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nglppZhuvUQT7nOX+N/aR3xpXIaRhCEPCSAdUmEvcVQ=;
  b=OqpEOGGLadO1AiwPEfujjSQYiD49fPoQKTBc4eiiOU5Gp+2Xg0G77Yef
   ndUbzC4vZZx8VDu9Tcx9gI8cNNWS3EXPk7aHFXYSisvD/wxdooyHggUui
   3ix9lMAQHAlWHuHGBtihOaXIbj0ZariP/Zxu9NZbnjmmKZzgS8sgeWXuy
   ygJSOPWoMuI4KIMOKX485QlzYQvn9Z9QUg5gAyubMr6RrGAHwvuN60GwF
   a6aM0jrIhPm5IgBJ4Qjrg1qSBZQ2fWVfXcrplemPAC1mEXHE4rAOpgMls
   LCsSwXoA4hU4mKZlk5nNa00Fw+QKEM4wtfZgA1UcNwacIi8JnTm2wdKB7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280920749"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280920749"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 03:55:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="913609049"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jun 2022 03:55:38 -0700
Date:   Mon, 20 Jun 2022 12:55:37 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org
Subject: Re: [PATCH v4 bpf-next 05/10] selftests: xsk: query for native XDP
 support
Message-ID: <YrBSKTsQjShydeAw@boxer>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-6-maciej.fijalkowski@intel.com>
 <62ad3470573f9_24b342082e@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ad3470573f9_24b342082e@john.notmuch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 07:12:00PM -0700, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > Currently, xdpxceiver assumes that underlying device supports XDP in
> > native mode - it is fine by now since tests can run only on a veth pair.
> > Future commit is going to allow running test suite against physical
> > devices, so let us query the device if it is capable of running XDP
> > programs in native mode. This way xdpxceiver will not try to run
> > TEST_MODE_DRV if device being tested is not supporting it.
> > 
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  tools/testing/selftests/bpf/xdpxceiver.c | 36 ++++++++++++++++++++++--
> >  1 file changed, 34 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index e5992a6b5e09..a1e410f6a5d8 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -98,6 +98,8 @@
> >  #include <unistd.h>
> >  #include <stdatomic.h>
> >  #include <bpf/xsk.h>
> > +#include <bpf/bpf.h>
> > +#include <linux/filter.h>
> >  #include "xdpxceiver.h"
> >  #include "../kselftest.h"
> >  
> > @@ -1605,10 +1607,37 @@ static void ifobject_delete(struct ifobject *ifobj)
> >  	free(ifobj);
> >  }
> >  
> > +static bool is_xdp_supported(struct ifobject *ifobject)
> > +{
> > +	int flags = XDP_FLAGS_DRV_MODE;
> > +
> > +	LIBBPF_OPTS(bpf_link_create_opts, opts, .flags = flags);
> > +	struct bpf_insn insns[2] = {
> > +		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
> > +		BPF_EXIT_INSN()
> > +	};
> > +	int ifindex = if_nametoindex(ifobject->ifname);
> > +	int prog_fd, insn_cnt = ARRAY_SIZE(insns);
> > +	int err;
> > +
> > +	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
> > +	if (prog_fd < 0)
> > +		return false;
> > +
> > +	err = bpf_xdp_attach(ifindex, prog_fd, flags, NULL);
> > +	if (err)
> 
> Best not to leave around prog_fd in the error case or in the
> good case.
> 
> > +		return false;
> > +
> > +	bpf_xdp_detach(ifindex, flags, NULL);
> > +
> 
> close(prog_fd)

Will fix

> 
> > +	return true;
> > +}
> > +
