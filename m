Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E480928780E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgJHPvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHPvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:51:17 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F99AC061755;
        Thu,  8 Oct 2020 08:51:17 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d23so2959376pll.7;
        Thu, 08 Oct 2020 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dB+dyquvrxBl9MA5sZBZwNlG/CVjWHyac1YjWH8pwgY=;
        b=Si99gxCbkmBdRodTsho0E+1GuiwANjnH7Z1eHoMIyehw5PlyHU7/4YKRi6wg37CaYV
         sgr3kFjzqyelC5qE2by/dNu0F3080ZX7DjlOIw2Nc5I7A4D1iM5x0ChQPrnST5yiuEo2
         Y87qoK83OfaJ9IuZscIc+q8nK224lVcHCDvLvPbNyFc4dSel0IcxgpfpLledoaW0NWOi
         coglXmkJ2vPEgYh+Zi746Wex3vqKlcf+EFxMZVltCD90F6xoXdLx4m0231rV9uEtiRtO
         yK5ItKoj5T0w8urzFIV1MNMnSV3/ZSG7q5CPA2I3T6ObzLLKRQ4dFueg5TFBmx0yOuHa
         unIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dB+dyquvrxBl9MA5sZBZwNlG/CVjWHyac1YjWH8pwgY=;
        b=EJn+stsd2tj6Pi0QqCcrVl1jsOS9Qa6HctCROm5CjKEc/zEKtmnaT9vpzUWyRRzWnG
         5jN/5izkHH+nxmzsWCOQH5Q+6byG/VD3xCR85mPt8aNnamBdM9V1Mrby5P0F+F7dPUnq
         QS0hBzBiSWDrInb1C0jAQPe9tSMmuJcpxjoCvDaaw9byNXFee8U+PbYs5N6fc9vsqvMO
         rAd138Bh2eJkQu7MqpiNM2QrxNQ7WyXnTSZfnd77VEmxp1EcQF2Giqt3OiucPP/yLxUu
         56a5NWwZBJd+8ZKOjV2fdv3S+Y/ydvCewwyTZSCN/kg+1tDDYFQM8tZWfhO+qBzX/Rt1
         FqRg==
X-Gm-Message-State: AOAM532pSD1XlzRnLZO/4tLAm7ZDOaH54AxfY6E3LxLnxON2/Eq50tqk
        7lUBeE7w8VfIYsgy2653utQ=
X-Google-Smtp-Source: ABdhPJxZvB4UjlY8ImXduAnET9YJ44S6oR9ivNFC/UT3tq6J9iWq7CS/9SMGgSgTIohrGleNW7GW+w==
X-Received: by 2002:a17:902:b418:b029:d3:82a5:4d75 with SMTP id x24-20020a170902b418b02900d382a54d75mr8499204plr.42.1602172276446;
        Thu, 08 Oct 2020 08:51:16 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id d128sm7854430pfd.94.2020.10.08.08.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:51:15 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, brcm80211-dev-list@cypress.com,
        b43-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH net 000/117] net: avoid to remove module when its debugfs is being used
Date:   Thu,  8 Oct 2020 15:48:51 +0000
Message-Id: <20201008155048.17679-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When debugfs file is opened, its module should not be removed until
it's closed.
Because debugfs internally uses the module's data.
So, it could access freed memory.

In order to avoid panic, it just sets .owner to THIS_MODULE.
So that all modules will be held when its debugfs file is opened.


Test commands:
cat <<EOF > open.c
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
        int fd = open(argv[1], O_RDONLY);

        if(fd < 0) {
                printf("failed to open\n");
                return 1;
        }

        usleep(3000000);

        close(fd);
        return 0;
}
EOF
gcc -o open open.c
modprobe netdevsim
echo 1 > /sys/bus/netdevsim/new_device
./open /sys/kernel/debug/netdevsim/netdevsim1/take_snapshot &
modprobe -rv netdevsim

Splat looks like:
[  115.765838][  T713] BUG: unable to handle page fault for address: fffffbfff8077fa0
[  115.768324][  T713] #PF: supervisor read access in kernel mode
[  115.770196][  T713] #PF: error_code(0x0000) - not-present page
[  115.772056][  T713] PGD 1237ee067 P4D 1237ee067 PUD 123642067 PMD 117501067 PTE 0
[  115.774455][  T713] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  115.776429][  T713] CPU: 1 PID: 713 Comm: open Not tainted 5.9.0-rc8+ #756
[  115.778641][  T713] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  115.781726][  T713] RIP: 0010:full_proxy_release+0xca/0x290
[  115.783522][  T713] Code: c1 ea 03 80 3c 02 00 0f 85 60 01 00 00 49 8d bc 24 80 00 00 00 4c 8b 73 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 71 01 00 00 49 8b 84 24 80 00 00 00 48 85 c0 0f
[  115.789724][  T713] RSP: 0018:ffff8880bad97e38 EFLAGS: 00010a06
[  115.791635][  T713] RAX: dffffc0000000000 RBX: ffff88810805de00 RCX: ffff88810805de28
[  115.794153][  T713] RDX: 1ffffffff8077fa0 RSI: ffff88810805de00 RDI: ffffffffc03bfd00
[  115.796682][  T713] RBP: ffff8880a60abd20 R08: ffff8880a60abd20 R09: ffff8880bb86e920
[  115.799188][  T713] R10: ffff8880bad97e78 R11: ffffed1016e5ab9d R12: ffffffffc03bfc80
[  115.801703][  T713] R13: ffff88810805de28 R14: ffff88810d0ac100 R15: ffff8880bb86e920
[  115.804204][  T713] FS:  00007fb71e5fb4c0(0000) GS:ffff888118e00000(0000) knlGS:0000000000000000
[  115.807018][  T713] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  115.809077][  T713] CR2: fffffbfff8077fa0 CR3: 00000000b8784005 CR4: 00000000003706e0
[  115.811588][  T713] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  115.814089][  T713] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  115.816573][  T713] Call Trace:
[  115.817620][  T713]  __fput+0x1ff/0x820
[  115.818886][  T713]  ? trace_hardirqs_on+0x45/0x190
[  115.820459][  T713]  task_work_run+0xd3/0x170
[  115.821876][  T713]  exit_to_user_mode_prepare+0x15b/0x160
[  115.823637][  T713]  syscall_exit_to_user_mode+0x44/0x270
[  115.825364][  T713]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  115.827857][  T713] RIP: 0033:0x7fb71e1019e4
[ ... ]


Taehee Yoo (117):
  mac80211: set .owner to THIS_MODULE in debugfs_netdev.c
  mac80211: set rcname_ops.owner to THIS_MODULE
  mac80211: set minstrel_ht_stat_fops.owner to THIS_MODULE
  mac80211: set minstrel_ht_stat_csv_fops.owner to THIS_MODULE
  mac80211: set KEY_OPS.owner to THIS_MODULE
  mac80211: set KEY_OPS_W.owner to THIS_MODULE
  mac80211: set KEY_CONF_OPS.owner to THIS_MODULE
  mac80211: set STA_OPS.owner to THIS_MODULE
  mac80211: set STA_OPS_RW.owner to THIS_MODULE
  mac80211: set DEBUGFS_READONLY_FILE_OPS.owner to THIS_MODULE
  mac80211: set aqm_ops.owner to THIS_MODULE
  mac80211: debugfs: set airtime_flags_ops.owner to THIS_MODULE
  mac80211: set aql_txq_limit_ops.owner to THIS_MODULE
  mac80211: set force_tx_status_ops.owner to THIS_MODULE
  mac80211: set reset_ops.owner to THIS_MODULE
  mac80211: set DEBUGFS_DEVSTATS_FILE.owner to THIS_MODULE
  mac80211/cfg80211: set DEBUGFS_READONLY_FILE.owner to THIS_MODULE
  cfg80211: set ht40allow_map_ops.owner to THIS_MODULE
  net: hsr: set hsr_fops.owner to THIS_MODULE
  batman-adv: set batadv_log_fops.owner to THIS_MODULE
  6lowpan: iphc: set lowpan_ctx_pfx_fops.owner to THIS_MODULE
  netdevsim: set nsim_dev_health_break_fops.owner to THIS_MODULE
  netdevsim: set nsim_udp_tunnels_info_reset_fops.owner to THIS_MODULE
  netdevsim: set nsim_dev_take_snapshot_fops.owner to THIS_MODULE
  netdevsim: set nsim_dev_trap_fa_cookie_fops.owner to THIS_MODULE
  ieee802154: set test_int_fops.owner to THIS_MODULE
  i2400m: set i2400m_rx_stats_fops.owner to THIS_MODULE
  i2400m: set i2400m_tx_stats_fops.owner to THIS_MODULE
  dpaa2-eth: set dpaa2_dbg_cpu_ops.owner to THIS_MODULE
  dpaa2-eth: set dpaa2_dbg_fq_ops.owner to THIS_MODULE
  dpaa2-eth: set dpaa2_dbg_ch_ops.owner to THIS_MODULE
  wl1271: set DEBUGFS_READONLY_FILE.owner to THIS_MODULE
  wl1271: set DEBUGFS_FWSTATS_FILE.owner to THIS_MODULE
  wlcore: set DEBUGFS_FWSTATS_FILE_ARRAY.owner to THIS_MODULE
  wl12xx: set DEBUGFS_FWSTATS_FILE_ARRAY.owner to THIS_MODULE
  wl12xx: set DEBUGFS_READONLY_FILE.owner to THIS_MODULE
  wl12xx: set tx_queue_len_ops.owner to THIS_MODULE
  wl1251: set tx_queue_status_ops.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_scale_table_ops.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
  iwlwifi: set DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
  iwlwifi: set DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
  iwlwifi: set DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_scale_table_ops.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
  iwlwifi: mvm: set rs_sta_dbgfs_drv_tx_stats_ops.owner to THIS_MODULE
  iwlwifi: mvm: set .owner to THIS_MODULE in debugfs.h
  iwlwifi: mvm: set iwl_dbgfs_mem_ops.owner to THIS_MODULE
  iwlwifi: runtime: set _FWRT_DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
  iwlwifi: runtime: set _FWRT_DEBUGFS_READ_WRITE_FILE_OPS.owner to
    THIS_MODULE
  iwlwifi: runtime: set _FWRT_DEBUGFS_WRITE_FILE_OPS.owner to
    THIS_MODULE
  iwlwifi: set DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
  iwlwifi: set DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
  iwlwifi: set DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_scale_table_ops.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
  iwlwifi: set rs_sta_dbgfs_rate_scale_data_ops.owner to THIS_MODULE
  iwlagn: set rs_sta_dbgfs_rate_scale_data_ops.owner to THIS_MODULE
  iwlagn: set DEBUGFS_READ_FILE_OPS.owner to THIS_MODULE
  iwlagn: set DEBUGFS_WRITE_FILE_OPS.owner to THIS_MODULE
  iwlagn: set DEBUGFS_READ_WRITE_FILE_OPS.owner to THIS_MODULE
  rtlwifi: set file_ops_common.owner to THIS_MODULE
  ath11k: set fops_extd_tx_stats.owner to THIS_MODULE
  ath11k: set fops_extd_rx_stats.owner to THIS_MODULE
  ath11k: set fops_pktlog_filter.owner to THIS_MODULE
  ath11k: set fops_simulate_radar.owner to THIS_MODULE
  ath10k: set fops_pktlog_filter.owner to THIS_MODULE
  ath10k: set fops_quiet_period.owner to THIS_MODULE
  ath10k: set fops_btcoex.owner to THIS_MODULE
  ath10k: set fops_enable_extd_tx_stats.owner to THIS_MODULE
  ath10k: set fops_peer_stats.owner to THIS_MODULE
  wcn36xx: set fops_wcn36xx_bmps.owner to THIS_MODULE
  wcn36xx: set fops_wcn36xx_dump.owner to THIS_MODULE
  wireless: set fops_ioblob.owner to THIS_MODULE
  wil6210: set fops_rxon.owner to THIS_MODULE
  wil6210: set fops_rbufcap.owner to THIS_MODULE
  wil6210: set fops_back.owner to THIS_MODULE
  wil6210: set fops_pmccfg.owner to THIS_MODULE
  wil6210: set fops_pmcdata.owner to THIS_MODULE
  wil6210: set fops_pmcring.owner to THIS_MODULE
  wil6210: set fops_txmgmt.owner to THIS_MODULE
  wil6210: set fops_wmi.owner to THIS_MODULE
  wil6210: set fops_recovery.owner to THIS_MODULE
  wil6210: set fops_tx_latency.owner to THIS_MODULE
  wil6210: set fops_link_stats.owner to THIS_MODULE
  wil6210: set fops_link_stats_global.owner to THIS_MODULE
  wil6210: set fops_led_cfg.owner to THIS_MODULE
  wil6210: set fops_led_blink_time.owner to THIS_MODULE
  wil6210: set fops_fw_capabilities.owner to THIS_MODULE
  wil6210: set fops_fw_version.owner to THIS_MODULE
  wil6210: set fops_suspend_stats.owner to THIS_MODULE
  wil6210: set fops_compressed_rx_status.owner to THIS_MODULE
  cw1200: set fops_wsm_dumps.owner to THIS_MODULE
  brcmfmac: set bus_reset_fops.owner to THIS_MODULE
  b43legacy: set B43legacy_DEBUGFS_FOPS.owner to THIS_MODULE
  b43: set B43_DEBUGFS_FOPS.owner to THIS_MODULE
  wireless: mwifiex: set .owner to THIS_MODULE in debugfs.c
  net: mt7601u: set fops_ampdu_stat.owner to THIS_MODULE
  net: mt7601u: set fops_eeprom_param.owner to THIS_MODULE
  mt76: mt7615: set fops_ampdu_stat.owner to THIS_MODULE
  mt76: mt7603: set fops_ampdu_stat.owner to THIS_MODULE
  mt76: set fops_ampdu_stat.owner to THIS_MODULE
  mt76: set fops_tx_stats.owner to THIS_MODULE
  mt76: mt7915: set fops_sta_stats.owner to THIS_MODULE
  Bluetooth: set dut_mode_fops.owner to THIS_MODULE
  Bluetooth: set vendor_diag_fops.owner to THIS_MODULE
  Bluetooth: set force_bredr_smp_fops.owner to THIS_MODULE
  Bluetooth: set test_smp_fops.owner to THIS_MODULE
  Bluetooth: set use_debug_keys_fops.owner to THIS_MODULE
  Bluetooth: set sc_only_mode_fops.owner to THIS_MODULE
  Bluetooth: set DEFINE_QUIRK_ATTRIBUTE.owner to THIS_MODULE
  Bluetooth: set ssp_debug_mode_fops.owner to THIS_MODULE
  Bluetooth: set force_static_address_fops.owner to THIS_MODULE
  Bluetooth: set force_no_mitm_fops.owner to THIS_MODULE
  Bluetooth: 6LoWPAN: set lowpan_control_fops.owner to THIS_MODULE
  Bluetooth: set test_ecdh_fops.owner to THIS_MODULE

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  3 +++
 drivers/net/ieee802154/ca8210.c               |  3 ++-
 drivers/net/netdevsim/dev.c                   |  2 ++
 drivers/net/netdevsim/health.c                |  1 +
 drivers/net/netdevsim/udp_tunnels.c           |  1 +
 drivers/net/wimax/i2400m/debugfs.c            |  2 ++
 drivers/net/wireless/ath/ath10k/debug.c       | 15 ++++++++++-----
 drivers/net/wireless/ath/ath11k/debug.c       | 10 +++++++---
 drivers/net/wireless/ath/wcn36xx/debug.c      |  2 ++
 drivers/net/wireless/ath/wil6210/debugfs.c    | 19 +++++++++++++++++++
 drivers/net/wireless/broadcom/b43/debugfs.c   |  1 +
 .../net/wireless/broadcom/b43legacy/debugfs.c |  1 +
 .../broadcom/brcm80211/brcmfmac/core.c        |  1 +
 drivers/net/wireless/intel/iwlegacy/3945-rs.c |  1 +
 drivers/net/wireless/intel/iwlegacy/4965-rs.c |  3 +++
 drivers/net/wireless/intel/iwlegacy/debug.c   |  3 +++
 .../net/wireless/intel/iwlwifi/dvm/debugfs.c  |  3 +++
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c   |  3 +++
 .../net/wireless/intel/iwlwifi/fw/debugfs.c   |  3 +++
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |  1 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs.h  |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c   |  3 +++
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  3 +++
 .../net/wireless/marvell/mwifiex/debugfs.c    |  3 +++
 .../wireless/mediatek/mt76/mt7603/debugfs.c   |  1 +
 .../wireless/mediatek/mt76/mt7615/debugfs.c   |  1 +
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  |  2 ++
 .../wireless/mediatek/mt76/mt7915/debugfs.c   |  2 ++
 .../net/wireless/mediatek/mt7601u/debugfs.c   |  2 ++
 drivers/net/wireless/realtek/rtlwifi/debug.c  |  1 +
 drivers/net/wireless/st/cw1200/debug.c        |  1 +
 drivers/net/wireless/ti/wl1251/debugfs.c      |  4 ++++
 drivers/net/wireless/ti/wlcore/debugfs.h      |  3 +++
 net/6lowpan/debugfs.c                         |  1 +
 net/batman-adv/log.c                          |  1 +
 net/bluetooth/6lowpan.c                       |  1 +
 net/bluetooth/hci_core.c                      |  2 ++
 net/bluetooth/hci_debugfs.c                   |  6 ++++++
 net/bluetooth/selftest.c                      |  1 +
 net/bluetooth/smp.c                           |  2 ++
 net/hsr/hsr_debugfs.c                         |  1 +
 net/mac80211/debugfs.c                        |  7 +++++++
 net/mac80211/debugfs_key.c                    |  3 +++
 net/mac80211/debugfs_netdev.c                 |  1 +
 net/mac80211/debugfs_sta.c                    |  2 ++
 net/mac80211/rate.c                           |  1 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c    |  2 ++
 net/wireless/debugfs.c                        |  2 ++
 48 files changed, 131 insertions(+), 9 deletions(-)

-- 
2.17.1

