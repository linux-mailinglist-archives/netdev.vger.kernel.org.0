Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289B75602AF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiF2O20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiF2O2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:28:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CF2EE31;
        Wed, 29 Jun 2022 07:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656512902; x=1688048902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dbj3+S/9miE8Pcqc+T5v7JFxc6IEMNZmGc4ZgWOS75I=;
  b=YOdQdhRzgqsNnHhi9gugPhS24X7b2GRQD6WIenDnDWy4FsfFJzz8fjqD
   v18/NyCXOtfmUsWZzTbHz3kPv+bhpQ7rXirjHgM5wRswgOd6nALF1ghfK
   5XE5S3anWhhfkxLwTByAdndQnxUtj5xUD8LvJTYVQVUlFok4W7kMe2zl3
   aP0PIb3n0TTY5a/fOSqfGGL/nA0+/2/C84JLxzRICvRCp8aczrMMG/cHr
   lJyfO5DwQhFKL54Tj/Jx1UvebWoqKOoJh0aHvXGVygu9FD3jxDnmEhn7x
   +AHI/wBpuudHXbQ1AK1E+L6PlTSB9TxiBV+wEH1xaS7WoHIlN6ZK00jcF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="265080784"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="265080784"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:28:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="647414082"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2022 07:28:20 -0700
Date:   Wed, 29 Jun 2022 16:28:19 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
Message-ID: <Yrxhg2R6rk1PKe4E@boxer>
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
 <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com>
 <CAJ+HfNgBXTWLWOthG1mOmy8ZZyzLAggpZLq9qOzbdzRxxmK77Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNgBXTWLWOthG1mOmy8ZZyzLAggpZLq9qOzbdzRxxmK77Q@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 03:39:57PM +0200, Björn Töpel wrote:
> On Wed, 29 Jun 2022 at 14:45, Björn Töpel <bjorn.topel@gmail.com> wrote:
> >
> > TL;DR, I think it's a good addition. One small nit below:
> >
> 
> I forgot one thing. Setting napi_id should be gated by
> "CONFIG_NET_RX_BUSY_POLL" ifdefs.

napi id marking functions are wrapped inside with this ifdef
