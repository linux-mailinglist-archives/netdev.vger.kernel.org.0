Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2608BA097B
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfH1Sci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:32:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33475 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfH1Sci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 14:32:38 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so1632879iog.0
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 11:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQp41Plpp9rXk68mL9tjFcokYswNi2jbS5GvNm+mTfA=;
        b=fRpNX5k76HwcOWlUk+P3HZzQLe22IDkKoPnhRK3r9YtaheMh6HPvJUYIhDClTyJRMO
         pcXB32YzkPdDEsFKVTF9MfihF7UcwksyR95KewnJbzU1Kl3mHNR/WmRHKbw6B5gaLbcA
         4fcSOiVE9irOzBmhuxa56BOI17kD4dSYLuxd5gdLZI3iiVDXFhfzbIFuRiRHQbALoHog
         FbSAWUIDUVZVNThlKY8KVADqI2cuvcVqeNHmt7L3IVriiJXlufrQkUnofLCVvxNDUAeI
         kvxGnjuflv33aXY9Iv8UMTLNc7V7gf6w/fJ2PsgzZ+cP5A1E8ebXZLn2CaIxBdqwsgXN
         dFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQp41Plpp9rXk68mL9tjFcokYswNi2jbS5GvNm+mTfA=;
        b=VCLtN878slql5t+RSFSoP4vEURlfLI3UfRtHHN6K5G3l5v+J4bArYk4ACiDHwVV4dV
         FAyvYNA263lf8KdeedFx1Tm9PKcmZrJIjv3usKUMO+nZ5796XcNFu7ENtnujV8XVD/WG
         PfdEyWp3/FwwmQMmeaJ010llS/kVAP7J6pRjgmzDIgcpkhZT6O/xqd6g2HF2xmZZuotE
         I5GgmsXyMpBPYdOJ3O8TbPAcW05leCWwcct6kCVMphu0OR6aS/COYvxd3qABwQNF3ZWb
         obH0PSsRymzehdSbHSs7lpUyCXEL7dSNeOgvSHulPGjSYRZlIrWDT6hJejUT8w5ciqrR
         UbyA==
X-Gm-Message-State: APjAAAXEiPAjUGpTzGyUN95J7FLGEELQVPPvmR+6qkmEl1zB4gk0k0Ox
        FmKteISwGpy+YXhdXISuWfJgjYIIh9IX/w5gHqE=
X-Google-Smtp-Source: APXvYqwUMrjWE91MPS5vCLYmXRDkItZ7vYbIMkvnDkVwGaGDyRe9RCD8SFaWL+9sOTRUI9h/R2UGdymn5+eKFcyothI=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr6120654ioj.64.1567017156782;
 Wed, 28 Aug 2019 11:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190828173912.29293-1-bob.beckett@collabora.com>
In-Reply-To: <20190828173912.29293-1-bob.beckett@collabora.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 28 Aug 2019 11:32:14 -0700
Message-ID: <CAKgT0UfeAgS-Jh69AdRNUzG2qt_gcHrLP1DP1v-5bxpY8UwpZg@mail.gmail.com>
Subject: Re: [PATCH] igb: add rx drop enable attribute
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 10:40 AM Robert Beckett
<bob.beckett@collabora.com> wrote:
>
> To allow userland to enable or disable dropping packets when descriptor
> ring is exhausted, add an adapter rx_drop_en attribute.
>
> This can be used in conjunction with flow control to mitigate packet storms
> (e.g. due to network loop or DoS) by forcing the network adapter to send
> pause frames whenever the ring is close to exhaustion.
>
> By default this will maintain previous behaviour of enabling dropping of
> packets during ring buffer exhaustion.
> Some use cases prefer to not drop packets upon exhaustion, but instead
> use flow control to limit ingress rates and ensure no dropped packets.
> This is useful when the host CPU cannot keep up with packet delivery,
> but data delivery is more important than throughput via multiple queues.
>
> Userland can write 0 to rx_drop_en to disable packet dropping via udev.
>
> Signed-off-by: Robert Beckett <bob.beckett@collabora.com>

Instead of doing this as a sysfs file it might be better to just do
this as an ethtool private flag like what I did for "legacy-rx".

> ---
>  drivers/net/ethernet/intel/igb/igb.h      |  1 +
>  drivers/net/ethernet/intel/igb/igb_main.c | 60 ++++++++++++++++++++++-
>  2 files changed, 60 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
> index ca54e268d157..efada57a05e1 100644
> --- a/drivers/net/ethernet/intel/igb/igb.h
> +++ b/drivers/net/ethernet/intel/igb/igb.h
> @@ -594,6 +594,7 @@ struct igb_adapter {
>         struct igb_mac_addr *mac_table;
>         struct vf_mac_filter vf_macs;
>         struct vf_mac_filter *vf_mac_list;
> +       bool rx_drop_enable; /* drop packets when descriptor ring exhausted */
>  };
>
>  /* flags controlling PTP/1588 function */
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 105b0624081a..5b499130c3f5 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -2982,6 +2982,54 @@ static s32 igb_init_i2c(struct igb_adapter *adapter)
>         return status;
>  }
>
> +static ssize_t rx_drop_en_show(struct device *dev,
> +                              struct device_attribute *attr,
> +                              char *buf)
> +
> +{
> +       struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
> +       struct igb_adapter *adapter = netdev_priv(netdev);
> +
> +       if (adapter->rx_drop_enable)
> +               return sprintf(buf, "1\n");
> +       else
> +               return sprintf(buf, "0\n");
> +}
> +
> +static ssize_t rx_drop_en_store(struct device *dev,
> +                               struct device_attribute *attr,
> +                               const char *buf, size_t count)
> +{
> +       struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
> +       struct igb_adapter *adapter = netdev_priv(netdev);
> +       struct e1000_hw *hw = &adapter->hw;
> +       int queue_idx, reg_idx;
> +       bool val;
> +       u32 srrctl;
> +       int ret;
> +
> +       ret = kstrtobool(buf, &val);
> +       if (ret < 0)
> +               return ret;
> +
> +       adapter->rx_drop_enable = val;
> +
> +       /* set for each currently active ring */
> +       for (queue_idx = 0; queue_idx < adapter->num_rx_queues; queue_idx++) {
> +               reg_idx = adapter->rx_ring[queue_idx]->reg_idx;
> +               srrctl = rd32(E1000_SRRCTL(reg_idx));
> +               if (val == 0)
> +                       srrctl &= ~E1000_SRRCTL_DROP_EN;
> +               else
> +                       srrctl |= E1000_SRRCTL_DROP_EN;
> +               wr32(E1000_SRRCTL(reg_idx), srrctl);
> +       }
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR_RW(rx_drop_en);
> +
>  /**
>   *  igb_probe - Device Initialization Routine
>   *  @pdev: PCI device information struct
> @@ -3329,6 +3377,9 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 goto err_eeprom;
>         }
>
> +       /* Add adapter attributes */
> +       device_create_file(&pdev->dev, &dev_attr_rx_drop_en);
> +
>         /* let the f/w know that the h/w is now under the control of the
>          * driver.
>          */
> @@ -3655,6 +3706,9 @@ static void igb_remove(struct pci_dev *pdev)
>          */
>         igb_release_hw_control(adapter);
>
> +       /* Remove addapter attributes */
> +       device_remove_file(&pdev->dev, &dev_attr_rx_drop_en);
> +
>  #ifdef CONFIG_PCI_IOV
>         igb_disable_sriov(pdev);
>  #endif
> @@ -3753,6 +3807,9 @@ static void igb_init_queue_configuration(struct igb_adapter *adapter)
>         max_rss_queues = igb_get_max_rss_queues(adapter);
>         adapter->rss_queues = min_t(u32, max_rss_queues, num_online_cpus());
>
> +       if (adapter->vfs_allocated_count || adapter->rss_queues > 1)
> +               adapter->rx_drop_enable = true;
> +
>         igb_set_flag_queue_pairs(adapter, max_rss_queues);
>  }
>
> @@ -4504,7 +4561,8 @@ void igb_configure_rx_ring(struct igb_adapter *adapter,
>         if (hw->mac.type >= e1000_82580)
>                 srrctl |= E1000_SRRCTL_TIMESTAMP;
>         /* Only set Drop Enable if we are supporting multiple queues */
> -       if (adapter->vfs_allocated_count || adapter->num_rx_queues > 1)
> +       if (adapter->rx_drop_enable &&
> +               (adapter->vfs_allocated_count || adapter->num_rx_queues > 1))

Isn't this redundant due to the code above where you were overriding
the value and setting it to true based on the vfs_allocated_count and
num_rx_queues? You could probably just use rx_drop_enable by itself.

>                 srrctl |= E1000_SRRCTL_DROP_EN;
>
>         wr32(E1000_SRRCTL(reg_idx), srrctl);
> --
> 2.18.0
>
