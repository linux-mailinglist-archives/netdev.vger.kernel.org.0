Return-Path: <netdev+bounces-1008-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B332B6FBCE4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D9B71C20A70
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A58394;
	Tue,  9 May 2023 02:11:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0906E7C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:11:40 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D5872A6
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:11:39 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QFhPX2PfYz18KBZ;
	Tue,  9 May 2023 10:07:28 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 9 May
 2023 10:11:37 +0800
Subject: Re: [PATCH iwl-next v4 02/15] idpf: add module register and probe
 functionality
To: Emil Tantilov <emil.s.tantilov@intel.com>,
	<intel-wired-lan@lists.osuosl.org>
CC: <shannon.nelson@amd.com>, <simon.horman@corigine.com>, <leon@kernel.org>,
	<decot@google.com>, <willemb@google.com>, Phani Burra
	<phani.r.burra@intel.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>, Alan Brady
	<alan.brady@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, Shailendra
 Bhatnagar <shailendra.bhatnagar@intel.com>, Pavan Kumar Linga
	<pavan.kumar.linga@intel.com>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230508194326.482-3-emil.s.tantilov@intel.com>
From: Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b947416c-a2a6-5b2f-73b5-843541f9ac0c@huawei.com>
Date: Tue, 9 May 2023 10:11:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230508194326.482-3-emil.s.tantilov@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/9 3:43, Emil Tantilov wrote:
> +
> +/**
> + * idpf_cfg_hw - Initialize HW struct
> + * @adapter: adapter to setup hw struct for
> + *
> + * Returns 0 on success, negative on failure
> + */
> +static int idpf_cfg_hw(struct idpf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct idpf_hw *hw = &adapter->hw;
> +
> +	hw->hw_addr = pcim_iomap_table(pdev)[0];
> +	if (!hw->hw_addr) {
> +		pci_err(pdev, "failed to allocate PCI iomap table\n");
> +

Nit: unnecessary blank line here.

> +		return -ENOMEM;
> +	}
> +
> +	hw->back = adapter;
> +
> +	return 0;
> +}
> +
> +/**
> + * idpf_probe - Device initialization routine
> + * @pdev: PCI device information struct
> + * @ent: entry in idpf_pci_tbl
> + *
> + * Returns 0 on success, negative on failure
> + */
> +static int idpf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct idpf_adapter *adapter;
> +	int err;
> +
> +	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
> +	if (!adapter)
> +		return -ENOMEM;

Nit: add a blank line here.

> +	adapter->pdev = pdev;
> +
> +	err = pcim_enable_device(pdev);
> +	if (err)
> +		goto err_free;
> +
> +	err = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
> +	if (err) {
> +		pci_err(pdev, "pcim_iomap_regions failed %pe\n", ERR_PTR(err));
> +
> +		goto err_free;
> +	}
> +
> +	/* set up for high or low dma */
> +	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
> +	if (err) {
> +		pci_err(pdev, "DMA configuration failed: %pe\n", ERR_PTR(err));
> +
> +		goto err_free;
> +	}
> +
> +	pci_enable_pcie_error_reporting(pdev);

It seems pci_enable_pcie_error_reporting() has a return value, is there a reason
not to check the return value and handle it?

> +	pci_set_master(pdev);
> +	pci_set_drvdata(pdev, adapter);
> +
> +	/* setup msglvl */
> +	adapter->msg_enable = netif_msg_init(-1, IDPF_AVAIL_NETIF_M);
> +
> +	err = idpf_cfg_hw(adapter);
> +	if (err) {
> +		dev_err(dev, "Failed to configure HW structure for adapter: %d\n",
> +			err);
> +		goto err_cfg_hw;
> +	}
> +
> +	return 0;
> +
> +err_cfg_hw:

Is pci_clear_master() needed here?

> +	pci_disable_pcie_error_reporting(pdev);
> +err_free:
> +	kfree(adapter);
> +	return err;
> +}

