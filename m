Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E72426A14F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIOIyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:54:35 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:48609 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIOIye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600160074; x=1631696074;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q1K3ZnDAfToNz/8n8qN43CbiTyRRyydMCMCOaNUYtDM=;
  b=U0u4thy7JRsmb3F0y0S3PgUMBVcE0vs+eF8MDqPW3RQanUBvYl8com8/
   Imw/uKoOyYe8M/6SCC7LE3YjSqNAse06xFmEYUr03SiFoyxoIsxOKUuRY
   DSgl8cDN+1tSpXzMpUgeE/QtVA+GQxFTcM0Q/2VWsJhs2z7D/3xxGhaFV
   CzpcCPZGNgTQGj3JUq9oBbuqOjRTzkoy0BQyLk3Je7J3YyCjM0Jm99f3c
   sJOY28hYshVXUjyi/3Xir10qgabopEx+2OF/cVbHMgh9niOrR5GPOed/u
   xGvYYAYWFwU6TVkgvbUPr4UXlrGBX5cTRUfYjcITYYfc0s/lUPyjV7a0v
   A==;
IronPort-SDR: W4dS+NKoczb/uFgiJQpnct2/tpr4/ydR+fpvqKV8jvXK+2Ymmmlop6w95BVSPPCYnvtCdFNVgV
 wpgd9ezuttGbJq4JiPjhqyazOAwlLNuqr0EHSa5oo0hFspVP1oUT6FNCQ9bqJLzTrLRrVJoamB
 hMTrqWVme0yr0QLJFxnRSgL4x//S0Z/h9KEkt5euUDbx5++Xiv8QD4r2bBMCAB5HeFiyoKEzhf
 7M+V4nlnW1xe7zB3GU1ewFvBP8lu0NbDux7ZkrGI9GUYuzfDPO2HLDt2iy+X6HqjMYwI7jaBsJ
 z7k=
X-IronPort-AV: E=Sophos;i="5.76,429,1592895600"; 
   d="scan'208";a="91839331"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2020 01:54:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 01:54:12 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Sep 2020 01:54:04 -0700
Date:   Tue, 15 Sep 2020 08:51:37 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC 4/7] bridge: cfm: Kernel space implementation of CFM.
Message-ID: <20200915085137.c7xfmk5bpjzniclp@soft-test08>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
 <20200904091527.669109-5-henrik.bjoernlund@microchip.com>
 <20200904080257.6b2a643f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200904080257.6b2a643f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 09/04/2020 08:02, Jakub Kicinski wrote:
> 
> On Fri, 4 Sep 2020 09:15:24 +0000 Henrik Bjoernlund wrote:
> > +     rcu_read_lock();
> > +     b_port = rcu_dereference(mep->b_port);
> > +     if (!b_port)
> > +             return NULL;
> > +     skb = dev_alloc_skb(CFM_CCM_MAX_FRAME_LENGTH);
> > +     if (!skb)
> > +             return NULL;
> 
> net/bridge/br_cfm.c:171:23: warning: context imbalance in 'ccm_frame_build' - different lock contexts for basic block

I will assure that rcu_read_unlock() is called before any return.

-- 
/Henrik
