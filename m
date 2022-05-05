Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5836651C1E4
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380408AbiEEOJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379404AbiEEOJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:09:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA982CE0D;
        Thu,  5 May 2022 07:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651759568; x=1683295568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h+QOZAobM0lRBZYbKWlwOpQ6isKFqzqT/SdzJuZTeck=;
  b=LQvHbM7IPVgU7pTjVLaMv0oum2m8tqTnX7f07g3AWBtUh6ju/j64hTuA
   QOCl4Ihlckj/Ht0rcr5IaSY+MMrPUZz19ZQCzXVw/z7SB7DyuaKrHWvtQ
   /8XWgrZEOm+bMTiyWjDSePgWaruQYJgxu0CivfU6LgEEQBjrURX2K4IyK
   6yODI12XZyu8eLnndz0cjRqMVvb2y3PILIOmtX4f8BUZsvAVcLy9k/Mao
   E4P8uBh5EVbANnz4fmGVm2vht/aH1Ud52HP3vGrhFHV6v0ICxvXkx1xuQ
   cETLgn59cGW9ltzgeHgIkJnFsdim7s7dmJNoE/4EeoNZuSbcsh9Zmb9vz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="293318140"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="293318140"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 07:05:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="891340211"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 05 May 2022 07:05:39 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 245E5cMV022368;
        Thu, 5 May 2022 15:05:38 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     andrii.nakryiko@gmail.com
Cc:     alexandr.lobakin@intel.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, kafai@fb.com,
        larysa.zaremba@intel.com, linux-kernel@vger.kernel.org,
        maciej.fijalkowski@intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH] bpftool: Use sysfs vmlinux when dumping BTF by ID
Date:   Thu,  5 May 2022 15:56:26 +0200
Message-Id: <20220505135626.137133-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAEf4BzZRioYpgsUFP1TLsqtjtvA3WLyuWjSyq12ctUoMqkUorg@mail.gmail.com>
References: <CAEf4BzZRioYpgsUFP1TLsqtjtvA3WLyuWjSyq12ctUoMqkUorg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 21:58:58 -0700 Andrii Nakryiko <andrii@kernel.org> wrote:
> On Thu, Apr 28, 2022 at 4:17 AM Larysa Zaremba <larysa.zaremba@intel.com> wrote:
> >
> > Currently, dumping almost all BTFs specified by id requires
>
> It should and will work only for kernel modules. It won't and
> shouldn't work for BTFs coming from BPF programs. We shouldn't blindly
> guess and substitute vmlinux BTF as base BTF, let's fetch
> bpf_btf_info, check that BTF is from kernel and is not vmlinux, and
> only in such case substitute vmlinux BTF as base BTF.

I agree, this is taken into account in v2

> > using the -B option to pass the base BTF. For most cases
> > the vmlinux BTF sysfs path should work.
> >
> > This patch simplifies dumping by ID usage by attempting to
> > use vmlinux BTF from sysfs, if the first try of loading BTF by ID
> > fails with certain conditions.
> >
> > Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> > Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > ---
> >  tools/bpf/bpftool/btf.c | 35 ++++++++++++++++++++++++++---------
> >  1 file changed, 26 insertions(+), 9 deletions(-)
> >

Best Regards,
Larysa Zaremba
