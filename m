Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C923FEFD8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345727AbhIBPIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:08:00 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:41306 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234984AbhIBPH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 11:07:58 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 73FA84D048;
        Thu,  2 Sep 2021 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:user-agent:content-type
        :content-type:organization:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received:received:received; s=
        mta-01; t=1630595213; x=1632409614; bh=ohzBaHIQJi6XFUgN9Za1egaft
        OTNkTgtCcHs5jiUnuQ=; b=gQtz9/zJnfSt09MuRU5JcwnKjSFT6mVvhBq7fgvNz
        UbDk8kUZe14HQjDrWd4O89wzdHWNB1YFYeDKJKngHTkTcAD7ACwINPMvJABlAlNG
        SkqPEX1lrL6yzUMYItAaFWjW25SLPsNR/Y6OdQxhXZyIckIJbceXS81lmp6VZIfg
        FY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id he5YG7Tih9hI; Thu,  2 Sep 2021 18:06:53 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5E25A4D01B;
        Thu,  2 Sep 2021 18:06:51 +0300 (MSK)
Received: from [10.199.0.231] (10.199.0.231) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 2 Sep
 2021 18:06:50 +0300
Message-ID: <cb9dedaf242264f76eca18e94934703300be5a7e.camel@yadro.com>
Subject: Re:  [PATCH 1/1] net/ncsi: add get MAC address command to get Intel
 i210 MAC address
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     Milton Miller II <miltonm@us.ibm.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Brad Ho <Brad_Ho@phoenix.com>,
        Paul Fertser <fercerpav@gmail.com>, <openbmc@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Date:   Thu, 2 Sep 2021 18:17:30 +0300
In-Reply-To: <OF2487FB9E.ECED277D-ON00258741.006BEF89-00258744.001FE4C0@ibm.com>
References: <20210830171806.119857-2-i.mikhaylov@yadro.com>
         <OF2487FB9E.ECED277D-ON00258741.006BEF89-00258744.001FE4C0@ibm.com>
Organization: YADRO
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.199.0.231]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-09-02 at 05:48 +0000, Milton Miller II wrote:
> On August 30, 2021, Ivan Mikhaylov" <i.mikhaylov@yadro.com> wrote:
> > This patch adds OEM Intel GMA command and response handler for it.
> > 
> > /* Get Link Status */
> > struct ncsi_rsp_gls_pkt {
> >         struct ncsi_rsp_pkt_hdr rsp;        /* Response header   */
> > diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> > index d48374894817..6447a09932f5 100644
> > --- a/net/ncsi/ncsi-rsp.c
> > +++ b/net/ncsi/ncsi-rsp.c
> > @@ -699,9 +699,51 @@ static int ncsi_rsp_handler_oem_bcm(struct
> > ncsi_request *nr)
> >         return 0;
> > }
> > 
> > +/* Response handler for Intel command Get Mac Address */
> > +static int ncsi_rsp_handler_oem_intel_gma(struct ncsi_request *nr)
> > +{
> > +       struct ncsi_dev_priv *ndp = nr->ndp;
> > +       struct net_device *ndev = ndp->ndev.dev;
> > +       const struct net_device_ops *ops = ndev->netdev_ops;
> > +       struct ncsi_rsp_oem_pkt *rsp;
> > +       struct sockaddr saddr;
> > +       int ret = 0;
> > +
> > +       /* Get the response header */
> > +       rsp = (struct ncsi_rsp_oem_pkt *)skb_network_header(nr->rsp);
> > +
> > +       saddr.sa_family = ndev->type;
> > +       ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
> > +       memcpy(saddr.sa_data, &rsp->data[INTEL_MAC_ADDR_OFFSET], ETH_ALEN);
> > +       /* Increase mac address by 1 for BMC's address */
> > +       eth_addr_inc((u8 *)saddr.sa_data);
> > +       if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
> > +               return -ENXIO;
> 
> The Intel GMA retireves the MAC address of the host, and the datasheet
> anticipates the BMC will "share" the MAC by stealing specific TCP and 
> UDP port traffic destined to the host.
> 
> This "add one" allocation of the MAC is therefore a policy, and one that 
> is beyond the data sheet.
> 
> While this +1 policy may work for some OEM boards, there are other boards 
> where the MAC address assigned to the BMC does not follow this pattern, 
> but instead the MAC is stored in some platform dependent location obtained 
> in a platform specific manner.
> 
> I suggest this BMC = ether_addr_inc(GMA) be opt in via a device tree
> property.  
> 
> as it appears it would be generic to more than one vendor.
> 
> Unfortunately, we missed this when we added the broadcom and mellanox
> handlers.
> 
> 
> 

Milton,

maybe something like "mac_addr_inc" or "ncsi,mac_addr_inc"? Also those 3(intel,
mellanox, broadcom) functions even with handlers similar to each other, they
could be unified on idea, difference in addresses, payload lengths, ids only as
I see. Joel proposed in the past about dts option for Intel OEM keep_phy option,
maybe that's the right time to reorganize all OEM related parts to fit in one
direction with dts options for ethernet interface without Kconfig options?

Thanks.

