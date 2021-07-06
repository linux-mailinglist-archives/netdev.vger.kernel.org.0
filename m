Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622323BC50B
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 05:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhGFDTO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Jul 2021 23:19:14 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13083 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhGFDTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 23:19:13 -0400
Received: from dggeme761-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GJngk6pMfzZnfH;
        Tue,  6 Jul 2021 11:13:22 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeme761-chm.china.huawei.com (10.3.19.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 6 Jul 2021 11:16:33 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2176.012;
 Tue, 6 Jul 2021 11:16:33 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        dingxiaoxiong <dingxiaoxiong@huawei.com>
Subject: RE: [PATCH net] virtio_net: check virtqueue_add_sgs() return value
Thread-Topic: [PATCH net] virtio_net: check virtqueue_add_sgs() return value
Thread-Index: AQHXcaQFMVkJoeQm7k+gqasXhggVCqs0KBYAgAEcD/A=
Date:   Tue, 6 Jul 2021 03:16:33 +0000
Message-ID: <ab0eec15304f498c8e25c28ec081b89e@huawei.com>
References: <63453491987be2b31062449bd59224faca9f546a.1625486802.git.wangyunjian@huawei.com>
 <20210705140505-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210705140505-mutt-send-email-mst@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.242.204]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Tuesday, July 6, 2021 2:08 AM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: kuba@kernel.org; davem@davemloft.net; netdev@vger.kernel.org;
> jasowang@redhat.com; dingxiaoxiong <dingxiaoxiong@huawei.com>
> Subject: Re: [PATCH net] virtio_net: check virtqueue_add_sgs() return value
> 
> On Mon, Jul 05, 2021 at 09:53:39PM +0800, wangyunjian wrote:
> > From: Yunjian Wang <wangyunjian@huawei.com>
> >
> > As virtqueue_add_sgs() can fail, we should check the return value.
> >
> > Addresses-Coverity-ID: 1464439 ("Unchecked return value")
> > Fixes: a7c58146cf9a ("virtio_net: don't crash if virtqueue is
> > broken.")
> 
> What does this have to do with it?

It's this commit that removes the check.
So delete this fix tag?

> 
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> > ---
> >  drivers/net/virtio_net.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c index
> > b0b81458ca94..2b852578551e 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1743,6 +1743,7 @@ static bool virtnet_send_command(struct
> > virtnet_info *vi, u8 class, u8 cmd,  {
> >  	struct scatterlist *sgs[4], hdr, stat;
> >  	unsigned out_num = 0, tmp;
> > +	int ret;
> >
> >  	/* Caller should know better */
> >  	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ)); @@
> > -1762,7 +1763,9 @@ static bool virtnet_send_command(struct virtnet_info
> *vi, u8 class, u8 cmd,
> >  	sgs[out_num] = &stat;
> >
> >  	BUG_ON(out_num + 1 > ARRAY_SIZE(sgs));
> > -	virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
> > +	ret = virtqueue_add_sgs(vi->cvq, sgs, out_num, 1, vi, GFP_ATOMIC);
> > +	if (ret < 0)
> > +		return false;
> 
> and maybe dev_warn here. these things should not happen.

OK, I will add it in next version.

Thanks
Yunjian

> 
> 
> >
> >  	if (unlikely(!virtqueue_kick(vi->cvq)))
> >  		return vi->ctrl->status == VIRTIO_NET_OK;
> > --
> > 2.23.0

