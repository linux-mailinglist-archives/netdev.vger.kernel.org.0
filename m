Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B8046FF7E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbhLJLNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:13:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:26585 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235145AbhLJLNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 06:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639134570; x=1670670570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FS4PnEFqktsl74QFl1oKDjvNGiKlWxYmMopnz/XDZoM=;
  b=N83DaSWX+6TS0WWrbwaCUN73j+kKsVslDx6HIvqE1XDIEIxTMk0XQ/O1
   EYABI4WpYPfSaVbo3u9CSBU1/tTqI9LeQXuPVpf8WcP+kDjwh9btjf6N9
   vzNzv3b6ri0WGLHGcnUFxk5qeRa8UzSleUUgdhOnpv6GS4XWV9Gl7b7h7
   sIAyhdsCNvfBObRb4yDuK4R9gQKeCNHpJVlzvuny0S6iNftC1ekUf7Kg8
   KtkyBL7MmjtKoczNMumQqd+m+CsK7ag0dLgI7s9yu7fYoHLx8ztWc8INm
   MENgWp38e2Qqy7bRB4/jdN5tDagld8HUqyAvZ/0Lkyuba3sOVLy/GKN7M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="225600958"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="225600958"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 03:09:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="602082497"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Dec 2021 03:09:24 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1BAB9MOF018070;
        Fri, 10 Dec 2021 11:09:22 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "jbrouer@redhat.com" <jbrouer@redhat.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "hawk@kernel.org" <hawk@kernel.org>, "kafai@fb.com" <kafai@fb.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>, "yhs@fb.com" <yhs@fb.com>,
        Jith Joseph <jithu.joseph@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 2/9] i40e: respect metadata on XSK Rx to skb
Date:   Fri, 10 Dec 2021 12:08:48 +0100
Message-Id: <20211210110848.708046-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <11db2426b85eb8cedd5e2d66d6399143cb382b49.camel@intel.com>
References: <20211208140702.642741-1-alexandr.lobakin@intel.com> <20211208140702.642741-3-alexandr.lobakin@intel.com> <2811b35a-9179-88ce-d87a-e1f824851494@redhat.com> <20211209173816.5157-1-alexandr.lobakin@intel.com> <11db2426b85eb8cedd5e2d66d6399143cb382b49.camel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Thu, 9 Dec 2021 18:50:07 +0000

> On Thu, 2021-12-09 at 18:38 +0100, Alexander Lobakin wrote:
> > From: Jesper Dangaard Brouer <jbrouer@redhat.com>
> > Date: Thu, 9 Dec 2021 09:27:37 +0100
> > 
> > > On 08/12/2021 15.06, Alexander Lobakin wrote:
> > > > For now, if the XDP prog returns XDP_PASS on XSK, the metadata
> > > > will
> > > > be lost as it doesn't get copied to the skb.
> > > 
> > > I have an urge to add a newline here, when reading this, as IMHO it
> > > is a 
> > > paragraph with the problem statement.
> > > 
> > > > Copy it along with the frame headers. Account its size on skb
> > > > allocation, and when copying just treat it as a part of the frame
> > > > and do a pull after to "move" it to the "reserved" zone.
> > > 
> > > Also newline here, as next paragraph are some extra details, you
> > > felt a 
> > > need to explain to the reader.
> > > 
> > > > net_prefetch() xdp->data_meta and align the copy size to speed-up
> > > > memcpy() a little and better match i40e_costruct_skb().
> > >                                       ^^^^^^xx^^^^^^^^^
> > > 
> > > commit messages.
> > 
> > Oh gosh, I thought I don't have attention deficit. Thanks, maybe
> > Tony will fix it for me or I could send a follow-up (or resend if
> > needed, I saw those were already applied to dev-queue).
> 
> If there's no need for follow-ups beyond this change, I'll fix it up.

The rest is fine, thank you!

> Thanks,
> Tony
> 
> > > --Jesper
> > 
> > Al

Al
