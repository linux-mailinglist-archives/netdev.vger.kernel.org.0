Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39A26B70DC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 09:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCMIH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 04:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCMIH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 04:07:28 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7A328851
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 01:05:58 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PZq053qYPz17KLj;
        Mon, 13 Mar 2023 16:03:01 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 13 Mar
 2023 16:05:55 +0800
Subject: Re: [PATCH v3 net-next] net: hns3: support wake on lan configuration
 and query
To:     Simon Horman <simon.horman@corigine.com>
References: <20230310081404.947-1-lanhao@huawei.com>
 <ZAxw3PWVLiGQtTMS@corigine.com>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <alexander.duyck@gmail.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <shenjian15@huawei.com>, <netdev@vger.kernel.org>,
        <wangjie125@huawei.com>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <3e2be728-cb68-36cf-0dd4-a62ba5601cea@huawei.com>
Date:   Mon, 13 Mar 2023 16:05:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <ZAxw3PWVLiGQtTMS@corigine.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestion. Generally I follow the reverse xmas tree style
for readability. But for this case, whether it looks a bit bloated ?

On 2023/3/11 20:15, Simon Horman wrote:
> Simon Horman <simon.horman@corigine.com>
> On Fri, Mar 10, 2023 at 04:14:04PM +0800, Hao Lan wrote:
> > The HNS3 driver supports Wake-on-LAN, which can wake up
> > the server from power off state to power on state by magic
> > packet or magic security packet.
> >
> > ChangeLog:
> > v1->v2:
> > Deleted the debugfs function that overlaps with the ethtool function
> > from suggestion of Andrew Lunn.
> >
> > v2->v3:
> > Return the wol configuration stored in driver,
> > suggested by Alexander H Duyck.
> >
> > Signed-off-by: Hao Lan <lanhao@huawei.com>
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
> ...
>
> > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> > index 55306fe8a540..10de2b4c401b 100644
> > --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
> > @@ -2063,6 +2063,31 @@ static int hns3_get_link_ext_state(struct net_device *netdev,
> >  	return -ENODATA;
> >  }
> >
> > +static void hns3_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> > +{
> > +	struct hnae3_handle *handle = hns3_get_handle(netdev);
> > +	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
> > +	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
>
> nit: the local variable declarations could be reverse xmas tree
>      - longest line to shortest line. One option being:
>
> 	const struct hnae3_ae_ops *ops;
> 	struct hnae3_handle *handle;
> 	struct hnae3_ae_dev *ae_dev;
>
> 	handle = hns3_get_handle(netdev);
> 	ae_dev = pci_get_drvdata(handle->pdev);
> 	ops = handle->ae_algo->ops;
>
> Likewise elsewhere in this patch.
> .
