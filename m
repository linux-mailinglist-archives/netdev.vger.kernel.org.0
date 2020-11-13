Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315B52B1FFF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKMQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:21:42 -0500
Received: from mga18.intel.com ([134.134.136.126]:45997 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMQVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:21:42 -0500
IronPort-SDR: JjmkOLnFmyim+RnkcYlMXSq/uY+0Y+Vz+GO9ZHrIWa3Ut61BA2N1FWW+Y+CswkF1pesXu9Mh0C
 LMfPjRQVuwcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="158272283"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="158272283"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:40 -0800
IronPort-SDR: 23c+MHLhpS2oIlsLPTVs8J5RvjH7fuuaUslEHlSUJB3RPnvQWw9X8tfihZ6w0iz8zWMy4fmCyE
 P4SvaBs5oqyQ==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="366767218"
Received: from dmert-dev.jf.intel.com ([10.166.241.5])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:21:39 -0800
From:   Dave Ertman <david.m.ertman@intel.com>
To:     alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org, linux-rdma@vger.kernel.org,
        jgg@nvidia.com, dledford@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com,
        linux-kernel@vger.kernel.org, leonro@nvidia.com
Subject: [PATCH v4 00/10] Auxiliary bus implementation and SOF multi-client support
Date:   Fri, 13 Nov 2020 08:18:49 -0800
Message-Id: <20201113161859.1775473-1-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brief history of Auxiliary Bus
==============================
The auxiliary bus code was originally submitted upstream as virtual
bus, and was submitted through the netdev tree.  This process generated
up to v4.  This discussion can be found here:
https://lore.kernel.org/netdev/20191111192219.30259-1-jeffrey.t.kirsher@intel.com/#t

At this point, GregKH requested that we take the review and revision
process to an internal mailing list and garner the buy-in of a respected
kernel contributor.

The auxiliary bus (then known as virtual bus) was originally submitted
along with implementation code for the ice driver and irdma drive,
causing the complication of also having dependencies in the rdma tree.
This new submission is utilizing an auxiliary bus consumer in only the
sound driver tree to create the initial implementation and a single
user.

Since implementation work has started on this patch set, there have been
multiple inquiries about the time frame of its completion.  It appears
that there will be numerous consumers of this functionality.

The process of internal review and implementation using the sound
drivers generated 19 internal versions.  The changes, including the name
change from virtual bus to auxiliary bus, from these versions can be
summarized as the following:

- Fixed compilation and checkpatch errors
- Improved documentation to address the motivation for virtual bus.
- Renamed virtual bus to auxiliary bus
- increased maximum device name size
- Correct order in Kconfig and Makefile
- removed the mid-layer adev->release layer for device unregister
- pushed adev->id management to parent driver
- all error paths out of ancillary_device_register return error code
- all error paths out of ancillary_device_register use put_device
- added adev->name element
- modname in register cannot be NULL
- added KBUILD_MODNAME as prefix for match_name
- push adev->id responsibility to registering driver
- uevent now parses adev->dev name
- match_id function now parses adev->dev name
- changed drivers probe function to also take an ancillary_device_id
  param
- split ancillary_device_register into device_initialize and device_add
- adjusted what is done in device_initialize and device_add
- change adev to ancildev and adrv to ancildrv
- change adev to ancildev in documentation

==========================

Introduces the auxiliary bus implementation along with the example usage
in the Sound Open Firmware(SOF) audio driver.

In some subsystems, the functionality of the core device
(PCI/ACPI/other) may be too complex for a single device to be managed as
a monolithic block or a part of the functionality might need to be
exposed to a different subsystem.  Splitting the functionality into
smaller orthogonal devices makes it easier to manage data, power
management and domain-specific communication with the hardware.  Also,
common auxiliary_device functionality across primary devices can be
handled by a common auxiliary_device. A key requirement for such a split
is that there is no dependency on a physical bus, device, register
accesses or regmap support. These individual devices split from the core
cannot live on the platform bus as they are not physical devices that
are controlled by DT/ACPI. The same argument applies for not using MFD
in this scenario as it relies on individual function devices being
physical devices that are DT enumerated.

An example for this kind of requirement is the audio subsystem where a
single IP handles multiple entities such as HDMI, Soundwire, local
devices such as mics/speakers etc. The split for the core's
functionality can be arbitrary or be defined by the DSP firmware
topology and include hooks for test/debug. This allows for the audio
core device to be minimal and tightly coupled with handling the
hardware-specific logic and communication.

The auxiliary bus is intended to be minimal, generic and avoid
domain-specific assumptions. Each auxiliary bus device represents a part
of its parent functionality. The generic behavior can be extended and
specialized as needed by encapsulating an auxiliary bus device within
other domain-specific structures and the use of .ops callbacks.

The SOF driver adopts the auxiliary bus for implementing the
multi-client support. A client in the context of the SOF driver
represents a part of the core device's functionality. It is not a
physical device but rather an auxiliary device that needs to communicate
with the DSP via IPCs. With multi-client support,the sound card can be
separated into multiple orthogonal auxiliary devices for local devices
(mic/speakers etc), HDMI, sensing, probes, debug etc.  In this series,
we demonstrate the usage of the auxiliary bus with the help of the IPC
test client which is used for testing the serialization of IPCs when
multiple clients talk to the DSP at the same time.

v4 changes:
clean up passive voice
clarify reg/unreg path for devices
explicitly call out GPL v2

v3 changes:
rename to auxiliary bus
move .c file to drivers/base/
split auxdev unregister flow into uninitialize and delete steps
update kernel-doc on register functions for new unregister model
update documentation with new name and unregister flow
remove check for release in auxiliary bus, allow core to catch
Change driver register so only probe and id_table mandatory
Fix matching logic in auxillary_match_id to account for longer id->name
utilize auxiliary_bus callbacks for probe, remove and shutdown
add auxiliary_find_device function
add code to ensure unique auxdrv name
shorten initialize/uninitialize in function names to init/uninit
simplify looping logic in match_id
in drives/base/Kconfig changed from tristate to bool
Modified signature SOF client register/unregister API
Modified PM runtime enabling sequence in the SOF ipc test aux driver
Removed driver.name from the aux driver
Added Probes client aux driver and device registration in the
        SOF driver. This allows for enabling the probes functionality in
the SOF
        firmware for audio data extraction from specific points in the
audio
        pipeline. Without auxiliary bus, the implementation requires
modifying
        existing 15+ machine drivers to add the probes DAI links to the
sounds
        cards. Using the auxiliary bus allows for splitting the probes
        implementation from the SOF core making it easy to maintain.

v2 changes:
defined pr_fmt for kernel messages
replaced WARN_ON calls in registration with pr_err calls
adding kernel-doc function comments for device_initialize and device_add
fix typo in documentation
removed inaccurate line in documentation
fixed formatting in drivers/bus/Makefile
changed unwind path for sof_client_dev_alloc()
improved comments for client list and mem freeing during client unreg
removed debugfs entries in sof_ipc_test_client_drv during remove
changed the signature of sof_debug_ipc_flood_test()
fix a looping error in ancillary_match_id
updated error value in sof_client_dev_register()
mutex held while traversing client list when unregistering clients
updated includes in sof-client.h

Dave Ertman (1):
  Add auxiliary bus support

Ranjani Sridharan (9):
  ASoC: SOF: Introduce descriptors for SOF client
  ASoC: SOF: Create client driver for IPC test
  ASoC: SOF: ops: Add ops for client registration
  ASoC: SOF: Intel: Define ops for client registration
  ASoC: SOF: Intel: Remove IPC flood test support in SOF core
  ASoC: SOF: sof-client: Add client APIs to access probes ops
  ASoC: SOF: compress: move and export sof_probe_compr_ops
  ASoC: SOF: Add new client driver for probes support
  ASoC: SOF: Intel: CNL: register probes client

 Documentation/driver-api/auxiliary_bus.rst | 234 +++++++++++
 Documentation/driver-api/index.rst         |   1 +
 drivers/base/Kconfig                       |   3 +
 drivers/base/Makefile                      |   1 +
 drivers/base/auxiliary.c                   | 268 ++++++++++++
 include/linux/auxiliary_bus.h              |  78 ++++
 include/linux/mod_devicetable.h            |   8 +
 scripts/mod/devicetable-offsets.c          |   3 +
 scripts/mod/file2alias.c                   |   8 +
 sound/soc/sof/Kconfig                      |  47 ++-
 sound/soc/sof/Makefile                     |  10 +-
 sound/soc/sof/compress.c                   |  60 +--
 sound/soc/sof/compress.h                   |   1 +
 sound/soc/sof/core.c                       |  18 +-
 sound/soc/sof/debug.c                      | 457 ---------------------
 sound/soc/sof/intel/Kconfig                |   9 +
 sound/soc/sof/intel/Makefile               |   3 +
 sound/soc/sof/intel/apl.c                  |  16 +
 sound/soc/sof/intel/bdw.c                  |  16 +
 sound/soc/sof/intel/byt.c                  |  20 +
 sound/soc/sof/intel/cnl.c                  |  32 ++
 sound/soc/sof/intel/hda-dai.c              |  27 --
 sound/soc/sof/intel/hda.h                  |   6 -
 sound/soc/sof/intel/intel-client.c         |  40 ++
 sound/soc/sof/intel/intel-client.h         |  26 ++
 sound/soc/sof/ops.h                        |  14 +
 sound/soc/sof/pcm.c                        |  11 -
 sound/soc/sof/probe.c                      | 124 +++---
 sound/soc/sof/probe.h                      |  41 +-
 sound/soc/sof/sof-client.c                 | 170 ++++++++
 sound/soc/sof/sof-client.h                 |  91 ++++
 sound/soc/sof/sof-ipc-test-client.c        | 321 +++++++++++++++
 sound/soc/sof/sof-priv.h                   |  23 +-
 sound/soc/sof/sof-probes-client.c          | 414 +++++++++++++++++++
 34 files changed, 1975 insertions(+), 626 deletions(-)
 create mode 100644 Documentation/driver-api/auxiliary_bus.rst
 create mode 100644 drivers/base/auxiliary.c
 create mode 100644 include/linux/auxiliary_bus.h
 create mode 100644 sound/soc/sof/intel/intel-client.c
 create mode 100644 sound/soc/sof/intel/intel-client.h
 create mode 100644 sound/soc/sof/sof-client.c
 create mode 100644 sound/soc/sof/sof-client.h
 create mode 100644 sound/soc/sof/sof-ipc-test-client.c
 create mode 100644 sound/soc/sof/sof-probes-client.c

-- 
2.26.2

