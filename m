Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C8F4ECA3C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 19:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbiC3RGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbiC3RGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 13:06:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99249637C;
        Wed, 30 Mar 2022 10:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648659874; x=1680195874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H4jFIKm2Scvn7/jZUOu58X66aPHnkWx8sQ0pdglcvyo=;
  b=H+pRX1Pv9m6jJPOx1sZNwITJh1YV0pZ7ihrJacQp7pSvvqKM1CXzqaUu
   bMibzmhErqPh2fpE5xgpNek3zQZRmGLgP/oGHcRwb9/V9ZE8GNDN/5C/Q
   c3A07yaVGdzrcBqXMZru7AXiRwkx0re6n/nW4vwP5vMdvxkuVMwdqnJHc
   sJr7u4zk8VGSkogrKefBPU7m+cKJOBcUHPzBWfsa09W2o0cNoAgyISzJ3
   tDe7cObQ7tLSQNLk8eRKU5Et4Q3UBCZLARE60kUjVjaofieGqFuI8JPVp
   wZBG5dQW247zD2sVgZSm9vICIzLM2ZaFTGFNOIAPU+8mEkmtwZPOVrfv0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="247095833"
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="247095833"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 10:03:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,223,1643702400"; 
   d="scan'208";a="565651863"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2022 10:03:29 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22UH3REc030366;
        Wed, 30 Mar 2022 18:03:27 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alice Michael <alice.michael@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix logic of getting XSK pool associated with Tx queue
Date:   Wed, 30 Mar 2022 19:00:46 +0200
Message-Id: <20220330170046.3604787-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <MWHPR11MB0062B06CAE27C58EEE54F162E41F9@MWHPR11MB0062.namprd11.prod.outlook.com>
References: <20220329102752.1481125-1-ivecera@redhat.com> <YkL0wfgyCq5s8vdu@boxer> <20220329195522.63d332fb@ceranb> <MWHPR11MB0062B06CAE27C58EEE54F162E41F9@MWHPR11MB0062.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>
Date: Wed, 30 Mar 2022 16:47:18 +0000

> > -----Original Message-----
> > From: Ivan Vecera <ivecera@redhat.com>
> > Sent: Tuesday, March 29, 2022 10:55 AM
> > To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> > Cc: netdev@vger.kernel.org; poros <poros@redhat.com>; mschmidt
> > <mschmidt@redhat.com>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> > Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> > <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> > Fastabend <john.fastabend@gmail.com>; Andrii Nakryiko
> > <andrii@kernel.org>; Martin KaFai Lau <kafai@fb.com>; Song Liu
> > <songliubraving@fb.com>; Yonghong Song <yhs@fb.com>; KP Singh
> > <kpsingh@kernel.org>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>; Krzysztof
> > Kazimierczak <krzysztof.kazimierczak@intel.com>; Lobakin, Alexandr
> > <alexandr.lobakin@intel.com>; moderated list:INTEL ETHERNET DRIVERS
> > <intel-wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>;
> > open list:XDP (eXpress Data Path) <bpf@vger.kernel.org>
> > Subject: Re: [PATCH net] ice: Fix logic of getting XSK pool associated with Tx
> > queue
> > 
> > On Tue, 29 Mar 2022 14:00:01 +0200
> > Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> > 
> > > Thanks for this fix! I did exactly the same patch yesterday and it's
> > > already applied to bpf tree:
> > >
> > > https://lore.kernel.org/bpf/20220328142123.170157-5-maciej.fijalkowski
> > > @intel.com/T/#u
> > >
> > > Maciej
> > 
> > Thanks for info... Nice human race condition ;-)
> > 
> > I.
> 
> I'm covering for Tony this week maintaining this tree.  He let me know there were a few patches you had to send Ivan and I was waiting on this one.  If I'm following correctly, this one will be dropped and the other ones are ready to be sent now to net then?

Yes, this one is beaten and the net tree already contains it[0].
There are still 3 Ivan's fixes not applied yet:
 * [1]
 * [2]
 * [3]

I'm wondering if it's worth to pass them through dev-queue since
they're urgent and have been tested already in 2 companies? They
could go directly to -net and make it into RC1.

> 
> Alice.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=1ac2524de7b366633fc336db6c94062768d0ab03
[1] https://lore.kernel.org/netdev/20220322142554.3253428-1-ivecera@redhat.com
[2] https://lore.kernel.org/netdev/20220325132524.1765342-1-ivecera@redhat.com
[3] https://lore.kernel.org/netdev/20220325132819.1767050-1-ivecera@redhat.com

Thanks,
Al
