Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32470613910
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiJaOfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiJaOfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:35:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D8E133;
        Mon, 31 Oct 2022 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667226913; x=1698762913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1/9s7CWhJVq2t2k0cmR+pgj89lz/7OULjiOZcjFEIbk=;
  b=XMKHl6NqDaJQNOLiDh8pFWhTyNyg025orljAuwadMmosYbKJW9nQVBM3
   86WGP7b/B0fpit+M7VcYDvgMCbYE7/plWymIhR6ZTGJswErAxNvp12nle
   hKWueEq3Bn8ddo9b6A15e1Kf8WTeN6EoCfBsXjk+bihslZGz+vmaTJ65f
   e+ElwKFG5Czvs5AmoYFMwOCfa+3abDtcnTaoyvmnTnUp0G6gxQp+NzNyU
   LKlCvem2FUDO3N2yiman2+xiHX/+wCAfUDp004530/hgQ6Zu7M3mlsTJC
   o4eINXpeoaXGdzO95R9t0zTnpVyqIruEkRkoRg8WBv/xLfZjhxcRA/vfK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="309997625"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="309997625"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 07:31:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="664796605"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="664796605"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 31 Oct 2022 07:30:59 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29VEUwgI001967;
        Mon, 31 Oct 2022 14:30:58 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>, brouer@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC bpf-next 5/5] selftests/bpf: Test rx_timestamp metadata in xskxceiver
Date:   Mon, 31 Oct 2022 15:29:07 +0100
Message-Id: <20221031142907.164469-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031142032.164247-1-alexandr.lobakin@intel.com>
References: <20221027200019.4106375-1-sdf@google.com> <20221027200019.4106375-6-sdf@google.com> <31f3aa18-d368-9738-8bb5-857cd5f2c5bf@linux.dev> <1885bc0c-1929-53ba-b6f8-ace2393a14df@redhat.com> <CAKH8qBt3hNUO0H_C7wYiwBEObGEFPXJCCLfkA=GuGC1CSpn55A@mail.gmail.com> <20221031142032.164247-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Mon, 31 Oct 2022 15:20:32 +0100

> From: Stanislav Fomichev <sdf@google.com>
> Date: Fri, 28 Oct 2022 11:46:14 -0700
> 
> > On Fri, Oct 28, 2022 at 3:37 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:

[...]

> > I don't think __xdp_build_skb_from_frame is automagically solved by
> > either proposal?
> 
> It's solved in my approach[0], so that __xdp_build_skb_from_frame()

Yeah sure forget to paste the link, why doncha?

[0] https://github.com/alobakin/linux/commit/a43a9d6895fa11f182becf3a7c202eeceb45a16a

> are automatically get skb fields populated with the metadata if
> available. But I always use a fixed generic structure, which can't
> compete with your series in terms of flexibility (but solves stuff
> like inter-vendor redirects and so on).

[...]

> Thanks,
> Olek

Thanks,
Olek
