Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4210462DE1E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiKQOa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbiKQO34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:29:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4559F2A940
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668695393; x=1700231393;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N0l/IllxRT2ONp070u7b5BHm5cAR4vfPg2Fg5Ye3MoE=;
  b=iEmh3zF9Hj+IZOPj+ViC3A/TiDgl8Fxo0b2KjQWewqXyzr5QyTgyyVja
   HCc96RQmgP7dki36lRxNlfk+synYvrjiSJIDuYjdnHWCVJT9a5rRXGT8G
   fTBxaBhwhcpgwIwj5APpm7Kq1pxJ5Da/Sc73rPK5jZb1JMRxtvjKjKBHm
   /H84xcPTxgjjIFtJfo0rDsnJUhDlpG/pTHhXBGHMkSflu0bvpUtsLrx39
   gjQBH35CJBACx43aGGrVV7EjgYFUtF3ut36cDlK5VQhR+zODH6pYmz4So
   2pvLhVAqiM2HrIKN40Tw20KeWPN1N/e/a5uA+IZg1UIryA6hzdX+2qs5w
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="200230047"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2022 07:29:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 17 Nov 2022 07:29:52 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 17 Nov 2022 07:29:49 -0700
Message-ID: <841c618ee79adf50eb9281308d370d5c761f3a05.camel@microchip.com>
Subject: Re: [PATCH net] net: sparx5: fix error handling in
 sparx5_port_open()
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Liu Jian <liujian56@huawei.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <horatiu.vultur@microchip.com>, <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 17 Nov 2022 15:29:48 +0100
In-Reply-To: <Y3Y0B4umLgFdcD4u@shell.armlinux.org.uk>
References: <20221117125918.203997-1-liujian56@huawei.com>
         <Y3Y0B4umLgFdcD4u@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Liu and Russell,

Yes, I think we should go over this and do some testing on the platform before taking it in.

On Thu, 2022-11-17 at 13:15 +0000, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Thu, Nov 17, 2022 at 08:59:18PM +0800, Liu Jian wrote:
> > If phylink_of_phy_connect() fails, the port should be disabled.
> > If sparx5_serdes_set()/phy_power_on() fails, the port should be
> > disabled and the phylink should be stopped and disconnected.
> > 
> > Fixes: 946e7fd5053a ("net: sparx5: add port module support")
> > Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> 
> The patch looks sane for the code structure that's there, but I question
> whether this is the best code structure.
> 
> phylink_start() will call the pcs_config() method, which then goes on
> to call sparx5_port_pcs_set() and sparx5_port_pcs_low_set() - which
> then calls sparx5_serdes_set(). Is that safe with the serdes PHY
> powered down? I think sparx5 maintainers need to think about that,
> and possibly include a comment in the code if it is indeed safe.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

BR
Steen


