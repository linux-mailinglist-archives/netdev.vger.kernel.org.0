Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461FC28F156
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgJOLax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:30:53 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:27467 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbgJOLaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761435; x=1634297435;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cA6QBKhjqXc9apBjlCYNPW0rtpxCtWcB+v3escExznM=;
  b=W80LQkKQS1FbutAapBEIh3gzKQsSz87eQAqyXkvmIU3ctGM4UnLsyxeN
   Qo9Vk3LDCxe8kXLXQ8NKfh0QADLrd47y9TPX7v+lP1eJ2rXiQgqXBk/J1
   1Wgx4/BMJZDcVj8h24lDAkiTtKkADvI1sWtJ2fXsARjwDOHonJSgCd5L8
   8zwqC6vH0oeQlgAl2owzz+Oyx5rAFc8ZaB0LVEfsGypsqZ5MQ+x9TgKpy
   b67MWi0tBSfw3YCt1H6NWMwCRerLH2rCEIJNPlyFllfDe9gVZeVMMtZ1b
   BTpIW9t3LXOqVQWDlY1MotnUVmPZhfZc7mps/vokPiHe1ZwwHZFbTQwjC
   g==;
IronPort-SDR: PIbj8i6RUB3fJ5PrshBXYm21Sjg3ZnFFF4jo2Jo8fIbZTahucEj3ug+SAE+PyFiFV5ZPPk3UzE
 zW5mfaezt8+0I/t86D89G9PylHp+0/N9OPD7scf7VwoezqDLllB8BuQmtCguwffc3XhqDXM6r1
 6HrekUMTzoMEPNFsttKJuXvoeyAUbixFJlIvlzfDU9c/BJ2dp3MdA/A2K5C32lO+R9Zb0rMF4e
 ALAHOTvc66ZRpb36uTjE9u5JCdrg6NOL3YeMIwzn252IB7tEOuLPMqtphQO0AlVwP997wgRZZL
 vgg=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="29986398"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:30:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:30:34 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:30:34 -0700
Date:   Thu, 15 Oct 2020 11:28:53 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 05/10] bridge: cfm: Kernel space
 implementation of CFM. CCM frame TX added.
Message-ID: <20201015112853.42vcj4bjbg7syoyd@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-6-henrik.bjoernlund@microchip.com>
 <20201014155958.12e38308@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201014155958.12e38308@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comments below.
Regards
Henrik

The 10/14/2020 15:59, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 12 Oct 2020 14:04:23 +0000 Henrik Bjoernlund wrote:
> > +     skb = dev_alloc_skb(CFM_CCM_MAX_FRAME_LENGTH);
> > +     if (!skb)
> > +             return NULL;
> > +
> > +     rcu_read_lock();
> > +     b_port = rcu_dereference(mep->b_port);
> > +     if (!b_port) {
> > +             rcu_read_unlock();
> > +             return NULL;
> > +     }
> 
> At a quick scan I noticed you appear to be leaking the skb here.
> So let me point out some more nit picks.

I have changed as requested.

-- 
/Henrik
