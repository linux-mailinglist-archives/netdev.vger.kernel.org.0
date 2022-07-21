Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389C557C75B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbiGUJRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiGUJRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:17:16 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729222B1B6;
        Thu, 21 Jul 2022 02:17:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0VK.Qu92_1658395024;
Received: from 192.168.0.4(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VK.Qu92_1658395024)
          by smtp.aliyun-inc.com;
          Thu, 21 Jul 2022 17:17:06 +0800
Message-ID: <f030aeab-b503-8381-53f5-15862e1333b0@linux.alibaba.com>
Date:   Thu, 21 Jul 2022 17:17:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
From:   Cheng Xu <chengyou@linux.alibaba.com>
Subject: Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
To:     longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
Content-Language: en-US
In-Reply-To: <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/16/22 10:07 AM, longli@linuxonhyperv.com wrote:
> From: Long Li <longli@microsoft.com>
> 

<...>

> +
> +static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
> +				 struct ib_qp_init_attr *attr,
> +				 struct ib_udata *udata)
> +{
> +	struct mana_ib_pd *pd = container_of(ibpd, struct mana_ib_pd, ibpd);
> +	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
> +	struct mana_ib_dev *mdev =
> +		container_of(ibpd->device, struct mana_ib_dev, ib_dev);
> +	struct mana_ib_cq *send_cq =
> +		container_of(attr->send_cq, struct mana_ib_cq, ibcq);
> +	struct ib_ucontext *ib_ucontext = ibpd->uobject->context;
> +	struct mana_ib_create_qp_resp resp = {};
> +	struct mana_ib_ucontext *mana_ucontext;
> +	struct gdma_dev *gd = mdev->gdma_dev;
> +	struct mana_ib_create_qp ucmd = {};
> +	struct mana_obj_spec wq_spec = {};
> +	struct mana_obj_spec cq_spec = {};
> +	struct mana_port_context *mpc;
> +	struct mana_context *mc;
> +	struct net_device *ndev;
> +	struct ib_umem *umem;
> +	int err;
> +	u32 port;
> +
> +	mana_ucontext =
> +		container_of(ib_ucontext, struct mana_ib_ucontext, ibucontext);
> +	mc = gd->driver_data;
> +
> +	if (udata->inlen < sizeof(ucmd))
> +		return -EINVAL;
> +
> +	err = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));
> +	if (err) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed to copy from udata create qp-raw, %d\n", err);
> +		return -EFAULT;
> +	}
> +
> +	/* IB ports start with 1, MANA Ethernet ports start with 0 */
> +	port = ucmd.port;
> +	if (ucmd.port > mc->num_ports)
> +		return -EINVAL;
> +
> +	if (attr->cap.max_send_wr > MAX_SEND_BUFFERS_PER_QUEUE) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Requested max_send_wr %d exceeding limit\n",
> +			  attr->cap.max_send_wr);
> +		return -EINVAL;
> +	}
> +
> +	if (attr->cap.max_send_sge > MAX_TX_WQE_SGL_ENTRIES) {
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Requested max_send_sge %d exceeding limit\n",
> +			  attr->cap.max_send_sge);
> +		return -EINVAL;
> +	}
> +
> +	ndev = mc->ports[port - 1];
> +	mpc = netdev_priv(ndev);
> +	ibdev_dbg(&mdev->ib_dev, "port %u ndev %p mpc %p\n", port, ndev, mpc);
> +
> +	err = mana_ib_cfg_vport(mdev, port - 1, pd, mana_ucontext->doorbell);
> +	if (err)
> +		return -ENODEV;
> +
> +	qp->port = port;
> +
> +	ibdev_dbg(&mdev->ib_dev, "ucmd sq_buf_addr 0x%llx port %u\n",
> +		  ucmd.sq_buf_addr, ucmd.port);
> +
> +	umem = ib_umem_get(ibpd->device, ucmd.sq_buf_addr, ucmd.sq_buf_size,
> +			   IB_ACCESS_LOCAL_WRITE);
> +	if (IS_ERR(umem)) {
> +		err = PTR_ERR(umem);
> +		ibdev_dbg(&mdev->ib_dev,
> +			  "Failed to get umem for create qp-raw, err %d\n",
> +			  err);
> +		goto err_free_vport;
> +	}
> +	qp->sq_umem = umem;
> +
> +	err = mana_ib_gd_create_dma_region(mdev, qp->sq_umem,
> +					   &qp->sq_gdma_region, PAGE_SIZE);
> +	if (err) {
> +		ibdev_err(&mdev->ib_dev,
> +			  "Failed to create dma region for create qp-raw, %d\n",
> +			  err);

It is better not print in userspace-triggered paths.

There are also same issues in other paths.

Thanks,
Cheng Xu


