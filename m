Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2758D484C4D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 03:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiAECHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 21:07:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45156 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiAECHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 21:07:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D776861476
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 02:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD0C36AED;
        Wed,  5 Jan 2022 02:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641348461;
        bh=1cgQtyY4JloFFw1O4ealJ6VnnNk1komD/My9+K1FEtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fbxSBA9QQjdINa+h5s9K4Qgt5wdsREuZCr5gp93PEAO/Hg4X2DbyDHRel4KS4Dk9P
         xm8/y57O6Eq1/t6EFpEcPCS4C3qJe5ngC9MBpXtalAGrBEpVWFxyRGjbW9FCaXqXzO
         XhYatw4WSIGORqGd+wiQz5tcmSv6sCTjV/5h5Akj/LQ4ULIrQmklIMZI6tC9UObfhJ
         UQjkoDQrMIQDkTvGEYGEzLCuo3lezCiCT8AWAQ01XxRSES1alus/BdpvGAPV1BsURB
         nAy1Bj3iVpnIW3CidwafaqKhEipkxKMPjardB07rRS17jDp7QX1tX6L1nRglqBTdZJ
         br/k4g6s2NSIQ==
Date:   Tue, 4 Jan 2022 18:07:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
Message-ID: <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104064657.2095041-4-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
        <20220104064657.2095041-4-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jan 2022 22:46:52 -0800 Dimitris Michailidis wrote:
> This is the first part of the Fungible ethernet driver. It deals with
> device probing, net_device creation, and netdev ops.

> +static int fun_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	struct bpf_prog *old_prog, *prog = xdp->prog;
> +	struct funeth_priv *fp = netdev_priv(dev);
> +	bool reconfig;
> +	int rc, i;
> +
> +	/* XDP uses at most one buffer */
> +	if (prog && dev->mtu > XDP_MAX_MTU) {
> +		netdev_err(dev, "device MTU %u too large for XDP\n", dev->mtu);
> +		NL_SET_ERR_MSG_MOD(xdp->extack,
> +				   "Device MTU too large for XDP");
> +		return -EINVAL;
> +	}
> +
> +	reconfig = netif_running(dev) && (!!fp->xdp_prog ^ !!prog);
> +	if (reconfig) {
> +		rc = funeth_close(dev);

Please rework runtime reconfig to not do the close and then open thing.
This will prevent users from reconfiguring their NICs at runtime.
You should allocate the resources first, then take the datapath down,
reconfigure, swap and free the old resources.

> +		if (rc) {
> +			NL_SET_ERR_MSG_MOD(xdp->extack,
> +					   "Failed to reconfigure Rx queues.");
> +			return rc;
> +		}
> +	}
> +
> +	dev->max_mtu = prog ? XDP_MAX_MTU : FUN_MAX_MTU;
> +	fp->num_xdpqs = prog ? num_online_cpus() : 0;
> +	old_prog = xchg(&fp->xdp_prog, prog);
> +
> +	if (reconfig) {
> +		rc = funeth_open(dev);
> +		if (rc) {
> +			NL_SET_ERR_MSG_MOD(xdp->extack,
> +					   "Failed to reconfigure Rx queues.");
> +			dev->max_mtu = old_prog ? XDP_MAX_MTU : FUN_MAX_MTU;
> +			fp->num_xdpqs = old_prog ? num_online_cpus() : 0;
> +			xchg(&fp->xdp_prog, old_prog);
> +			return rc;
> +		}
> +	} else if (netif_running(dev)) {
> +		struct funeth_rxq **rxqs = rtnl_dereference(fp->rxqs);
> +
> +		for (i = 0; i < dev->real_num_rx_queues; i++)
> +			WRITE_ONCE(rxqs[i]->xdp_prog, prog);
> +	}
> +
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +	return 0;
> +}


> +static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
> +{
> +	struct fun_dev *fdev = &ed->fdev;
> +	struct net_device *netdev;
> +	unsigned int ntx, nrx;
> +	struct funeth_priv *fp;

rev xmas tree

> +	int rc;

> +static void fun_destroy_netdev(struct net_device *netdev)
> +{
> +	if (likely(netdev)) {

defensive programming?

try to avoid wrapping the entire function in an if condition,
return early instead.

> +		struct funeth_priv *fp = netdev_priv(netdev);
> +
> +		if (fp->dl_port.devlink) {
> +			devlink_port_type_clear(&fp->dl_port);
> +			devlink_port_unregister(&fp->dl_port);
> +		}
> +		unregister_netdev(netdev);
> +		fun_ktls_cleanup(fp);
> +		fun_free_stats_area(fp);
> +		fun_free_rss(fp);
> +		fun_port_destroy(netdev);
> +		free_netdev(netdev);
> +	}
> +}


> +	if ((notif->link_state | notif->missed_events) & FUN_PORT_FLAG_MAC_DOWN)
> +		netif_carrier_off(netdev);
> +	if (notif->link_state & FUN_PORT_FLAG_NH_DOWN)
> +		netif_dormant_on(netdev);
> +	if (notif->link_state & FUN_PORT_FLAG_NH_UP)
> +		netif_dormant_off(netdev);

What does this do?

> +	if (notif->link_state & FUN_PORT_FLAG_MAC_UP)
> +		netif_carrier_on(netdev);
> +
> +	write_seqcount_end(&fp->link_seq);
> +	fun_report_link(netdev);
> +}

> +static int funeth_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct devlink *devlink;
> +	struct fun_ethdev *ed;
> +	struct fun_dev *fdev;
> +	int rc;
> +
> +	struct fun_dev_params aqreq = {
> +		.cqe_size_log2 = ilog2(ADMIN_CQE_SIZE),
> +		.sqe_size_log2 = ilog2(ADMIN_SQE_SIZE),
> +		.cq_depth      = ADMIN_CQ_DEPTH,
> +		.sq_depth      = ADMIN_SQ_DEPTH,
> +		.rq_depth      = ADMIN_RQ_DEPTH,
> +		.min_msix      = 2,              /* 1 Rx + 1 Tx */
> +		.event_cb      = fun_event_cb,
> +		.serv_cb       = fun_service_cb,
> +	};

no empty lines between variable declarations, you can make this the
first variable instead since it has longest lines

> +	devlink = fun_devlink_alloc(&pdev->dev);
> +	if (!devlink) {
> +		dev_err(&pdev->dev, "devlink alloc failed\n");
> +		return -ENOMEM;
> +	}

> +static void __funeth_remove(struct pci_dev *pdev)
> +{
> +	struct fun_dev *fdev = pci_get_drvdata(pdev);
> +	struct devlink *devlink;
> +	struct fun_ethdev *ed;
> +
> +	if (!fdev)
> +		return;

defensive programming, please remove 

> +	ed = to_fun_ethdev(fdev);
> +	devlink = priv_to_devlink(ed);
> +	fun_devlink_unregister(devlink);
> +
> +#ifdef CONFIG_PCI_IOV
> +	funeth_sriov_configure(pdev, 0);
> +#endif
> +
> +	fun_serv_stop(fdev);
> +	fun_destroy_ports(ed);
> +	fun_dev_disable(fdev);
> +
> +	fun_devlink_free(devlink);
> +}
> +
> +static void funeth_remove(struct pci_dev *pdev)
> +{
> +	__funeth_remove(pdev);
> +}
> +
> +static void funeth_shutdown(struct pci_dev *pdev)
> +{
> +	__funeth_remove(pdev);
> +}

Why the two identical wrappers?

> +static struct pci_driver funeth_driver = {
> +	.name		 = KBUILD_MODNAME,
> +	.id_table	 = funeth_id_table,
> +	.probe		 = funeth_probe,
> +	.remove		 = funeth_remove,
> +	.shutdown	 = funeth_shutdown,
> +	.sriov_configure = funeth_sriov_configure,
> +};
> +
> +static int __init funeth_init(void)
> +{
> +	int ret;
> +
> +	ret = pci_register_driver(&funeth_driver);
> +	if (ret) {
> +		pr_err("%s pci_register_driver failed ret %d\n",
> +		       KBUILD_MODNAME, ret);

not worth it, plus you have unnecessary parenthesis here

you can remove the print and use module_pci_driver()

> +	}
> +	return ret;
> +}
> +
> +static void __exit funeth_exit(void)
> +{
> +	pci_unregister_driver(&funeth_driver);
> +}
> +
> +module_init(funeth_init);
> +module_exit(funeth_exit);


