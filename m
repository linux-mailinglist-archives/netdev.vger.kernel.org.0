Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7612F2C1878
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732425AbgKWWbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:31:51 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:18657 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728305AbgKWWbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606170710; x=1637706710;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wb8eqtyylgw78rPOZfSNn17SgdN/t/g7nieWeZQwGus=;
  b=Q+eKq4lkj7tci88+degHQsWNaoCm6kbKriUU1EkrXInzkevgSVxB2A1N
   ti1TPFV3e4/6xa+mVyuH0GDVCobGvuvSrUiJqZEwG9vhWzlKQjjqAQpaO
   6Bp05tBVhDIoLXnmlpYORRNhReb2xefgEBacGQcPylqnzFfcjph56tlGr
   EsLDS9rXxGLwKD/KQVGVjtwSMwCd+TP8/eQV06bb3Xehd0zkR09r610cd
   2bWC4E6Ilnt2yYW6DWKCfjzrIBPGjME80UpgwLtSZ2oGpXkgsVdUDiHc7
   1Wer+yQBYedvuHlgxkwMyXZXJOktNMfdgpQZiTTjIlbn6LyxQXyEQ5YfU
   w==;
IronPort-SDR: u/vGnz1blCz9GBhE4TnLUcqOnwlPo94yZb1RzmGXPC1g30ZFyxAx0lK3u+fyroPDwcwUd2UDLh
 rkGM3PouOYpJs8TeWASsGf6EqDnXSkSQVQn+3cKWPlXwGpj5lffx2l5xvkCydDM9PLv+3ytb4h
 z8wefRifdevAtdryrjxqsi1E3r+ByI5X8EdctPQL+xW/3g8McLCyyq5bivCDz1v2JuafVE9Cej
 uL5WbLfQ/l68vXp/8UphWaWVv4WGllHI9v7x7Hl0t5vc7VNIKbIW2KIGkvjBO07VpEru8V4T0Q
 27I=
X-IronPort-AV: E=Sophos;i="5.78,364,1599548400"; 
   d="scan'208";a="34789328"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2020 15:31:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 23 Nov 2020 15:31:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 23 Nov 2020 15:31:49 -0700
Date:   Mon, 23 Nov 2020 23:31:48 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Nikolay Aleksandrov <nikolay@nvidia.com>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
Message-ID: <20201123223148.gvexo37ibzophobl@soft-dev3.localdomain>
References: <20201123111401.136952-1-horatiu.vultur@microchip.com>
 <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
 <20201123123132.uxvec6uwuegioc25@soft-dev3.localdomain>
 <13cef7c2-cacc-2c24-c0d5-e462b0e3b4df@nvidia.com>
 <20201123140519.3bb3db16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201123140519.3bb3db16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/23/2020 14:05, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 23 Nov 2020 16:25:53 +0200 Nikolay Aleksandrov wrote:
> > >>> @@ -156,4 +157,10 @@ struct br_mrp_in_link_hdr {
> > >>>       __be16 interval;
> > >>>  };
> > >>>
> > >>> +struct br_mrp_in_link_status_hdr {
> > >>> +     __u8 sa[ETH_ALEN];
> > >>> +     __be16 port_role;
> > >>> +     __be16 id;
> > >>> +};
> > >>> +
> > >>
> > >> I didn't see this struct used anywhere, am I missing anything?
> > >
> > > Yes, you are right, the struct is not used any. But I put it there as I
> > > put the other frame types for MRP.
> > >
> >
> > I see, we don't usually add unused code. The patch is fine as-is and since
> > this is already the case for other MRP parts I'm not strictly against it, so:
> >
> > Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> >
> > If Jakub decides to adhere to that rule you can keep my acked-by and just remove
> > the struct for v2.

Hi Jakub,

> 
> Yes, good catch, let's drop it, we don't want to make too much of
> a precedent for using kernel uAPI headers as a place to provide
> protocol-related structs if the kernel doesn't need them.

OK, I see. I will send a new version for this patch where I will drop
the struct 'br_mrp_in_link_stauts_hdr'.

> 
> The existing structs are only present in net-next as well, so if you
> don't mind Horatiu it'd be good to follow up and remove the unused ones
> and move the ones (if any) which are only used by the kernel but not by
> the user space <-> kernel API communication out of include/uapi.

Maybe we don't refer to the same structs, but I could see that they are
already in net and in Linus' tree. For example the struct
'br_mrp_ring_topo_hdr'. Or am I missunderstanding something?

-- 
/Horatiu
