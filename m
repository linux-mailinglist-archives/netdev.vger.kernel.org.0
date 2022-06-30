Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B3A5617AC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiF3KYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbiF3KYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:24:13 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6965D7E029
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:23:39 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-317a66d62dfso174210967b3.7
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbnlfACHSMD2kFp2nkR9i85EQl5tAVPGzguGHV0sdHk=;
        b=e2jXjAyJXC6mG92CBxrGO58oqtaV37I1fe1bSVpuNM4nnb9BHM2jyyXedb503XdFQH
         QJdkVKBuiwGJUmiBJksvpW6BUFmf3dMzzgyz/A3eri5sXm0kOe7d8RNB+/CrPIQB+YB+
         GWzeXAJ69dc1n39+VA0ypOSyXDjEfFGeemHj9sLtH1TfEzaBPmlkJHG1on5A0IhJdfRJ
         Rlx2SYgl0eMegOeO5UPL+GRJGV3Yx4p9JlcI4jiMSgX7mV0eLszZLbwX4g7MTyvSCZww
         Ac0dSlotFBBwqO8VeZDCa00cTJzo8ic8jmE/yrkETJixIG1BclYrvPKEeDDjrFs7NyZY
         YhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbnlfACHSMD2kFp2nkR9i85EQl5tAVPGzguGHV0sdHk=;
        b=V+r01QaZQR9MAyn+/O9kY1v8cfmyOHC5/4mgiX9+gugBQEokso/40neojcqrxW/Vvm
         H+CW9WKuOz7huMhkc8XZnEe8RK1F8SqR8KhAWiH4XXsJOqGz2dwZbR8Smty9H4fLQ5el
         +itAdU5nTYBUMkizrwK/+Xb3ZAo0xtMbI6kWe4XJPdZ4OURqwdIIleGLtz+E8uZ9XeZj
         XsNHdllYq+En6wjYn+2GE/gSQ+Q97lfbNTn2ESDIERBhppt9FTE1OJXK1HZHgFKHnHw/
         7g/wakoc0kyUbjw/ZQ7YLjJwn4NNp/3/Xsa5IkDC3uRKce5oeorZ74nb7viXP3XU6fhp
         JyXA==
X-Gm-Message-State: AJIora+sP8hzKdjMNf3+PN8KC8c23Qs+PlUCO2FcJB8oi+GbSL41im/T
        LTiwWyeHud0w5Os52g7nc64bTyUKxJeadqEO8jn0SA==
X-Google-Smtp-Source: AGRyM1vCYKo3K9x+FRI+mTpzo7P34FXDjurwnb0nZ6G+rEltQim+oN+awgAZWEL3q5wp/n6GMgRh5F48RRkZOyi1vSI=
X-Received: by 2002:a81:1809:0:b0:317:c014:f700 with SMTP id
 9-20020a811809000000b00317c014f700mr9808354ywy.255.1656584618094; Thu, 30 Jun
 2022 03:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
In-Reply-To: <07736c2b7019b6883076a06129e06e8f7c5f7154.1656487154.git.mqaio@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jun 2022 12:23:26 +0200
Message-ID: <CANn89iLpW4zFf2ABADbMNERPFr=OrAXEMm6ZgCxYA5VpcDpYTw@mail.gmail.com>
Subject: Re: [PATCH] net: hinic: avoid kernel hung in hinic_get_stats64()
To:     Qiao Ma <mqaio@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, gustavoars@kernel.org,
        cai.huoqing@linux.dev, Aviad Krawczyk <aviad.krawczyk@huawei.com>,
        zhaochen6@huawei.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 9:28 AM Qiao Ma <mqaio@linux.alibaba.com> wrote:
>
> When using hinic device as a bond slave device, and reading device stats of
> master bond device, the kernel may hung.
>
> The kernel panic calltrace as follows:
> Kernel panic - not syncing: softlockup: hung tasks
> Call trace:
>   native_queued_spin_lock_slowpath+0x1ec/0x31c
>   dev_get_stats+0x60/0xcc
>   dev_seq_printf_stats+0x40/0x120
>   dev_seq_show+0x1c/0x40
>   seq_read_iter+0x3c8/0x4dc
>   seq_read+0xe0/0x130
>   proc_reg_read+0xa8/0xe0
>   vfs_read+0xb0/0x1d4
>   ksys_read+0x70/0xfc
>   __arm64_sys_read+0x20/0x30
>   el0_svc_common+0x88/0x234
>   do_el0_svc+0x2c/0x90
>   el0_svc+0x1c/0x30
>   el0_sync_handler+0xa8/0xb0
>   el0_sync+0x148/0x180
>
> And the calltrace of task that actually caused kernel hungs as follows:
>   __switch_to+124
>   __schedule+548
>   schedule+72
>   schedule_timeout+348
>   __down_common+188
>   __down+24
>   down+104
>   hinic_get_stats64+44 [hinic]
>   dev_get_stats+92
>   bond_get_stats+172 [bonding]
>   dev_get_stats+92
>   dev_seq_printf_stats+60
>   dev_seq_show+24
>   seq_read_iter+964
>   seq_read+220
>   proc_reg_read+164
>   vfs_read+172
>   ksys_read+108
>   __arm64_sys_read+28
>   el0_svc_common+132
>   do_el0_svc+40
>   el0_svc+24
>   el0_sync_handler+164
>   el0_sync+324
>
> When getting device stats from bond, kernel will call bond_get_stats().
> It first holds the spinlock bond->stats_lock, and then call
> hinic_get_stats64() to collect hinic device's stats.
> However, hinic_get_stats64() calls `down(&nic_dev->mgmt_lock)` to
> protect its critical section, which may schedule current task out.
> And if system is under high pressure, the task cannot be woken up
> immediately, which eventually triggers kernel hung panic.
>
> Fixes: edd384f682cc ("net-next/hinic: Add ethtool and stats")
> Signed-off-by: Qiao Ma <mqaio@linux.alibaba.com>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_dev.h  | 1 +
>  drivers/net/ethernet/huawei/hinic/hinic_main.c | 7 +++----
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> index fb3e89141a0d..1fb343d03fd5 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
> @@ -97,6 +97,7 @@ struct hinic_dev {
>
>         struct hinic_txq_stats          tx_stats;
>         struct hinic_rxq_stats          rx_stats;
> +       spinlock_t                      stats_lock;
>
>         u8                              rss_tmpl_idx;
>         u8                              rss_hash_engine;
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index 56a89793f47d..32a3d700ad26 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -125,11 +125,13 @@ static void update_nic_stats(struct hinic_dev *nic_dev)
>  {
>         int i, num_qps = hinic_hwdev_num_qps(nic_dev->hwdev);
>
> +       spin_lock(&nic_dev->stats_lock);
>         for (i = 0; i < num_qps; i++)
>                 update_rx_stats(nic_dev, &nic_dev->rxqs[i]);
>
>         for (i = 0; i < num_qps; i++)
>                 update_tx_stats(nic_dev, &nic_dev->txqs[i]);
> +       spin_unlock(&nic_dev->stats_lock);
>  }
>
>  /**
> @@ -859,13 +861,9 @@ static void hinic_get_stats64(struct net_device *netdev,
>         nic_rx_stats = &nic_dev->rx_stats;
>         nic_tx_stats = &nic_dev->tx_stats;
>
> -       down(&nic_dev->mgmt_lock);
> -
>         if (nic_dev->flags & HINIC_INTF_UP))
>                 update_nic_stats(nic_dev);
>
> -       up(&nic_dev->mgmt_lock);
> -

Note: The following is racy, because multiple threads can call
hinic_get_stats64() at the same time.
It needs a loop, see include/linux/u64_stats_sync.h for detail.

>         stats->rx_bytes   = nic_rx_stats->bytes;
>         stats->rx_packets = nic_rx_stats->pkts;
>         stats->rx_errors  = nic_rx_stats->errors;

Same remark for nic_tx_stats->{bytes|pkts|errors}

> @@ -1239,6 +1237,7 @@ static int nic_dev_init(struct pci_dev *pdev)
>
>         u64_stats_init(&tx_stats->syncp);
>         u64_stats_init(&rx_stats->syncp);
> +       spin_lock_init(&nic_dev->stats_lock);
>
>         nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
>                                                   GFP_KERNEL);
> --
> 1.8.3.1
>
