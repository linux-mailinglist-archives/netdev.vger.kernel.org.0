Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DC16112C1
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiJ1NaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiJ1N3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:29:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EE117402;
        Fri, 28 Oct 2022 06:29:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B44E62872;
        Fri, 28 Oct 2022 13:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304ECC433B5;
        Fri, 28 Oct 2022 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666963783;
        bh=tJWcuyWfa0M4hO0xH/GKOkdSlykFGC5Dur3PYcMKMSE=;
        h=From:Subject:To:Cc:Date:From;
        b=kElKvcimYI+3W51/qaC8ZmqNJovxxYrXVLGKgdYzNS+ATld6eWcmQ8DbKLmD0pV+/
         Uk/Ww35MughQG7bdSYNCtjxrI9hqc1DUOc4E3IIEQ654a2oFeqKEfapUTp/uNiEz95
         3iHqaTm848P443TRLWAr2nr/+LLqljHv8NkzVBgtr+aaCZL4tOG7B5uSSVmkF4IuCI
         nB/ZJSGKwADFWVnj3bb7qjKrPHAvjmIuhZcHQqrl0u62gIPy+EDHYLlEGLStVO3jaW
         vxl/JEFthE64fj/cUeSAjKn7Miy+d9WRV6dkPUvs7sd4mzzd6Rlbn9fGBERNBCmlAj
         vJxq3XFqbDRWA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@kernel.org>
Subject: pull-request: wireless-next-2022-10-28
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20221028132943.304ECC433B5@smtp.kernel.org>
Date:   Fri, 28 Oct 2022 13:29:43 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here's a pull request to net-next tree, more info below. Please let me know if
there are any problems.

Kalle

The following changes since commit 10d5ea5a436da8d60cdb5845f454d595accdbce0:

  wifi: nl80211: Split memcpy() of struct nl80211_wowlan_tcp_data_token flexible array (2022-10-07 15:19:06 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-10-28

for you to fetch changes up to 80e5acb6dd72b25a6e6527443b9e9c1c3a7bcef6:

  wifi: rtl8xxxu: Fix reads of uninitialized variables hw_ctrl_s1, sw_ctrl_s1 (2022-10-21 15:54:06 +0300)

----------------------------------------------------------------
wireless-next patches for v6.2

First set of patches v6.2. mac80211 refactoring continues for Wi-Fi 7.
All mac80211 driver are now converted to use internal TX queues, this
might cause some regressions so we wanted to do this early in the
cycle.

Note: wireless tree was merged[1] to wireless-next to avoid some
conflicts with mac80211 patches between the trees. Unfortunately there
are still two smaller conflicts in net/mac80211/util.c which Stephen
also reported[2]. In the first conflict initialise scratch_len to
"params->scratch_len ?: 3 * params->len" (note number 3, not 2!) and
in the second conflict take the version which uses elems->scratch_pos.

Git diff output should like this:

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@@ -1506,7 -1648,7 +1650,7 @@@ ieee802_11_parse_elems_full(struct ieee
        const struct element *non_inherit = NULL;
        u8 *nontransmitted_profile;
        int nontransmitted_profile_len = 0;
-       size_t scratch_len = params->len;
 -      size_t scratch_len = params->scratch_len ?: 2 * params->len;
++      size_t scratch_len = params->scratch_len ?: 3 * params->len;

        elems = kzalloc(sizeof(*elems) + scratch_len, GFP_ATOMIC);
        if (!elems)

[1] https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/commit/?id=dfd2d876b3fda1790bc0239ba4c6967e25d16e91
[2] https://lore.kernel.org/all/20221020032340.5cf101c0@canb.auug.org.au/

Major changes:

mac80211

* preparation for Wi-Fi 7 Multi-Link Operation (MLO) continues

* add API to show the link STAs in debugfs

* all mac80211 drivers are now using mac80211 internal TX queues (iTXQs)

rtw89

* support 8852BE

rtl8xxxu

* support RTL8188FU

brmfmac

* support two station interfaces concurrently

bcma

* support SPROM rev 11

----------------------------------------------------------------
Alexander Wetzel (3):
      wifi: mac80211: add internal handler for wake_tx_queue
      wifi: mac80211: add wake_tx_queue callback to drivers
      wifi: mac80211: Drop support for TX push path

Benjamin Berg (3):
      wifi: mac80211: add pointer from link STA to STA
      wifi: mac80211: add API to show the link STAs in debugfs
      wifi: mac80211: include link address in debugfs

Bitterblue Smith (5):
      wifi: rtl8xxxu: Support new chip RTL8188FU
      wifi: rtl8xxxu: gen2: Turn on the rate control
      wifi: rtl8xxxu: Make some arrays const
      wifi: rtl8xxxu: Fix reading the vendor of combo chips
      wifi: rtl8xxxu: Update module description

Ching-Te Ku (1):
      wifi: rtw89: coex: move chip_ops::btc_bt_aci_imp to a generic code

Colin Ian King (1):
      wifi: rtl8xxxu: Fix reads of uninitialized variables hw_ctrl_s1, sw_ctrl_s1

Double Lo (1):
      brcmfmac: fix CERT-P2P:5.1.10 failure

Eric Huang (1):
      wifi: rtw89: parse PHY status only when PPDU is to_self

Haim Dreyfuss (1):
      wifi: mac80211: advertise TWT requester only with HW support

Ilan Peer (5):
      wifi: ieee80211: Support validating ML station profile length
      wifi: cfg80211/mac80211: Fix ML element common size calculation
      wifi: cfg80211/mac80211: Fix ML element common size validation
      wifi: mac80211: Parse station profile from association response
      wifi: mac80211: Process association status for affiliated links

Johannes Berg (21):
      wifi: mac80211: recalc station aggregate data during link switch
      wifi: cfg80211: support reporting failed links
      wifi: mac80211: wme: use ap_addr instead of deflink BSSID
      wifi: mac80211: transmit AddBA with MLD address
      wifi: nl80211: use link ID in NL80211_CMD_SET_BSS
      wifi: mac80211: use link_id in ieee80211_change_bss()
      wifi: mac80211: set internal scan request BSSID
      wifi: mac80211: fix AddBA response addressing
      wifi: mac80211: add RCU _check() link access variants
      wifi: fix multi-link element subelement iteration
      wifi: mac80211: mlme: fix null-ptr deref on failed assoc
      wifi: mac80211: check link ID in auth/assoc continuation
      wifi: mac80211: mlme: mark assoc link in output
      wifi: mac80211: change AddBA deny error message
      wifi: mac80211: don't clear DTIM period after setting it
      wifi: mac80211: prohibit IEEE80211_HT_CAP_DELAY_BA with MLO
      wifi: mac80211: agg-rx: avoid band check
      wifi: mac80211: remove support for AddBA with fragmentation
      wifi: mac80211: fix ifdef symbol name
      Merge remote-tracking branch 'wireless/main' into wireless-next
      wifi: realtek: remove duplicated wake_tx_queue

Kees Cook (1):
      wifi: atmel: Avoid clashing function prototypes

Linus Walleij (2):
      bcma: support SPROM rev 11
      bcma: gpio: Convert to immutable gpio irqchip

Peter Seiderer (1):
      wifi: mac80211: minstrel_ht: remove unused has_mrr member from struct minstrel_priv

Ping-Ke Shih (35):
      wifi: rtw89: 8852b: add BB and RF tables (1 of 2)
      wifi: rtw89: 8852b: add BB and RF tables (2 of 2)
      wifi: rtw89: 8852b: add tables for RFK
      wifi: rtw89: 8852b: add chip_ops::set_txpwr
      wifi: rtw89: 8852b: add chip_ops to read efuse
      wifi: rtw89: 8852b: add chip_ops to read phy cap
      wifi: rtw89: 8852be: add 8852BE PCI entry
      wifi: rtw89: 8852c: correct set of IQK backup registers
      wifi: rtw89: 8852c: rfk: correct miscoding delay of DPK
      wifi: rtw89: 8852c: update BB parameters to v28
      wifi: rtw89: phy: ignore warning of bb gain cfg_type 4
      wifi: rtw89: 8852c: set pin MUX to enable BT firmware log
      wifi: rtw89: add to dump TX FIFO 0/1 for 8852C
      wifi: rtw89: 8852b: set proper configuration before loading NCTL
      wifi: rtw89: 8852b: add HFC quota arrays
      wifi: rtw89: make generic functions to convert subband gain index
      wifi: rtw89: 8852b: add chip_ops::set_channel
      wifi: rtw89: 8852b: add chip_ops::set_channel_help
      wifi: rtw89: 8852b: add power on/off functions
      wifi: rtw89: 8852b: add basic baseband chip_ops
      wifi: rtw89: 8852b: add chip_ops to get thermal
      wifi: rtw89: 8852b: add chip_ops related to BT coexistence
      wifi: rtw89: 8852b: add chip_ops to query PPDU
      wifi: rtw89: 8852b: add chip_ops to configure TX/RX path
      wifi: rtw89: 8852b: add functions to control BB to assist RF calibrations
      wifi: rtw89: 8852b: add basic attributes of chip_info
      wifi: rtw89: 8852b: rfk: add DACK
      wifi: rtw89: 8852b: rfk: add RCK
      wifi: rtw89: 8852b: rfk: add RX DCK
      wifi: rtw89: 8852b: rfk: add IQK
      wifi: rtw89: 8852b: rfk: add TSSI
      wifi: rtw89: 8852b: rfk: add DPK
      wifi: rtw89: 8852b: add chip_ops related to RF calibration
      wifi: rtw89: phy: add dummy C2H handler to avoid warning message
      wifi: rtw89: 8852b: add 8852be to Makefile and Kconfig

Po-Hao Huang (2):
      wifi: rtw89: correct 6 GHz scan behavior
      wifi: rtw89: fix wrong bandwidth settings after scan

Prasanna Kerekoppa (1):
      brcmfmac: Fix AP interface delete issue

Ramesh Rangavittal (1):
      brcmfmac: Fix authentication latency caused by OBSS stats survey

Vinayak Yadawad (1):
      cfg80211: Update Transition Disable policy during port authorization

Wright Feng (7):
      brcmfmac: Add dump_survey cfg80211 ops for HostApd AutoChannelSelection
      brcmfmac: fix firmware trap while dumping obss stats
      brcmfmac: add a timer to read console periodically in PCIE bus
      brcmfmac: return error when getting invalid max_flowrings from dongle
      brcmfmac: dump dongle memory when attaching failed
      brcmfmac: add creating station interface support
      brcmfmac: support station interface creation version 1, 2 and 3

Zong-Zhe Yang (2):
      wifi: rtw89: phy: make generic txpwr setting functions
      wifi: rtw89: debug: txpwr_table considers sign

 drivers/bcma/driver_gpio.c                         |     8 +-
 drivers/bcma/sprom.c                               |     2 +-
 drivers/net/wireless/admtek/adm8211.c              |     1 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |     1 +
 drivers/net/wireless/ath/ath11k/mac.c              |     1 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |     1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |     1 +
 drivers/net/wireless/ath/carl9170/main.c           |     1 +
 drivers/net/wireless/ath/wcn36xx/main.c            |     1 +
 drivers/net/wireless/atmel/at76c50x-usb.c          |     1 +
 drivers/net/wireless/atmel/atmel.c                 |   164 +-
 drivers/net/wireless/broadcom/b43/main.c           |     1 +
 drivers/net/wireless/broadcom/b43legacy/main.c     |     1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |     6 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   546 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |     3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |     1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |     3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |     4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   139 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |     2 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |     1 +
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |     1 +
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |     1 +
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |     1 +
 drivers/net/wireless/intersil/p54/main.c           |     1 +
 drivers/net/wireless/mac80211_hwsim.c              |     1 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |     1 +
 drivers/net/wireless/marvell/mwl8k.c               |     1 +
 drivers/net/wireless/mediatek/mt7601u/main.c       |     1 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |     1 +
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |     1 +
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |     1 +
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |     1 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |     7 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |     2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    64 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |  1679 ++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |    11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    13 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |     3 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |    11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   184 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    19 +
 drivers/net/wireless/realtek/rtlwifi/core.c        |     1 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |    14 +
 drivers/net/wireless/realtek/rtw89/Makefile        |     9 +
 drivers/net/wireless/realtek/rtw89/coex.c          |     9 +-
 drivers/net/wireless/realtek/rtw89/core.c          |     3 +
 drivers/net/wireless/realtek/rtw89/core.h          |    26 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    33 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |    29 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |     1 +
 drivers/net/wireless/realtek/rtw89/mac.c           |     3 +
 drivers/net/wireless/realtek/rtw89/mac.h           |     5 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   198 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    80 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |   192 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   159 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.h      |     1 -
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |  2436 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.h      |   137 +
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |  4174 ++++
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.h  |    25 +
 .../wireless/realtek/rtw89/rtw8852b_rfk_table.c    |   794 +
 .../wireless/realtek/rtw89/rtw8852b_rfk_table.h    |    62 +
 .../net/wireless/realtek/rtw89/rtw8852b_table.c    | 22877 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8852b_table.h    |    30 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    64 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   208 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.h      |     1 -
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |     5 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    |   988 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |     1 +
 drivers/net/wireless/silabs/wfx/main.c             |     1 +
 drivers/net/wireless/st/cw1200/main.c              |     1 +
 drivers/net/wireless/ti/wl1251/main.c              |     1 +
 drivers/net/wireless/ti/wlcore/main.c              |     1 +
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |     1 +
 drivers/staging/vt6655/device_main.c               |     1 +
 drivers/staging/vt6656/main_usb.c                  |     1 +
 include/linux/ieee80211.h                          |    56 +-
 include/net/cfg80211.h                             |    13 +-
 include/net/mac80211.h                             |    73 +-
 include/uapi/linux/nl80211.h                       |     3 +
 net/mac80211/agg-rx.c                              |    25 +-
 net/mac80211/agg-tx.c                              |     2 +-
 net/mac80211/cfg.c                                 |    43 +-
 net/mac80211/debugfs.c                             |     4 +-
 net/mac80211/debugfs_netdev.c                      |     3 +-
 net/mac80211/debugfs_sta.c                         |   148 +-
 net/mac80211/debugfs_sta.h                         |    12 +
 net/mac80211/driver-ops.c                          |    27 +-
 net/mac80211/driver-ops.h                          |    16 +
 net/mac80211/ieee80211_i.h                         |    30 +-
 net/mac80211/iface.c                               |    69 +-
 net/mac80211/link.c                                |    17 +
 net/mac80211/main.c                                |    23 +-
 net/mac80211/mlme.c                                |   131 +-
 net/mac80211/rc80211_minstrel_ht.c                 |     3 -
 net/mac80211/rc80211_minstrel_ht.h                 |     1 -
 net/mac80211/rx.c                                  |     3 -
 net/mac80211/sta_info.c                            |   110 +-
 net/mac80211/sta_info.h                            |     7 +
 net/mac80211/tdls.c                                |     1 -
 net/mac80211/tx.c                                  |    30 +-
 net/mac80211/util.c                                |   249 +-
 net/mac80211/wme.c                                 |    63 +-
 net/mac80211/wme.h                                 |     4 +-
 net/wireless/core.h                                |     5 +-
 net/wireless/mlme.c                                |     4 +
 net/wireless/nl80211.c                             |    17 +-
 net/wireless/nl80211.h                             |     3 +-
 net/wireless/sme.c                                 |    26 +-
 net/wireless/util.c                                |     4 +-
 122 files changed, 35592 insertions(+), 1106 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_table.h
