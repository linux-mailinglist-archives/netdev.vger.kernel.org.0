Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F51C47F773
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhLZPgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:36:41 -0500
Received: from marcansoft.com ([212.63.210.85]:55396 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233791AbhLZPgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 10:36:40 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B4111419C2;
        Sun, 26 Dec 2021 15:36:28 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [RFC PATCH 00/34] brcmfmac: Support Apple T2 and M1 platforms
Date:   Mon, 27 Dec 2021 00:35:50 +0900
Message-Id: <20211226153624.162281-1-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

Merry Christmas! This year Santa brings us a 34-patch series to add
proper support for the Broadcom FullMAC chips used on Apple T2 and M1
platforms:

- BCM4355C1
- BCM4364B2/B3
- BCM4377B3
- BCM4378B1
- BCM4387C2

As usual for Apple, things are ever so slightly different on these
machines from every other Broadcom platform. In particular, besides
the normal device/firmware support changes, a large fraction of this
series deals with selecting and loading the correct firmware. These
platforms use multiple dimensions for firmware selection, and the values
for these dimensions are variously sourced from DT or OTP (see the
commit message for #9 for the gory details).

This is what is included:

# 01: DT bindings (M1 platforms)

On M1 platforms, we use the device tree to provide properties for PCIe
devices like these cards. This patch re-uses the existing SDIO binding
and adds the compatibles for these PCIe chips, plus the properties we
need to correctly instantiate them:

- apple,module-instance: A codename (seemingly always an island) that
  identifies the specific platform/board. brcmfmac normally uses the
  root node compatible for this on DT platforms, but Apple have their
  own mapping/identifier here. This is prepended with `apple,` and
  becomes the base board_name for firmware selection. An alternative
  here might be to use something like brcm,board-name with the
  `apple,`-prefixed value instead, which would be more general and allow
  any DT platform to override the desired board name used when building
  firmware filenames.

- apple,antenna-sku: Specifies the specific antenna configuration in a
  produt. This would normally be filled in by the bootloader from
  device-specific configuration data. On ACPI platforms, this is
  provided via ACPI instead. This is used to build the funky Apple
  firmware filenames. Note: it seems the antenna doesn't actually matter
  for any of the above platforms (they are all aliases to the same files
  and our firmware copier collapses down this dimension), but since
  Apple do support having different firmware or NVRAM depending on
  antenna SKU, we ough to support it in case it starts mattering on a
  future platform.

- brcm,cal-blob: A calibration blob for the Wi-Fi module, specific to a
  given unit. On most platforms, this is stored in SROM on the module,
  and does not need to be provided externally, but Apple instead stores
  this in platform configuration for M1 machines and the driver needs to
  upload it to the device after initializing the firmware. This has a
  generic brcm name, since a priori this mechanism shouldn't be
  Apple-specific, although chances are only Apple do it like this so far.

# 02~09: Apple firmware selection (M1 platforms)

These patches add support for choosing firmwares (binaries, CLM blobs,
and NVRAM configs alike) using all the dimensions that Apple uses. The
firmware files are renamed to conform to the existing brcmfmac
convention. See the commit message for #9 for the gory details as to how
these filenames are constructed. The data to make the firmware selection
comes from the above DT properties and from an OTP ROM on the chips on
M1 platforms.

# 10~14: BCM4378 support (M1 T8103 platforms)

These patches make changes required to support the BCM4378 chip present
in Apple M1 (T8103) platforms. This includes adding support for passing
in the MAC address via the DT (this is standard on DT platforms) since
the chip does not have a burned-in MAC; adding support for PCIe core
revs >64 (which moved around some registers); tweaking ring buffer
sizes; and fixing a bug.

# 15~20: BCM4355/4364/4377 support (T2 platforms)

These patches add support for the chips found across T2 Mac platforms.
This includes ACPI support for fetching properties instead of using DT,
providing a buffer of entropy to the devices (required for some of the
firmwares), and adding the required IDs. This also fixes the BCM4364
firmware naming; it was added without consideration that there are two
incompatible chip revisions. To avoid this ambiguity in the future, all
the chips added by this series use firmware names ending in the revision
(apple/brcm style, that is letter+number), so that future revisions can
be added without creating confusion.

# 21~27: BCM4387 support (M1 Pro/Max T600x platforms)

These patches add support for the newer BCM4387 present in the recently
launched M1 Pro/Max platforms. This chip requires a few changes to D11
reset behavior and TCM size calculation to work properly, and it uses
newer firmware which needs support for newer firmware interfaces
in the cfg80211 support. Backwards compatibility is maintained via
feature flags discovered at runtime from information provided by the
firmware.

A note on #26: it seems this chip broke the old hack of passing the PMK
in hexdump form as a PSK, but it seems brcmfmac chips supported passing
it in binary all along. I'm not sure why it was done this way in the
Linux driver, but it seems OpenBSD always did it in binary and works
with older chips, so this should be reasonably well tested. Any further
insight as to why this was done this way would be appreciated.

# 28~31: Fixes

These are just random things I came across while developing this series.
#31 is required to avoid a compile warning in subsequent patches. None
of these are strictly required to support these chips/platforms.

# 32-34: TxCap and calibration blobs

These patches add support for uploading TxCap blobs, which are another
kind of firmware blob that Apple platforms use (T2 and M1), as well as
providing Wi-Fi calibration data from the device tree (M1).

I'm not sure what the TxCap blobs do. Given the stray function
prototype at [5], it would seem the Broadcom folks in charge of Linux
drivers also know all about Apple's fancy OTP for firmware selection
and the existence of TxCap blobs, so it would be great if you could
share any insight here ;-)

These patches are not required for the chips to function, but presumably
having proper per-device calibration data available matters, and I
assume the TxCap blobs aren't just for show either.

# On firmware

As you might expect, the firmware for these machines is not available
under a redistributable license; however, every owner of one of these
machines *is* implicitly licensed to posess the firmware, and the OS
packages containing it are available under well-known URLs on Apple's
CDN with no authentication.

Our plan to support this is to propose a platform firmware mechanism,
where platforms can provide a firmware package in the EFI system
partition along with a manifest, and distros will extract it to
/lib/firmware on boot or otherwise make it available to the kernel.

Then, on M1 platforms, our install script, which performs all the
bootloader installation steps required to run Linux on these machines in
the first place, will also take care of copying the firmware from the
base macOS image to the EFI partition. On T2 platforms, we'll provide an
analogous script that users can manually run prior to a normal EFI Linux
installation to just grab the firmware from /usr/share/firmware/wifi in
the running macOS.

There is an example firmware manifest at [1] which details the files
copied by our firmware rename script [2], as of macOS 12.0.1.

To test this series on a supported Mac today (T2 or M1), boot into macOS
and run:

$ git clone https://github.com/AsahiLinux/asahi-installer
$ cd asahi-installer/src
$ python -m firmware.wifi /usr/share/firmware/wifi firmware.tar

Then copy firmware.tar to Linux and extract it into /lib/firmware.

# Acknowledgements

This patch series was developed referencing the OpenBSD support for the
BCM4378 [3] and the bcmdhd-4359 GPL release [4], which contained some
interesting tidbits about newer chips, registers, OTP, etc.

[1] https://gist.github.com/marcan/5cfaad948e224279f09a4a79ccafd9b6
[2] https://github.com/AsahiLinux/asahi-installer/blob/main/src/firmware/wifi.py
[3] https://github.com/openbsd/src/blob/master/sys/dev/pci/if_bwfm_pci.c
[4] https://github.com/StreamUnlimited/broadcom-bcmdhd-4359/
[5] https://github.com/StreamUnlimited/broadcom-bcmdhd-4359/blob/master/dhd_pcie.h#L594

Hector Martin (34):
  dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
  brcmfmac: pcie: Declare missing firmware files in pcie.c
  brcmfmac: firmware: Support having multiple alt paths
  brcmfmac: firmware: Handle per-board clm_blob files
  brcmfmac: pcie/sdio/usb: Get CLM blob via standard firmware mechanism
  brcmfmac: firmware: Support passing in multiple board_types
  brcmfmac: pcie: Read Apple OTP information
  brcmfmac: of: Fetch Apple properties
  brcmfmac: pcie: Perform firmware selection for Apple platforms
  brcmfmac: firmware: Allow platform to override macaddr
  brcmfmac: msgbuf: Increase RX ring sizes to 1024
  brcmfmac: pcie: Fix crashes due to early IRQs
  brcmfmac: pcie: Support PCIe core revisions >= 64
  brcmfmac: pcie: Add IDs/properties for BCM4378
  ACPI / property: Support strings in Apple _DSM props
  brcmfmac: acpi: Add support for fetching Apple ACPI properties
  brcmfmac: pcie: Provide a buffer of random bytes to the device
  brcmfmac: pcie: Add IDs/properties for BCM4355
  brcmfmac: pcie: Add IDs/properties for BCM4377
  brcmfmac: pcie: Perform correct BCM4364 firmware selection
  brcmfmac: chip: Only disable D11 cores; handle an arbitrary number
  brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
  brcmfmac: cfg80211: Add support for scan params v2
  brcmfmac: feature: Add support for setting feats based on WLC version
  brcmfmac: cfg80211: Add support for PMKID_V3 operations
  brcmfmac: cfg80211: Pass the PMK in binary instead of hex
  brcmfmac: pcie: Add IDs/properties for BCM4387
  brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
  brcmfmac: pcie: Read the console on init and shutdown
  brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
  brcmfmac: fwil: Constify iovar name arguments
  brcmfmac: common: Add support for downloading TxCap blobs
  brcmfmac: pcie: Load and provide TxCap blobs
  brcmfmac: common: Add support for external calibration blobs

 .../net/wireless/brcm,bcm4329-fmac.yaml       |  32 +-
 drivers/acpi/x86/apple.c                      |  11 +-
 .../broadcom/brcm80211/brcmfmac/Makefile      |   2 +
 .../broadcom/brcm80211/brcmfmac/acpi.c        |  51 ++
 .../broadcom/brcm80211/brcmfmac/bus.h         |  20 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 175 ++++-
 .../broadcom/brcm80211/brcmfmac/chip.c        |  36 +-
 .../broadcom/brcm80211/brcmfmac/common.c      | 130 +++-
 .../broadcom/brcm80211/brcmfmac/common.h      |  12 +
 .../broadcom/brcm80211/brcmfmac/feature.c     |  49 ++
 .../broadcom/brcm80211/brcmfmac/feature.h     |   6 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 140 +++-
 .../broadcom/brcm80211/brcmfmac/firmware.h    |   2 +-
 .../broadcom/brcm80211/brcmfmac/fwil.c        |  34 +-
 .../broadcom/brcm80211/brcmfmac/fwil.h        |  28 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h  | 157 ++++-
 .../broadcom/brcm80211/brcmfmac/msgbuf.h      |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/of.c |  27 +-
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 606 +++++++++++++++---
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  41 +-
 .../broadcom/brcm80211/brcmfmac/sdio.h        |   2 +
 .../broadcom/brcm80211/brcmfmac/usb.c         |  23 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h  |   8 +
 include/linux/bcma/bcma_driver_chipcommon.h   |   1 +
 24 files changed, 1327 insertions(+), 270 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c

-- 
2.33.0

