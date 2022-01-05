Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD6248563C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241722AbiAEPwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiAEPwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:52:41 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C82CC061201
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 07:52:38 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id h7so45493732lfu.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 07:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3tScpzsvs4vCd0ND7vB0d0otJSPL2erhDWI/+koxaVk=;
        b=B0U0j2OEtvXU8NA/ABUJ4jAjT3v70RSgTYCbCUpxBL/DGeaXC2FKI2LYlrUHkK/Jpu
         CTd/qmDdorDKGCG+sLQuhSyfEWnU3M0NaJ0EoJwrvcBdwbIJlc/jPOe4XNn9fAZ4H0Ab
         c+TG+ew0zA0LKaYWD/3SL/k7SvrbqNJ8zlyqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3tScpzsvs4vCd0ND7vB0d0otJSPL2erhDWI/+koxaVk=;
        b=ZSB3jvg7v69Kd9S5olk+O9j8Gk7ZwjZAfSogv3XhaRzR2AeMKqf0sRNM+hUfXsbXoy
         trKLvYNmhRPlGolTFStEiEdAnNcRLDfqiDyOsc8CelHRjYSOo9P3d6K2UW3lLO1o3i7r
         hBG6CBIyc4G07+TJo6dXtU7/uQreqO7qQWRmJZZsJh/6cNVyp3pLYUmbnYMP9MOYwUz3
         36h8wOK5oiWT808mI1b6tGYBI5/JFSw3AAqJSkfZ1JS1SKgEHY+H6mowPRG8DDuvy8P5
         M+dubzVuZJjF2gbktqWMKpk1MWRbW82WqYLC8xxuzYVzm1sMQIefp8WyzNwPpv8GvdYy
         CH0A==
X-Gm-Message-State: AOAM531OGjwWuxIScK4y2pqK0DiR3sKW5HgvcUYaj6QJafY5Ph9rOjzy
        iGOKbRoqtj4afaKlxrq6CYcV7KlHOq/PWDiBXoZwyrDNM2v7Vg==
X-Google-Smtp-Source: ABdhPJySs2Hms+lUgh/K5hRqzMvAzIPsmXXmDB6Pk9UftyywUn4ScmcCq/hGixV5hBN0/5N/g7Zj9N9l12gXIdqlv7Y=
X-Received: by 2002:a05:6512:1599:: with SMTP id bp25mr46229045lfb.689.1641397956473;
 Wed, 05 Jan 2022 07:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20220104064657.2095041-1-dmichail@fungible.com>
 <20220104064657.2095041-4-dmichail@fungible.com> <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Wed, 5 Jan 2022 07:52:21 -0800
Message-ID: <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 6:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  3 Jan 2022 22:46:52 -0800 Dimitris Michailidis wrote:
> > This is the first part of the Fungible ethernet driver. It deals with
> > device probing, net_device creation, and netdev ops.
>
> > +static int fun_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
> > +{
> > +     struct bpf_prog *old_prog, *prog = xdp->prog;
> > +     struct funeth_priv *fp = netdev_priv(dev);
> > +     bool reconfig;
> > +     int rc, i;
> > +
> > +     /* XDP uses at most one buffer */
> > +     if (prog && dev->mtu > XDP_MAX_MTU) {
> > +             netdev_err(dev, "device MTU %u too large for XDP\n", dev->mtu);
> > +             NL_SET_ERR_MSG_MOD(xdp->extack,
> > +                                "Device MTU too large for XDP");
> > +             return -EINVAL;
> > +     }
> > +
> > +     reconfig = netif_running(dev) && (!!fp->xdp_prog ^ !!prog);
> > +     if (reconfig) {
> > +             rc = funeth_close(dev);
>
> Please rework runtime reconfig to not do the close and then open thing.
> This will prevent users from reconfiguring their NICs at runtime.
> You should allocate the resources first, then take the datapath down,
> reconfigure, swap and free the old resources.

I imagine you have in mind something like nfp_net_ring_reconfig() but that
doesn't work as well here. We have the linux part of the data path (ring memory,
interrupts, etc) and the device part, handled by FW. I can't clone the device
portion for a quick swap during downtime. Since it involves messages to FW
updating the device portion is by far the bulk of the work and it needs to be
during the downtime. Doing Linux allocations before downtime offers little
improvement I think.

There is ongoing work for FW to be able to modify live queues. When that
is available I expect this function will be able to move in and out of XDP with
no downtime.

> > +             if (rc) {
> > +                     NL_SET_ERR_MSG_MOD(xdp->extack,
> > +                                        "Failed to reconfigure Rx queues.");
> > +                     return rc;
> > +             }
> > +     }
> > +
> > +     dev->max_mtu = prog ? XDP_MAX_MTU : FUN_MAX_MTU;
> > +     fp->num_xdpqs = prog ? num_online_cpus() : 0;
> > +     old_prog = xchg(&fp->xdp_prog, prog);
> > +
> > +     if (reconfig) {
> > +             rc = funeth_open(dev);
> > +             if (rc) {
> > +                     NL_SET_ERR_MSG_MOD(xdp->extack,
> > +                                        "Failed to reconfigure Rx queues.");
> > +                     dev->max_mtu = old_prog ? XDP_MAX_MTU : FUN_MAX_MTU;
> > +                     fp->num_xdpqs = old_prog ? num_online_cpus() : 0;
> > +                     xchg(&fp->xdp_prog, old_prog);
> > +                     return rc;
> > +             }
> > +     } else if (netif_running(dev)) {
> > +             struct funeth_rxq **rxqs = rtnl_dereference(fp->rxqs);
> > +
> > +             for (i = 0; i < dev->real_num_rx_queues; i++)
> > +                     WRITE_ONCE(rxqs[i]->xdp_prog, prog);
> > +     }
> > +
> > +     if (old_prog)
> > +             bpf_prog_put(old_prog);
> > +     return 0;
> > +}
>
>
> > +static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
> > +{
> > +     struct fun_dev *fdev = &ed->fdev;
> > +     struct net_device *netdev;
> > +     unsigned int ntx, nrx;
> > +     struct funeth_priv *fp;
>
> rev xmas tree

OK

> > +     int rc;
>
> > +static void fun_destroy_netdev(struct net_device *netdev)
> > +{
> > +     if (likely(netdev)) {
>
> defensive programming?

Looks that way but I'd rather have this function work with any input.

> try to avoid wrapping the entire function in an if condition,
> return early instead.

Will do.

> > +             struct funeth_priv *fp = netdev_priv(netdev);
> > +
> > +             if (fp->dl_port.devlink) {
> > +                     devlink_port_type_clear(&fp->dl_port);
> > +                     devlink_port_unregister(&fp->dl_port);
> > +             }
> > +             unregister_netdev(netdev);
> > +             fun_ktls_cleanup(fp);
> > +             fun_free_stats_area(fp);
> > +             fun_free_rss(fp);
> > +             fun_port_destroy(netdev);
> > +             free_netdev(netdev);
> > +     }
> > +}
>
>
> > +     if ((notif->link_state | notif->missed_events) & FUN_PORT_FLAG_MAC_DOWN)
> > +             netif_carrier_off(netdev);
> > +     if (notif->link_state & FUN_PORT_FLAG_NH_DOWN)
> > +             netif_dormant_on(netdev);
> > +     if (notif->link_state & FUN_PORT_FLAG_NH_UP)
> > +             netif_dormant_off(netdev);
>
> What does this do?

FW may get exclusive access to the ports in some cases and during those times
host traffic isn't serviced. Changing a port to dormant is its way of
telling the host
the port is unavailable though it has link up.

>
> > +     if (notif->link_state & FUN_PORT_FLAG_MAC_UP)
> > +             netif_carrier_on(netdev);
> > +
> > +     write_seqcount_end(&fp->link_seq);
> > +     fun_report_link(netdev);
> > +}
>
> > +static int funeth_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > +{
> > +     struct devlink *devlink;
> > +     struct fun_ethdev *ed;
> > +     struct fun_dev *fdev;
> > +     int rc;
> > +
> > +     struct fun_dev_params aqreq = {
> > +             .cqe_size_log2 = ilog2(ADMIN_CQE_SIZE),
> > +             .sqe_size_log2 = ilog2(ADMIN_SQE_SIZE),
> > +             .cq_depth      = ADMIN_CQ_DEPTH,
> > +             .sq_depth      = ADMIN_SQ_DEPTH,
> > +             .rq_depth      = ADMIN_RQ_DEPTH,
> > +             .min_msix      = 2,              /* 1 Rx + 1 Tx */
> > +             .event_cb      = fun_event_cb,
> > +             .serv_cb       = fun_service_cb,
> > +     };
>
> no empty lines between variable declarations, you can make this the
> first variable instead since it has longest lines

OK

> > +     devlink = fun_devlink_alloc(&pdev->dev);
> > +     if (!devlink) {
> > +             dev_err(&pdev->dev, "devlink alloc failed\n");
> > +             return -ENOMEM;
> > +     }
>
> > +static void __funeth_remove(struct pci_dev *pdev)
> > +{
> > +     struct fun_dev *fdev = pci_get_drvdata(pdev);
> > +     struct devlink *devlink;
> > +     struct fun_ethdev *ed;
> > +
> > +     if (!fdev)
> > +             return;
>
> defensive programming, please remove

OK

> > +     ed = to_fun_ethdev(fdev);
> > +     devlink = priv_to_devlink(ed);
> > +     fun_devlink_unregister(devlink);
> > +
> > +#ifdef CONFIG_PCI_IOV
> > +     funeth_sriov_configure(pdev, 0);
> > +#endif
> > +
> > +     fun_serv_stop(fdev);
> > +     fun_destroy_ports(ed);
> > +     fun_dev_disable(fdev);
> > +
> > +     fun_devlink_free(devlink);
> > +}
> > +
> > +static void funeth_remove(struct pci_dev *pdev)
> > +{
> > +     __funeth_remove(pdev);
> > +}
> > +
> > +static void funeth_shutdown(struct pci_dev *pdev)
> > +{
> > +     __funeth_remove(pdev);
> > +}
>
> Why the two identical wrappers?

I've dropped them both and removed __ from __funeth_remove.

> > +static struct pci_driver funeth_driver = {
> > +     .name            = KBUILD_MODNAME,
> > +     .id_table        = funeth_id_table,
> > +     .probe           = funeth_probe,
> > +     .remove          = funeth_remove,
> > +     .shutdown        = funeth_shutdown,
> > +     .sriov_configure = funeth_sriov_configure,
> > +};
> > +
> > +static int __init funeth_init(void)
> > +{
> > +     int ret;
> > +
> > +     ret = pci_register_driver(&funeth_driver);
> > +     if (ret) {
> > +             pr_err("%s pci_register_driver failed ret %d\n",
> > +                    KBUILD_MODNAME, ret);
>
> not worth it, plus you have unnecessary parenthesis here
>
> you can remove the print and use module_pci_driver()

OK.

>
> > +     }
> > +     return ret;
> > +}
> > +
> > +static void __exit funeth_exit(void)
> > +{
> > +     pci_unregister_driver(&funeth_driver);
> > +}
> > +
> > +module_init(funeth_init);
> > +module_exit(funeth_exit);
>
>
