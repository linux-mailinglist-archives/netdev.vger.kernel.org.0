Return-Path: <netdev+bounces-2964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7B2704B50
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4433228145F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82AA134CDB;
	Tue, 16 May 2023 11:01:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6082D34CD2
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:01:05 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE602685;
	Tue, 16 May 2023 04:01:02 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GAjIov031110;
	Tue, 16 May 2023 11:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=00njCaDgDgkN80yPXTEtlQkuK1jDrNQzbMXxzNRYFcM=;
 b=tBPEXVV/fuB0UyItyMNvk/5a1RKp64/F/5lJWLY1vOZ1jsxn3H3g1hsnyvEUTM165B6L
 0cYYB8QU0A0WmwhgWod6fZXNHUV/xZ5u0qdfi+BfWOu/1dlBeMNw/hgbBhSj/t0h8n0q
 M34+HZprm+Tet1JXvEavI4nebP+bnmIWC/1IxsVAkoLHFBgA99J+d6bicy6usOzilH/Z
 12/IK6NNHp+/coYhNcwGPkYm3gx4MpgPkqIrQKJjQP6N/OuFAP+SeWL7diGaHzqs7Q4r
 +vTspsal2lGAYt+m5fMO5wAgCpQehbIorsq4vm15E6D+9l8TqljhDI1hEDVXMnndLQ73 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8bn0dqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:00:43 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GAl79D005579;
	Tue, 16 May 2023 11:00:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qm8bn0dq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:00:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G7b9Xr031123;
	Tue, 16 May 2023 11:00:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qj1tdsjqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 May 2023 11:00:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GB0c9h28115492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 11:00:39 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9F6E2005A;
	Tue, 16 May 2023 11:00:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EB6520040;
	Tue, 16 May 2023 11:00:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 May 2023 11:00:38 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, Richard Cochran <richardcochran@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 00/41] treewide: Remove I/O port accessors for HAS_IOPORT=n
Date: Tue, 16 May 2023 12:59:56 +0200
Message-Id: <20230516110038.2413224-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cuWI-MKjah2_cb2Eay6rHS03FTe-Er8m
X-Proofpoint-ORIG-GUID: tUY-rLdjyPUBTdjYyPoTcw5ynLJ4748B
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_04,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Kernel Hackers,

Some platforms such as s390 do not support PCI I/O spaces. On such platforms
I/O space accessors like inb()/outb() are stubs that can never actually work.
The way these stubs are implemented in asm-generic/io.h leads to compiler
warnings because any use will be a NULL pointer access on these platforms. In
a previous patch we tried handling this with a run-time warning on access. This
approach however was rejected by Linus[0] with the argument that this really
should be a compile-time check and, though a much more invasive change, we
believe that is indeed the right approach.

This patch series does exactly that by utilizing the HAS_IOPORT Kconfig option
introduced in v6.4-rc1 via the spun out first patch[1] of a previous version. With
the final patch of this series HAS_IOPORT=n means that inb()/outb() and friends
are not defined. This is also the same approach originally planned by Uwe
Kleine-König as mentioned in commit ce816fa88cca ("Kconfig: rename HAS_IOPORT
to HAS_IOPORT_MAP"). With the HAS_IOPORT Kconfig option merged already
per-subsystem patches can now also be merged independently and only the last
patch needs to wait.

This series builds heavily on an original patch for demonstating the concept by
Arnd Bergmann[2] and incoporates feedback of previous versions [3][4][5].

This version is based on v6.4-rc2 and is also available on my kernel.org tree
in the has_ioport_v4:

https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git

Thanks,
Niklas Schnelle

Changes from v3:
- Rebased on v6.4-rc2 which includes the Kconfig HAS_IOPORT option
- Fixed some wrong #ifdef HAS_IOPORT to #ifdef CONFIG_HAS_IOPORT
- Split the usb subsystem patch into 3 parts (Arnd)
- Removed unneeded HAS_IOPORT dependency for SERIO_PARKBD (Geert Uytterhoeven)
- Removed no-op I/O access from FB_ATY (Ville Syrjälä)
- Simplified HAS_IOPORT dependencies for the sound subsystem (Takashi Iwai)
- Slightly reworded the subject line of the last patch which removes
  the I/O port accessor functions.

Changes from RFC v2:
- Rebased on v6.3-rc1
- Fixed a NULL pointer dereference in set_io_from_upio() due to accidentially
  expanded #ifdef CONFIG_SERIAL_8250_RT288X (kernel test robot)
- Dropped "ACPI: add dependency on HAS_IOPORT" (Bjorn Helgaas)
- Reworded commit message and moved ifdefs for "PCI/sysfs: Make I/O resource
  depend on HAS_IOPORT" (Bjorn Helgaas)
- Instead of complete removal inb() etc. are marked with __compiletime_error()
  when HAS_IOPORT is unset allowing for better error reporting (Ahmad Fatoum)
- Removed HAS_IOPORT dependency from PCMCIA as I/O port use is optional in at
  least PC Card. Instead added HAS_IOPORT on a per driver basis. (Bjorn
  Helgaas)
- Made uhci_has_pci_registers() constant 0 if HAS_IOPORT is not defined (Alan
  Stern)

Changes from RFC v1:
- Completely dropped the LEGACY_PCI option and replaced its dependencies with
  HAS_IOPORT as appropriate
- In the usb subsystem patch I incorporated the feedback from v1 by Alan Stern:
  - Used a local macro to nop in*()/out*() in the helpers
  - Removed an unnecessary further restriction on CONFIG_USB_UHCI_HCD
- Added a few more subsystems including wireless, ptp, and, mISDN that I had
  previously missed due to a blanket !S390.
- Removed blanket !S390 dependencies where they are added due to the I/O port
  problem
- In the sound system SND_OPL3_LIB needed to use "depends on" instead of
  "select" because of its added HAS_IOPORT dependency
- In the drm subsystem the bochs driver gets #ifdefs instead of a blanket
  dependency because its MMIO capable device variant should work without
  HAS_IOPORT.

[0] https://lore.kernel.org/lkml/CAHk-=wg80je=K7madF4e7WrRNp37e3qh6y10Svhdc7O8SZ_-8g@mail.gmail.com/
[1] https://lore.kernel.org/lkml/20230323163354.1454196-1-schnelle@linux.ibm.com/
[2] https://lore.kernel.org/lkml/CAK8P3a0MNbx-iuzW_-=0ab6-TTZzwV-PT_6gAC1Gp5PgYyHcrA@mail.gmail.com/
[3] https://yhbt.net/lore/all/20211227164317.4146918-1-schnelle@linux.ibm.com/
[4] https://lore.kernel.org/all/20220429135108.2781579-1-schnelle@linux.ibm.com/
[5] https://lore.kernel.org/lkml/20230314121216.413434-1-schnelle@linux.ibm.com/

Niklas Schnelle (41):
  kgdb: add HAS_IOPORT dependency
  ata: add HAS_IOPORT dependencies
  char: impi, tpm: depend on HAS_IOPORT
  comedi: add HAS_IOPORT dependencies
  counter: add HAS_IOPORT dependencies
  /dev/port: don't compile file operations without CONFIG_DEVPORT
  drm: handle HAS_IOPORT dependencies
  firmware: dmi-sysfs: handle HAS_IOPORT=n
  gpio: add HAS_IOPORT dependencies
  hwmon: add HAS_IOPORT dependencies
  i2c: add HAS_IOPORT dependencies
  iio: ad7606: Kconfig: add HAS_IOPORT dependencies
  Input: add HAS_IOPORT dependencies
  Input: gameport: add ISA and HAS_IOPORT dependencies
  leds: add HAS_IOPORT dependencies
  media: add HAS_IOPORT dependencies
  misc: add HAS_IOPORT dependencies
  mISDN: add HAS_IOPORT dependencies
  mpt fusion: add HAS_IOPORT dependencies
  net: handle HAS_IOPORT dependencies
  parport: PC style parport depends on HAS_IOPORT
  PCI: Make quirk using inw() depend on HAS_IOPORT
  PCI/sysfs: Make I/O resource depend on HAS_IOPORT
  pcmcia: add HAS_IOPORT dependencies
  platform: add HAS_IOPORT dependencies
  pnp: add HAS_IOPORT dependencies
  power: add HAS_IOPORT dependencies
  rtc: add HAS_IOPORT dependencies
  scsi: add HAS_IOPORT dependencies
  sound: add HAS_IOPORT dependencies
  speakup: add HAS_IOPORT dependency for SPEAKUP_SERIALIO
  staging: add HAS_IOPORT dependencies
  tty: serial: handle HAS_IOPORT dependencies
  usb: add HAS_IOPORT dependencies
  usb: uhci: handle HAS_IOPORT dependencies
  usb: pci-quirks: handle HAS_IOPORT dependencies
  fbdev: atyfb: Remove unused clock determination
  video: handle HAS_IOPORT dependencies
  watchdog: add HAS_IOPORT dependencies
  wireless: add HAS_IOPORT dependencies
  asm-generic/io.h: Remove I/O port accessors for HAS_IOPORT=n

 drivers/accessibility/speakup/Kconfig        |   1 +
 drivers/ata/Kconfig                          |  28 ++---
 drivers/ata/ata_generic.c                    |   2 +
 drivers/ata/libata-sff.c                     |   2 +
 drivers/char/Kconfig                         |   3 +-
 drivers/char/ipmi/Makefile                   |  11 +-
 drivers/char/ipmi/ipmi_si_intf.c             |   3 +-
 drivers/char/ipmi/ipmi_si_pci.c              |   3 +
 drivers/char/mem.c                           |   6 +-
 drivers/char/tpm/Kconfig                     |   1 +
 drivers/char/tpm/tpm_infineon.c              |  16 ++-
 drivers/char/tpm/tpm_tis_core.c              |  19 ++-
 drivers/comedi/Kconfig                       | 103 +++++++++------
 drivers/counter/Kconfig                      |   1 +
 drivers/firmware/dmi-sysfs.c                 |   4 +
 drivers/gpio/Kconfig                         |  26 ++--
 drivers/gpu/drm/qxl/Kconfig                  |   1 +
 drivers/gpu/drm/tiny/bochs.c                 |  17 +++
 drivers/gpu/drm/tiny/cirrus.c                |   2 +
 drivers/hwmon/Kconfig                        |  21 +++-
 drivers/i2c/busses/Kconfig                   |  31 ++---
 drivers/iio/adc/Kconfig                      |   2 +-
 drivers/input/gameport/Kconfig               |   4 +-
 drivers/input/serio/Kconfig                  |   1 +
 drivers/input/touchscreen/Kconfig            |   1 +
 drivers/isdn/Kconfig                         |   1 -
 drivers/isdn/hardware/mISDN/Kconfig          |  12 +-
 drivers/leds/Kconfig                         |   2 +-
 drivers/media/pci/dm1105/Kconfig             |   2 +-
 drivers/media/radio/Kconfig                  |  14 ++-
 drivers/media/rc/Kconfig                     |   6 +
 drivers/message/fusion/Kconfig               |   2 +-
 drivers/misc/altera-stapl/Makefile           |   3 +-
 drivers/misc/altera-stapl/altera.c           |   6 +-
 drivers/net/Kconfig                          |   2 +-
 drivers/net/arcnet/Kconfig                   |   2 +-
 drivers/net/can/cc770/Kconfig                |   1 +
 drivers/net/can/sja1000/Kconfig              |   1 +
 drivers/net/ethernet/3com/Kconfig            |   4 +-
 drivers/net/ethernet/8390/Kconfig            |   6 +-
 drivers/net/ethernet/amd/Kconfig             |   4 +-
 drivers/net/ethernet/fujitsu/Kconfig         |   2 +-
 drivers/net/ethernet/intel/Kconfig           |   2 +-
 drivers/net/ethernet/sis/Kconfig             |   4 +-
 drivers/net/ethernet/smsc/Kconfig            |   2 +-
 drivers/net/ethernet/ti/Kconfig              |   2 +-
 drivers/net/ethernet/via/Kconfig             |   1 +
 drivers/net/ethernet/xircom/Kconfig          |   2 +-
 drivers/net/fddi/defxx.c                     |   2 +-
 drivers/net/hamradio/Kconfig                 |   6 +-
 drivers/net/wan/Kconfig                      |   2 +-
 drivers/net/wireless/atmel/Kconfig           |   2 +-
 drivers/net/wireless/intersil/hostap/Kconfig |   2 +-
 drivers/parport/Kconfig                      |   3 +-
 drivers/pci/pci-sysfs.c                      |   4 +
 drivers/pci/quirks.c                         |   2 +
 drivers/pcmcia/Kconfig                       |   5 +-
 drivers/platform/chrome/Kconfig              |   1 +
 drivers/platform/chrome/wilco_ec/Kconfig     |   1 +
 drivers/pnp/isapnp/Kconfig                   |   2 +-
 drivers/power/reset/Kconfig                  |   1 +
 drivers/rtc/Kconfig                          |   4 +-
 drivers/scsi/Kconfig                         |  25 ++--
 drivers/scsi/aic7xxx/Kconfig.aic79xx         |   2 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx         |   2 +-
 drivers/scsi/aic94xx/Kconfig                 |   2 +-
 drivers/scsi/megaraid/Kconfig.megaraid       |   6 +-
 drivers/scsi/mvsas/Kconfig                   |   2 +-
 drivers/scsi/pcmcia/Kconfig                  |   6 +-
 drivers/scsi/qla2xxx/Kconfig                 |   2 +-
 drivers/staging/sm750fb/Kconfig              |   2 +-
 drivers/staging/vt6655/Kconfig               |   2 +-
 drivers/tty/Kconfig                          |   4 +-
 drivers/tty/serial/8250/8250_early.c         |   4 +
 drivers/tty/serial/8250/8250_pci.c           |  14 +++
 drivers/tty/serial/8250/8250_port.c          |  44 +++++--
 drivers/tty/serial/8250/Kconfig              |   5 +-
 drivers/tty/serial/Kconfig                   |   2 +-
 drivers/usb/Kconfig                          |  10 ++
 drivers/usb/core/hcd-pci.c                   |   2 +
 drivers/usb/host/Kconfig                     |   4 +-
 drivers/usb/host/pci-quirks.c                | 125 ++++++++++---------
 drivers/usb/host/pci-quirks.h                |  30 +++--
 drivers/usb/host/uhci-hcd.c                  |   2 +-
 drivers/usb/host/uhci-hcd.h                  |  36 ++++--
 drivers/video/console/Kconfig                |   1 +
 drivers/video/fbdev/Kconfig                  |  21 ++--
 drivers/video/fbdev/aty/atyfb_base.c         |   5 -
 drivers/watchdog/Kconfig                     |   6 +-
 include/asm-generic/io.h                     |  60 +++++++++
 include/linux/gameport.h                     |   9 +-
 include/linux/libata.h                       |   2 +
 include/linux/parport.h                      |   2 +-
 include/video/vga.h                          |   8 ++
 lib/Kconfig.kgdb                             |   1 +
 net/ax25/Kconfig                             |   2 +-
 sound/drivers/Kconfig                        |   3 +
 sound/isa/Kconfig                            |   1 +
 sound/pci/Kconfig                            |  45 +++++--
 sound/pcmcia/Kconfig                         |   1 +
 100 files changed, 631 insertions(+), 298 deletions(-)


base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
-- 
2.39.2


