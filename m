Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E42378292
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhEJKgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhEJKca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 06:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8B7061864;
        Mon, 10 May 2021 10:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620642444;
        bh=ecNT6Qkny310TF2Gc5f4rT75sPCp5MHYtIZGEKTj06Y=;
        h=From:To:Cc:Subject:Date:From;
        b=UcevxFcEh3Li+i6O96esjAQwtO4uSF7OkmnaXbUGuKrV8uvn5D3YHrYAkQ2/PUQ+H
         W9TvnHIXs+6PuDeS1sySVDl5b+kZJLJNiKWzOaT28OTrcYXd41BcTT/W/xmDMiDYJc
         NXMcl5dkZF+skL/ecPvA5wTdK4o4x+GnunjH/NmxR/yJu8E4pznFJs+xWcx2gEwfA4
         XCBkfBQ0zIGZl9DOMzQHk7sBS5W6Hlu9kth9XR129w1/oLPDA2JZ/64ZgwSblnTghd
         iot0AnPlhuAm6nY73Msiw7+8VeDC0SCv/fIeb4QX1qF678zB0I6rD9S2HSN+p78ETw
         VllHul+Znpi9A==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lg38C-000UOL-8L; Mon, 10 May 2021 12:27:20 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
Date:   Mon, 10 May 2021 12:26:12 +0200
Message-Id: <cover.1620641727.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several UTF-8 characters at the Kernel's documentation.

Several of them were due to the process of converting files from
DocBook, LaTeX, HTML and Markdown. They were probably introduced
by the conversion tools used on that time.

Other UTF-8 characters were added along the time, but they're easily
replaceable by ASCII chars.

As Linux developers are all around the globe, and not everybody has UTF-8
as their default charset, better to use UTF-8 only on cases where it is really
needed.

The first 3 patches on this series were manually written, in order to solve
a few special cases.

The remaining patches on series address such cases on *.rst files and 
inside the Documentation/ABI, using this perl map table in order to do the
charset conversion:

my %char_map = (
	0x2010 => '-',		# HYPHEN
	0xad   => '-',		# SOFT HYPHEN
	0x2013 => '-',		# EN DASH
	0x2014 => '-',		# EM DASH

	0x2018 => "'",		# LEFT SINGLE QUOTATION MARK
	0x2019 => "'",		# RIGHT SINGLE QUOTATION MARK
	0xb4   => "'",		# ACUTE ACCENT

	0x201c => '"',		# LEFT DOUBLE QUOTATION MARK
	0x201d => '"',		# RIGHT DOUBLE QUOTATION MARK

	0x2212 => '-',		# MINUS SIGN
	0x2217 => '*',		# ASTERISK OPERATOR
	0xd7   => 'x',		# MULTIPLICATION SIGN

	0xbb   => '>',		# RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK

	0xa0   => ' ',		# NO-BREAK SPACE
	0xfeff => '',		# ZERO WIDTH NO-BREAK SPACE
);

After the conversion, those UTF-8 chars will be kept:

	- U+00a9 ('©'): COPYRIGHT SIGN
	- U+00ac ('¬'): NOT SIGN		# only at Documentation/powerpc/transactional_memory.rst
	- U+00ae ('®'): REGISTERED SIGN
	- U+00b0 ('°'): DEGREE SIGN
	- U+00b1 ('±'): PLUS-MINUS SIGN
	- U+00b2 ('²'): SUPERSCRIPT TWO
	- U+00b5 ('µ'): MICRO SIGN
	- U+00b7 ('·'): MIDDLE DOT		# See below
	- U+00bd ('½'): VULGAR FRACTION ONE HALF
	- U+00c7 ('Ç'): LATIN CAPITAL LETTER C WITH CEDILLA
	- U+00df ('ß'): LATIN SMALL LETTER SHARP S
	- U+00e1 ('á'): LATIN SMALL LETTER A WITH ACUTE
	- U+00e4 ('ä'): LATIN SMALL LETTER A WITH DIAERESIS
	- U+00e6 ('æ'): LATIN SMALL LETTER AE
	- U+00e7 ('ç'): LATIN SMALL LETTER C WITH CEDILLA
	- U+00e9 ('é'): LATIN SMALL LETTER E WITH ACUTE
	- U+00ea ('ê'): LATIN SMALL LETTER E WITH CIRCUMFLEX
	- U+00eb ('ë'): LATIN SMALL LETTER E WITH DIAERESIS
	- U+00f3 ('ó'): LATIN SMALL LETTER O WITH ACUTE
	- U+00f4 ('ô'): LATIN SMALL LETTER O WITH CIRCUMFLEX
	- U+00f6 ('ö'): LATIN SMALL LETTER O WITH DIAERESIS
	- U+00f8 ('ø'): LATIN SMALL LETTER O WITH STROKE
	- U+00fa ('ú'): LATIN SMALL LETTER U WITH ACUTE
	- U+00fc ('ü'): LATIN SMALL LETTER U WITH DIAERESIS
	- U+00fd ('ý'): LATIN SMALL LETTER Y WITH ACUTE
	- U+011f ('ğ'): LATIN SMALL LETTER G WITH BREVE
	- U+0142 ('ł'): LATIN SMALL LETTER L WITH STROKE
	- U+03bc ('μ'): GREEK SMALL LETTER MU
	- U+2026 ('…'): HORIZONTAL ELLIPSIS
	- U+2122 ('™'): TRADE MARK SIGN
	- U+2191 ('↑'): UPWARDS ARROW
	- U+2192 ('→'): RIGHTWARDS ARROW
	- U+2193 ('↓'): DOWNWARDS ARROW
	- U+2264 ('≤'): LESS-THAN OR EQUAL TO
	- U+2265 ('≥'): GREATER-THAN OR EQUAL TO
	- U+2500 ('─'): BOX DRAWINGS LIGHT HORIZONTAL
	- U+2502 ('│'): BOX DRAWINGS LIGHT VERTICAL
	- U+2514 ('└'): BOX DRAWINGS LIGHT UP AND RIGHT
	- U+251c ('├'): BOX DRAWINGS LIGHT VERTICAL AND RIGHT
	- U+2b0d ('⬍'): UP DOWN BLACK ARROW

PS.: maintainers were bcc on patch 00/53, in order to reduce the
risk of patch 00 to be rejected by list servers.

-

For U+00b7 ('·'): MIDDLE DOT, I opted to keep it on a few places:

- Documentation/devicetree/bindings/clock/qcom,rpmcc.txt

  As this file will be some day converted to yaml, where the 
  MIDDLE DOT will be removed, I guess it is not worth touching it.

- Documentation/scheduler/sched-deadline.rst

  There, it is used on a math expressions. So, better to keep.

- Documentation/devicetree/bindings/media/video-interface-devices.yaml

  There, it part of an ASCII artwork.

- translations/zh_CN

  I prefer not touching it, as it might have some special meaning in Simplified Chinese.

Mauro Carvalho Chehab (53):
  docs: cdrom-standard.rst: get rid of uneeded UTF-8 chars
  docs: ABI: remove a meaningless UTF-8 character
  docs: ABI: remove some spurious characters
  docs: index.rst: avoid using UTF-8 chars
  docs: hwmon: avoid using UTF-8 chars
  docs: admin-guide: avoid using UTF-8 chars
  docs: admin-guide: media: ipu3.rst: avoid using UTF-8 chars
  docs: admin-guide: sysctl: kernel.rst: avoid using UTF-8 chars
  docs: admin-guide: perf: imx-ddr.rst: avoid using UTF-8 chars
  docs: admin-guide: pm: avoid using UTF-8 chars
  docs: trace: coresight: coresight-etm4x-reference.rst: avoid using
    UTF-8 chars
  docs: driver-api: avoid using UTF-8 chars
  docs: driver-api: fpga: avoid using UTF-8 chars
  docs: driver-api: iio: avoid using UTF-8 chars
  docs: driver-api: thermal: avoid using UTF-8 chars
  docs: driver-api: media: drivers: avoid using UTF-8 chars
  docs: driver-api: firmware: other_interfaces.rst: avoid using UTF-8
    chars
  docs: driver-api: nvdimm: btt.rst: avoid using UTF-8 chars
  docs: fault-injection: nvme-fault-injection.rst: avoid using UTF-8
    chars
  docs: usb: avoid using UTF-8 chars
  docs: process: avoid using UTF-8 chars
  docs: block: data-integrity.rst: avoid using UTF-8 chars
  docs: userspace-api: media: fdl-appendix.rst: avoid using UTF-8 chars
  docs: userspace-api: media: v4l: avoid using UTF-8 chars
  docs: userspace-api: media: dvb: avoid using UTF-8 chars
  docs: vm: zswap.rst: avoid using UTF-8 chars
  docs: filesystems: f2fs.rst: avoid using UTF-8 chars
  docs: filesystems: ext4: avoid using UTF-8 chars
  docs: kernel-hacking: avoid using UTF-8 chars
  docs: hid: avoid using UTF-8 chars
  docs: security: tpm: avoid using UTF-8 chars
  docs: security: keys: trusted-encrypted.rst: avoid using UTF-8 chars
  docs: riscv: vm-layout.rst: avoid using UTF-8 chars
  docs: networking: scaling.rst: avoid using UTF-8 chars
  docs: networking: devlink: devlink-dpipe.rst: avoid using UTF-8 chars
  docs: networking: device_drivers: avoid using UTF-8 chars
  docs: x86: avoid using UTF-8 chars
  docs: scheduler: sched-deadline.rst: avoid using UTF-8 chars
  docs: dev-tools: testing-overview.rst: avoid using UTF-8 chars
  docs: power: powercap: powercap.rst: avoid using UTF-8 chars
  docs: ABI: avoid using UTF-8 chars
  docs: doc-guide: contributing.rst: avoid using UTF-8 chars
  docs: PCI: acpi-info.rst: avoid using UTF-8 chars
  docs: gpu: avoid using UTF-8 chars
  docs: sound: kernel-api: writing-an-alsa-driver.rst: avoid using UTF-8
    chars
  docs: arm64: arm-acpi.rst: avoid using UTF-8 chars
  docs: infiniband: tag_matching.rst: avoid using UTF-8 chars
  docs: timers: no_hz.rst: avoid using UTF-8 chars
  docs: misc-devices: ibmvmc.rst: avoid using UTF-8 chars
  docs: firmware-guide: acpi: lpit.rst: avoid using UTF-8 chars
  docs: firmware-guide: acpi: dsd: graph.rst: avoid using UTF-8 chars
  docs: virt: kvm: avoid using UTF-8 chars
  docs: RCU: avoid using UTF-8 chars

 .../obsolete/sysfs-kernel-fadump_registered   |   2 +-
 .../obsolete/sysfs-kernel-fadump_release_mem  |   2 +-
 ...sfs-class-chromeos-driver-cros-ec-lightbar |   2 +-
 .../ABI/testing/sysfs-class-net-cdc_ncm       |   2 +-
 .../ABI/testing/sysfs-devices-platform-ipmi   |   2 +-
 .../testing/sysfs-devices-platform-trackpoint |   2 +-
 Documentation/ABI/testing/sysfs-devices-soc   |   4 +-
 Documentation/ABI/testing/sysfs-module        |   4 +-
 Documentation/PCI/acpi-info.rst               |  26 +-
 .../Data-Structures/Data-Structures.rst       |  52 ++--
 .../Expedited-Grace-Periods.rst               |  40 +--
 .../Tree-RCU-Memory-Ordering.rst              |  10 +-
 .../RCU/Design/Requirements/Requirements.rst  | 126 ++++-----
 Documentation/admin-guide/index.rst           |   2 +-
 Documentation/admin-guide/media/ipu3.rst      |   2 +-
 Documentation/admin-guide/module-signing.rst  |   4 +-
 Documentation/admin-guide/perf/imx-ddr.rst    |   2 +-
 Documentation/admin-guide/pm/intel_idle.rst   |   4 +-
 Documentation/admin-guide/pm/intel_pstate.rst |   4 +-
 Documentation/admin-guide/ras.rst             |  94 +++----
 .../admin-guide/reporting-issues.rst          |  12 +-
 Documentation/admin-guide/sysctl/kernel.rst   |   2 +-
 Documentation/arm64/arm-acpi.rst              |   8 +-
 Documentation/block/data-integrity.rst        |   2 +-
 Documentation/cdrom/cdrom-standard.rst        |  30 +--
 Documentation/dev-tools/testing-overview.rst  |   4 +-
 Documentation/doc-guide/contributing.rst      |   2 +-
 .../driver-api/firmware/other_interfaces.rst  |   2 +-
 Documentation/driver-api/fpga/fpga-bridge.rst |  10 +-
 Documentation/driver-api/fpga/fpga-mgr.rst    |  12 +-
 .../driver-api/fpga/fpga-programming.rst      |   8 +-
 Documentation/driver-api/fpga/fpga-region.rst |  20 +-
 Documentation/driver-api/iio/buffers.rst      |   8 +-
 Documentation/driver-api/iio/hw-consumer.rst  |  10 +-
 .../driver-api/iio/triggered-buffers.rst      |   6 +-
 Documentation/driver-api/iio/triggers.rst     |  10 +-
 Documentation/driver-api/index.rst            |   2 +-
 Documentation/driver-api/ioctl.rst            |   8 +-
 .../media/drivers/sh_mobile_ceu_camera.rst    |   8 +-
 .../driver-api/media/drivers/vidtv.rst        |   4 +-
 .../driver-api/media/drivers/zoran.rst        |   2 +-
 Documentation/driver-api/nvdimm/btt.rst       |   2 +-
 .../driver-api/thermal/cpu-idle-cooling.rst   |  14 +-
 .../driver-api/thermal/intel_powerclamp.rst   |   6 +-
 .../thermal/x86_pkg_temperature_thermal.rst   |   2 +-
 .../fault-injection/nvme-fault-injection.rst  |   2 +-
 Documentation/filesystems/ext4/attributes.rst |  20 +-
 Documentation/filesystems/ext4/bigalloc.rst   |   6 +-
 Documentation/filesystems/ext4/blockgroup.rst |   8 +-
 Documentation/filesystems/ext4/blocks.rst     |   2 +-
 Documentation/filesystems/ext4/directory.rst  |  16 +-
 Documentation/filesystems/ext4/eainode.rst    |   2 +-
 Documentation/filesystems/ext4/inlinedata.rst |   6 +-
 Documentation/filesystems/ext4/inodes.rst     |   6 +-
 Documentation/filesystems/ext4/journal.rst    |   8 +-
 Documentation/filesystems/ext4/mmp.rst        |   2 +-
 .../filesystems/ext4/special_inodes.rst       |   4 +-
 Documentation/filesystems/ext4/super.rst      |  10 +-
 Documentation/filesystems/f2fs.rst            |   6 +-
 .../firmware-guide/acpi/dsd/graph.rst         |   2 +-
 Documentation/firmware-guide/acpi/lpit.rst    |   2 +-
 Documentation/gpu/i915.rst                    |   2 +-
 Documentation/gpu/komeda-kms.rst              |   2 +-
 Documentation/hid/hid-sensor.rst              |  70 ++---
 Documentation/hid/intel-ish-hid.rst           | 246 +++++++++---------
 Documentation/hwmon/ir36021.rst               |   2 +-
 Documentation/hwmon/ltc2992.rst               |   2 +-
 Documentation/hwmon/pm6764tr.rst              |   2 +-
 Documentation/hwmon/tmp103.rst                |   4 +-
 Documentation/index.rst                       |   4 +-
 Documentation/infiniband/tag_matching.rst     |   8 +-
 Documentation/kernel-hacking/hacking.rst      |   2 +-
 Documentation/kernel-hacking/locking.rst      |   2 +-
 Documentation/misc-devices/ibmvmc.rst         |   8 +-
 .../device_drivers/ethernet/intel/i40e.rst    |  12 +-
 .../device_drivers/ethernet/intel/iavf.rst    |   6 +-
 .../device_drivers/ethernet/netronome/nfp.rst |  12 +-
 .../networking/devlink/devlink-dpipe.rst      |   2 +-
 Documentation/networking/scaling.rst          |  18 +-
 Documentation/power/powercap/powercap.rst     | 210 +++++++--------
 Documentation/process/code-of-conduct.rst     |   2 +-
 .../process/kernel-enforcement-statement.rst  |   2 +-
 Documentation/riscv/vm-layout.rst             |   2 +-
 Documentation/scheduler/sched-deadline.rst    |   4 +-
 .../security/keys/trusted-encrypted.rst       |   4 +-
 Documentation/security/tpm/tpm_event_log.rst  |   2 +-
 Documentation/security/tpm/xen-tpmfront.rst   |   2 +-
 .../kernel-api/writing-an-alsa-driver.rst     |  68 ++---
 Documentation/timers/no_hz.rst                |   2 +-
 .../coresight/coresight-etm4x-reference.rst   |  16 +-
 Documentation/usb/ehci.rst                    |   2 +-
 Documentation/usb/gadget_printer.rst          |   2 +-
 Documentation/usb/mass-storage.rst            |  36 +--
 Documentation/usb/mtouchusb.rst               |   2 +-
 Documentation/usb/usb-serial.rst              |   2 +-
 .../media/dvb/audio-set-bypass-mode.rst       |   2 +-
 .../userspace-api/media/dvb/audio.rst         |   2 +-
 .../userspace-api/media/dvb/dmx-fopen.rst     |   2 +-
 .../userspace-api/media/dvb/dmx-fread.rst     |   2 +-
 .../media/dvb/dmx-set-filter.rst              |   2 +-
 .../userspace-api/media/dvb/intro.rst         |   6 +-
 .../userspace-api/media/dvb/video.rst         |   2 +-
 .../userspace-api/media/fdl-appendix.rst      |  64 ++---
 .../userspace-api/media/v4l/biblio.rst        |   8 +-
 .../userspace-api/media/v4l/crop.rst          |  16 +-
 .../userspace-api/media/v4l/dev-decoder.rst   |   6 +-
 .../userspace-api/media/v4l/diff-v4l.rst      |   2 +-
 .../userspace-api/media/v4l/open.rst          |   2 +-
 .../media/v4l/vidioc-cropcap.rst              |   4 +-
 Documentation/virt/kvm/api.rst                |  28 +-
 .../virt/kvm/running-nested-guests.rst        |  12 +-
 Documentation/vm/zswap.rst                    |   4 +-
 Documentation/x86/resctrl.rst                 |   2 +-
 Documentation/x86/sgx.rst                     |   4 +-
 114 files changed, 807 insertions(+), 807 deletions(-)

-- 
2.30.2


