Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1264A46F235
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbhLIRmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:42:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:18787 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231476AbhLIRmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:42:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639071521; x=1670607521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GW8eLCzIYcPKkn65ZA+HWRTXMBZawug5TiMgnaXmBGc=;
  b=jAbGeipF++vxB9r086USfv4fAzR9wUd7y5dhRn4aelBdtNgTJyU0yY0X
   /4EV9+wed2oO1wzcIreu0F68zxyepnS6YxMNloO/C41/wHCSFOR0EnJsR
   3euv4LdeTqrfZHX3ZZ6pibkOLSpED0THWwYKGu9w0E8Fu+gH4iFvQsIdy
   Vlh0KQAGkVXg4YArMmrHxP33rgO2G/+a/uJWlDf2hlOfKkeZcZM57DOIl
   qx4Ev+TgxT1WQsqOoJUOPFsloB69eKaquXDr2G8BLpI6VR4ejItVx1lYM
   wVUuBaz77ULye4aea7j2f/92/kJCvb7gyKoDoNs1ectAzCTwIEKZgbOfM
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="238388305"
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="238388305"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 09:38:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,193,1635231600"; 
   d="scan'208";a="503581282"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 09 Dec 2021 09:38:35 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B9HcXEn013933;
        Thu, 9 Dec 2021 17:38:33 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org, brouer@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v4 net-next 2/9] i40e: respect metadata on XSK Rx to skb
Date:   Thu,  9 Dec 2021 18:38:16 +0100
Message-Id: <20211209173816.5157-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <2811b35a-9179-88ce-d87a-e1f824851494@redhat.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com> <20211208140702.642741-3-alexandr.lobakin@intel.com> <2811b35a-9179-88ce-d87a-e1f824851494@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 9 Dec 2021 09:27:37 +0100

> On 08/12/2021 15.06, Alexander Lobakin wrote:
> > For now, if the XDP prog returns XDP_PASS on XSK, the metadata will
> > be lost as it doesn't get copied to the skb.
> 
> I have an urge to add a newline here, when reading this, as IMHO it is a 
> paragraph with the problem statement.
> 
> > Copy it along with the frame headers. Account its size on skb
> > allocation, and when copying just treat it as a part of the frame
> > and do a pull after to "move" it to the "reserved" zone.
> 
> Also newline here, as next paragraph are some extra details, you felt a 
> need to explain to the reader.
> 
> > net_prefetch() xdp->data_meta and align the copy size to speed-up
> > memcpy() a little and better match i40e_costruct_skb().
>                                       ^^^^^^xx^^^^^^^^^
> 
> You have a general misspelling of this function name in all of your 
> commit messages.

Oh gosh, I thought I don't have attention deficit. Thanks, maybe
Tony will fix it for me or I could send a follow-up (or resend if
needed, I saw those were already applied to dev-queue).

> 
> --Jesper

Al
